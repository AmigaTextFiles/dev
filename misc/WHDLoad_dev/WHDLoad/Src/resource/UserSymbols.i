
* $Id: UserSymbols.i 1.2 2003/03/29 13:35:13 wepl Exp $

ByteSymbol     macro
               dc.b    '\1'
               dc.b    0
               dc.b    (\2)
               endm

WordSymbol     macro
               dc.b    '\1'
               dc.b    0
               dc.b    ((\2>>8)&$FF)
               dc.b    (\2&$FF)
               endm

LongSymbol     macro
               dc.b    '\1'
               dc.b    0
               dc.b    ((\2>>24)&$FF)
               dc.b    ((\2>>16)&$FF)
               dc.b    ((\2>>8)&$FF)
               dc.b    (\2&$FF)
               endm

ORedSymbol     macro
               dc.b    '\1'
               dc.b    0
               dc.b    ((\2>>24)&$FF)
               dc.b    ((\2>>16)&$FF)
               dc.b    ((\2>>8)&$FF)
               dc.b    (\2&$FF)
               dc.b    ((\3>>24)&$FF)
               dc.b    ((\3>>16)&$FF)
               dc.b    ((\3>>8)&$FF)
               dc.b    (\3&$FF)
               endm

OREDSYM        equ     1<<7            ;Symbol base using OR'd symbols
SIGNEDSYM      equ     1<<4            ;Symbol base using signed symbols
BYTESYM        equ     1<<0            ;Symbol base using byte symbols
WORDSYM        equ     1<<1            ;Symbol base using word symbols
LONGSYM        equ     BYTESYM!WORDSYM ;Symbol base using long symbols
ENDBASE        equ     $FF             ;Token to end symbol base

