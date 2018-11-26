#include <avr/io.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>

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
  // ustaw flage przerwan przy odbieraniu/wysylaniu/bufforowaniu
  UCSR0B |= _BV(RXCIE0) | _BV(TXC0) | _BV(UDRIE0);
  sei();
}

#define N 32

char buff_in [N];
char buff_out[N];
volatile uint16_t _or = 0, _ow = 0;
volatile uint16_t _ir = 0, _iw = 0;


// transmisja jednego znaku
int uart_transmit(char data, FILE *stream)
{
  buff_out[_or++ % N] = data;
  sei(); 
  while(_ow != _or);
  cli();
  return 0;/*
  //czekaj aż transmiter gotowy
  while(!(UCSR0A & _BV(UDRE0)));
  UDR0 = data;
  return 0; */
}

// odczyt jednego znaku
int uart_receive(FILE *stream)
{
  sei();
  while(_ir == _iw);
  cli();
  return buff_in[_iw++ % N];
}

FILE uart_file;
// kiedy buffor na odczycie posiada dane
ISR(USART_RX_vect) {
  buff_in[_ir++ % N] = UDR0;
}
// kiedy przeshiftowalismy dane z buffora i nie ma wiecej
ISR(USART_TX_vect) {
  _or++;
}
//buffer transmitujacy moze przyjac nowe dane
ISR(USART_UDRE_vect) {
  if(_ow != _or)
    UDR0 = buff_out[_ow++ % N];
}


int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  for(uint16_t i = 0; i < N; ++i){
    buff_out[i] = '\0';
    buff_in [i] = '\0';
  }
  cli();
  // program testowy
  printf("Hello world!\r\n");
  while(1) {
    int16_t a = 1;
    scanf("%"SCNd16, &a);
    printf("Odczytano: %"PRId16"\r\n", a);
  }
}

