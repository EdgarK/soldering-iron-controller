
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
	.DEF _delay=R2
	.DEF _prevPins=R5

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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x26:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x02
	.DW  _0x26*2

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
;Project :
;Version :
;Date    : 3/4/2015
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
;#include <delay.h>
;
;eeprom unsigned char pwm1;
;
;int delay = 0;
;unsigned char prevPins = 0;
;
;void transmit(char data){
; 0000 001F void transmit(char data){

	.CSEG
_transmit:
; 0000 0020    while(!(UCSRA & (1 << UDRE))){}
;	data -> Y+0
_0x3:
	SBIS 0xB,5
	RJMP _0x3
; 0000 0021    UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0022 }
	ADIW R28,1
	RET
;
;void transmitInt(int data){
; 0000 0024 void transmitInt(int data){
_transmitInt:
; 0000 0025     int number = 0;
; 0000 0026     char str = '';
; 0000 0027     if(data < 10){
	RCALL __SAVELOCR4
;	data -> Y+4
;	number -> R16,R17
;	str -> R19
	__GETWRN 16,17,0
	LDI  R19,0
	RCALL SUBOPT_0x0
	SBIW R26,10
	BRGE _0x6
; 0000 0028        str = data + '0';
	LDD  R30,Y+4
	SUBI R30,-LOW(48)
	MOV  R19,R30
; 0000 0029        transmit(str);
	ST   -Y,R19
	RJMP _0x24
; 0000 002A     }else if(data < 100){
_0x6:
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x25
; 0000 002B         number = data / 10;
; 0000 002C         transmit(number + '0');
; 0000 002D         number = data - (number*10);
; 0000 002E         transmit(number + '0');
; 0000 002F     }else if(data < 1000){
	RCALL SUBOPT_0x0
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRGE _0xA
; 0000 0030         number = data / 100;
	RCALL SUBOPT_0x0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x1
; 0000 0031         transmit(number + '0');
; 0000 0032         data = data - (number * 100);
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL SUBOPT_0x2
	STD  Y+4,R26
	STD  Y+4+1,R27
; 0000 0033         number = data / 10;
_0x25:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x1
; 0000 0034         transmit(number + '0');
; 0000 0035         number = data - (number*10);
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL SUBOPT_0x2
	MOVW R16,R26
; 0000 0036         transmit(number + '0');
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   -Y,R30
_0x24:
	RCALL _transmit
; 0000 0037     }
; 0000 0038     transmit('\n');
_0xA:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _transmit
; 0000 0039 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void pwmChanged(void){
; 0000 003B void pwmChanged(void){
_pwmChanged:
; 0000 003C     int num = 0;
; 0000 003D     pwm1 = delay; //memorize the value
	RCALL __SAVELOCR2
;	num -> R16,R17
	__GETWRN 16,17,0
	MOV  R30,R2
	RCALL SUBOPT_0x3
	RCALL __EEPROMWRB
; 0000 003E 
; 0000 003F     OCR0A = delay*2+1;
	MOV  R30,R2
	LSL  R30
	SUBI R30,-LOW(1)
	OUT  0x36,R30
; 0000 0040     num = delay - ((delay/100)*100);
	MOVW R26,R2
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12
	MOVW R26,R30
	MOVW R30,R2
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0041     OCR0B = (num*255)/99;
	MOVW R30,R16
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	RCALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	RCALL __DIVW21
	OUT  0x3C,R30
; 0000 0042 }
	RCALL __LOADLOCR2P
	RET
;
;void incDelay(void){
; 0000 0044 void incDelay(void){
_incDelay:
; 0000 0045     if(delay < 127){
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	CP   R2,R30
	CPC  R3,R31
	BRGE _0xB
; 0000 0046         delay++;
	MOVW R30,R2
	ADIW R30,1
	RCALL SUBOPT_0x4
; 0000 0047         transmitInt(delay);
; 0000 0048         pwmChanged();
; 0000 0049     }
; 0000 004A }
_0xB:
	RET
;
;void decDelay(void){
; 0000 004C void decDelay(void){
_decDelay:
; 0000 004D     if(delay > 0){
	CLR  R0
	CP   R0,R2
	CPC  R0,R3
	BRGE _0xC
; 0000 004E         delay--;
	MOVW R30,R2
	SBIW R30,1
	RCALL SUBOPT_0x4
; 0000 004F         transmitInt(delay);
; 0000 0050         pwmChanged();
; 0000 0051     }
; 0000 0052 }
_0xC:
	RET
;// Pin change 0-7 interrupt service routine
;interrupt [PC_INT] void pin_change_isr0(void)
; 0000 0055 {
_pin_change_isr0:
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
; 0000 0056 // Place your code here
; 0000 0057 
; 0000 0058     if((prevPins & (1<<4)) != (PINB & (1<<4))){
	RCALL SUBOPT_0x5
	BREQ _0xD
; 0000 0059         if(!PINB.4){
	SBIC 0x16,4
	RJMP _0xE
; 0000 005A             if(PINB.3){
	SBIS 0x16,3
	RJMP _0xF
; 0000 005B                 incDelay();
	RCALL _incDelay
; 0000 005C             }else{
	RJMP _0x10
_0xF:
; 0000 005D                 decDelay();
	RCALL _decDelay
; 0000 005E             }
_0x10:
; 0000 005F         }else{
	RJMP _0x11
_0xE:
; 0000 0060             if(!PINB.3){
	SBIC 0x16,3
	RJMP _0x12
; 0000 0061                 incDelay();
	RCALL _incDelay
; 0000 0062             }else{
	RJMP _0x13
_0x12:
; 0000 0063                 decDelay();
	RCALL _decDelay
; 0000 0064             }
_0x13:
; 0000 0065         }
_0x11:
; 0000 0066      }else if((prevPins & (1<<4)) != (PINB & (1<<4))){
	RJMP _0x14
_0xD:
	RCALL SUBOPT_0x5
	BREQ _0x15
; 0000 0067          if(!PINB.3){
	SBIC 0x16,3
	RJMP _0x16
; 0000 0068             if(!PINB.4){
	SBIC 0x16,4
	RJMP _0x17
; 0000 0069                 incDelay();
	RCALL _incDelay
; 0000 006A             }else{
	RJMP _0x18
_0x17:
; 0000 006B                 decDelay();
	RCALL _decDelay
; 0000 006C             }
_0x18:
; 0000 006D         }else{
	RJMP _0x19
_0x16:
; 0000 006E             if(PINB.4){
	SBIS 0x16,4
	RJMP _0x1A
; 0000 006F                 incDelay();
	RCALL _incDelay
; 0000 0070             }else{
	RJMP _0x1B
_0x1A:
; 0000 0071                 decDelay();
	RCALL _decDelay
; 0000 0072             }
_0x1B:
; 0000 0073         }
_0x19:
; 0000 0074      }
; 0000 0075 
; 0000 0076      prevPins = PINB;
_0x15:
_0x14:
	IN   R5,22
; 0000 0077 }
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
;// Declare your global variables here
;
;void main(void)
; 0000 007C {
_main:
; 0000 007D // Declare your local variables here
; 0000 007E 
; 0000 007F // Crystal Oscillator division factor: 1
; 0000 0080 #pragma optsize-
; 0000 0081 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0082 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0083 #ifdef _OPTIMIZE_SIZE_
; 0000 0084 #pragma optsize+
; 0000 0085 #endif
; 0000 0086 
; 0000 0087 // Input/Output Ports initialization
; 0000 0088 // Port A initialization
; 0000 0089 // Func2=In Func1=In Func0=In
; 0000 008A // State2=T State1=T State0=T
; 0000 008B PORTA=0x00;
	OUT  0x1B,R30
; 0000 008C DDRA=0x00;
	OUT  0x1A,R30
; 0000 008D 
; 0000 008E // Port B initialization
; 0000 008F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 0090 // State7=T State6=T State5=T State4=T State3=T State2=T State1=1 State0=1
; 0000 0091 PORTB=0b00011011;
	LDI  R30,LOW(27)
	OUT  0x18,R30
; 0000 0092 DDRB=0b00000111;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0093 
; 0000 0094 // Port D initialization
; 0000 0095 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0096 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0097 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0098 DDRD=0b00100000;
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 0099 
; 0000 009A // Timer/Counter 0 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: 31.250 kHz
; 0000 009D // Mode: Fast PWM top=FFh
; 0000 009E // OC0A output: Non-Inverted PWM
; 0000 009F // OC0B output: Non-Inverted PWM
; 0000 00A0 TCCR0A=0xA3;
	LDI  R30,LOW(163)
	OUT  0x30,R30
; 0000 00A1 TCCR0B=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 00A2 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00A3 OCR0A=0x00;
	OUT  0x36,R30
; 0000 00A4 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00A5 
; 0000 00A6 // Timer/Counter 1 initialization
; 0000 00A7 // Clock source: System Clock
; 0000 00A8 // Clock value: Timer1 Stopped
; 0000 00A9 // Mode: Normal top=FFFFh
; 0000 00AA // OC1A output: Discon.
; 0000 00AB // OC1B output: Discon.
; 0000 00AC // Noise Canceler: Off
; 0000 00AD // Input Capture on Falling Edge
; 0000 00AE // Timer1 Overflow Interrupt: Off
; 0000 00AF // Input Capture Interrupt: Off
; 0000 00B0 // Compare A Match Interrupt: Off
; 0000 00B1 // Compare B Match Interrupt: Off
; 0000 00B2 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00B3 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00B4 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B5 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B6 ICR1H=0x00;
	OUT  0x25,R30
; 0000 00B7 ICR1L=0x00;
	OUT  0x24,R30
; 0000 00B8 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00B9 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00BA OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00BB OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00BC 
; 0000 00BD // External Interrupt(s) initialization
; 0000 00BE // INT0: Off
; 0000 00BF // INT1: Off
; 0000 00C0 // Interrupt on any change on pins PCINT0-7: On
; 0000 00C1 GIMSK=0x20;
	LDI  R30,LOW(32)
	OUT  0x3B,R30
; 0000 00C2 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00C3 PCMSK=0b00011000;
	LDI  R30,LOW(24)
	OUT  0x20,R30
; 0000 00C4 EIFR=0x20;
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 00C5 
; 0000 00C6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C7 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00C8 
; 0000 00C9 // Universal Serial Interface initialization
; 0000 00CA // Mode: Disabled
; 0000 00CB // Clock source: Register & Counter=no clk.
; 0000 00CC // USI Counter Overflow Interrupt: Off
; 0000 00CD USICR=0x00;
	OUT  0xD,R30
; 0000 00CE 
; 0000 00CF // USART initialization
; 0000 00D0 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00D1 // USART Receiver: Off
; 0000 00D2 // USART Transmitter: On
; 0000 00D3 // USART Mode: Asynchronous
; 0000 00D4 // USART Baud Rate: 9600
; 0000 00D5 UCSRA=0x00;
	OUT  0xB,R30
; 0000 00D6 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 00D7 UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 00D8 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00D9 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00DA 
; 0000 00DB // Analog Comparator initialization
; 0000 00DC // Analog Comparator: Off
; 0000 00DD // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00DE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DF 
; 0000 00E0 // Global enable interrupts
; 0000 00E1 transmitInt(pwm1);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x6
; 0000 00E2 delay = pwm1;
	RCALL SUBOPT_0x3
	RCALL __EEPROMRDB
	MOV  R2,R30
	CLR  R3
; 0000 00E3 delay++;
	MOVW R30,R2
	ADIW R30,1
	MOVW R2,R30
; 0000 00E4 transmitInt(pwm1);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x6
; 0000 00E5 transmitInt(0);
	RCALL SUBOPT_0x7
; 0000 00E6 transmitInt(0);
	RCALL SUBOPT_0x7
; 0000 00E7 pwmChanged();
	RCALL _pwmChanged
; 0000 00E8 
; 0000 00E9 
; 0000 00EA #asm("sei")
	sei
; 0000 00EB 
; 0000 00EC while (1)
_0x1C:
; 0000 00ED       {
; 0000 00EE       // Place your code here
; 0000 00EF 
; 0000 00F0       #asm("sei");
	sei
; 0000 00F1           delay_ms(delay);
	ST   -Y,R3
	ST   -Y,R2
	RCALL _delay_ms
; 0000 00F2          PORTB.0 = !PORTB.0;
	SBIS 0x18,0
	RJMP _0x1F
	CBI  0x18,0
	RJMP _0x20
_0x1F:
	SBI  0x18,0
_0x20:
; 0000 00F3          delay_ms(delay);
	ST   -Y,R3
	ST   -Y,R2
	RCALL _delay_ms
; 0000 00F4          PORTB.1 = !PORTB.1;
	SBIS 0x18,1
	RJMP _0x21
	CBI  0x18,1
	RJMP _0x22
_0x21:
	SBI  0x18,1
_0x22:
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 
; 0000 00F8       };
	RJMP _0x1C
; 0000 00F9 }
_0x23:
	RJMP _0x23
;

	.ESEG
_pwm1:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	RCALL __DIVW21
	MOVW R16,R30
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RCALL _transmit
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	RCALL __MULW12
	RCALL SUBOPT_0x0
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_pwm1)
	LDI  R27,HIGH(_pwm1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	MOVW R2,R30
	ST   -Y,R3
	ST   -Y,R2
	RCALL _transmitInt
	RJMP _pwmChanged

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	MOV  R30,R5
	ANDI R30,LOW(0x10)
	MOV  R26,R30
	IN   R30,0x16
	ANDI R30,LOW(0x10)
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	RCALL __EEPROMRDB
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP _transmitInt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _transmitInt


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MOV  R0,R26
	MOV  R1,R27
	LDI  R24,17
	CLR  R26
	SUB  R27,R27
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R26,R0
	ADC  R27,R1
__MULW12U2:
	LSR  R27
	ROR  R26
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
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
