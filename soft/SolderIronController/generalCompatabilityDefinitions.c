#define _BV(bit)    (1 << (bit)) 
#define BV(byte, num) ((byte>>num)&1)

#ifndef NULL
    #define NULL 0
#endif