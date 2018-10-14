#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>

#define LED PD4
#define LED_DDR DDRD
#define LED_PORT PORTD

#define DELAY_NEXT 10
#define DELAY_PREV 25
#define DELAY_SEQ  100

const uint8_t leds[8] = {PD0, PD1, PD2, PD3, PD4, PD5, PD6, PD7};

int main() {
  UCSR0B &= ~_BV(RXEN0) & ~_BV(TXEN0);
  for(uint8_t i = 0; i < 8; i++)    
    LED_DDR |= _BV(leds[i]);  
  uint8_t i = 0;
  while (1) {
    for(uint8_t i = 0; i < 8; i++){
      LED_PORT |= _BV(leds[i]);
      _delay_ms(DELAY_PREV);
      if(i)
        LED_PORT &= ~_BV(leds[i-1]);
      _delay_ms(DELAY_NEXT);
    }
    for(int8_t i = 7; i > -1; i--){
      LED_PORT |= _BV(leds[i]);
      _delay_ms(DELAY_PREV);
      if(i < 7)
        LED_PORT &= ~_BV(leds[i+1]);
      _delay_ms(DELAY_NEXT);
    }
    _delay_ms(DELAY_SEQ);
  }
}
