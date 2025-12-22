@q this file is part of the c2cweb package Version 1.4 @>

@q this is the file compiler.w @>
@q written by Werner Lemberg (a7621gac@@awiuni11.bitnet) 20-Aug-1994 @>


@q the format definitions below are just examples and not complete! @>

@q definition strings @>

% A4 paper format

\fullpageheight=240mm
\pageheight=223mm
\pagewidth=158mm
\setpage

\def\botofcontents{
  \vfill
  \centerline{This document was produced with the \.{c2cweb}
              program by Werner Lemberg}}

\input c2cweb.ger       @q uncomment this if not needed @>

\def\xWindows{\.{\_Windows}}
\def\xxcplusplus{\.{\_\_cplusplus}}


@s error x      @q if you use C++ 3.0, you must delete this line @>
@s line  x      @q if you want to use the #line preprocessor command, delete this line @>


@q most of the DOS C and C++ compilers need that stuff @>

@s _cdecl const 
@s cdecl const
@s _cs const
@s _ds const
@s _es const
@s _export const
@s _far const
@s far const
@s huge const
@s interrupt const
@s _loadds const
@s _near const
@s near const
@s _pascal const
@s pascal const
@s _saveregs const
@s _seg const
@s _ss const

@s _Windows TeX
@s __cplusplus TeX


@q some GNU C directives @>

@s asm const
@s inline const
@s const const
@s __asm__ const
@s __inline__ const
@s __const__ const
@s __label__ int
@s __attribute__ int
@s __alignof__ sizeof
