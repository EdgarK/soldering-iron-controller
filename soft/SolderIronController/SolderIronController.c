/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <stdint.h>
#include <ui.c>

#include <generalCompatabilityDefinitions.c>
#include <twiOverUsi.c>

#include <configuration.c>
#include <delay.h>

#define TWI_ADDRESS         0b1000000
#define LedDelay            50
eeprom ui16 pwmValues     = 0;
eeprom ui8  settingTarget = 0;

ui8 outputStates           = 0;
ui8 lastPortBValue         = 0;


void setOut1StateTo(ui8 isOn);
void setOut2StateTo(ui8 isOn);
void savePwmValues(void);

static void responde(uint8_t *output_buffer_length, uint8_t *output_buffer){
    *output_buffer_length = 3;
    output_buffer[0] = OCR0A;
    output_buffer[1] = OCR0B;
    output_buffer[2] = outputStates;    
}
static void on_twi_receive(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
    if(input_buffer_length != 2){
        responde(output_buffer_length, output_buffer);
        return;
    }
              
    if(input_buffer[0] & 1){//zero bit
        setOut1StateTo(input_buffer[1] & 1);          
    }else if(input_buffer[0] & 2){// first
        setOut2StateTo(input_buffer[1] & 1);
    }else if(input_buffer[0] & 4){
        OCR0A = input_buffer[1];
        savePwmValues();
    }else if(input_buffer[0] & 8){
        OCR0B = input_buffer[1];
        savePwmValues();
    }
    responde(output_buffer_length, output_buffer);    
}

void restorePwmValues(void){
    OCR0A = (ui8) (pwmValues >> 8);
    OCR0B = (ui8) pwmValues;
}                   

void savePwmValues(void){
    ui16 buffer = 0;
    
    buffer = OCR0A;
    buffer = buffer << 8; 
    buffer |= OCR0B;
    pwmValues = buffer;
}    

static void increasePwm(void){
    if(!settingTarget){
        if(OCR0A > 0xFD) OCR0A = 0xFF;
        if(OCR0A < 0xFF){
            OCR0A += 2;
        }
    }else{
        if(OCR0B > 0xFD) OCR0B = 0xFF;
        if(OCR0B < 0xFF){
            OCR0B += 2;
        }
    }
    savePwmValues();
}

static void decreasePwm(void){
    if(!settingTarget){
        if(OCR0A == 1) OCR0A = 0;
        if(OCR0A > 0)
            OCR0A -= 2;
    }else{           
        if(OCR0B == 1) OCR0B = 0;
        if(OCR0B > 0)
            OCR0B -= 2;
    }   
    savePwmValues();
}

void toggleTarget(void){
    settingTarget = !settingTarget;
} 

void turnOut1On(void){
    DDRB |= 0b00000100;
    outputStates |= 0b00000001;
}
void turnOut1Off(void){
    DDRB &= 0b11111011; //To disable output just configuring it as an input
    outputStates &= 0b11111110;  
}
void setOut1StateTo(ui8 isOn){
    if(isOn)
        turnOut1On();
    else
        turnOut1Off();
}
void toggleOut1State(void){
    setOut1StateTo(!(outputStates & 1));
}

void turnOut2On(void){
    outputStates |= 0b00000010;
    DDRD |= 0b00100000;
}
void turnOut2Off(void){
     DDRD &= 0b11011111;
     outputStates &= 0b11111101;    
}
void setOut2StateTo(ui8 isOn){
    if(isOn)
        turnOut2On();
    else
        turnOut2Off();
}
void toggleOut2State(void){
    setOut2StateTo(!(outputStates & 2));                
}

   
// Pin change 0-7 interrupt service routine
interrupt [PC_INT] void pin_change_isr0(void){
    if(BV(lastPortBValue,4) != BV(PINB,4)){
        if(!BV(PINB, 4)){
            if(BV(PINB, 3))
                decreasePwm();//1
            else
                increasePwm();//2
        }else{
            if(BV(PINB, 3))
                increasePwm();
            else
                decreasePwm();
        } 
    }else if(BV(lastPortBValue,3) != BV(PINB,3)){

    }else if((BV(lastPortBValue, 6) != BV(PINB,6)) && BV(PINB, 6)){
        toggleTarget();
    }else if(((lastPortBValue & (1<<1)) != (PINB & (1<<1))) && !PINB.1){  
        toggleOut1State();        
    }else if(((lastPortBValue & 1) != (PINB & 1)) && !PINB.0){
        toggleOut2State();
    } 
    lastPortBValue = PINB;
}
 
void displayVal(ui8 val){
    ui8 value;
    if(val > 128){
        value = (val - 128) / 25; 
        switch(value){
            case(1):{
//                PORTD.0 = 1;
                PORTD.6 = 1;
                PORTD.1 = 0;
                PORTA.1 = 0;
                PORTA.0 = 0;
                PORTD.2 = 0;
                break;
            }
            case(2):{
//                PORTD.0 = 1;
                PORTD.6 = 1;
                PORTD.1 = 1;
                PORTA.1 = 0;
                PORTA.0 = 0;
                PORTD.2 = 0;
                break;
            }
            case(3):{
//                PORTD.0 = 1;
                PORTD.6 = 1;
                PORTD.1 = 1;
                PORTA.1 = 1;
                PORTA.0 = 0;
                PORTD.2 = 0;
                break;
            }
            case(4):{       
//                PORTD.0 = 1;
                PORTD.6 = 1;
                PORTD.1 = 1;
                PORTA.1 = 1;
                PORTA.0 = 1;
                PORTD.2 = 0;
                break;
            }
            case(5):{       
//                PORTD.0 = 1;
                PORTD.6 = 1;
                PORTD.1 = 1;
                PORTA.1 = 1;
                PORTA.0 = 1;
                PORTD.2 = 1;
                break;
            }
        }    
    }else{
        PORTD.6 = 0;
        PORTD.0 = 0;
        PORTD.1 = 0;
        PORTA.1 = 0;
        PORTA.0 = 0;
        PORTD.2 = 0;    
    }
    
}
     
void main(void){
ui8 toggler = 0;
ui16 counter = 0;
    // Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

    configure();

    restorePwmValues();
    
   // usi_twi_slave(TWI_ADDRESS, 0, on_twi_receive, NULL);
    #asm("sei")

    while (1){       
    
        if(!settingTarget){            
            
            if(!!(outputStates & 1))
                PORTD.3 = (counter > 400);    
            else
                PORTD.3 = (counter < 400);
                            
            PORTD.4 = !!(outputStates & 2);
            
            
            if(OCR0A > 133)
                displayVal(OCR0A);                 
            else if(counter > 8000)                   
                displayVal(OCR0A + 120);
            else 
                displayVal(0);
                
        }else{
            PORTD.3 = !!(outputStates & 1);                               
             
            if(!!(outputStates & 2))
                PORTD.4 = (counter > 400);
            else                          
                PORTD.4 = (counter < 400);
                
            if(OCR0B > 133)
                displayVal(OCR0B);                 
            else if(counter > 8000)                   
                displayVal(OCR0B + 120);
            else 
                displayVal(0);;
        }          
        
        counter++;
        if(counter >= 16000) counter = 0; 
        
        //PORTD.3 = !!(outputStates & 1);//0
        //PORTD.4 = !!(outputStates & 2);//1
        //if(!settingTarget){
        //    displayVal(OCR0A);    
        //}else{
        //    if(toggler)
        //        displayVal(OCR0B);
        //    else
        //        displayVal(0);
        //    toggler = !toggler;
        //    delay_ms(LedDelay); 
        //}  
    };
}
