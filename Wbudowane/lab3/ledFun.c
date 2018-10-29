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

void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja AVcc, wejście ADC0
  DIDR0   = _BV(ADC0D); // wyłącz wejście cyfrowe na ADC0
  // częstotliwość zegara ADC 125 kHz (16 MHz / 128)
  ADCSRA  = _BV(ADPS1) | _BV(ADPS0); // preskaler 8
  ADCSRA |= _BV(ADEN); // włącz ADC
}

void led_bright(uint16_t delay){

//for(uint16_t i = 0; i < 10; ++i){
    delay *= 10;
        Delay_us(10240 - delay);
        LED_PORT |= _BV(LED);
        Delay_us(delay);
        LED_PORT &= ~_BV(LED);    
 //   }    
}

uint8_t find_sig_bit(uint16_t var){
    uint16_t ref = 0x200;
    for(uint8_t i = 10, j = 0; i > 0; i--, j++){
        if(var & (ref >> j))
            return i;
    }
    return 0;
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

    //UCSR0B &= ~_BV(RXEN0) & ~_BV(TXEN0);
    LED_DDR |= _BV(LED);
    CTR_DDR |= _BV(PC0);    

    uint16_t ref = 1;
    adc_init();
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
    while(1){
        LED_PORT &= ~_BV(LED);//wylacz led na czas pomiaru             
        ADCSRA |= _BV(ADSC); // wykonaj konwersję        
        while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
        ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)    
        uint16_t v = ADC; // weź zmierzoną wartość (0..1023)
        printf("ADC : %"SCNd16"\r\n", v);   
        uint8_t pow = find_sig_bit(v);


        
        led_bright(ref << pow);
    }    
}