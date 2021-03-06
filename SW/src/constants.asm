* Memory map.
RAMSTRT	equ	$0000
RAMSIZE	equ	$8000
IOSTRT	equ	$C000
ROMSTRT	equ	$E000
VECTBL	equ	$FFF0

* Base address for global variables (direct page addressed by default).
VARSPC	equ	$100

* The 74HCT138 IO address decoder maps one 1KB page per usable device.
DEV0	equ	$C000		Compact Flash memory module
DEV1	equ	$C400
DEV2	equ	$C800
DEV3	equ	$CC00
DEV4	equ	$D000
DEV5	equ	$D400
DEV6	equ	$D800		HD63B50 unit 0
DEV7	equ	$DC00

ACIACTL	equ	DEV6
ACIADAT	equ	DEV6+1

* ACIA control register bits.
ACRST	equ	11b		ACIA master reset

* 115200 bps w. 7.37280 MHz oscillator, 38400 bps w. 2.45760 MHz oscillator.
ACD16	equ	01b		ACIA div 16
* 28800 bps w. 7.37280 MHz oscillator, bps 9600 w. 2.45760 MHz oscillator.
ACD64	equ	10b		ACIA div 64
ACDVSEL	equ	ACD16		Selected divider value

AC8N1	equ	10100b		ACIA 8N1
ACRTS0	equ	0000000b	ACIA RTS low
ACRTS1	equ	1000000b	ACIA RTS high

ACIRSET	equ	ACRTS1|ACRST
ACIRTS1	equ	ACRTS1|AC8N1|ACDVSEL
ACIRTS0	equ	ACRTS0|AC8N1|ACDVSEL

* ACIA status register bits.
ACIRDRF	equ	1		Receive data register full
ACITDRE	equ	2		Transmit data register empty
ACIOVRN	equ	32		Overrun status register bit (req. NZ CKOVRUN)

* Compact Flash parameters.
CFBASE	equ	DEV0
CFDATAR	equ	CFBASE		R/W data register
CFERROR	equ	CFBASE+1	RO error register
CFFEATR	equ	CFBASE+1	WO features register
CFSCNTR	equ	CFBASE+2	R/W sector count register
CFSNUMR	equ	CFBASE+3	R/W sector number register
CFCLOWR	equ	CFBASE+4	R/W cylinder low register
CFCHIGR	equ	CFBASE+5	R/W cylinder high register
CFDRHDR	equ	CFBASE+6	R/W drive/head register
CFSTATR	equ	CFBASE+7	RO status register
CFCOMDR	equ	CFBASE+7	WO command register

* CF status bits.
CFBSYB	equ	10000000b	BSY status bit
CFRDYB	equ	01000000b	RDY status bit
CFDWFB	equ	00100000b	DWF status bit (not used)
CFDSCB	equ	00010000b	DSC status bit (not used)
CFDRQB	equ	00001000b	DRQ status bit
CFERRB	equ	00000001b	ERR status bit

CFSCSZ	equ	$200		Compact Flash (IDE) sector size

* CF commands.
CFIDDEV	equ	$EC		Identify Device
CFSETFT	equ	$EF		Set Feature
CFRSCTS	equ	$20		Read Sectors
CFWSCTS	equ	$30		Write Sectors

* Buffer in-memory structure:
* data: 1024 bytes.
* terminator: 1 byte set to 0.
* flags: 1 byte.
* blknum: 2 bytes.
BINUSE	equ	1		Buffer is allocated (the blknum field is valid)
BMAPPD	equ	2		Block has been read from the CF device
BDIRTY	equ	4		Block has been marked for update
BLKSIZ	equ	2*CFSCSZ	Block size is 2 CF sectors (1 KB)
* Buffer field offsets.
BOFLAGS	equ	BLKSIZ+1	Base buffer to the 'flag' field offset
BOBLKNO	equ	BLKSIZ+2	Base buffer to the 'blknum' field offset

BFDISP	equ	BUF1-BUF0	Offset between resident buffers

* ASCII trivia.
NUL	equ	0		End of string marker
ETX	equ	3		Control-C (intr)
BS	equ	8		Backspace
HT	equ	9		Horizontal tab
LF	equ	$0A		aka new line
CR	equ	$0D		Carriage return
FF	equ	$0C		Form feed (clear screen)
NAK	equ	$15		Control-U (kill)
SP	equ	$20

* Configuration tunable parameters.
CSSNTVE	equ	0		Words and HEX numbers are case sensitive if NZ
STRCT79	equ	0		Set to 1 to omit the COMPILE word
DEBUG	equ	0		Enforce assertions and miscellaneous checks
CKOVRUN	equ	0		Check for overruns in GETCH
USEDP	equ	1		Set to 1 to use direct page addressing
SSDFEAT	equ	1		Set to 1 to enable the symbolic stack dump feat.
RELFEAT	equ	1		Set to 1 to enable the reliability feature
*				Caution: when this is enabled, you can no
*				longer fit a DEBUG image into an 8 KB EEPROM
* Loop count for MS. This is busy waiting, so we depend on the CPU clock speed.
*MSLCNT	equ	496		at 3 MHz emulation mode
*MSLCNT	equ	662		at 4 MHz emulation mode
*MSLCNT	equ	794		at 4 MHz native mode
MSLCNT	equ	994		at 5 MHz native mode

* Stack sizes.
NSTKSZ	equ	192		Expressed in bytes. Now only limited by RAM size
RSTKSZ	equ	128		Expressed in bytes

* Buffer sizes.
CMDBFSZ	equ	132		Command line entry buffer
HEXBFSZ	equ	80
TBUFSZ	equ	72		Used by VLIST to print word name, CVNSTR
*				And DUMP, at offset 69
PADBSZ	equ	1+80		79-STANDARD mandates a minimum of 64 bytes

* Dictionary flag masks.
IMDFLM	equ	$80		Immediate flag mask
DEFFLM	equ	$40		Compilation only flag mask
	IFNE	RELFEAT
MONFLM	equ	$20		Monitored flag mask. This indicates that the
*				word to which it relates might be checked for
*				integrity. This applies by default to all words
*				defined with : and all constants. It might
*				also apply to any other CREATEd object by
*				resorting to the MONITOR word. Using MONITOR
*				on variable word contents is guaranteed to
*				raise ICHECK's attention.
	ENDC

WRLNMSK	equ	$1F		31 character is the maximum word length

* 6309 opcodes.
LDXOPC	equ	$8E		LDX (immediate)
JMPOPC	equ	$7E		JMP (extended)
JSROPC	equ	$BD		JSR (extended)
RTSOPC	equ	$39		RTS (inherent)
BCSOPC	equ	$2503		BCS *+5 (relative)
BNEOPC	equ	$2603		BNE *+5 (relative)
ILLOPC	equ	$C7		An illegal operation code. Meant to raise a trap

CFLAG	equ	1		CC bit 0
ZFLAG	equ	4		CC bit 2
NFLAG	equ	8		CC bit 3

* RAM based execution token for @.
RAMFTCH	set	WDICSPC+4	Dictionary header overhead is word's length + 3
	IFNE	RELFEAT		The reliability features adds one byte to the
RAMFTCH	set	WDICSPC+5	header: a checksum.
	ENDC

