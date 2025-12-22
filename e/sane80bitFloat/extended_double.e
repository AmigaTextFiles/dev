-> This module is a raw extract from the MusicIn 'common.c/h'
-> source found on aminet in the archive: MusicIn.lha .
-> It has been ported to AmigaE by Deniil 715!
-> Every character from the C-source was intact when I left it
-> with exception for blanklines and spaces.

OPT MODULE

/***********************************************************************
*
*  Routines to convert between the Apple SANE extended floating point
*  format and the IEEE double precision floating point format.
*
***********************************************************************/

/*
*** Apple's 80-bit SANE extended has the following format:

 1       15      1            63
+-+-------------+-+-----------------------------+
|s|       e     |i|            f                |
+-+-------------+-+-----------------------------+
  msb        lsb   msb                       lsb

The value v of the number is determined by these fields as follows:
If 0 <= e < 32767,              then v = (-1)^s * 2^(e-16383) * (i.f).
If e == 32767 and f == 0,       then v = (-1)^s * (infinity), regardless of i.
If e == 32767 and f != 0,       then v is a NaN, regardless of i.

*** IEEE Draft Standard 754 Double Precision has the following format:

MSB
+-+---------+-----------------------------+
|1| 11 Bits |           52 Bits           |
+-+---------+-----------------------------+
 ^     ^                ^
 |     |                |
 Sign  Exponent         Mantissa
*/

/* Double and SANE Floating Point Type Definitions */

/*
typedef struct  IEEE_DBL_struct {
    unsigned long   hi;
    unsigned long   lo;
} IEEE_DBL;
*/

EXPORT OBJECT ieee_dbl
 hi:LONG
 lo:LONG
ENDOBJECT

/*
typedef struct  SANE_EXT_struct {
    unsigned long   l1;
    unsigned long   l2;
    unsigned short  s1;
} SANE_EXT;
*/

EXPORT OBJECT sane_ext
 l1:LONG
 l2:LONG
 s1:INT
ENDOBJECT

/***********************************************************************
*
*  double_to_extended()
*
*  Purpose:     Convert from IEEE double precision format to SANE
*               extended format.
*
*  Passed:      Pointer to the double precision number and a pointer to
*               what will hold the Apple SANE extended format value.
*
*  Outputs:     The SANE extended format pointer will be filled with
*               the converted value.
*
*  Returned:    Nothing. (E-version returns ext-ptr for convenience)
*
***********************************************************************/

->void double_to_extended(pd, ps)
->double *pd;
->char ps[10];
->{
EXPORT PROC double_to_extended(p_dbl:PTR TO ieee_dbl,p_ext:PTR TO sane_ext)

->register unsigned long  top2bits;
->register unsigned short *ps2;
->register IEEE_DBL       *p_dbl;
->register SANE_EXT       *p_ext;
 DEF top2bits

->#ifdef  MACINTOSH

->        x96tox80(pd, (extended *) ps);

->#else

->   p_dbl = (IEEE_DBL *) pd;
->   p_ext = (SANE_EXT *) ps;

->   top2bits = p_dbl->hi & 0xc0000000;
 top2bits:=p_dbl.hi AND $c0000000

->   p_ext->l1 = ((p_dbl->hi >> 4) & 0x3ff0000) | top2bits;
 p_ext.l1:=shr(p_dbl.hi,4) AND $3ff0000 OR top2bits

->   p_ext->l1 |= ((p_dbl->hi >> 5) & 0x7fff) | 0x8000;
 p_ext.l1:=shr(p_dbl.hi,5) AND $7fff OR $8000 OR p_ext.l1

->   p_ext->l2 = (p_dbl->hi << 27) & 0xf8000000;
 p_ext.l2:=Shl(p_dbl.hi,27) AND $f8000000

->   p_ext->l2 |= ((p_dbl->lo >> 5) & 0x07ffffff);
 p_ext.l2:=shr(p_dbl.lo,5) AND $07ffffff OR p_ext.l2

->   ps2 = (unsigned short *) & (p_dbl->lo);
->   ps2++;
->   p_ext->s1 = (*ps2 << 11) & 0xf800;
 p_ext.s1:=Shl(p_dbl.lo,11) AND $f800

->#endif

->}
ENDPROC p_ext

/***********************************************************************
*
*  extended_to_double()
*
*  Purpose:     Convert from SANE extended format to IEEE double
*               precision format.
*
*  Passed:      Pointer to the Apple SANE extended format value and a
*               pointer to what will hold the IEEE double precision number.
*
*  Outputs:     The IEEE double precision format pointer will be filled
*               with the converted value.
*
*  Returned:    Nothing. (E-version return dbl-ptr for convenience)
*
***********************************************************************/

->void extended_to_double(ps, pd)
->char ps[10];
->double *pd;
->{
EXPORT PROC extended_to_double(p_ext:PTR TO sane_ext,p_dbl:PTR TO ieee_dbl)

->register unsigned long  top2bits;
->register IEEE_DBL       *p_dbl;
->register SANE_EXT       *p_ext;
 DEF top2bits

->#ifdef  MACINTOSH

->   x80tox96((extended *) ps, pd);

->#else

->   p_dbl = (IEEE_DBL *) pd;
->   p_ext = (SANE_EXT *) ps;

->   top2bits = p_ext->l1 & 0xc0000000;
 top2bits:=p_ext.l1 AND $c0000000

->   p_dbl->hi = ((p_ext->l1 << 4) & 0x3ff00000) | top2bits;
 p_dbl.hi:=Shl(p_ext.l1,4) AND $3ff00000 OR top2bits

->   p_dbl->hi |= (p_ext->l1 << 5) & 0xffff0;
 p_dbl.hi:=Shl(p_ext.l1,5) AND $ffff0 OR p_dbl.hi

->   p_dbl->hi |= (p_ext->l2 >> 27) & 0x1f;
 p_dbl.hi:=shr(p_ext.l2,27) AND $1f OR p_dbl.hi

->   p_dbl->lo = (p_ext->l2 << 5) & 0xffffffe0;
 p_dbl.lo:=Shl(p_ext.l2,5) AND $ffffffe0

->   p_dbl->lo |= (unsigned long) ((p_ext->s1 >> 11) & 0x1f);
 p_dbl.lo:=shr(p_ext.s1,11) AND $1f OR p_dbl.lo

->#endif

->}
ENDPROC p_dbl

-> this is for E has no Logic shift right, just arithmetic
PROC shr(x,y)
 MOVE.L x,D0
 MOVE.L y,D1
 LSR.L  D1,D0
ENDPROC D0