
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
;
;#define _BV(bit)    (1 << (bit))
;//#define USI_TWI_BUFFER_SIZE 16
;enum{
;    USI_TWI_BUFFER_SIZE = 32
;};
;#ifndef NULL
;    #define NULL 0
;#endif
;
;# define DDR_USI	DDRB
;# define PORT_USI	PORTB
;# define PIN_USI	PINB
;# define PORT_USI_SDA	PINB5
;# define PORT_USI_SCL	PINB7
;# define PIN_USI_SDA	PINB5
;# define PIN_USI_SCL	PINB7
;
;
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
;static void (*idle_callback)(void);
;static void	(*data_callback)(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer);
;
;static uint8_t of_state;
;static uint8_t ss_state;
;static uint8_t	slave_address;
;static uint8_t	input_buffer[USI_TWI_BUFFER_SIZE];
;static uint8_t	input_buffer_length;
;static uint8_t	output_buffer[USI_TWI_BUFFER_SIZE];
;static uint8_t	output_buffer_length;
;static uint8_t	output_buffer_current;
;static uint8_t	stats_enabled;
;static uint16_t	start_conditions_count;
;static uint16_t	stop_conditions_count;
;static uint16_t	error_conditions_count;
;static uint16_t	overflow_conditions_count;
;static uint16_t	local_frames_count;
;static uint16_t	idle_call_count;
;
;
;static	uint8_t	*phy_send_buffer;
;static	uint8_t	*phy_send_buffer_length;
;enum{
;    phy_buffer_size = USI_TWI_BUFFER_SIZE
;};
;
;
;
;
;static void set_sda_to_input(void){
; 0000 005A static void set_sda_to_input(void){

	.CSEG
_set_sda_to_input_G000:
; 0000 005B     DDR_USI &= ~_BV(PORT_USI_SDA);
	CBI  0x17,5
; 0000 005C }
	RET
;static void set_sda_to_output(void){
; 0000 005D static void set_sda_to_output(void){
_set_sda_to_output_G000:
; 0000 005E     DDR_USI |= _BV(PORT_USI_SDA);
	SBI  0x17,5
; 0000 005F }
	RET
;static inline void set_scl_to_input(void){
; 0000 0060 static inline void set_scl_to_input(void){
_set_scl_to_input_G000:
; 0000 0061     DDR_USI &= ~_BV(PORT_USI_SCL);
	CBI  0x17,7
; 0000 0062 }
	RET
;static inline void set_scl_to_output(void){
; 0000 0063 static inline void set_scl_to_output(void){
_set_scl_to_output_G000:
; 0000 0064     DDR_USI |= _BV(PORT_USI_SCL);
	SBI  0x17,7
; 0000 0065 }
	RET
;static inline void set_sda_low(void){
; 0000 0066 static inline void set_sda_low(void){
_set_sda_low_G000:
; 0000 0067     PORT_USI &= ~_BV(PORT_USI_SDA);
	CBI  0x18,5
; 0000 0068 }
	RET
;static inline void set_sda_high(void){
; 0000 0069 static inline void set_sda_high(void){
_set_sda_high_G000:
; 0000 006A     PORT_USI |= _BV(PORT_USI_SDA);
	SBI  0x18,5
; 0000 006B }
	RET
;static inline void set_scl_low(void){
; 0000 006C static inline void set_scl_low(void){
_set_scl_low_G000:
; 0000 006D     PORT_USI &= ~_BV(PORT_USI_SCL);
	CBI  0x18,7
; 0000 006E }
	RET
;static inline void set_scl_high(void){
; 0000 006F static inline void set_scl_high(void){
_set_scl_high_G000:
; 0000 0070     PORT_USI |= _BV(PORT_USI_SCL);
	SBI  0x18,7
; 0000 0071 }
	RET
;
;
;static inline void twi_reset_state(void){
; 0000 0074 static inline void twi_reset_state(void){
_twi_reset_state_G000:
; 0000 0075     USISR =
; 0000 0076             (1	<< USISIF) | // clear start condition flag
; 0000 0077             (1	<< USIOIF) | // clear overflow condition flag
; 0000 0078             (0	<< USIPF) | // !clear stop condition flag
; 0000 0079             (1	<< USIDC) | // clear arbitration error flag
; 0000 007A             (0x00 << USICNT0); // set counter to "8" bits
	LDI  R30,LOW(208)
	OUT  0xE,R30
; 0000 007B     USICR =
; 0000 007C             (1 << USISIE) | // enable start condition interrupt
; 0000 007D             (0 << USIOIE) | // !enable overflow interrupt
; 0000 007E             (1 << USIWM1) | (0 << USIWM0) | // set usi in two-wire mode, disable bit counter overflow hold
; 0000 007F             (1 << USICS1) | (0 << USICS0) | (0 << USICLK) | // shift register clock source = external, positive edge, 4-bit counter source = external, both edges
; 0000 0080             (0 << USITC); // don't toggle clock-port pin
	LDI  R30,LOW(168)
	OUT  0xD,R30
; 0000 0081 }
	RET
;
;static void twi_reset(void){
; 0000 0083 static void twi_reset(void){
_twi_reset_G000:
; 0000 0084 // make sure no sda/scl remains pulled up or down
; 0000 0085     set_sda_to_input(); // deactivate internal pullup on sda/scl
	RCALL _set_sda_to_input_G000
; 0000 0086     set_sda_low();
	RCALL _set_sda_low_G000
; 0000 0087     set_scl_to_input();
	RCALL _set_scl_to_input_G000
; 0000 0088     set_scl_low();
	RCALL _set_scl_low_G000
; 0000 0089     set_sda_to_output(); // release (set high) on sda/scl
	RCALL _set_sda_to_output_G000
; 0000 008A     set_sda_high();
	RCALL _set_sda_high_G000
; 0000 008B     set_sda_to_input();
	RCALL _set_sda_to_input_G000
; 0000 008C     set_sda_high();
	RCALL _set_sda_high_G000
; 0000 008D     set_scl_to_output();
	RCALL _set_scl_to_output_G000
; 0000 008E     set_scl_high();
	RCALL _set_scl_high_G000
; 0000 008F     twi_reset_state();
	RCALL _twi_reset_state_G000
; 0000 0090 }
	RET
;
;static inline void twi_init(void)
; 0000 0093 {
_twi_init_G000:
; 0000 0094     #if defined(USIPP)
; 0000 0095         #if defined(USI_ON_PORT_A)
; 0000 0096             USIPP |= _BV(USIPOS);
; 0000 0097         #else
; 0000 0098             USIPP &= ~_BV(USIPOS);
; 0000 0099         # endif
; 0000 009A     #endif
; 0000 009B     twi_reset();
	RCALL _twi_reset_G000
; 0000 009C }
	RET
;
;
;// USI start condition interrupt service routine
;interrupt [USI_STRT] void usi_start_isr(void){
; 0000 00A0 interrupt [16] void usi_start_isr(void){
_usi_start_isr:
	RCALL SUBOPT_0x0
; 0000 00A1     set_sda_to_input();
	RCALL _set_sda_to_input_G000
; 0000 00A2     // wait for SCL to go low to ensure the start condition has completed (the
; 0000 00A3     // start detector will hold SCL low) - if a stop condition arises then leave
; 0000 00A4     // the interrupt to prevent waiting forever - don't use USISR to test for stop
; 0000 00A5     // condition as in Application Note AVR312 because the stop condition Flag is
; 0000 00A6     // going to be set from the last TWI sequence
; 0000 00A7     while(!(PIN_USI & _BV(PIN_USI_SDA)) && (PIN_USI & _BV(PIN_USI_SCL))){}
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
; 0000 00A8     // possible combinations
; 0000 00A9     // sda = low scl = low break start condition
; 0000 00AA     // sda = low scl = high loop
; 0000 00AB     // sda = high scl = low break stop condition
; 0000 00AC     // sda = high scl = high break stop condition
; 0000 00AD     if((PIN_USI & _BV(PIN_USI_SDA))){ // stop condition
	SBIS 0x16,5
	RJMP _0x8
; 0000 00AE         twi_reset();
	RCALL _twi_reset_G000
; 0000 00AF         if(stats_enabled){
	RCALL SUBOPT_0x1
	BREQ _0x9
; 0000 00B0             error_conditions_count++;
	LDI  R26,LOW(_error_conditions_count_G000)
	RCALL SUBOPT_0x2
; 0000 00B1         }
; 0000 00B2         return;
_0x9:
	RJMP _0x4A
; 0000 00B3     }
; 0000 00B4 
; 0000 00B5     if(stats_enabled){
_0x8:
	RCALL SUBOPT_0x1
	BREQ _0xA
; 0000 00B6         start_conditions_count++;
	LDI  R26,LOW(_start_conditions_count_G000)
	RCALL SUBOPT_0x2
; 0000 00B7     }
; 0000 00B8     of_state = of_state_check_address;
_0xA:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x3
; 0000 00B9     ss_state = ss_state_after_start;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4
; 0000 00BA     USIDR = 0xff;
	LDI  R30,LOW(255)
	OUT  0xF,R30
; 0000 00BB     USICR =
; 0000 00BC             (1 << USISIE) | // enable start condition interrupt
; 0000 00BD             (1 << USIOIE) | // enable overflow interrupt
; 0000 00BE             (1 << USIWM1) | (1 << USIWM0) | // set usi in two-wire mode, enable bit counter overflow hold
; 0000 00BF             (1 << USICS1) | (0 << USICS0) | (0 << USICLK) | // shift register clock source = external, positive edge, 4-bit counter source = external, both edges
; 0000 00C0             (0 << USITC); // don't toggle clock-port pin
	LDI  R30,LOW(248)
	OUT  0xD,R30
; 0000 00C1     USISR =
; 0000 00C2             (1	<< USISIF) | // clear start condition flag
; 0000 00C3             (1	<< USIOIF) | // clear overflow condition flag
; 0000 00C4             (0	<< USIPF) | // !clear stop condition flag
; 0000 00C5             (1	<< USIDC) | // clear arbitration error flag
; 0000 00C6             (0x00 << USICNT0); // set counter to "8" bits
	LDI  R30,LOW(208)
	OUT  0xE,R30
; 0000 00C7 }
	RJMP _0x4A
;
;
;// USI counter overflow interrupt service routine
;interrupt [USI_OVERFLOW] void usi_ovf_isr(void){
; 0000 00CB interrupt [17] void usi_ovf_isr(void){
_usi_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 00CC     // bit shift register overflow condition occured
; 0000 00CD     // scl forced low until overflow condition is cleared!
; 0000 00CE     uint8_t data = USIDR;
; 0000 00CF     uint8_t set_counter = 0x00; // send 8 bits (16 edges)
; 0000 00D0     if(stats_enabled){
	RCALL __SAVELOCR2
;	data -> R17
;	set_counter -> R16
	IN   R17,15
	LDI  R16,0
	RCALL SUBOPT_0x1
	BREQ _0xB
; 0000 00D1         overflow_conditions_count++;
	LDI  R26,LOW(_overflow_conditions_count_G000)
	RCALL SUBOPT_0x2
; 0000 00D2     }
; 0000 00D3 again:
_0xB:
_0xC:
; 0000 00D4     switch(of_state){
	LDS  R30,_of_state_G000
	RCALL SUBOPT_0x5
; 0000 00D5     // start condition occured and succeed
; 0000 00D6     // check address, if not OK, reset usi
; 0000 00D7     // note: not using general call address
; 0000 00D8         case(of_state_check_address):{
	SBIW R30,0
	BRNE _0x10
; 0000 00D9             uint8_t address;
; 0000 00DA             uint8_t direction;
; 0000 00DB             direction = data & 0x01;
	SBIW R28,2
;	address -> Y+1
;	direction -> Y+0
	MOV  R30,R17
	ANDI R30,LOW(0x1)
	ST   Y,R30
; 0000 00DC             address = (data & 0xfe) >> 1;
	MOV  R30,R17
	ANDI R30,0xFE
	RCALL SUBOPT_0x5
	ASR  R31
	ROR  R30
	STD  Y+1,R30
; 0000 00DD             if(address == slave_address){
	LDS  R30,_slave_address_G000
	LDD  R26,Y+1
	CP   R30,R26
	BRNE _0x11
; 0000 00DE                 ss_state = ss_state_address_selected;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x4
; 0000 00DF                 if(direction){ // read request from master
	LD   R30,Y
	CPI  R30,0
	BREQ _0x12
; 0000 00E0                     of_state = of_state_send_data;
	LDI  R30,LOW(1)
	RJMP _0x45
; 0000 00E1                 }else{	// write request from master
_0x12:
; 0000 00E2                     of_state = of_state_receive_data;
	LDI  R30,LOW(4)
_0x45:
	STS  _of_state_G000,R30
; 0000 00E3                 }
; 0000 00E4                 USIDR = 0x00;
	RCALL SUBOPT_0x6
; 0000 00E5                 set_counter = 0x0e; // send 1 bit (2 edges)
	LDI  R16,LOW(14)
; 0000 00E6                 set_sda_to_output(); // initiate send ack
	RCALL _set_sda_to_output_G000
; 0000 00E7             }else{
	RJMP _0x14
_0x11:
; 0000 00E8                 USIDR = 0x00;
	RCALL SUBOPT_0x6
; 0000 00E9                 set_counter = 0x00;
	LDI  R16,LOW(0)
; 0000 00EA                 twi_reset_state();
	RCALL _twi_reset_state_G000
; 0000 00EB                 ss_state = ss_state_address_not_selected;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x4
; 0000 00EC             }
_0x14:
; 0000 00ED             break;
	ADIW R28,2
	RJMP _0xF
; 0000 00EE         }
; 0000 00EF         // process read request from master
; 0000 00F0         case(of_state_send_data):{
_0x10:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x15
; 0000 00F1             ss_state = ss_state_data_processed;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x4
; 0000 00F2             of_state = of_state_request_ack;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3
; 0000 00F3             if(output_buffer_current < output_buffer_length){
	LDS  R30,_output_buffer_length_G000
	LDS  R26,_output_buffer_current_G000
	CP   R26,R30
	BRSH _0x16
; 0000 00F4                 USIDR = output_buffer[output_buffer_current++];
	LDS  R30,_output_buffer_current_G000
	SUBI R30,-LOW(1)
	STS  _output_buffer_current_G000,R30
	SUBI R30,LOW(1)
	SUBI R30,-LOW(_output_buffer_G000)
	LD   R30,Z
	RJMP _0x46
; 0000 00F5             }else{
_0x16:
; 0000 00F6                 USIDR = 0x00; // no more data, but cannot send "nothing" or "nak"
	LDI  R30,LOW(0)
_0x46:
	OUT  0xF,R30
; 0000 00F7             }
; 0000 00F8             set_counter = 0x00;
	LDI  R16,LOW(0)
; 0000 00F9             set_sda_to_output(); // initiate send data
	RJMP _0x47
; 0000 00FA             break;
; 0000 00FB         }
; 0000 00FC         // data sent to master, request ack (or nack) from master
; 0000 00FD         case(of_state_request_ack):{
_0x15:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x18
; 0000 00FE             of_state = of_state_check_ack;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3
; 0000 00FF             USIDR = 0x00;
	RCALL SUBOPT_0x6
; 0000 0100             set_counter = 0x0e; // receive 1 bit (2 edges)
	LDI  R16,LOW(14)
; 0000 0101             set_sda_to_input(); // initiate receive ack
	RCALL _set_sda_to_input_G000
; 0000 0102             break;
	RJMP _0xF
; 0000 0103         }
; 0000 0104         // ack/nack from master received
; 0000 0105         case(of_state_check_ack):{
_0x18:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x19
; 0000 0106             if(data){ // if NACK, the master does not want more data
	CPI  R17,0
	BREQ _0x1A
; 0000 0107                 of_state = of_state_check_address;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x3
; 0000 0108                 set_counter = 0x00;
	LDI  R16,LOW(0)
; 0000 0109                 twi_reset();
	RCALL _twi_reset_G000
; 0000 010A             }else{
	RJMP _0x1B
_0x1A:
; 0000 010B                 of_state = of_state_send_data;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
; 0000 010C                 goto again; // from here we just drop straight into state_send_data
	RJMP _0xC
; 0000 010D             } // don't wait for another overflow interrupt
_0x1B:
; 0000 010E             break;
	RJMP _0xF
; 0000 010F         }
; 0000 0110         // process write request from master
; 0000 0111         case(of_state_receive_data):{
_0x19:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1C
; 0000 0112             ss_state = ss_state_data_processed;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x4
; 0000 0113             of_state = of_state_store_data_and_send_ack;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3
; 0000 0114             set_counter = 0x00; // receive 1 bit (2 edges)
	LDI  R16,LOW(0)
; 0000 0115             set_sda_to_input(); // initiate receive data
	RCALL _set_sda_to_input_G000
; 0000 0116             break;
	RJMP _0xF
; 0000 0117         }
; 0000 0118         // data received from master, store it and wait for more data
; 0000 0119         case(of_state_store_data_and_send_ack):{
_0x1C:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xF
; 0000 011A             of_state = of_state_receive_data;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3
; 0000 011B             if(input_buffer_length < (USI_TWI_BUFFER_SIZE - 1)){
	LDS  R26,_input_buffer_length_G000
	CPI  R26,LOW(0x1F)
	BRSH _0x1E
; 0000 011C                 input_buffer[input_buffer_length++] = data;
	LDS  R30,_input_buffer_length_G000
	SUBI R30,-LOW(1)
	STS  _input_buffer_length_G000,R30
	SUBI R30,LOW(1)
	SUBI R30,-LOW(_input_buffer_G000)
	ST   Z,R17
; 0000 011D             }
; 0000 011E             USIDR = 0x00;
_0x1E:
	RCALL SUBOPT_0x6
; 0000 011F             set_counter = 0x0e; // send 1 bit (2 edges)
	LDI  R16,LOW(14)
; 0000 0120             set_sda_to_output(); // initiate send ack
_0x47:
	RCALL _set_sda_to_output_G000
; 0000 0121             break;
; 0000 0122         }
; 0000 0123     }
_0xF:
; 0000 0124     USISR =
; 0000 0125             (0	<< USISIF) | // don't clear start condition flag
; 0000 0126             (1	<< USIOIF) | // clear overflow condition flag
; 0000 0127             (0	<< USIPF) | // don't clear stop condition flag
; 0000 0128             (1	<< USIDC) | // clear arbitration error flag
; 0000 0129             (set_counter << USICNT0); // set counter to 8 or 1 bits
	MOV  R30,R16
	ORI  R30,LOW(0x50)
	OUT  0xE,R30
; 0000 012A }
	RCALL __LOADLOCR2P
_0x4A:
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
; 0000 012D                     const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer),void (*idle_callback_in)(void)){
_usi_twi_slave:
; 0000 012E     uint8_t	call_datacallback = 0;
; 0000 012F     slave_address = slave_address_in;
	ST   -Y,R17
;	slave_address_in -> Y+6
;	use_sleep -> Y+5
;	*data_callback_in -> Y+3
;	*idle_callback_in -> Y+1
;	call_datacallback -> R17
	LDI  R17,0
	LDD  R30,Y+6
	STS  _slave_address_G000,R30
; 0000 0130     data_callback = data_callback_in;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	STS  _data_callback_G000,R30
	STS  _data_callback_G000+1,R31
; 0000 0131     idle_callback = idle_callback_in;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	STS  _idle_callback_G000,R30
	STS  _idle_callback_G000+1,R31
; 0000 0132     input_buffer_length = 0;
	LDI  R30,LOW(0)
	STS  _input_buffer_length_G000,R30
; 0000 0133     output_buffer_length = 0;
	RCALL SUBOPT_0x7
; 0000 0134     output_buffer_current = 0;
; 0000 0135     ss_state = ss_state_before_start;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
; 0000 0136 //    if(use_sleep){
; 0000 0137 //        set_sleep_mode(SLEEP_MODE_IDLE);
; 0000 0138 //    }
; 0000 0139     twi_init();
	RCALL _twi_init_G000
; 0000 013A     #asm("sei")
	sei
; 0000 013B     for(;;){
_0x20:
; 0000 013C         if(idle_callback){
	RCALL SUBOPT_0x8
	SBIW R30,0
	BREQ _0x22
; 0000 013D             idle_callback();
	RCALL SUBOPT_0x8
	ICALL
; 0000 013E             if(stats_enabled){
	RCALL SUBOPT_0x1
	BREQ _0x23
; 0000 013F                 idle_call_count++;
	LDI  R26,LOW(_idle_call_count_G000)
	RCALL SUBOPT_0x2
; 0000 0140             }
; 0000 0141         }
_0x23:
; 0000 0142 
; 0000 0143         if(use_sleep && (ss_state == ss_state_before_start)){
_0x22:
; 0000 0144             //sleep_mode();
; 0000 0145         }
; 0000 0146 
; 0000 0147         if(USISR & _BV(USIPF)){
	SBIS 0xE,5
	RJMP _0x27
; 0000 0148             #asm("cli")
	cli
; 0000 0149             if(stats_enabled){
	RCALL SUBOPT_0x1
	BREQ _0x28
; 0000 014A                 stop_conditions_count++;
	LDI  R26,LOW(_stop_conditions_count_G000)
	RCALL SUBOPT_0x2
; 0000 014B             }
; 0000 014C             USISR |= _BV(USIPF); // clear stop condition flag
_0x28:
	SBI  0xE,5
; 0000 014D             switch(ss_state){
	LDS  R30,_ss_state_G000
	RCALL SUBOPT_0x5
; 0000 014E                 case(ss_state_after_start):{
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2C
; 0000 014F                     twi_reset();
	RCALL _twi_reset_G000
; 0000 0150                     break;
	RJMP _0x2B
; 0000 0151                 }
; 0000 0152 
; 0000 0153                 case(ss_state_data_processed):{
_0x2C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2B
; 0000 0154                     if(stats_enabled){
	RCALL SUBOPT_0x1
	BREQ _0x2E
; 0000 0155                         local_frames_count++;
	LDI  R26,LOW(_local_frames_count_G000)
	RCALL SUBOPT_0x2
; 0000 0156                     }
; 0000 0157                     call_datacallback = 1;
_0x2E:
	LDI  R17,LOW(1)
; 0000 0158                     break;
; 0000 0159                 }
; 0000 015A             }
_0x2B:
; 0000 015B             ss_state = ss_state_before_start;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
; 0000 015C             #asm("sei")
	sei
; 0000 015D         }
; 0000 015E         if(call_datacallback){
_0x27:
	CPI  R17,0
	BREQ _0x2F
; 0000 015F             output_buffer_length = 0;
	RCALL SUBOPT_0x7
; 0000 0160             output_buffer_current = 0;
; 0000 0161             data_callback(input_buffer_length, input_buffer, &output_buffer_length, output_buffer);
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
; 0000 0162             input_buffer_length = 0;
	LDI  R30,LOW(0)
	STS  _input_buffer_length_G000,R30
; 0000 0163             call_datacallback = 0;
	LDI  R17,LOW(0)
; 0000 0164         }
; 0000 0165     }
_0x2F:
	RJMP _0x20
; 0000 0166 }
;
;void usi_twi_enable_stats(uint8_t onoff){
; 0000 0168 void usi_twi_enable_stats(uint8_t onoff){
; 0000 0169     stats_enabled = onoff;
;	onoff -> Y+0
; 0000 016A     start_conditions_count = 0;
; 0000 016B     stop_conditions_count = 0;
; 0000 016C     error_conditions_count = 0;
; 0000 016D     overflow_conditions_count = 0;
; 0000 016E     local_frames_count = 0;
; 0000 016F     idle_call_count = 0;
; 0000 0170 }
;
;uint16_t usi_twi_stats_start_conditions(void){
; 0000 0172 uint16_t usi_twi_stats_start_conditions(void){
; 0000 0173     return(start_conditions_count);
; 0000 0174 }
;uint16_t usi_twi_stats_stop_conditions(void){
; 0000 0175 uint16_t usi_twi_stats_stop_conditions(void){
; 0000 0176     return(stop_conditions_count);
; 0000 0177 }
;uint16_t usi_twi_stats_error_conditions(void){
; 0000 0178 uint16_t usi_twi_stats_error_conditions(void){
; 0000 0179     return(error_conditions_count);
; 0000 017A }
;uint16_t usi_twi_stats_overflow_conditions(void){
; 0000 017B uint16_t usi_twi_stats_overflow_conditions(void){
; 0000 017C     return(overflow_conditions_count);
; 0000 017D }
;uint16_t usi_twi_stats_local_frames(void){
; 0000 017E uint16_t usi_twi_stats_local_frames(void){
; 0000 017F     return(local_frames_count);
; 0000 0180 }
;uint16_t usi_twi_stats_idle_calls(void){
; 0000 0181 uint16_t usi_twi_stats_idle_calls(void){
; 0000 0182     return(idle_call_count);
; 0000 0183 }
;
;void transmit(char data){
; 0000 0185 void transmit(char data){
_transmit:
; 0000 0186     while(!(UCSRA & (1 << UDRE))){}
;	data -> Y+0
_0x30:
	SBIS 0xB,5
	RJMP _0x30
; 0000 0187     UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0188 }
	RJMP _0x2000001
;void transmitInt(int data){
; 0000 0189 void transmitInt(int data){
; 0000 018A     int number = 0;
; 0000 018B     char str = '';
; 0000 018C     if(data < 10){
;	data -> Y+4
;	number -> R16,R17
;	str -> R19
; 0000 018D         str = data + '0';
; 0000 018E         transmit(str);
; 0000 018F     }else if(data < 100){
; 0000 0190         number = data / 10;
; 0000 0191         transmit(number + '0');
; 0000 0192         number = data - (number*10);
; 0000 0193         transmit(number + '0');
; 0000 0194     }else if(data < 1000){
; 0000 0195         number = data / 100;
; 0000 0196         transmit(number + '0');
; 0000 0197         data = data - (number * 100);
; 0000 0198         number = data / 10;
; 0000 0199         transmit(number + '0');
; 0000 019A         number = data - (number*10);
; 0000 019B         transmit(number + '0');
; 0000 019C     }
; 0000 019D }
;
;static void reply(uint8_t error_code, uint8_t reply_length, const uint8_t *reply_string){
; 0000 019F static void reply(uint8_t error_code, uint8_t reply_length, const uint8_t *reply_string){
_reply_G000:
; 0000 01A0     uint8_t checksum;
; 0000 01A1     uint8_t ix;
; 0000 01A2     if((reply_length + 4) > phy_buffer_size){
	RCALL __SAVELOCR2
;	error_code -> Y+4
;	reply_length -> Y+3
;	*reply_string -> Y+2
;	checksum -> R17
;	ix -> R16
	LDD  R30,Y+3
	RCALL SUBOPT_0x5
	ADIW R30,4
	SBIW R30,33
	BRGE _0x2000002
; 0000 01A3         return;
; 0000 01A4     }
; 0000 01A5     phy_send_buffer[0] = 3 + reply_length;
	RCALL SUBOPT_0x9
	ST   X,R30
; 0000 01A6     phy_send_buffer[1] = error_code;
	LDD  R30,Y+4
	__PUTB1PMN _phy_send_buffer_G000,1
; 0000 01A7    // phy_send_buffer[2] = input_byte;
; 0000 01A8     for(ix = 0; ix < reply_length; ix++){
	LDI  R16,LOW(0)
_0x3A:
	LDD  R30,Y+3
	CP   R16,R30
	BRSH _0x3B
; 0000 01A9         phy_send_buffer[3 + ix] = reply_string[ix];
	MOV  R30,R16
	SUBI R30,-LOW(3)
	LDS  R26,_phy_send_buffer_G000
	ADD  R30,R26
	MOV  R0,R30
	MOV  R30,R16
	LDD  R26,Y+2
	ADD  R26,R30
	LD   R30,X
	MOV  R26,R0
	ST   X,R30
; 0000 01AA     }
	SUBI R16,-1
	RJMP _0x3A
_0x3B:
; 0000 01AB     for(ix = 1, checksum = 0; ix < (3 + reply_length); ix++){
	LDI  R16,LOW(1)
	LDI  R17,LOW(0)
_0x3D:
	LDD  R30,Y+3
	RCALL SUBOPT_0x5
	ADIW R30,3
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x3E
; 0000 01AC         checksum += phy_send_buffer[ix];
	MOV  R30,R16
	LDS  R26,_phy_send_buffer_G000
	ADD  R26,R30
	LD   R30,X
	ADD  R17,R30
; 0000 01AD     }
	SUBI R16,-1
	RJMP _0x3D
_0x3E:
; 0000 01AE     phy_send_buffer[3 + reply_length] = checksum;
	RCALL SUBOPT_0x9
	ADD  R30,R26
	ST   Z,R17
; 0000 01AF     *phy_send_buffer_length = 3 + reply_length + 1;
	LDD  R30,Y+3
	SUBI R30,-LOW(4)
	LDS  R26,_phy_send_buffer_length_G000
	ST   X,R30
; 0000 01B0 }
_0x2000002:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
;
;static void reply_char(uint8_t value){
; 0000 01B2 static void reply_char(uint8_t value){
_reply_char_G000:
; 0000 01B3     reply(0, sizeof(value), &value);
;	value -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOV  R30,R28
	SUBI R30,-(2)
	ST   -Y,R30
	RCALL _reply_G000
; 0000 01B4     //reply(0, 0, 0));
; 0000 01B5 }
_0x2000001:
	ADIW R28,1
	RET
;
;static void my_twi_callback(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
; 0000 01B7 static void my_twi_callback(uint8_t input_buffer_length, const uint8_t *input_buffer, uint8_t *output_buffer_length, uint8_t *output_buffer){
_my_twi_callback_G000:
; 0000 01B8                         uint8_t l = 1;
; 0000 01B9                         uint8_t b = 5;
; 0000 01BA 
; 0000 01BB                         PORTD.5 = !PORTD.5;
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
	RJMP _0x3F
	CBI  0x12,5
	RJMP _0x40
_0x3F:
	SBI  0x12,5
_0x40:
; 0000 01BC                         transmit(input_buffer_length);
	LDD  R30,Y+5
	ST   -Y,R30
	RCALL _transmit
; 0000 01BD                         transmit(input_buffer[0]);
	LDD  R26,Y+4
	LD   R30,X
	ST   -Y,R30
	RCALL _transmit
; 0000 01BE                         transmit(input_buffer[1]);
	LDD  R30,Y+4
	LDD  R26,Z+1
	ST   -Y,R26
	RCALL _transmit
; 0000 01BF                         //transmit(0);
; 0000 01C0                         //transmit(0);
; 0000 01C1                         //transmit(0);
; 0000 01C2                         //transmit(0);
; 0000 01C3                         //transmit(0);
; 0000 01C4                         //transmit(0);
; 0000 01C5                         //transmit(0);
; 0000 01C6                         //transmit(0);
; 0000 01C7                         //transmit(0);
; 0000 01C8                         //transmit(0);
; 0000 01C9                         //transmit(0);
; 0000 01CA                         //transmit(0);
; 0000 01CB                         //transmit(0);
; 0000 01CC 
; 0000 01CD 
; 0000 01CE                         //output_buffer_length = &l;
; 0000 01CF                         //output_buffer = &b;
; 0000 01D0                         reply_char(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _reply_char_G000
; 0000 01D1                         return;
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
; 0000 01D2                         //return(reply(0,0,0));
; 0000 01D3 }
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 01D9 {
_main:
; 0000 01DA // Declare your local variables here
; 0000 01DB 
; 0000 01DC // Crystal Oscillator division factor: 1
; 0000 01DD #pragma optsize-
; 0000 01DE CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 01DF CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 01E0 #ifdef _OPTIMIZE_SIZE_
; 0000 01E1 #pragma optsize+
; 0000 01E2 #endif
; 0000 01E3 
; 0000 01E4 // Input/Output Ports initialization
; 0000 01E5 // Port A initialization
; 0000 01E6 // Func2=In Func1=In Func0=In
; 0000 01E7 // State2=T State1=T State0=T
; 0000 01E8 PORTA=0x00;
	OUT  0x1B,R30
; 0000 01E9 DDRA=0x00;
	OUT  0x1A,R30
; 0000 01EA 
; 0000 01EB // Port B initialization
; 0000 01EC // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01ED // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01EE PORTB=0b00000100;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 01EF DDRB=0b00000100;
	OUT  0x17,R30
; 0000 01F0 
; 0000 01F1 // Port D initialization
; 0000 01F2 
; 0000 01F3 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01F4 DDRD=0b00100000;
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 01F5 
; 0000 01F6 // Timer/Counter 0 initialization
; 0000 01F7 // Clock source: System Clock
; 0000 01F8 // Clock value: Timer 0 Stopped
; 0000 01F9 // Mode: Normal top=FFh
; 0000 01FA // OC0A output: Disconnected
; 0000 01FB // OC0B output: Disconnected
; 0000 01FC TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01FD TCCR0B=0x00;
	OUT  0x33,R30
; 0000 01FE TCNT0=0x00;
	OUT  0x32,R30
; 0000 01FF OCR0A=0x00;
	OUT  0x36,R30
; 0000 0200 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 0201 
; 0000 0202 // Timer/Counter 1 initialization
; 0000 0203 // Clock source: System Clock
; 0000 0204 // Clock value: Timer1 Stopped
; 0000 0205 // Mode: Normal top=FFFFh
; 0000 0206 // OC1A output: Discon.
; 0000 0207 // OC1B output: Discon.
; 0000 0208 // Noise Canceler: Off
; 0000 0209 // Input Capture on Falling Edge
; 0000 020A // Timer1 Overflow Interrupt: Off
; 0000 020B // Input Capture Interrupt: Off
; 0000 020C // Compare A Match Interrupt: Off
; 0000 020D // Compare B Match Interrupt: Off
; 0000 020E TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 020F TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0210 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0211 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0212 ICR1H=0x00;
	OUT  0x25,R30
; 0000 0213 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0214 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0215 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0216 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0217 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0218 
; 0000 0219 // External Interrupt(s) initialization
; 0000 021A // INT0: Off
; 0000 021B // INT1: Off
; 0000 021C // Interrupt on any change on pins PCINT0-7: Off
; 0000 021D GIMSK=0x00;
	OUT  0x3B,R30
; 0000 021E MCUCR=0x00;
	OUT  0x35,R30
; 0000 021F 
; 0000 0220 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0221 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0222 
; 0000 0223 // Universal Serial Interface initialization
; 0000 0224 // Mode: Two Wire (I2C)
; 0000 0225 // Clock source: Reg.=ext. pos. edge, Cnt.=USITC
; 0000 0226 // USI Counter Overflow Interrupt: On
; 0000 0227 // USI Start Condition Interrupt: On
; 0000 0228 USICR=0xEA;
	LDI  R30,LOW(234)
	OUT  0xD,R30
; 0000 0229 
; 0000 022A // USART initialization
; 0000 022B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 022C // USART Receiver: Off
; 0000 022D // USART Transmitter: On
; 0000 022E // USART Mode: Asynchronous
; 0000 022F // USART Baud Rate: 9600
; 0000 0230 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0231 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0232 UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 0233 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0234 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0235 
; 0000 0236 // Analog Comparator initialization
; 0000 0237 // Analog Comparator: Off
; 0000 0238 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0239 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 023A // #asm("sei")
; 0000 023B 
; 0000 023C usi_twi_slave(0b1000000, 0, my_twi_callback, NULL);
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
; 0000 023D transmit(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _transmit
; 0000 023E while (1)
_0x41:
; 0000 023F       {
; 0000 0240       // Place your code here
; 0000 0241       //uint8_t bu = 8;
; 0000 0242                           //output_buffer = 8;
; 0000 0243       };
	RJMP _0x41
; 0000 0244 }
_0x44:
	RJMP _0x44

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
	.BYTE 0x20
_input_buffer_length_G000:
	.BYTE 0x1
_output_buffer_G000:
	.BYTE 0x20
_output_buffer_length_G000:
	.BYTE 0x1
_output_buffer_current_G000:
	.BYTE 0x1
_stats_enabled_G000:
	.BYTE 0x1
_start_conditions_count_G000:
	.BYTE 0x2
_stop_conditions_count_G000:
	.BYTE 0x2
_error_conditions_count_G000:
	.BYTE 0x2
_overflow_conditions_count_G000:
	.BYTE 0x2
_local_frames_count_G000:
	.BYTE 0x2
_idle_call_count_G000:
	.BYTE 0x2
_phy_send_buffer_G000:
	.BYTE 0x1
_phy_send_buffer_length_G000:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDS  R30,_stats_enabled_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	STS  _of_state_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	STS  _ss_state_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	OUT  0xF,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _output_buffer_length_G000,R30
	STS  _output_buffer_current_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_idle_callback_G000)
	LDI  R31,HIGH(_idle_callback_G000)
	MOV  R26,R30
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R30,Y+3
	SUBI R30,-LOW(3)
	LDS  R26,_phy_send_buffer_G000
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
