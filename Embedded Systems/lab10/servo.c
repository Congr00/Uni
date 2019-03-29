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
  ADMUX   |= _BV(REFS0) | _BV(REFS1); // Vref 1.1V
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  =  _BV(ADPS1) | _BV(ADPS0) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN) | _BV(ADIE) | _BV(ADATE); // włącz ADC przerwania i autotrigger
  sei();
}

void timer1_init()
{
  // COM1A = 10   -- non-inverting mode
  // WGM1  = 1110 -- fast PWM top=ICR1
  // CS1   = 011  -- prescaler 1024
  // ICR1  = 311
  // częstotliwość 16e6/(1024*(1+311)) = 50Hz ~ 20ms => 1ms <=> OCR1A++15 => ORC1A++1 = 1/15ms => 15 states (0-1MS)
  
  TCCR1A = _BV(COM1A1) | _BV(WGM11);
  TCCR1B = _BV(WGM12) | _BV(CS12) | _BV(CS10) | _BV(WGM13);

  DDRB |= _BV(PB1);
  ICR1 = 311;
  OCR1A = 15 + 7;
}

FILE uart_file;
 
#define DEG   (OCR1A)
#define MS_CONST (15) 

volatile uint16_t c = 0;

ISR(ADC_vect) {
  uint16_t v = ADC;
  v /= 68;
  DEG = MS_CONST + v;
  if(c++ % 512 == 0){
    printf("Servo at %"SCNd16"\r\n", 100 - (uint16_t)((v * 100) / MS_CONST));
    c = 0;
  }
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

  ADCSRA |= _BV(ADSC); // start adc conversion
  
  set_sleep_mode(SLEEP_MODE_IDLE);

  while(1) {
      sleep_mode();
  }
}
