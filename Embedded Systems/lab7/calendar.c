#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <util/delay.h>
#include <string.h>
#include <stdlib.h>

#include "lib/i2c.h"

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
  char data = UDR0;   
  uart_transmit(UDR0, NULL);  
  return data;
}

FILE uart_file;

const uint8_t clock_addr_r = 0b11010001;
const uint8_t clock_addr_w = 0b11010000;

#define DAY   0x04
#define MONTH 0x05
#define YEAR  0x06
#define SEC   0x00
#define MIN   0x01
#define HOUR  0x02


const char* date  = "date";
const char* time  = "time";
const char* set   = "set";

#define i2cCheck(code, msg) \
  if ((TWSR & 0xf8) != (code)) { \
    printf(msg " failed, status: %.2x\r\n", TWSR & 0xf8); \
    i2cReset(); \
    return 0; \
  }

int set_address(uint16_t addr){
  i2cStart();
  i2cCheck(0x08, "I2C start")
  i2cSend(clock_addr_w);
  i2cCheck(0x18, "I2C clock write request")
  i2cSend(addr);
  i2cCheck(0x28, "I2C clock set address")    
  return 0;
}

uint8_t read_byte(uint16_t addr){
  set_address(addr);
  i2cStart();  
  i2cCheck(0x10, "I2C second start")
  i2cSend(clock_addr_r);
  i2cCheck(0x40, "I2C EEPROM read request")
  uint8_t data = i2cReadNoAck();
  i2cCheck(0x58, "I2C EEPROM read")
  i2cStop();
  i2cStop();// kek
  i2cCheck(0xf8, "I2C stop")
  return data;
}

int write_byte(uint16_t addr, uint8_t val){
  set_address(addr);
  i2cSend(val);
  i2cCheck(0x28, "I2C EEPROM set data")
  i2cStop();
  i2cStop();//kek
  i2cCheck(0xf8, "I2C stop")
  return 0;
}
uint8_t bcd_int(uint8_t b){
    return (b & 0x0F) + ((b & 0xF0) >> 4) * 10;
}
uint8_t int_bcd(uint8_t i){
    return ((i / 10) << 4) | (i % 10);
}

#define YEAR_BASE 1973

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;
  // zainicjalizuj I2C
  i2cInit();

  char command[32];
  printf("input command:\r\n");
  //set 24 hour
  write_byte(HOUR, 0b00100000);

  while(1) {
    scanf("%s", command);
    if(!strcmp(command, date)){
        uint8_t day = bcd_int(read_byte(DAY));
        uint8_t month = bcd_int(read_byte(MONTH) & 0x7F);
        uint16_t year = bcd_int(read_byte(YEAR));
        printf("\r\ncurrent date: %02"SCNd8"-%02"SCNd8"-%04"SCNd16"\r\n", day, month, YEAR_BASE+year);
    }
    else if(!strcmp(command, time)){
        uint8_t sec = bcd_int(read_byte(SEC));
        uint8_t min = bcd_int(read_byte(MIN));
        uint8_t hour = bcd_int(read_byte(HOUR) & 0x3F);

        printf("\r\ncurrent time: %02"SCNd8":%02"SCNd8":%02"SCNd8"\r\n", hour, min, sec);
    }
    else if(!strcmp(command, set)){
        scanf(" %s", command);
        if(!strcmp(command, date)){
            uint8_t day;
            uint8_t month;
            uint16_t year;
            scanf(" %02"SCNd8"-%02"SCNd8"-%04"SCNd16"", &day, &month, &year);
            uint8_t year_scaled = year - YEAR_BASE;
            write_byte(DAY, int_bcd(day));
            write_byte(MONTH, int_bcd(month));
            write_byte(YEAR, int_bcd(year_scaled));
            printf("\r\ndate set!\r\n");            
        }
        else if(!strcmp(command, time)){
            uint8_t sec;
            uint8_t min;
            uint8_t hour;
            scanf(" %02"SCNd8":%02"SCNd8":%02"SCNd8"", &hour, &min, &sec);
            write_byte(SEC, int_bcd(sec));
            write_byte(MIN, int_bcd(min));
            write_byte(HOUR, int_bcd(hour));
            printf("\r\ntime set!\r\n");
        }
        else
            printf("\r\nCommand not found!\r\n");            
    }
    else
      printf("\r\nCommand %s not found!\r\n", command);

  }
}

