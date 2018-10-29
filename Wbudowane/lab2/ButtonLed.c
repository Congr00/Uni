#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>


#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB0
#define BTN_PIN PINB
#define BTN_PORT PORTB

#define FALSE 0
#define TRUE  1

#define DELAY    20
#define MEM_SIZE 2000 / DELAY

int8_t led_mem[MEM_SIZE];

uint16_t ptr_led = MEM_SIZE / 2;
uint16_t ptr_mem = 0;

int main() {
  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);
  for(int8_t i = 0; i < MEM_SIZE; i++)
    led_mem[i] = FALSE;

  while (TRUE) {
    if (BTN_PIN & _BV(BTN)){
        led_mem[ptr_mem % 100] = FALSE;
    }
    else{
        led_mem[ptr_mem % 100] = TRUE;        
    }
    if(led_mem[ptr_led % 100]){
        LED_PORT |= _BV(LED);
        led_mem[ptr_led % 100] = FALSE;
    }
    else
        LED_PORT &= ~_BV(LED);
    ptr_led++;
    ptr_mem++;
    _delay_ms(DELAY);
  }
}