#include <avr/io.h>
#include <util/delay.h>

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB4
#define BTN_PIN PINB
#define BTN_PORT PORTB

int main() {
  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);
  
  while (1) {
    if (BTN_PIN & _BV(BTN))
      LED_PORT &= ~_BV(LED);
    else
      LED_PORT |= _BV(LED);
  }
}
