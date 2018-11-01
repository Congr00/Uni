#include <avr/io.h>
#include <util/delay.h>

void timer1_init()
{
  // ustaw tryb licznika
  // COM1B = 01   -- toggle on compare match
  // WGM1  = 1100 -- CTC top=ICR1
  // CS1   = 001  -- prescaler 1
  // częstotliwość 16e6/(2*1*(1+15624)) = 512 Hz

  TCCR1A = _BV(COM1A0);
  TCCR1B = _BV(WGM12) | _BV(WGM13) | _BV(CS10);
  // ustaw pin OC1A (PB1) jako wyjście
  DDRB |= _BV(PB1);
}

#define HTZ_SET  210;
#define HTZ_USET 999;

#define RIN      PB0
#define RIN_DDR  DDRB
#define RIN_PORT PORTB
#define RTN_PIN  PINB

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

void Delay_us(int n) {
    n = n / 10;
    while (n--) {
        if(RTN_PIN & _BV(RIN)){
            LED_PORT |= _BV(LED);            
        }
        else
            LED_PORT &= ~_BV(LED);
        _delay_us(7);
    }
}

int main() {
  
  RIN_DDR  &= ~_BV(RIN); // set to input
  RIN_PORT &= ~_BV(RIN); // turn off pull up transistor

  LED_DDR  |=  _BV(LED);  

  // uruchom licznik
  timer1_init();

  while (1) {
    ICR1 = HTZ_SET; // 37.9kHz
    Delay_us(600);
    ICR1 = HTZ_USET; // 8kHz
    Delay_us(600);
  }
}
