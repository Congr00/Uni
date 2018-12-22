#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <string.h>
#include <avr/sleep.h>
#include <math.h>

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

#define e    (2.72f)    // const e
#define B    (6543.83f) // B = ln(R0/R1) / (1/T0 - 1/T1)
#define Vref (1.1f)     // Vref is 1.1V
#define R    (220.0f)   // resistor 
#define T0    (296.15f)
#define R0   (4900.0f)    // resistance at 22C
#define T1   (285.15f)  // temp 12C
#define R1   (9166.0f)  // resistance at 12C
#define I    (130*10e-7)      // 1
 
volatile uint16_t c = 0;

ISR(ADC_vect) {
    if((c++) % 1024 == 0){    
        uint16_t v = ADC;
        float Vin = ((float)v * 1.1f) / 1024.0f;
        // get RT - termistor resistance
     /*   float r0 = Vin / (pow(e, (-B * ((1.0/T0)- (1.0/296.15)))));
        r0 *= I;
        float tempK = B*T0 / (log(Vin/r0)*T0 + B);
        float tempC = tempK - 273.15;
*/
        float RT = Vin / I;
        //calculate temperature using Beta
        float r = R0 * pow(e, (-B / T0));
        //float tempK = B / (log(RT / r));
        //float tempC = tempK - 273.15;
        float tempK = B*T0 / (log(RT/R0)*T0 + B);
        float tempC = tempK - 273.15;        


        printf("| adc: %"SCNd16" | Vin: %f | R: %f | temp: %"SCNd16" |\r\n\r\n", v, Vin, RT, (int16_t)tempC);
    }
}

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  adc_init();
  ADCSRA |= _BV(ADSC); // start adc conversion
  
  set_sleep_mode(SLEEP_MODE_ADC);

  while(1) {
      sleep_mode();
  }
}
