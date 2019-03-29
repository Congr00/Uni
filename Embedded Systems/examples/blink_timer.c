#include <avr/io.h>

void timer1_init()
{
  // ustaw tryb licznika
  // COM1A = 10   -- non-inverting mode
  // WGM1  = 1110 -- fast PWM top=ICR1
  // CS1   = 101  -- prescaler 1024
  // ICR1  = 15624
  // częstotliwość 16e6/(1024*(1+15624)) = 1 Hz
  // wzór: datasheet 20.12.3 str. 164
  ICR1 = 15624;
  TCCR1A = _BV(COM1A1) | _BV(WGM11);
  TCCR1B = _BV(WGM12) | _BV(WGM13) | _BV(CS10) | _BV(CS12);
  // ustaw pin OC1A (PB1) jako wyjście
  DDRB |= _BV(PB1);
}

int main()
{
  // uruchom licznik
  timer1_init();
  // ustaw wypełnienie 50%
  OCR1A = ICR1/2;
  while(1);
}

