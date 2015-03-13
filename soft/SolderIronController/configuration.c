
static void configure(void){
    // Input/Output Ports initialization
    // Port A initialization
    // Func2=In Func1=Out Func0=Out 
    // State2=T State1=0 State0=0 
    PORTA=0x00;
    DDRA=0x03;

    // Port B initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
    // State7=T State6=P State5=T State4=P State3=P State2=0 State1=P State0=P 
    PORTB=0b1011011;
    DDRB=0b00000000;
    //DDRB=0b00000100;

    // Port D initialization
    // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
    // State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
    PORTD=0b00000000;
    DDRD=0b01011111;
    //DDRD=0b01011111;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 31.250 kHz
    // Mode: Fast PWM top=FFh
    // OC0A output: Non-Inverted PWM
    // OC0B output: Non-Inverted PWM
    TCCR0A=0xA3;
    TCCR0B=0x04;
    OCR0B=OCR0A=TCNT0=0x00;

    // Clock value: Timer1 Stopped
    OCR1BL=OCR1BH=OCR1AL=OCR1AH=ICR1L=ICR1H=TCNT1L=TCNT1H=TCCR1B=TCCR1A=0x00;

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

    // Analog Comparator: Off
    ACSR=0x80;
}

