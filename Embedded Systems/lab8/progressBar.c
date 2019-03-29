#include <avr/io.h>
#include <util/delay.h>
#include <inttypes.h>
#include "lib/hd44780.h"


char progress[] = {0x10, 0x18, 0x1C, 0x1E, 0x1F};

void set_chars(){
    for(uint8_t i = 0; i < 5; ++i){
        LCD_WriteCommand(HD44780_CGRAM_SET + (i * 8));
        for(uint8_t j = 0; j < 8; ++j)
            LCD_WriteData(progress[i]);
    }
    LCD_WriteCommand(HD44780_HOME);
}

int main()
{
  // skonfiguruj wyświetlacz

  LCD_Initialize();
  LCD_Clear();

  set_chars();

  while(1) {    
      for(uint8_t i = 0; i < 81; i++){
          if(i == 0)
            LCD_Clear();          
          LCD_GoTo(i / 5, 0);
          LCD_WriteData(i % 5);

        _delay_ms(50);          
      }
  }
}

