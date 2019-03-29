#include <avr/io.h>
#include <util/delay.h>

#define BUZZ PB5
#define BUZZ_DDR DDRB
#define BUZZ_PORT PORTB

#define TONE(step, delay) \
    for (uint16_t i = 0; i < (uint32_t)1000 * (delay) / (step) / 2; i++) { \
      BUZZ_PORT |= _BV(BUZZ); \
      _delay_us(step); \
      BUZZ_PORT &= ~_BV(BUZZ); \
      _delay_us(step); \
    }

int main() {
  BUZZ_DDR |= _BV(BUZZ);
  while (1) {
    TONE(500, 1000);
    TONE(250, 1000);
  }
}
