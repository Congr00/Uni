#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>

#define LA PB1
#define OE PB2
#define DDR DDRB
#define PORT PORTB

// inicjalizacja SPI
void spi_init()
{
    // ustaw piny MOSI, SCK i ~SS jako wyjścia
    DDRB |= _BV(DDB3) | _BV(DDB5) | _BV(DDB2);
    // włącz SPI w trybie master z zegarem 250 kHz
    SPCR = _BV(SPE) | _BV(MSTR) | _BV(SPR1);
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

const uint8_t numbers[10] = {0x40, 0xF9, 0x24, 0x30, 0x99, 0x12, 0x2, 0x58, 0x0, 0x10};

int main()
{
  // ustaw porty
  DDR |= _BV(LA) | _BV(OE); 
  PORT &= ~_BV(OE);
  PORT &= ~_BV(LA);  
  // zainicjalizuj SPI
  spi_init();
  while(1) {
      for(uint8_t i = 0; i < 10; ++i){
          PORT &= ~_BV(LA);            
          spi_transfer(~numbers[i]);                       
          PORT |= _BV(LA);                
          _delay_ms(1000);
      }
  }
}

