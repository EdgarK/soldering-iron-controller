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
