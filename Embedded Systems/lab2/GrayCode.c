#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>


#define LED PD4
#define LED_DDR DDRD
#define LED_PORT PORTD

#define BTN_PREV PB0
#define BTN_NEXT PB2
#define BTN_RST  PB1
#define BTN_PIN  PINB
#define BTN_PORT PORTB

#define DELAY 25

uint8_t bToG(uint8_t value){
    return value ^ (value >> 1);
}

int main() {
  UCSR0B &= ~_BV(RXEN0) & ~_BV(TXEN0);    
  BTN_PORT |= _BV(BTN_PREV);
  BTN_PORT |= _BV(BTN_NEXT);
  BTN_PORT |= _BV(BTN_RST);    
  LED_DDR  = 0xff;

  uint8_t code = 0;
  LED_PORT = code;
  while (1) {
    //wcisniety btn_*
    if (!(BTN_PIN & _BV(BTN_NEXT))){
        code++;
        LED_PORT = bToG(code);
        _delay_ms(DELAY);        
        while(!(BTN_PIN & _BV(BTN_NEXT)));
        _delay_ms(DELAY);        
    }
    if (!(BTN_PIN & _BV(BTN_PREV))){
        code--;
        LED_PORT = bToG(code);
        _delay_ms(DELAY);        
        while(!(BTN_PIN & _BV(BTN_PREV)));     
        _delay_ms(DELAY);           
    }
    if (!(BTN_PIN & _BV(BTN_RST))){
        code = 0;
        LED_PORT = bToG(code);
        _delay_ms(DELAY);
        while(!(BTN_PIN & _BV(BTN_RST)));    
        _delay_ms(DELAY);              
    }        
  }
}

