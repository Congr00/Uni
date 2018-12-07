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

const uint8_t eeprom_addr = 0xa0;

#define true  1
#define false 0
#define bool int

const char* read  = "read";
const char* write = "write";
const char* addr  = "addr";
const char* value = "value";

#define i2cCheck(code, msg) \
  if ((TWSR & 0xf8) != (code)) { \
    printf(msg " failed, status: %.2x\r\n", TWSR & 0xf8); \
    i2cReset(); \
    return 0; \
  }

int set_address(uint16_t addr){
  i2cStart();
  i2cCheck(0x08, "I2C start")
  i2cSend(eeprom_addr | ((addr & 0x100) >> 7));
  i2cCheck(0x18, "I2C EEPROM write request")
  i2cSend(addr & 0xff);
  i2cCheck(0x28, "I2C EEPROM set address")
  return 0;
}

int read_bytes(uint16_t addr, uint8_t len, uint8_t* buff){
  set_address(addr);
  i2cStop();
  i2cStart();  
  i2cCheck(0x10, "I2C second start")
  i2cSend(eeprom_addr | 0x1 | ((addr & 0x100) >> 7));
  i2cCheck(0x40, "I2C EEPROM read request")
  uint16_t i;
  for(i = 0; i < len-1; i++){
    buff[i] = i2cReadAck();
    i2cCheck(0x50, "I2C EEPROM read ack")
  }
  buff[i] = i2cReadNoAck();
  i2cCheck(0x58, "I2C EEPROM read")  
  i2cStop();
  i2cCheck(0xf8, "I2C stop")
  return 0;
}

int write_byte(uint16_t addr, uint8_t val){
  _delay_ms(3);
  set_address(addr);
  i2cSend(val);
  i2cCheck(0x28, "I2C EEPROM set data")
  i2cStop();
  i2cCheck(0xf8, "I2C stop")
  return 0;
}

void print_I8HEX(uint8_t* buff, uint8_t len, uint8_t type, uint16_t address){
    uint8_t checksum = len + type + (address >> 2) + ((address << 2) >> 2);
    printf("\r\nresult :%02X|%04X|%02X|", len, address, type);
    for(uint8_t i = 0; i < len; ++i){
        checksum += buff[i];   
        printf("%02X", buff[i]);
    }
    printf("|%02X\r\n", checksum);

}

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
  
  while(1) {
    uint8_t data[512];
    char data_str[512];
    uint16_t address;
    uint8_t length = 0;    

    scanf("%s", command);
    if(!strcmp(command, read)){
      scanf(" 0x%X %"SCNd8"", &address, &length);
      read_bytes(address, length, data);
      print_I8HEX(data, length, 0x00, address);
    }
    else if(!strcmp(command, write)){
      uint8_t val = 0;
      scanf(" :%s", data_str);
      char substr[6];
      memcpy(substr, data_str, 2);
      substr[2] = '\0';
      length = (uint8_t)strtol(substr, NULL, 16); 
      memcpy(substr, &data_str[2], 4);
      substr[4] = '\0';         
      address = (uint16_t)strtol(substr, NULL, 16);  
      substr[2] = '\0';    
      for(uint8_t i = 0; i < length; ++i){        
        memcpy(substr, &data_str[i*2 + 8], 2);
        val = (uint8_t)strtol(substr, NULL, 16);
        write_byte(address, val);       
        address++;
      }
      printf("\r\n%"SCNd8" bytes writen starting at: [0x%X]\r\n", length, address-length);
    }
    else
      printf("Command not found!\r\n");

  }
}

