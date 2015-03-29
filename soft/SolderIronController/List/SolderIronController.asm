
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _overflow_state_t=R3
	.DEF _startstop_state_t=R2
	.DEF _outputStates=R5
	.DEF _lastPortBValue=R4

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _pin_change_isr0
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usi_start_isr
	RJMP _usi_ovf_isr
	RJMP 0x00
	RJMP 0x00

_0xC5:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  _0xC5*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,0x00
	OUT  GPIOR0,R30
	OUT  GPIOR1,R30
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : TWI Controlled Solder-Iron-Controller
;Version : 1
;Date    : 3/9/2015
;Author  : EdgarK
;Company : banana-electronics
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdint.h>
;#include <ui.c>
;typedef unsigned char ui8;
;typedef unsigned short ui16;
;typedef unsigned long ui32;
;
;#include <generalCompatabilityDefinitions.c>
;#define _BV(bit)    (1 << (bit))
;#define BV(byte, num) ((byte>>num)&1)
;
;#ifndef NULL
;    #define NULL 0
;#endif
;#include <twiOverUsi.c>
;# define USI_TWI_BUFFER_SIZE 16
;
;//******chrystal dependent part******//
;# define DDR_USI    DDRB
;# define PORT_USI    PORTB
;# define PIN_USI    PINB
;# define PORT_USI_SDA    PINB5
;# define PORT_USI_SCL    PINB7
;# define PIN_USI_SDA    PINB5
;# define PIN_USI_SCL    PINB7
;
;//******theoretically chrystal independent part******//
;enum{
;    of_state_check_address,
;    of_state_send_data,
;    of_state_request_ack,
;    of_state_check_ack,
;    of_state_receive_data,
;    of_state_store_data_and_send_ack
;} overflow_state_t;
;
;enum{
;    ss_state_before_start,
;    ss_state_after_start,
;    ss_state_address_selected,
;    ss_state_address_not_selected,
;    ss_state_data_processed
;} startstop_state_t;
;
;
;static void (*idle_callback)(void);
;static void    (*data_callback)(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer);
;
;static uint8_t of_state;
;static uint8_t ss_state;
;static uint8_t    slave_address;
;static uint8_t    input_buffer[USI_TWI_BUFFER_SIZE];
;static uint8_t    input_buffer_length;
;static uint8_t    output_buffer[USI_TWI_BUFFER_SIZE];
;static uint8_t    output_buffer_length;
;static uint8_t    output_buffer_current;
;
;//static    uint8_t    *phy_send_buffer;
;//static    uint8_t    *phy_send_buffer_length;
;enum{
;    phy_buffer_size = USI_TWI_BUFFER_SIZE
;};
;
;
;
;
;static void set_sda_to_input(void){
; 0000 001C static void set_sda_to_input(void){

	.CSEG
_set_sda_to_input_G000:
;    DDR_USI &= ~_BV(PORT_USI_SDA);
	CBI  0x17,5
;}
	RET
;static void set_sda_to_output(void){
_set_sda_to_output_G000:
;    DDR_USI |= _BV(PORT_USI_SDA);
	SBI  0x17,5
;}
	RET
;static inline void set_scl_to_input(void){
_set_scl_to_input_G000:
;    DDR_USI &= ~_BV(PORT_USI_SCL);
	CBI  0x17,7
;}
	RET
;static inline void set_scl_to_output(void){
_set_scl_to_output_G000:
;    DDR_USI |= _BV(PORT_USI_SCL);
	SBI  0x17,7
;}
	RET
;static inline void set_sda_low(void){
_set_sda_low_G000:
;    PORT_USI &= ~_BV(PORT_USI_SDA);
	CBI  0x18,5
;}
	RET
;static inline void set_sda_high(void){
_set_sda_high_G000:
;    PORT_USI |= _BV(PORT_USI_SDA);
	SBI  0x18,5
;}
	RET
;static inline void set_scl_low(void){
_set_scl_low_G000:
;    PORT_USI &= ~_BV(PORT_USI_SCL);
	CBI  0x18,7
;}
	RET
;static inline void set_scl_high(void){
_set_scl_high_G000:
;    PORT_USI |= _BV(PORT_USI_SCL);
	SBI  0x18,7
;}
	RET
;
;static inline void twi_reset_state(void){
_twi_reset_state_G000:
;    USISR =
;            (1	<< USISIF) | // clear start condition flag
;            (1	<< USIOIF) | // clear overflow condition flag
;            (0	<< USIPF) | // !clear stop condition flag
;            (1	<< USIDC) | // clear arbitration error flag
;            (0x00 << USICNT0); // set counter to "8" bits
	LDI  R30,LOW(208)
	OUT  0xE,R30
;    USICR =
;            (1 << USISIE) | // enable start condition interrupt
;            (0 << USIOIE) | // !enable overflow interrupt
;            (1 << USIWM1) | (0 << USIWM0) | // set usi in two-wire mode, disable bit counter overflow hold
;            (1 << USICS1) | (0 << USICS0) | (0 << USICLK) | // shift register clock source = external, positive edge, 4-bit counter source = external, both edges
;            (0 << USITC); // don't toggle clock-port pin
	LDI  R30,LOW(168)
	OUT  0xD,R30
;}
	RET
;
;static void twi_reset(void){
_twi_reset_G000:
;// make sure no sda/scl remains pulled up or down
;    set_sda_to_input(); // deactivate internal pullup on sda/scl
	RCALL _set_sda_to_input_G000
;    set_sda_low();
	RCALL _set_sda_low_G000
;    set_scl_to_input();
	RCALL _set_scl_to_input_G000
;    set_scl_low();
	RCALL _set_scl_low_G000
;    set_sda_to_output(); // release (set high) on sda/scl
	RCALL _set_sda_to_output_G000
;    set_sda_high();
	RCALL _set_sda_high_G000
;    set_sda_to_input();
	RCALL _set_sda_to_input_G000
;    set_sda_high();
	RCALL _set_sda_high_G000
;    set_scl_to_output();
	RCALL _set_scl_to_output_G000
;    set_scl_high();
	RCALL _set_scl_high_G000
;    twi_reset_state();
	RCALL _twi_reset_state_G000
;}
	RET
;
;static inline void twi_init(void)
;{
;    #if defined(USIPP)
;        #if defined(USI_ON_PORT_A)
;            USIPP |= _BV(USIPOS);
;        #else
;            USIPP &= ~_BV(USIPOS);
;        # endif
;    #endif
;    twi_reset();
;}
;
;
;// USI start condition interrupt service routine
;interrupt [USI_STRT] void usi_start_isr(void){
_usi_start_isr:
	RCALL SUBOPT_0x0
;    set_sda_to_input();
	RCALL _set_sda_to_input_G000
;    // wait for SCL to go low to ensure the start condition has completed (the
;    // start detector will hold SCL low) - if a stop condition arises then leave
;    // the interrupt to prevent waiting forever - don't use USISR to test for stop
;    // condition as in Application Note AVR312 because the stop condition Flag is
;    // going to be set from the last TWI sequence
;    while(!(PIN_USI & _BV(PIN_USI_SDA)) && (PIN_USI & _BV(PIN_USI_SCL))){}
_0x3:
	SBIC 0x16,5
	RJMP _0x6
	SBIC 0x16,7
	RJMP _0x7
_0x6:
	RJMP _0x5
_0x7:
	RJMP _0x3
_0x5:
;    // possible combinations
;    // sda = low scl = low break start condition
;    // sda = low scl = high loop
;    // sda = high scl = low break stop condition
;    // sda = high scl = high break stop condition
;    if((PIN_USI & _BV(PIN_USI_SDA))){ // stop condition
	SBIS 0x16,5
	RJMP _0x8
;        twi_reset();
	RCALL _twi_reset_G000
;        return;
	RJMP _0xC4
;    }
;
;    of_state = of_state_check_address;
_0x8:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
;    ss_state = ss_state_after_start;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
;    USIDR = 0xff;
	LDI  R30,LOW(255)
	OUT  0xF,R30
;    USICR =
;            (1 << USISIE) | // enable start condition interrupt
;            (1 << USIOIE) | // enable overflow interrupt
;            (1 << USIWM1) | (1 << USIWM0) | // set usi in two-wire mode, enable bit counter overflow hold
;            (1 << USICS1) | (0 << USICS0) | (0 << USICLK) | // shift register clock source = external, positive edge, 4-bit counter source = external, both edges
;            (0 << USITC); // don't toggle clock-port pin
	LDI  R30,LOW(248)
	OUT  0xD,R30
;    USISR =
;            (1    << USISIF) | // clear start condition flag
;            (1    << USIOIF) | // clear overflow condition flag
;            (0    << USIPF) | // !clear stop condition flag
;            (1    << USIDC) | // clear arbitration error flag
;            (0x00 << USICNT0); // set counter to "8" bits
	LDI  R30,LOW(208)
	OUT  0xE,R30
;}
	RJMP _0xC4
;
;
;// USI counter overflow interrupt service routine
;interrupt [USI_OVERFLOW] void usi_ovf_isr(void){
_usi_ovf_isr:
	RCALL SUBOPT_0x0
;    // bit shift register overflow condition occured
;    // scl forced low until overflow condition is cleared!
;    uint8_t data = USIDR;
;    uint8_t set_counter = 0x00; // send 8 bits (16 edges)
;again:
	RCALL __SAVELOCR2
;	data -> R17
;	set_counter -> R16
	IN   R17,15
	LDI  R16,0
_0x9:
;    switch(of_state){
	LDS  R30,_of_state_G000
	RCALL SUBOPT_0x3
;    // start condition occured and succeed
;    // check address, if not OK, reset usi
;    // note: not using general call address
;        case(of_state_check_address):{
	SBIW R30,0
	BRNE _0xD
;            uint8_t address;
;            uint8_t direction;
;            direction = data & 0x01;
	SBIW R28,2
;	address -> Y+1
;	direction -> Y+0
	MOV  R30,R17
	ANDI R30,LOW(0x1)
	ST   Y,R30
;            address = (data & 0xfe) >> 1;
	MOV  R30,R17
	ANDI R30,0xFE
	RCALL SUBOPT_0x3
	ASR  R31
	ROR  R30
	STD  Y+1,R30
;            if(address == slave_address){
	LDS  R30,_slave_address_G000
	LDD  R26,Y+1
	CP   R30,R26
	BRNE _0xE
;                ss_state = ss_state_address_selected;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2
;                if(direction){ // read request from master
	LD   R30,Y
	CPI  R30,0
	BREQ _0xF
;                    of_state = of_state_send_data;
	LDI  R30,LOW(1)
	RJMP _0xBE
;                }else{    // write request from master
_0xF:
;                    of_state = of_state_receive_data;
	LDI  R30,LOW(4)
_0xBE:
	STS  _of_state_G000,R30
;                }
;                USIDR = 0x00;
	RCALL SUBOPT_0x4
;                set_counter = 0x0e; // send 1 bit (2 edges)
	LDI  R16,LOW(14)
;                set_sda_to_output(); // initiate send ack
	RCALL _set_sda_to_output_G000
;            }else{
	RJMP _0x11
_0xE:
;                USIDR = 0x00;
	RCALL SUBOPT_0x4
;                set_counter = 0x00;
	LDI  R16,LOW(0)
;                twi_reset_state();
	RCALL _twi_reset_state_G000
;                ss_state = ss_state_address_not_selected;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x2
;            }
_0x11:
;            break;
	ADIW R28,2
	RJMP _0xC
;        }
;        // process read request from master
;        case(of_state_send_data):{
_0xD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x12
;            ss_state = ss_state_data_processed;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2
;            of_state = of_state_request_ack;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1
;            if(output_buffer_current < output_buffer_length){
	LDS  R30,_output_buffer_length_G000
	LDS  R26,_output_buffer_current_G000
	CP   R26,R30
	BRSH _0x13
;                USIDR = output_buffer[output_buffer_current++];
	LDS  R30,_output_buffer_current_G000
	SUBI R30,-LOW(1)
	STS  _output_buffer_current_G000,R30
	SUBI R30,LOW(1)
	SUBI R30,-LOW(_output_buffer_G000)
	LD   R30,Z
	RJMP _0xBF
;            }else{
_0x13:
;                USIDR = 0x00; // no more data, but cannot send "nothing" or "nak"
	LDI  R30,LOW(0)
_0xBF:
	OUT  0xF,R30
;            }
;            set_counter = 0x00;
	LDI  R16,LOW(0)
;            set_sda_to_output(); // initiate send data
	RJMP _0xC0
;            break;
;        }
;        // data sent to master, request ack (or nack) from master
;        case(of_state_request_ack):{
_0x12:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x15
;            of_state = of_state_check_ack;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1
;            USIDR = 0x00;
	RCALL SUBOPT_0x4
;            set_counter = 0x0e; // receive 1 bit (2 edges)
	LDI  R16,LOW(14)
;            set_sda_to_input(); // initiate receive ack
	RCALL _set_sda_to_input_G000
;            break;
	RJMP _0xC
;        }
;        // ack/nack from master received
;        case(of_state_check_ack):{
_0x15:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x16
;            if(data){ // if NACK, the master does not want more data
	CPI  R17,0
	BREQ _0x17
;                of_state = of_state_check_address;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
;                set_counter = 0x00;
	LDI  R16,LOW(0)
;                twi_reset();
	RCALL _twi_reset_G000
;            }else{
	RJMP _0x18
_0x17:
;                of_state = of_state_send_data;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1
;                goto again; // from here we just drop straight into state_send_data
	RJMP _0x9
;            } // don't wait for another overflow interrupt
_0x18:
;            break;
	RJMP _0xC
;        }
;        // process write request from master
;        case(of_state_receive_data):{
_0x16:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x19
;            ss_state = ss_state_data_processed;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2
;            of_state = of_state_store_data_and_send_ack;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x1
;            set_counter = 0x00; // receive 1 bit (2 edges)
	LDI  R16,LOW(0)
;            set_sda_to_input(); // initiate receive data
	RCALL _set_sda_to_input_G000
;            break;
	RJMP _0xC
;        }
;        // data received from master, store it and wait for more data
;        case(of_state_store_data_and_send_ack):{
_0x19:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC
;            of_state = of_state_receive_data;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1
;            if(input_buffer_length < (USI_TWI_BUFFER_SIZE - 1)){
	LDS  R26,_input_buffer_length_G000
	CPI  R26,LOW(0xF)
	BRSH _0x1B
;                input_buffer[input_buffer_length++] = data;
	LDS  R30,_input_buffer_length_G000
	SUBI R30,-LOW(1)
	STS  _input_buffer_length_G000,R30
	SUBI R30,LOW(1)
	SUBI R30,-LOW(_input_buffer_G000)
	ST   Z,R17
;            }
;            USIDR = 0x00;
_0x1B:
	RCALL SUBOPT_0x4
;            set_counter = 0x0e; // send 1 bit (2 edges)
	LDI  R16,LOW(14)
;            set_sda_to_output(); // initiate send ack
_0xC0:
	RCALL _set_sda_to_output_G000
;            break;
;        }
;    }
_0xC:
;    USISR =
;            (0	<< USISIF) | // don't clear start condition flag
;            (1	<< USIOIF) | // clear overflow condition flag
;            (0	<< USIPF) | // don't clear stop condition flag
;            (1	<< USIDC) | // clear arbitration error flag
;            (set_counter << USICNT0); // set counter to 8 or 1 bits
	MOV  R30,R16
	ORI  R30,LOW(0x50)
	OUT  0xE,R30
;}
	RCALL __LOADLOCR2P
	RJMP _0xC4
;
;void usi_twi_slave(uint8_t slave_address_in, uint8_t use_sleep, void (*data_callback_in)(uint8_t input_buffer_length,
;                    const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer),void (*idle_callback_in)(void)){
;    uint8_t	call_datacallback = 0;
;    slave_address = slave_address_in;
;	slave_address_in -> Y+6
;	use_sleep -> Y+5
;	*data_callback_in -> Y+3
;	*idle_callback_in -> Y+1
;	call_datacallback -> R17
;    data_callback = data_callback_in;
;    idle_callback = idle_callback_in;
;    input_buffer_length = 0;
;    output_buffer_length = 0;
;    output_buffer_current = 0;
;    ss_state = ss_state_before_start;
;//    if(use_sleep){
;//        set_sleep_mode(SLEEP_MODE_IDLE);
;//    }
;    twi_init();
;    #asm("sei")
;    for(;;){
;        if(idle_callback){
;            idle_callback();
;        }
;
;        if(use_sleep && (ss_state == ss_state_before_start)){
;            //sleep_mode();
;        }
;
;        if(USISR & _BV(USIPF)){
;            #asm("cli")
;            USISR |= _BV(USIPF); // clear stop condition flag
;            switch(ss_state){
;                case(ss_state_after_start):{
;                    twi_reset();
;                    break;
;                }
;
;                case(ss_state_data_processed):{
;                    call_datacallback = 1;
;                    break;
;                }
;            }
;            ss_state = ss_state_before_start;
;            #asm("sei")
;        }
;        if(call_datacallback){
;            output_buffer_length = 0;
;            output_buffer_current = 0;
;            data_callback(input_buffer_length, input_buffer, &output_buffer_length, output_buffer);
;            input_buffer_length = 0;
;            call_datacallback = 0;
;        }
;    }
;}
;
;#include <configuration.c>
;
;static void configure(void){
; 0000 001E static void configure(void){
_configure_G000:
;    // Input/Output Ports initialization
;    // Port A initialization
;    // Func2=In Func1=Out Func0=Out
;    // State2=T State1=0 State0=0
;    PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;    DDRA=0x03;
	LDI  R30,LOW(3)
	OUT  0x1A,R30
;
;    // Port B initialization
;    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In
;    // State7=T State6=P State5=T State4=P State3=P State2=0 State1=P State0=P
;    PORTB=0b1011011;
	LDI  R30,LOW(91)
	OUT  0x18,R30
;    DDRB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x17,R30
;    //DDRB=0b00000100;
;
;    // Port D initialization
;    // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;    // State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
;    PORTD=0b00000000;
	OUT  0x12,R30
;    DDRD=0b01011111;
	LDI  R30,LOW(95)
	OUT  0x11,R30
;    //DDRD=0b01011111;
;
;    // Timer/Counter 0 initialization
;    // Clock source: System Clock
;    // Clock value: 31.250 kHz
;    // Mode: Fast PWM top=FFh
;    // OC0A output: Non-Inverted PWM
;    // OC0B output: Non-Inverted PWM
;    TCCR0A=0xA3;
	LDI  R30,LOW(163)
	OUT  0x30,R30
;    TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;    OCR0B=OCR0A=TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
	OUT  0x36,R30
	OUT  0x3C,R30
;
;    // Clock value: Timer1 Stopped
;    OCR1BL=OCR1BH=OCR1AL=OCR1AH=ICR1L=ICR1H=TCNT1L=TCNT1H=TCCR1B=TCCR1A=0x00;
	OUT  0x2F,R30
	OUT  0x2E,R30
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x25,R30
	OUT  0x24,R30
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
;
;    // External Interrupt(s) initialization
;    // INT0: Off
;    // INT1: Off
;    // Interrupt on any change on pins PCINT0-7: On
;    GIMSK=0x20;
	LDI  R30,LOW(32)
	OUT  0x3B,R30
;    MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;    PCMSK=0b1011011;
	LDI  R30,LOW(91)
	OUT  0x20,R30
;    EIFR=0x20;
	LDI  R30,LOW(32)
	OUT  0x3A,R30
;
;    // Timer(s)/Counter(s) Interrupt(s) initialization
;    TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
;
;    // Analog Comparator: Off
;    ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;}
	RET
;
;#include <delay.h>
;
;#define TWI_ADDRESS         0b1000000
;#define LedDelay            50
;eeprom ui16 pwmValues     = 0;
;eeprom ui8  settingTarget = 0;
;
;ui8 outputStates           = 0;
;ui8 lastPortBValue         = 0;
;
;
;void setOut1StateTo(ui8 isOn);
;void setOut2StateTo(ui8 isOn);
;void savePwmValues(void);
;
;static void responde(uint8_t *output_buffer_length, uint8_t *output_buffer){
; 0000 002E static void responde(uint8_t *output_buffer_length, uint8_t *output_buffer){
; 0000 002F     *output_buffer_length = 3;
;	*output_buffer_length -> Y+1
;	*output_buffer -> Y+0
; 0000 0030     output_buffer[0] = OCR0A;
; 0000 0031     output_buffer[1] = OCR0B;
; 0000 0032     output_buffer[2] = outputStates;
; 0000 0033 }
;static void on_twi_receive(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
; 0000 0034 static void on_twi_receive(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
; 0000 0035     if(input_buffer_length != 2){
;	input_buffer_length -> Y+3
;	*input_buffer -> Y+2
;	*output_buffer_length -> Y+1
;	*output_buffer -> Y+0
; 0000 0036         responde(output_buffer_length, output_buffer);
; 0000 0037         return;
; 0000 0038     }
; 0000 0039 
; 0000 003A     if(input_buffer[0] & 1){//zero bit
; 0000 003B         setOut1StateTo(input_buffer[1] & 1);
; 0000 003C     }else if(input_buffer[0] & 2){// first
; 0000 003D         setOut2StateTo(input_buffer[1] & 1);
; 0000 003E     }else if(input_buffer[0] & 4){
; 0000 003F         OCR0A = input_buffer[1];
; 0000 0040         savePwmValues();
; 0000 0041     }else if(input_buffer[0] & 8){
; 0000 0042         OCR0B = input_buffer[1];
; 0000 0043         savePwmValues();
; 0000 0044     }
; 0000 0045     responde(output_buffer_length, output_buffer);
; 0000 0046 }
;
;void restorePwmValues(void){
; 0000 0048 void restorePwmValues(void){
_restorePwmValues:
; 0000 0049     OCR0A = (ui8) (pwmValues >> 8);
	LDI  R26,LOW(_pwmValues)
	LDI  R27,HIGH(_pwmValues)
	RCALL __EEPROMRDW
	MOV  R30,R31
	LDI  R31,0
	OUT  0x36,R30
; 0000 004A     OCR0B = (ui8) pwmValues;
	LDI  R26,LOW(_pwmValues)
	LDI  R27,HIGH(_pwmValues)
	RCALL __EEPROMRDB
	OUT  0x3C,R30
; 0000 004B }
	RET
;
;void savePwmValues(void){
; 0000 004D void savePwmValues(void){
_savePwmValues:
; 0000 004E     ui16 buffer = 0;
; 0000 004F 
; 0000 0050     buffer = OCR0A;
	RCALL __SAVELOCR2
;	buffer -> R16,R17
	__GETWRN 16,17,0
	IN   R16,54
	CLR  R17
; 0000 0051     buffer = buffer << 8;
	MOV  R17,R16
	CLR  R16
; 0000 0052     buffer |= OCR0B;
	IN   R30,0x3C
	RCALL SUBOPT_0x3
	__ORWRR 16,17,30,31
; 0000 0053     pwmValues = buffer;
	MOVW R30,R16
	LDI  R26,LOW(_pwmValues)
	LDI  R27,HIGH(_pwmValues)
	RCALL __EEPROMWRW
; 0000 0054 }
	RCALL __LOADLOCR2P
	RET
;
;static void increasePwm(void){
; 0000 0056 static void increasePwm(void){
_increasePwm_G000:
; 0000 0057     if(!settingTarget){
	RCALL SUBOPT_0x5
	BRNE _0x32
; 0000 0058         if(OCR0A > 0xFD) OCR0A = 0xFF;
	IN   R30,0x36
	CPI  R30,LOW(0xFE)
	BRLO _0x33
	LDI  R30,LOW(255)
	OUT  0x36,R30
; 0000 0059         if(OCR0A < 0xFF){
_0x33:
	IN   R30,0x36
	CPI  R30,LOW(0xFF)
	BRSH _0x34
; 0000 005A             OCR0A += 2;
	IN   R30,0x36
	SUBI R30,-LOW(2)
	OUT  0x36,R30
; 0000 005B         }
; 0000 005C     }else{
_0x34:
	RJMP _0x35
_0x32:
; 0000 005D         if(OCR0B > 0xFD) OCR0B = 0xFF;
	IN   R30,0x3C
	CPI  R30,LOW(0xFE)
	BRLO _0x36
	LDI  R30,LOW(255)
	OUT  0x3C,R30
; 0000 005E         if(OCR0B < 0xFF){
_0x36:
	IN   R30,0x3C
	CPI  R30,LOW(0xFF)
	BRSH _0x37
; 0000 005F             OCR0B += 2;
	IN   R30,0x3C
	SUBI R30,-LOW(2)
	OUT  0x3C,R30
; 0000 0060         }
; 0000 0061     }
_0x37:
_0x35:
; 0000 0062     savePwmValues();
	RJMP _0x2000003
; 0000 0063 }
;
;static void decreasePwm(void){
; 0000 0065 static void decreasePwm(void){
_decreasePwm_G000:
; 0000 0066     if(!settingTarget){
	RCALL SUBOPT_0x5
	BRNE _0x38
; 0000 0067         if(OCR0A == 1) OCR0A = 0;
	IN   R30,0x36
	CPI  R30,LOW(0x1)
	BRNE _0x39
	LDI  R30,LOW(0)
	OUT  0x36,R30
; 0000 0068         if(OCR0A > 0)
_0x39:
	IN   R30,0x36
	CPI  R30,LOW(0x1)
	BRLO _0x3A
; 0000 0069             OCR0A -= 2;
	IN   R30,0x36
	RCALL SUBOPT_0x3
	SBIW R30,2
	OUT  0x36,R30
; 0000 006A     }else{
_0x3A:
	RJMP _0x3B
_0x38:
; 0000 006B         if(OCR0B == 1) OCR0B = 0;
	IN   R30,0x3C
	CPI  R30,LOW(0x1)
	BRNE _0x3C
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 006C         if(OCR0B > 0)
_0x3C:
	IN   R30,0x3C
	CPI  R30,LOW(0x1)
	BRLO _0x3D
; 0000 006D             OCR0B -= 2;
	IN   R30,0x3C
	RCALL SUBOPT_0x3
	SBIW R30,2
	OUT  0x3C,R30
; 0000 006E     }
_0x3D:
_0x3B:
; 0000 006F     savePwmValues();
_0x2000003:
	RCALL _savePwmValues
; 0000 0070 }
	RET
;
;void toggleTarget(void){
; 0000 0072 void toggleTarget(void){
_toggleTarget:
; 0000 0073     settingTarget = !settingTarget;
	LDI  R26,LOW(_settingTarget)
	LDI  R27,HIGH(_settingTarget)
	RCALL __EEPROMRDB
	RCALL __LNEGB1
	LDI  R26,LOW(_settingTarget)
	LDI  R27,HIGH(_settingTarget)
	RCALL __EEPROMWRB
; 0000 0074 }
	RET
;
;void turnOut1On(void){
; 0000 0076 void turnOut1On(void){
_turnOut1On:
; 0000 0077     DDRB |= 0b00000100;
	SBI  0x17,2
; 0000 0078     outputStates |= 0b00000001;
	LDI  R30,LOW(1)
	OR   R5,R30
; 0000 0079 }
	RET
;void turnOut1Off(void){
; 0000 007A void turnOut1Off(void){
_turnOut1Off:
; 0000 007B     DDRB &= 0b11111011; //To disable output just configuring it as an input
	CBI  0x17,2
; 0000 007C     outputStates &= 0b11111110;
	LDI  R30,LOW(254)
	RJMP _0x2000002
; 0000 007D }
;void setOut1StateTo(ui8 isOn){
; 0000 007E void setOut1StateTo(ui8 isOn){
_setOut1StateTo:
; 0000 007F     if(isOn)
;	isOn -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x3E
; 0000 0080         turnOut1On();
	RCALL _turnOut1On
; 0000 0081     else
	RJMP _0x3F
_0x3E:
; 0000 0082         turnOut1Off();
	RCALL _turnOut1Off
; 0000 0083 }
_0x3F:
	RJMP _0x2000001
;void toggleOut1State(void){
; 0000 0084 void toggleOut1State(void){
_toggleOut1State:
; 0000 0085     setOut1StateTo(!(outputStates & 1));
	MOV  R30,R5
	ANDI R30,LOW(0x1)
	RCALL __LNEGB1
	ST   -Y,R30
	RCALL _setOut1StateTo
; 0000 0086 }
	RET
;
;void turnOut2On(void){
; 0000 0088 void turnOut2On(void){
_turnOut2On:
; 0000 0089     outputStates |= 0b00000010;
	LDI  R30,LOW(2)
	OR   R5,R30
; 0000 008A     DDRD |= 0b00100000;
	SBI  0x11,5
; 0000 008B }
	RET
;void turnOut2Off(void){
; 0000 008C void turnOut2Off(void){
_turnOut2Off:
; 0000 008D      DDRD &= 0b11011111;
	CBI  0x11,5
; 0000 008E      outputStates &= 0b11111101;
	LDI  R30,LOW(253)
_0x2000002:
	AND  R5,R30
; 0000 008F }
	RET
;void setOut2StateTo(ui8 isOn){
; 0000 0090 void setOut2StateTo(ui8 isOn){
_setOut2StateTo:
; 0000 0091     if(isOn)
;	isOn -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x40
; 0000 0092         turnOut2On();
	RCALL _turnOut2On
; 0000 0093     else
	RJMP _0x41
_0x40:
; 0000 0094         turnOut2Off();
	RCALL _turnOut2Off
; 0000 0095 }
_0x41:
_0x2000001:
	ADIW R28,1
	RET
;void toggleOut2State(void){
; 0000 0096 void toggleOut2State(void){
_toggleOut2State:
; 0000 0097     setOut2StateTo(!(outputStates & 2));
	MOV  R30,R5
	ANDI R30,LOW(0x2)
	RCALL __LNEGB1
	ST   -Y,R30
	RCALL _setOut2StateTo
; 0000 0098 }
	RET
;
;
;// Pin change 0-7 interrupt service routine
;interrupt [PC_INT] void pin_change_isr0(void){
; 0000 009C interrupt [12] void pin_change_isr0(void){
_pin_change_isr0:
	RCALL SUBOPT_0x0
; 0000 009D     if(BV(lastPortBValue,4) != BV(PINB,4)){
	MOV  R30,R4
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	CP   R30,R26
	BREQ _0x42
; 0000 009E         if(!BV(PINB, 4)){
	IN   R30,0x16
	RCALL SUBOPT_0x6
	BRNE _0x43
; 0000 009F             if(BV(PINB, 3))
	RCALL SUBOPT_0x8
	BREQ _0x44
; 0000 00A0                 decreasePwm();//1
	RCALL _decreasePwm_G000
; 0000 00A1             else
	RJMP _0x45
_0x44:
; 0000 00A2                 increasePwm();//2
	RCALL _increasePwm_G000
; 0000 00A3         }else{
_0x45:
	RJMP _0x46
_0x43:
; 0000 00A4             if(BV(PINB, 3))
	RCALL SUBOPT_0x8
	BREQ _0x47
; 0000 00A5                 increasePwm();
	RCALL _increasePwm_G000
; 0000 00A6             else
	RJMP _0x48
_0x47:
; 0000 00A7                 decreasePwm();
	RCALL _decreasePwm_G000
; 0000 00A8         }
_0x48:
_0x46:
; 0000 00A9     }else if(BV(lastPortBValue,3) != BV(PINB,3)){
	RJMP _0x49
_0x42:
	MOV  R30,R4
	RCALL SUBOPT_0x3
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x3
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	CP   R30,R26
	BRNE _0x4B
; 0000 00AA 
; 0000 00AB     }else if((BV(lastPortBValue, 6) != BV(PINB,6)) && BV(PINB, 6)){
	MOV  R26,R4
	LDI  R27,0
	LDI  R30,LOW(6)
	RCALL __ASRW12
	ANDI R30,LOW(0x1)
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x9
	CP   R30,R26
	BREQ _0x4D
	IN   R30,0x16
	RCALL SUBOPT_0x9
	BRNE _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00AC         toggleTarget();
	RCALL _toggleTarget
; 0000 00AD     }else if(((lastPortBValue & (1<<1)) != (PINB & (1<<1))) && !PINB.1){
	RJMP _0x4F
_0x4C:
	MOV  R30,R4
	ANDI R30,LOW(0x2)
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x2)
	CP   R30,R26
	BREQ _0x51
	SBIS 0x16,1
	RJMP _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00AE         toggleOut1State();
	RCALL _toggleOut1State
; 0000 00AF     }else if(((lastPortBValue & 1) != (PINB & 1)) && !PINB.0){
	RJMP _0x53
_0x50:
	MOV  R30,R4
	ANDI R30,LOW(0x1)
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x1)
	CP   R30,R26
	BREQ _0x55
	SBIS 0x16,0
	RJMP _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 00B0         toggleOut2State();
	RCALL _toggleOut2State
; 0000 00B1     }
; 0000 00B2     lastPortBValue = PINB;
_0x54:
_0x53:
_0x4F:
_0x4B:
_0x49:
	IN   R4,22
; 0000 00B3 }
_0xC4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void displayVal(ui8 val){
; 0000 00B5 void displayVal(ui8 val){
_displayVal:
; 0000 00B6     ui8 value;
; 0000 00B7     if(val > 128){
	ST   -Y,R17
;	val -> Y+1
;	value -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x81)
	BRLO _0x57
; 0000 00B8         value = (val - 128) / 25;
	LDD  R30,Y+1
	RCALL SUBOPT_0x3
	SUBI R30,LOW(128)
	SBCI R31,HIGH(128)
	MOVW R26,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RCALL __DIVW21
	MOV  R17,R30
; 0000 00B9         switch(value){
	MOV  R30,R17
	RCALL SUBOPT_0x3
; 0000 00BA             case(1):{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5B
; 0000 00BB //                PORTD.0 = 1;
; 0000 00BC                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 00BD                 PORTD.1 = 0;
	RCALL SUBOPT_0xA
; 0000 00BE                 PORTA.1 = 0;
; 0000 00BF                 PORTA.0 = 0;
; 0000 00C0                 PORTD.2 = 0;
; 0000 00C1                 break;
	RJMP _0x5A
; 0000 00C2             }
; 0000 00C3             case(2):{
_0x5B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x66
; 0000 00C4 //                PORTD.0 = 1;
; 0000 00C5                 PORTD.6 = 1;
	RCALL SUBOPT_0xB
; 0000 00C6                 PORTD.1 = 1;
; 0000 00C7                 PORTA.1 = 0;
	CBI  0x1B,1
; 0000 00C8                 PORTA.0 = 0;
	CBI  0x1B,0
; 0000 00C9                 PORTD.2 = 0;
	CBI  0x12,2
; 0000 00CA                 break;
	RJMP _0x5A
; 0000 00CB             }
; 0000 00CC             case(3):{
_0x66:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x71
; 0000 00CD //                PORTD.0 = 1;
; 0000 00CE                 PORTD.6 = 1;
	RCALL SUBOPT_0xB
; 0000 00CF                 PORTD.1 = 1;
; 0000 00D0                 PORTA.1 = 1;
	SBI  0x1B,1
; 0000 00D1                 PORTA.0 = 0;
	CBI  0x1B,0
; 0000 00D2                 PORTD.2 = 0;
	CBI  0x12,2
; 0000 00D3                 break;
	RJMP _0x5A
; 0000 00D4             }
; 0000 00D5             case(4):{
_0x71:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x7C
; 0000 00D6 //                PORTD.0 = 1;
; 0000 00D7                 PORTD.6 = 1;
	RCALL SUBOPT_0xB
; 0000 00D8                 PORTD.1 = 1;
; 0000 00D9                 PORTA.1 = 1;
	SBI  0x1B,1
; 0000 00DA                 PORTA.0 = 1;
	SBI  0x1B,0
; 0000 00DB                 PORTD.2 = 0;
	CBI  0x12,2
; 0000 00DC                 break;
	RJMP _0x5A
; 0000 00DD             }
; 0000 00DE             case(5):{
_0x7C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5A
; 0000 00DF //                PORTD.0 = 1;
; 0000 00E0                 PORTD.6 = 1;
	RCALL SUBOPT_0xB
; 0000 00E1                 PORTD.1 = 1;
; 0000 00E2                 PORTA.1 = 1;
	SBI  0x1B,1
; 0000 00E3                 PORTA.0 = 1;
	SBI  0x1B,0
; 0000 00E4                 PORTD.2 = 1;
	SBI  0x12,2
; 0000 00E5                 break;
; 0000 00E6             }
; 0000 00E7         }
_0x5A:
; 0000 00E8     }else{
	RJMP _0x92
_0x57:
; 0000 00E9         PORTD.6 = 0;
	CBI  0x12,6
; 0000 00EA         PORTD.0 = 0;
	CBI  0x12,0
; 0000 00EB         PORTD.1 = 0;
	RCALL SUBOPT_0xA
; 0000 00EC         PORTA.1 = 0;
; 0000 00ED         PORTA.0 = 0;
; 0000 00EE         PORTD.2 = 0;
; 0000 00EF     }
_0x92:
; 0000 00F0 
; 0000 00F1 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void main(void){
; 0000 00F3 void main(void){
_main:
; 0000 00F4 ui8 toggler = 0;
; 0000 00F5 ui16 counter = 0;
; 0000 00F6     // Crystal Oscillator division factor: 1
; 0000 00F7 #pragma optsize-
; 0000 00F8 CLKPR=0x80;
;	toggler -> R17
;	counter -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00F9 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00FA #ifdef _OPTIMIZE_SIZE_
; 0000 00FB #pragma optsize+
; 0000 00FC #endif
; 0000 00FD 
; 0000 00FE     configure();
	RCALL _configure_G000
; 0000 00FF 
; 0000 0100     restorePwmValues();
	RCALL _restorePwmValues
; 0000 0101 
; 0000 0102    // usi_twi_slave(TWI_ADDRESS, 0, on_twi_receive, NULL);
; 0000 0103     #asm("sei")
	sei
; 0000 0104 
; 0000 0105     while (1){
_0x9F:
; 0000 0106 
; 0000 0107         if(!settingTarget){
	RCALL SUBOPT_0x5
	BRNE _0xA2
; 0000 0108 
; 0000 0109             if(!!(outputStates & 1))
	SBRS R5,0
	RJMP _0xA3
; 0000 010A                 PORTD.3 = (counter > 400);
	RCALL SUBOPT_0xC
	RCALL __GTW12U
	CPI  R30,0
	BRNE _0xA4
	CBI  0x12,3
	RJMP _0xA5
_0xA4:
	SBI  0x12,3
_0xA5:
; 0000 010B             else
	RJMP _0xA6
_0xA3:
; 0000 010C                 PORTD.3 = (counter < 400);
	RCALL SUBOPT_0xC
	RCALL __LTW12U
	CPI  R30,0
	BRNE _0xA7
	CBI  0x12,3
	RJMP _0xA8
_0xA7:
	SBI  0x12,3
_0xA8:
; 0000 010D 
; 0000 010E             PORTD.4 = !!(outputStates & 2);
_0xA6:
	SBRC R5,1
	RJMP _0xA9
	CBI  0x12,4
	RJMP _0xAA
_0xA9:
	SBI  0x12,4
_0xAA:
; 0000 010F 
; 0000 0110 
; 0000 0111             if(OCR0A > 133)
	IN   R30,0x36
	CPI  R30,LOW(0x86)
	BRLO _0xAB
; 0000 0112                 displayVal(OCR0A);
	IN   R30,0x36
	RJMP _0xC2
; 0000 0113             else if(counter > 8000)
_0xAB:
	__CPWRN 18,19,8001
	BRLO _0xAD
; 0000 0114                 displayVal(OCR0A + 120);
	IN   R30,0x36
	SUBI R30,-LOW(120)
	RJMP _0xC2
; 0000 0115             else
_0xAD:
; 0000 0116                 displayVal(0);
	LDI  R30,LOW(0)
_0xC2:
	ST   -Y,R30
	RCALL _displayVal
; 0000 0117 
; 0000 0118         }else{
	RJMP _0xAF
_0xA2:
; 0000 0119             PORTD.3 = !!(outputStates & 1);
	SBRC R5,0
	RJMP _0xB0
	CBI  0x12,3
	RJMP _0xB1
_0xB0:
	SBI  0x12,3
_0xB1:
; 0000 011A 
; 0000 011B             if(!!(outputStates & 2))
	SBRS R5,1
	RJMP _0xB2
; 0000 011C                 PORTD.4 = (counter > 400);
	RCALL SUBOPT_0xC
	RCALL __GTW12U
	CPI  R30,0
	BRNE _0xB3
	CBI  0x12,4
	RJMP _0xB4
_0xB3:
	SBI  0x12,4
_0xB4:
; 0000 011D             else
	RJMP _0xB5
_0xB2:
; 0000 011E                 PORTD.4 = (counter < 400);
	RCALL SUBOPT_0xC
	RCALL __LTW12U
	CPI  R30,0
	BRNE _0xB6
	CBI  0x12,4
	RJMP _0xB7
_0xB6:
	SBI  0x12,4
_0xB7:
; 0000 011F 
; 0000 0120             if(OCR0B > 133)
_0xB5:
	IN   R30,0x3C
	CPI  R30,LOW(0x86)
	BRLO _0xB8
; 0000 0121                 displayVal(OCR0B);
	IN   R30,0x3C
	RJMP _0xC3
; 0000 0122             else if(counter > 8000)
_0xB8:
	__CPWRN 18,19,8001
	BRLO _0xBA
; 0000 0123                 displayVal(OCR0B + 120);
	IN   R30,0x3C
	SUBI R30,-LOW(120)
	RJMP _0xC3
; 0000 0124             else
_0xBA:
; 0000 0125                 displayVal(0);;
	LDI  R30,LOW(0)
_0xC3:
	ST   -Y,R30
	RCALL _displayVal
; 0000 0126         }
_0xAF:
; 0000 0127 
; 0000 0128         counter++;
	__ADDWRN 18,19,1
; 0000 0129         if(counter >= 16000) counter = 0;
	__CPWRN 18,19,16000
	BRLO _0xBC
	__GETWRN 18,19,0
; 0000 012A 
; 0000 012B         //PORTD.3 = !!(outputStates & 1);//0
; 0000 012C         //PORTD.4 = !!(outputStates & 2);//1
; 0000 012D         //if(!settingTarget){
; 0000 012E         //    displayVal(OCR0A);
; 0000 012F         //}else{
; 0000 0130         //    if(toggler)
; 0000 0131         //        displayVal(OCR0B);
; 0000 0132         //    else
; 0000 0133         //        displayVal(0);
; 0000 0134         //    toggler = !toggler;
; 0000 0135         //    delay_ms(LedDelay);
; 0000 0136         //}
; 0000 0137     };
_0xBC:
	RJMP _0x9F
; 0000 0138 }
_0xBD:
	RJMP _0xBD

	.DSEG
_idle_callback_G000:
	.BYTE 0x2
_data_callback_G000:
	.BYTE 0x2
_of_state_G000:
	.BYTE 0x1
_ss_state_G000:
	.BYTE 0x1
_slave_address_G000:
	.BYTE 0x1
_input_buffer_G000:
	.BYTE 0x10
_input_buffer_length_G000:
	.BYTE 0x1
_output_buffer_G000:
	.BYTE 0x10
_output_buffer_length_G000:
	.BYTE 0x1
_output_buffer_current_G000:
	.BYTE 0x1

	.ESEG
_pwmValues:
	.DW  0x0
_settingTarget:
	.DB  0x0

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	STS  _of_state_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	STS  _ss_state_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x3:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	OUT  0xF,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_settingTarget)
	LDI  R27,HIGH(_settingTarget)
	RCALL __EEPROMRDB
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x3
	RCALL __ASRW4
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	MOV  R26,R30
	IN   R30,0x16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	IN   R30,0x16
	RCALL SUBOPT_0x3
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x3
	RCALL __ASRW2
	RCALL __ASRW4
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CBI  0x12,1
	CBI  0x1B,1
	CBI  0x1B,0
	CBI  0x12,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	SBI  0x12,6
	SBI  0x12,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	MOVW R26,R18
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__GTW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLO __GTW12UT
	CLR  R30
__GTW12UT:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
