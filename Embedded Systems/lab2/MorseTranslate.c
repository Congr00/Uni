#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>

#define DELAY_TIME_MS 200
#define DOT 1
#define LINE 3 
#define SPACE_WORD 7
#define SPACE_CHAR 3

#define LED PB5
#define LED_DDR DDRB
#define LED_PORT PORTB

#define BTN PB0
#define BTN_PIN PINB
#define BTN_PORT PORTB

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

//morse'a table
//                           0             1            2            3            4            5            6           7           8              9            
uint8_t const code[36][5] = {{1,1,1,1,1}, {0,1,1,1,1}, {0,0,1,1,1}, {0,0,0,1,1}, {0,0,0,0,1}, {0,0,0,0,0}, {1,0,0,0,0}, {1,1,0,0,0}, {1,1,1,0,0}, {1,1,1,1,0},
//a            b            c            d            e            f            g            h
  {0,1,2,2,2}, {1,0,0,0,2}, {1,0,1,0,2}, {1,0,0,0,2}, {0,2,2,2,2}, {0,0,1,0,2}, {1,1,0,2,2}, {0,0,0,0,2},
//i            j            k            l            m            n            o            p
  {0,0,2,2,2}, {0,1,1,1,2}, {1,0,1,2,2}, {0,1,0,0,2}, {1,1,2,2,2}, {1,0,2,2,2}, {1,1,1,2,2}, {0,1,1,0,2},
//q            r            s            t            u            v            w            x
  {1,1,0,1,2}, {0,1,0,2,2}, {0,0,0,2,2}, {1,2,2,2,2}, {0,0,1,2,2}, {0,0,0,1,2}, {0,1,1,2,2}, {1,0,0,1,2},
//y            z
  {1,0,1,1,2}, {1,1,0,0,2}};
uint8_t const char_code[36] = {'0', '1', '2', '3', '4', '5', '6', '7', '8','9',
     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
     'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

//ala ma kota
// .- .-.. .- | -- .- | -.- --- - .- 

#define EMPTY 2

uint16_t wait_for_boi(uint8_t led){
    uint16_t passed = 0;
    while(BTN_PIN & _BV(BTN)){
        passed++;
        _delay_ms(10);
        if(led && passed * 10 > DELAY_TIME_MS*DOT*SPACE_CHAR)
            LED_PORT |= _BV(LED);     
        if(led && ((passed * 10) > DELAY_TIME_MS*DOT*SPACE_WORD))
            break;       
    }
    return passed * 10;
}
uint16_t wait_for_eoi(uint8_t led){
    uint16_t passed = 0;
    while(!(BTN_PIN & _BV(BTN))){
        passed++;
        _delay_ms(10);
        if(led && passed * 10 > DELAY_TIME_MS*DOT)
            LED_PORT |= _BV(LED);            
    }
    return passed * 10;
}

int main() {
  BTN_PORT |= _BV(BTN);
  LED_DDR |= _BV(LED);
    // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  while (1) {
    uint8_t input[5];
    uint8_t insert_space = 0;
    while(BTN_PIN & _BV(BTN));      
    for(uint8_t i = 0; i < 5; ++i){
        if (!(BTN_PIN & _BV(BTN))){
            uint16_t wfe = wait_for_eoi(1); 
            if(wfe <= DELAY_TIME_MS*DOT)
                input[i] = 0;
            else
                input[i] = 1;
            // wylaczamy diode jesli byla zapalona
            LED_PORT &= ~_BV(LED);                
        }
        uint16_t wfb = wait_for_boi(1);
        if(wfb <= DELAY_TIME_MS*DOT){
            // przerwa miedzy znakami morse'a
            LED_PORT &= ~_BV(LED);                   
            continue;
        }
        // przerwa miedzy znakami
        else if(wfb <= DELAY_TIME_MS*DOT*SPACE_CHAR){
            LED_PORT &= ~_BV(LED);                   
            if(i != 4)
                input[i+1] = EMPTY;     
            break;        
        }
        // przerwa miedzy slowami, wypisujemy spacje
        else{
            LED_PORT &= ~_BV(LED);                   
            if(i != 4)
                input[i+1] = EMPTY;     
            insert_space = 1;                  
            break;
        }
    }
    // mamy znak, wypisujemy go,
    
    for(uint8_t i = 0; i < 36; i++){
        uint8_t matched = 0;
        for(uint8_t j = 0; j < 5; j++){
            if(input[j] != code[i][j]){
                break;
            }
            else if(input[j] == 2){
                matched = 1;
                break;
            }
            if(j == 4)
                matched = 1;
        }
        if(matched){
            printf("%c", char_code[i]);
            break;
        }
        if(i == 35 && !matched)
            printf("\r\ninput entry not found\r\n");
    } 
    if(insert_space)
        printf(" ");    
  }
}