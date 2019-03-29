#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <util/delay.h>
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

// inicjalizacja ADC
void adc_init()
{
  ADMUX   |= _BV(REFS0) | _BV(REFS1); // referencja Vref 1.1V
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  =  _BV(ADPS1) | _BV(ADPS0) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN) | _BV(ADIE) | _BV(ADATE); // włącz ADC przerwania i autotrigger
  sei();
}

void timer1_init()
{
  // ustaw tryb licznika
  // COM1A = 11   -- inverting mode
  // WGM1  = 1110 -- fast PWM top=ICR1
  // CS1   = 011  -- prescaler 64
  // top = 0xff
  // częstotliwość 16e6/(64*(1+255)) = 976Hz
  // wzór: datasheet 20.12.3 str. 164
  TCCR1A = _BV(COM1A1) | _BV(COM1A0) | _BV(WGM10);
  TCCR1B = _BV(WGM12) | _BV(CS11) | _BV(CS10);
  // ustaw pin OC2 (PB3) jako wyjście
  DDRB |= _BV(PB1);
  OCR1A = 1;
}

FILE uart_file;
 
#define SPEED OCR1A

volatile uint16_t c = 0;

void engine_kicker(){
  SPEED = 255/2;
  _delay_us(10);
}

ISR(ADC_vect) {
  uint16_t v = ADC;
  v = v / 4;
  if(v > 10 && SPEED < 10)
      engine_kicker();  
  SPEED = v;
  char p = '%';
  if(c++ % 512 == 0)
    printf("Engine working at %"SCNd16"%c of efficiency\r\n", 100 - ((v*100) / 255), p);
}


int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  timer1_init();
  adc_init();

  engine_kicker();

  ADCSRA |= _BV(ADSC); // start adc conversion
  
  set_sleep_mode(SLEEP_MODE_IDLE);

  while(1) {
      sleep_mode();
  }
}
