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

#define N 200

volatile static uint16_t i_ = 0;
volatile static float sum = 0.0;
volatile float input[N];


void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  ADMUX  |= _BV(MUX3) | _BV(MUX2) | _BV(MUX1); // input to 1.1V internal voltage  
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  =  _BV(ADPS1) | _BV(ADPS0); // preskaler 128
  ADCSRA |= _BV(ADEN);// włącz ADC i przerwania
}

ISR(ADC_vect) {
    if(i_ < N){    
        uint16_t v = ADC; // weź zmierzoną wartość (0..1023)   
        float res = (float)(1.1 * 1024) / (float)v;  
        input[i_] = res;
        sum += res;
        i_++;   
    }
}

float variance(){
    float var = 0.0;
    for(uint16_t i = 0; i < N; i++){
        var += (input[i] - sum) * (input[i] - sum);
        input[i] = 0.0;
    }
    return var / (float)N;
}

int main(){
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    adc_init();
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
    ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)    

    while(1){      
        for(uint16_t i = 0; i < N; i++){
            ADCSRA |= _BV(ADSC); // wykonaj konwersję
            while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
            ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)        
            uint16_t v = ADC; // weź zmierzoną wartość (0..1023)   
            float res = (float)(1.1 * 1024) / (float)v;  
            input[i] = res;
            sum += res;   
        }
        sum /= N;
        printf("NoSleep-> \r\nMean: %f\r\nVariance: %.15f\r\n", sum, variance());
        sum = 0.0;
        uart_wait();      
        _delay_ms(1);
        ADCSRA |= _BV(ADIE);           
        set_sleep_mode(SLEEP_MODE_ADC);
        sei();                              
        for(uint16_t i = 0; i < N; i++)
            sleep_mode();
        sum /= (float)N;
        printf("Sleep-> \r\nMean: %f\r\nVariance: %.15f\r\n", sum, variance()); 
        i_ = 0;
        sum = 0.0;
        uart_wait();
        cli();
        _delay_ms(50000);
    }    
}