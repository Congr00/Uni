#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <util/delay.h>
#include <math.h>
#include <avr/interrupt.h>

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


FILE uart_file;

#define CTR_DDR   DDRC
#define CTR_PORT  PORTC
#define CTR       PC0

#define BTN       PD2
#define BTN_PIN   PIND
#define BTN_PORT  PORTD

// input is 5V
#define Vref 5
// resistor 
#define R    220

volatile static uint16_t v = 0;

void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  = _BV(ADPS2) | _BV(ADPS1) | _BV(ADPS0); // preskaler 128
  ADCSRA |= _BV(ADEN) | _BV(ADIF) | _BV(ADIE); // włącz ADC i przerwania
}

void io_init()
{
  CTR_DDR  &= ~_BV(CTR); // set to input
  CTR_PORT &= ~_BV(CTR); // turn off pull up resistor
  BTN_PORT |= _BV(BTN); // turn on pull up resistor for button

  // ustaw wyzwalanie przerwania na INT0 zboczem opadajacym
  EICRA |=  _BV(ISC01);
  // odmaskuj przerwania dla INT0
  EIMSK |= _BV(INT0);
  // odmaskuj przerwania dla ADC
  EIMSK |= _BV(ADC);
}

ISR(INT0_vect) {    
    ADCSRA |= _BV(ADSC); // wykonaj konwersję        
}

ISR(ADC_vect) {
    ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)    
    v = ADC; // weź zmierzoną wartość (0..1023)    
}

int main(){
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    io_init();
    adc_init();
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
    sei();

    while(1){           
        cli();        
        // ADC = Vin * 1024 / Vref => Vin = ADC*Vref/1024        
        float Vout = ((float)v * (float)Vref) / 1024.0;
        // Vout = Vin * R/(RT+ R)
        // RT = R*(Vin - Vout) / Vout
        // RT - fotoresistor resistance       
        uint32_t RT = (float)R * ((float)Vref - Vout) / Vout;
        printf("ADC : %"SCNd16", RT : %"SCNd32"\r\n", v, RT);        
        sei();           
        _delay_ms(1000);
    }    
}