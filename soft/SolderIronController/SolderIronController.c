/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : TWI Controlled Solder-Iron-Controller
Version : 1
Date    : 3/9/2015
Author  : EdgarK
Company : banana-electronics
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>

// Pin change 0-7 interrupt service routine
interrupt [PC_INT] void pin_change_isr0(void)
{
// Place your code here

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
// Func2=In Func1=Out Func0=Out 
// State2=T State1=0 State0=0 
PORTA=0x00;
DDRA=0x03;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
// State7=T State6=P State5=T State4=P State3=P State2=0 State1=P State0=P 
PORTB=0x5B;
DDRB=0x04;

// Port D initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0x7F;

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
PCMSK=0x5B;
EIFR=0x20;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      };
}
