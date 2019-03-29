#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>
#include <time.h>
#include <stdlib.h>


#define RED   OCR1A
#define GREEN OCR0A
#define BLUE  OCR2B

uint16_t H = 0;
uint16_t S = 100;
uint16_t L = 0;

uint8_t R = 0,G = 0,B = 0;

void timer1_init()
{
  // ustaw tryb licznika
  // COM1A = 11   -- inverting mode
  // WGM1  = 1110 -- fast PWM top=ICR1
  // CS1   = 101  -- prescaler 256
  // ICR1  = 15624
  // częstotliwość 16e6/(256*(1+15)) = 961 Hz
  // wzór: datasheet 20.12.3 str. 164
  TCCR1A = _BV(COM1A1) | _BV(COM1A0) | _BV(WGM10);
  TCCR1B = _BV(WGM12) | _BV(CS12);
  // ustaw pin OC2 (PB3) jako wyjście
  DDRB |= _BV(PB1);
}

void timer0_init(){

  // WGM01  = 111 -- fast PWN 8 bit top = 0x00ff
  // COMOA1 = 11  -- inv mode on pin OC0A, OC0B
  // CS01   = 100 -- prescaler 256

  //OCR0A  = (uint8_t)256;
  TCCR0A = _BV(WGM01) | _BV(WGM00) | _BV(COM0A1) | _BV(COM0A0);
  TCCR0B = _BV(CS02) | _BV(CS00);
  // ustaw pin OC0A (PD6) jako wyjście
  DDRD |= _BV(PD6);
}

void timer2_init(){
  // ustaw tryb licznika
  // COM1A = 11   -- inverting mode
  // WGM1  = 1110 -- fast PWM top=0xff
  // CS1   = 101  -- prescaler 1024
  // ICR1  = 15624
  // częstotliwość 16e6/(1024*(1+15)) = 961 Hz
  // wzór: datasheet 20.12.3 str. 164

  TCCR2A = _BV(WGM21) | _BV(WGM20) | _BV(COM2B1) | _BV(COM2B0);
  TCCR2B = _BV(CS22) | _BV(CS20);
  // ustaw pin OC2B (PD3) jako wyjście
  DDRD |= _BV(PD3);
}

void HSL_to_RGB(uint16_t hue, uint16_t sat, uint16_t lum, uint8_t* r, uint8_t* g, uint8_t* b)
{
    uint16_t v;

    v = (lum < 128) ? (lum * (256 + sat)) >> 8 :
          (((lum + sat) << 8) - lum * sat) >> 8;
    if (v <= 0) {
        *r = *g = *b = 0;
    } else {
        uint16_t m;
        uint16_t sextant;
        uint16_t fract, vsf, mid1, mid2;

        m = lum + lum - v;
        hue *= 6;
        sextant = hue >> 8;
        fract = hue - (sextant << 8);
        vsf = v * fract * (v - m) / v >> 8;
        mid1 = m + vsf;
        mid2 = v - vsf;
        switch (sextant) {
           case 0: *r = v; *g = mid1; *b = m; break;
           case 1: *r = mid2; *g = v; *b = m; break;
           case 2: *r = m; *g = v; *b = mid1; break;
           case 3: *r = m; *g = mid2; *b = v; break;
           case 4: *r = mid1; *g = m; *b = v; break;
           case 5: *r = v; *g = m; *b = mid2; break;
        }
    }
}

void rnd_hsl(){
    while(1){
        H = rand() % 300;
        if(H < 240)
            break;
    }
    HSL_to_RGB(H, S, L, &R, &G, &B);
}

int8_t vals[250] ={0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,
        1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,
        1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,
        2,  2,  2,  2,  2,  2,  2,  2,  2,  3,  3,  3,  3,  3,  3,  3,  3,
        3,  3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,  4,  4,  4,  4,
        4,  4,  4,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  6,  6,  6,  6,
        6,  6,  6,  6,  7,  7,  7,  7,  7,  7,  7,  7,  8,  8,  8,  8,  8,
        8,  9,  9,  9,  9,  9,  9, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11,
       12, 12, 12, 12, 13, 13, 13, 13, 14, 14, 14, 14, 15, 15, 15, 16, 16,
       16, 16, 17, 17, 17, 18, 18, 18, 19, 19, 19, 20, 20, 21, 21, 21, 22,
       22, 23, 23, 24, 24, 24, 25, 25, 26, 26, 27, 27, 28, 28, 29, 29, 30,
       31, 31, 32, 32, 33, 34, 34, 35, 35, 36, 37, 38, 38, 39, 40, 40, 41,
       42, 43, 44, 44, 45, 46, 47, 48, 49, 50, 50, 51, 52, 53, 54, 55, 56,
       57, 59, 60, 61, 62, 63, 64, 65, 67, 68, 69, 70, 72, 73, 75, 76, 77,
       79, 80, 82, 83, 85, 86, 88, 90, 91, 93, 95, 97};

void run_breathe(){
    // for running for 2.5 sec

    //_delay_ms(5000);
    for(uint8_t i = 0; i < 250; ++i){
        L = vals[i];
        HSL_to_RGB(H, S, L, &R, &G, &B);
        RED   = R;
        GREEN = G;
        BLUE  = B;        
        _delay_ms(3);
    }
    _delay_ms(250);
    for(uint8_t i = 250; i > 0; --i){
        L = vals[i - 1];
        HSL_to_RGB(H, S, L, &R, &G, &B);
        RED   = R;
        GREEN = G;
        BLUE  = B;        
        _delay_ms(3);
    }  
    _delay_ms(250);
}

int main()
{

  srand(time(NULL));  
  
  // uruchom licznik
  timer1_init();
  timer0_init();
  timer2_init();

  RED   = 0;
  GREEN = 0;
  BLUE  = 0;

  while(1){
    rnd_hsl();   
    run_breathe();    
  }
}

