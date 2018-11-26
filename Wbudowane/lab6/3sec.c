#include <util/delay.h>
#include <avr/io.h>
#include <stdint.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include "3sec.h"

// inicjalizacja SPI
void spi_init()
{
    // ustaw piny MOSI, SCK i ~SS jako wyjścia
    DDRB |= _BV(DDB3) | _BV(DDB5) | _BV(DDB2);
    // włącz SPI w trybie master z zegarem 1000 kHz
    SPCR = _BV(SPE) | _BV(MSTR) | _BV(SPR0);
    SPCR &= ~_BV(CPOL);
    SPCR &= ~_BV(CPHA);
}

// transfer jednego bajtu
uint8_t spi_transfer(uint8_t data)
{
    // rozpocznij transmisję
    SPDR = data;
    // czekaj na ukończenie transmisji         
    while (!(SPSR & _BV(SPIF)));
    // wyczyść flagę przerwania
    SPSR |= _BV(SPIF);
    // zwróć otrzymane dane
    return SPDR;
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

#define CS   PB2
#define DDR  DDRB
#define PORT PORTB

#define B15  3//1
#define BUF  2//0
#define GA   1//1
#define SHDN 0//1

volatile uint16_t i = 0;    

union pack{
    uint16_t val;
    uint8_t data[2];       
};

ISR( TIMER1_COMPA_vect ){
    if(i == sizeof(music))
        i = 0;       
    union pack p;
    p.val = 0;
    p.val += pgm_read_byte(&music[i++]);
    p.val <<= 4;
    p.val += 0x7000;   
    PORT &= ~_BV(CS);
    spi_transfer(p.data[1]);
    spi_transfer(p.data[0]);
    PORT |= _BV(CS);
}

int main() {

  // ustaw porty
  DDR |= _BV(CS); 
  PORT |= _BV(CS);

  // uruchom licznik
  timer1_init();
  spi_init();
  set_sleep_mode(SLEEP_MODE_IDLE);
  _delay_ms(10);
  sei();  
  while (1) {
      sleep_mode();
  }
}
