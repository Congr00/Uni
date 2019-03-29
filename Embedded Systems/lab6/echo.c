#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#define F_CPU 16000000

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
  // ustaw flage przerwan przy odbieraniu
  UCSR0B |= _BV(RXCIE0);
}

// transmisja jednego znaku
int uart_transmit(char data)
{
  // czekaj aż transmiter gotowy
  while(!(UCSR0A & _BV(UDRE0)));
  UDR0 = data;
  return 0;
}

// odczyt jednego znaku
int uart_receive()
{
  // czekaj aż znak dostępny
  while (!(UCSR0A & _BV(RXC0)));
  return UDR0;
}

volatile uint16_t x = 1;

ISR(USART_RX_vect) {
  char data = UDR0;   
  uart_transmit(UDR0);
  if((x++ % 11) == 0){
    uart_transmit('\r');
    uart_transmit('\n');    
  } 
}

int main()
{
  // zainicjalizuj UART
  uart_init();
  // program testujący połączenie
  set_sleep_mode(SLEEP_MODE_IDLE);
  sei();
  while(1)
    sleep_mode();
}

