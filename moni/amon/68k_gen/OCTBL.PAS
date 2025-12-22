{ 68000 opcode microcode table source.         }
{ each opcode is described by 128bits.         }
{ see bottom for data structure.               }

{ version 1.01 2005 01 10                      }
{ put into limited public domain.              }
{ this means the following:                    }
{                                              }
{ the right to download, read and run          }
{ this source. the obligation not to omit      }
{ copyright sequence.                          }
{ terms and conditions of the relevant         }
{ manufacturer companies apply automatically.  }
{                                              }
{ however, corporate usage requires a licence. }

abcd   *c100 2001 0001 0402
abcdm  *c108 2010 2010 0402

add    *d000 efff 0001 1104
adda   *d0c0 efff 0002 2104
addi   *0600 e200 01fd 1c01
addm   *d100 0001 e1fc 1401
addq   *5000 3200 e1ff 1301
addx   *d100 e001 0001 1402
addxm  *d108 e010 0010 1402

and    *c000 effd 0001 1104
andi   *0200 e200 01fd 1c01
andiccr*023c 2200 0000 0800
andisr *027c 4200 0000 0900
andm   *c100 0001 e1fc 1401

asl    *e140 e001 0001 1402
aslm   *e1c0 e1fc 0000 1100
aslq   *e100 3200 e001 1302
asr    *e040 e001 0001 1402
asrm   *e0c0 e1fc 0000 1100
asrq   *e000 3200 e001 1302

bcc    *6000 4200 0000 0d00
bccq   *6000 2200 0000 0500
bchg   *0140 a002 01fd 0401
bchgi  *0840 a200 01fd 0108
bclr   *0180 a002 01fd 0401
bclri  *0880 a200 01fd 0108

bkptq  *4848 3200 0000 0700

bra    *6000 4200 0000 0d00
braq   *6000 3200 0000 0500
bset   *01c0 a002 01fd 0401
bseti  *08c0 a200 01fd 0108

bsr    *6100 6200 0000 0d00
bsrq   *6100 6200 0000 0500

btst   *0100 a002 01fd 0401
btsti  *0800 a200 01fd 0108

chk    *4010 4dff 0001 3104
clr    *4200 e1fd 0000 1100

cmp    *b000 efff 0001 1104
cmpa   *b000 efff 0001 2104
cmpi   *0c00 e200 01fd 1c02
cmpm   *b108 e008 0008 1204

dbcc   *50c8 4001 0200 0209

divs   *81c0 4ffd 0001 0104
divu   *80c0 4ffd 0001 0104

eor    *b100 e001 01fd 1401
eori   *0a00 e200 01fd 1c01
eoriccr*003c 2200 0000 0800
eorisr *0a7c 4200 0000 0900

exga   *c141 4002 0020 0402
exgd   *c100 4001 0001 0402
exgda  *c181 4001 0002 0402
extbw  *4880 c001 0000 0200
extwl  *48c0 c001 0000 0200

jmp    *4ec0 9de4 0000 0100
jsr    *4e80 9de4 0000 0100
lea    *41c0 8de4 0001 0104
link   *4e50 4002 0002 0209

lsr    *e048 e001 0001 1402
lsrm   *e008 e1fc 0000 0100
lsrq   *e008 3200 e001 1302
lsl    *e140 e001 0001 1402
lslm   *e100 e1fc 0000 0100
lslq   *e100 3200 e001 1302

move   *0000 efff e1fd 410b
movea  *0040 cfff 0002 4104

movemtom*4880 4200 c1f4 1911
movemtor*4c80 cdec 4200 1109
moveptor*0008 c020 0001 5204

moveq  *7000 3200 8001 0504
movetop*0008 c001 0020 5402

mvfrccr*44c0 5000 41fd 0100
mvfrsr *40c0 5000 41fd 0100
mvfrusp*4e58 5000 0002 0700
mvtoccr*42c0 41fd 0000 0100
mvtosr *45c0 effd 0000 0100
mvtousp*4e50 0002 0000 0700

muls   *c1c0 cffd 0001 0104
mulu   *c0c0 cffd 0001 0104

nbcd   *4800 21fd 0000 0100
neg    *4400 e1fd 0000 1100
negx   *4100 e1fd 0000 1100
nop    *4e71 0000 0000 0000
not    *4600 e1fd 0000 1100

or     *4000 effd 0001 1104
orm    *4000 0001 e1fc 1401
ori    *0000 e200 01fd 1c01
oriccr *003c 2200 0000 0800
orisr  *007c 4200 0000 0900

pea    *4840 8de4 0000 0100
reset  *4e70 0000 0000 0000

rol    *e138 e001 0001 1402
rolm   *e7c0 e1fc 0000 0100
rolq   *e118 3200 e001 1302
ror    *e038 e001 0001 1402
rorm   *e6c0 e1fc 0000 0100
rorq   *e018 3200 e001 1302

roxl   *e130 e001 0001 1402
roxlm  *e5c0 e1fc 0000 0100
roxlq  *e110 3200 e001 1302
roxr   *e040 e001 0001 1402
roxrm  *e4c0 e1fc 0000 0100
roxrq  *e000 3200 e001 1302

rte    *4e73 0000 0000 0000
rtr    *4e77 0000 0000 0000
rts    *4e75 0000 0000 0000

sbcd   *8100 2001 0001 0202
sbcdm  *8108 2010 0010 0204

scc    *50c0 21fd 0000 0d00
stop   *4e72 4200 0000 0900

sub    *9000 efff 0001 1104
subm   *9010 0001 e1fc 1401
suba   *9000 cfff 0002 2104
subi   *0400 e200 01fd 1c01
subq   *5400 3200 e1ff 1701

subx   *9400 e001 0001 1204
subxm  *9408 e010 0010 1204

swap   *4840 4001 0000 0700
tas    *4ac0 21fd 0000 0100

trap   *4e40 c200 0000 0600
trapv  *4e76 0000 0000 0000

tst    *4a00 e1fd 0000 1100
unlk   *4e58 0002 0000 0700

{

opcode text: 2 longwords

opcode and register mask: 1 word
15:14:13:12 opcode
11-------00 mode/register mask

source mask: 1 word
destination mask: 1 word
operand destiny mask 1st operand: 1 byte
operand destiny mask 2nd operand: 1 byte

opcode and register mask + source mask: 1 longword
destination mask + 1st+2nd operand destiny masks: 1 word+2 byte = 1 longword

-> 4 longwords (32bit) -> 128 bit. each opcode table entry has 128bit.

rem source/destination
rem
rem "source"=0, it is an address/immediate/quick instruction.
rem
rem 15:14:13:12 long       word        byte/quick  quick/lwb
rem 11:10:09:08 d8(pc,dn)  d16(pc)     #data       abs.l
rem 07:06:05:04 abs.w      d8(an,dn)   d16(an)     -(an)
rem 03:02:01:00 (an)+      (an)        an          dn

rem two bytes describe where source/target operand go.
rem the top byte (1st operand) contains the size style.

rem ----- top bit not used
rem 00 no size
rem 01 size byte,word,long   000,001,010
rem 02 size adda style
rem 03 size chk style
rem 04 size move style
rem 05 size movep style (16bit immediate displacement addressing mode)
rem ----- 2bit
rem 00 0000 0 no operand
rem 01 0001 1 ea (mode and register)
rem 02 0010 2 ea register
rem 03 0011 3 quick
rem 04 0100 4 register
rem 05 0101 5 immediate 8bit
rem 06 0110 6 immediate 4bit
rem 07 0111 7 immediate 3bit
rem 08 1000 8 immediate extension operand 8bit
rem 09 1001 9 immediate extension operand 16bit
rem 10 1010 a immediate extension operand 32bit
rem 11 1011 b register and mode
rem 12 1100 c immediate extension operand 8/16/32bit
rem 13 1100 d immediate extension operand 16bit bcc/bsr/scc style
rem ----- 4bit

}


*end*