
  BUILDING MEGALZ FROM SOURCES.

 I. Source code.

 MegaLZ  pc  packer/depacker  is  written  completely  in C in a
portable  manner.   Complete  source  code  is situated in "Src"
directory.


 II. How to build.

 WIN32:   Use project files for MSVC given in "Win32" directory.
Don't  forget  to  switch  to the 'Release' configuration before
compiling.  It is also possible to use latest "dotnet" compilers
as   far  as  they  support  loading  old  MSVC  projects.   For
cygwin/mingw try to use unix make file (see below).

 AmigaOS:   For SAS/C environment you can use make file supplied
in "Amiga" directory.  Just invoke "smake" in that directory and
enjoy!  =)

 Unix:  basic makefile supplied in "Unices" directory.  So far I
have  built  MegaLZ  successfully  under  gcc 3.2.3, i586, linux
redhat 7.3.

 ARM:   I  don't  really  know  why in hell you would need to do
that, but please direct all questions to my email - I'll provide
you   connection  with  kl^mhm,  who's  done  that  for  unknown
purposes.


 III. Types.

 The   code   was  written  for  generic  32  bit  machine  (and
particularly,  in  amiga-style  C  programming  manner), so some
common  integer  types  are  used:   LONG and ULONG - signed and
unsigned  32  bit integers, WORD and UWORD - signed and unsigned
16  bit  integers,  BYTE  and  UBYTE - signed and unsigned 8 bit
integers.   These types defined in MegaLZ_types.h.  When porting
to specific architecture, adjust this file accordingly.  In some
cases,  mostly  when using standard C environment, standard type
"int" is used.


 IV. Depacker specific.

 It is also possible to use MegaLZ C depacker separately in your
programs. For details see "DEPACKING" file.
