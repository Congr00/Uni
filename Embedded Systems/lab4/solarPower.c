#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <util/delay.h>

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



#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define CTR_DDR   DDRC
#define CTR_PORT  PORTC
#define CTR_LEFT  PC0

#define DIV 1024 / 12
#define MAX 4096

void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  // częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  ADCSRA  |= _BV(ADPS1); // preskaler 8
  ADCSRA |= _BV(ADEN); // włącz ADC
}

void led_bright(uint16_t delay){
  // 10ms loop
  for(uint8_t i = 0; i < 10; ++i){
      LED_PORT |= _BV(LED);
      Delay_us(delay);
      LED_PORT &= ~_BV(LED);      
      Delay_us(MAX - delay);    
  }
}

void Delay_us(int n) {
    n = n / 10;
    while (n--) {
        _delay_us(10);
    }
}

FILE uart_file;


int main(){
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;

    LED_DDR  |=  _BV(LED);    
    CTR_PORT |= _BV(CTR_LEFT); 

    adc_init();

    uint16_t ref = MAX;    
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik 
    while(1){

        //LED_PORT &= ~_BV(LED);//wylacz led na czas pomiaru             
        ADCSRA |= _BV(ADSC); // wykonaj konwersję        
        while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
        ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)    
        uint16_t v = ADC; // weź zmierzoną wartość (0..1023)
        uint16_t bright = v / (DIV);
        //printf("ADC : %"SCNd16"\r\n", v);    
        led_bright(ref >> bright);
    }    
}