/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/8/2015
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
#include <stdint.h>

#define _BV(bit)    (1 << (bit)) 
#define USI_TWI_BUFFER_SIZE 16
//enum{
//    USI_TWI_BUFFER_SIZE = 32
//};
#ifndef NULL
    #define NULL 0
#endif

# define DDR_USI	DDRB
# define PORT_USI	PORTB
# define PIN_USI	PINB
# define PORT_USI_SDA	PINB5
# define PORT_USI_SCL	PINB7
# define PIN_USI_SDA	PINB5
# define PIN_USI_SCL	PINB7


enum{
    of_state_check_address,
    of_state_send_data,
    of_state_request_ack,
    of_state_check_ack,
    of_state_receive_data,
    of_state_store_data_and_send_ack
} overflow_state_t;

enum{
    ss_state_before_start,
    ss_state_after_start,
    ss_state_address_selected,
    ss_state_address_not_selected,
    ss_state_data_processed
} startstop_state_t;

static void (*idle_callback)(void);
static void	(*data_callback)(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer);

static uint8_t of_state;
static uint8_t ss_state;
static uint8_t	slave_address;
static uint8_t	input_buffer[USI_TWI_BUFFER_SIZE];
static uint8_t	input_buffer_length;
static uint8_t	output_buffer[USI_TWI_BUFFER_SIZE];
static uint8_t	output_buffer_length;
static uint8_t	output_buffer_current;

static	uint8_t	*phy_send_buffer;
static	uint8_t	*phy_send_buffer_length;
enum{
    phy_buffer_size = USI_TWI_BUFFER_SIZE
};




static void set_sda_to_input(void){
    DDR_USI &= ~_BV(PORT_USI_SDA);
}
static void set_sda_to_output(void){
    DDR_USI |= _BV(PORT_USI_SDA);
}
static inline void set_scl_to_input(void){
    DDR_USI &= ~_BV(PORT_USI_SCL);
}
static inline void set_scl_to_output(void){
    DDR_USI |= _BV(PORT_USI_SCL);
}
static inline void set_sda_low(void){
    PORT_USI &= ~_BV(PORT_USI_SDA);
}
static inline void set_sda_high(void){
    PORT_USI |= _BV(PORT_USI_SDA);
}
static inline void set_scl_low(void){
    PORT_USI &= ~_BV(PORT_USI_SCL);
}
static inline void set_scl_high(void){
    PORT_USI |= _BV(PORT_USI_SCL);
}


static inline void twi_reset_state(void){
    USISR =
            (1	<< USISIF) | // clear start condition flag
            (1	<< USIOIF) | // clear overflow condition flag
            (0	<< USIPF) | // !clear stop condition flag
            (1	<< USIDC) | // clear arbitration error flag
            (0x00 << USICNT0); // set counter to "8" bits
    USICR =
            (1 << USISIE) | // enable start condition interrupt
            (0 << USIOIE) | // !enable overflow interrupt
            (1 << USIWM1) | (0 << USIWM0) | // set usi in two-wire mode, disable bit counter overflow hold
            (1 << USICS1) | (0 << USICS0) | (0 << USICLK) | // shift register clock source = external, positive edge, 4-bit counter source = external, both edges
            (0 << USITC); // don't toggle clock-port pin
}

static void twi_reset(void){
// make sure no sda/scl remains pulled up or down
    set_sda_to_input(); // deactivate internal pullup on sda/scl
    set_sda_low();
    set_scl_to_input();
    set_scl_low();
    set_sda_to_output(); // release (set high) on sda/scl
    set_sda_high();
    set_sda_to_input();
    set_sda_high();
    set_scl_to_output();
    set_scl_high();
    twi_reset_state();
}

static inline void twi_init(void)
{
    #if defined(USIPP)
        #if defined(USI_ON_PORT_A)
            USIPP |= _BV(USIPOS);
        #else
            USIPP &= ~_BV(USIPOS);
        # endif
    #endif
    twi_reset();
}


// USI start condition interrupt service routine
interrupt [USI_STRT] void usi_start_isr(void){
    set_sda_to_input();
    // wait for SCL to go low to ensure the start condition has completed (the
    // start detector will hold SCL low) - if a stop condition arises then leave
    // the interrupt to prevent waiting forever - don't use USISR to test for stop
    // condition as in Application Note AVR312 because the stop condition Flag is
    // going to be set from the last TWI sequence
    while(!(PIN_USI & _BV(PIN_USI_SDA)) && (PIN_USI & _BV(PIN_USI_SCL))){}
    // possible combinations
    // sda = low scl = low break start condition
    // sda = low scl = high loop
    // sda = high scl = low break stop condition
    // sda = high scl = high break stop condition       
    if((PIN_USI & _BV(PIN_USI_SDA))){ // stop condition
        twi_reset();
        return;
    }     
            
    of_state = of_state_check_address;
    ss_state = ss_state_after_start;
    USIDR = 0xff;
    USICR =
            (1 << USISIE) | // enable start condition interrupt
            (1 << USIOIE) | // enable overflow interrupt
            (1 << USIWM1) | (1 << USIWM0) | // set usi in two-wire mode, enable bit counter overflow hold
            (1 << USICS1) | (0 << USICS0) | (0 << USICLK) | // shift register clock source = external, positive edge, 4-bit counter source = external, both edges
            (0 << USITC); // don't toggle clock-port pin
    USISR =
            (1	<< USISIF) | // clear start condition flag
            (1	<< USIOIF) | // clear overflow condition flag
            (0	<< USIPF) | // !clear stop condition flag
            (1	<< USIDC) | // clear arbitration error flag
            (0x00 << USICNT0); // set counter to "8" bits
}


// USI counter overflow interrupt service routine
interrupt [USI_OVERFLOW] void usi_ovf_isr(void){
    // bit shift register overflow condition occured
    // scl forced low until overflow condition is cleared!
    uint8_t data = USIDR;
    uint8_t set_counter = 0x00; // send 8 bits (16 edges)          
again:
    switch(of_state){
    // start condition occured and succeed
    // check address, if not OK, reset usi
    // note: not using general call address
        case(of_state_check_address):{
            uint8_t address;
            uint8_t direction;
            direction = data & 0x01;
            address = (data & 0xfe) >> 1;
            if(address == slave_address){
                ss_state = ss_state_address_selected;
                if(direction){ // read request from master
                    of_state = of_state_send_data;
                }else{	// write request from master
                    of_state = of_state_receive_data;
                }
                USIDR = 0x00;
                set_counter = 0x0e; // send 1 bit (2 edges)
                set_sda_to_output(); // initiate send ack
            }else{
                USIDR = 0x00;
                set_counter = 0x00;
                twi_reset_state();
                ss_state = ss_state_address_not_selected;
            }
            break;
        }
        // process read request from master
        case(of_state_send_data):{
            ss_state = ss_state_data_processed;
            of_state = of_state_request_ack;
            if(output_buffer_current < output_buffer_length){
                USIDR = output_buffer[output_buffer_current++];
            }else{
                USIDR = 0x00; // no more data, but cannot send "nothing" or "nak"
            }
            set_counter = 0x00;
            set_sda_to_output(); // initiate send data
            break;
        }
        // data sent to master, request ack (or nack) from master
        case(of_state_request_ack):{
            of_state = of_state_check_ack;
            USIDR = 0x00;
            set_counter = 0x0e; // receive 1 bit (2 edges)
            set_sda_to_input(); // initiate receive ack
            break;
        }
        // ack/nack from master received
        case(of_state_check_ack):{
            if(data){ // if NACK, the master does not want more data    
                of_state = of_state_check_address;
                set_counter = 0x00;
                twi_reset();
            }else{
                of_state = of_state_send_data;
                goto again; // from here we just drop straight into state_send_data
            } // don't wait for another overflow interrupt
            break;
        }
        // process write request from master
        case(of_state_receive_data):{
            ss_state = ss_state_data_processed;
            of_state = of_state_store_data_and_send_ack;
            set_counter = 0x00; // receive 1 bit (2 edges)
            set_sda_to_input(); // initiate receive data
            break;
        }
        // data received from master, store it and wait for more data
        case(of_state_store_data_and_send_ack):{
            of_state = of_state_receive_data;
            if(input_buffer_length < (USI_TWI_BUFFER_SIZE - 1)){
                input_buffer[input_buffer_length++] = data;
            }
            USIDR = 0x00;
            set_counter = 0x0e; // send 1 bit (2 edges)
            set_sda_to_output(); // initiate send ack
            break;
        }
    }
    USISR =
            (0	<< USISIF) | // don't clear start condition flag
            (1	<< USIOIF) | // clear overflow condition flag
            (0	<< USIPF) | // don't clear stop condition flag
            (1	<< USIDC) | // clear arbitration error flag
            (set_counter << USICNT0); // set counter to 8 or 1 bits
}

void usi_twi_slave(uint8_t slave_address_in, uint8_t use_sleep, void (*data_callback_in)(uint8_t input_buffer_length,
                    const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer),void (*idle_callback_in)(void)){
    uint8_t	call_datacallback = 0;
    slave_address = slave_address_in;
    data_callback = data_callback_in;
    idle_callback = idle_callback_in;
    input_buffer_length = 0;
    output_buffer_length = 0;
    output_buffer_current = 0;
    ss_state = ss_state_before_start;   
//    if(use_sleep){
//        set_sleep_mode(SLEEP_MODE_IDLE);
//    }
    twi_init();
    #asm("sei")
    for(;;){
        if(idle_callback){
            idle_callback();
        }                                                    
        
        if(use_sleep && (ss_state == ss_state_before_start)){
            //sleep_mode();
        }
        
        if(USISR & _BV(USIPF)){
            #asm("cli")
            USISR |= _BV(USIPF); // clear stop condition flag
            switch(ss_state){
                case(ss_state_after_start):{
                    twi_reset();
                    break;
                }
                
                case(ss_state_data_processed):{                    
                    call_datacallback = 1;
                    break;
                }
            }
            ss_state = ss_state_before_start;
            #asm("sei")
        }
        if(call_datacallback){
            output_buffer_length = 0;
            output_buffer_current = 0;
            data_callback(input_buffer_length, input_buffer, &output_buffer_length, output_buffer);
            input_buffer_length = 0;
            call_datacallback = 0;
        }
    }
}


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
}

static void reply(uint8_t error_code, uint8_t reply_length, const uint8_t *reply_string){
    uint8_t checksum;
    uint8_t ix;
    if((reply_length + 4) > phy_buffer_size){
        return;                              
    }
    //phy_send_buffer[0] = 3 + reply_length;
    //phy_send_buffer[1] = error_code;
   // phy_send_buffer[2] = input_byte;
    for(ix = 0; ix < reply_length; ix++){
        phy_send_buffer[3 + ix] = reply_string[ix];
    }
    for(ix = 1, checksum = 0; ix < (3 + reply_length); ix++){
        checksum += phy_send_buffer[ix];
    }
    //phy_send_buffer[3 + reply_length] = checksum;
    //*phy_send_buffer_length = 3 + reply_length + 1;
    *phy_send_buffer_length = 1;
}

static void reply_char(uint8_t value){
    reply(0, sizeof(value), &value);
    //reply(0, 0, 0));
}

static void my_twi_callback(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
                        uint8_t l = 1;
                        uint8_t b = 5;
                        
                        PORTD.5 = !PORTD.5;
                        transmit(input_buffer_length);
                        transmit(input_buffer[0]);     
                        transmit(input_buffer[1]);    
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        //transmit(0);
                        
                        b = input_buffer[0];
                        b++;                     
                           
                        *output_buffer_length = l;
                        output_buffer[0] = b;
                        //output_buffer = &b;
                        //reply_char(12);
                        //return;
                        //return(reply(0,0,0));
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
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0b00000100;
DDRB=0b00000100;

// Port D initialization

PORTD=0x00;
DDRD=0b00100000;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
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
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Two Wire (I2C)
// Clock source: Reg.=ext. pos. edge, Cnt.=USITC
// USI Counter Overflow Interrupt: On
// USI Start Condition Interrupt: On
USICR=0xEA;

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
// #asm("sei") 
 
usi_twi_slave(0b1000000, 0, my_twi_callback, NULL);
transmit(4);
while (1)
      {
      // Place your code here   
      //uint8_t bu = 8;
                          //output_buffer = 8;
      };
}
