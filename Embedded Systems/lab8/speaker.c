#include <avr/io.h>
#include <util/delay.h>
#include <avr/pgmspace.h>



#define BUZZ PB1
#define BUZZ_DDR DDRB
#define BUZZ_PORT PORTB

#define C  16
#define D  18
#define E  20
#define F  22
#define G  24
#define A  27
#define H  30
#define P   0

#define TONE_SHIFT 3

#define NOTE  100 // *7
#define HALF  NOTE/2
#define QUART NOTE/4
#define EITH  NOTE/8

#define PAUSE 50
#define NOTES_SIZE 223

// 133 elements
static const uint8_t song[][2] PROGMEM = 
{
{P, HALF}, {H, QUART}, 
{E*2, QUART+QUART/2}, {G*2, EITH}, {F*2, QUART},
{E*2, HALF}, {H*2, QUART},
{A*2, HALF+QUART},
{F*2, HALF+QUART},
{E*2, QUART+EITH}, {G*2, EITH}, {F*2, QUART},
{D*2, HALF}, {F*2, QUART},
{H, HALF+QUART},
{P, QUART},{P, QUART},{H, QUART}, 
{E*2, QUART+EITH}, {G*2, EITH}, {F*2, QUART},
{E*2, HALF}, {H*2, QUART},

{D*4, HALF},{D*4, QUART},
{C*4, HALF},{A*2, QUART},
{C*4, QUART+EITH},{H*2, EITH}, {H*2, QUART},
{H, HALF}, {G*2, QUART}, 
{E*2, HALF+QUART},
{P, HALF},{G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{C*4, HALF}, {H*2, QUART},
{H*2, HALF}, {F*2, QUART},
{G*2, QUART+EITH}, {H*2, EITH}, {H*2, QUART},

{H, HALF}, {H, QUART},
{H*2, HALF}, {P, QUART},
{P, HALF}, {G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{D*4, HALF},{D*4, QUART},
{C*4, HALF},{A*2, QUART},
{C*4, QUART+EITH},{H*2, EITH}, {H*2, QUART},
{H, HALF}, {G*2, QUART}, 
{E*2, HALF+QUART},
{P, HALF},
{E*2, HALF+QUART},

{P, HALF}, {H, QUART}, 
{E*2, QUART+QUART/2}, {G*2, EITH}, {F*2, QUART},
{E*2, HALF}, {H*2, QUART},
{A*2, HALF+QUART},
{F*2, HALF+QUART},
{E*2, QUART+EITH}, {G*2, EITH}, {F*2, QUART},
{D*2, HALF}, {F*2, QUART},
{H, HALF+QUART},
{P, HALF},{H, QUART},
{E*2, QUART+EITH}, {G*2, EITH},{F*2, QUART},
{E*2, HALF},{H*2, QUART},
{D*4, HALF},{D*4, QUART},

{C*4, HALF},{A*2, QUART},
{C*4, QUART+EITH},{H*2, EITH}, {H*2, QUART},
{H, HALF}, {G*2, QUART}, 
{E*2, HALF+QUART},
{P, HALF},{G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{C*4, HALF}, {H*2, QUART},
{H*2, HALF}, {F*2, QUART},
{G*2, QUART+EITH}, {H*2, EITH}, {H*2, QUART},
{H, HALF},{H, QUART},

{H*2, HALF}, {P, QUART},
{P, HALF}, {G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{H*2, HALF}, {G*2, QUART},
{D*4, HALF},{D*4, QUART},
{C*4, HALF},{A*2, QUART},
{C*4, QUART+EITH},{H*2, EITH}, {H*2, QUART},
{H, HALF}, {G*2, QUART}, 
{E*2, HALF+QUART},
{P, HALF},
//4x4

{E*2, EITH},{E*2, EITH},{E*2,EITH},{E*2, EITH},
{E*2, EITH},{E*2, EITH},{E*2, EITH},{E*2, EITH},
{F*2, QUART}, {E*2, EITH}, {E*2, EITH}, {E*2, QUART}, {C*2, QUART},
{D*2, QUART}, {C*2, EITH}, {D*2, QUART}, {F, QUART},
{E, QUART},{A, EITH}, {C*2, EITH}, {D*2, HALF},
{E*2, EITH},{E*2, EITH},{E*2,EITH},{E*2, EITH},
{E*2, EITH},{E*2, EITH},{E*2,EITH},{E*2, EITH},

{G*2, QUART},{F*2, EITH},{E*2, EITH}, {F*2, QUART},{D, QUART},
{F*2, QUART},{E*2, EITH}, {D*2, EITH}, {E*2, EITH}, {D, QUART},
{C*2, HALF},{H, QUART}, {P, QUART},
{E*2, EITH},{E*2, EITH},{E*2,EITH},{E*2, EITH},
{E*2, EITH},{E*2, EITH},{E*2, EITH},{E*2, EITH},
{F*2, QUART}, {E*2, EITH}, {E*2, EITH}, {E*2, QUART}, {C*2, QUART},
{D*2, QUART}, {P, EITH}, {C*2, EITH}, {D*2, QUART}, {F, QUART},

{E, QUART},{A, EITH}, {C*2, EITH}, {D*2, HALF},
{E*2, EITH},{E*2, EITH},{E*2,EITH},{E*2, EITH},
{E*2, EITH},{E*2, EITH},{E*2,EITH},{E*2, EITH},
{G*2, QUART},{F*2, EITH},{E*2, EITH}, {F*2, QUART},{D, QUART},
{F*2, QUART},{E*2, EITH}, {D*2, EITH}, {E*2, EITH}, {D, QUART},
{C*2, HALF},{H, QUART}, {P, QUART},
{A, QUART},{P, HALF+QUART}
};



void Delay_us(int n) {
    n /= 10;
    while (n--) {
        _delay_us(10);
    }
}

void play_htz(uint32_t freq, uint32_t ms_duration){
    if(freq == 0){
        Delay_us(ms_duration * 1000);
        return;
    }
    uint32_t step = (uint32_t)1000*1000 / freq / 2;
    uint32_t n = ms_duration*(uint32_t)1000 / step;

    for(uint16_t i = 0; i < n; i++){
      BUZZ_PORT |= _BV(BUZZ);     
      Delay_us(step);

      BUZZ_PORT &= ~_BV(BUZZ);
      Delay_us(step); 
    }
}

int main() {
  BUZZ_DDR |= _BV(BUZZ);
  while (1) {
    for(uint32_t i = 0; i < NOTES_SIZE; ++i){
        play_htz(pgm_read_byte(&song[i][0])<<TONE_SHIFT, 4*pgm_read_byte(&song[i][1]));
        _delay_ms(PAUSE);
    }
    _delay_ms(5000);
  }
}