#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <util/delay.h>

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

void timer1_init()
{
  // ustaw tryb licznika
  // WGM1  = 0000 -- normal
  // CS1   = 001  -- prescaler 1
  TCCR1B = _BV(CS10);
}
FILE uart_file;

static volatile int8_t int8_1;
static volatile int8_t int8_2;

static volatile int16_t int16_1;
static volatile int16_t int16_2;

static volatile int32_t int32_1;
static volatile int32_t int32_2; 

static volatile int64_t int64_1;
static volatile int64_t int64_2;

static volatile float f_1;
static volatile float f_2;

uint16_t t1[3], t2[3]; 

#define TEST(var1, var2, val1, val2, type)\
    printf("testowanie typu "type":\r\n");\
    var1 = val1;\
    var2 = val2;\
    t1[0] = TCNT1;\
    var1 = var1 + var2;\
    t2[0] = TCNT1;\
    t1[1] = TCNT1;\
    var1 = var1 * var2;\
    t2[1] = TCNT1;\
    t1[2] = TCNT1;\
    var1 = var1 / var2;\
    t2[2] = TCNT1;\
    printf("+: %"SCNd16"; *: %"SCNd16"; /: %"SCNd16"\r\n", t2[0] - t1[0], t2[1] - t1[1], t2[2] - t1[2]);


int main()  
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  // zainicjalizuj timer1
  timer1_init();

  stdin = stdout = stderr = &uart_file;  

  while(1){
    TEST(int8_1 , int8_2 , 27, 49, "int8");
    TEST(int16_1, int16_2, 270, 490, "int16");
    TEST(int32_1, int32_2, 2700, 4900, "int32");
    TEST(int64_1, int64_2, 27000, 49000, "int64");
    TEST(f_1    , f_2    , 2700.0, 4900.0, "float");        
    printf("\r\n\r\n");
    _delay_ms(50000);

  }
}

