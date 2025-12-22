
I. Introduction

FOCAL is a interpretitive language developed by Digital Equipment Corporation
(DEC) for the PDP-8 family of computers. This version is written in C and runs
under several different operating systems. 


II. Build FOCAL

Lunix/Unix:

$ make

The make attempts to figure out which system to make for using uname.

WinBlows:

$ nmake nt

The supported operating system targets are:

   linux   - Linux
   nt      - Windows (NT)
   openvms - OpenVMS (also vaxvms)
   os2     - IBM OS/2
   riscos  - MIPS RiscOS 
   solaris - Sun Solaris
   sunos   - Sun OS (pre Solaris)
   uss     - Unix Systems Services under OS/390 and z/OS


III. To run FOCAL

$ focal [program]

Where an optional program may be specified. When the program is given Focal
will read and execute the program and will terminate on program exit.


IV. FOCAL commands

The following list shows a simplified syntax. For more information on
programming in Focal consult the references below.

    A[SK] ["PROMPT",] <VAR> ...
    C[ONTINUE]
    D[O] ['?'] <GROUP>[.<STEP>]
    E[RASE] [A[LL] | <GROUP>[.<STEP]]
    F[OR] <VAR>=<START>[,<INC>],<END>; <COMMAND>
    G[OTO] ['?'] [<LINE>]
    H[ELP] [<COMMAND>]
    I[F] (<EXPRESSION>) <LINE> [,<LINE>[,<LINE>]]
    L[IBRARY] C[ALL] <FILENAME>
    L[IBRARY] L[IST] [<PATHNAME>]
    L[IBRARY] P[RINT] <FILENAME>
    L[IBRARY] S[AVE] <FILENAME>
    L[IBRARY] W[ORK] <DIRNAME>
    M[ODIFY] <LINE> /OLDPATTERN/NEWPATTERN/
    Q[UIT]
    R[ETURN]
    S[ET] <VAR> = <EXPRESSION>
    T[YPE] ["TEXT",] | <PRECISION> | <CURSOR> | <VAR> | <EXPRESSION> ...
    W[RITE] [A[LL] | <GROUP>[.<STEP]]


V. References

Wikepedia page:
    http://en.wikipedia.org/wiki/FOCAL-69 

Focal promotional book:
    http://www.cs.uiowa.edu/~jones/pdp8/focal/focal69.html

DEC Introduction to Programming (Chapter 9):
    http://www.bitsavers.org/pdf/dec/pdp8/handbooks/IntroToProgramming1969.pdf 


