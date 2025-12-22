CMDreset  equ  1
CMDread   equ  2
CMDwrite  equ  3
CMDclear  equ  4
CMDstop   equ  5
CMDstart  equ  6
CMDflush  equ  8
CMDquery  equ  9
CMDbreak  equ  10
CMDset    equ  11


oldfile             equ       1005
newfile             equ       1006
readwrite           equ       1004

raw       macro
    bsr  _s_raw
    ifnd  gos_s_raw
gos_s_raw
    endc
    endm

con     macro
    bsr  _s_con
    ifnd  gos_s_con
gos_s_con
    endc
    endm

Reads    MACRO
    move.l  \1,d2
    move.l  \2,d3
    bsr  _s_reads
    ifnd  gos_s_reads
gos_s_reads
    endc
    ENDM

ReadsChar    MACRO
    move.l  \1,d2
    bsr  _s_read1
    ifnd  gos_s_read1
gos_s_read1
    endc
    ENDM

waits  macro
    bsr  _s_waits
    ifnd  gos_s_waits
gos_s_waits
    endc
    tst.l  d0
    beq  \1
    endm

randomize_timer   macro
    ifnd  gos_randtime
gos_randtime
    endc
    bsr  ctime
    move.l  xds_tick,d0
    bsr  RandomSeed
    endm

rnd  macro         ;rnd [min,]max[,var][,step]
    ifeq  NARG-1    ;rnd max
    move.l  \1,d0    ;rnd max,var
    bsr  Random    ;rnd min,max,var
    endc      ;rnd min,max,var,step
    ifeq  NARG-2
    move.l  \1,d0
    bsr  Random
    move.l  d0,\2
    endc
    ifeq  NARG-3
    move.l  \1,d2
    move.l  \2,d0
    sub.l  d2,d0
    bsr  Random
    add.l  d2,d0
    move.l  d0,\3
    endc
    ifeq  NARG-4
    move.l  \2,d0
    move.l  \1,d2
    sub  d2,d0
    divu  \4,d0
    bsr  Random
    mulu  \4,d0
    add.l  d2,d0
    move.l  d0,\3
    endc
    ifnd  gos_s_rnd
gos_s_rnd
    endc
    endm

numb0   macro
    move.l  \1,a5
    bsr  _s_numb0
    IFND  x_go_numb02
x_go_numb02
    ENDC
    IFEQ  NARG-2
    move.l  d3,\2
    ENDC
    endm

writes   macro
    ifeq  NARG-2
    move.l  \1,d2
    Move.l  \2,d3
    endc
    ifeq  NARG-1
    numb0  \1
    move.l  \1,d2
    endc
    bsr  s_writes0
    IFND  go_s_writes0
go_s_writes0
    ENDC
    endm

writes0   macro
    numb0  \1
    move.l  \1,d2
    bsr  s_writes0
    IFND  go_s_writes0
go_s_writes0
    ENDC
    endm

write0   macro
    IFND  go_s_write0
go_s_write0
    ENDC
    numb0  \2
    move.l  \2,d2
    move.l  \1,d1
    bsr  s_write0
    endm

Instring  macro
    move.l  \1,a0
    move.l  \2,a1
    moveq.l  #0,d0
    bsr  st_cmp
    IFEQ  NARG-3
    move.l  d0,\3
    ENDC
    IFND  gos_st_cmp
gos_st_cmp
    ENDC
    endm

str      macro
    moveq.l  #0,d2
    move  \0,\1,d2
    move.l  \2,a0
    bsr  _s_longzustring
    IFEQ  NARG-3
    move.b  d0,\3
    ENDC
    ifnd  gos_longzustring
gos_longzustring
    ENDC
    endm



val macro
    move.l  \1,d1
    bsr  str_tl
    move  \0,d1,\2
    ifnd  _gos_s_str_tl
_gos_s_str_tl
    endc
    endm

time      macro
    bsr  ctime
    ifnd  gos_randtime
gos_randtime
    endc
    endm

fillstring         macro
    move.l  \1,a1
    move.b  \2,d1
    move.l  \3-1,d0
    ifeq  NARG-2
    move.l  #32000,d0
    endc
    bsr  _fillString
    ifnd  gos_FillString
gos_FillString
    endc
    endm

nullstring          macro    ;nullstring String,Anzahl
    move.l  \1,a1
    move.l  \2-1,d0
    bsr  _nullString
    ifnd  gos_NullString
gos_NullString
    endc
    endm

getstring        macro         ;getstring ziel,quell,anz,pos
    ifeq  NARG-2
    movea.l  \1,a1
    moveq.l  #0,d0
    move.b  #\2-1,d0
    endc
    ifeq  NARG-3
    movea.l  \1,a1
    movea.l  \2,a0
    moveq.l  #0,d0
    move.b  #\3-1,d0
    endc
    ifeq  NARG-4
    movea.l  \1,a1
    movea.l  \2,a0
    moveq.l  #0,d0
    move.b  \3-1,d0
    lea  \4-1(a0),a0    ;#########
    endc
    bsr  s_vtov
    ifnd  gos_vtov
gos_vtov
    endc
    endm

chain                macro
    movea.l  \1,a0
    movea.l  \2,a1
    movea.l  \3,a2
    moveq.l  #0,d0
    move.b  \4-1,d0
    bsr  s_2in1o
    ifnd  gos_2in1o
gos_2in1o
    endc
    endm


comp                macro
    movea.l  \1,a0
    movea.l  \2,a1
    ifeq  NARG-3
    move.b  \3-1,d0
    endc
    ifeq  NARG-2
    move.b  #255,d0
    ENDC
    bsr  s_cmp0
    ifnd  gos_cmp0
gos_cmp0
    endc
    endm


getword             macro       ;getword ausPuff,inPuff[,ab Pos]  -> pos in d0
    movea.l  \1,a5
    movea.l  \2,a3
    moveq.l  #0,d0
    ifeq  NARG-3
    move.l  \3,d0
    sub.l  #1,d0
    add.l  d0,a5
    endc
    bsr  s_getstring
    ifnd  go_getstring2
go_getstring2
    endc
    endm



hex       macro
    move.l  \1,d2
    move.l  \2,a0
    bsr  sx_hex
    ifnd  gos_hex
gos_hex
    endc
    endm

copyvor      macro        copyvor Puffer,abPOS,Anzahl,GesPuffln,-POS ..ohne minus Zeichen
    move.l  \1,a0    ;Pufferadr
    move.l  \2-1,d0    ;Ab Pos
    move.l  \3-1,d1    ;Anzahl Zeichen
    move.l  \4,d2    ;Puffer Länge  des gesammten Puffers
    move.l  \5,d3    ;wieviel Zeichen vorher
    bsr  s_copyvor
    ifnd  gos_s_copyvor
gos_s_copyvor
    endc
    endm


copynach      macro       copynach Puffer,abPOS,Anzahl,GesPuffln,+POS ..ohne plusZeichen
    move.l  \1,a0    ;Pufferadr
    move.l  \2-1,d0    ;Ab Pos
    move.l  \3-1,d1    ;Anzahl Zeichen
    move.l  \4,d2    ;Puffer Länge   des gesammten Puffers
    move.l  \5,d3    ;wieviel Zeichen nacher
    bsr  s_copynach
    ifnd  gos_s_copynach
gos_s_copynach
    endc
    endm

inserts    macro         ;insert puffer,pos,Zeichen,Pufflen
    move.l  \1,a0    ;Pufferadr
    moveq.l  #0,d0
    move  \0,\2,d0    ;in Pos
    subq.l  #1,d0
    moveq.l  #0,d1
    move.b  \3,d1    ;Zeichen
    move.l  \4,d2    ;Puffer Länge  des gesammten Puffers
    bsr  s_insert_z
    ifnd  gos_s_insert_z
gos_s_insert_z
    endc
    endm

mem        MACRO
    move.l  4,a6
    move.l  \1,d0    ;angeforderte Menge in Byte
    move.l  #$10001,d1    ;Speichertyp
    jsr  -684(a6)    ;Funktion AllocMem()
    ifeq  NARG-2
    move.l  d0,\2    ;Puffername
    endc
    endm


free       MACRO
    move.l  4,a6
    move.l  \1,a1    ;Zeiger auf Speicherbereich
    jsr  -690(a6)    ;Funktion FreeMem()
    ENDM

DelIO     macro
    movea.l  4,a6
    movea.l  \1,a0
    jsr  -660(a6)
    movea.l  \2,a0
    jsr  -672(a6)
    endm


TimeIO    macro
    bra.s  _FC_timeo\@
    ifnd  _TimeReq
    cnop  0,4
_TimeReq  ds.l 1
_TimePort ds.l 1
_FC_timername  dc.b "timer.device",0
    even
    endc
_FC_timeo\@
    movea.l  4,a6
    jsr  -666(a6)    ;TimeIO
    move.l  d0,_TimePort    ;Port
    move.l  d0,a0
    clr.b  8(a0)
    move.l  #40,d0
    movea.l  4,a6
    jsr  -654(a6)
    move.l  d0,_TimeReq    ;IOReq

    endm

OpenTimer macro  ;OpenTimer Unit,sec,mic      Unit: Vblank=1,Cia=0
    TimeIO
    lea  _FC_timername,a0
    move.l  #\1,d0
    moveq.l  #0,d1
    movea.l  4,a6
    jsr  -444(a6)

    endm

CloseTimer  macro
    movea.l  4,a6
    movea.l  _TimeReq,a1
    jsr  -450(a6)
    DelIO  _TimeReq,_TimePort
    endm

SetTimer   macro                      ;SendTime sec,mic
    bsr  _s_settimer
    move.l  \1,32(a1)    ;secs
    move.l  \2,36(a1)    ;micros
    bsr  _s_settimer2
    ifnd  _s_gosettimer
_s_gosettimer
    endc
    endm



MakeIO    macro                    ;bis SetParams  sie OpenSer macro
    bra  _FC_sero\@
    ifnd  _SerWriteReq\1
    cnop  0,4
_SerWriteReq\1  ds.l 1
_SerReadReq\1   ds.l 1
_SerWritePort\1 ds.l 1
_SerReadPort\1  ds.l 1
    endc
_FC_sero\@
    movea.l  4,a6
    jsr  -666(a6)    ;MakeIO Nr,MsgPort,IOReq,Length
    ;tst.l d0
    ;beq  _SER_aus
    move.l  d0,\2    ;Port
    move.l  d0,a0
    clr.b  8(a0)
    move.l  \4,d0
    movea.l  4,a6
    jsr  -654(a6)
    move.l  d0,\3    ;IOReq
    ;tst.l d0
    ;beq  _Del_MsgPort
    endm

OpenSerDev  macro         ;OpenSerDev DevName,Unit,IOReq
    move.l  \3,a1
    move.l  #19200,60(a1)    ;baud
    move.b  #8,76(a1)    ;Bits 7 o 8
    move.b  #8,77(a1)
    move.b  #180,79(a1)    ;serFlags
    move.b  #1,78(a1)    ;stop
    move.l  #32768,52(a1)    ;Bufflen
    move.l  #250000,64(a1)    ;BreakTimee
    movea.l  \1,a0
    move.l  \2,d0
    moveq.l  #0,d1
    movea.l  4,a6
    jsr  -444(a6)
    endm

SetSerParams   macro

    move.l  \1,A1    ;IOReq
    move.l  #0,40(A1)
    move.l  #0,36(A1)

    IFC  '\2','Baud'
    move.l  \3,60(A1)    ;baud
    ENDC
    IFC  '\4','Baud'
    move.l  \5,60(A1)    ;baud
    ENDC
    IFC  '\6','Baud'
    move.l  \7,60(A1)    ;baud
    ENDC
    IFC  '\8','Baud'
    move.l  \9,60(A1)    ;baud
    ENDC
    IFC  '\10','Baud''
    move.l  \11,60(A1)   ;baud
    ENDC
    IFC '\12','Baud'
    move.l  \13,60(A1)   ;baud
    ENDC
    IFC '\14','Baud'
    move.l  \15,60(A1)   ;baud
    ENDC

    IFC '\2','Bits'
    move.b  \3,76(A1)   ;Bits
    move.b  \3,77(A1)   ;Bits
    ENDC
    IFC '\4','Bits'
    move.b  \5,76(A1)   ;Bits
    move.b  \5,77(A1)   ;Bits
    ENDC
    IFC '\6','Bits'
    move.b  \7,76(A1)   ;Bits
    move.b  \7,77(A1)   ;Bits
    ENDC
    IFC '\8','Bits'
    move.b  \9,76(A1)   ;Bits
    move.b  \9,77(A1)   ;Bits
    ENDC
    IFC '\10','Bits'
    move.b  \11,76(A1)   ;Bits
    move.b  \11,77(A1)   ;Bits
    ENDC
    IFC '\12','Bits'
    move.b  \13,76(A1)   ;Bits
    move.b  \13,77(A1)   ;Bits
    ENDC
    IFC '\14','Bits'
    move.b  \15,76(A1)   ;Bits
    move.b  \15,77(A1)   ;Bits
    ENDC

    IFC '\2','Flags'
    move.b  \3,79(A1)   ;Flags
    ENDC
    IFC '\4','Flags'
    move.b  \5,79(A1)   ;Flags
    ENDC
    IFC '\6','Flags'
    move.b  \7,79(A1)   ;Flags
    ENDC
    IFC '\8','Flags'
    move.b  \9,79(A1)   ;Flags
    ENDC
    IFC '\10','Flags'
    move.b  \11,79(A1)   ;Flags
    ENDC
    IFC '\12','Flags'
    move.b  \13,79(A1)   ;Flags
    ENDC
    IFC '\14','Flags'
    move.b  \15,79(A1)   ;Flags
    ENDC

    IFC '\2','Stop'
    move.b  \3,79(A1)   ;Stop
    ENDC
    IFC '\4','Stop'
    move.b  \5,79(A1)   ;Stop
    ENDC
    IFC '\6','Stop'
    move.b  \7,79(A1)   ;Stop
    ENDC
    IFC '\8','Stop'
    move.b  \9,79(A1)   ;Stop
    ENDC
    IFC '\10','Stop'
    move.b  \11,79(A1)   ;Stop
    ENDC
    IFC '\12','Stop'
    move.b  \13,79(A1)   ;Stop
    ENDC
    IFC '\14','Stop'
    move.b  \15,79(A1)   ;Stop
    ENDC

    IFC '\2','Buffer'
    move.l  \3,52(A1)   ;Buffer
    ENDC
    IFC '\4','Buffer'
    move.l  \5,52(A1)   ;Buffer
    ENDC
    IFC '\6','Buffer'
    move.l  \7,52(A1)   ;Buffer
    ENDC
    IFC '\8','Buffer'
    move.l  \9,52(A1)   ;Buffer
    ENDC
    IFC '\10','Buffer'
    move.l  \11,52(A1)   ;Buffer
    ENDC
    IFC '\12','Buffer'
    move.l  \13,52(A1)   ;Buffer
    ENDC
    IFC '\14','Buffer'
    move.l  \15,52(A1)   ;Buffer
    ENDC


    IFC '\2','Break'
    move.l  \3,64(A1)   ;Break
    ENDC
    IFC '\4','Break'
    move.l  \5,64(A1)   ;Break
    ENDC
    IFC '\6','Break'
    move.l  \7,64(A1)   ;Break
    ENDC
    IFC '\8','Break'
    move.l  \9,64(A1)   ;Break
    ENDC
    IFC '\10','Break'
    move.l  \11,64(A1)   ;Break
    ENDC
    IFC '\12','Break'
    move.l  \13,64(A1)   ;Break
    ENDC
    IFC '\14','Break'
    move.l  \15,64(A1)   ;Break
    ENDC


    move.w  #CMDset,28(A1)
    movea.l 4,a6
    jsr   -456(a6)
    endm


CloseSer  macro             ; CloseSer  Nummer
    movea.l 4,a6
    movea.l _SerWriteReq\1,a1
    jsr -450(a6)
    DelIO _SerReadReq\1,_SerReadPort\1
    DelIO _SerWriteReq\1,_SerWritePort\1
    endm

OpenSer   macro  ;OpenSer Nr,Name,Unit,[Baud,#19200,Bits,#8,Flags,#180,Stop,#1,Buffer,#32000,Break,



    MakeIO \1,_SerWritePort\1,_SerWriteReq\1,#82  ,#82
    MakeIO \1,_SerReadPort\1,_SerReadReq\1,#82  82
    OpenSerDev \2,\3,_SerWriteReq\1
    move.l  _SerWriteReq\1,a0
    move.l  _SerReadReq\1,a1
    move.l  20(a0),20(a1)
    move.l  24(a0),24(a1)
    ifeq NARG-5
    SetSerParams _SerWriteReq\1,\4,\5
    SetSerParams _SerReadReq\1,\4,\5
    endc
    ifeq NARG-7
    SetSerParams _SerWriteReq\1,\4,\5,\6,\7
    SetSerParams _SerReadReq\1,\4,\5,\6,\7
    endc
    ifeq NARG-9
    SetSerParams _SerWriteReq\1,\4,\5,\6,\7,\8,\9  \8,\9
    SetSerParams _SerReadReq\1,\4,\5,\6,\7,\8,\9  8,\9
    endc
    ifeq NARG-11
    SetSerParams _SerWriteReq\1,\4,\5,\6,\7,\8,\9,\10,\11  \8,\9,\10,\11
    SetSerParams _SerReadReq\1,\4,\5,\6,\7,\8,\9,\10,\11  8,\9,\10,\11
    endc
    ifeq NARG-13
    SetSerParams _SerWriteReq\1,\4,\5,\6,\7,\8,\9,\10,\11,\12,\13  \8,\9,\10,\11,\12,\13
    SetSerParams _SerReadReq\1,\4,\5,\6,\7,\8,\9,\10,\11,\12,\13  8,\9,\10,\11,\12,\13
    endc
    ifeq NARG-15
    SetSerParams _SerWriteReq\1,\4,\5,\6,\7,\8,\9,\10,\11,\12,\13,\14,\15  \8,\9,\10,\11,\12,\13,\14,\15
    SetSerParams _SerReadReq\1,\4,\5,\6,\7,\8,\9,\10,\11,\12,\13,\14,\15  8,\9,\10,\11,\12,\13,\14,\15
    endc

    endm

WriteSer   macro                   ;writeser Nr #Buff,#len
    move.l  _SerWriteReq\1,a1
    move.l  \2,40(a1)
    move.l  \3,36(a1)
    move.w  #CMDwrite,28(a1)
    movea.l 4,a6
    jsr -456(a6)
    endm


readser   macro                    ;readser Nr #Buff,#len
    move.l  _SerReadReq\1,a1
    move.l  \2,40(a1)
    move.l  \3,36(a1)
    move.w  #CMDread,28(a1)
    movea.l 4,a6
    jsr -456(a6)
    endm

putser   macro
    move.l  _SerWriteReq\1,a1      ;putser Nr #Buff,#len  r #Buff,#len
    move.l  \2,40(a1)
    move.l  \3,36(a1)
    move.w  #CMDwrite,28(a1)
    movea.l 4,a6
    jsr -462(a6)
    endm

getser   macro                      ;getser Nr #Buff,#len
    move.l  _SerReadReq\1,a1
    move.l  \2,40(a1)
    move.l  \3,36(a1)
    move.w  #CMDread,28(a1)
    movea.l 4,a6
    jsr -462(a6)
    endm

NoCarrier   macro         ;CheckCD AusLabel ... wenn kein Carrier dann goto Label
    move.l  _SerReadReq\1,a1
    bsr  ser_getStatus
    btst.b  #5,80(a1)
    beq  CCDaus\@
    bra \1
CCDaus\@
    endm


CheckReadBuff  macro
    move.l  _SerReadReq\1,a1
    bsr  ser_getStatus
    IFEQ NARG-2
    move.l 32(a1),\2
    ENDC
    endm

CheckWriteBuff  macro
    move.l  _SerWriteReq\1,a1
    bsr  ser_getStatus
    move.l 32(a1),d0
    endm




ser_read_doio  macro
    movea.l _SerReadReq\1,a1
    movea.l 4,a6
    jsr -456(a6)
    endm

ser_write_doio  macro
    movea.l _SerWriteReq\1,a1
    movea.l 4,a6
    jsr -456(a6)
    endm


ser_read_sendio  macro
    movea.l _SerReadReq\1,a1
    movea.l 4,a6
    jsr -462(a6)
    endm

ser_write_sendio  macro
    movea.l _SerWriteReq\1,a1
    movea.l 4,a6
    jsr -462(a6)
    endm

ser_read_checkio  macro
    movea.l _SerReadReq\1,a1
    movea.l 4,a6
    jsr -468(a6)
    endm

ser_write_checkio  macro
    movea.l _SerWriteReq\1,a1
    movea.l 4,a6
    jsr -468(a6)
    endm

ser_read_waitio  macro
    movea.l _SerReadReq\1,a1
    movea.l 4,a6
    jsr -474(a6)
    endm

ser_write_waitio  macro
    movea.l _SerWriteReq\1,a1
    movea.l 4,a6
    jsr -474(a6)
    endm

ser_read_abortio  macro
    movea.l _SerReadReq\1,a1
    movea.l 4,a6
    jsr -480(a6)
    endm

ser_write_abortio  macro
    movea.l _SerWriteReq\1,a1
    movea.l 4,a6
    jsr -480(a6)
    endm


SetSer   macro    ;SetSer Nr,Buffer,Länge
    movea.l _SerReadPort\1,a0
    bsr _FC_setser1
    movea.l _SerReadReq\1,a1
    move.l  \2,40(a1)
    move.l  \3,36(a1)

    bsr _FC_setser2
    ifnd _s_setser
_s_setser
    endc
    endm


Set_C     macro
    ifnd _s_goset_c
_s_goset_c
    endc
    endm

TaskWait  macro
    movea.l 4,a6
    moveq.l #0,d0
    IFC "\1","C"
    or.l _Sig_C,d0
    endc
    IFC "\2","C"
    or.l _Sig_C,d0
    endc
    IFC "\3","C"
    or.l _Sig_C,d0
    endc
    IFC "\4","C"
    or.l _Sig_C,d0
    endc
    IFC "\5","C"
    or.l _Sig_C,d0
    endc
    IFC "\6","C"
    or.l _Sig_C,d0
    endc
    IFC "\7","C"
    or.l _Sig_C,d0
    endc
    IFC "\8","C"
    or.l _Sig_C,d0
    endc
    IFC "\9","C"
    or.l _Sig_C,d0
    endc
    IFC "\10","C"
    or.l _Sig_C,d0
    endc

    IFC "\1","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\2","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\3","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\4","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\5","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\6","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\7","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\8","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\9","Time"
    or.l _Sig_Time,d0
    endc
    IFC "\10","Time"
    or.l _Sig_Time,d0
    endc

    IFC "\1","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\2","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\3","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\4","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\5","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\6","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\7","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\8","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\9","Ser"
    or.l _Sig_Ser,d0
    endc
    IFC "\10","Ser"
    or.l _Sig_Ser,d0
    endc

    jsr -318(a6)
    endm

