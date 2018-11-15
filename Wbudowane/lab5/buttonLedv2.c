#include <stdint.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>


#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PD2
#define BTN_PIN PIND
#define BTN_PORT PORTD

#define FALSE 0
#define TRUE  1

#define DELAY    30
#define MEM_SIZE (2000 / DELAY)

int8_t led_mem[MEM_SIZE];

uint16_t ptr_led = MEM_SIZE / 2;
uint16_t ptr_mem = 0;


// inicjalizacja licznika 2
void timer2_init()
{
  // preskaler 1024 ~30ms
  TCCR2B = _BV(CS20) | _BV(CS21) | _BV(CS22);
  // odmaskowanie przerwania przepełnienia licznika
  TIMSK2 |= _BV(TOIE2);
}

// procedura obsługi przerwania przepełnienia licznika
ISR(TIMER2_OVF_vect) {
    led_mem[ptr_mem % MEM_SIZE] = (BTN_PIN & _BV(BTN));
    if(led_mem[ptr_led % MEM_SIZE] == 0)
        LED_PORT |= _BV(LED);
    else
        LED_PORT &= ~_BV(LED);
    ptr_led++;
    ptr_mem++;   
}

int main() {
  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);
  
  for(int16_t i = 0; i < MEM_SIZE; i++)
    led_mem[i] = TRUE;

  // zainicjalizuj licznik 2
  timer2_init(); 
  // ustaw tryb uśpienia na tryb bezczynności
  set_sleep_mode(SLEEP_MODE_PWR_SAVE);
  // odmaskuj przerwania
  sei();

  while(1) {
    sleep_mode();
  }
}