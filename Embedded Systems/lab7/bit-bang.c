#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>


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
  char data = UDR0;   
  return data;
}

FILE uart_file;


#define SS_IN     PD4
#define SLAVE_IN  PD5
#define SLAVE_OUT PD7
#define SCK       PD6
#define DDR       DDRD
#define PIN       PIND
#define PORT      PORTD

volatile uint8_t shift_buffer = 0;
volatile uint8_t value = 1;

// inicjalizacja licznika 2
void timer2_init()
{
  // preskaler 1024
  TCCR2B = _BV(CS22) | _BV(CS20) | _BV(CS21);
  // odmaskowanie przerwania przepełnienia licznika
  TIMSK2 |= _BV(TOIE2);
  sei();
}

void send_8bit(uint8_t data){

    PORT &= ~_BV(SS_IN);
    for(uint8_t i = 0; i < 8; ++i){                
        if(data & 0x80)
            PORT |= _BV(SLAVE_IN);
        else
            PORT &= ~_BV(SLAVE_IN);
        PORT |= _BV(SCK);            
        shift_buffer <<= 1;             
        shift_buffer |= ((PIN & _BV(SLAVE_OUT)) >> SLAVE_OUT);   
        PORT &= ~_BV(SCK);
        data <<= 1;          
    }     
    PORT |= _BV(SS_IN);
}

ISR(TIMER2_OVF_vect) {
    send_8bit(value++);
}

// inicjalizacja SPI
void spi_init()
{
    // ustaw piny MISO jako wyjscie
    DDRB |= _BV(DDB4);
    // ustaw piny sterujace spi na wyjscie
    DDR |= _BV(SLAVE_IN) | _BV(SCK) | _BV(SS_IN);
    // czytanie MISO na wejscie
    DDR &= ~_BV(SLAVE_OUT);
    // włącz SPI w trybie slave
    SPCR = _BV(SPE);
}

uint8_t SPI_SlaveReceive()
{
    /* Wait for reception complete */
    while(!(SPSR & (1<<SPIF)));
    /* Return Data Register */
    return SPDR;
}

int main()
{
    DDRD |= _BV(DDB4);
    // zainicjalizuj UART
    uart_init();
    // skonfiguruj strumienie wejścia/wyjścia
    fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
    stdin = stdout = stderr = &uart_file;    
    // zainicjalizuj SPI
    spi_init();
    timer2_init();
    while(1) {
        uint8_t result = SPI_SlaveReceive();
        printf("Slave data: %"SCNd8" Master data: %"SCNd8"\r\n",  result, shift_buffer);
    }
}

