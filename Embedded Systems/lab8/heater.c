#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <string.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

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

#define TR      PB5
#define TR_DDR  DDRB
#define TR_PORT PORTB

void heater_on(){TR_PORT |= _BV(TR);}
void heater_off(){TR_PORT &= ~_BV(TR);}

volatile float T       = 0.0f;
volatile float targetT = 31.0f;

ISR(ADC_vect) {
    uint16_t v = ADC;
    float Vin = ((float)v * 1.1f) / 1024.0f;
    // Tcoff * T + V0C = Vin
    T = (Vin - V0C) / Tcoff;
    if(T >= targetT)
        heater_off();
    else if((targetT - T) >= Th)
        heater_on();
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
