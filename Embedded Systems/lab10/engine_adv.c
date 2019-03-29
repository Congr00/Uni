#include <avr/io.h>
#include <stdio.h>
#include <inttypes.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/sleep.h>

#define BAUD 9600                          // baudrate
#define UBRR_VALUE ((F_CPU)/16/(BAUD)-1)   // zgodnie ze wzorem

// inicjalizacja UART
void uart_init()
{
  // ustaw baudrate
  UBRR0 = UBRR_VALUE;
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

// inicjalizacja ADC
void adc_init()
{
  ADMUX   |= _BV(REFS0); // referencja Vref 1.1V
  DIDR0   = _BV(ADC0D) | _BV(ADC1D); // wyłącz wejście cyfrowe na ADC0 i ADC1

  ADCSRA  =  _BV(ADPS1) | _BV(ADPS2); // preskaler 64
  ADCSRA |= _BV(ADEN); // włącz ADC  
}

void timer1_init()
{
  // ustaw tryb licznika
  // COM1A = 11   -- inverting mode
  // WGM1  = 1000 -- PWN phase and freq correct top=ICR1
  // CS1   = 011  -- prescaler 64
  // ICR1  = 255
  // częstotliwość 16e6/(64*(1+255)) = 976Hz

  TCCR1A = _BV(COM1A1) | _BV(COM1A0);
  TCCR1B = _BV(WGM13) | _BV(CS11) | _BV(CS10);
  // ustaw pin OC2 (PB3) jako wyjście
  DDRB |= _BV(PB1);
  // interrupt at top enable
  TIMSK1 |= _BV(ICF1) | _BV(TOIE1);
  // interrupt at bottom enable
  TIFR1  |= _BV(TOV1);
  ICR1 = 0xFF;
}

FILE uart_file;
 
#define SPEED OCR1A

volatile uint16_t c = 0;

uint16_t adc_speed(){
    ADMUX &= ~_BV(MUX1);
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
    ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)        
    return ADC; // weź zmierzoną wartość (0..1023)       
}

uint16_t adc_voltage(){
    ADMUX  |= _BV(MUX1);
    ADCSRA |= _BV(ADSC); // wykonaj konwersję
    while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
    ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)        
    return ADC; // weź zmierzoną wartość (0..1023)       
}

void engine_kicker(){
  SPEED = 255/2;
  _delay_us(20);
}


#define TOP_SUM (256)

volatile uint32_t volt_sum_top = 0;
volatile uint16_t cnt_top = 0,cnt_bot = 0, print = 0;
volatile uint32_t volt_sum_bot = 0;

void calc_voltage(int top){
    float res = ((float)adc_voltage() * 5000.0f) / 1024.0f;
    if(top)
        volt_sum_top += (uint16_t)res;
    else
        volt_sum_bot += (uint16_t)res;
}

void update_speed(){
    uint16_t v = adc_speed();
    v = v / 4;
    if(v > 10 && SPEED < 10)
        engine_kicker();  
    SPEED = v;
}

// at bottom
ISR(TIMER1_OVF_vect){   
    calc_voltage(0);
    _delay_us(10);
    update_speed();         
}
// at top
ISR(TIMER1_CAPT_vect){
    
    calc_voltage(1);
    if(cnt_top++ == TOP_SUM){
        printf("ENGINE VOLTAGE BOT: %"SCNd32"mV TOP: %"SCNd32"mV\r\n", (uint32_t)(((float)volt_sum_bot / (float)TOP_SUM))  
        ,(uint32_t)(((float)volt_sum_top / (float)TOP_SUM)));  
        volt_sum_top = 0;
        volt_sum_bot = 0;
        cnt_top = 0;        
    }
}

int main()
{
  // zainicjalizuj UART
  uart_init();
  // skonfiguruj strumienie wejścia/wyjścia
  fdev_setup_stream(&uart_file, uart_transmit, uart_receive, _FDEV_SETUP_RW);
  stdin = stdout = stderr = &uart_file;

  timer1_init();
  adc_init();

  engine_kicker(); 

  ADCSRA |= _BV(ADSC); // wykonaj konwersję
  while (!(ADCSRA & _BV(ADIF))); // czekaj na wynik
  ADCSRA |= _BV(ADIF); // wyczyść bit ADIF (pisząc 1!)    
  set_sleep_mode(SLEEP_MODE_IDLE);
  sei();

  while(1) {
      sleep_mode();
  }
}
