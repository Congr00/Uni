#include <avr/io.h>
#include <util/delay.h>

#define DELAY_TIME_MS 200
#define DOT 1
#define LINE 3 
#define SPACE_WORD 7
#define SPACE_CHAR 3

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

// inicjalizacja UART
void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
  // wyczyść rejestr UCSR0A
  UCSR0A = 0;
  // włącz odbiornik i nadajnik
  UCSR0B = _BV(RXEN0) | _BV(TXEN0);
  // ustaw format 8n1
  UCSR0C = _BV(UCSZ00) | _BV(UCSZ01);
}

// transmisja jednego znaku
int uart_transmit(char data, FILE *stream)
{
  // czekaj aż transmiter gotowy
  while(!(UCSR0A & _BV(UDRE0)));
  UDR0 = data;
  return 0;
}

// odczyt jednego znaku
int uart_receive(FILE *stream)
{
  // czekaj aż znak dostępny
  while (!(UCSR0A & _BV(RXC0)));
  return UDR0;
}

FILE uart_file;

//moars'e table
//                           0             1            2            3            4            5            6           7           8              9            
uint8_t const code[43][5] = {{1,1,1,1,1}, {0,1,1,1,1}, {0,0,1,1,1}, {0,0,0,1,1}, {0,0,0,0,1}, {0,0,0,0,0}, {1,0,0,0,0}, {1,1,0,0,0}, {1,1,1,0,0}, {1,1,1,1,0},
//assci slots for :,;,<,=,>,?,@
{2,2,2,2,2},{2,2,2,2,2},{2,2,2,2,2},{2,2,2,2,2},{2,2,2,2,2},{2,2,2,2,2},{2,2,2,2,2},//17+24+2 = 26+17=43
//a            b            c            d            e            f            g            h
  {0,1,2,2,2}, {1,0,0,0,2}, {1,0,1,0,2}, {1,0,0,0,2}, {0,2,2,2,2}, {0,0,1,0,2}, {1,1,0,2,2}, {0,0,0,0,2},
//i            j            k            l            m            n            o            p
  {0,0,2,2,2}, {0,1,1,1,2}, {1,0,1,2,2}, {0,1,0,0,2}, {1,1,2,2,2}, {1,0,2,2,2}, {1,1,1,2,2}, {0,1,1,0,2},
//q            r            s            t            u            v            w            x
  {1,1,0,1,2}, {0,1,0,2,2}, {0,0,0,2,2}, {1,2,2,2,2}, {0,0,1,2,2}, {0,0,0,1,2}, {0,1,1,2,2}, {1,0,0,1,2},
//y            z
  {1,0,1,1,2}, {1,1,0,0,2}};

void dot(){
    LED_PORT |= _BV(LED);
    _delay_ms(DELAY_TIME_MS*DOT);
    LED_PORT &= ~_BV(LED);
    _delay_ms(DELAY_TIME_MS*DOT);    
}

void line(){
    LED_PORT |= _BV(LED);
    _delay_ms(DELAY_TIME_MS*DOT*LINE);
    LED_PORT &= ~_BV(LED);
    _delay_ms(DELAY_TIME_MS*DOT);    
}

int main() {

// zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // program testowy
  char word[64];
  scanf("%64[^\r\n]", word);
  
  LED_DDR |= _BV(LED);
  while (1) {
    printf("Nadaje: %s\r\n", word);      
    for(uint8_t i = 0; word[i] != '\0'; i++){
        uint8_t assci = word[i];
        if(!assci)//end of string
            break;
        if(assci > 96) // change small letter to big one
            assci -= 32;        
        assci -= 48; // shift assci code by 48 to match code array
        for(uint8_t j = 0; j < 5; ++j){
            if(code[assci][j] == 2)
                break;
            else if(!code[assci][j])
                dot();
            else
                line();
        }
        if(i == 63) //word longer then string
            break;
        if(word[i+1] == 32){ //space pause
            i++;
            _delay_ms(DELAY_TIME_MS*DOT*SPACE_WORD);
        }
        else
            _delay_ms(DELAY_TIME_MS*DOT*SPACE_CHAR);
    }
    //end of msg
    printf("koniec wiadomosci\r\n");  
    _delay_ms(DELAY_TIME_MS*DOT*SPACE_WORD);        
  }
}
