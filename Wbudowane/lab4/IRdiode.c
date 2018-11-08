#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
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

#define CTR_DDR   DDRC
#define CTR_PORT  PORTC
#define CTR       PC0

void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  ADCSRA  = _BV(ADPS1) | _BV(ADPS0); // preskaler 8
  ADCSRA |= _BV(ADEN); // włącz ADC
}

FILE uart_file;

void timer1_init()
{
  // ustaw tryb licznika
  // COM1B = 01   -- toggle on compare match
  // WGM1  = 1100 -- CTC top=ICR1
  // CS1   = 001  -- prescaler 1
  // częstotliwość 16e6/(2*1*(1+15624)) = 512 Hz

  TCCR1A = _BV(COM1A0);
  TCCR1B = _BV(WGM12) | _BV(WGM13) | _BV(CS10);
  // ustaw pin OC1A (PB1) jako wyjście
  DDRB |= _BV(PB1);
}

void timer0_init(){
   TCCR0A = _BV(WGM01);
   TCCR0B = _BV( CS00 ) | _BV( CS01 ); // 32 preskaler
   TIMSK0 = _BV( OCIE0A );   
   sei();
   OCR0A = 150;   
}

#define TIMER TCNT0

#define HTZ_SET  210
#define HTZ_USET 0

#define RIN      PB0
#define RIN_DDR  DDRB
#define RIN_PORT PORTB
#define RTN_PIN  PINB

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB


uint8_t cnt = 0;

ISR( TIMER0_COMPA_vect ) {   
   if(cnt < 50){
        ICR1 = ICR1 ? HTZ_USET : HTZ_SET;
        cnt++;  
   } 
}


int main() {
  
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  RIN_DDR  &= ~_BV(RIN); // set to input
  RIN_PORT &= ~_BV(RIN); // turn off pull up resistor

  LED_DDR  |=  _BV(LED);  

  // uruchom licznik
  timer1_init();
  timer0_init();

  LED_PORT &= ~_BV(LED); 
  
  while (1) { 
    if(cnt == 50){
         //LED_PORT &= ~_BV(LED);          
        _delay_ms(20);
        cnt = 0;
        _delay_us(600);
    }
    uint16_t cn = 0;
    int16_t i;
    for(i = 0; i < 8192; ++i){
        cn +=  (RTN_PIN & _BV(RIN));
        if(cnt == 50)
            break;
    }
    if(cn > 50){
         LED_PORT &= ~_BV(LED);  
    }
    else{
        LED_PORT |= _BV(LED);  

    }       
    printf("%"PRIu16"\r\n", cn);                
  }
}
