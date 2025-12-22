$!-----------------------------
$! Generate the C2MAN.EXE
$!-----------------------------
$!CC	 = "CC"					! Uncomment if using VAX-C
$ CC	 = "GCC"				! Uncomment if using GCC
$!-----------------------------
$ CFLAGS = "/Include=([.VMS],[.LIBC])/NOOPT"
$!CFLAGS = "/Include=([.VMS],[.LIBC])/NOOPT/DEBUG"
$!-----------------------------
$!OPTFILE= "[.VMS]C2MAN.OPT-VAXC"		! Uncomment if using VAX-C
$ OPTFILE= "[.VMS]C2MAN.OPT-GCC"		! Uncomment if using GCC
$!-----------------------------
$ LFLAGS = "/NOMAP"
$!LFLAGS = "/DEBUG/NOMAP"			! Uncomment if you want /DEBUG
$!-----------------------------
$ BFLAGS = "/NOLINES"				! Don't uncomment.. otherwise linker errors!
$ ECHO 	:= "WRITE SYS$OUTPUT"
$!
$ ECHO "Compiling GETOPT.C..."
$ 'CC' 'CFLAGS' [.LIBC]GETOPT.C
$ ECHO "Compiling ALLOCA.C..."
$ 'CC' 'CFLAGS' [.LIBC]ALLOCA.C
$ ECHO "Compiling POPEN.C..."
$ 'CC' 'CFLAGS' [.VMS]POPEN.C
$ ECHO "Compiling C2MAN.C..."
$ 'CC' 'CFLAGS' C2MAN
$ ECHO "Compiling ENUM.C..."
$ 'CC' 'CFLAGS' ENUM
$ ECHO "Compiling LATEX.C..."
$ 'CC' 'CFLAGS' LATEX
$ ECHO "Compiling MANPAGE.C..."
$ 'CC' 'CFLAGS' MANPAGE
$ ECHO "Compiling NROFF.C..."
$ 'CC' 'CFLAGS' NROFF
$ ECHO "Compiling SEMANTIC.C..."
$ 'CC' 'CFLAGS' SEMANTIC
$ ECHO "Compiling STRAPPEND.C..."
$ 'CC' 'CFLAGS' STRAPPEND
$ ECHO "Compiling STRCONCAT.C..."
$ 'CC' 'CFLAGS' STRCONCAT
$ ECHO "Compiling STRING.C..."
$ 'CC' 'CFLAGS' STRING
$ ECHO "Compiling SYMBOL.C..."
$ 'CC' 'CFLAGS' SYMBOL
$ ECHO "Compiling TEXINFO.C..."
$ 'CC' 'CFLAGS' TEXINFO
$ ECHO "Invoking Bison.. Expect 54 Shift/reduce conflicts..."
$ BISON 'BFLAGS' GRAMMAR.Y
$ ECHO "Invoking Flex..."
$ FLEX -n LEX.L
$ ECHO "Compiling GRAMMAR_TAB.C (results of Bison & Flex)..."
$ 'CC' 'CFLAGS' GRAMMAR_TAB
$ ECHO "Linking C2MAN..."
$ LINK 'OPTFILE'/OPT'LFLAGS'
$ ECHO "Done.."
$ EXIT
