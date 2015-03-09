
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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usi_start_isr
	RJMP _usi_ovf_isr
	RJMP 0x00
	RJMP 0x00

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
;Project :
;Version :
;Date    : 3/8/2015
;Author  : NeVaDa
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
;#include <generalCompatabilityDefinitions.c>
;#define _BV(bit)    (1 << (bit))
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
; 0000 001A static void set_sda_to_input(void){

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
_twi_init_G000:
;    #if defined(USIPP)
;        #if defined(USI_ON_PORT_A)
;            USIPP |= _BV(USIPOS);
;        #else
;            USIPP &= ~_BV(USIPOS);
;        # endif
;    #endif
;    twi_reset();
	RCALL _twi_reset_G000
;}
	RET
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
	RJMP _0x3D
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
	RJMP _0x3D
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
	RJMP _0x38
;                }else{    // write request from master
_0xF:
;                    of_state = of_state_receive_data;
	LDI  R30,LOW(4)
_0x38:
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
	RJMP _0x39
;            }else{
_0x13:
;                USIDR = 0x00; // no more data, but cannot send "nothing" or "nak"
	LDI  R30,LOW(0)
_0x39:
	OUT  0xF,R30
;            }
;            set_counter = 0x00;
	LDI  R16,LOW(0)
;            set_sda_to_output(); // initiate send data
	RJMP _0x3A
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
_0x3A:
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
_0x3D:
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
;void usi_twi_slave(uint8_t slave_address_in, uint8_t use_sleep, void (*data_callback_in)(uint8_t input_buffer_length,
;                    const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer),void (*idle_callback_in)(void)){
_usi_twi_slave:
;    uint8_t	call_datacallback = 0;
;    slave_address = slave_address_in;
	ST   -Y,R17
;	slave_address_in -> Y+6
;	use_sleep -> Y+5
;	*data_callback_in -> Y+3
;	*idle_callback_in -> Y+1
;	call_datacallback -> R17
	LDI  R17,0
	LDD  R30,Y+6
	STS  _slave_address_G000,R30
;    data_callback = data_callback_in;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	STS  _data_callback_G000,R30
	STS  _data_callback_G000+1,R31
;    idle_callback = idle_callback_in;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	STS  _idle_callback_G000,R30
	STS  _idle_callback_G000+1,R31
;    input_buffer_length = 0;
	LDI  R30,LOW(0)
	STS  _input_buffer_length_G000,R30
;    output_buffer_length = 0;
	RCALL SUBOPT_0x5
;    output_buffer_current = 0;
;    ss_state = ss_state_before_start;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
;//    if(use_sleep){
;//        set_sleep_mode(SLEEP_MODE_IDLE);
;//    }
;    twi_init();
	RCALL _twi_init_G000
;    #asm("sei")
	sei
;    for(;;){
_0x1D:
;        if(idle_callback){
	RCALL SUBOPT_0x6
	SBIW R30,0
	BREQ _0x1F
;            idle_callback();
	RCALL SUBOPT_0x6
	ICALL
;        }
;
;        if(use_sleep && (ss_state == ss_state_before_start)){
_0x1F:
;            //sleep_mode();
;        }
;
;        if(USISR & _BV(USIPF)){
	SBIS 0xE,5
	RJMP _0x23
;            #asm("cli")
	cli
;            USISR |= _BV(USIPF); // clear stop condition flag
	SBI  0xE,5
;            switch(ss_state){
	LDS  R30,_ss_state_G000
	RCALL SUBOPT_0x3
;                case(ss_state_after_start):{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x27
;                    twi_reset();
	RCALL _twi_reset_G000
;                    break;
	RJMP _0x26
;                }
;
;                case(ss_state_data_processed):{
_0x27:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x26
;                    call_datacallback = 1;
	LDI  R17,LOW(1)
;                    break;
;                }
;            }
_0x26:
;            ss_state = ss_state_before_start;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
;            #asm("sei")
	sei
;        }
;        if(call_datacallback){
_0x23:
	CPI  R17,0
	BREQ _0x29
;            output_buffer_length = 0;
	RCALL SUBOPT_0x5
;            output_buffer_current = 0;
;            data_callback(input_buffer_length, input_buffer, &output_buffer_length, output_buffer);
	LDI  R30,LOW(_data_callback_G000)
	LDI  R31,HIGH(_data_callback_G000)
	MOV  R26,R30
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	LDS  R30,_input_buffer_length_G000
	ST   -Y,R30
	LDI  R30,LOW(_input_buffer_G000)
	ST   -Y,R30
	LDI  R30,LOW(_output_buffer_length_G000)
	ST   -Y,R30
	LDI  R30,LOW(_output_buffer_G000)
	ST   -Y,R30
	POP  R30
	POP  R31
	ICALL
;            input_buffer_length = 0;
	LDI  R30,LOW(0)
	STS  _input_buffer_length_G000,R30
;            call_datacallback = 0;
	LDI  R17,LOW(0)
;        }
;    }
_0x29:
	RJMP _0x1D
;}
;#include <uartHelper.c>
;void transmit(char data){
; 0000 001B void transmit(char data){
_transmit:
;    while(!(UCSRA & (1 << UDRE))){}
;	data -> Y+0
_0x2A:
	SBIS 0xB,5
	RJMP _0x2A
;    UDR=data;
	LD   R30,Y
	OUT  0xC,R30
;}
	ADIW R28,1
	RET
;void transmitInt(int data){
;    int number = 0;
;    char str = '';
;    if(data < 10){
;	data -> Y+4
;	number -> R16,R17
;	str -> R19
;        str = data + '0';
;        transmit(str);
;    }else if(data < 100){
;        number = data / 10;
;        transmit(number + '0');
;        number = data - (number*10);
;        transmit(number + '0');
;    }else if(data < 1000){
;        number = data / 100;
;        transmit(number + '0');
;        data = data - (number * 100);
;        number = data / 10;
;        transmit(number + '0');
;        number = data - (number*10);
;        transmit(number + '0');
;    }
;}
;
;
;
;static void my_twi_callback(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
; 0000 001F static void my_twi_callback(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
_my_twi_callback_G000:
; 0000 0020                         uint8_t l = 1;
; 0000 0021                         uint8_t b = 5;
; 0000 0022 
; 0000 0023                         PORTD.5 = !PORTD.5;
	RCALL __SAVELOCR2
;	input_buffer_length -> Y+5
;	*input_buffer -> Y+4
;	*output_buffer_length -> Y+3
;	*output_buffer -> Y+2
;	l -> R17
;	b -> R16
	LDI  R17,1
	LDI  R16,5
	SBIS 0x12,5
	RJMP _0x32
	CBI  0x12,5
	RJMP _0x33
_0x32:
	SBI  0x12,5
_0x33:
; 0000 0024                         transmit(input_buffer_length);
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _transmit
; 0000 0025                         transmit(input_buffer[0]);
	LDD  R26,Y+4
	LD   R30,X
	ST   -Y,R30
	RCALL _transmit
; 0000 0026                         transmit(input_buffer[1]);
	LDD  R30,Y+4
	LDD  R26,Z+1
	ST   -Y,R26
	RCALL _transmit
; 0000 0027 
; 0000 0028 
; 0000 0029                         b = input_buffer[0];
	LDD  R26,Y+4
	LD   R16,X
; 0000 002A                         b++;
	SUBI R16,-1
; 0000 002B 
; 0000 002C                         *output_buffer_length = l;
	LDD  R26,Y+3
	ST   X,R17
; 0000 002D                         output_buffer[0] = b;
	LDD  R26,Y+2
	ST   X,R16
; 0000 002E }
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0034 {
_main:
; 0000 0035 // Declare your local variables here
; 0000 0036 
; 0000 0037 // Crystal Oscillator division factor: 1
; 0000 0038 #pragma optsize-
; 0000 0039 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 003A CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 003B #ifdef _OPTIMIZE_SIZE_
; 0000 003C #pragma optsize+
; 0000 003D #endif
; 0000 003E 
; 0000 003F // Input/Output Ports initialization
; 0000 0040 // Port A initialization
; 0000 0041 // Func2=In Func1=In Func0=In
; 0000 0042 // State2=T State1=T State0=T
; 0000 0043 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0044 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0045 
; 0000 0046 // Port B initialization
; 0000 0047 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0048 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0049 PORTB=0b00000100;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 004A DDRB=0b00000100;
	OUT  0x17,R30
; 0000 004B 
; 0000 004C // Port D initialization
; 0000 004D 
; 0000 004E PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 004F DDRD=0b00100000;
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 0050 
; 0000 0051 // Timer/Counter 0 initialization
; 0000 0052 // Clock source: System Clock
; 0000 0053 // Clock value: Timer 0 Stopped
; 0000 0054 // Mode: Normal top=FFh
; 0000 0055 // OC0A output: Disconnected
; 0000 0056 // OC0B output: Disconnected
; 0000 0057 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0058 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 0059 TCNT0=0x00;
	OUT  0x32,R30
; 0000 005A OCR0A=0x00;
	OUT  0x36,R30
; 0000 005B OCR0B=0x00;
	OUT  0x3C,R30
; 0000 005C 
; 0000 005D // Timer/Counter 1 initialization
; 0000 005E // Clock source: System Clock
; 0000 005F // Clock value: Timer1 Stopped
; 0000 0060 // Mode: Normal top=FFFFh
; 0000 0061 // OC1A output: Discon.
; 0000 0062 // OC1B output: Discon.
; 0000 0063 // Noise Canceler: Off
; 0000 0064 // Input Capture on Falling Edge
; 0000 0065 // Timer1 Overflow Interrupt: Off
; 0000 0066 // Input Capture Interrupt: Off
; 0000 0067 // Compare A Match Interrupt: Off
; 0000 0068 // Compare B Match Interrupt: Off
; 0000 0069 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 006A TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 006B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 006C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 006D ICR1H=0x00;
	OUT  0x25,R30
; 0000 006E ICR1L=0x00;
	OUT  0x24,R30
; 0000 006F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0070 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0071 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0072 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0073 
; 0000 0074 // External Interrupt(s) initialization
; 0000 0075 // INT0: Off
; 0000 0076 // INT1: Off
; 0000 0077 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0078 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0079 MCUCR=0x00;
	OUT  0x35,R30
; 0000 007A 
; 0000 007B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 007C TIMSK=0x00;
	OUT  0x39,R30
; 0000 007D 
; 0000 007E // Universal Serial Interface initialization
; 0000 007F // Mode: Two Wire (I2C)
; 0000 0080 // Clock source: Reg.=ext. pos. edge, Cnt.=USITC
; 0000 0081 // USI Counter Overflow Interrupt: On
; 0000 0082 // USI Start Condition Interrupt: On
; 0000 0083 USICR=0xEA;
	LDI  R30,LOW(234)
	OUT  0xD,R30
; 0000 0084 
; 0000 0085 // USART initialization
; 0000 0086 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0087 // USART Receiver: Off
; 0000 0088 // USART Transmitter: On
; 0000 0089 // USART Mode: Asynchronous
; 0000 008A // USART Baud Rate: 9600
; 0000 008B UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 008C UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 008D UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 008E UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 008F UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0090 
; 0000 0091 // Analog Comparator initialization
; 0000 0092 // Analog Comparator: Off
; 0000 0093 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0094 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0095 // #asm("sei")
; 0000 0096 
; 0000 0097 usi_twi_slave(0b1000000, 0, my_twi_callback, NULL);
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(_my_twi_callback_G000)
	LDI  R31,HIGH(_my_twi_callback_G000)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _usi_twi_slave
; 0000 0098 transmit(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _transmit
; 0000 0099 while (1)
_0x34:
; 0000 009A       {
; 0000 009B       // Place your code here
; 0000 009C       //uint8_t bu = 8;
; 0000 009D                           //output_buffer = 8;
; 0000 009E       };
	RJMP _0x34
; 0000 009F }
_0x37:
	RJMP _0x37

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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	STS  _ss_state_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	OUT  0xF,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _output_buffer_length_G000,R30
	STS  _output_buffer_current_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(_idle_callback_G000)
	LDI  R31,HIGH(_idle_callback_G000)
	MOV  R26,R30
	RCALL __GETW1P
	RET


	.CSEG
__GETW1P:
	LD   R30,X+
	LD   R31,X
	DEC  R26
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
