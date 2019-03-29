#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <string.h>

#include "IAR/pid.h"

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

#pragma region UART
// inicjalizacja UART
void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
  // włącz odbiornik i nadajnik
  UCSR0B = _BV(RXEN0) | _BV(TXEN0);
  // ustaw format 8n1
  UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);
}

// transmisja jednego znaku
int uart_transmit(char data, FILE *stream)
{
  // czekaj aż transmiter gotowy
  while(!(UCSR0A & _BV(UDRE0)));
  UDR0 = data;
  return 0;
}

// odczyt jednego znaku
int uart_receive(FILE *stream)
{
  // czekaj aż znak dostępny
  while (!(UCSR0A & _BV(RXC0)));
  return UDR0;
}

// inicjalizacja ADC
void adc_init()
{
  ADMUX   |= _BV(REFS0) | _BV(REFS1); // referencja Vref 1.1V
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  =  _BV(ADPS1) | _BV(ADPS0) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN) | _BV(ADIE) | _BV(ADATE); // włącz ADC przerwania i autotrigger
  sei();
}

FILE uart_file;

#define Tcoff (0.01f) //10mV/C
#define V0C   (0.5f ) //500mV
#define Th    (0.5f)  //0.5C histeres constant

#define TVcc    OCR1A 

#define TR      PB5
#define TR_DDR  DDRB
#define TR_PORT PORTB


void heater_on(){TR_PORT |= _BV(TR);}
void heater_off(){TR_PORT &= ~_BV(TR);}

#define K_P     1.00
#define K_I     0.00
#define K_D     0.00

/*! \brief Flags for status information
 */
struct GLOBAL_FLAGS {
  //! True when PID control loop should run one time
  uint8_t pidTimer:1;
  uint8_t dummy:7;
} gFlags = {0, 0};

//! Parameters for regulator
struct PID_DATA pidData;


volatile float T       = 0.0f;
volatile float targetT = 31.0f;


int16_t Get_Reference(void)
{
  return targetT;
}

/*! \brief Read system process value
 *
 * This function must return the measured data
 */
int16_t Get_Measurement(void)
{
  return T;
}

/*! \brief Set control input to system
 *
 * Set the output from the controller as input
 * to system.
 */
void Set_Input(int16_t inputValue)
{
    TVcc = inputValue;
}

/*! \brief Sampling Time Interval
 *
 * Specify the desired PID sample time interval
 * With a 8-bit counter (255 cylces to overflow), the time interval value is calculated as follows:
 * TIME_INTERVAL = ( desired interval [sec] ) * ( frequency [Hz] ) / 255
 */

#define TIME_INTERVAL   157

ISR(TIMER0_OVF_vect){
  static uint16_t i = 0;
  if(i < TIME_INTERVAL)
    i++;
  else{
    gFlags.pidTimer = TRUE;
    // Run PID calculations once every PID timer timeout
    if(gFlags.pidTimer)
    {
      int16_t referenceValue, measurementValue, inputValue;        
      referenceValue = Get_Reference();
      measurementValue = Get_Measurement();

      inputValue = pid_Controller(referenceValue, measurementValue, &pidData);

      Set_Input(inputValue);

      gFlags.pidTimer = FALSE;
    }    
    i = 0;
  }
}

void timer1_init()
{
  // COM1A = 110  -- non-inverting mode
  // WGM1  = 1110 -- fast PWM top=ICR1
  // CS1   = 010  -- prescaler 8
  // top   = 1999
  // freq  = 16e6/(8*(1+1999)) = 1kHz

  ICR1 = 1999;

  TCCR1A = _BV(COM1A1) | _BV(WGM11);
  TCCR1B = _BV(WGM12) | _BV(CS11) | _BV(WGM13);
  
  // set OC2 pin (PB3) as exit
  DDRB |= _BV(PB1);
  OCR1A = 1;

}


void PIDT_init(void)
{
  pid_Init(K_P * SCALING_FACTOR, K_I * SCALING_FACTOR , K_D * SCALING_FACTOR , &pidData);

  // Set up timer, enable timer/counte 0 overflow interrupt
  TCCR0A = (1<<CS00);
  TIMSK0 = (1<<TOIE0);
  TCNT0 = 0;
}

ISR(ADC_vect) {
    uint16_t v = ADC;
    float Vin = ((float)v * 1.1f) / 1024.0f;
    // Tcoff * T + V0C = Vin
    T = (Vin - V0C) / Tcoff;
}

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  adc_init();

  TR_DDR |= _BV(TR); // transistor pin control to output
  ADCSRA |= _BV(ADSC); // start adc conversion

  heater_off();

  while(1) {
      char in[32];
      scanf("%s", in);

      if(strcmp(in, "g") == 0)
        printf("Temp: %"SCNd16" Target: %"SCNd16"\r\n", (int16_t)T, (int16_t)(targetT-1.0));
      else if(strcmp(in, "s") == 0){
        int16_t temp = 0;
        scanf(" %02"SCNd16"", &temp);
        cli();        
        targetT = (float)(temp+1);
        printf("target temp set to: %"SCNd16"\r\n", (int16_t)(targetT-1.0));
        sei();
      }
      else
        printf("unknown command '%s'\r\n", in);
      sei();
  }
}
