#include <avr/io.h>
#include <util/delay.h>

void timer1_init()
{
  // ustaw tryb licznika
  // COM1B = 01   -- toggle on compare match
  // WGM1  = 1100 -- CTC top=ICR1
  // CS1   = 010  -- prescaler 8
  // częstotliwość 16e6/(1024*(1+15624)) = 1 Hz
  // wzór: datasheet 20.12.3 str. 164
  TCCR1A = _BV(COM1B0);
  TCCR1B = _BV(WGM12) | _BV(WGM13) | _BV(CS11);
  // ustaw pin OC1B (PB2) jako wyjście
  DDRB |= _BV(PB2);
}

int main() {
  // uruchom licznik
  timer1_init();
  while (1) {
    // częstotliwość 16e6/(2*8*(1+999)) = 2 kHz
    ICR1=999;
    _delay_ms(1000);
    // częstotliwość 16e6/(2*8*(1+499)) = 1 kHz
    ICR1=499;
    _delay_ms(1000);
  }
}
