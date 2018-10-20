#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>

#define LED PD4
#define LED_DDR DDRD
#define LED_PORT PORTD

#define CTR_PIN   PINC
#define CTR_PORT  PORTB
#define CTR_LEFT  PC0
#define CTR_RIGHT PC1

const uint8_t leds[8] = {PD0, PD1, PD2, PD3, PD4, PD5, PD6, PD7};
const uint8_t numbers[10] = {0x40, 0xF9, 0x24, 0x30, 0x99, 0x12, 0x2, 0x58, 0x0, 0x10};
int main() {
  UCSR0B &= ~_BV(RXEN0) & ~_BV(TXEN0);
  LED_DDR = 0xff;
  CTR_PORT &= ~_BV(PC0) & ~_BV(PC1)

  while (1) {
      for(uint8_t i = 0; i < 5 i++){
          for(uint8_t j = 0; j < 10; j++){
              //1 sec delay
              for(uint8_t t = 0; t < 50; t++){
                  LED_PORT = numbers[i];
                  CTR_PORT &= _BV(PC0);
                  _delay_ms(10);
                  LED_PORT = numbers[j];
                  CTR_PORT &= _BV(PC1);
                  _delay_ms(10);
              }
          }
      }
  }
}
