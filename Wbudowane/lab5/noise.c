#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include <util/delay.h>
#include <math.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

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

// oczekiwanie na zakończenie transmisji
void uart_wait()
{
  while(!(UCSR0A & _BV(TXC0)));
}

FILE uart_file;

volatile static uint16_t v = 0;
volatile static uint8_t work = 0;

void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  ADMUX  |= _BV(MUX3) | _BV(MUX2) | _BV(MUX1); // input to 1.1V internal voltage  
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  =  _BV(ADPS1) | _BV(ADPS0); // preskaler 128
  ADCSRA |= _BV(ADEN) | _BV(ADIF) | _BV(ADIE); // włącz ADC i przerwania
  // odmaskuj przerwania dla ADC
  EIMSK |= _BV(ADC);  
}

char buff[32];

void put_print(float value, uint8_t s){
    uint32_t v = value * 100000;
    ltoa(v, buff, 10);
    sei();
    if(s)
        fputs("Sleep: ", stdout);
    else 
        fputs("NSleep: ", stdout);
    fputs(buff, stdout);
    fputs("\r\n", stdout);
    cli();
}


ISR(ADC_vect) {
    ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)        
    v = ADC; // weź zmierzoną wartość (0..1023)   
    float Vref = (float)(1.1 * 1024) / (float)v;     
    put_print(Vref, 1);
}

int main(){
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    adc_init();
    
    set_sleep_mode(SLEEP_MODE_ADC);
    sei();   
    
    while(1){     
        cli();        
        EIMSK &= ~_BV(ADC); 
        _delay_ms(1000);          
        float Vref;
        ADCSRA |= _BV(ADSC); // wykonaj konwersję
        while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
        ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)
        // ADC = Vin * 1024 / Vref => Vref = Vin * 1024 / ADC Vin = 1.1V
        v = ADC; // weź zmierzoną wartość (0..1023)
        Vref = (float)(1.1 * 1024) / (float)v; 
        put_print(Vref / 16, 0);                   
        _delay_ms(1000);          
        EIMSK |= _BV(ADC);        
        sei();            
        //ADCSRA |= _BV(ADSC); // wykonaj konwersję 
        sleep_mode();        
    }    
}