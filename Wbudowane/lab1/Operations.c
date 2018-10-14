#include <avr/io.h>
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

union comb{
    int64_t conv64;
    int32_t conv32[2]; 

};


int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  while(1){
    printf("testowanie typu int8_t:\r\n");
    int8_t int81 = 0;
    int8_t int82 = 0;
    scanf("%"SCNd8" %"SCNd8, &int81, &int82);
    printf("wprowadzone liczby: %"SCNd8" %"SCNd8"\r\ndodawanie: %"SCNd8"\r\nmnożenie: %"SCNd8"\r\ndzielenie: %"SCNd8"\r\n",int81,int82, int81+int82, int81*int82, int81/int82);
    printf("testowanie typu int16_t:\r\n");
    int16_t int161 = 0,int162 = 0;
    scanf("%"SCNd16" %"SCNd16, &int161, &int162);
    printf("wprowadzone liczby: %"SCNd16" %"SCNd16"\r\ndodawanie: %"SCNd16"\r\nmnożenie: %"SCNd16"\r\ndzielenie: %"SCNd16"\r\n", int161, int162, int161+int162, int161*int162, int161/int162);
    printf("testowanie typu int32_t:\r\n");
    int32_t int321 = 0,int322 = 0;
    scanf("%"SCNd32" %"SCNd32, &int321, &int322);
    printf("wprowadzone liczby: %"SCNd32" %"SCNd32"\r\ndodawanie: %"SCNd32"\r\nmnożenie: %"SCNd32"\r\ndzielenie: %"SCNd32"\r\n", int321, int322, int321+int322, int321*int322, int321/int322);
    printf("testowanie typu int64_t:\r\n");
    //tak, nie ma obslugi int64 w avr, wiec wczytujemy 32 bity
    int64_t int641 = 0,int642 = 0;  
    scanf("%"SCNd32" %"SCNd32, &int321, &int322);
    int641 = int321;
    int642 = int322;
    printf("wprowadzone liczby: %"SCNd32" %"SCNd32"\r\ndodawanie: %"SCNd32"\r\nmnożenie: %"SCNd32"\r\ndzielenie: %"SCNd32"\r\n", int641, int642, int641+int642, int641*int642, int641/int642);      
    printf("testowanie typu float:\r\n");
    //fajne flagi dla linkera do obslugi floatow:  -Wl,-u,vfprintf -lprintf_flt -lm   
    float float1 = 0.123f,float2 = 0.123f;
    scanf("%f %f", &float1, &float2);
    printf("wprowadzone liczby: %.6f %.6f\r\ndodawanie: %.6f\r\nmnożenie: %.6f\r\ndzielenie: %.6f\r\n",float1, float2, float1+float2, float1*float2, float1/float2);  
  }
}

