#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
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

// inicjalizacja ADC
void adc_init()
{
  ADMUX  |= _BV(REFS0); // referencja Vref 5V
  ADMUX  |= _BV(MUX0); // wejscie ADC1
  DIDR0   = _BV(ADC1D); // wyłącz wejście cyfrowe na ADC1
  ADCSRA  =  _BV(ADPS1) | _BV(ADPS0) | _BV(ADPS2); // preskaler 128
  ADCSRA |= _BV(ADEN);
}

void timer1_init()
{
  // ustaw tryb licznika
  // COM1B = 01   -- toggle on compare match
  // WGM1  = 1100 -- CTC top=ICR1=0xff
  // CS1   = 001  -- prescaler 64
  // częstotliwość 16e6/(1*(1+1999)) = 8 kHz

  TCCR1A = _BV(COM1A0);
  TCCR1B = _BV(WGM12) | _BV(CS10);
  TIMSK1 = _BV(OCF1A);
  OCR1A  =  1999; 
}

FILE uart_file;

uint16_t adc_conv(){
    ADCSRA |= _BV(ADSC);        
    while (!(ADCSRA & _BV(ADIF))); 
    ADCSRA |= _BV(ADIF);    
    return ADC;    
}

#define RANGE  (128)
#define OFFSET (2.5f)
#define XREF   (1.83f)


volatile uint16_t c = 0;
float data[RANGE];
float max_record = 0.0f;

float mean_sqr(){
    float res = 0.0f;
    for(uint16_t i = 0; i < RANGE; ++i)
        res += (data[i]-OFFSET) * (data[i]-OFFSET);
    return sqrt(res / RANGE);
}

void print_decibels(){
    float x = mean_sqr(); 
    if(x > max_record)
        max_record = x;
    float dec = 20 * log10(x / XREF);
    printf("| mean: %f | max: %f | decibels: %f |\r\n", x, max_record, dec);
}

ISR( TIMER1_COMPA_vect ){
    uint16_t adc = adc_conv();
    data[c++] = ((float)adc * 5.0f) / 1024.0f;
    if(c == RANGE){
        c = 0;
        //printf("| adc: %"SCNd16" | Vin: %f | ", adc, Vin);     
        print_decibels();
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
  adc_conv();
  set_sleep_mode(SLEEP_MODE_IDLE);
  sei();
  printf("test\r\n");
  while(1) {
      sleep_mode();
  }
}
