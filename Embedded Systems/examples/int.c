#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

void io_init()
{
  // ustaw pull-up na PD2 i PD3 (INT0 i INT1)
  PORTD |= _BV(PORTD2) | _BV(PORTD3);
  // ustaw wyjście na PB5
  DDRB |= _BV(DDB5);
  // ustaw wyzwalanie przerwania na INT0 i INT1 zboczem narastającym
  EICRA |= _BV(ISC00) | _BV(ISC01) | _BV(ISC10) | _BV(ISC11);
  // odmaskuj przerwania dla INT0 i INT1
  EIMSK |= _BV(INT0) | _BV(INT1);
}

// może być potrzebny volatile
static uint8_t led = 0;

ISR(INT0_vect) {
  led = 1;
}

ISR(INT1_vect) {
  led = 0;
}

int main()
{
  // zainicjalizuj wejścia/wyjścia
  io_init();
  // odmaskuj przerwania
  sei();
  // program testowy
  while(1) {
    if (led)
        PORTB |= _BV(PORTB5);
    else
        PORTB &= ~_BV(PORTB5);
  }
}

