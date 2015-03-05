/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/4/2015
Author  : NeVaDa
Company : banana-electronics
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>

eeprom unsigned char pwm1;

int delay = 0;
unsigned char prevPins = 0;

void transmit(char data){
   while(!(UCSRA & (1 << UDRE))){}
   UDR=data; 
}

void transmitInt(int data){
    int number = 0; 
    char str = '';
    if(data < 10){
       str = data + '0';
       transmit(str); 
    }else if(data < 100){
        number = data / 10;
        transmit(number + '0');
        number = data - (number*10);
        transmit(number + '0');
    }else if(data < 1000){
        number = data / 100;
        transmit(number + '0');
        data = data - (number * 100);                        
        number = data / 10;
        transmit(number + '0');        
        number = data - (number*10);
        transmit(number + '0');
    }                      
    transmit('\n');
}

void pwmChanged(void){
    int num = 0;
    pwm1 = delay; //memorize the value
    
    OCR0A = delay*2+1;
    num = delay - ((delay/100)*100);
    OCR0B = (num*255)/99; 
}

void incDelay(void){
    if(delay < 127){
        delay++; 
        transmitInt(delay); 
        pwmChanged();
    }
}

void decDelay(void){
    if(delay > 0){
        delay--;
        transmitInt(delay);
        pwmChanged();
    }
}
// Pin change 0-7 interrupt service routine
interrupt [PC_INT] void pin_change_isr0(void)
{
// Place your code here
     
    if((prevPins & (1<<4)) != (PINB & (1<<4))){
        if(!PINB.4){
            if(PINB.3){
                incDelay();
            }else{
                decDelay();
            }
        }else{
            if(!PINB.3){
                incDelay();
            }else{
                decDelay();
            }
        }
     }else if((prevPins & (1<<4)) != (PINB & (1<<4))){
         if(!PINB.3){
            if(!PINB.4){
                incDelay();
            }else{
                decDelay();
            }
        }else{
            if(PINB.4){
                incDelay();
            }else{
                decDelay();
            }
        }
     } 
      
     prevPins = PINB;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=1 State0=1 
PORTB=0b00011011;
DDRB=0b00000111;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0b00100000;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: Fast PWM top=FFh
// OC0A output: Non-Inverted PWM
// OC0B output: Non-Inverted PWM
TCCR0A=0xA3;
TCCR0B=0x04;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: On
GIMSK=0x20;
MCUCR=0x00;
PCMSK=0b00011000;
EIFR=0x20;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Global enable interrupts
transmitInt(pwm1);
delay = pwm1;
delay++;
transmitInt(pwm1);
transmitInt(0);
transmitInt(0);
pwmChanged();


#asm("sei")

while (1)
      {
      // Place your code here
                            
      #asm("sei");    
          delay_ms(delay);
         PORTB.0 = !PORTB.0;
         delay_ms(delay);
         PORTB.1 = !PORTB.1;   
         
         
 
      };
}

