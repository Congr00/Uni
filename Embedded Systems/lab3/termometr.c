#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <util/delay.h>
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

#define CTR_DDR   DDRC
#define CTR_PORT  PORTC
#define CTR       PC0

void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  = _BV(ADPS1) | _BV(ADPS0); // preskaler 8
  ADCSRA |= _BV(ADEN); // włącz ADC
}

FILE uart_file;

#define e 2.72
// B = ln(R0/R1) / (1/T0 - 1/T1)
#define B 6543.83

// input is 5V
#define Vref 5
// resistor 
#define R    220

// temp 22C
#define T0 295.15
// resistance at 22C
#define R0 4900
// temp 12C
#define T1 285.15
// resistance at 12C
#define R1 9166



int main(){
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    CTR_DDR  &= ~_BV(CTR); // set to input
    CTR_PORT &= ~_BV(CTR); // turn off pull up resistor
  
    adc_init();
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
 
    while(1){           
        ADCSRA |= _BV(ADSC); // wykonaj konwersję        
        while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
        ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)    
        uint16_t v = ADC; // weź zmierzoną wartość (0..1023)
        // ADC = Vin * 1024 / Vref => Vin = ADC*Vref/1024        
        float Vout = ((float)v * Vref) / 1024.0;
        // Vout = Vin * R/(RT+ R)
        // RT = R*(Vin - Vout) / Vout
        // RT - termistor resistance
        float RT = R * (Vref - Vout) / Vout;
        //calculate temperature using Beta
        float r = R0 * pow(e, (-B / T0));
        float tempK = B / (log(RT / r));
        float tempC = tempK - 273.15;
        printf("ADC : %"SCNd16", RT : %f, tempC : %f, Vout: %f\r\n", v, RT, tempC, Vout);           
        _delay_ms(1000);
    }    
}