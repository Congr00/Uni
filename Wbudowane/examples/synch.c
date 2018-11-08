#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdlib.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

// inicjalizacja UART
void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
  // wyczyść rejestr UCSR0A
  UCSR0A = 0;
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

void io_init()
{
  // ustaw pull-up na PD2 i PD3 (INT0 i INT1)
  PORTD |= _BV(PORTD2) | _BV(PORTD3);
  // ustaw wyjście na PB5
  DDRB |= _BV(DDB5);
  // ustaw wyzwalanie przerwania na INT0 i INT1 zboczem narastającym
  EICRA |= _BV(ISC00) | _BV(ISC01) | _BV(ISC10) | _BV(ISC11);
  // odmaskuj przerwania dla INT0 i INT1
  EIMSK |= _BV(INT0) | _BV(INT1);
}

FILE uart_file;
char buf[32];

int32_t val;

ISR(INT0_vect) {
    val = 0;
    putchar('x');
}

ISR(INT1_vect) {
    val = 0;
    putchar('y');
}

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj wejścia/wyjścia
  io_init();
  // odmaskuj przerwania
  sei();
  // program testowy
  while(1) {
    // zamaskuj przerwania
    // zakomentuj, a będą kłopoty!
    cli();
    // inkrementuj
    val++;
    // napisz wartość od czasu do czasu
    if (!(val & 0xfffff)) {
        ltoa(val, buf, 16);
        sei();
        fputs(buf, stdout);
        fputs("\r\n", stdout);
        PORTB ^= _BV(PORTB5);
    } else sei();
  }
}

