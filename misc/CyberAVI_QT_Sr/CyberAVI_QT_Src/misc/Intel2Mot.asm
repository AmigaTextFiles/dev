;prog:phxass/gigaphxass asm/Intel2Mot.asm to obj/Intel2Mot.o noexe

    SECTION Intel,CODE

    XDEF    _LSB2MSBLong

; ulong LSB2MSBLong(unsigned long x)
; {
;   return (x & 0xff000000) >> 24 | (x & 0x00ff0000) >> 8 | (x & 0x0000ff00) << 8 | (x & 0x000000ff) << 24;
; }

_LSB2MSBLong:
    moveq   #8,d1
    rol.w   d1,d0
    swap    d0
    rol.w   d1,d0

    rts

    XDEF    _LSB2MSBShort

_LSB2MSBShort:
    rol.w   #8,d0
    and.l   #$0000ffff,d0
    rts



    XDEF    _ByteTo32

; ulong ByteTo32(unsigned char x)
; {
;   ulong t;
;   t=x<<8 | x;
;   return t << 16 | t;
; }

_ByteTo32:
    and.l   #$000000ff,d0
    move.l  d0,d1
    asl.l   #8,d1
    or.l    d0,d1
    move.l  d1,d0
    swap    d0
    clr.w   d0
    or.l    d1,d0
    rts



    XDEF    _ShortTo32

; ulong ShortTo32(ushort x)
; {
;   ulong t;
;   t=x<<16 | x;
;   return t << 16 | t;
; }

_ShortTo32:
    and.l   #$0000ffff,d0
    move.l  d0,d1
    swap    d0
    clr.w   d0
    or.l    d1,d0
    rts



    XDEF    _Round

; ulong Round(ulong x, ulong r)
; {
;   return ((x+r-1)*r)/r;
; }

_Round:
    add.l   d1,d0
    subq.l  #1,d0
    divu.l  d1,d0
    mulu.l  d1,d0
    rts

    END
