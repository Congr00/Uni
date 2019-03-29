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

void timer1_init(){

  // CS12   = 100 -- prescaler 256
  // ICES1  = input capture enable on rising edge
  TCCR1B = _BV(CS12) | _BV(ICES1);
  TIMSK1 = _BV(ICIE1); // input capture interrupt enable 
}


#define CTR_DDR   DDRB
#define CTR_PORT  PORTB
#define CTR_PIN   PINB
#define CTR       PB0

#define N 0xFF

volatile uint32_t time = 0;
volatile int16_t n    = 0;

volatile uint16_t a = 0;

ISR(TIMER1_CAPT_vect){
    if(!n++){
        a = ICR1;
    }
    else if(n++ < N){
        time += abs(ICR1 - a);
        a = ICR1;
    }
    else{
        time /= N;
        float htz = 16e6 / (2 * 256 * (1 + time));
        printf("Result %f htz\r\n", htz);
        a = 0;
        time = 0;
        n = 0;
    }
}

int main(){

    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    CTR_DDR  &= ~_BV(CTR); // set to input
    CTR_PORT &= ~_BV(CTR); // turn off pull up resistor

    timer1_init(); 
    sei();

    set_sleep_mode(SLEEP_MODE_IDLE);
    while(1){
        sleep_mode();
    }
}

