#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>

#define LED PD4
#define LED_DDR DDRD
#define LED_PORT PORTD
const uint8_t leds[8] = {PD0, PD1, PD2, PD3, PD4, PD5, PD6, PD7};
const uint8_t numbers[10] = {0x40, 0x4F, 0x24, 0x30, 0x1B, 0x12, 0x2, 0x58, 0x0, 0x10};
int main() {
  UCSR0B &= ~_BV(RXEN0) & ~_BV(TXEN0);
  for(uint8_t i = 0; i < 8; i++)    
    LED_DDR |= _BV(leds[i]);  
  while (1) {
      for(uint8_t i = 0; i < 10; i++){
          LED_PORT &= 0x0;          
          LED_PORT |= numbers[i];          
          _delay_ms(1000);
      }
  }
}
