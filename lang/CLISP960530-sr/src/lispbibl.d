# Haupt-Include-File für CLISP
# Bruno Haible 23.6.1995
# Marcus Daniels 11.11.1994


# Implementation ist auf folgende Rechner, Betriebssysteme und C-Compiler
# vorbereitet. (Nur ungefähre Liste, Genaues siehe PLATFORMS.)
# Maschine     Hersteller         Betriebssystem                C-Compiler    erkennbar an
# AMIGA        Commodore          AMIGA-OS (AMIGADOS)           GNU           amiga oder AMIGA, __GNUC__, evtl. MC68000 oder AMIGA3000
# beliebig     beliebig           UNIX                          GNU           unix, __GNUC__, ...
# beliebig     beliebig           UNIX                          CC            unix, ...
# Amiga 3000   Commodore          Amiga UNIX 2.1 SVR4.0         GNU           unix, __unix__, AMIX, __AMIX__, __svr4__, m68k, __m68k__, __motorola__, __GNUC__
# SUN-3        Sun                SUN-OS3 (UNIX BSD 4.2)        GNU           sun, unix, mc68020, __GNUC__
# SUN-3        Sun                SUN-OS4 (UNIX SUNOS 4.1)      GNU           sun, unix, mc68020, __GNUC__
# SUN-386      Sun                SUN-OS4 (UNIX SUNOS 4.0)      GNU           sun, unix, sun386, i386, __GNUC__
# SUN-386      Sun                SUN-OS4 (UNIX SUNOS 4.0)      CC            sun, unix, sun386, i386
# SUN-4        Sun                SUN-OS4 (UNIX SUNOS 4.1)      GNU           sun, unix, sparc, __GNUC__
# SUN-4        Sun                SUN-OS4 (UNIX SUNOS 4.1)      CC            sun, unix, sparc
# SUN-4        Sun                SUN-OS5 (UNIX Solaris)        GCC           sun, unix, sparc, __GNUC__
# IBM-PC/386   beliebig           SUN-OS5 (UNIX Solaris)        GCC           sun, unix, __svr4__, i386, __GNUC__
# HP9000-300   Hewlett-Packard    NetBSD 0.9 (UNIX BSD 4.3)     GNU           unix, __NetBSD__, mc68000, __GNUC__
# HP9000-300   Hewlett-Packard    HP-UX 8.0 (UNIX SYS V)        GNU           [__]hpux, [__]unix, [__]hp9000s300, mc68000, __GNUC__
# HP9000-800   Hewlett-Packard    HP-UX 8.0 (UNIX SYS V)        GNU           [__]hpux, [__]unix, [__]hp9000s800
# IRIS         Silicon Graphics   IRIX (UNIX SYS V 3.2)         GNU           unix, SVR3, mips, sgi, __GNUC__
# IRIS         Silicon Graphics   IRIX (UNIX SYS V)             cc -ansi      [__]unix, [__]SVR3, [__]mips, [__]sgi
# IRIS         Silicon Graphics   IRIX 5 (UNIX SYS V 4)         GNU           [__]unix, [__]SYSTYPE_SVR4, [__]mips, [__]host_mips, [__]MIPSEB, [__]sgi, __DSO__, [__]_MODERN_C, __GNUC__
# DECstation 5000                 RISC/OS (Ultrix V4.2A)        GNU           unix, [__]mips, [__]ultrix
# DG-UX 88k    Data General       DG/UX                         GNU           unix, m88000, DGUX
# DEC Alpha    DEC                OSF/1 1.3                     cc            [unix,] __unix__, __osf__, __alpha
# DEC Alpha    DEC                OSF/1 1.3                     GNU           unix, __unix__, __osf__, __alpha, __alpha__, _LONGLONG
# Apple MacII  Apple              A/UX (UNIX SYS V 2)           GNU           [__]unix, [__]AUX, [__]macII, [__]m68k, mc68020, mc68881, __GNUC__
# NeXT         NeXT               NeXTstep 3.1 (UNIX)           cc            NeXT, m68k; NEXTAPP für NeXTstep-Applikation
# Sequent      Sequent            PTX 3.2.0 V2.1.0 i386 (SYS V) GNU           unix, i386, _SEQUENT_, __GNUC__
# Convex C2    Convex             ConvexOS 10.1                 GNU           __convex__, __GNUC__
# IBM RS/6000  IBM                AIX 3.2                       GNU           _AIX, _AIX32, _IBMR2, __CHAR_UNSIGNED__, __GNUC__
# IBM-PC/386   beliebig           LINUX (freies UNIX)           GNU           unix, linux, i386, __GNUC__
# IBM-PC/386   beliebig           386BSD 0.1 (UNIX BSD 4.2)     GNU           unix, __386BSD__, i386, __GNUC__
# IBM-PC/386   beliebig           NetBSD 0.9 (UNIX BSD 4.3)     GNU           unix, __NetBSD__, i386, __GNUC__
# IBM-PC/386   beliebig           DJUNIX (UNIXlike auf MSDOS)   GNU           unix, i386, [__MSDOS__,] __GNUC__, __GO32__; __GO32__ muß man evtl. selbst definieren!
# IBM-PC/386   beliebig           EMX (UNIXlike auf MSDOS)      GNU           [unix,] i386, __GNUC__, __EMX__
# IBM-PC/386   beliebig           EMX (UNIXlike auf OS/2)       GNU           [unix,] i386, __GNUC__, __EMX__, OS2; OS2 muß man selbst definieren!
# IBM-PC/386   beliebig           MSDOS + MS Windows 3.1 + RSX  GNU           [unix,] i386, __GNUC__, __EMX__, WINDOWS; WINDOWS muß man selbst definieren!
# IBM-PC/386   beliebig           MSDOS                         WATCOM        MSDOS, __386__, M_I386, __WATCOMC__, __FLAT__
# IBM-PC/386   beliebig           MSDOS + MS Windows 3.1        WATCOM        __WINDOWS_386__, __386__, M_I386, __WATCOMC__, __FLAT__
# RM400        Siemens-Nixdorf    SINIX-N 5.42                  c89           unix, mips, MIPSEB, host_mips, sinix, SNI, _XPG_IV
# Acorn        Risc PC            RISC OS 3.x                   GNU           [__]arm, [__]riscos, __GNUC__
# Acorn        Risc PC            RISC OS 3.x                   Norcroft      [__]arm, [__]riscos
# APPLE IIGS   Apple              ??                            ??
# Für ANSI-C-Compiler: verwende Präprozessoren comment5, ansidecl.
# Für traditionelle C-Compiler: verwende Präprozessoren comment5, traddecl
#   und evtl. gcc-cpp, ccpaux, deelif, deerror und mergestrings.


# diese Maschine: AMIGA oder DOSPC oder ACORN oder GENERIC_UNIX
#if (defined(__unix) || defined(sinix)) && !defined(unix)
  #define unix
#endif
#if (defined(amiga) || defined(AMIGA))
  #undef AMIGA
  #define AMIGA
#endif
#if (defined(arm) || defined(__arm)) && (defined(riscos) || defined(__riscos))
  #define ACORN
#endif
#if (defined(i386) && defined(__EMX__)) || defined(__GO32__) || (defined(__386__) && defined(__WATCOMC__) && (defined(MSDOS) || defined(__WINDOWS_386__))) || (defined(__WINNT__) && !defined(__CYGWIN32__))
  #define DOSPC
#endif
#if !(defined(AMIGA) || defined(DOSPC) || defined(ACORN))
  #if defined(unix)
    #define GENERIC_UNIX
  #elif defined(__CYGWIN32__)
    #define WIN32_UNIX
  #else
    #error "Unknown machine type -- Maschine neu einstellen!"
  #endif
#endif
# Zusätzliche Spezifikation der Maschine:
#ifdef DOSPC
  #define PC386 # IBMPC-Kompatibler mit 80386/80486-Prozessor
#endif
#ifdef GENERIC_UNIX
  #if (defined(sun) && defined(unix) && defined(sun386))
    #define SUN386
  #endif
  #if (defined(unix) && defined(linux) && defined(i386))
    #define PC386
  #endif
  #if (defined(sun) && defined(unix) && defined(mc68020))
    #define SUN3
  #endif
  #if (defined(sun) && defined(unix) && defined(sparc))
    #define SUN4
    # evtl. SUN4_29 falls nur Adressen <2^29 unterstützt werden.
  #endif
  #if defined(hp9000s800) || defined(__hp9000s800)
    #define HP8XX
  #endif
#endif

# Auswahl des Prozessors:
# MC680X0 == alle Prozessoren der Motorola-68000-Serie
# MC680Y0 == alle Prozessoren der Motorola-68000-Serie ab MC68020
# SPARC == der Sun-SPARC-Prozessor
# HPPA == alle Prozessoren der HP-Precision-Architecture
# MIPS == der Mips-Prozessor
# M88000 == alle Prozessoren der Motorola-88000-Serie
# RS6000 == der IBM-RS/6000-Prozessor
# I80X86 == alle Prozessoren der Intel-8086-Serie
# I80Y86 == alle Prozessoren der Intel-8086-Serie ab 80286
# I80Z86 == alle Prozessoren der Intel-8086-Serie ab 80386
# VAX == der VAX-Prozessor
# CONVEX == der Convex-Prozessor
# ARM == der ARM-Prozessor
# DECALPHA == der DEC-Alpha-Chip
#ifdef AMIGA
  #define MC680X0
  #if defined(AMIGA3000) && !defined(MC680Y0)
    #define MC680Y0
  #endif
#endif
#ifdef DOSPC
  #define I80X86
  #define I80Y86
  #define I80Z86
#endif
#if 0
  #define VAX
#endif
#if defined(arm) || defined(__arm)
  #define ARM
#endif
#if defined(GENERIC_UNIX) || defined(WIN32_UNIX)
  #if defined(m68k) || defined(mc68000)
    #define MC680X0
  #endif
  #if defined(mc68020) || (defined(m68k) && defined(NeXT))
    #define MC680X0
    #define MC680Y0
  #endif
  #if defined(i386) || defined(__i386) || defined(_I386)
    #define I80X86
    #define I80Y86
    #define I80Z86
  #endif
  #ifdef sparc
    #define SPARC
  #endif
  #if defined(mips) || defined(__mips)
    #define MIPS
  #endif
  #if defined(HP8XX) || defined(hppa) || defined(__hppa)
    #define HPPA
  #endif
  #ifdef m88000
    #define M88000
  #endif
  #ifdef _IBMR2
    #define RS6000
  #endif
  #ifdef __convex__
    #define CONVEX
  #endif
  #ifdef __alpha
    #define DECALPHA
  #endif
#endif


# Auswahl des Betriebssystems:
#ifdef AMIGA
  #define AMIGAOS
#endif
#if (defined(riscos) || defined(__riscos)) && !defined(unix)
  #define RISCOS  # Acorn RISC OS
  #ifndef __GNUC__
    #define RISCOS_CCBUG  # Bug in Norcrofts C-Compiler umgehen
  #endif
  #define ACORN_1  # Typcode "oben"
  # define ACORN_2  # Typcode "unten"
#endif
#ifdef GENERIC_UNIX
  #define UNIX
  #ifdef linux
    #define UNIX_LINUX  # Linux (Linus Torvalds Unix)
  #endif
  #if defined(hpux) || defined(__hpux)
    #define UNIX_HPUX  # HP-UX
  #endif
  #if defined(SVR3) || defined(__SVR3) || defined(SVR4) || defined(__SVR4) || defined(SYSTYPE_SVR4) || defined(__SYSTYPE_SVR4) || defined(__svr4__) || defined(USG) || defined(UNIX_HPUX) # ??
    #define UNIX_SYSV  # UNIX System V
  #endif
  #if defined(UNIX_SYSV) && (defined(sgi) || defined(__sgi))
    #define UNIX_IRIX  # Irix
    #if defined(SYSTYPE_SVR4) || defined(__SYSTYPE_SVR4)
      #define UNIX_IRIX5  # Irix 5
    #endif
  #endif
  #if defined(MIPS) && (defined(ultrix) || defined(__ultrix))
    #define UNIX_DEC_ULTRIX  # DEC's (oder IBM's ?) RISC/OS Ultrix auf DEC MIPS
    #ifdef __GNUC__
      #define UNIX_DEC_ULTRIX_GCCBUG  # GCC 2.3.3 Bug umgehen
    #endif
  #endif
  #if defined(USL) # defined(__svr4__) && defined(i386) && ??
    # Eine Reihe von 386er Unixen (alle unter verschiedenem Namen) stammen
    # von USL SysV R 4 ab:
    #   386 UHC UNIX System V release 4
    #   Consensys System V 4.2
    #   Onsite System V 4.2
    #   SINIX-Z
    #define UNIX_SYSV_USL  # Unix System V R 4 von der AT&T-Tochter USL
    #define UNIX_SYSV_UHC_1 # Behandlung analog HPPA && UNIX_HPUX
    # define UNIX_SYSV_UHC_2 # Behandlung analog AMIGA3000 - langsamer
    #ifdef SNI
      #define UNIX_SINIX # Siemens is nix
    #endif
  #endif
  #ifdef _SEQUENT_
    #define UNIX_SYSV_PTX
  #endif
  #ifdef _AIX
    #define UNIX_AIX  # IBM AIX
  #endif
  #ifdef DGUX
    #define UNIX_DGUX  # Data General DG/UX
  #endif
  #ifdef __osf__
    #define UNIX_OSF  # OSF/1
  #endif
  #ifdef AUX
    #define UNIX_AUX  # Apple A/UX, ein aufgepäppeltes SVR2
  #endif
  #ifdef NeXT
    #define UNIX_NEXTSTEP  # NeXTstep
    # define NEXTAPP       # Definiere dies, um eine NeXTstep-GUI-Applikation
                           # zu bekommen.
    #define MAYBE_NEXTAPP  # kleiner Hack, damit die .mem Files zwischen
                           # clisp mit NEXTAPP und ohne NEXTAPP kompatibel sind
  #endif
  #ifdef AMIX
    #define UNIX_AMIX  # Amiga UNIX
  #endif
  #ifdef __convex__
    #define UNIX_CONVEX  # ConvexOS
  #endif
#endif
#ifdef DOSPC
  #undef MSDOS  # wg. WATCOM
  #define MSDOS
  #ifdef __EMX__
    #define EMUNIX  # UNIX-Emulation auf MSDOS/OS2-Basis von Eberhard Mattes
    #if defined(OS2)
      #define EMUNIX_PORTABEL # ob wir eine zwischen MSDOS und OS2 portable Version machen
    #endif
    # EMUNIX_OLD_8d steht für emx <= 0.8d, EMUNIX_NEW_8e steht für emx >= 0.8e
    # EMUNIX_OLD_8e steht für emx <= 0.8e, EMUNIX_NEW_8f steht für emx >= 0.8f
    # EMUNIX_OLD_8f steht für emx <= 0.8f, EMUNIX_NEW_8g steht für emx >= 0.8g
    # EMUNIX_OLD_8g steht für emx <= 0.8g, EMUNIX_NEW_8h steht für emx >= 0.8h
    # EMUNIX_OLD_8h steht für emx <= 0.8h, EMUNIX_NEW_9a steht für emx >= 0.9a
  #endif
  #ifdef __GO32__
    #define DJUNIX  # UNIX-Emulation auf MSDOS-Basis von D.J. Delorie
  #endif
  #ifdef __WATCOMC__
    #define WATCOM  # Bibliotheksfunktionen von WATCOM C
    #ifdef __WINDOWS_386__
      #define WINDOWS
    #endif
  #endif
  #ifdef __WINNT__
   #define WIN32_WINDOWS
   #define WIN32_DOS
  #ifdef _MSC_VER
    #define MICROSOFT
  #endif
  #endif
  # WINDOWS ist definiert, wenn wir für MS Windows 3.1 compilieren
#endif
#ifdef WIN32_UNIX
  #define WIN32_WINDOWS 
#endif


# Eigenschaften von Compiler und Umgebung abfragen:
#if defined(UNIX) || defined(WIN32_UNIX)
  #include "config.h"  # von configure erzeugte Konfiguration
  #include "machine.h"   # von machine erzeugte Integertyp-Charakteristika
  #ifdef WIN32_UNIX
    #undef VOID_CLOSEDIR
    #undef HAVE_READLINK
  #endif
#elif defined(AMIGA) || defined(DOSPC) || defined(ACORN)
  #ifdef WIN32_DOS
    #include "config.h"  # von configure erzeugte Konfiguration
    #undef CODE_ADDRESS_RANGE
    #undef MALLOC_ADDRESS_RANGE
    #undef SHLIB_ADDRESS_RANGE
  #endif  
  #define char_bitsize 8
  #define short_bitsize 16
  #if defined(DOSPC) || defined(ACORN)
    #define int_bitsize 32
  #else
    #define int_bitsize 0 # wird nicht benötigt
  #endif
  #define long_bitsize 32
  #ifdef __GNUC__
    #if (__GNUC__ >= 2) # GCC 2 hat inzwischen funktionierenden `long long' Typ
      #ifndef HAVE_LONGLONG  # (e.g. MSDOS)
        #define HAVE_LONGLONG
      #endif
      #define long_long_bitsize 64
    #endif
  #endif
  #define pointer_bitsize 32
  #ifdef MC680X0
    #define short_big_endian
    #define long_big_endian
  #endif
  #if defined(I80X86) || defined(VAX) || defined(ARM)
    #define short_little_endian
    #define long_little_endian
  #endif
  #define stack_grows_down
  #define CODE_ADDRESS_RANGE 0
  #define MALLOC_ADDRESS_RANGE 0
  #define SHLIB_ADDRESS_RANGE 0
#endif


# Genauere Klassifikation des Betriebssystems:
  #if defined(UNIX) && defined(SIGNALBLOCK_BSD) && !defined(SIGNALBLOCK_SYSV)
    #define UNIX_BSD # BSD Unix
  #endif
  #ifdef __NetBSD__
    #define UNIX_NETBSD
  #endif
  #ifdef __FreeBSD__
    #define UNIX_FREEBSD
  #endif
  #if (defined(SUN3) || defined(SUN386) || defined(SUN4)) && defined(HAVE_MMAP) && defined(HAVE_VADVISE)
    #define UNIX_SUNOS4  # Sun OS Version 4
  #endif
  #if defined(SUN4) && !defined(HAVE_VADVISE) # && !defined(HAVE_GETPAGESIZE)
    #define UNIX_SUNOS5  # Sun OS Version 5.1/5.2/5.3 (Solaris 2)
  #endif


# Auswahl des Zeichensatzes:
#if (defined(SUN3) && defined(UNIX_SUNOS4)) || defined(SUN4) || defined(AMIGA) || defined(ACORN) || defined(UNIX_LINUX) || defined(UNIX_AIX)
  #define ISOLATIN_CHS  # ISO 8859-1, siehe isolatin.chs
#endif
#ifdef HP8XX
  #define HPROMAN8_CHS  # HP-Roman8, siehe hproman8.chs
  # unter X-Term aber: #define ISOLATIN_CHS ??
#endif
#ifdef UNIX_NEXTSTEP
  #define NEXTSTEP_CHS  # NeXTstep, siehe nextstep.chs
#endif
#ifdef DOSPC
  #define IBMPC_CHS  # IBM PC, siehe ibmpc.chs
#endif
#if !(defined(ISOLATIN_CHS) || defined(HPROMAN8_CHS) || defined(NEXTSTEP_CHS) || defined(IBMPC_CHS))
  #define ASCII_CHS  # Default: Nur Ascii-Zeichensatz ohne Sonderzeichen
#endif


# Auswahl des Compilers:
#if defined(__GNUC__)
  #define GNU
#endif
#if defined(__STDC__)
  #define ANSI
#endif


# Auswahl der Floating-Point-Fähigkeiten:
# FAST_DOUBLE sollte definiert werden, wenn ein Floating-Point-Coprozessor
# vorhanden ist, dessen 'double'-Typ IEEE-Floating-Points mit 64 Bits sind.
# FAST_FLOAT sollte definiert werden, wenn ein Floating-Point-Coprozessor
# vorhanden ist, dessen 'float'-Typ IEEE-Floating-Points mit 32 Bits sind,
# und der C-Compiler auch 'float'- und nicht 'double'-Operationen generiert.
#ifdef SUN4
  #define FAST_DOUBLE
  #define FAST_FLOAT
#endif
#ifdef HPPA
  #define FAST_DOUBLE
  #define FAST_FLOAT
#endif
#ifdef M88000
  #define FAST_DOUBLE
  #define FAST_FLOAT
#endif
#ifdef RS6000
  #define FAST_DOUBLE
  #define FAST_FLOAT
#endif
#if defined(I80Z86) && (defined(UNIX_LINUX) || defined(UNIX_NEXTSTEP))
  # Linux hat einen funktionierenden Floating-Point-Coprozessor-Emulator.
  # NeXTstep läuft sowieso nur mit Floating-Point-Coprozessor.
  # Aber auf Intel-Pentium-Prozessoren ist die FPU fehlerhaft.
  #define FAST_DOUBLE
  #define FAST_FLOAT
#endif
#ifdef ARM
  # Bei Integers ist der Prozessor Little-Endian, bei Double-Floats Big-Endian!
  #undef FAST_DOUBLE
#endif
#ifdef GNU
  # Erst gcc-2.6 kann auch bei -traditional mit 'float's konversionslos rechnen.
  #if !defined(ANSI) && !((__GNUC__ == 2) && (__GNUC_MINOR__ >= 6))
    #undef FAST_FLOAT
  #endif
#endif
#ifdef NO_FAST_FLOAT
  #undef FAST_FLOAT
#endif


# Auswahl der Sprache:
  #ifdef ENGLISH
    #undef ENGLISH
    #define ENGLISH 1
  #else
    #define ENGLISH 0
  #endif
  #ifdef DEUTSCH
    #undef DEUTSCH
    #define DEUTSCH 1
  #else
    #define DEUTSCH 0
  #endif
  #ifdef FRANCAIS
    #undef FRANCAIS
    #define FRANCAIS 1
  #else
    #define FRANCAIS 0
  #endif
  #if (DEUTSCH+ENGLISH+FRANCAIS > 1)
    #error "Ambiguous choice of language -- Sprache nicht eindeutig!!"
  #endif
  #if (DEUTSCH+ENGLISH+FRANCAIS > 0)
    #define LANGUAGE_STATIC
  #else # noch keine Sprache ausgewählt
    # Sprache wird zur Laufzeit von der Variablen language bestimmt.
    #undef ENGLISH
    #undef DEUTSCH
    #undef FRANCAIS
    #define ENGLISH  (language==language_english)
    #define DEUTSCH  (language==language_deutsch)
    #define FRANCAIS  (language==language_francais)
  #endif
  #ifdef ENABLE_NLS
    #include <libintl.h>
    extern const char *__GETTEXT(const char *asciz_string);
    #define GETTEXT(str) __GETTEXT(str)
  #else
    #ifdef LANGUAGE_STATIC
      #if ENGLISH
        #define GETTEXT(str) ENGLISH_MSG
      #elif DEUTSCH
        #define GETTEXT(str) DEUTSCH_MSG
      #elif FRANCAIS
        #define GETTEXT(str) FRANCAIS_MSG
      #else
        #define GETTEXT(str) str
      #endif
    #else
      # define GETTEXT(str) (DEUTSCH ? DEUTSCH_MSG : ENGLISH ? ENGLISH_MSG : FRANCAIS ? FRANCAIS_MSG : str)
      #define GETTEXT(str) (DEUTSCH ? DEUTSCH_MSG : FRANCAIS ? FRANCAIS_MSG : ENGLISH_MSG)
    #endif
  #endif

# Auswahl der Sicherheitsstufe:
# SAFETY=0 : alle Optimierungen eingeschaltet
# SAFETY=1 : alle Optimierungen, aber noch STACKCHECKs
# SAFETY=2 : nur einfache Assembler-Unterstützung
# SAFETY=3 : keine Optimierungen
  #ifndef SAFETY
    #define SAFETY 0
  #endif
  #if SAFETY >= 3
    #define NO_ASM
    #define NO_FAST_DISPATCH
  #endif


# Name des Compilers: siehe constobj.d: software_version_string


# Es gibt doch tatsächlich Compiler, deren Präprozessor in den constant-
# expressions nach '#if' keine Macros mit Argumenten expandiert.
# (Z.B. der cc von HP-UX 8.0.)
# Solche Compiler unterstützen wir definitiv nicht.

# Der Acorn ANSI-C Compiler für ARM unter RISCOS hat "char" == "unsigned char".
  #if defined(ARM) && defined(RISCOS) && !defined(GNU)
    #define __CHAR_UNSIGNED__
  #endif

# Eine Eigenschaft des Prozessors:
# Die Reihenfolge, in der Worte/Langworte in Bytes abgelegt werden.
  #if defined(short_little_endian) || defined(int_little_endian) || defined(long_little_endian)
    # Z80, VAX, I80X86, DECALPHA, MIPSEL, ...:
    # Low Byte zuunterst, High Byte an höherer Adresse
    #if defined(BIG_ENDIAN_P)
      #error "Bogus BIG_ENDIAN_P -- BIG_ENDIAN_P neu einstellen!"
    #endif
    #define BIG_ENDIAN_P  0
  #endif
  #if defined(short_big_endian) || defined(int_big_endian) || defined(long_big_endian)
    # MC680X0, SPARC, HPPA, MIPSEB, M88000, RS6000, ...:
    # High Byte zuunterst, Low Byte an höherer Adresse (leichter zu lesen)
    #if defined(BIG_ENDIAN_P)
      #error "Bogus BIG_ENDIAN_P -- BIG_ENDIAN_P neu einstellen!"
    #endif
    #define BIG_ENDIAN_P  1
  #endif
  #if !defined(BIG_ENDIAN_P)
    #error "Bogus BIG_ENDIAN_P -- BIG_ENDIAN_P neu einstellen!"
  #endif

# Globale Registerdeklarationen müssen schon jetzt kommen, wenn die
# System-Include-Files Inline-Funktions-Definitionen enthalten.
  #if defined(GNU) && (SAFETY < 2)
    #if defined(M88000) && defined(UNIX_DGUX)
      # CFLAGS = -ffixed-r14 -ffixed-r15 -ffixed-r16  simulieren:
      register void* *       STACK    __asm__("%r14"); # s.u.
      register unsigned long mv_count __asm__("%r15"); # s.u.
      register void*         value1   __asm__("%r16"); # s.u.
    #endif
    #if defined(DECALPHA)
      # Have to save our global registers during callbacks since
      # other languages (FORTRAN) have other register usage conventions.
      #define HAVE_SAVED_REGISTERS
    #endif
  #endif


# ###################### Macros zu C ##################### #

# Definitionen für non-ANSI-C-Compiler:
#if !defined(ANSI) && !defined(UNIXCONF)
  #define const       # 'const' streichen
#endif
#if !defined(ANSI)
  # 'volatile' (in der Bedeutung als Variablen-Attribut) streichen:
    #define volatile
  # Hiervon nicht betroffen sind:
  # * 'volatile' als Attribut für die Deklaration (nicht Definition!) von
  #   Funktionen, heißt bei uns 'nonreturning'.
  # * '__volatile__' als Attribut für GCC-__asm__-Anweisungen.
#endif
#if !defined(ANSI) && !defined(__CHAR_UNSIGNED__)
  #define signed      # 'signed int' --> 'int'
#endif
#if !defined(ANSI) && !defined(UNIXCONF)
  #define void  char  # Ergebnistyp 'void', Typ 'void*'
#endif
#if !defined(UNIXCONF)
  # Um einen Typ vom Wert void weiterzureichen: return_void(...);
  #ifdef GNU
    #define return_void  return # 'return void;' ist zulässig
  #else
    # In general it is not legal to return `void' values.
    #define return_void  # Kein 'return' für Expressions vom Typ 'void' verwenden.
  #endif
#endif
#if !defined(GNU) && !defined(UNIXCONF)
  #define inline      # inline foo() {...} --> foo() {...}
#endif
#if !defined(UNIXCONF)
  #define nowarn
#else
  # Um GCC-Warnungen selektiv auszuschalten:
  #define nowarn  __nowarn__
#endif

# Definitionen für C++-Compiler:
#ifdef __cplusplus
  #define BEGIN_DECLS  extern "C" {
  #define END_DECLS    }
#else
  #define BEGIN_DECLS
  #define END_DECLS
#endif
# C++ stört sich noch an goto's, die in den Scope von Variablen hineinspringen.

# Use _EMA_ where empty macro arguments occur. 
  #define _EMA_

# Zusammenhängen zweier macroexpandierter Tokens:
# Beispiel:
#   #undef x
#   #define y 16
#   CONCAT(x,y)        ==>  'x16' (nicht 'xy' !)
  #define CONCAT_(xxx,yyy)  xxx##yyy
  #define CONCAT3_(aaa,bbb,ccc)  aaa##bbb##ccc
  #define CONCAT4_(aaa,bbb,ccc,ddd)  aaa##bbb##ccc##ddd
  #define CONCAT5_(aaa,bbb,ccc,ddd,eee)  aaa##bbb##ccc##ddd##eee
  #define CONCAT6_(aaa,bbb,ccc,ddd,eee,fff)  aaa##bbb##ccc##ddd##eee##fff
  #define CONCAT7_(aaa,bbb,ccc,ddd,eee,fff,ggg)  aaa##bbb##ccc##ddd##eee##fff##ggg
  #define CONCAT(xxx,yyy)  CONCAT_(xxx,yyy)
  #define CONCAT3(aaa,bbb,ccc)  CONCAT3_(aaa,bbb,ccc)
  #define CONCAT4(aaa,bbb,ccc,ddd)  CONCAT4_(aaa,bbb,ccc,ddd)
  #define CONCAT5(aaa,bbb,ccc,ddd,eee)  CONCAT5_(aaa,bbb,ccc,ddd,eee)
  #define CONCAT6(aaa,bbb,ccc,ddd,eee,fff)  CONCAT6_(aaa,bbb,ccc,ddd,eee,fff)
  #define CONCAT7(aaa,bbb,ccc,ddd,eee,fff,ggg)  CONCAT7_(aaa,bbb,ccc,ddd,eee,fff,ggg)

# Generierung von Sprungzielen (goto-Marken) in Macros:
# GENTAG(end)  ==>  end116
# Damit kann ein Macro, der Marken definiert, mehr als einmal pro Funktion,
# aber immer noch nur einmal pro Source-Zeile benutzt werden.
# Die Marken müssen in einem umschließenden Block mit
# DECLTAG(end);
# deklariert werden.
# Ab GCC-2.6.1 muß dieser umschließende Block eine Expression sein:
# BEGIN_DECLTAG { DECLTAG(end); ... } END_DECLTAG  expandiert dann zu
# ( { DECLTAG(end); ... } );
  #ifdef ANSI # mit traditionellem Präprozessor ist dieser Macro wertlos
    #define GENTAG(xxx)  CONCAT(xxx,__LINE__)
    #define DECLTAG(xxx)
    #define BEGIN_DECLTAG
    #define END_DECLTAG
  #elif defined(GNU)
    #if (__GNUC__ >= 2)
      #define GENTAG(xxx)  xxx
      #define DECLTAG(xxx)  __label__ xxx
      #define BEGIN_DECLTAG  (
      #define END_DECLTAG  );
    #endif
  #endif

# Umwandlung von Tokens in Strings:
# STRING(token)  ==>  "token"
#ifdef ANSI
  #define STRING(token) #token
#else
  #define STRING(token) "token"
#endif
#define STRINGIFY(token) STRING(token)

# Storage-Class-Specifier in Top-Level-Deklarationen:
# für Variablen:
#   global           überall sichtbare Variable
#   local            nur im File (lokal) sichtbare Variable
#   extern           Verweis auf woanders definierte Variable
# für Funktionen:
#   global           überall sichtbare Funktion
#   local            nur im File (lokal) sichtbare Funktion
#   extern           Verweis auf woanders definierte Funktion
#   local_function   Verweis auf später im File definierte Funktion
#   nonreturning     Funktion, die nie zurückkommt
  #define global
  #define local  static
# #define extern extern
  #if defined(ANSI) || defined(GNU)
    #define local_function  local
  #else
    # Es gibt Compiler, die sich über
    #    typedef int handler(); local handler my_handler;
    # aufregen!
    #define local_function  extern
  #endif
  #ifdef GNU
    #define nonreturning  __volatile__
  #else
    #define nonreturning
  #endif

# Deklaration einer Funktion (nur die Fälle, die von ansidecl.d nicht erkannt
# werden):
  #ifdef ANSI
    #define _ARGS(x) x
  #else
    #define _ARGS(x) ()
  #endif
  #ifdef ANSI
    #define PARM0()  (void)
    #define PARM1(arg1,decl1)  (decl1)
    #define PARM2(arg1,arg2,decl1,decl2)  (decl1,decl2)
    #define PARM3(arg1,arg2,arg3,decl1,decl2,decl3)  (decl1,decl2,decl3)
    #define PARM4(arg1,arg2,arg3,arg4,decl1,decl2,decl3,decl4)  (decl1,decl2,decl3,decl4)
    #define PARM5(arg1,arg2,arg3,arg4,arg5,decl1,decl2,decl3,decl4,decl5)  (decl1,decl2,decl3,decl4,decl5)
  #else
    #define PARM0()  ()
    #define PARM1(arg1,decl1)  (arg1) decl1;
    #define PARM2(arg1,arg2,decl1,decl2)  (arg1,arg2) decl1; decl2;
    #define PARM3(arg1,arg2,arg3,decl1,decl2,decl3)  (arg1,arg2,arg3) decl1; decl2; decl3;
    #define PARM4(arg1,arg2,arg3,arg4,decl1,decl2,decl3,decl4)  (arg1,arg2,arg3,arg4) decl1; decl2; decl3; decl4;
    #define PARM5(arg1,arg2,arg3,arg4,arg5,decl1,decl2,decl3,decl4,decl5)  (arg1,arg2,arg3,arg4,arg5) decl1; decl2; decl3; decl4; decl5;
  #endif

# Deklaration einer Funktion, die nie zurückkommt:
# nonreturning_function(extern,exit,(void)); == extern void abort (void);
  #ifdef GNU
    #ifdef ANSI
      #define nonreturning_function(storclass,funname,arguments)  \
        typedef void CONCAT3(funname,_function_,__LINE__) arguments; \
        storclass nonreturning CONCAT3(funname,_function_,__LINE__) funname
    #else
      typedef void void_function ();
      #define nonreturning_function(storclass,funname,arguments)  \
        storclass nonreturning void_function funname
    #endif
  #else
    #ifdef ANSI
      #define nonreturning_function(storclass,funname,arguments)  \
        storclass void funname arguments
    #else
      #define nonreturning_function(storclass,funname,arguments)  \
        storclass void funname()
    #endif
  #endif

# Storage-Class-Specifier in Deklarationen an Blockanfängen:
# var                       leitet Variablendeklarationen ein
# reg1, reg2, ..., reg10    spezifiziert, daß eine Variable in einem Register
#                           sitzen soll, und die (geschätzte) Priorität
#                           davon.
#      (reg1 = wichtigst, z.B. Zähler der innersten Schleife)
  #define var
# regvarcount ist eine Schätzung, wieviele (Integer-)Variablen der Compiler
# üblicherweise gleichzeitig in die Register legen kann. Die Anzahl der Nullen
# bei Integer-Registern im Macro CALL_USED_REGISTERS der gcc2-Maschinen-
# beschreibung ist ein guter Schätzwert.
#ifdef MC680X0            # gcc2: 6+5
  #define regvarcount  6  # kann mindestens 6 Variablen in die Register nehmen
#endif
#ifdef SPARC              # gcc2: 14
  #define regvarcount  8  # kann mindestens 8 Variablen in die Register nehmen
#endif
#ifdef HPPA               # gcc2: 16
  #define regvarcount 16  # kann sehr viele Variablen in die Register nehmen
#endif
#ifdef MIPS               # gcc2: 9
  #define regvarcount 10  # kann viele Variablen in die Register nehmen
#endif
#ifdef M88000             # gcc2: 12
  #define regvarcount 12  # kann viele Variablen in die Register nehmen
#endif
#ifdef RS6000             # gcc2: 19
  #define regvarcount 16  # kann sehr viele Variablen in die Register nehmen
#endif
#ifdef I80X86             # gcc2: 4
  #define regvarcount  4  # kann mindestens 4 Variablen in die Register nehmen
#endif
#ifdef VAX
  #define regvarcount  6  # gcc2: 6
#endif
#ifdef CONVEX
  #define regvarcount  6  # gcc2: 0
#endif
#ifdef ARM
  #define regvarcount  6  # gcc2: 6
#endif
#ifdef DECALPHA           # gcc2: 8, dafür aber 20 call-used-Register
  #define regvarcount 10  # kann viele Variablen in die Register nehmen
#endif
#if (regvarcount>=1)
  #define reg1  register
#else
  #define reg1  # auto
#endif
#if (regvarcount>=2)
  #define reg2  register
#else
  #define reg2  # auto
#endif
#if (regvarcount>=3)
  #define reg3  register
#else
  #define reg3  # auto
#endif
#if (regvarcount>=4)
  #define reg4  register
#else
  #define reg4  # auto
#endif
#if (regvarcount>=5)
  #define reg5  register
#else
  #define reg5  # auto
#endif
#if (regvarcount>=6)
  #define reg6  register
#else
  #define reg6  # auto
#endif
#if (regvarcount>=7)
  #define reg7  register
#else
  #define reg7  # auto
#endif
#if (regvarcount>=8)
  #define reg8  register
#else
  #define reg8  # auto
#endif
#if (regvarcount>=9)
  #define reg9  register
#else
  #define reg9  # auto
#endif
#if (regvarcount>=10)
  #define reg10  register
#else
  #define reg10  # auto
#endif

# Adresse des ersten Elements eines Arrays: &!array
# (Wenn klar werden soll, daß man die Adresse des ganzen Arrays übergibt.
# Wenn man &array schreibt, ist das genau genommen ein Typfehler.)

# Verallgemeinerte if-Anweisung:
# if (cond1) ... {elif (condi) ...} [else ...]
  #define elif  else if

# Endlosschleife, nur mit  break;  oder  return...;  zu verlassen:
  #define loop  while (1)

# Umgekehrte Abbruchbedingung in Schleifen:
# Erlaubt   until (expression) statement
# und       do statement until (expression);
  #define until(expression)  while(!(expression))

# Fallunterscheidung über einen Wert >=0
# switchu (expression) ...
  #ifdef GNU # wird so besser optimiert
    #define switchu(expression)  switch ((unsigned int)(expression))
  #else
    #define switchu  switch
  #endif

# Ignorieren eines Wertes (statt einer Zuweisung an eine Variable)
# unused ...
  #ifdef GNU # um eine gcc-Warnung "statement with no effect" zu vermeiden
    #define unused  (void)
  #else
    #define unused
  #endif

# Vertauschen zweier Variableninhalte:  swap(register int, x1, x2);
  #define swap(swap_type,swap_var1,swap_var2)  \
    { var swap_type swap_temp;                                             \
      swap_temp = swap_var1; swap_var1 = swap_var2; swap_var2 = swap_temp; \
    }

# Kennzeichnung einer unerreichten Programmstelle: NOTREACHED
  #define NOTREACHED  fehler_notreached(__FILE__,__LINE__);

# Überprüfung eines arithmetischen Ausdrucks: ASSERT(expr)
  #define ASSERT(expr)  { if (!(expr)) { NOTREACHED } }

# alloca()
  #if defined(GNU) && !defined(RISCOS) && !defined(CONVEX)
    #define alloca  __builtin_alloca
  #elif defined(HAVE_ALLOCA_H) || defined(RISCOS)
    #include <alloca.h>
    #ifndef alloca # Manche definieren 'alloca' als Macro...
      #ifdef UNIX_OSF
        extern char* alloca (int size);
      #elif !defined(UNIX_DEC_ULTRIX)
        extern void* alloca (int size); # siehe MALLOC(3V)
      #endif
    #endif
  #elif defined(_AIX)
    #pragma alloca /* AIX requires this to be the first thing in the file. */
  #elif defined(WATCOM)
    #include <malloc.h> # definiert 'alloca' als Macro
  #elif !defined(NO_ALLOCA)
    extern void* alloca (int size); # siehe MALLOC(3V)
  #endif

# Synonym für Byte, Word, Longword:
# CLISP_BYTE    = signed 8 bit integer
# CLISP_UBYTE   = unsigned 8 bit int
# CLISP_WORD    = signed 16 bit int
# CLISP_UWORD   = unsigned 16 bit int
# CLISP_LONG    = signed 32 bit int
# CLISP_ULONG   = unsigned 32 bit int
# Hingegen wird "char" nur in der Bedeutung eines Elements eines Strings
# verwendet. Nie wird mit einem "char" wirklich gerechnet; das könnte von
# __CHAR_UNSIGNED__ abhängen!
  #if (char_bitsize==8)
    #ifdef __CHAR_UNSIGNED__
      typedef signed char  CLISP_BYTE;
    #else
      typedef char         CLISP_BYTE;
    #endif
    typedef unsigned char  CLISP_UBYTE;
  #else
    #error "No 8 bit integer type? -- Welcher Integer-Typ hat 8 Bit?"
  #endif
  #if (short_bitsize==16)
    typedef short          CLISP_WORD;
    typedef unsigned short CLISP_UWORD;
  #else
    #error "No 16 bit integer type? -- Welcher Integer-Typ hat 16 Bit?"
  #endif
  #if (long_bitsize==32)
    typedef long           CLISP_LONG;
    typedef unsigned long  CLISP_ULONG;
  #elif (int_bitsize==32)
    typedef int            CLISP_LONG;
    typedef unsigned int   CLISP_ULONG;
  #else
    #error "No 32 bit integer type? -- Welcher Integer-Typ hat 32 Bit?"
  #endif
  #if (long_bitsize==64)
    typedef long           CLISP_LONGLONG;
    typedef unsigned long  CLISP_ULONGLONG;
    #undef HAVE_LONGLONG
    #define HAVE_LONGLONG
  #elif defined(HAVE_LONGLONG)
   #if defined(long_long_bitsize) && (long_long_bitsize==64)
    typedef long long           CLISP_LONGLONG;
    typedef unsigned long long  CLISP_ULONGLONG;
   #else # unbrauchbarer Typ
    #undef HAVE_LONGLONG
   #endif
  #endif
  #if defined(WIDE) && !defined(HAVE_LONGLONG)
    #error "No 64 bit integer type? -- Welcher Integer-Typ hat 64 Bit?"
  #endif

# Wahrheitswerte:
  #define TRUE   1
  #define FALSE  0
  typedef unsigned int  boolean;

# Typ für Vorzeichenwerte, Vergleichsergebnisse, dreiwertige enum's
# mit Werten +1, 0, -1
  typedef signed int  signean;
  #define signean_plus    1 # +1
  #define signean_null    0 #  0
  #define signean_minus  -1 # -1

# Nullpointer
  #undef NULL  # wg. WATCOM
  #define NULL  ((void*) 0L)

# Den Offset einer Komponente 'ident' in einem Struct vom Typ 'type' bestimmen:
# 0 als Pointer auf 'type' auffassen, dorthin ein Struct 'type' legen und
# von dessen Komponente 'ident' die Adresse bestimmen und als Zahl liefern:
  #ifndef HAVE_OFFSETOF
  #define offsetof(type,ident)  ((CLISP_ULONG)&(((type*)0)->ident))
  #else
  #include <stddef.h>
  #endif
# Den Offset eines Arrays 'ident' in einem Struct vom Typ 'type' bestimmen:
  #define offsetofa(type,ident)  offsetof(type,ident[0])

# Unspezifizierte Länge von Arrays in Structures:
# struct { ...; ...; type x[unspecified]; }
# Statt sizeof(..) muß man dann aber immer offsetof(..,x) schreiben.
  #if defined(GNU) # GNU-C kann Arrays der Länge 0
    #define unspecified 0
  #elif 0
    # Üblicherweise läßt man die Arraygrenze weg:
    #define unspecified
  #else
    # Jedoch die HP-UX- und IRIX-Compiler lassen sich nur damit befriedigen:
    #define unspecified 1
  #endif

# Pointer-Arithmetik: einen gegebenen Offset (gemessen in Bytes)
# zu einem Pointer addieren.
  #if !(defined(GNU) || (pointer_bitsize > 32))
    # Billige Methode:
    #define pointerplus(pointer,offset)  ((void*)((CLISP_ULONG)(pointer)+(offset)))
  #else
    # Für GNU-C beim Initialisieren von static-Variablen unerläßlich
    # (muß ein Bug in 'c-typeck.c' in 'initializer_constant_valid_p' sein):
    # Das einzig Richtige, falls sizeof(CLISP_ULONG) < sizeof(void*):
    #define pointerplus(pointer,offset)  ((CLISP_UBYTE*)(pointer)+(offset))
  #endif

# Bit Nummer n (0<=n<32)
  #define bit(n)  (1L<<(n))
# Bit Nummer n (0<n<=32) mod 2^32
  #define bitm(n)  (2L<<((n)-1))
# Bit-Test von Bit n in x, n konstant, x ein oint:
  #if !defined(SPARC)
    #define bit_test(x,n)  ((x) & bit(n))
  #else
    # Auf SPARC-Prozessoren sind lange Konstanten langsamer als Shifts.
    #if !defined(GNU)
      #define bit_test(x,n)  \
        ((n)<12 ? ((x) & bit(n)) : ((sint32)((uint32)(x) << (31-(n))) < 0))
    #else # der GNU-Compiler optimiert boolean-Expressions so besser:
      #define bit_test(x,n)  \
        (   ( ((n)<12) && ((x) & bit(n)) )                           \
         || ( ((n)>=12) && ((sint32)((uint32)(x) << (31-(n))) < 0) ) \
        )
    #endif
  #endif
# Minus Bit Nummer n (0<=n<32)
  #define minus_bit(n)  (-1L<<(n))
# Minus Bit Nummer n (0<n<=32) mod 2^32
  #define minus_bitm(n)  (-2L<<((n)-1))

# floor(a,b) liefert für a>=0, b>0  floor(a/b).
# b sollte eine 'constant expression' sein.
  #define floor(a_from_floor,b_from_floor)  ((a_from_floor) / (b_from_floor))

# ceiling(a,b) liefert für a>=0, b>0  ceiling(a/b) = floor((a+b-1)/b).
# b sollte eine 'constant expression' sein.
  #define ceiling(a_from_ceiling,b_from_ceiling)  \
    (((a_from_ceiling) + (b_from_ceiling) - 1) / (b_from_ceiling))

# round_down(a,b) rundet a>=0 so ab, daß es durch b>0 teilbar ist.
# b sollte eine 'constant expression' sein.
  #define round_down(a_from_round,b_from_round)  \
    (floor(a_from_round,b_from_round)*(b_from_round))

# round_up(a,b) rundet a>=0 so auf, daß es durch b>0 teilbar ist.
# b sollte eine 'constant expression' sein.
  #define round_up(a_from_round,b_from_round)  \
    (ceiling(a_from_round,b_from_round)*(b_from_round))

# nicht-lokale Ausgänge
  #include <setjmp.h>
  #if defined(UNIX) && defined(HAVE__JMP) && !defined(UNIX_LINUX)
    # Folgende Routinen sind effizienter (hantieren nicht mit Signal-Masken):
    #undef setjmp
    #undef longjmp
    #define setjmp  _setjmp
    #define longjmp  _longjmp
    #ifdef LONGJMP_RETURNS
      # _longjmp(jmpbuf,value) kann zurückkehren, wenn jmpbuf ungültig ist.
      #undef longjmp
      #define longjmp(x,y)  (_longjmp(x,y), fehler_notreached(__FILE__,__LINE__))
    #endif
  #endif
# Mit longjmp() kann man nur ein `int' übergeben.
# Wenn wir nun ein `long' übergeben wollen und sizeof(int) < sizeof(long) ist,
# brauchen wir eine globale Variable:
  #if (int_bitsize == long_bitsize)
    #define setjmpl(x)  setjmp(x)
    #define longjmpl(x,y)  longjmp(x,y)
  #else # (int_bitsize < long_bitsize)
    extern long jmpl_value;
    #define setjmpl(x)  (setjmp(x) ? jmpl_value : 0)
    #define longjmpl(x,y)  (jmpl_value = (y), longjmp(x,1))
  #endif

# Dynamisch allozierte Arrays mit dynamic extent:
# Beispiel:
#     { var DYNAMIC_ARRAY(reg7,my_array,uintL,n);
#       ...
#       FREE_DYNAMIC_ARRAY(my_array);
#     }
# Vorsicht: Je nach Implementierung ist my_array entweder der Array selbst
# oder ein Pointer auf den Array! Immer nur my_array als Expression verwenden!
  #if defined(GNU)
    # verkraftet dynamisch allozierte Arrays im Maschinenstack
    # { var reg7 uintL my_array[n]; ... }
    #define DYNAMIC_ARRAY(regdecl,arrayvar,arrayeltype,arraysize)  \
      arrayeltype arrayvar[arraysize]
    #define FREE_DYNAMIC_ARRAY(arrayvar)
    #ifdef DECALPHA # GCC 2.5.5 Bug umgehen
      #undef DYNAMIC_ARRAY
      #define DYNAMIC_ARRAY(regdecl,arrayvar,arrayeltype,arraysize)  \
        arrayeltype arrayvar[(arraysize)+1]
    #endif
  #elif (defined(UNIX) && (defined(HAVE_ALLOCA_H) || defined(_AIX) || !defined(NO_ALLOCA))) || defined(WATCOM) || defined(RISCOS)
    # Platz im Maschinenstack reservieren.
    # { var reg7 uintL* my_array = (uintL*)alloca(n*sizeof(uintL)); ... }
    #define DYNAMIC_ARRAY(regdecl,arrayvar,arrayeltype,arraysize)  \
      regdecl arrayeltype* arrayvar = (arrayeltype*)alloca((arraysize)*sizeof(arrayeltype))
    #define FREE_DYNAMIC_ARRAY(arrayvar)
    # kein Errorcheck??
  #else
    # Platz woanders reservieren und dann wieder freigeben.
    # { var reg7 uintL* my_array = (uintL*)malloc(n*sizeof(uintL)); ... free(my_array); }
    #ifdef HAVE_STDLIB_H
      #include <stdlib.h>
    #else
      #include <sys/types.h>
    #endif
    #ifndef malloc
      extern void* malloc (size_t size); # siehe MALLOC(3V)
    #endif
    #ifndef free
      extern void free (void* ptr); # siehe MALLOC(3V)
    #endif
    #define NEED_MALLOCA
    extern void* malloca (size_t size); # siehe SPVW.D
    extern void freea (void* ptr); # siehe SPVW.D
    #define DYNAMIC_ARRAY(regdecl,arrayvar,arrayeltype,arraysize)  \
      regdecl arrayeltype* arrayvar = (arrayeltype*)malloca((arraysize)*sizeof(arrayeltype))
    #define FREE_DYNAMIC_ARRAY(arrayvar)  freea(arrayvar)
  #endif

# Signed/Unsigned-Integer-Typen mit vorgegebener Mindestgröße:
  typedef CLISP_UBYTE   uint1;   # unsigned 1 bit Integer
  typedef CLISP_BYTE    sint1;   # signed 1 bit Integer
  typedef CLISP_UBYTE   uint2;   # unsigned 2 bit Integer
  typedef CLISP_BYTE    sint2;   # signed 2 bit Integer
  typedef CLISP_UBYTE   uint3;   # unsigned 3 bit Integer
  typedef CLISP_BYTE    sint3;   # signed 3 bit Integer
  typedef CLISP_UBYTE   uint4;   # unsigned 4 bit Integer
  typedef CLISP_BYTE    sint4;   # signed 4 bit Integer
  typedef CLISP_UBYTE   uint5;   # unsigned 5 bit Integer
  typedef CLISP_BYTE    sint5;   # signed 5 bit Integer
  typedef CLISP_UBYTE   uint6;   # unsigned 6 bit Integer
  typedef CLISP_BYTE    sint6;   # signed 6 bit Integer
  typedef CLISP_UBYTE   uint7;   # unsigned 7 bit Integer
  typedef CLISP_BYTE    sint7;   # signed 7 bit Integer
  typedef CLISP_UBYTE   uint8;   # unsigned 8 bit Integer
  typedef CLISP_BYTE    sint8;   # signed 8 bit Integer
  typedef CLISP_UWORD   uint9;   # unsigned 9 bit Integer
  typedef CLISP_WORD    sint9;   # signed 9 bit Integer
  typedef CLISP_UWORD   uint10;  # unsigned 10 bit Integer
  typedef CLISP_WORD    sint10;  # signed 10 bit Integer
  typedef CLISP_UWORD   uint11;  # unsigned 11 bit Integer
  typedef CLISP_WORD    sint11;  # signed 11 bit Integer
  typedef CLISP_UWORD   uint12;  # unsigned 12 bit Integer
  typedef CLISP_WORD    sint12;  # signed 12 bit Integer
  typedef CLISP_UWORD   uint13;  # unsigned 13 bit Integer
  typedef CLISP_WORD    sint13;  # signed 13 bit Integer
  typedef CLISP_UWORD   uint14;  # unsigned 14 bit Integer
  typedef CLISP_WORD    sint14;  # signed 14 bit Integer
  typedef CLISP_UWORD   uint15;  # unsigned 15 bit Integer
  typedef CLISP_WORD    sint15;  # signed 15 bit Integer
  typedef CLISP_UWORD   uint16;  # unsigned 16 bit Integer
  typedef CLISP_WORD    sint16;  # signed 16 bit Integer
  typedef CLISP_ULONG   uint17;  # unsigned 17 bit Integer
  typedef CLISP_LONG    sint17;  # signed 17 bit Integer
  typedef CLISP_ULONG   uint18;  # unsigned 18 bit Integer
  typedef CLISP_LONG    sint18;  # signed 18 bit Integer
  typedef CLISP_ULONG   uint19;  # unsigned 19 bit Integer
  typedef CLISP_LONG    sint19;  # signed 19 bit Integer
  typedef CLISP_ULONG   uint20;  # unsigned 20 bit Integer
  typedef CLISP_LONG    sint20;  # signed 20 bit Integer
  typedef CLISP_ULONG   uint21;  # unsigned 21 bit Integer
  typedef CLISP_LONG    sint21;  # signed 21 bit Integer
  typedef CLISP_ULONG   uint22;  # unsigned 22 bit Integer
  typedef CLISP_LONG    sint22;  # signed 22 bit Integer
  typedef CLISP_ULONG   uint23;  # unsigned 23 bit Integer
  typedef CLISP_LONG    sint23;  # signed 23 bit Integer
  typedef CLISP_ULONG   uint24;  # unsigned 24 bit Integer
  typedef CLISP_LONG    sint24;  # signed 24 bit Integer
  typedef CLISP_ULONG   uint25;  # unsigned 25 bit Integer
  typedef CLISP_LONG    sint25;  # signed 25 bit Integer
  typedef CLISP_ULONG   uint26;  # unsigned 26 bit Integer
  typedef CLISP_LONG    sint26;  # signed 26 bit Integer
  typedef CLISP_ULONG   uint27;  # unsigned 27 bit Integer
  typedef CLISP_LONG    sint27;  # signed 27 bit Integer
  typedef CLISP_ULONG   uint28;  # unsigned 28 bit Integer
  typedef CLISP_LONG    sint28;  # signed 28 bit Integer
  typedef CLISP_ULONG   uint29;  # unsigned 29 bit Integer
  typedef CLISP_LONG    sint29;  # signed 29 bit Integer
  typedef CLISP_ULONG   uint30;  # unsigned 30 bit Integer
  typedef CLISP_LONG    sint30;  # signed 30 bit Integer
  typedef CLISP_ULONG   uint31;  # unsigned 31 bit Integer
  typedef CLISP_LONG    sint31;  # signed 31 bit Integer
  typedef CLISP_ULONG   uint32;  # unsigned 32 bit Integer
  typedef CLISP_LONG    sint32;  # signed 32 bit Integer
  #ifdef HAVE_LONGLONG
  typedef CLISP_ULONGLONG  uint33;  # unsigned 33 bit Integer
  typedef CLISP_LONGLONG   sint33;  # signed 33 bit Integer
  typedef CLISP_ULONGLONG  uint48;  # unsigned 48 bit Integer
  typedef CLISP_LONGLONG   sint48;  # signed 48 bit Integer
  typedef CLISP_ULONGLONG  uint64;  # unsigned 64 bit Integer
  typedef CLISP_LONGLONG   sint64;  # signed 64 bit Integer
  #endif
  #define exact_uint_size_p(n) (((n)==char_bitsize)||((n)==short_bitsize)||((n)==int_bitsize)||((n)==long_bitsize))
  #ifdef ANSI # mit traditionellem Präprozessor sind diese Macros wertlos
    #define signed_int_with_n_bits(n) CONCAT(sint,n)
    #define unsigned_int_with_n_bits(n) CONCAT(uint,n)
  #endif
# Verwende 'uintn' und 'sintn' für Integers mit genau vorgegebener Breite.
# exact_uint_size_p(n) gibt an, ob der uint mit n Bits auch wirklich
# nur n Bits hat.

# Ab hier bedeuten 'uintX' und 'sintX' unsigned bzw. signed integer -
# Typen der Wortbreite X (X=B,W,L,Q).
  #define intBsize 8
  #ifdef ANSI
    typedef signed_int_with_n_bits(intBsize)    sintB;
    typedef unsigned_int_with_n_bits(intBsize)  uintB;
  #else
    typedef sint/**/intBsize  sintB;
    typedef uint/**/intBsize  uintB;
  #endif
  #define intWsize 16
  #ifdef ANSI
    typedef signed_int_with_n_bits(intWsize)    sintW;
    typedef unsigned_int_with_n_bits(intWsize)  uintW;
  #else
    typedef sint/**/intWsize  sintW;
    typedef uint/**/intWsize  uintW;
  #endif
  #define intLsize 32
  #ifdef ANSI
    typedef signed_int_with_n_bits(intLsize)    sintL;
    typedef unsigned_int_with_n_bits(intLsize)  uintL;
  #else
    typedef sint/**/intLsize  sintL;
    typedef uint/**/intLsize  uintL;
  #endif
  #if defined(DECALPHA)
    # Maschine hat echte 64-Bit-Zahlen in Hardware.
    #define intQsize 64
    #ifdef ANSI
      typedef signed_int_with_n_bits(intQsize)    sintQ;
      typedef unsigned_int_with_n_bits(intQsize)  uintQ;
    #else
      typedef sint/**/intQsize  sintQ;
      typedef uint/**/intQsize  uintQ;
    #endif
    typedef sintQ  sintL2;
    typedef uintQ  uintL2;
  #else
    # Emuliere 64-Bit-Zahlen mit Hilfe von zwei 32-Bit-Zahlen.
    typedef struct { sintL hi; uintL lo; } sintL2; # signed integer mit 64 Bit
    typedef struct { uintL hi; uintL lo; } uintL2; # unsigned integer mit 64 Bit
  #endif
# Verwende 'uintX' und 'sintX' für Integers mit ungefähr vorgegebener Breite
# und möglichst geringem Speicherplatz.

# Ab hier bedeuten 'uintP' und 'sintP' unsigned bzw. signed integer - Typen,
# die so breit sind wie ein void* - Pointer.
  #ifdef ANSI
    typedef signed_int_with_n_bits(pointer_bitsize)    sintP;
    typedef unsigned_int_with_n_bits(pointer_bitsize)  uintP;
  #else
    typedef sint/**/pointer_bitsize  sintP;
    typedef uint/**/pointer_bitsize  uintP;
  #endif

# Ab hier bedeuten 'uintXY' und 'sintXY' unsigned bzw. signed integer -
# Typen der Wortbreite X oder Y (X,Y=B,W,L).
  #if (defined(MC680X0) && !defined(HPUX_ASSEMBLER)) || defined(VAX)
    # Der 68000 hat gute uintB-, uintW-, uintL-Verarbeitung, insbesondere
    # DBRA-Befehle für uintW.
    #define intBWsize intBsize
    #define intWLsize intWsize
    #define intBWLsize intBsize
  #elif (defined(MC680X0) && defined(HPUX_ASSEMBLER)) || defined(SPARC) || defined(HPPA) || defined(MIPS) || defined(M88000) || defined(RS6000) || defined(CONVEX)
    # Der Sparc-Prozessor kann mit uintB und uintW schlecht rechnen.
    # Anderen 32-Bit-Prozessoren geht es genauso.
    #define intBWsize intWsize
    #define intWLsize intLsize
    #define intBWLsize intLsize
  #elif defined(I80Z86)
    # Wird auf einem 80386 mit uintB und uintW gerechnet, so gibt das viele
    # Zero-Extends, die - da es zu wenig Register gibt - andere Variablen
    # unnötigerweise in den Speicher schieben.
    #define intBWsize intWsize
    #define intWLsize intLsize
    #define intBWLsize intLsize
  #elif defined(ARM)
    # Der ARM kann mit uintW sehr schlecht rechnen.
    #define intBWsize intBsize
    #define intWLsize intLsize
    #define intBWLsize intBsize
  #elif defined(DECALPHA)
    # Auch 64-Bit-Prozessoren können mit uintB und uintW schlecht rechnen.
    #define intBWsize intWsize
    #define intWLsize intLsize
    #define intBWLsize intLsize
  #else
    #error "Preferred integer sizes depend on CPU -- Größen intBWsize, intWLsize, intBWLsize neu einstellen!"
  #endif
  #ifdef ANSI
    typedef signed_int_with_n_bits(intBWsize)    sintBW;
    typedef unsigned_int_with_n_bits(intBWsize)  uintBW;
    typedef signed_int_with_n_bits(intWLsize)    sintWL;
    typedef unsigned_int_with_n_bits(intWLsize)  uintWL;
    typedef signed_int_with_n_bits(intBWLsize)    sintBWL;
    typedef unsigned_int_with_n_bits(intBWLsize)  uintBWL;
  #else
    typedef sint/**/intBWsize  sintBW;
    typedef uint/**/intBWsize  uintBW;
    typedef sint/**/intWLsize  sintWL;
    typedef uint/**/intWLsize  uintWL;
    typedef sint/**/intBWLsize  sintBWL;
    typedef uint/**/intBWLsize  uintBWL;
  #endif
# Verwende 'uintXY' und 'sintXY' für Integers mit vorgegebener Mindestbreite,
# mit denen sich leicht rechnen läßt.

# Schleife, die ein Statement eine gewisse Anzahl mal ausführt:
# dotimesW(countvar,count,statement);  falls count in ein uintW paßt,
# dotimesL(countvar,count,statement);  falls count nur in ein uintL paßt,
# dotimespW(countvar,count,statement);  falls count in ein uintW paßt und >0 ist,
# dotimespL(countvar,count,statement);  falls count nur in ein uintL paßt und >0 ist.
# Die Variable countvar muß bereits deklariert sein, vom Typ uintW bzw. uintL
# und wird durch diese Anweisung verändert!
# Sie darf in statement nicht verwendet werden!
# Die Expression count wird nur einmal (zu Beginn) ausgewertet.
  #if defined(GNU) && defined(MC680X0) && !defined(HPUX_ASSEMBLER)
    # GNU-C auf einem 680X0 läßt sich dazu überreden, den DBRA-Befehl zu verwenden:
    #define fast_dotimesW
    # Um zu entscheiden, wie man GNU-C am besten dazu überredet, betrachte man
    # den Code, der für spvw.d:gc_markphase() produziert wird.
    # Oder ein kleines Testprogramm (dbratest.c), das mit
    # "gcc -O6 -da -S dbratest.c" compiliert wird, und betrachte dbratest.s
    # und dbratest.c.flow sowie dbratest.c.combine.
    #if (__GNUC__<2) # GNU C Version 1
      #define dotimesW_(countvar_from_dotimesW,count_from_dotimesW,statement_from_dotimesW)  \
        { countvar_from_dotimesW = (count_from_dotimesW);     \
          if (!(countvar_from_dotimesW==0))                   \
            { countvar_from_dotimesW--;                       \
              do {statement_from_dotimesW}                    \
                 until ((sintW)--countvar_from_dotimesW==-1); \
        }   }
      #define dotimespW_(countvar_from_dotimespW,count_from_dotimespW,statement_from_dotimespW)  \
        { countvar_from_dotimespW = (count_from_dotimespW)-1;                         \
          do {statement_from_dotimespW} until ((sintW)--countvar_from_dotimespW==-1); \
        }
    #else
      #define dotimesW_(countvar_from_dotimesW,count_from_dotimesW,statement_from_dotimesW)  \
        { countvar_from_dotimesW = (count_from_dotimesW);        \
          if (!(countvar_from_dotimesW==0))                      \
            { countvar_from_dotimesW--;                          \
              do {statement_from_dotimesW}                       \
                 until ((sintW)(--countvar_from_dotimesW)+1==0); \
        }   }
      #define dotimespW_(countvar_from_dotimespW,count_from_dotimespW,statement_from_dotimespW)  \
        { countvar_from_dotimespW = (count_from_dotimespW)-1;                            \
          do {statement_from_dotimespW} until ((sintW)(--countvar_from_dotimespW)+1==0); \
        }
    #endif
  #else
    #define dotimesW_(countvar_from_dotimesW,count_from_dotimesW,statement_from_dotimesW)  \
      { countvar_from_dotimesW = (count_from_dotimesW);         \
        until (countvar_from_dotimesW==0)                       \
          {statement_from_dotimesW; countvar_from_dotimesW--; } \
      }
    #define dotimespW_(countvar_from_dotimespW,count_from_dotimespW,statement_from_dotimespW)  \
      { countvar_from_dotimespW = (count_from_dotimespW);                   \
        do {statement_from_dotimespW} until (--countvar_from_dotimespW==0); \
      }
  #endif
  #if defined(GNU) && defined(MC680X0) && !defined(HPUX_ASSEMBLER)
    # GNU-C auf einem 680X0 läßt sich dazu überreden, den DBRA-Befehl
    # auf intelligente Weise zu verwenden:
    #define fast_dotimesL
    #define dotimesL_(countvar_from_dotimesL,count_from_dotimesL,statement_from_dotimesL)  \
      { countvar_from_dotimesL = (count_from_dotimesL);           \
        if (!(countvar_from_dotimesL==0))                         \
          { countvar_from_dotimesL--;                             \
            do {statement_from_dotimesL}                          \
               until ((sintL)(--countvar_from_dotimesL) == -1);   \
      }   }
    #define dotimespL_(countvar_from_dotimespL,count_from_dotimespL,statement_from_dotimespL)  \
      { countvar_from_dotimespL = (count_from_dotimespL)-1;                             \
        do {statement_from_dotimespL} until ((sintL)(--countvar_from_dotimespL) == -1); \
      }
  #endif
  #ifndef dotimesL_
    #define dotimesL_(countvar_from_dotimesL,count_from_dotimesL,statement_from_dotimesL)  \
      { countvar_from_dotimesL = (count_from_dotimesL);         \
        until (countvar_from_dotimesL==0)                       \
          {statement_from_dotimesL; countvar_from_dotimesL--; } \
      }
    #define dotimespL_(countvar_from_dotimespL,count_from_dotimespL,statement_from_dotimespL)  \
      { countvar_from_dotimespL = (count_from_dotimespL);                   \
        do {statement_from_dotimespL} until (--countvar_from_dotimespL==0); \
      }
  #endif
  #if defined(GNU) && defined(__OPTIMIZE__)
    # Es ist mir nun schon zweimal passiert, daß ich dotimesL auf eine
    # Variable vom Typ uintC angewandt habe. Damit Jörg und Marcus nicht
    # mehr suchen müssen, überprüfe ich das jetzt.
    # Der Dummy-Aufruf wird, wenn's gut geht, von gcc wegoptimiert.
    # Ansonsten bekommt man einen Fehler beim Linken.
    #define dotimes_check_sizeof(countvar,type)  \
      if (!(sizeof(countvar)==sizeof(type))) { dotimes_called_with_count_of_wrong_size(); }
    extern void dotimes_called_with_count_of_wrong_size (void); # nicht existente Funktion
  #else
    #define dotimes_check_sizeof(countvar,type)
  #endif
  #define dotimesW(countvar_from_dotimesW,count_from_dotimesW,statement_from_dotimesW) \
    { dotimes_check_sizeof(countvar_from_dotimesW,uintW); \
      dotimesW_(countvar_from_dotimesW,count_from_dotimesW,statement_from_dotimesW); \
    }
  #define dotimespW(countvar_from_dotimespW,count_from_dotimespW,statement_from_dotimespW) \
    { dotimes_check_sizeof(countvar_from_dotimespW,uintW); \
      dotimespW_(countvar_from_dotimespW,count_from_dotimespW,statement_from_dotimespW); \
    }
  #define dotimesL(countvar_from_dotimesL,count_from_dotimesL,statement_from_dotimesL) \
    { dotimes_check_sizeof(countvar_from_dotimesL,uintL); \
      dotimesL_(countvar_from_dotimesL,count_from_dotimesL,statement_from_dotimesL); \
    }
  #define dotimespL(countvar_from_dotimespL,count_from_dotimespL,statement_from_dotimespL) \
    { dotimes_check_sizeof(countvar_from_dotimespL,uintL); \
      dotimespL_(countvar_from_dotimespL,count_from_dotimespL,statement_from_dotimespL); \
    }
# doconsttimes(count,statement);
# führt statement count mal aus (count mal der Code!),
# wobei count eine constant-expression >=0, <=8 ist.
  #define doconsttimes(count_from_doconsttimes,statement_from_doconsttimes)  \
    { if (0 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (1 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (2 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (3 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (4 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (5 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (6 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
      if (7 < (count_from_doconsttimes)) { statement_from_doconsttimes; } \
    }
# DOCONSTTIMES(count,macroname);
# ruft count mal den Macro macroname auf (count mal der Code!),
# wobei count eine constant-expression >=0, <=8 ist.
# Dabei bekommt macroname der Reihe nach die Werte 0,...,count-1 übergeben.
  #define DOCONSTTIMES(count_from_DOCONSTTIMES,macroname_from_DOCONSTTIMES)  \
    { if (0 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((0 < (count_from_DOCONSTTIMES) ? 0 : 0)); } \
      if (1 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((1 < (count_from_DOCONSTTIMES) ? 1 : 0)); } \
      if (2 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((2 < (count_from_DOCONSTTIMES) ? 2 : 0)); } \
      if (3 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((3 < (count_from_DOCONSTTIMES) ? 3 : 0)); } \
      if (4 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((4 < (count_from_DOCONSTTIMES) ? 4 : 0)); } \
      if (5 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((5 < (count_from_DOCONSTTIMES) ? 5 : 0)); } \
      if (6 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((6 < (count_from_DOCONSTTIMES) ? 6 : 0)); } \
      if (7 < (count_from_DOCONSTTIMES)) { macroname_from_DOCONSTTIMES((7 < (count_from_DOCONSTTIMES) ? 7 : 0)); } \
    }

# Ab hier bedeutet uintC einen unsigned-Integer-Typ, mit dem sich besonders
# leicht zählen läßt. Teilmengenrelation: uintW <= uintC <= uintL.
# uintCoverflow(x) stellt fest, ob nach Ausführen eines x++ ein Overflow
# eingetreten ist.
  #define intCsize intWLsize
  #define uintC uintWL
  #define sintC sintWL
  #if (intCsize==intWsize)
    #define dotimesC dotimesW
    #define dotimespC dotimespW
  #endif
  #if (intCsize==intLsize)
    #define dotimesC dotimesL
    #define dotimespC dotimespL
  #endif
  #define uintCoverflow(x)  ((intCsize<intLsize) && ((x)==0))
# Verwende 'uintC' für Zähler, die meist klein sind.

# Die Arithmetik benutzt "Digit Sequences" aus "Digits".
# Das sind unsigned ints mit intDsize Bits (sollte =8 oder =16 oder =32 sein).
# Falls HAVE_DD: "Doppel-Digits" sind unsigned ints mit 2*intDsize<=32 Bits.
  #if defined(MC680X0) && !defined(MC680Y0)
    #define intDsize 16
    #define intDDsize 32  # = 2*intDsize
    #define log2_intDsize  4  # = log2(intDsize)
  #elif defined(MC680Y0) || defined(I80Z86) || defined(SPARC) || defined(HPPA) || defined(MIPS) || defined(M88000) || defined(RS6000) || defined(VAX) || defined(CONVEX) || defined(ARM) || defined(DECALPHA)
    #define intDsize 32
    #define intDDsize 64  # = 2*intDsize
    #define log2_intDsize  5  # = log2(intDsize)
  #else
    #error "Preferred digit size depends on CPU -- Größe intDsize neu einstellen!"
  #endif
  #ifdef ANSI
    typedef unsigned_int_with_n_bits(intDsize)  uintD;
    typedef signed_int_with_n_bits(intDsize)    sintD;
  #else
    typedef uint/**/intDsize  uintD;
    typedef sint/**/intDsize  sintD;
  #endif
  #if (intDDsize<=32) || ((intDDsize<=64) && defined(DECALPHA))
    #define HAVE_DD 1
    #ifdef ANSI
      typedef unsigned_int_with_n_bits(intDDsize)  uintDD;
      typedef signed_int_with_n_bits(intDDsize)    sintDD;
    #else
      typedef uint/**/intDDsize  uintDD;
      typedef sint/**/intDDsize  sintDD;
    #endif
  #else
    #define HAVE_DD 0
  #endif

# Auch einige andere Kürzel wie 'oint', 'tint', 'aint', 'cint' werden noch
# für entsprechende Integer-Typen verwendet werden:
#   Integertyp     enthält Information äquivalent zu
#      oint           LISP-Objekt
#      tint           Typcode eines LISP-Objekts
#      aint           Adresse eines LISP-Objekts
#      cint           LISP-Character

# Üblicherweise ist sizeof(oint) = sizeof(aint) = sizeof(uintL) = 32 Bit.
# Bei Modell WIDE ist sizeof(oint) > sizeof(uintL).
# Modell WIDE_HARD steht für sizeof(aint) > sizeof(uintL).
#   Dieses Modell muß dann gewählt werden, wenn
#   sizeof(void*) > sizeof(uintL) = 32 Bit ist. Es setzt
#   sizeof(long) = sizeof(void*) = 64 Bit voraus, denn einige 64-Bit-Zahlen
#   tauchen als Präprozessor-Konstanten auf.
# Modell WIDE_SOFT steht für sizeof(oint) = 64 Bit und sizeof(aint) = 32 Bit.
#   Dieses Modell kann auf jeder 32-Bit-Maschine gewählt werden, wenn der
#   Compiler (soft- oder hardwaremäßige) 64-Bit-Zahlen hat. Es muß dann
#   gewählt werden, wenn ansonsten nicht genug Platz für die Typbits in einem
#   32-Bit-Pointer wäre.

#ifdef DECALPHA
  #define WIDE_HARD
#endif

#if defined(WIDE) && !(defined(WIDE_HARD) || defined(WIDE_SOFT))
  #define WIDE_SOFT
#endif
#if (defined(WIDE_HARD) || defined(WIDE_SOFT)) && !defined(WIDE)
  #define WIDE
#endif
# Nun ist defined(WIDE) == defined(WIDE_HARD) || defined(WIDE_SOFT)

#ifdef WIDE_SOFT
  #ifdef GNU
    # Benutze die GNU-C-Erweiterungen, um die breiten oints als structs aufzufassen.
    #define WIDE_STRUCT
  #endif
  # Bestimmt die Anordnung der Teile eines oints:
  #define WIDE_ENDIANNESS TRUE
#endif

#if defined(GNU) && (SAFETY >= 3)
  #if (__GNUC__ >= 2)
    #if (__GNUC_MINOR__ >= 7) # gcc-2.6.3 Bug umgehen
      # Typüberprüfungen durch den C-Compiler
      #define OBJECT_STRUCT
    #endif
  #endif
#endif


# ###################### Betriebssystem-Routinen ##################### #

# allgemein standardisierte Konstanten für Steuerzeichen:
  #define BS    8  #  #\Backspace     Backspace
  #define TAB   9  #  #\Tab           Tabulator
  #define LF   10  #  #\Linefeed      Zeilenvorschub
  #define CR   13  #  #\Return        Carriage return, zum Zeilenanfang
  #define PG   12  #  #\Page          Form Feed, neue Seite

#ifdef AMIGAOS

#include "amiga.c"

# statement im Unterbrechungsfalle (Ctrl-C gedrückt) ausführen:
# interruptp(statement);
  #define interruptp(statement) \
    { # Ctrl-C-Signal abfragen und löschen:                             \
      if (SetSignal(0L,(CLISP_ULONG)(SIGBREAKF_CTRL_C)) & (SIGBREAKF_CTRL_C)) \
        { statement }                                                   \
    }
  # vgl. AMIGA.D und exec.library/SetSignal
# wird verwendet von EVAL, IO, SPVW, STREAM

#endif # AMIGAOS

#ifdef RISCOS

#include "acorn.c"

# Unterbrechungen noch nicht implementiert.
  #define interruptp(statement)

# Verdecken der Funktion read:
  #define read LISPread

#endif # RISCOS

#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(WIN32_DOS) || defined(WIN32_UNIX)

#if defined(UNIX) || defined(WIN32_UNIX)
#include "unix.c"
#endif
#ifdef MSDOS
#include "msdos.c"
#endif

# statement im Unterbrechungsfalle ausführen:
# interruptp(statement);
 #if defined(UNIX) || (defined(EMUNIX) && !defined(WINDOWS)) || defined(WIN32_UNIX)
  # Eine Tastatur-Unterbrechung (Signal SIGINT, erzeugt durch Ctrl-C)
  # wird eine Sekunde lang aufgehoben. In dieser Zeit kann sie mittels
  # 'interruptp' auf fortsetzbare Art behandelt werden. Nach Ablauf dieser
  # Zeit wird das Programm nichtfortsetzbar unterbrochen.
  #define PENDING_INTERRUPTS
  extern uintB interrupt_pending;
  #define interruptp(statement)  if (interrupt_pending) { statement; }
 #endif
 #if defined(DJUNIX)
  # DJUNIX kennt keine Signale, nicht mal Ctrl-C.
  # Hat auch kein alarm() oder ualarm().
  #define interruptp(statement)  if (_go32_was_ctrl_break_hit()) { statement; }
 #endif
 #if defined(WATCOM) && !defined(WINDOWS)
  # WATCOM hat kein alarm() oder ualarm().
  #define interruptp(statement)  FALSE
 #endif
 #if defined(WINDOWS)
  # Eine Unterbrechung (erzeugt durch einen Windows-Event) wird aufgehoben.
  # Sie kann mittels 'interruptp' auf fortsetzbare Art behandelt werden.
  #define PENDING_INTERRUPTS
  extern uintB interrupt_pending;
  #define interruptp(statement)  if (interrupt_pending) { statement; }
 #endif
 #if defined(WIN32_UNIX) || defined(WIN32_DOS)
   #define PENDING_INTERRUPTS
   extern uintB interrupt_pending;
   #define interruptp(statement) if (interrupt_pending) { statement; }
 #endif
# wird verwendet von EVAL, IO, SPVW, STREAM

# Verdecken der Systemfunktion read:
  #define read LISPread
# Consensys macht "#define DS 3". Grr...
  #undef DS
# 386BSD macht "#define CBLOCK 64". Grr...
  #undef CBLOCK
# BSDI 1.1 macht "#define IMMUTABLE". Grr...
  #ifdef __bsdi__
    #undef IMMUTABLE
  #endif

#endif # UNIX || DJUNIX || EMUNIX || WATCOM

# ##################### Weitere System-Abhängigkeiten ##################### #

# Erst solche, die bis auf die Lisp-Ebene hin sichtbar sind:

# Einstellung der Tabelle von Zeichennamen:
  #ifdef AMIGA
    #define AMIGA_CHARNAMES
  #endif
  #ifdef MSDOS
    #define MSDOS_CHARNAMES
  #endif
  #if defined(UNIX) || defined(RISCOS) || defined(WIN32_UNIX)
    #define UNIX_CHARNAMES
  #endif
# Bei Erweiterung: CONSTOBJ, CHARSTRG, FORMAT.LSP erweitern.

# Ob ein Stream *KEYBOARD-INPUT* gebildet wird,
# und ob er für den Stream *TERMINAL-IO* verwendet wird:
  #if defined(MSDOS) || (defined(UNIX) && !defined(NEXTAPP) || defined(MAYBE_NEXTAPP)) || defined(RISCOS)
    #define KEYBOARD
    #if 0 # || defined(WINDOWS) ??
      #define TERMINAL_USES_KEYBOARD
    #endif
  #endif
# Bei Erweiterung: STREAM, USER1.LSP erweitern.

# Ob wir die GNU Readline-Library für *TERMINAL-IO* benutzen:
  #if ((defined(UNIX) && !defined(NEXTAPP)) || (defined(MSDOS) && !defined(WATCOM) && !defined(WINDOWS))) && !defined(NO_READLINE)
    # Auf WATCOM ist die Readline-Library noch nicht portiert.
    # Unter Windows und bei NEXTAPP haben wir Besseres vor.
    #define GNU_READLINE
  #endif
# Bei Erweiterung: READLINE erweitern.

# Ob es Window-Streams und eine Package SCREEN gibt:
  #if defined(MSDOS) || (defined(UNIX) && !defined(NEXTAPP) || defined(MAYBE_NEXTAPP)) || defined(WIN32_UNIX)
    #define SCREEN
  #endif
# Bei Erweiterung: STREAM erweitern (viel Arbeit!).

# Ob es File-Handle-Streams gibt:
  #if defined(UNIX) || defined(MSDOS) || defined(AMIGAOS) # || defined(RISCOS)
    #define HANDLES
  #endif
# Bei Erweiterung: STREAM erweitern.

# Ob es Pipe-Streams gibt:
  #if defined(UNIX) || defined(EMUNIX_PORTABEL)
    #define PIPES
    #if defined(UNIX) || defined(EMUNIX_PORTABEL)
      #define PIPES2  # bidirektionale Pipes
    #endif
  #endif
# Bei Erweiterung: STREAM und USER2.LSP erweitern.

# Ob es Socket-Streams gibt:
  #if defined(UNIX) && defined(HAVE_GETHOSTBYNAME)
    # Damit Socket-Streams sinnvoll sind, muß socket.d compilierbar sein.
    # Dazu muß netdb.h oder sun/netdb.h existieren, was zufällig auch der
    # Existenz von gethostbyname() entspricht.
    #define XSOCKETS
    #define SOCKET_STREAMS
  #endif
# Bei Erweiterung: STREAM erweitern.

# Whether there are generic streams:
  #if 1
    #define GENERIC_STREAMS
  #endif
# Bei Erweiterung: Nichts weiter zu tun.

# Ob die für die Funktionen MACHINE-TYPE, MACHINE-VERSION, MACHINE-INSTANCE
# benötigte Information vom Betriebssystem geholt werden kann:
  #ifdef UNIX
    #define MACHINE_KNOWN
  #endif
# Bei Erweiterung: MISC erweitern.

# Ob es LOGICAL-PATHNAMEs gibt:
  #if 1
    #define LOGICAL_PATHNAMES
  #endif
# Bei Erweiterung: Nichts weiter zu tun.

# Ob die Funktion USER-HOMEDIR-PATHNAME existiert:
  #if defined(UNIX) || defined(RISCOS) || defined(WIN32_UNIX)
    #define USER_HOMEDIR
  #endif
# Bei Erweiterung: PATHNAME erweitern.

# Ob ein Stream *PRINTER-OUTPUT* bzw. eine Funktion MAKE-PRINTER-STREAM
# zur Verfügung gestellt werden:
  #ifdef AMIGAOS
    #define PRINTER_AMIGAOS
  #endif
# Ob es Printer-Streams gibt:
  #if defined(PRINTER_AMIGAOS)
    #define PRINTER
  #endif
# Bei Erweiterung: STREAM erweitern.

# Ob externe Kommunikation via Rexx unterstützt wird.
  #ifdef AMIGAOS
    #define REXX
    # define REXX_SERVER  # noch nicht ?JCH?
  #endif
# Bei Erweiterung: REXX erweitern.

# Ob Graphik-Operationen unterstützt werden.
  #if (defined(EMUNIX) && !defined(WINDOWS)) || defined(UNIX_LINUX)
    #define GRAPHICS
    #define GRAPHICS_SWITCH  # Umschalten zwischen Text-Modus und Grafik-Modus
  #endif
# Bei Erweiterung: GRAPH erweitern.

# Ob das Betriebssystem ein Environment verwaltet, das Strings zu Strings
# assoziiert:
  #if defined(UNIX) || defined(MSDOS) || defined(AMIGAOS) || defined(RISCOS) || defined(WIN32_UNIX)
    #define HAVE_ENVIRONMENT
  #endif
# Bei Erweiterung: Nichts weiter zu tun.

# Ob das Betriebssystem einen bevorzugten Kommando-Interpreter hat:
  #if defined(UNIX) || defined(MSDOS) || defined(AMIGAOS) || defined(RISCOS) || defined(WIN32_UNIX)
    #define HAVE_SHELL
  #endif
# Bei Erweiterung: PATHNAME erweitern.

# Ob ein Foreign Function Interface zur Verfügung gestellt wird:
  #if (defined(UNIX) && !defined(UNIX_BINARY_DISTRIB)) || defined(DYNAMIC_FFI)
    #define HAVE_FFI
  #endif
# Bei Erweiterung: ??

# Ob ein externer Disassembler zur Verfügung steht:
  #if defined(UNIX) || defined(WIN32_UNIX)
    #define HAVE_DISASSEMBLER
  #endif
# Bei Erweiterung: PATHNAME erweitern.

# Dann die, die nur intern bedeutsam sind:

# Ob die GC nicht mehr referenzierte Files schließt:
  #if defined(UNIX) || defined(WINDOWS) || defined(AMIGAOS) || defined(RISCOS) || defined(WIN32_UNIX)
    #define GC_CLOSES_FILES
  #endif
# Bei Erweiterung: nichts zu tun.

# Wie die Zeitmessungen durchgeführt werden:
  #if defined(WIN32_UNIX) || defined(WIN32_DOS)
    #define TIME_WIN32
  #elif defined(MSDOS)
    #define TIME_MSDOS
  #endif
  #ifdef AMIGAOS
    #define TIME_AMIGAOS
  #endif
  #ifdef RISCOS
    #define TIME_RISCOS
  #endif
  #ifdef UNIX
    #if defined(HAVE_GETTIMEOFDAY) || defined(HAVE_FTIME)
      #define TIME_UNIX
    #elif defined(HAVE_TIMES_CLOCK)
      #define TIME_UNIX_TIMES
    #endif
  #endif
  #if defined(TIME_MSDOS) || defined(TIME_AMIGAOS) || defined(TIME_UNIX_TIMES) || defined(TIME_RISCOS)
    # Die Zeitauflösung ist nur mittel, so daß man für Zeitdifferenz-Messungen
    # ohne weiteres eine 32-Bit-Zahl nehmen kann.
    #define TIME_1
    # Wir holen die Uhrzeit einmal beim System-Start. Alle weiteren
    # Uhrzeiten werden relativ zu dieser genommen.
    #define TIME_RELATIVE
  #endif
  #if defined(TIME_UNIX) || defined(TIME_WIN32)
    # Die Zeitauflösung ist so hoch, daß man für Zeitdifferenz-Messungen gleich
    # zwei 32-Bit-Zahlen braucht: Sekunden und Sekundenbruchteile.
    #define TIME_2
    # In diesem Fall können wir auch gleich immer mit absoluten und genauen
    # Uhrzeiten rechnen.
    #define TIME_ABSOLUTE
  #endif
# Bei Erweiterung: TIME erweitern.

# Ob die Funktion SYS::%SLEEP ein oder zwei Argumente übergeben bekommt:
  #if defined(TIME_MSDOS) || defined(TIME_AMIGAOS) || defined(TIME_RISCOS)
    #define SLEEP_1
  #endif
  #if defined(TIME_UNIX) || defined(TIME_UNIX_TIMES) || defined(TIME_WIN32)
    #define SLEEP_2
  #endif
# Bei Erweiterung: TIME, DEFS1.LSP erweitern.

# Ob das Betriebssystem uns die Run-Time liefern kann, oder ob wir sie
# selber akkumulieren müssen (was bei Multitasking-Betriebssystemen ein wenig
# verfälschend ist: AMIGAOS kann diese Information nicht liefern, RISCOS??):
  #if defined(UNIX) || defined(WIN32_UNIX) || defined(WIN32_DOS)
    #define HAVE_RUN_TIME
  #endif
# Bei Erweiterung: TIME erweitern.

# Ob das Betriebssystem Virtual Memory zur Verfügung stellt.
  #if defined(UNIX) || defined(EMUNIX) || defined(DJUNIX) || defined(WINDOWS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
    #define VIRTUAL_MEMORY
  #endif
# Bei Erweiterung: nichts zu tun.

# Ob das Betriebssystem Unterbrechungen (Ctrl-C o.ä.) als Signal auszuliefern
# in der Lage ist:
  #if defined(UNIX) || ((defined(EMUNIX) || defined(WATCOM)) && !defined(WINDOWS)) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
    #define HAVE_SIGNALS
  #endif
# Ob wir auf asynchrone Signale auch reagieren können:
# (Bei WIDE_SOFT ist das Schreiben eines Pointers i.a. keine Elementar-Operation mehr!)
  #if defined(WIDE_SOFT) && !(defined(GNU) && defined(SPARC))
    #define NO_ASYNC_INTERRUPTS
  #endif
# Bei Erweiterung: SPVW erweitern, interruptp() schreiben.

# Arten der Pathname-Verwaltung:
  #ifdef AMIGAOS
    #define PATHNAME_AMIGAOS
  #endif
  #ifdef MSDOS
    #if defined(OS2) || defined(WIN32_DOS)
    #define PATHNAME_OS2
   #else
    #define PATHNAME_MSDOS
   #endif
  #endif
  #ifdef RISCOS
    #define PATHNAME_RISCOS
  #endif
  #ifdef UNIX
    #define PATHNAME_UNIX
  #endif
  #ifdef WIN32_UNIX
    #define PATHNAME_UNIX
  #endif
# Die Komponenten von Pathnames:
  #if defined(PATHNAME_AMIGAOS) || defined(PATHNAME_MSDOS) || defined(PATHNAME_OS2)
    #define HAS_HOST      0
    #define HAS_DEVICE    1
    #define HAS_VERSION   0
  #endif
  #ifdef PATHNAME_UNIX
    #define HAS_HOST      0
    #define HAS_DEVICE    0
    #define HAS_VERSION   0
  #endif
  #ifdef PATHNAME_RISCOS
    #define HAS_HOST      1
    #define HAS_DEVICE    1
    #define HAS_VERSION   0
    #define FLIP_NAME_TYPE # Name und Type zum Betriebssystem hin vertauschen
  #endif
# Handhabung der File "Extension" (pathname-type):
  #ifdef PATHNAME_MSDOS
    #define PATHNAME_EXT83  # Name und Type getrennt, Abschneiden nach 8 bzw. 3 Zeichen
  #endif
  #if defined(PATHNAME_RISCOS)
    #define PATHNAME_EXT  # Name und Type getrennt, aber keine Längenbegrenzung
  #endif
  #if defined(PATHNAME_UNIX) || defined(PATHNAME_AMIGAOS) || defined(PATHNAME_OS2)
    #define PATHNAME_NOEXT  # Keine explizite Extension.
  #endif
# Bei Erweiterung: PATHNAME erweitern.

# Ob es einen Typ FOREIGN gibt (eine Verpackung für diverse Pointer):
  #if defined(DYNAMIC_FFI) || defined(AMIGAOS)
    #define FOREIGN  void*
  #endif
# Bei Erweiterung: Nichts weiter zu tun.

# Ob Simple-Strings am Stück an Streams durchgereicht werden:
  #if defined(UNIX) || defined(AMIGAOS) || defined(OS2) || defined(RISCOS)
    #define STRM_WR_SS
  #endif
# Bei Veränderung: Nichts weiter zu tun.

# Ob an diversen Schlüsselstellen der STACK überprüft wird:
  #define STACKCHECKS  (SAFETY >= 1) # beim Aufruf von SUBRs und FSUBRs
  #define STACKCHECKC  (SAFETY >= 1) # beim Abinterpretieren compilierter Closures
  #define STACKCHECKR  (SAFETY >= 1) # im Reader
  #define STACKCHECKP  (SAFETY >= 1) # im Printer
# Bei Veränderung: Nichts weiter zu tun.

# Ob subr_tab statisch zu initialisieren versucht wird.
  #if (1 || defined(ANSI) || defined(GNU)) && !(defined(WIDE_SOFT) && !defined(WIDE_STRUCT)) && !defined(WATCOM)
    #define INIT_SUBR_TAB
  #endif
# Bei Veränderung: Nichts weiter zu tun.

# Ob symbol_tab statisch zu initialisieren versucht wird.
# (Es macht die Initialisierung einfacher, aber bei GNU-C auf einem Amiga
# reicht der Platz zum Compilieren von SPVWTABS nicht.
# WATCOM stürzt ab mit "Abnormal program termination: Page fault".
# Und Nicht-ANSI-Compiler verweigern das Initialisieren von Unions.)
  #if (defined(ANSI) || defined(GNU)) && !(defined(WIDE_SOFT) && !defined(WIDE_STRUCT)) && !(defined(AMIGA) || defined(WATCOM))
    #define INIT_SYMBOL_TAB
  #endif
# Bei Veränderung: Nichts weiter zu tun.

# Ob object_tab statisch zu initialisieren versucht wird.
  #if (1 || defined(ANSI) || defined(GNU)) && !(defined(WIDE_SOFT) && !defined(WIDE_STRUCT)) && !defined(WATCOM)
    #define INIT_OBJECT_TAB
  #endif
# Bei Veränderung: Nichts weiter zu tun.


# ############### Liste von implementierten CLtL2-Features ################ #

#undef  X3J13_003
#define X3J13_005  # 18.5.1993
#define X3J13_014  # 22.1.1995
#define X3J13_149  # 22.7.1993
#define X3J13_161  # 20.5.1993
#define X3J13_175  # 25.7.1993


# ##################### Speicherstruktur von Objekten ##################### #

/*

FESTLEGUNG DER BEDEUTUNG DES TYP-INFOBYTES UND DER SPEICHERFORMATE DER
======================================================================
                       VERSCHIEDENEN DATENTYPEN
                       ========================

1. Typ-Infobyte
---------------

Das Typ-Infobyte besteht aus den höchstwertigen 8 Bits (Bits 24-31)
des Langworts, das ein Datum repräsentiert. Außer in einigen speziellen
Fällen ("kleine Daten" wie Zeichen, Fixnums u.ä.) enthalten die übrigen
24 Bits die Speicheradresse des Objekts (wie Cons, Symbol, Vektor...).
Bit 7 des Infobytes (Bit 31 des Langworts) dient als Markierungsbit
für den Garbage Collector und ist außerhalb desselben stets gelöscht
(einzige Ausnahme: Hilfsroutine für PRINT-CIRCLE). Bit 6 (Bit 30) ist
genau dann gesetzt, wenn es sich um ein Cons handelt (CONS_BIT), Bit 5
(Bit 29) genau dann, wenn es sich um ein Symbol handelt (SYMBOL_BIT).
Bit 4 (Bit 28) ist nur bei Zahlen gesetzt (NUMBER_BIT). Die übrigen
4 Bits dienen der näheren Unterscheidung. Die Bedeutungen im einzelnen:

Bits 76543210       Bedeutung (Typ)

     00000000       Maschinenpointer  (*)
     00000???       array
     000000??       einfacher vector (d.h. eindimensionaler Array
                                      ohne zusätzl. Features)
     00000001       simple-bit-vector
     00000010       simple-string
     00000011       simple-vector
     000001??       übrige Arrays
     00000100       sonstige Arrays (Rang /= 1 oder andere Elementtypen)
     00000101       bit-vector oder byte-vector, kein simple-bit-vector
     00000110       string, kein simple-string
     00000111       (vector t), kein simple-vector
     00001...       Records:
     00001000        closure
     00001001        structure
     00001010        stream
     00001011        sonstige (package, readtable, hash-table ...)
     00001100        instance
     00001101       character         (*)
     00001110       subr              (*)
     00001111....0  frame-pointer     (*) [STACK muß Alignment 2 haben!]
     000011110...1  read-label        (*)
     000011111...1  system            (*) (UNBOUND, SPECDECL u.ä.)
     0001???V       number (V = Vorzeichen bei reellen Zahlen)
     0001000V       fixnum            (*)
     0001001V       short-float       (*)
     0001010V       bignum
     0001011V       single-float
     0001100V       ratio
     0001101V       double-float
     00011100       complex
     0001111V       long-float
     0010????       symbol
     0100????       cons

(Objekte der mit (*) gekennzeichneten Typen sind nicht im Speicher
verschiebbar und brauchen daher bei der GC nicht berücksichtigt zu
werden.)

2. Speicherformate
------------------

2.0. Maschinenpointer

Ein Maschinenpointer ist eine fürs LISP-System bedeutungslose Adresse.
(Beispielsweise Pointer in den SP oder in den STACK, die keine Typinfo
tragen. Können z.B. vorübergehend im Stack liegen.)
Maschinenpointer, die nicht in 24 Bit passen, müssen als Foreign-Pointer
in einen Simple-Bit-Vector verpackt werden.

2.1. CONS

Ein Cons umfaßt 8 Byte, aufgeteilt in 2 Langworte. Das erste enthält
den CDR, das zweite den CAR.

     +-+-----+       +-------+-------+
     |T| ADR |  ADR: |  CDR  |  CAR  |
     +-+-----+       +-------+-------+

ADR: Adresse des Records für CAR und CDR
T: Typ-Info für CONS #b0100????
Conses befinden sich im Speicherbereich für Zwei-Pointer-Objekte.

2.2. SYMBOL

Ein Symbol umfaßt 24 Byte (6 Langworte). Das zweite enthält den aktuellen
dynamischen Wert, das dritte die globale Funktionsdefinition (wenn nicht
vorhanden, steht in beiden Fällen dort der Wert #UNBOUND). Das vierte
Langwort enthält die Property-Liste (zunächst NIL), das fünfte den Namen
des Symbols (ein [einfacher] String). Im sechsten Langwort befindet sich
die Home-Package, und das erste ist frei für die GC, bis auf einige
Flags (KEYWORD, CONSTANT, SPECIAL).

     +-+-----+       +-------+-------+-------+-------+-------+-------+
     |T| ADR |  ADR: |F      | VALUE | FUNCT.| PLIST | NAME  | PACK. |
     +-+-----+       +-------+-------+-------+-------+-------+-------+

ADR: Adresse der Recordstruktur
T: Typ-Info für SYMBOL #b0010????
F: Bits 2..0 sind die Flags
Symbole befinden sich im Speicherbereich für Objekte variabler Länge.

2.3. CHARACTER

Code, Bit- und Font-Attribute befinden sich direkt im darstellenden
Langwort: Bits 0-7 geben den (ASCII-)Code des Zeichens, Bits 8-11 sind
die Control-Bits (control: Bit 8, meta: Bit 9, super: Bit 10, hyper:
Bit 11) und Bits 12-15 die Fontnummer (0 bis 15); die Bits 16-23 sind
stets 0, nur Bit 16 wird bei den Streams als Markierung benutzt.

     +-+-+--+-+
     |T|0|FB|C|
     +-+-+--+-+

T = #b00001100 Typ-Info für CHARACTER
0 = #b00000000
F = 4 Bits für Fontnummer (obere 4 Bits)
B = 4 Control-Bits (untere 4 Bits)
C = 8 Bits für Code

2.4. SUBR, FSUBR

Die unteren 24 Bits enthalten die Startadresse des Maschinenunter-
programms, das die betreffende Funktion ausführt (zum Format des
Codes siehe unten).

     +-+-----+
     |T| ADR |
     +-+-----+

T = #b00001101 oder #b00001110 Typ-Info für SUBR oder FSUBR

2.5. FRAME-POINTER

Die unteren 24 Bits enthalten die Adresse des Frame-Anfangs (im LISP-
Stack), "Anfang" heißt Adresse des Langworts mit dem Frame-Infobyte.

     +-+-----+
     |T| ADR |
     +-+-----+

T = #b00001111 Typ-Info für FRAME-POINTER
Zum Aufbau der Frames siehe EVALBIBL.

2.6. READ-LABEL

Die unteren 22 Bits (Bit 23 ist gesetzt, Bit 22 gelöscht) enthalten
die Nummer n des Labels #n= .

     +-+-----+
     |T| VAL |
     +-+-----+

T = #b00001111 Typ-Info für SYSTEM, VAL = #b10??????????????????????

2.7. SYSTEM

Die unteren 22 Bits (Bits 22,23 sind gesetzt) enthalten irgendeine
spezielle Markierung (z.B. #b1111111111111111111111 für #UNBOUND).

     +-+-----+
     |T|FLAG |
     +-+-----+

T = #b00001111 Typ-Info für SYSTEM, FLAG = #b11??????????????????????

2.8. FIXNUM

Bit 24 enthält das Vorzeichen (1 für negativ, 0 für >= 0), die unteren
24 Bits enthalten den Wert in Zweierkomplementdarstellung (der Werte-
bereich geht also von -2^24 bis +2^24-1).

     +-+-----+
     |T|WERT |
     +-+-----+

T = #b0001000V Typ-Info für FIXNUM

2.9. BIGNUM

Bignums werden in Zweierkomplementdarstellung variabler Länge abge-
speichert. Das höchstwertige Bit gibt das Vorzeichen an.
Die Zahl ist durch einen Vektor von Bits gegeben:

      +-+-----+        +-------+---+--------------------+
      |T| ADR |   ADR: |       |LEN|  ...   DATA   ...  |
      +-+-----+        +-------+---+--------------------+

ADR: Adresse des Zahlvektors
T = #b0001010V Typ-Info für BIGNUM (V = Vorzeichen)
LEN = Länge der Zahl (in Digits), ( >= 2 )
DATA = Zahl in Zweierkomplementdarstellung
Bignums befinden sich im Speicherbereich für Objekte variabler Länge.

2.10. SHORT-FLOAT

Bit 24 = Vorzeichen, Rest = Wert (Bits 16-23 für Exponent, Bits 0-15
für Mantisse)

     +-+-----+
     |T|WERT |
     +-+-----+

T = #b0001001V Typ-Info für SHORT-FLOAT

2.11. SINGLE-FLOAT

Wird im Bereich für Objekte variabler Länge abgespeichert:

      +-+-----+         +-------+-------+
      |T| ADR |    ADR: |       | WERT  |
      +-+-----+         +-------+-------+

ADR: Adresse des Zahl-"Vektors"
T: Typ-Info für SINGLE-FLOAT #b0001011V (V = Vorzeichen)
WERT: Zahlwert (1 Bit Vorz., 8 Bit Exponent, 23 Bit Mantisse)
Single-Floats befinden sich im Speicherbereich für Objekte variabler Länge.

2.12. DOUBLE-FLOAT

Wird im Bereich für Objekte variabler Länge abgespeichert:

      +-+-----+         +-------+---------------+
      |T| ADR |    ADR: |       |     WERT      |
      +-+-----+         +-------+---------------+

ADR: Adresse des Zahl-"Vektors"
T: Typ-Info für DOUBLE-FLOAT #b0001101V (V = Vorzeichen)
WERT: Zahlwert (1 Bit Vorz., 11 Bit Exponent, 52 Bit Mantisse)
Double-Floats befinden sich im Speicherbereich für Objekte variabler Länge.

2.13. LONG-FLOAT

Long-floats sind Realzahlen variabler Genauigkeit (precision). Sie
werden als Vektoren abgespeichert (ähnlich wie BIGNUMs).

      +-+-----+       +-------+---+-------+------------------+
      |T| ADR |  ADR: |       |LEN| EXPO  | ... MANTISSE ... |
      +-+-----+       +-------+---+-------+------------------+

ADR: Adresse des Zahlvektors
T = #b0001111V Typ-Info für LONG-FLOAT (V = Vorzeichen)
LEN = Länge der Mantisse in Digits
EXPO = Exponent (in Zweierkomplementdarstellung)
MANTISSE = Mantisse (16*LEN Bits)
Long-Floats befinden sich im Speicherbereich für Objekte variabler Länge.

2.14. RATIO

Brüche werden wie CONSes abgespeichert:

     +-+-----+       +-------+-------+
     |T| ADR |  ADR: |  NUM  | DENOM |
     +-+-----+       +-------+-------+

ADR: Adresse des Records für Zähler und Nenner
T: Typ-Info für RATIO #b0001100V (V = Vorzeichen)
NUM: Zähler (FIXNUM oder BIGNUM /= 0 mit Vorzeichen V)
DENOM: Nenner (FIXNUM oder BIGNUM, positiv, > 1)
Zähler und Nenner sind teilerfremde ganze Zahlen.
Ratios befinden sich im Speicherbereich für Zwei-Pointer-Objekte.

2.15. COMPLEX

Komplexe Zahlen werden wie CONSes abgespeichert:

     +-+-----+       +-------+-------+
     |T| ADR |  ADR: | REAL  | IMAG  |
     +-+-----+       +-------+-------+

ADR2 Adresse des Records für Real-  und Imaginärteil
T: Typ-Info für COMPLEX #b00011100
REAL: Realteil (NUMBER)
IMAG: Imaginärteil (NUMBER, /= INTEGER 0)
Complexs befinden sich im Speicherbereich für Zwei-Pointer-Objekte.

2.16. SIMPLE-VECTOR

Simple-Vectors sind Records von LISP-Objekten:

      +-+-----+      +-------+-------+-------+-----+-------+
      |T| ADR | ADR: |       |  LEN  | OBJ1  | ... | OBJn  |
      +-+-----+      +-------+-------+-------+-----+-------+

ADR: Adresse des Records
T: Typ-Info für SIMPLE-VECTOR #b00000011
LEN: Anzahl n der Objekte im Vektor
OBJi: LISP-Objekte (die Vektor-Elemente)
Simple-Vectors befinden sich im Speicherbereich für Objekte variabler Länge.

2.17. SIMPLE-BIT-VECTOR

      +-+-----+      +-------+-------+------------------+
      |T| ADR | ADR: |       |  LEN  |  ...  BITS  ...  |
      +-+-----+      +-------+-------+------------------+

ADR: Adresse des Bit-Vektors
T: Typ-Info für SIMPLE-BIT-VECTOR #b00000001
LEN: Länge des Vektors (Anzahl Bits)
BITS: Die Bits des Vektors, aufgefüllt auf durch 16 teilbare Anzahl
      (Bit Nummer x ist Bit (7-(x mod 8)) im Byte (ADR+DATA_+(x div 8)).)
Simple-Bit-Vectors befinden sich im Speicherbereich für Objekte variabler Länge.

2.18. SIMPLE-STRING

      +-+-----+      +-------+-------+-------------------+
      |T| ADR | ADR: |       |  LEN  |  ...  CHARS  ...  |
      +-+-----+      +-------+-------+-------------------+

ADR: Adresse des Zeichen-Vektors
T: Typ-Info für SIMPLE-STRING #b00000010
LEN: Anzahl Zeichen im String
CHARS: Die Zeichen (im ASCII-Code, aufgefüllt auf gerade Anzahl)
Simple-Strings befinden sich im Speicherbereich für Objekte variabler Länge.

2.19. ARRAY

      +-+-----+
      |T| ADR |
      +-+-----+

      +-------+-+-+---+-------+-------+-------+-------+-----+-------+-------+
ADR:  |       |F| |RK | DATA  | TSIZE +[D.OFF]| DIM1  | ... | DIMn  |[FILLP]|
      +-------+-+-+---+-------+-------+-------+-------+-----+-------+-------+

ADR: Adresse des Datenrecords für den Array
T: #b000001?? Typ-Info für Array
F: nähere Information (8 Bits):
     Bit 7: 1 = adjustable
     Bit 6: 1 = Fill-Pointer ist vorhanden (nur bei n = 1 möglich)
     Bit 5: 1 = displaced
     Bit 4: 1 = Platz für Displaced-Offset ist vorhanden
              (<==> Array adjustable oder displaced)
     Bits 0-3: Element-Typ, im Fall T = #b00000111
          nötig: T, BIT, STRING-CHAR
          wünschenswert: SINGLE-FLOAT, LONG-FLOAT, evtl. FIXNUM
             (dann müssen aber die Macros VECTORP und ARRAY1P in
              BIBTYPE geändert werden!)
           Bit 3210       Bedeutung (Element-Typ)
               1000          BIT
               0001          2BIT
               0010          4BIT
               0011          8BIT
               0100          16BIT
               0101          32BIT
               1110          T
               1111          STRING-CHAR
         Der Element-Typ ist auch der Element-Typ des Datenvektors. (Ausnahme:
         Byte-Vektoren. Deren letzter Datenvektor ist ein Simple-Bit-Vektor.)
RK: Rang n (von 0 bis 65535)
DATA: Vektor mit Arrayelementen (in lexikographischer Ordung gemäß den
      Indices) oder (falls displaced) Array, auf den displaced wurde.
TSIZE: Total-Size (als vorzeichenlose 32-Bit-Zahl)
D.OFF: Falls F,Bit 4 = 1: Falls F,Bit 5 = 1: displaced-offset, sonst
       beliebig (nur Platzhalter für den Fall, daß bei ADJUST-ARRAY
       die :DISPLACED-TO-Option angegeben wird).
DIMi: i-te Dimension (als vorzeichenlose 32-Bit-Zahl)
FILLP: Falls F,Bit 6 = 1: Fill-Pointer (als vorzeichenlose 32-Bit-Zahl)

(Die Gesamtgröße des Arrays (d.h. TSIZE = DIM1*...*DIMn) ist gleich der Länge
des Datenvektors, falls nicht displaced, abgesehen von obiger Ausnahme.)

Arrays befinden sich im Speicherbereich für Objekte variabler Länge.

2.20. Records (CLOSURE, STRUCTURE, INSTANCE, STREAM etc.)

      +-+-----+      +-------+-+-+---+-------+-----+-------+
      |T| ADR | ADR: |       |F|t| L | DAT1  | ... | DATn  |
      +-+-----+      +-------+-+-+---+-------+-----+-------+

ADR: Adresse des Records
T: #b000010?? Typ-Info für Records
F: 8 Flag-Bits für zusätzliche lokale Information
     (z.B. bei Hash-Tables für Test (EQ, EQL, EQUAL) und ob
      Rehash nach GC nötig ist)
t: 8 Bits nähere Typinformation bei T = #b00001011:
     #b11111111 = Hash-Table
     #b00000000 = Package
     #b00000001 = Readtable
     #b00000010 = Pathname
     #b00000011 = Random-State
     #b00000100 = Byte
     #b00000101 = Load-time-Eval
     #b00000110 = Symbol-Macro
L: Länge des Records (in Pointern) (ein Wort)
DATi: Elemente des Records
Records befinden sich im Speicherbereich für Objekte variabler Länge.

2.21. Records im Einzelnen

2.21.1. Closures

Interpretierte Closures:
  F=t=0, L=21, die Daten sind:
  NAME            Name der Funktion (:LAMBDA als Default)
  FORM            gesamter Lambdabody (lambda-list {decl|doc} {form}) oder NIL
  DOCSTRING       Docstring oder NIL
  BODY            Liste der auszuführenden Formen
  VAR_ENV         Variablen-Environment             | Environments,
  FUN_ENV         Funktionsdefinitions-Environment  | die beim Aufruf
  BLOCK_ENV       Block-Environment                 | der Closure zu
  GO_ENV          Tagbody-Environment               | aktivieren sind
  DECL_ENV        Deklarations-Environment          |
  VARS            Vektor mit allen Variablen in der richtigen Reihenfolge
  VARFLAGS        parallel dazu: Byte-Vektor, in dem jeweils evtl.
                    DYNAM_BIT und SVAR_BIT gesetzt sind (DYNAM_BIT,
                    wenn die Variable dynamisch gebunden werden muß,
                    SVAR_BIT, wenn eine supplied-p-Variable folgt)
  SPEC_ANZ        Anzahl der dynamischen Referenzen
  REQ_ANZ         Anzahl der required-Parameter
  OPT_ANZ         Anzahl der optional-Parameter
  OPT_INITS       Liste der Initialisierungsformen der optional-Parameter
  KEY_ANZ         Anzahl der Keyword-Parameter
  KEYWORDS        Liste der zugehörigen Keywords (oder 0, falls überhaupt
                    keine Keywords zugelassen sind)
  KEY_INITS       Liste der Initialisierungsformen der Keyword-Parameter
  ALLOW_FLAG      Flag für &ALLOW-OTHER-KEYS (NIL oder T)
  REST_FLAG       Flag für &REST-Parameter (NIL oder T)
  AUX_ANZ         Anzahl der &AUX-Variablen
  AUX_INITS       Liste der Initialisierungsformen der &AUX-Variablen

Compilierte Closures:
F=t=0, die Daten sind:
  Name            Name der Funktion
  CODEVEC         Bytecode-Vektor
  [VenvConst]
  {BlockConst}*
  {TagbodyConst}*
  {Keyword}*
  {sonstige Const}*
VenvConst, BlockConst, TagbodyConst : diese LISP-Objekte werden innerhalb der
Funktion als Konstanten betrachtet. Sie werden beim Aufbau der Funktion zur
Laufzeit mitgegeben. Sollten diese drei Teile fehlen (d.h. diese Funktion ist
von der Inkarnation unabhängig, weil sie auf keine lexikalischen Variablen,
Blocks oder Tags zugreift, die im compilierten Code außerhalb von ihr definiert
werden), so heißt die Funktion autonom.
Keyword : die Keywords in der richtigen Reihenfolge. Werden vom Interpreter bei
der Parameterübergabe gebraucht.
sonstige Const: sonstige Konstanten, auf die vom Innern der Funktion aus Bezug
genommen wird. Sie sind untereinander und zu allen Keywords paarweise nicht EQL.
CODEVEC = Code-Vektor, ein SIMPLE-BIT-VECTOR,
   2 Bytes : Anzahl der required parameter
   2 Bytes : Anzahl der optionalen Parameter
   1 Byte : Flags. Bit 0: ob &REST - Parameter angegeben
                   Bit 7: ob Keyword-Parameter angegeben
                   Bit 6: &ALLOW-OTHER-KEYS-Flag
   1 Byte : Kürzel für den Argumenttyp, für schnelleres FUNCALL
   Falls Keyword-Parameter angegeben:
     4 Bytes : 2 Bytes : Anzahl der Keyword-Parameter
               2 Bytes : Offset in FUNC der Keywords
   dann
   eine Folge von Byte-Instruktionen.

2.21.2. Structures

t=0, L>0, erstes Element ist das LIST* aller Structure-Typen, der die
Structure angehört (alles Symbole): (name_1 ... name_i-1 name_i)
Siehe RECORD.D

2.21.3. Instanzen

t=0, L>0, erstes Element ist die Klasse, von der das Objekt eine direkte
Instanz ist. (Oberklassen werden nicht direkt aufgeführt.) Dann die Slots,
die instanz-alloziert sind.

2.21.4. Streams

t codiert den Typ des Streams:
  Bit 0-7 genauerer Typ
F codiert den Zustand des Streams:
  Bit 0-3 =0
  Bit 4 gesetzt, falls READ-BYTE möglich ist
  Bit 5 gesetzt, falls WRITE-BYTE möglich ist
  Bit 6 gesetzt, falls READ-CHAR möglich ist
  Bit 7 gesetzt, falls WRITE-CHAR möglich ist
L >=6, die festen Daten sind:
RD_BY          Pseudofunktion zum Lesen eines Bytes
WR_BY          Pseudofunktion zum Schreiben eines Bytes
RD_CH          Pseudofunktion zum Lesen eines Characters
WR_CH          Pseudofunktion zum Schreiben eines Characters
RD_CH_LAST     letztes gelesenes Zeichen und Flag
WR_CH_LPOS     Position in der Zeile

2.21.5. Packages

F=0, L=7, die Daten sind:
EXTERNAL_SYMBOLS     Symboltabelle der extern präsenten Symbole
INTERNAL_SYMBOLS     Symboltabelle der intern präsenten Symbole
SHADOWING_SYMBOLS    Liste der Shadowing-Symbole
USE_LIST             Use-List
USED_BY_LIST         Used-By-List
NAME                 Package-Name
NICKNAMES            Liste der Nicknames der Package
Siehe PACKAGE.D

2.21.6. Hash-Tables

t=-1.
F codiert den Typ und den Zustand der Hashtabelle:
  Bit 0 gesetzt, wenn EQ-Hashtabelle
  Bit 1 gesetzt, wenn EQL-Hashtabelle
  Bit 2 gesetzt, wenn EQUAL-Hashtabelle
  Bit 3-6 =0
  Bit 7 gesetzt, wenn Tabelle nach GC reorganisiert werden muß
L=10, die Daten sind:
SIZE                Fixnum>0 = Länge der ITABLE
MAXCOUNT            Fixnum>0 = Länge der NTABLE
ITABLE              Index-Vektor der Länge SIZE, enthält Indizes
NTABLE              Next-Vektor der Länge MAXCOUNT, enthält Indizes
KVTABLE             Key-Value-Vektor, Vektor der Länge 2*MAXCOUNT
FREELIST            Start-Index der Freiliste im Next-Vektor
COUNT               Anzahl der Einträge in der Table, Fixnum >=0, <=MAXCOUNT
REHASH_SIZE         Wachstumsrate bei Reorganisation. Float >1.1
MINCOUNT_THRESHOLD  Verhältnis MINCOUNT/MAXCOUNT = 1/rehash-size^2
MINCOUNT            Fixnum>=0, untere Grenze für COUNT
Siehe HASHTABL.D

2.21.7. Readtables

F=0, L=3, die Daten sind:
SYNTAX_TABLE           Syntaxcodes, ein Bitvektor mit 256 Bytes
MACRO_TABLE            Read-Macros, ein Vektor mit 256 Funktionen/Vektoren/NILs
CASE                   Case, ein Fixnum in {0,1,2}
Siehe IO.D

2.21.8. Pathnames

F=0, L<=6, die Daten sind:
evtl. HOST             Host
evtl. DEVICE           Drive
      DIRECTORY        Disknummer und Subdirectory-Path
      NAME             Name
      TYPE             Extension
evtl. VERSION          Version

2.21.9. Random-states

F=0, L=1, die Daten sind:
SEED                   letzte Zahl, ein Simple-Bit-Vector mit 64 Bits

2.21.10. Bytes

F=0, L=2, die Daten sind:
SIZE            Größe des spezifizierten Bytes, ein Fixnum
POSITION        Position des spezifizierten Bytes, ein Fixnum
Siehe ARIDECL.TXT

2.21.11. Load-time-Evals

F=0, L=1, die Daten sind:
FORM            Form, die erst zur Zeit des Ladens evaluiert werden soll

2.21.12. Symbol-Macros

F=0, L=1, die Daten sind:
EXPANSION       Expansion des Symbols, eine Form.


3. Code-Aufbau
--------------

Der Code ist compiliert. Für Fehlermeldungen ist der Name nötig. Da man in C
nicht Daten in unmittelbarer Nähe von Funktionen unterbringen kann, muß man
Name und Funktionsadresse in einer Tabelle aller SUBRs bzw. FSUBRs unter-
bringen. Ein SUBR ist ein Pointer in die SUBR-Tabelle, ein FSUBR ist ein
Pointer in die FSUBR-Tabelle. Um sowohl schnellen FUNCALL als auch
Argumente-überprüfenden APPLY zu ermöglichen, stehen noch weitere
Informationen in der Tabelle (Argumentanzahlen etc.):

FSUBR-Tabellen-Eintrag:
  .L   Adresse der C-Funktion (ohne Argumente, ohne Wert)
  .L   Adresse des Namens des FSUBR (LISP-Objekt)
  .W   Kürzel für den Argumente-Typ des FSUBR
  .W   REQ_ANZ : Anzahl required Parameter
  .W   OPT_ANZ : Anzahl optionaler Parameter
  .W   BODY_FLAG : Body-Flag

SUBR-Tabellen-Eintrag:
  .L   Adresse der C-Funktion (ohne Argumente, ohne Wert)
  .L   Adresse des Namens des SUBR (LISP-Objekt)
  .L   Adresse des Vektors mit den Keywords oder NIL (LISP-Objekt)
  .W   Kürzel für den Argumente-Typ des SUBR
  .W   REQ_ANZ : Anzahl required Parameter
  .W   OPT_ANZ : Anzahl optionaler Parameter
  .B   REST_FLAG : Flag für beliebig viele Argumente
  .B   KEY_FLAG : Flag für Keywords
  .W   KEY_ANZ : Anzahl Keywordparameter

*/

# ######################## LISP-Objekte allgemein ######################### #

#if !defined(WIDE)

# Ein Objektpointer ist erst einmal ein leerer Pointer (damit man in C nichts
# Unbeabsichtigtes mit ihm machen kann):
  #ifdef OBJECT_STRUCT
    typedef struct { uintL one; } object;
  #else
    typedef  void *  object;
  #endif
# Aber in der Repräsentation steckt eine Adresse und Typbits.

# Ein (unsigned) Integer von der Größe eines Objekts:
  typedef  uintL  oint;
  typedef  sintL  soint;

#else # defined(WIDE)

# Ein Objekt besteht aus getrennten 32 Bit Adresse und 32 Bit Typinfo.
  typedef  uint64  oint;
  typedef  sint64  soint;
  #ifdef WIDE_STRUCT
    #if BIG_ENDIAN_P==WIDE_ENDIANNESS
      #define TYPEDEF_OBJECT  \
        typedef  union { struct { /* tint */ uintL type; /* aint */ uintL addr; } both; \
                         oint one _attribute_aligned_object_;                           \
                       }                                                                \
                 object;
    #else
      #define TYPEDEF_OBJECT  \
        typedef  union { struct { /* aint */ uintL addr; /* tint */ uintL type; } both; \
                         oint one _attribute_aligned_object_;                           \
                       }                                                                \
                 object;
    #endif
  #else
    typedef  oint  object;
  #endif

#endif

# Es muß sizeof(object) = sizeof(oint) gelten!

# Umwandlungen zwischen object und oint:
# as_oint(expr)   object --> oint
# as_object(x)    oint --> object
  #if defined(WIDE_STRUCT) || defined(OBJECT_STRUCT)
    #define as_oint(expr)  ((expr).one)
    #if 1
      #define as_object(o)  ((object){one:(o)})
    #else
      extern __inline__ object as_object (register oint o)
        { register object obj; obj.one = o; return obj; }
    #endif
  #else
    #define as_oint(expr)  (oint)(expr)
    #define as_object(o)  (object)(o)
  #endif

# Was von einer Adresse auch wirklich auf den Adreßbus geschickt wird:
#if defined(MC68000)
  #define addressbus_mask  0x00FFFFFFUL  # 68000 wirft 8 Bits weg
#elif defined(SUN3) && !defined(UNIX_SUNOS4)
  #define addressbus_mask  0x0FFFFFFFUL  # SUN3 unter SunOS 3.5 wirft 4 Bits weg
#elif 1
  #define addressbus_mask  ~0UL  # Default: nichts wird weggeworfen
#else
  #error "Unknown address bus mask -- Größe addressbus_mask neu einstellen!"
#endif

# Aufteilung eines oint in Typbits und Adresse:
# Stets ist  oint_type_mask  subset  (2^oint_type_len-1)<<oint_type_shift
# und        oint_addr_mask superset (2^oint_addr_len-1)<<oint_addr_shift .
#if defined(WIDE_HARD)
  #if defined(DECALPHA) && defined(UNIX_OSF)
    #if defined(NO_SINGLEMAP)
      # Wenn MAP_MEMORY nicht gefordert ist, ist das das sicherste.
      # Bits 63..48 = Typcode, Bits 47..0 = Adresse
      #define oint_type_shift 48
      #define oint_type_len 16
      #define oint_type_mask 0xFFFF000000000000UL
      #define oint_addr_shift 0
      #define oint_addr_len 48
      #define oint_addr_mask 0x0000FFFFFFFFFFFFUL
      #define oint_data_shift 0
      #define oint_data_len 32
      #define oint_data_mask 0x00000000FFFFFFFFUL
    #else
      # Gewöhnliche Pointer liegen im Bereich 1*2^32..2*2^32.
      # Bits 63..33 = Typcode, Bits 32..0 = Adresse
      #if 1 # Was ist besser??
        #define oint_type_shift 32
        #define oint_type_len 32
      #else
        #define oint_type_shift 33
        #define oint_type_len 31
      #endif
      #define oint_type_mask 0xFFFFFFFE00000000UL
      #define oint_addr_shift 0
      #define oint_addr_len 33
      #define oint_addr_mask 0x00000001FFFFFFFFUL
      #define oint_data_shift 0
      #define oint_data_len 32
      #define oint_data_mask 0x00000000FFFFFFFFUL
    #endif
  #endif
#elif defined(WIDE_SOFT)
  # Getrennte 32-Bit-Wörter für Typcode und Adresse.
  #if WIDE_ENDIANNESS
    # Bits 63..32 = Typcode, Bits 31..0 = Adresse
    #define oint_type_shift 32
    #define oint_type_len 32
    #define oint_type_mask 0xFFFFFFFF00000000ULL
    #define oint_addr_shift 0
    #define oint_addr_len 32
    #define oint_addr_mask 0x00000000FFFFFFFFULL
  #else # umgekehrt ist es etwas langsamer:
    # Bits 63..32 = Adresse, Bits 31..0 = Typcode
    #define oint_type_shift 0
    #define oint_type_len 32
    #define oint_type_mask 0x00000000FFFFFFFFULL
    #define oint_addr_shift 32
    #define oint_addr_len 32
    #define oint_addr_mask 0xFFFFFFFF00000000ULL
  #endif
#elif (defined(MC680X0) && !defined(AMIGA3000) && !defined(UNIX_AMIX) && !(defined(UNIX_LINUX) && CODE_ADDRESS_RANGE) && !defined(UNIX_NEXTSTEP)) || (defined(I80Z86) && !defined(WATCOM_BLAKE) && !defined(UNIX_SYSV_UHC_2) && !defined(UNIX_SYSV_UHC_1) && !(defined(UNIX_LINUX) && CODE_ADDRESS_RANGE) && !defined(UNIX_NEXTSTEP) && !defined(UNIX_SYSV_PTX) && !defined(WIN32_DOS) && !defined(WIN32_UNIX)) || defined(SPARC) || (defined(MIPS) && !defined(UNIX_IRIX) && !defined(UNIX_DEC_ULTRIX)) || defined(M88000) || (defined(RS6000) && !defined(UNIX_AIX)) || defined(VAX) || (defined(CONVEX) && !defined(UNIX_CONVEX)) || defined(ACORN_1)
  # Bits 31..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xFF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x00FFFFFFUL
#elif defined(ACORN_2)
  # Bits 31..8 = Adresse, Bits 7..0 = Typcode
  #define oint_type_shift 0
  #define oint_type_len 8
  #define oint_type_mask 0x000000FFUL
  #define oint_addr_shift 8
  #define oint_addr_len 24
  #define oint_addr_mask 0xFFFFFF00UL
#elif defined(ACORN_3)
  # Bits 31..26 = Typcode, Bits 25..0 = Adresse
  #define oint_type_shift 26
  #define oint_type_len 6
  #define oint_type_mask 0xFC000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 26
  #define oint_addr_mask 0x03FFFFFFUL
#elif defined(ACORN_4)
  # Bits 31..6 = Adresse, Bits 5..0 = Typcode
  #define oint_type_shift 0
  #define oint_type_len 6
  #define oint_type_mask 0x0000003FUL
  #define oint_addr_shift 6
  #define oint_addr_len 26
  #define oint_addr_mask 0xFFFFFFC0UL
#elif defined(AMIGA3000)
  # Bits 31..6 = Adresse/2, Bits 5..0 = Typcode
  #define oint_type_shift 0
  #define oint_type_len 6
  #define oint_type_mask 0x0000003FUL
  #define oint_addr_shift 6
  #define oint_addr_len 26
  #define oint_addr_mask 0xFFFFFFC0UL
  #define addr_shift 1
#elif defined(UNIX_SYSV_UHC_2)
  # Bits 31..6 = Adresse/4, Bits 5..0 = Typcode
  #define oint_type_shift 0
  #define oint_type_len 6
  #define oint_type_mask 0x0000003FUL
  #define oint_addr_shift 6
  #define oint_addr_len 26
  #define oint_addr_mask 0xFFFFFFC0UL
  #define addr_shift 2  # funktioniert nicht wegen STACK_alignment ??
#elif (defined(HPPA) && defined(UNIX_HPUX)) || (defined(MC680X0) && defined(UNIX_AMIX))
  # Bits 29..24 = Typcode, Bits 31..30,23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 6
  #define oint_type_mask 0x3F000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24 # vernünftig nutzbar sind nur die unteren 24 Bit
  #define oint_addr_mask 0xC0FFFFFFUL
  # Beachte: unten wird aint = uint24 = uint32 sein.
#elif defined(UNIX_SYSV_UHC_1)
  # Bits 31..28,26..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xF7000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x08FFFFFFUL
#elif defined(UNIX_LINUX) && (CODE_ADDRESS_RANGE != 0) # Linux with ELF binary format
  # Bits 31..28,26..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xF7000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x08FFFFFFUL
  # Shared libraries are mapped in at 0x50000000 or 0x40000000, via mmap().
  #define vm_addr_mask 0xBFFFFFFFUL
#elif defined(MIPS) && (defined(UNIX_IRIX) || defined(UNIX_DEC_ULTRIX))
  # Bits 31..29,27..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xEF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x10FFFFFFUL
#elif defined(RS6000) && defined(UNIX_AIX)
  # Bits 31..30,28..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xDF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x20FFFFFFUL
#elif defined(WATCOM_BLAKE)
  # Bits 30..25 = Typcode, Bits 31,24..0 = Adresse
  #define oint_type_shift 25
  #define oint_type_len 6
  #define oint_type_mask 0x7E000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 25
  #define oint_addr_mask 0x81FFFFFFUL
#elif defined(WIN32_DOS) || defined(WIN32_UNIX)
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xDF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x20FFFFFFUL
#elif defined(UNIX_NEXTSTEP)
  # Bits 31..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xFF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x00FFFFFFUL
  # UNIX_NEXTSTEP has shared libraries at 0x05000000, related storage at
  # 0x04000000, a stack from 0x03F80000..0x04000000. We avoid this address
  # range of VM addresses by not using bits 26 and 24 in our typecode
  # bit encoding scheme.
  #define vm_addr_mask 0xFAFFFFFFUL
#elif defined(UNIX_SYSV_PTX)
  # Bits 31..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xFF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x00FFFFFFUL
  # UNIX_SYSV_PTX has its stack above (or below??) 0x40000000. We avoid this
  # address range of VM addresses by not using bit 30 in our typecode bit
  # encoding scheme.
  #define vm_addr_mask 0xBFFFFFFFUL
#elif defined(UNIX_NETBSD) # experimentell??
  # Bits 31..24 = Typcode, Bits 23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0xFF000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x00FFFFFFUL
  # NetBSD 1.0 has its shared libraries above 0x10000000. We avoid this
  # address range of VM addresses by not using bit 28 in our typecode bit
  # encoding scheme.
  #define vm_addr_mask 0xEFFFFFFFUL
#elif defined(CONVEX) && defined(UNIX_CONVEX)
  # Bits 30..24 = Typcode, Bits 31,23..0 = Adresse
  #define oint_type_shift 24
  #define oint_type_len 8
  #define oint_type_mask 0x7F000000UL
  #define oint_addr_shift 0
  #define oint_addr_len 24
  #define oint_addr_mask 0x80FFFFFFUL
  # UNIX_CONVEX user space addresses are in the range 0x80000000..0xFFFFFFFF.
  # Memory mapping works in the range 0x80000000..0xBFFFFFFFUL.
  #define vm_addr_mask 0xBFFFFFFFUL
#else
  #error "How to split a pointer into type and address? -- Größen oint_type_shift, oint_addr_shift neu einstellen!"
#endif

# Meist nutzen wir den ganzen Platz einer Adresse für die Daten von Fixnums etc.
# Stets ist  [oint_data_shift..oint_data_shift+oint_data_len-1] subset
#            [oint_addr_shift..oint_addr_shift+oint_addr_len-1],
# also       oint_data_len <= oint_addr_len,
# aber auch  oint_data_len <= intLsize = 32 .
#ifndef oint_data_len
  #define oint_data_shift oint_addr_shift
  #define oint_data_len oint_addr_len
  #define oint_data_mask oint_addr_mask
#endif

# Integertyp für Typbits:
  #ifdef ANSI
    typedef unsigned_int_with_n_bits(oint_type_len)  tint;
  #else
    typedef uint/**/oint_type_len  tint;
  #endif

# Integertyp für Adressen:
  #ifdef ANSI
    typedef unsigned_int_with_n_bits(oint_addr_len)  aint;
    typedef signed_int_with_n_bits(oint_addr_len)  saint;
  #else
    typedef uint/**/oint_addr_len  aint;
    typedef sint/**/oint_addr_len  saint;
  #endif

# Anzahl der Bits, um die eine Adresse zuletzt noch geshiftet wird:
  #ifndef addr_shift
    #define addr_shift 0
  #endif

# Maske der Bits eines tint, die wirklich zum Typ gehören:
# tint_type_mask = oint_type_mask >> oint_type_shift
# (eine Constant Expression, in der keine 'long long's vorkommen!)
  #ifdef WIDE_SOFT
    #define tint_type_mask  (bitm(oint_type_len)-1)
  #else
    #define tint_type_mask  (oint_type_mask >> oint_type_shift)
  #endif

# Um zu einem object/oint etwas zu addieren:
# objectplus(obj,offset)
  #if !(defined(WIDE_SOFT) || defined(OBJECT_STRUCT))
    #define objectplus(obj,offset)  ((object)pointerplus(obj,offset))
  #else # defined(WIDE_SOFT) || defined(OBJECT_STRUCT)
    #define objectplus(obj,offset)  as_object(as_oint(obj)+(soint)(offset))
  #endif

# Bitoperationen auf Größen vom Typ oint:
# ...wbit... statt ...bit..., "w" = "wide".
  #if !defined(WIDE_SOFT)
    #define wbit  bit
    #define wbitm  bitm
    #define wbit_test  bit_test
    #define minus_wbit  minus_bit
  #else
    #define wbit(n)  (1LL<<(n))
    #define wbitm(n)  (2LL<<((n)-1))
    #define wbit_test(x,n)  ((x) & wbit(n))
    #define minus_wbit(n)  (-1LL<<(n))
  #endif

# Typinfo:
# typecode(object) und mtypecode(object) liefern den Typcode eines
# Objektes obj. Bei mtypecode muß er dazu im Speicher liegen.
  #if !(exact_uint_size_p(oint_type_len) && (tint_type_mask == bit(oint_type_len)-1))
    #define typecode(expr)  \
      ((tint)(as_oint(expr) >> oint_type_shift) & (oint_type_mask >> oint_type_shift))
    #define mtypecode(expr)  typecode(expr)
  #else
    # Der Typ 'tint' hat genau oint_type_len Bits, und tint_type_mask = 2^oint_type_len-1.
    # Also kann man sich das ANDen sparen.
    # Allerdings ist auf einem 68000 ein ROL.L #8 schneller, auf einer SPARC ein Shift.
      #define typecode(expr)  \
        ((tint)(as_oint(expr) >> oint_type_shift))
      #if defined(MC68000) && defined(GNU) && !defined(NO_ASM) && (oint_type_shift==24) && (oint_type_len==8)
        # GNU C auf einem 68000, ersetze LSR.L #24 durch ROL.L #8 :
        #undef typecode
        #define typecode(expr)  \
          ({var tint __typecode;                                               \
            __asm__ ("roll #8,%0" : "=d" (__typecode) : "0" (as_oint(expr)) ); \
            __typecode;                                                        \
           })
      #elif defined(SPARC) && !defined(WIDE)
        #undef typecode
        #define typecode(expr)  \
          ((as_oint(expr) << (32-oint_type_len-oint_type_shift)) >> (32-oint_type_len))
      #elif defined(WIDE) && defined(WIDE_STRUCT)
        #undef typecode
        #define typecode(expr)  ((expr).both.type)
      #endif
    # Außerdem kann man Zugriffe im Speicher auch ohne Shift machen:
      #if !defined(WIDE) && (((oint_type_shift==24) && BIG_ENDIAN_P) || ((oint_type_shift==0) && !BIG_ENDIAN_P))
        #define mtypecode(expr)  (*(tint*)&(expr))
        #define fast_mtypecode
      #elif !defined(WIDE) && (((oint_type_shift==24) && !BIG_ENDIAN_P) || ((oint_type_shift==0) && BIG_ENDIAN_P))
        #define mtypecode(expr)  (*((tint*)&(expr)+3))
        #define fast_mtypecode
      #elif defined(WIDE)
        #ifdef WIDE_STRUCT
          #define mtypecode(expr)  ((expr).both.type)
        #elif (oint_type_len==16)
          #if (oint_type_shift==0) == BIG_ENDIAN_P
            #define mtypecode(expr)  (*((tint*)&(expr)+3))
          #else # (oint_type_shift==48) == BIG_ENDIAN_P
            #define mtypecode(expr)  (*(tint*)&(expr))
          #endif
        #elif (oint_type_len==32)
          #if (oint_type_shift==0) == BIG_ENDIAN_P
            #define mtypecode(expr)  (*((tint*)&(expr)+1))
          #else # (oint_type_shift==32) == BIG_ENDIAN_P
            #define mtypecode(expr)  (*(tint*)&(expr))
          #endif
        #endif
        #define fast_mtypecode
      #else # keine Optimierung möglich
        #define mtypecode(expr)  typecode(expr)
      #endif
  #endif

# Extraktion des Adreßfelds ohne Typinfo:
# untype(obj)
  #if defined(WIDE) && defined(WIDE_STRUCT)
    #define untype(expr)  ((expr).both.addr)
  #elif !(defined(SPARC) && (oint_addr_len+oint_addr_shift<32))
    #define untype(expr)    \
      ((aint)(as_oint(expr) >> oint_addr_shift) & (aint)(oint_addr_mask >> oint_addr_shift))
  #else
    # Auf einem SPARC-Prozessor sind lange Konstanten langsamer als Shifts:
    # Evtl. kann man sich ein ANDen sparen.
    #define untype(expr)  \
      ((aint)((as_oint(expr) << (32-oint_addr_len-oint_addr_shift)) >> (32-oint_addr_len)))
  #endif

# Objekt aus Typinfo und Adreßfeld:
# type_untype_object(type,address)
  #if defined(WIDE) && defined(WIDE_STRUCT)
    #if BIG_ENDIAN_P==WIDE_ENDIANNESS
      #define type_untype_object(type,address)  ((object){{(tint)(type),(aint)(address)}})
    #else
      #define type_untype_object(type,address)  ((object){{(aint)(address),(tint)(type)}})
    #endif
  #elif !(oint_addr_shift==0)
    #define type_untype_object(type,address)  \
      (as_object(  ((oint)(tint)(type) << oint_type_shift) + \
                   ((oint)(aint)(address) << oint_addr_shift) ))
  #else # bei oint_addr_shift=0 braucht man nicht zu schieben:
    #if defined(WIDE_SOFT)
      # Vorsicht: Konversion von address zum oint durch Zero-Extend!
      #define type_untype_object(type,address)              \
        objectplus((oint)(aint)(address),(oint)(tint)(type)<<oint_type_shift)
    #elif defined(OBJECT_STRUCT)
      #define type_untype_object(type,address)              \
        as_object((oint)pointerplus((address),(oint)(tint)(type)<<oint_type_shift))
    #else # Normalfall
      # Damit das für gcc-2.5.8 ein gültiger Initialisierer ist (NIL_IS_CONSTANT),
      # darf man nicht vom Pointer zum oint und dann wieder zum Pointer casten,
      # sondern muß im Bereich der Pointer bleiben.
      #define type_untype_object(type,address)              \
        as_object(pointerplus((address),(oint)(tint)(type)<<oint_type_shift))
    #endif
  #endif

# Objekt aus Typinfo und direkten Daten (als "Adresse"):
# type_data_object(type,data)
  #if defined(WIDE) && defined(WIDE_STRUCT)
    #if BIG_ENDIAN_P==WIDE_ENDIANNESS
      #define type_data_object(type,data)  ((object){{(tint)(type),(aint)(data)}})
    #else
      #define type_data_object(type,data)  ((object){{(aint)(data),(tint)(type)}})
    #endif
  #elif !(oint_addr_shift==0)
    #define type_data_object(type,data)  \
      (as_object(  ((oint)(tint)(type) << oint_type_shift) + \
                   ((oint)(aint)(data) << oint_addr_shift) ))
  #else # bei oint_addr_shift=0 braucht man nicht zu schieben:
    #define type_data_object(type,data)  \
      (as_object( ((oint)(tint)(type) << oint_type_shift) + (oint)(aint)(data) ))
  #endif

# Extraktion der Adresse ohne Typinfo:
# upointer(obj)
# (upointer steht für "untyped pointer".)
  #if (addr_shift==0)
    #define upointer  untype
  #else
    #define optimized_upointer(obj)  \
      ((aint)((as_oint(obj) << (32-oint_addr_len-oint_addr_shift)) >> (32-oint_addr_len-addr_shift)))
    #define upointer(obj)  (untype(obj)<<addr_shift)
  #endif

# Objekt aus Typinfo und Adresse:
# type_pointer_object(type,address)
  #if (addr_shift==0)
    # (Kein Cast auf aint, damit NIL als Initializer zu gebrauchen ist.)
    #define type_pointer_object(type,address)  \
      type_untype_object(type,address)
  #elif defined(WIDE_SOFT) && !defined(WIDE_STRUCT)
    #define type_pointer_object(type,address)  \
      type_untype_object(type,(aint)(address)>>addr_shift)
  #else # effizienter,
    # setzt aber voraus, daß address durch 2^addr_shift teilbar ist:
    #define type_pointer_object(type,address)  \
      (as_object(  ((oint)(tint)(type) << oint_type_shift) + \
                   ((oint)(aint)(address) << (oint_addr_shift-addr_shift)) ))
  #endif

# Objekt aus konstanter Typinfo und konstanter Adresse:
# type_constpointer_object(type,address)
  #define type_constpointer_object(type,address)  type_pointer_object(type,address)

# oint aus konstanter Typinfo und Adresse = 0:
# type_zero_oint(type)
  #if defined(WIDE_SOFT) && defined(WIDE_STRUCT)
    #define type_zero_oint(type)  as_oint(type_untype_object(type,0))
  #else
    #define type_zero_oint(type)  ((oint)(tint)(type) << oint_type_shift)
  #endif


#if (oint_type_len >= 8) && (oint_addr_shift == 0) && (addr_shift == 0) && !defined(WIDE_SOFT) && !(defined(SUN3) && !defined(UNIX_SUNOS4) && !defined(WIDE_SOFT))
# Falls tint_type_mask mindestens 8 Bit umfaßt und nicht WIDE_SOFT,
# ist evtl. Memory-Mapping möglich.

  #if (defined(HAVE_MMAP_ANON) || defined(HAVE_MMAP_DEVZERO) || defined(HAVE_MACH_VM)) && !(defined(MULTIMAP_MEMORY) || defined(IMMUTABLE)) && !defined(NO_SINGLEMAP)
    # Zugriff auf Lisp-Objekte wird vereinfacht dadurch, daß jedes Lisp-Objekt
    # an eine Adresse gelegt wird, das seine Typinformation bereits enthält.
      #define SINGLEMAP_MEMORY
  #endif

  #if defined(UNIX_SUNOS4) && (oint_addr_shift==0) && !defined(MULTIMAP_MEMORY) && !defined(SINGLEMAP_MEMORY) && !defined(NO_MULTIMAP_FILE)
    # Zugriff auf Lisp-Objekte geschieht mittels Memory-Mapping: Jede Speicher-
    # seite ist unter mehreren Adressen zugreifbar.
      #define MULTIMAP_MEMORY
      #define MULTIMAP_MEMORY_VIA_FILE
  #endif

  #if defined(HAVE_SHM) && (oint_addr_shift==0) && !defined(MULTIMAP_MEMORY) && !defined(SINGLEMAP_MEMORY) && !defined(NO_MULTIMAP_SHM)
    # Zugriff auf Lisp-Objekte geschieht mittels Memory-Mapping: Jede Speicher-
    # seite ist unter mehreren Adressen zugreifbar.
      #define MULTIMAP_MEMORY
      #define MULTIMAP_MEMORY_VIA_SHM
  #endif

  #if defined(UNIX_LINUX) && (oint_addr_shift==0) && !defined(MULTIMAP_MEMORY) && !defined(SINGLEMAP_MEMORY) && !defined(NO_MULTIMAP_FILE)
    # Zugriff auf Lisp-Objekte geschieht mittels Memory-Mapping: Jede Speicher-
    # seite ist unter mehreren Adressen zugreifbar.
      #define MULTIMAP_MEMORY
      #define MULTIMAP_MEMORY_VIA_FILE
  #endif

  #ifdef IMMUTABLE
    #ifdef SUN4_29
      #error "Immutable objects don't work on this SUN4 architecture!"
    #endif
    #ifndef MULTIMAP_MEMORY
      #error "Immutable objects require working shared memory!"
    #endif
    # Welche Typen immutabler Objekte gibt es?
    #define IMMUTABLE_CONS   # Conses
    #define IMMUTABLE_ARRAY  # alle Arten Arrays
  #endif

  #if defined(MULTIMAP_MEMORY) || defined(SINGLEMAP_MEMORY)
    #define MAP_MEMORY
  #endif

#endif

#if (defined(HAVE_MMAP_ANON) || defined(HAVE_MMAP_DEVZERO) || defined(HAVE_MACH_VM)) && !defined(MAP_MEMORY) && !defined(NO_TRIVIALMAP)
  # mmap() erlaubt eine flexiblere Art der Speicherverwaltung als malloc().
  # Es ist kein wirkliches Memory-Mapping, sondern nur eine bequemere Art,
  # zwei große Speicherblöcke zu verwalten.
  #define TRIVIALMAP_MEMORY
#endif


# Art der Garbage Collection: normal oder generational.
#if defined(VIRTUAL_MEMORY) && (defined(SINGLEMAP_MEMORY) || defined(TRIVIALMAP_MEMORY)) && defined(HAVE_WORKING_MPROTECT) && defined(CAN_HANDLE_WP_FAULT) && (SAFETY < 3) && !defined(NO_GENERATIONAL_GC)
  # Für "generational garbage collection" sind einige Voraussetzungen nötig.
  # Unter Linux geht es erst ab Linux 1.1.52, das wird in makemake überprüft.
  #define GENERATIONAL_GC
#endif


#ifdef MULTIMAP_MEMORY
  #if defined(IMMUTABLE) && defined(GENERATIONAL_GC) # && !defined(UNIX_LINUX)
    # Es belastet das Betriebssystem weniger, wenn wir den Speicher nur
    # 2x mappen: 1x bei 0x00 read-write, 1x bei 0x40 read-only.
    #define MINIMAL_MULTIMAP_MEMORY
  #endif
  #ifndef MINIMAL_MULTIMAP_MEMORY
    # Normalerweise hat man ca. 42 read-write und bei IMMUTABLE 8 read-only
    # Mappings.
    #define NORMAL_MULTIMAP_MEMORY
  #endif
#endif

#ifdef MAP_MEMORY
  #ifdef MINIMAL_MULTIMAP_MEMORY
    # Durchs Memory-Mapping ist jetzt das Immutable-Bit einer Adresse redundant.
    #define immutable_bit_t  6
    #define immutable_bit_o  30
    #undef addressbus_mask
    #define addressbus_mask  ~(1UL<<immutable_bit_o)
  #else
    #if defined(SUN4_29)
      # Durchs Memory-Mapping sind jetzt die Bits 28..24 einer Adresse redundant.
      #undef addressbus_mask
      #define addressbus_mask  0xE0FFFFFFUL
    #elif defined(DECALPHA) && defined(UNIX_OSF)
      # Durchs Memory-Mapping sind jetzt die Bits 37..33 einer Adresse redundant.
      #undef addressbus_mask
      #define addressbus_mask  0xFFFFFFC1FFFFFFFFUL
    #else
      # Durchs Memory-Mapping sind jetzt die Bits 31..24 einer Adresse redundant.
      #undef addressbus_mask
      #define addressbus_mask  oint_addr_mask  # meist = 0x00FFFFFFUL
    #endif
  #endif
  # Aber evtl. sind einige Typbit-Kombinationen nicht erlaubt.
  #ifdef vm_addr_mask
    #define tint_allowed_type_mask  ((oint_type_mask & vm_addr_mask) >> oint_type_shift)
  #endif
#endif


# Der Typ `object' liegt nun vollständig fest.
#ifdef WIDE_STRUCT
  #ifdef GENERATIONAL_GC
    # Die Generational GC kann es nicht brauchen, daß ein einzelner
    # Objektpointer sich auf zwei Seiten erstreckt.
    # Erzwinge daher  alignof(object) = sizeof(object).
    #define _attribute_aligned_object_  __attribute__ ((aligned(8)))
  #else
    #define _attribute_aligned_object_
  #endif
  TYPEDEF_OBJECT
#endif


# Objekte variabler Länge müssen an durch 2 (o.ä.) teilbaren Adressen liegen:
#if defined(VAX) # ?? gcc/config/vax/vax.h sagt: Alignment = 4
  #define varobject_alignment  1
#endif
#if defined(MC680X0)
  #if !(addr_shift==0)
    #define varobject_alignment  bit(addr_shift)  # wegen der gedrängten Typcodeverteilung
  #else
    #define varobject_alignment  2
  #endif
#endif
#if defined(I80Z86) || defined(RS6000) || defined(CONVEX) || defined(ARM)
  #define varobject_alignment  4
#endif
#if defined(SPARC) || defined(HPPA) || defined(MIPS) || defined(M88000) || defined(DECALPHA)
  #define varobject_alignment  8
#endif
#if defined(GENERATIONAL_GC) && (varobject_alignment < 4)
  #undef varobject_alignment
  #define varobject_alignment  4
#endif
#if defined(GENERATIONAL_GC) && defined(WIDE) && (varobject_alignment < 8)
  #undef varobject_alignment
  #define varobject_alignment  8
#endif
# varobject_alignment sollte definiert sein:
#ifndef varobject_alignment
  #error "varobject_alignment depends on CPU -- varobject_alignment neu einstellen!!"
#endif
# varobject_alignment sollte eine Zweierpotenz sein:
#if !((varobject_alignment & (varobject_alignment-1)) ==0)
  #error "Bogus varobject_alignment -- varobject_alignment neu einstellen!!"
#endif
# varobject_alignment sollte ein Vielfaches von 2^addr_shift sein:
#if (varobject_alignment % bit(addr_shift))
  #error "Bogus varobject_alignment -- varobject_alignment neu einstellen!!"
#endif


# Es folgt die Festlegung der einzelnen Typbits und Typcodes.

# Feststellen, ob ein Typ bei GC keine Veränderung erfährt
# (z.B. weil er keinen Pointer darstellt):
  #if 0 && defined(GNU)
    #define immediate_type_p(type)  \
      ({var reg1 boolean _erg;                 \
        switch (type)                          \
          { case_machine:                      \
            case_char: case_subr: case_system: \
            case_fixnum: case_sfloat:          \
            /* bei WIDE auch: case_ffloat: */  \
              _erg = TRUE; break;              \
            default: _erg = FALSE; break;      \
          }                                    \
        _erg;                                  \
       })
  #endif

#ifndef tint_allowed_type_mask
  #define tint_allowed_type_mask  tint_type_mask
#endif

# Wir haben 6 bis 8 Typbits zur Verfügung: TB7, [TB6,] [TB5,] TB4, ..., TB0.
# Alle müssen in tint_allowed_type_mask und damit auch in tint_type_mask
# gesetzt sein. Wir verteilen sie unter der Annahme, daß in tint_type_mask
# höchstens ein Bit fehlt. TB6 und TB5 werden, falls nicht benutzbar,
# auf -1 gesetzt.
#if ((0xFF & ~tint_allowed_type_mask) == 0)
  #define TB7 7
  #define TB6 6
  #define TB5 5
  #define TB4 4
  #define TB3 3
  #define TB2 2
  #define TB1 1
  #define TB0 0
#elif (oint_type_len==6)
  #define TB7 5
  #define TB6 -1
  #define TB5 -1
  #define TB4 4
  #define TB3 3
  #define TB2 2
  #define TB1 1
  #define TB0 0
#elif (oint_type_len>=8) && !((0xFF & ~tint_allowed_type_mask) == 0)
  # Manchem Bit müssen wir aus dem Weg gehen:
  #define tint_avoid  (0xFF & ~tint_allowed_type_mask)
  #if ((tint_avoid & (tint_avoid-1)) == 0)
    # tint_avoid besteht aus genau einem Bit, das es zu vermeiden gilt.
    #if (tint_avoid > bit(0))
      #define TB0 0
    #else
      #define TB0 1
    #endif
    #if (tint_avoid > bit(1))
      #define TB1 1
    #else
      #define TB1 2
    #endif
    #if (tint_avoid > bit(2))
      #define TB2 2
    #else
      #define TB2 3
    #endif
    #if (tint_avoid > bit(3))
      #define TB3 3
    #else
      #define TB3 4
    #endif
    #if (tint_avoid > bit(4))
      #define TB4 4
    #else
      #define TB4 5
    #endif
    #if (tint_avoid > bit(5))
      #define TB5 5
    #else
      #define TB5 6
    #endif
    #define TB6 -1
    #if (tint_avoid > bit(6))
      #define TB7 6
    #else
      #define TB7 7
    #endif
  #else
    # tint_avoid darf höchstens zwei Bits enthalten:
    #if ((tint_avoid & (tint_avoid-1)) & ((tint_avoid & (tint_avoid-1)) - 1))
      #error "Bogus oint_type_mask -- oint_type_mask neu einstellen!"
    #endif
    # Das eine verbotene Bit können wir immer noch als GC-Bit nutzen,
    # vorausgesetzt, es ist in tint_type_mask enthalten:
    #define tint_maybegc_type_mask  (0xFF & tint_type_mask & ~tint_allowed_type_mask)
    #if (tint_maybegc_type_mask==0)
      #error "Bogus oint_type_mask, vm_addr_mask -- oint_type_mask, vm_addr_mask neu einstellen!"
    #endif
    # Davon nehmen wir das kleinere Bit als GC-Bit:
    #define tint_avoid1  (tint_maybegc_type_mask & -tint_maybegc_type_mask)
    #if (tint_avoid1 == bit(0))
      #define TB7 0
    #elif (tint_avoid1 == bit(1))
      #define TB7 1
    #elif (tint_avoid1 == bit(2))
      #define TB7 2
    #elif (tint_avoid1 == bit(3))
      #define TB7 3
    #elif (tint_avoid1 == bit(4))
      #define TB7 4
    #elif (tint_avoid1 == bit(5))
      #define TB7 5
    #elif (tint_avoid1 == bit(6))
      #define TB7 6
    #elif (tint_avoid1 == bit(7))
      #define TB7 7
    #else
      #error "Bogus tint_avoid1!"
    #endif
    #define TB6 -1
    # Und das größere Bit gilt es noch zu vermeiden:
    #define tint_avoid2  (tint_avoid & ~tint_avoid1)
    #if (TB7 > 0) && (tint_avoid2 > bit(0))
      #define TB0 0
    #elif (TB7 > 1) || (tint_avoid2 > bit(1))
      #define TB0 1
    #else
      #define TB0 2
    #endif
    #if (TB7 > 1) && (tint_avoid2 > bit(1))
      #define TB1 1
    #elif (TB7 > 2) || (tint_avoid2 > bit(2))
      #define TB1 2
    #else
      #define TB1 3
    #endif
    #if (TB7 > 2) && (tint_avoid2 > bit(2))
      #define TB2 2
    #elif (TB7 > 3) || (tint_avoid2 > bit(3))
      #define TB2 3
    #else
      #define TB2 4
    #endif
    #if (TB7 > 3) && (tint_avoid2 > bit(3))
      #define TB3 3
    #elif (TB7 > 4) || (tint_avoid2 > bit(4))
      #define TB3 4
    #else
      #define TB3 5
    #endif
    #if (TB7 > 4) && (tint_avoid2 > bit(4))
      #define TB4 4
    #elif (TB7 > 5) || (tint_avoid2 > bit(5))
      #define TB4 5
    #else
      #define TB4 6
    #endif
    #if (TB7 > 5) && (tint_avoid2 > bit(5))
      #define TB5 5
    #elif (TB7 > 6) || (tint_avoid2 > bit(6))
      #define TB5 6
    #else
      #define TB5 7
    #endif
  #endif
#else
  #error "Bogus TB7..TB0 -- TB7..TB0 neu einstellen!"
#endif

#if (TB7==7)&&(TB6==6)&&(TB5==5)&&(TB4==4)&&(TB3==3)&&(TB2==2)&&(TB1==1)&&(TB0==0)
  #if defined(SUN3) && !defined(UNIX_SUNOS4) && !defined(WIDE_SOFT)
    #define SUN3_TYPECODES
  #elif defined(SUN4_29) && defined(MAP_MEMORY)
    #define PACKED_TYPECODES
  #elif defined(DECALPHA) && defined(UNIX_OSF) && defined(MAP_MEMORY)
    #define PACKED_TYPECODES
  #elif defined(MINIMAL_MULTIMAP_MEMORY)
    #define PACKED_TYPECODES
  #else
    #define STANDARD_TYPECODES
  #endif
#endif
#if (oint_type_len>=8) && (TB6==-1)
  #if defined(DECALPHA) && defined(UNIX_OSF) && defined(MAP_MEMORY)
    #define PACKED_TYPECODES
  #else
    #define SEVENBIT_TYPECODES
  #endif
#endif
#if (oint_type_len==6)
  #define SIXBIT_TYPECODES
#endif

#if (defined(IMMUTABLE_CONS) || defined(IMMUTABLE_ARRAY)) && !(defined(STANDARD_TYPECODES) || defined(PACKED_TYPECODES))
  # Currently only STANDARD_TYPECODES and PACKED_TYPECODES have support for
  # immutable objects.
  #error "Not enough type bits to support IMMUTABLE !"
#endif

#ifdef STANDARD_TYPECODES

#if defined(UNIX_LINUX) && (CODE_ADDRESS_RANGE == 0)
  # Zugriffe sind nur auf Pointer >=0, <0x60000000 erlaubt.
  # Deswegen brauchen wir die Typcode-Verteilung aber nicht zu ändern.
#endif

# Typbits:
# in Typcodes (tint):
  #define garcol_bit_t     7  # gesetzt nur während der Garbage Collection!
  #define cons_bit_t       6  # gesetzt nur bei CONS
  #define symbol_bit_t     5  # gesetzt nur bei SYMBOL
  #define number_bit_t     4  # gesetzt nur bei Zahlen
  #define notsimple_bit_t  2  # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_t       0  # Vorzeichen bei reellen Zahlen (gesetzt <==> Zahl <0)
  #define float_bit_t      1
  #define float1_bit_t     3
  #define float2_bit_t     2
  #define ratio_bit_t      3
  #define bignum_bit_t     2
# in Objekten (oint):
  #define garcol_bit_o     (garcol_bit_t+oint_type_shift)    # gesetzt nur während der Garbage Collection!
  #define cons_bit_o       (cons_bit_t+oint_type_shift)      # gesetzt nur bei CONS
  #define symbol_bit_o     (symbol_bit_t+oint_type_shift)    # gesetzt nur bei SYMBOL
  #define number_bit_o     (number_bit_t+oint_type_shift)    # gesetzt nur bei Zahlen
  #define notsimple_bit_o  (notsimple_bit_t+oint_type_shift) # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_o       (sign_bit_t+oint_type_shift)      # Vorzeichen bei reellen Zahlen
  #define float_bit_o      (float_bit_t+oint_type_shift)
  #define float1_bit_o     (float1_bit_t+oint_type_shift)
  #define float2_bit_o     (float2_bit_t+oint_type_shift)
  #define ratio_bit_o      (ratio_bit_t+oint_type_shift)
  #define bignum_bit_o     (bignum_bit_t+oint_type_shift)

# konstante Typcodes:
  #define machine_type   0x00  # %00000000  ; Maschinenpointer
  #define sbvector_type  0x01  # %00000001  ; Simple-Bit-Vector
  #define sstring_type   0x02  # %00000010  ; Simple-String
  #define svector_type   0x03  # %00000011  ; Simple-Vector
  #define array_type     0x04  # %00000100  ; sonstiger Array (Rang /=1 oder
                               #            ; - später vielleicht - anderer Elementtyp)
  #define bvector_type   0x05  # %00000101  ; sonstiger Bit-Vector oder Byte-Vector
  #define string_type    0x06  # %00000110  ; sonstiger String
  #define vector_type    0x07  # %00000111  ; sonstiger (VECTOR T)
  #define closure_type   0x08  # %00001000  ; Closure
  #define structure_type 0x09  # %00001001  ; Structure
  #define stream_type    0x0A  # %00001010  ; Stream
  #define orecord_type   0x0B  # %00001011  ; OtherRecord (Package, Byte, ...)
  #define instance_type  0x0C  # %00001100  ; CLOS-Instanz
  #define char_type      0x0D  # %00001101  ; Character
  #define subr_type      0x0E  # %00001110  ; SUBR
  #define system_type    0x0F  # %00001111  ; Frame-Pointer, Read-Label, SYSTEM
  #define fixnum_type    0x10  # %00010000  ; Fixnum
  #define sfloat_type    0x12  # %00010010  ; Short-Float
  #define bignum_type    0x14  # %00010100  ; Bignum
  #define ffloat_type    0x16  # %00010110  ; Single-Float
  #define ratio_type     0x18  # %00011000  ; Ratio
  #define dfloat_type    0x1A  # %00011010  ; Double-float
  #define complex_type   0x1C  # %00011100  ; Complex
  #define lfloat_type    0x1E  # %00011110  ; Long-Float
  #ifndef IMMUTABLE_ARRAY
  #define symbol_type    0x20  # %00100000  ; Symbol
          # Bits für Symbole in VAR/FUN-Frames (im LISP-Stack):
          #define active_bit  1  # gesetzt: Bindung ist aktiv
          #define dynam_bit   2  # gesetzt: Bindung ist dynamisch
          #define svar_bit    3  # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen
          #define oint_symbolflags_shift  oint_type_shift
          # Bits für Symbole im Selbstpointer:
          #define constant_bit_t  1  # zeigt an, ob das Symbol eine Konstante ist
          #define special_bit_t   2  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
          #define keyword_bit_t   3  # zeigt an, ob das Symbol ein Keyword ist
  #else
  #define imm_array_mask     0x20  # Maske, die immutable von normalen Arrays unterscheidet
  #define imm_sbvector_type  0x21  # %00100001  ; immutabler Simple-Bit-Vector
  #define imm_sstring_type   0x22  # %00100010  ; immutabler Simple-String
  #define imm_svector_type   0x23  # %00100011  ; immutabler Simple-Vector
  #define imm_array_type     0x24  # %00100100  ; immutabler sonstiger Array (Rang /=1 oder
                                   #            ; - später vielleicht - anderer Elementtyp)
  #define imm_bvector_type   0x25  # %00100101  ; immutabler sonstiger Bit-Vector oder Byte-Vector
  #define imm_string_type    0x26  # %00100110  ; immutabler sonstiger String
  #define imm_vector_type    0x27  # %00100111  ; immutabler sonstiger (VECTOR T)
  #define symbol_type    0x28  # %00101000  ; Symbol
          # Bits für Symbole in VAR/FUN-Frames (im LISP-Stack):
          #define active_bit  0  # gesetzt: Bindung ist aktiv
          #define dynam_bit   1  # gesetzt: Bindung ist dynamisch
          #define svar_bit    2  # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen
          #define oint_symbolflags_shift  oint_type_shift
          # Bits für Symbole im Selbstpointer:
          #define constant_bit_t  0  # zeigt an, ob das Symbol eine Konstante ist
          #define special_bit_t   1  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
          #define keyword_bit_t   2  # zeigt an, ob das Symbol ein Keyword ist
  #undef symbol_bit_t
  #undef symbol_bit_o
  #endif
  #define cons_type      0x40  # %01000000  ; Cons
  #ifdef IMMUTABLE_CONS
  #define imm_cons_type  0x41  # %01000001  ; immutable Cons
  #endif

#ifndef WIDE
  # Typ ist GC-invariant, wenn
  # Typinfobyte=0 oder char_type <= Typinfobyte < bignum_type.
    #define immediate_type_p(type)  \
      ((type==0) || ((char_type<=type) && (type<bignum_type)))
#else
  # Typ ist GC-invariant, wenn
  # Typinfobyte eines von 0x00,0x0D..0x13,0x16..0x17 ist.
    #define immediate_type_p(type)  \
      ((type<0x18) && ((bit(type) & 0xFF301FFEUL) == 0))
#endif

#endif # STANDARD_TYPECODES

#ifdef PACKED_TYPECODES

#ifdef SUN4_29
# Zugriffe sind nur auf Pointer >=0, <2^29 erlaubt.
# Daher eine etwas gedrängte Typcode-Verteilung.
#endif

#if defined(DECALPHA) && defined(UNIX_OSF) && !(defined(NO_SINGLEMAP) || defined(NO_TRIVIALMAP))
# mmap() geht nur mit Adressen >=0, <2^38, aber da gewöhnliche Pointer im
# Bereich 1*2^32..2*2^32 liegen, bleiben uns nur die Bits 37..33 als Typbits.
#endif

# Typbits:
# in Typcodes (tint):
  #define garcol_bit_t     TB7  # gesetzt nur während der Garbage Collection!
  #define number_bit_t     TB4  # gesetzt nur bei Zahlen
  #define notsimple_bit_t  TB2  # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_t       TB0  # Vorzeichen bei reellen Zahlen (gesetzt <==> Zahl <0)
  #define float_bit_t      TB1
  #define float1_bit_t     TB3
  #define float2_bit_t     TB2
  #define ratio_bit_t      TB3
  #define bignum_bit_t     TB2
# in Objekten (oint):
  #define garcol_bit_o     (garcol_bit_t+oint_type_shift)    # gesetzt nur während der Garbage Collection!
  #define number_bit_o     (number_bit_t+oint_type_shift)    # gesetzt nur bei Zahlen
  #define notsimple_bit_o  (notsimple_bit_t+oint_type_shift) # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_o       (sign_bit_t+oint_type_shift)      # Vorzeichen bei reellen Zahlen
  #define float_bit_o      (float_bit_t+oint_type_shift)
  #define float1_bit_o     (float1_bit_t+oint_type_shift)
  #define float2_bit_o     (float2_bit_t+oint_type_shift)
  #define ratio_bit_o      (ratio_bit_t+oint_type_shift)
  #define bignum_bit_o     (bignum_bit_t+oint_type_shift)
#ifdef IMMUTABLE
  # define immutable_bit_t  TB6                                # s.o.
  # define immutable_bit_o  (immutable_bit_t+oint_type_shift)  # s.o.
#endif

# konstante Typcodes:
  #define machine_type   (0)                                            # 0x00  # %00000000  ; Maschinenpointer
  #define sbvector_type  (                                    bit(TB0)) # 0x01  # %00000001  ; Simple-Bit-Vector
  #define sstring_type   (                           bit(TB1)         ) # 0x02  # %00000010  ; Simple-String
  #define svector_type   (                           bit(TB1)|bit(TB0)) # 0x03  # %00000011  ; Simple-Vector
  #define array_type     (                  bit(TB2)                  ) # 0x04  # %00000100  ; sonstiger Array (Rang /=1 oder
                                                                                #            ; - später vielleicht - anderer Elementtyp)
  #define bvector_type   (                  bit(TB2)         |bit(TB0)) # 0x05  # %00000101  ; sonstiger Bit-Vector oder Byte-Vector
  #define string_type    (                  bit(TB2)|bit(TB1)         ) # 0x06  # %00000110  ; sonstiger String
  #define vector_type    (                  bit(TB2)|bit(TB1)|bit(TB0)) # 0x07  # %00000111  ; sonstiger (VECTOR T)
  #define closure_type   (         bit(TB3)                           ) # 0x08  # %00001000  ; Closure
  #define structure_type (         bit(TB3)                  |bit(TB0)) # 0x09  # %00001001  ; Structure
  #define stream_type    (         bit(TB3)         |bit(TB1)         ) # 0x0A  # %00001010  ; Stream
  #define orecord_type   (         bit(TB3)         |bit(TB1)|bit(TB0)) # 0x0B  # %00001011  ; OtherRecord (Package, Byte, ...)
  #define instance_type  (         bit(TB3)|bit(TB2)                  ) # 0x0C  # %00001100  ; CLOS-Instanz
  #define subr_type      (         bit(TB3)|bit(TB2)         |bit(TB0)) # 0x0D  # %00001101  ; SUBR
  #define symbol_type    (         bit(TB3)|bit(TB2)|bit(TB1)         ) # 0x0E  # %00001110  ; Symbol
          # Bits für Symbole in VAR/FUN-Frames (im LISP-Stack):
          # sitzen nicht im oint_type-Teil, sondern im oint_addr-Teil.
          #define active_bit  0  # gesetzt: Bindung ist aktiv
          #define dynam_bit   1  # gesetzt: Bindung ist dynamisch
          #define svar_bit    2  # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen
          #if (varobject_alignment >= bit(3))
            #define oint_symbolflags_shift  oint_addr_shift
          #else
            #define NO_symbolflags # active_bit, dynam_bit, svar_bit haben im Symbol keinen Platz
          #endif
          # Bits für Symbole im Selbstpointer:
          #if !((TB3+3==TB7) || (TB3+2==TB7) || (TB3+1==TB7))
            #define constant_bit_t  (TB3+3)  # zeigt an, ob das Symbol eine Konstante ist
            #define special_bit_t   (TB3+2)  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
            #define keyword_bit_t   (TB3+1)  # zeigt an, ob das Symbol ein Keyword ist
          #else
            #define constant_bit_t  (TB7+3)  # zeigt an, ob das Symbol eine Konstante ist
            #define special_bit_t   (TB7+2)  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
            #define keyword_bit_t   (TB7+1)  # zeigt an, ob das Symbol ein Keyword ist
          #endif
  #define cons_type      (         bit(TB3)|bit(TB2)|bit(TB1)|bit(TB0)) # 0x0F  # %00001111  ; Cons
  #define fixnum_type    (bit(TB4)                                    ) # 0x10  # %00010000  ; Fixnum
  #define sfloat_type    (bit(TB4)                  |bit(TB1)         ) # 0x12  # %00010010  ; Short-Float
  #define bignum_type    (bit(TB4)         |bit(TB2)                  ) # 0x14  # %00010100  ; Bignum
  #define ffloat_type    (bit(TB4)         |bit(TB2)|bit(TB1)         ) # 0x16  # %00010110  ; Single-Float
  #define ratio_type     (bit(TB4)|bit(TB3)                           ) # 0x18  # %00011000  ; Ratio
  #define dfloat_type    (bit(TB4)|bit(TB3)         |bit(TB1)         ) # 0x1A  # %00011010  ; Double-float
  #define complex_type   (bit(TB4)|bit(TB3)|bit(TB2)                  ) # 0x1C  # %00011100  ; Complex
  #define lfloat_type    (bit(TB4)|bit(TB3)|bit(TB2)|bit(TB1)         ) # 0x1E  # %00011110  ; Long-Float
  #define system_type    (bit(TB5)                                    ) # 0x20  # %00100000  ; Frame-Pointer, Read-Label, SYSTEM
  #define char_type      (bit(TB5)|bit(TB0)                           ) # 0x21  # %00100001  ; Character
#ifdef IMMUTABLE
  #define imm_type  bit(immutable_bit_t)
 #ifdef IMMUTABLE_ARRAY
  #define imm_array_mask     imm_type  # Maske, die immutable von normalen Arrays unterscheidet
  #define imm_sbvector_type  (imm_array_mask|sbvector_type)  # immutabler Simple-Bit-Vector
  #define imm_sstring_type   (imm_array_mask|sstring_type)   # immutabler Simple-String
  #define imm_svector_type   (imm_array_mask|svector_type)   # immutabler Simple-Vector
  #define imm_array_type     (imm_array_mask|array_type)     # immutabler sonstiger Array (Rang /=1 oder
                                                             # - später vielleicht - anderer Elementtyp)
  #define imm_bvector_type   (imm_array_mask|bvector_type)   # immutabler sonstiger Bit-Vector oder Byte-Vector
  #define imm_string_type    (imm_array_mask|string_type)    # immutabler sonstiger String
  #define imm_vector_type    (imm_array_mask|vector_type)    # immutabler sonstiger (VECTOR T)
 #endif
 #ifdef IMMUTABLE_CONS
  #define imm_cons_mask  imm_type
  #define imm_cons_type  (imm_cons_mask|cons_type)  # immutable Cons
 #endif
#else
  #define imm_type  0
#endif

# Typ ist GC-invariant, wenn
  #if (TB5==5)&&(TB4==4)&&(TB3==3)&&(TB2==2)&&(TB1==1)&&(TB0==0) && !defined(WIDE)
    # Typinfobyte eines von 0x00,0x0D,0x10,0x11,0x12,0x13,0x20,0x21 ist.
    #define immediate_type_p(type)  \
      ((((type)&~imm_type)>=32) || ((bit(type) & 0xFFF0DFFEUL) == 0))
  #elif (TB5==6)&&(TB4==5)&&(TB3==4)&&(TB2==3)&&(TB1==2)&&(TB0==1) && defined(WIDE)
    # Typinfobyte/2 eines von 0x00,0x0D,0x10,0x11,0x12,0x13,0x16,0x17,0x20,0x21 ist.
    #define immediate_type_p(type)  \
      (((type)>=64) || ((bit((type)>>1) & 0xFF30DFFEUL) == 0))
  #endif

#endif # PACKED_TYPECODES

#ifdef SEVENBIT_TYPECODES

#if defined(UNIX_SYSV_UHC_1) || (defined(UNIX_LINUX) && (CODE_ADDRESS_RANGE != 0))
# Mallozierter Speicher belegt den Bereich ab 0x08000000.
# Für die Typinformation stehen nur 7 Bit zur Verfügung, und die für den
# Typcode zur Verfügung stehenden Bits liegen nicht am Stück.
# Wir müssen Bit 3 aus dem Weg gehen.
#if defined(UNIX_LINUX) && (CODE_ADDRESS_RANGE != 0)
# Shared Libraries belegen den Bereich ab 0x40000000 oder 0x50000000.
# Nehme daher Bit 6 als GC-Bit.
#endif
#endif

#if defined(UNIX_IRIX) || defined(UNIX_DEC_ULTRIX)
# Mallozierter Speicher belegt den Bereich ab 0x10000000.
# Für die Typinformation stehen nur 7 Bit zur Verfügung, und die für den
# Typcode zur Verfügung stehenden Bits liegen nicht am Stück.
# Wir müssen Bit 4 aus dem Weg gehen.
#endif

#ifdef UNIX_AIX
# Mallozierter Speicher belegt den Bereich ab 0x20000000.
# Für die Typinformation stehen nur 7 Bit zur Verfügung, und die für den
# Typcode zur Verfügung stehenden Bits liegen nicht am Stück.
# Wir müssen Bit 5 aus dem Weg gehen.
#endif

#if defined(UNIX_NEXTSTEP) && defined(MAP_MEMORY)
# UNIX_NEXTSTEP verbietet uns die Benutzung von Adressen im Bereich von
# unterhalb 0x04000000 bis oberhalb 0x05000000. Wir vermeiden daher als
# Typbits Bit 0 und Bit 2 (ausgenommen GC-Bit, das ja vor jedem Speicherzugriff
# wegmaskiert wird).
#endif

#if defined(UNIX_CONVEX) && defined(MAP_MEMORY)
# Bei UNIX_CONVEX liegt der Adreßraum der Prozesse ab 0x80000000.
# mmap() funktioniert allerdings nur unterhalb von 0xC000000. Daher
# gehört Bit 31 zur Adresse, und Bit 30 müssen wir aus dem Weg gehen.
#endif

# Typbits:
# in Typcodes (tint):
  #define garcol_bit_t     TB7  # gesetzt nur während der Garbage Collection!
  #define number_bit_t     TB4  # gesetzt nur bei Zahlen
  #define notsimple_bit_t  TB2  # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_t       TB0  # Vorzeichen bei reellen Zahlen (gesetzt <==> Zahl <0)
  #define float_bit_t      TB1
  #define float1_bit_t     TB3
  #define float2_bit_t     TB2
  #define ratio_bit_t      TB3
  #define bignum_bit_t     TB2
# in Objekten (oint):
  #define garcol_bit_o     (garcol_bit_t+oint_type_shift)    # gesetzt nur während der Garbage Collection!
  #define number_bit_o     (number_bit_t+oint_type_shift)    # gesetzt nur bei Zahlen
  #define notsimple_bit_o  (notsimple_bit_t+oint_type_shift) # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_o       (sign_bit_t+oint_type_shift)      # Vorzeichen bei reellen Zahlen
  #define float_bit_o      (float_bit_t+oint_type_shift)
  #define float1_bit_o     (float1_bit_t+oint_type_shift)
  #define float2_bit_o     (float2_bit_t+oint_type_shift)
  #define ratio_bit_o      (ratio_bit_t+oint_type_shift)
  #define bignum_bit_o     (bignum_bit_t+oint_type_shift)

# konstante Typcodes:
  #define machine_type   (0)                                             # %000000  ; Maschinenpointer
  #define sbvector_type  (                                    bit(TB0))  # %000001  ; Simple-Bit-Vector
  #define sstring_type   (                           bit(TB1)         )  # %000010  ; Simple-String
  #define svector_type   (                           bit(TB1)|bit(TB0))  # %000011  ; Simple-Vector
  #define array_type     (                  bit(TB2)                  )  # %000100  ; sonstiger Array (Rang /=1 oder
                                                                         #          ; - später vielleicht - anderer Elementtyp)
  #define bvector_type   (                  bit(TB2)         |bit(TB0))  # %000101  ; sonstiger Bit-Vector oder Byte-Vector
  #define string_type    (                  bit(TB2)|bit(TB1)         )  # %000110  ; sonstiger String
  #define vector_type    (                  bit(TB2)|bit(TB1)|bit(TB0))  # %000111  ; sonstiger (VECTOR T)
  #define closure_type   (         bit(TB3)                           )  # %001000  ; Closure
  #define structure_type (         bit(TB3)                  |bit(TB0))  # %001001  ; Structure
  #define stream_type    (         bit(TB3)         |bit(TB1)         )  # %001010  ; Stream
  #define orecord_type   (         bit(TB3)         |bit(TB1)|bit(TB0))  # %001011  ; OtherRecord (Package, Byte, ...)
  #define instance_type  (         bit(TB3)|bit(TB2)                  )  # %001100  ; CLOS-Instanz
  #define char_type      (         bit(TB3)|bit(TB2)         |bit(TB0))  # %001101  ; Character
  #define subr_type      (         bit(TB3)|bit(TB2)|bit(TB1)         )  # %001110  ; SUBR
  #define system_type    (         bit(TB3)|bit(TB2)|bit(TB1)|bit(TB0))  # %001111  ; Frame-Pointer, Read-Label, SYSTEM
  #define fixnum_type    (bit(TB4)                                    )  # %010000  ; Fixnum
  #define sfloat_type    (bit(TB4)                  |bit(TB1)         )  # %010010  ; Short-Float
  #define bignum_type    (bit(TB4)         |bit(TB2)                  )  # %010100  ; Bignum
  #define ffloat_type    (bit(TB4)         |bit(TB2)|bit(TB1)         )  # %010110  ; Single-Float
  #define ratio_type     (bit(TB4)|bit(TB3)                           )  # %011000  ; Ratio
  #define dfloat_type    (bit(TB4)|bit(TB3)         |bit(TB1)         )  # %011010  ; Double-float
  #define complex_type   (bit(TB4)|bit(TB3)|bit(TB2)                  )  # %011100  ; Complex
  #define lfloat_type    (bit(TB4)|bit(TB3)|bit(TB2)|bit(TB1)         )  # %011110  ; Long-Float
  #define symbol_type    (bit(TB5)                                    )  # %100000  ; Symbol
          # Bits für Symbole in VAR/FUN-Frames (im LISP-Stack):
          #define active_bit  TB0  # gesetzt: Bindung ist aktiv
          #define dynam_bit   TB1  # gesetzt: Bindung ist dynamisch
          #define svar_bit    TB2  # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen
          #define oint_symbolflags_shift  oint_type_shift
          # Bits für Symbole im Selbstpointer:
          #define constant_bit_t  TB0  # zeigt an, ob das Symbol eine Konstante ist
          #define special_bit_t   TB1  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
          #define keyword_bit_t   TB2  # zeigt an, ob das Symbol ein Keyword ist
  #define cons_type      (bit(TB5)|bit(TB3))                             # %101000  ; Cons

#ifndef WIDE
  # Typ ist GC-invariant, wenn
  # Typinfobyte=0 oder char_type <= Typinfobyte < bignum_type.
    #define immediate_type_p(type)  \
      ((type==0) || ((char_type<=type) && (type<bignum_type)))
#else
  #error "immediate_type_p() implementieren!"
#endif

#endif # SEVENBIT_TYPECODES

#ifdef SIXBIT_TYPECODES

#if defined(ACORN_3) || defined(ACORN_4)
# Speicher kann den Bereich von 0x00000000 bis 0x03FFFFFF umfassen.
# Für die Typinformation stehen nur 6 Bit zur Verfügung.
#endif

#ifdef AMIGA3000
# Speicher kann den Bereich von 0x07000000 bis 0x0FFFFFFF umfassen.
# Für die Typinformation stehen nur 6 Bit zur Verfügung, und dies auch nur,
# wenn wir Alignment = 4 voraussetzen.
# Das können wir aber nicht, da der C-Compiler bzw. der Linker im Text-Segment
# nur Alignment = 2 hat. Somit können wir nur den Bereich von 0x07000000 bis
# 0x07FFFFFF nutzen.
#endif

#if defined(HPPA) && defined(UNIX_HPUX)
# Mallozierter Speicher belegt den Bereich ab 0x40000000.
# Für die Typinformation stehen die Bits 29..24 zur Verfügung.
#endif

#ifdef UNIX_AMIX
# Bits 31..30 werden vom Betriebssystem belegt.
# Für die Typinformation stehen die Bits 29..24 zur Verfügung.
#endif

#ifdef UNIX_SYSV_UHC_2
# Mallozierter Speicher belegt den Bereich ab 0x08000000.
# Für die Typinformation stehen nur 6 Bit zur Verfügung, und dies auch nur,
# wenn wir Alignment = 4 voraussetzen.
#endif

#ifdef WATCOM_BLAKE
# When run with virtual memory or in the DOS box, the DOS4GW extender returns
# malloc'ed memory in the range beginning at 0x80000000.
# The type information can use the bits 30..25.
#endif

# Für die Typinformation stehen nur 6 Bit zur Verfügung.
# Daher eine etwas gedrängte Typcode-Verteilung.

# Typbits:
# in Typcodes (tint):
  #define garcol_bit_t     5  # gesetzt nur während der Garbage Collection!
  #define number_bit_t     4  # gesetzt nur bei Zahlen
  #define notsimple_bit_t  2  # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_t       0  # Vorzeichen bei reellen Zahlen (gesetzt <==> Zahl <0)
  #define float_bit_t      1
  #define float1_bit_t     3
  #define float2_bit_t     2
  #define ratio_bit_t      3
  #define bignum_bit_t     2
# in Objekten (oint):
  #define garcol_bit_o     (garcol_bit_t+oint_type_shift)    # gesetzt nur während der Garbage Collection!
  #define number_bit_o     (number_bit_t+oint_type_shift)    # gesetzt nur bei Zahlen
  #define notsimple_bit_o  (notsimple_bit_t+oint_type_shift) # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_o       (sign_bit_t+oint_type_shift)      # Vorzeichen bei reellen Zahlen
  #define float_bit_o      (float_bit_t+oint_type_shift)
  #define float1_bit_o     (float1_bit_t+oint_type_shift)
  #define float2_bit_o     (float2_bit_t+oint_type_shift)
  #define ratio_bit_o      (ratio_bit_t+oint_type_shift)
  #define bignum_bit_o     (bignum_bit_t+oint_type_shift)

# konstante Typcodes:
  #define machine_type   0x00  # %000000  ; Maschinenpointer
  #define sbvector_type  0x01  # %000001  ; Simple-Bit-Vector
  #define sstring_type   0x02  # %000010  ; Simple-String
  #define svector_type   0x03  # %000011  ; Simple-Vector
  #define array_type     0x04  # %000100  ; sonstiger Array (Rang /=1 oder
                               #          ; - später vielleicht - anderer Elementtyp)
  #define bvector_type   0x05  # %000101  ; sonstiger Bit-Vector oder Byte-Vector
  #define string_type    0x06  # %000110  ; sonstiger String
  #define vector_type    0x07  # %000111  ; sonstiger (VECTOR T)
  #define symbol_type    0x08  # %001000  ; Symbol
          # Bits für Symbole in VAR/FUN-Frames (im LISP-Stack):
          #define active_bit  0  # gesetzt: Bindung ist aktiv
          #define dynam_bit   1  # gesetzt: Bindung ist dynamisch
          #define svar_bit    2  # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen
          #if defined(ACORN_3) || defined(ACORN_4) || defined(AMIGA3000) || defined(UNIX_AMIX) || defined(WATCOM_BLAKE)
            #define NO_symbolflags # active_bit, dynam_bit, svar_bit haben im Symbol keinen Platz
          #endif
          #if defined(HPPA) && defined(UNIX_HPUX)
            # sitzen nicht im oint_type-Teil, sondern im oint_addr-Teil.
            #define oint_symbolflags_shift  oint_addr_shift
          #endif
          #if defined(UNIX_SYSV_UHC_2)
            # sitzen im oberen oint_addr-Teil.
            #define oint_symbolflags_shift  (24-addr_shift + oint_addr_shift)
          #endif
          # Bits für Symbole im Selbstpointer:
          #define constant_bit_t  4  # zeigt an, ob das Symbol eine Konstante ist
          #define special_bit_t   0  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
          #define keyword_bit_t   2  # zeigt an, ob das Symbol ein Keyword ist
  #define cons_type      0x09  # %001001  ; Cons
  #define subr_type      0x0A  # %001010  ; SUBR
  #define instance_type  0x0B  # %001011  ; CLOS-Instanz
  #define closure_type   0x0C  # %001100  ; Closure
  #define orecord_type   0x0D  # %001101  ; OtherRecord (Structure, Stream, Package, Byte, ...)
  #define system_type    0x0E  # %001110  ; Frame-Pointer, Read-Label, SYSTEM
  #define char_type      0x0F  # %001111  ; Character
  #define fixnum_type    0x10  # %010000  ; Fixnum
  #define sfloat_type    0x12  # %010010  ; Short-Float
  #define bignum_type    0x14  # %010100  ; Bignum
  #define ffloat_type    0x16  # %010110  ; Single-Float
  #define ratio_type     0x18  # %011000  ; Ratio
  #define dfloat_type    0x1A  # %011010  ; Double-float
  #define complex_type   0x1C  # %011100  ; Complex
  #define lfloat_type    0x1E  # %011110  ; Long-Float

# Typ ist GC-invariant, wenn
# Typinfobyte eines von 0x00,0x0A,0x0E,0x0F,0x10,0x11,0x12,0x13 ist.
  #define immediate_type_p(type)  \
    ((bit(type) & 0xFFF03BFEUL) == 0)

#endif # SIXBIT_TYPECODES

#ifdef SUN3_TYPECODES

# Typbits:
# in Typcodes (tint):
  #define garcol_bit_t     1  # gesetzt nur während der Garbage Collection!
  #define cons_bit_t       7  # gesetzt nur bei CONS
  #define symbol_bit_t     6  # gesetzt nur bei SYMBOL
  #define number_bit_t     2  # gesetzt nur bei Zahlen
  #define notsimple_bit_t  0  # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_t       0  # Vorzeichen bei reellen Zahlen (gesetzt <==> Zahl <0)
  #define float_bit_t      5
  #define float1_bit_t     3
  #define float2_bit_t     4
  #define ratio_bit_t      3
  #define bignum_bit_t     4
# in Objekten (oint):
  #define garcol_bit_o     (garcol_bit_t+oint_type_shift)    # gesetzt nur während der Garbage Collection!
  #define cons_bit_o       (cons_bit_t+oint_type_shift)      # gesetzt nur bei CONS
  #define symbol_bit_o     (symbol_bit_t+oint_type_shift)    # gesetzt nur bei SYMBOL
  #define number_bit_o     (number_bit_t+oint_type_shift)    # gesetzt nur bei Zahlen
  #define notsimple_bit_o  (notsimple_bit_t+oint_type_shift) # bei Arrays: gelöscht bei Simple-Arrays
  #define sign_bit_o       (sign_bit_t+oint_type_shift)      # Vorzeichen bei reellen Zahlen
  #define float_bit_o      (float_bit_t+oint_type_shift)
  #define float1_bit_o     (float1_bit_t+oint_type_shift)
  #define float2_bit_o     (float2_bit_t+oint_type_shift)
  #define ratio_bit_o      (ratio_bit_t+oint_type_shift)
  #define bignum_bit_o     (bignum_bit_t+oint_type_shift)

# konstante Typcodes:
  #define machine_type   0x00  # %00000000  ; Maschinenpointer
  #define sbvector_type  0x10  # %00010000  ; Simple-Bit-Vector
  #define sstring_type   0x08  # %00001000  ; Simple-String
  #define svector_type   0x18  # %00011000  ; Simple-Vector
  #define array_type     0x01  # %00000001  ; sonstiger Array (Rang /=1 oder
                               #            ; - später vielleicht - anderer Elementtyp)
  #define bvector_type   0x11  # %00010001  ; sonstiger Bit-Vector oder Byte-Vector
  #define string_type    0x09  # %00001001  ; sonstiger String
  #define vector_type    0x19  # %00011001  ; sonstiger (VECTOR T)
  #define closure_type   0x20  # %00100000  ; Closure
  #define structure_type 0x21  # %00100001  ; Structure
  #define stream_type    0x28  # %00101000  ; Stream
  #define orecord_type   0x29  # %00101001  ; OtherRecord (Package, Byte, ...)
  #define instance_type  0x39  # %00111001  ; CLOS-Instanz
  #define char_type      0x31  # %00110001  ; Character
  #define subr_type      0x30  # %00110000  ; SUBR
  #define system_type    0x38  # %00111000  ; Frame-Pointer, Read-Label, SYSTEM
  #define fixnum_type    0x04  # %00000100  ; Fixnum
  #define sfloat_type    0x24  # %00100100  ; Short-Float
  #define bignum_type    0x14  # %00010100  ; Bignum
  #define ffloat_type    0x34  # %00110100  ; Single-Float
  #define ratio_type     0x0C  # %00001100  ; Ratio
  #define dfloat_type    0x2C  # %00101100  ; Double-float
  #define complex_type   0x1C  # %00011100  ; Complex
  #define lfloat_type    0x3C  # %00111100  ; Long-Float
  #define symbol_type    0x40  # %01000000  ; Symbol
          # Bits für Symbole in VAR/FUN-Frames (im LISP-Stack):
          #define active_bit  3  # gesetzt: Bindung ist aktiv
          #define dynam_bit   4  # gesetzt: Bindung ist dynamisch
          #define svar_bit    5  # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen
          #define oint_symbolflags_shift  oint_type_shift
          # Bits für Symbole im Selbstpointer:
          #define constant_bit_t  3  # zeigt an, ob das Symbol eine Konstante ist
          #define special_bit_t   4  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
          #define keyword_bit_t   5  # zeigt an, ob das Symbol ein Keyword ist
  #define cons_type      0x80  # %10000000  ; Cons

# Typ ist GC-invariant, wenn
# Typinfobyte eines von 0x00,0x04,0x05,0x24,0x25,0x30,0x31,0x38 ist.
  #define immediate_type_p(type)  \
    ((type<0x39) && ((type==0) || !((bit(type>>1) & 0x11040004) == 0)))

#endif # SUN3_TYPECODES

#if !(immediate_type_p(ffloat_type) == defined(WIDE))
  #error "immediate_type_p() fehlerhaft implementiert!"
#endif

#if defined(SINGLEMAP_MEMORY) && (((system_type*1UL << oint_type_shift) & addressbus_mask) == 0)
  # Auch der STACK liegt in einem Singlemap-Bereich, Typinfo system_type.
  #define SINGLEMAP_MEMORY_STACK
#endif


#ifdef oint_symbolflags_shift
  #if defined(SINGLEMAP_MEMORY) && (oint_symbolflags_shift==oint_type_shift)
    # Da wir die symbol_tab nicht multimappen können, müssen wir auf extra Bits
    # im Typcode von Symbolen verzichten.
    #undef oint_symbolflags_shift
    #define NO_symbolflags
  #endif
#endif
#ifdef NO_symbolflags
  #define oint_symbolflags_shift  -1 # ungültiger Wert
#endif


# Fallunterscheidungen nach Typcodes:
# Einzuleiten durch switch (typecode(obj)), danach wie in einer
# switch-Anweisung beliebig viele case-Labels.
# Beispiel:  switch (typecode(arg)) { case_string: ...; break; ... }
  #define case_machine    case machine_type   # Maschinenpointer
  #ifdef IMMUTABLE_ARRAY
  #define case_sstring    case imm_sstring_type: case sstring_type    # Simple-String
  #define case_ostring    case imm_string_type: case string_type      # Other String
  #define case_string     case_sstring: case_ostring                  # String allgemein
  #define case_sbvector   case imm_sbvector_type: case sbvector_type  # Simple-Bit-Vector
  #define case_obvector   case imm_bvector_type: case bvector_type    # Other Bit/Byte-Vector
  #define case_bvector    case_sbvector: case_obvector                # Bit-Vector allgemein
  #define case_svector    case imm_svector_type: case svector_type    # Simple-(General-)Vector
  #define case_ovector    case imm_vector_type: case vector_type      # Other (General-)Vector
  #define case_vector     case_svector: case_ovector                  # (General-)Vector allgemein
  #define case_array1     case imm_array_type: case array_type        # sonstiger Array
  #define case_array      case_string: case_bvector: case_vector: case_array1 # Array allgemein
  #else
  #define case_sstring    case sstring_type   # Simple-String
  #define case_ostring    case string_type    # Other String
  #define case_string     case_sstring: case_ostring # String allgemein
  #define case_sbvector   case sbvector_type  # Simple-Bit-Vector
  #define case_obvector   case bvector_type   # Other Bit/Byte-Vector
  #define case_bvector    case_sbvector: case_obvector # Bit-Vector allgemein
  #define case_svector    case svector_type   # Simple-(General-)Vector
  #define case_ovector    case vector_type    # Other (General-)Vector
  #define case_vector     case_svector: case_ovector # (General-)Vector allgemein
  #define case_array1     case array_type     # sonstiger Array
  #define case_array      case_string: case_bvector: case_vector: case_array1 # Array allgemein
  #define imm_array_mask     0
  #define imm_sbvector_type  sbvector_type
  #define imm_sstring_type   sstring_type
  #define imm_svector_type   svector_type
  #define imm_array_type     array_type
  #define imm_bvector_type   bvector_type
  #define imm_string_type    string_type
  #define imm_vector_type    vector_type
  #endif
  #define case_closure    case closure_type   # Closure
  #ifdef structure_type
  #define case_structure  case structure_type # Structure
  #else
  #define structure_type  orecord_type        # Structures sind OtherRecords
  #endif
  #ifdef stream_type
  #define case_stream     case stream_type    # Stream
  #else
  #define stream_type     orecord_type        # Streams sind OtherRecords
  #endif
  #define case_orecord    case orecord_type   # Other Record
  #define case_instance   case instance_type  # CLOS-Instanz
  #if defined(case_structure) || defined(case_stream)
  #define case_record     case_closure: case_structure: case_stream: case_orecord: case_instance # Record allgemein
  #else
  #define case_record     case_closure: case_orecord: case_instance # Record allgemein
  #endif
  #define case_char       case char_type      # Character
  #define case_subr       case subr_type      # SUBR
  #define case_system     case system_type    # Frame-Pointer, Read-Label, System
  #define case_posfixnum  case fixnum_type    # Fixnum >=0
  #define case_negfixnum  case fixnum_type|bit(sign_bit_t) # Fixnum <0
  #define case_fixnum     case_posfixnum: case_negfixnum # Fixnum
  #define case_posbignum  case bignum_type    # Bignum >0
  #define case_negbignum  case bignum_type|bit(sign_bit_t) # Bignum <0
  #define case_bignum     case_posbignum: case_negbignum # Bignum
  #define case_integer    case_fixnum: case_bignum # Integer
  #define case_ratio      case ratio_type: case ratio_type|bit(sign_bit_t) # Ratio
  #define case_rational   case_integer: case_ratio # Rational
  #define case_sfloat     case sfloat_type: case sfloat_type|bit(sign_bit_t) # Short-Float
  #define case_ffloat     case ffloat_type: case ffloat_type|bit(sign_bit_t) # Single-Float
  #define case_dfloat     case dfloat_type: case dfloat_type|bit(sign_bit_t) # Double-Float
  #define case_lfloat     case lfloat_type: case lfloat_type|bit(sign_bit_t) # Long-Float
  #define case_float      case_sfloat: case_ffloat: case_dfloat: case_lfloat # Float
  #define case_real       case_rational: case_float # Real
  #define case_complex    case complex_type # Complex
  #define case_number     case_real: case_complex # Number
  #define case_symbol     case symbol_type # Symbol
  #if /* !defined(NO_symbolflags) && */ (oint_symbolflags_shift==oint_type_shift)
  #define case_symbolflagged  # Symbol mit Flags \
                          case symbol_type: \
                          case symbol_type|bit(active_bit): \
                          case symbol_type|bit(dynam_bit): \
                          case symbol_type|bit(dynam_bit)|bit(active_bit): \
                          case symbol_type|bit(svar_bit): \
                          case symbol_type|bit(svar_bit)|bit(active_bit): \
                          case symbol_type|bit(svar_bit)|bit(dynam_bit): \
                          case symbol_type|bit(svar_bit)|bit(dynam_bit)|bit(active_bit)
  #else
  #define case_symbolflagged  case_symbol # Symbol mit Flags
  #endif
  #ifdef IMMUTABLE_CONS
  #define case_cons       case imm_cons_type: case cons_type # Cons
  #else
  #define imm_cons_mask   0
  #define case_cons       case cons_type # Cons
  #define imm_cons_type   cons_type
  #endif


# ################## Speicheraufbau von LISP-Objekten ##################### #

# Objekte mit genau zwei Pointern:

# Cons
typedef struct { object cdr;   # CDR
                 object car; } # CAR
        cons_;
typedef cons_ *  Cons;

# liefert das immutable Pendant zu einem Cons
#define make_imm_cons(obj)  \
  objectplus(obj,type_zero_oint(imm_cons_type)-type_zero_oint(cons_type))

# Ratio
typedef struct { object rt_num;   # Zähler, Integer
                 object rt_den; } # Nenner, Integer >0
        ratio_;
typedef ratio_ *  Ratio;

# Complex
typedef struct { object c_real;   # Realteil, reelle Zahl
                 object c_imag; } # Imaginärteil, reelle Zahl
        complex_;
typedef complex_ *  Complex;

# Objekte variabler Länge:
# Die erste Komponente (die ersten vier Bytes) sind für die Garbage
# Collection reserviert. Das erste Byte davon muß die Typinfo des
# Objektes enthalten (bei Symbolen zusätzlich noch max. 3 Flag-Bits); bis
# auf das GC-Bit 7 wird es von der GC unverändert gelassen. Die drei weiteren
# Bytes der ersten Komponente werden von der GC als Zwischenpointer genutzt;
# nach Beendigung der GC steht dort ein Selbstpointer.

# Typ der Header-Flags:
  #if (oint_type_len<=8) && !defined(ARM) && !defined(DECALPHA)
    # Zugriff auf ein einzelnes Byte möglich
    #define hfintsize  intBsize
    typedef uintB  hfint;
  #else
    # Zugriff auf ein ganzes Wort
    #define hfintsize  intLsize
    typedef uintL  hfint;
  #endif

# Objekt variabler Länge
#define VAROBJECT_HEADER  \
               union { object _GCself;  # Selbstpointer für GC            \
                       hfint flags[sizeof(object)/sizeof(hfint)]; # Flags \
                     } header;
typedef struct { VAROBJECT_HEADER }
        varobject_;
typedef varobject_ *  Varobject;
#define GCself  header._GCself
# Der Typcode ist im Byte ((Varobject)p)->header_flags enthalten.
  #if !(oint_type_len>=hfintsize ? oint_type_shift%hfintsize==0 : floor(oint_type_shift,hfintsize)==floor(oint_type_shift+oint_type_len-1,hfintsize))
    #error "Bogus header_flags -- header_flags neu definieren!"
  #endif
  #if BIG_ENDIAN_P
    #define header_flags  header.flags[sizeof(object)/sizeof(hfint)-1-floor(oint_type_shift,hfintsize)]
  #else
    #define header_flags  header.flags[floor(oint_type_shift,hfintsize)]
  #endif
  # Es gilt  mtypecode(((Varobject)p)->GCself) =
  # (((Varobject)p)->header_flags >> (oint_type_shift%hfintsize)) & tint_type_mask
  # Bits für Symbole im Selbstpointer (siehe oben):
  # define constant_bit_t  ...  # zeigt an, ob das Symbol eine Konstante ist
  # define special_bit_t   ...  # zeigt an, ob das Symbol SPECIAL-proklamiert ist
  # define keyword_bit_t   ...  # zeigt an, ob das Symbol ein Keyword ist
  #define constant_bit_hf  (constant_bit_t+(oint_type_shift%hfintsize))
  #define special_bit_hf  (special_bit_t+(oint_type_shift%hfintsize))
  #define keyword_bit_hf  (keyword_bit_t+(oint_type_shift%hfintsize))

# Symbol
typedef struct { VAROBJECT_HEADER
                 object symvalue;    # Wertzelle
                 object symfunction; # Funktiondefinitionszelle
                 object proplist;    # Property-Liste
                 object pname;       # Printname
                 object homepackage; # Home-Package oder NIL
               }
        symbol_;
typedef symbol_ *  Symbol;
#define symbol_objects_offset  offsetof(symbol_,symvalue)

# Jedes Keyword ist eine Konstante.
# Bei Konstanten ist das Special-Bit bedeutungslos (denn Konstanten
# können bei uns weder lexikalisch noch dynamisch gebunden werden).

# Test, ob ein Symbol eine Konstante ist:
  #define constantp(sym)  \
    (((sym)->header_flags) & bit(constant_bit_hf))

# Test, ob ein Symbol eine SPECIAL-proklamierte Variable ist:
  #define special_var_p(sym)  \
    (((sym)->header_flags) & bit(special_bit_hf))

# Test, ob ein Symbol ein Keyword ist:
  #define keywordp(sym)  \
    ((TheSymbol(sym)->header_flags) & bit(keyword_bit_hf))

# Constant-Flag eines Symbols setzen:
  #define set_const_flag(sym)  \
    (((sym)->header_flags) |= bit(constant_bit_hf))

# Constant-Flag eines Symbols löschen:
# (Symbol darf kein Keyword sein, vgl. spvw.d:case_symbolwithflags)
  #define clear_const_flag(sym)  \
    (((sym)->header_flags) &= ~bit(constant_bit_hf))

# Special-Flag eines Symbols setzen:
  #define set_special_flag(sym)  \
    (((sym)->header_flags) |= bit(special_bit_hf))

# Special-Flag eines Symbols löschen:
  #define clear_special_flag(sym)  \
    (((sym)->header_flags) &= ~bit(special_bit_hf))

# Symbol als Konstante mit gegebenem Wert val definieren.
# val darf keine GC auslösen!
  #define define_constant(sym,val)                              \
    {var reg1 Symbol sym_from_define_constant = TheSymbol(sym); \
     set_const_flag(sym_from_define_constant);                  \
     sym_from_define_constant->symvalue = (val);                \
    }

# Symbol als Variable mit gegebenem Initialisierungswert val definieren.
# val darf keine GC auslösen!
  #define define_variable(sym,val)                              \
    {var reg1 Symbol sym_from_define_variable = TheSymbol(sym); \
     set_special_flag(sym_from_define_variable);                \
     sym_from_define_variable->symvalue = (val);                \
    }

# Flagbits in einem Symbol entfernen:
  #if defined(NO_symbolflags)
    #define symbol_without_flags(symbol)  symbol
  #elif (oint_symbolflags_shift==oint_type_shift)
    #define symbol_without_flags(symbol)  \
      as_object(as_oint(symbol) & (type_zero_oint(symbol_type) | oint_addr_mask))
  #else
    #define symbol_without_flags(symbol)  \
      as_object(as_oint(symbol) & ~((wbit(active_bit)|wbit(dynam_bit)|wbit(svar_bit))<<oint_symbolflags_shift))
  #endif

# Characters
# Implementiert sind 4 Bits und 16 Fonts.
# Aufteilung in code, bits, font:
#   Fontnummer  in den Bits 15..12,
#   Bits        in den Bits 11..8,
#   Ascii-Code  in den Bits 7..0.
# Bits: 8=Control, 9=Meta, 10=Super, 11=Hyper.
# Fonts: 0=Default, restliche ungenutzt und non-graphic.

# Integer, der die Daten eines Character ganz faßt:
  #define char_int_len 16
  #define char_int_limit  (1UL<<char_int_len)
  #ifdef ANSI
    typedef unsigned_int_with_n_bits(char_int_len)  cint;
  #else
    typedef uint/**/char_int_len  cint;
  #endif
# Aus einem Integer-Code ein Character machen:
  #define int_char(int_from_int_char)  \
    type_data_object(char_type,(aint)(cint)(int_from_int_char))
# Aus einem Character seinen Integer-Code herausziehen:
  #if !((oint_data_shift==0) && (char_int_len<=oint_data_len) && (exact_uint_size_p(char_int_len)))
    #define char_int(char_from_char_int)  \
      ((cint)(untype(char_from_char_int)))
  #else
    # Falls oint_data_shift=0, braucht untype nicht zu shiften;
    # falls auch char_int_len<=oint_data_len und ein cint genau char_int_len
    # Bits hat, braucht untype nicht zu ANDen.
    #define char_int(char_from_char_int)  \
      ((cint)as_oint(char_from_char_int))
  #endif
# Characters können somit mit EQ auf Gleichheit verglichen werden,
# das ist ein oint-Vergleich bzw. (unter Characters) sogar ein
# cint-Vergleich ihrer Integer-Codes.

# Aufteilung eines Integer-Codes in Bits:
  #define char_code_shift_c   0      # (sollte =0 sein, siehe CLTL S. 242)
  #define char_code_len_c     8      # Ascii-Zeichensatz mit 8 Bits, paßt in uintB
  #define char_code_limit     (1UL<<char_code_len_c)
  #define char_code_mask_c    ((char_code_limit-1)<<char_code_shift_c)
  #define char_bits_shift_c   8
  #define char_bits_len_c     4
  #define char_bits_limit     (1UL<<char_bits_len_c)
  #define char_bits_mask_c    ((char_bits_limit-1)<<char_bits_shift_c)
  #define char_font_shift_c  12
  #define char_font_len_c     4
  #define char_font_limit     (1UL<<char_font_len_c)
  #define char_font_mask_c    ((char_font_limit-1)<<char_font_shift_c)
# Aus dem Code eines String-Char ein Character machen:
  #if !(char_code_shift_c==0)
    #define code_char(code_from_code_char)  \
      int_char((cint)(code_from_code_char)<<char_code_shift_c)
  #else
    # falls nicht geschoben werden muß:
    #define code_char(code_from_code_char)  \
      int_char((cint)(code_from_code_char))
  #endif
# Aus einem Character den Code extrahieren:
  #if !((char_code_shift_c==0)&&(char_code_len_c==8))
    #define char_code(char_from_char_code)  \
      ((uintB)((char_int(char_from_char_code)&char_code_mask_c)>>char_code_shift_c))
  #else
    # falls der char-code genau das untere Byte belegt:
    #define char_code(char_from_char_code)  ((uintB)(char_int(char_from_char_code)))
  #endif
# Bits im cint:
  #define char_control_bit_c  8
  #define char_meta_bit_c     9
  #define char_super_bit_c   10
  #define char_hyper_bit_c   11
# Bitmasken im cint:
  #define char_control_c  bit(char_control_bit_c)
  #define char_meta_c     bit(char_meta_bit_c)
  #define char_super_c    bit(char_super_bit_c)
  #define char_hyper_c    bit(char_hyper_bit_c)
# wird verwendet von STREAM, DEBUG, EVAL

# Fixnums

# fixnum(x) ist ein Fixnum mit Wert x>=0.
# x eine Expression mit 0 <= x < 2^oint_data_len.
# (Sollte eigentlich posfixnum(x) heißen.)
  #define fixnum(x)  type_data_object(fixnum_type,x)

# Fixnum_0 ist die Zahl 0, Fixnum_1 ist die Zahl 1,
# Fixnum_minus1 ist die Zahl -1
  #define Fixnum_0  fixnum(0)
  #define Fixnum_1  fixnum(1)
  #define Fixnum_minus1  type_data_object( fixnum_type | bit(sign_bit_t), bitm(oint_data_len)-1 )

# Wert eines nichtnegativen Fixnum:
# posfixnum_to_L(obj)
# Ergebnis ist >= 0, < 2^oint_data_len.
  #if !(defined(SPARC) && (oint_data_len+oint_data_shift<32))
    #define posfixnum_to_L(obj)  \
      ((uintL)((as_oint(obj)&(wbitm(oint_data_len+oint_data_shift)-1))>>oint_data_shift))
  #else
    # Auf einem SPARC-Prozessor sind lange Konstanten langsamer als Shifts:
    #define posfixnum_to_L(obj)  \
      ((uintL)((as_oint(obj) << (32-oint_data_len-oint_data_shift)) >> (32-oint_data_len)))
  #endif

# Wert eines negativen Fixnum:
# negfixnum_to_L(obj)
# Ergebnis ist >= - 2^oint_data_len, < 0.
  #define negfixnum_to_L(obj)  (posfixnum_to_L(obj) | (-bitm(oint_data_len)))

# Betrag eines negativen Fixnum:
# negfixnum_abs_L(obj)
# Ergebnis ist > 0, <= 2^oint_data_len.
# Vorsicht: Wraparound bei oint_data_len=intLsize möglich!
  #define negfixnum_abs_L(obj)  \
    ((uintL)((as_oint(fixnum_inc(Fixnum_minus1,1))-as_oint(obj))>>oint_data_shift))

# Wert eines Fixnum, obj sollte eine Variable sein:
# fixnum_to_L(obj)
# Ergebnis ist >= - 2^oint_data_len, < 2^oint_data_len und vom Typ sintL.
# Die Verwendung dieses Macros ist nur bei oint_data_len+1 <= intLsize sinnvoll!
  #if (oint_data_len>=intLsize)
    # Kein Platz mehr fürs Vorzeichenbit, daher fixnum_to_L = posfixnum_to_L = negfixnum_to_L !
    #define fixnum_to_L(obj)  (sintL)posfixnum_to_L(obj)
  #elif (sign_bit_o == oint_data_len+oint_data_shift)
    #define fixnum_to_L(obj)  \
      (((sintL)as_oint(obj) << (intLsize-1-sign_bit_o)) >> (intLsize-1-sign_bit_o+oint_data_shift))
  #else
    #if !defined(SPARC)
      #define fixnum_to_L(obj)  \
        (sintL)( ((((sintL)as_oint(obj) >> sign_bit_o) << (intLsize-1)) >> (intLsize-1-oint_data_len)) \
                |((uintL)((as_oint(obj) & (wbitm(oint_data_len+oint_data_shift)-1)) >> oint_data_shift)) \
               )
    #else
      # Auf einem SPARC-Prozessor sind lange Konstanten langsamer als Shifts:
      #define fixnum_to_L(obj)  \
        (sintL)( ((((sintL)as_oint(obj) >> sign_bit_o) << (intLsize-1)) >> (intLsize-1-oint_data_len)) \
                |(((uintL)as_oint(obj) << (intLsize-oint_data_len-oint_data_shift)) >> (intLsize-oint_data_len)) \
               )
    #endif
  #endif

#ifdef intQsize
# Wert eines Fixnum, obj sollte eine Variable sein:
# fixnum_to_Q(obj)
# Ergebnis ist >= - 2^oint_data_len, < 2^oint_data_len.
  #if (sign_bit_o == oint_data_len+oint_data_shift)
    #define fixnum_to_Q(obj)  \
      (((sintQ)as_oint(obj) << (intQsize-1-sign_bit_o)) >> (intQsize-1-sign_bit_o+oint_data_shift))
  #else
    #define fixnum_to_Q(obj)  \
      ( ((((sintQ)as_oint(obj) >> sign_bit_o) << (intQsize-1)) >> (intQsize-1-oint_data_len)) \
       |((uintQ)((as_oint(obj) & (wbitm(oint_data_len+oint_data_shift)-1)) >> oint_data_shift)) \
      )
  #endif
#endif

# Zu einem nichtnegativen Fixnum eine Konstante addieren, vorausgesetzt,
# das Ergebnis ist wieder ein nichtnegatives Fixnum:
# fixnum_inc(obj,delta)
# > obj: ein Fixnum
# > delta: eine Konstante
# < ergebnis: erhöhtes Fixnum
  #define fixnum_inc(obj,delta)  \
    objectplus(obj, (soint)(delta) << oint_data_shift)

# posfixnum(x) ist ein Fixnum mit Wert x>=0.
  #define posfixnum(x)  fixnum_inc(Fixnum_0,x)

# negfixnum(x) ist ein Fixnum mit Wert x<0.
# (Vorsicht, wenn x unsigned ist!)
  #define negfixnum(x)  fixnum_inc(fixnum_inc(Fixnum_minus1,1),x)

# sfixnum(x) ist ein Fixnum mit Wert x,
# x eine Constant-Expression mit -2^oint_data_len <= x < 2^oint_data_len.
  #define sfixnum(x) ((x)>=0 ? posfixnum(x) : negfixnum(x))

# Aus einem Character ein Fixnum >=0 machen (wie bei char-int):
  #ifdef WIDE_STRUCT
    #define char_to_fixnum(obj)  \
      type_data_object(fixnum_type,untype(obj))
  #else
    #define char_to_fixnum(obj)  \
      objectplus(obj,type_zero_oint(fixnum_type)-type_zero_oint(char_type))
  #endif

# Aus einem passenden Fixnum >=0 ein Character machen (wie bei int-char):
  #ifdef WIDE_STRUCT
    #define fixnum_to_char(obj)  \
      type_data_object(char_type,untype(obj))
  #else
    #define fixnum_to_char(obj)  \
      objectplus(obj,type_zero_oint(char_type)-type_zero_oint(fixnum_type))
  #endif

# Bignums
typedef struct { VAROBJECT_HEADER  # Selbstpointer für GC
                 uintC length;     # Länge in Digits
                 uintD data[unspecified]; # Zahl in Zweierkomplementdarstellung
               }
        bignum_;
typedef bignum_ *  Bignum;

# Single-Floats
typedef uint32 ffloat; # 32-Bit-Float im IEEE-Format
typedef union { ffloat explicit_;     # Wert, explizit
                #ifdef FAST_FLOAT
                float machine_float; # Wert, als C-'float'
                #endif
              }
        ffloatjanus;
#ifndef WIDE
typedef struct { VAROBJECT_HEADER            # Selbstpointer für GC
                 ffloatjanus representation; # Wert
               }
        ffloat_;
typedef ffloat_ *  Ffloat;
#define ffloat_value(obj)  (TheFfloat(obj)->float_value)
#else
# Der Float-Wert wird im Pointer selbst untergebracht, wie bei Short-Floats.
#define ffloat_value(obj)  ((ffloat)untype(obj))
#endif

# Double-Floats
typedef # 64-Bit-Float im IEEE-Format:
        #ifdef intQsize
          # Sign/Exponent/Mantisse
          uint64
        #else
          # Sign/Exponent/MantisseHigh und MantisseLow
          #if BIG_ENDIAN_P
            struct {uint32 semhi,mlo;}
          #else
            struct {uint32 mlo,semhi;}
          #endif
        #endif
        dfloat;
typedef union { dfloat explicit_;       # Wert, explizit
                #ifdef FAST_DOUBLE
                double machine_double; # Wert, als C-'double'
                #endif
              }
        dfloatjanus;
typedef struct { VAROBJECT_HEADER            # Selbstpointer für GC
                 dfloatjanus representation; # Wert
               }
        dfloat_;
typedef dfloat_ *  Dfloat;

# Single- und Double-Floats
  #define float_value  representation.explicit_

# Long-Floats
typedef struct { VAROBJECT_HEADER   # Selbstpointer für GC
                 uintC  len;        # Länge der Mantisse in Digits
                 uint32 expo;       # Exponent
                 uintD  data[unspecified]; # Mantisse
               }
        lfloat_;
typedef lfloat_ *  Lfloat;

# Simple-Array (umfaßt einfache eindimensionale Arrays:
# Simple-Bit-Vector, Simple-String, Simple-Vector)
typedef struct { VAROBJECT_HEADER # Selbstpointer für GC
                 uintL  length;   # Länge in Elementen
               }
        sarray_;
typedef sarray_ *  Sarray;

# Simple-Bit-Vektor
typedef struct { VAROBJECT_HEADER # Selbstpointer für GC
                 uintL  length;   # Länge in Bits
                 uint8  data[unspecified]; # Bits, in Bytes unterteilt
               }
        sbvector_;
typedef sbvector_ *  Sbvector;

# Simple-String
typedef struct { VAROBJECT_HEADER # Selbstpointer für GC
                 uintL  length;   # Länge in Bytes
                 uintB  data[unspecified]; # Characters
               }
        sstring_;
typedef sstring_ *  Sstring;

# Simple-Vector
typedef struct { VAROBJECT_HEADER # Selbstpointer für GC
                 uintL  length;   # Länge in Objekten
                 object data[unspecified]; # Elemente
               }
        svector_;
typedef svector_ *  Svector;

# nicht-simpler Array
typedef struct { VAROBJECT_HEADER  # Selbstpointer für GC
                 uintB flags;      # Flags
                                   # dann ein Byte unbenutzt
                 uintC rank;       # Rang n
                 object data;      # Datenvektor
                 uintL totalsize;  # Totalsize = Produkt der n Dimensionen
                 uintL dims[unspecified]; # evtl. displaced-offset,
                                   # n Dimensionen,
                                   # evtl. Fill-Pointer
               }
        array_;
typedef array_ *  Array;
#define array_data_offset  offsetof(array_,data)
# Bits in den Flags:
  #define arrayflags_adjustable_bit  7 # gesetzt, wenn Array adjustable
  #define arrayflags_fillp_bit       6 # gesetzt, wenn Fill-Pointer vorhanden (nur bei n=1 möglich)
  #define arrayflags_displaced_bit   5 # gesetzt, wenn Array displaced
  #define arrayflags_dispoffset_bit  4 # gesetzt, wenn Platz für den
                                       # Displaced-Offset vorhanden ist
                                       # (<==> Array adjustable oder displaced)
  #define arrayflags_notbytep_bit    3 # gelöscht bei Byte-Vektoren
  #define arrayflags_atype_mask  0x07  # Maske für Elementtyp
# Elementtypen von Arrays in Bits 2..0 der flags:
  # Die ersten sind so gewählt, daß 2^Atype_nBit = n ist.
  #define Atype_Bit          0         # arrayflags_notbytep_bit gesetzt!
  #define Atype_2Bit         1
  #define Atype_4Bit         2
  #define Atype_8Bit         3
  #define Atype_16Bit        4
  #define Atype_32Bit        5
  #define Atype_T            6         # arrayflags_notbytep_bit gesetzt!
  #define Atype_String_Char  7         # arrayflags_notbytep_bit gesetzt!

# liefert das immutable Pendant zu einem Array
#define make_imm_array(obj)  \
  as_object(as_oint(obj) | type_zero_oint(imm_array_mask))

# Records
# Simple-Records können bis zu 65535 Elemente haben,
# Extended-Records haben dagegen Platz für extra (nicht-Lisp) Elemente.
typedef struct { VAROBJECT_HEADER # Selbstpointer für GC
                 uintB recflags;  # bei OtherRecord: Flags
                 sintB rectype;   # bei OtherRecord: Untertyp
                 uintW recfiller; # Länge u.a.
                 object recdata[unspecified]; # Elemente
               }
        record_;
typedef record_ *  Record;
#define SRECORD_HEADER  \
                 VAROBJECT_HEADER # Selbstpointer für GC          \
                 uintB recflags;  # bei OtherRecord: Flags        \
                 sintB rectype;   # bei OtherRecord: Untertyp, <0 \
                 uintW reclength; # Länge in Objekten
typedef struct { SRECORD_HEADER
                 object recdata[unspecified]; # Elemente, reclength Stück
               }
        srecord_;
typedef srecord_ *  Srecord;
#define XRECORD_HEADER  \
                 VAROBJECT_HEADER  # Selbstpointer für GC           \
                 uintB recflags;   # bei OtherRecord: Flags         \
                 sintB rectype;    # bei OtherRecord: Untertyp, >=0 \
                 uintB reclength;  # Länge in Objekten              \
                 uintB recxlength; # Länge der Extra-Elemente
typedef struct { XRECORD_HEADER
                 object recdata[unspecified];  # Elemente, reclength Stück
               # uintB  recxdata[unspecified]; # Extra-Elemente, recxlength Stück
               }
        xrecord_;
typedef xrecord_ *  Xrecord;
# Elementtypen von OtherRecords:
  #define Rectype_Closure      -3
  #define Rectype_Structure    -2
  #define Rectype_Instance     -1
  #define Rectype_Hashtable     0
  #define Rectype_Package       1
  #define Rectype_Readtable     2
  #define Rectype_Pathname      3
  #define Rectype_Logpathname   4 # nur gebraucht, falls defined(LOGICAL_PATHNAMES)
  #define Rectype_Random_State  5
  #define Rectype_Stream        6 # nur gebraucht, falls !defined(case_stream)
  #define Rectype_Byte          7
  #define Rectype_Fsubr         8
  #define Rectype_Loadtimeeval  9
  #define Rectype_Symbolmacro  10
  #define Rectype_Fpointer     11 # nur gebraucht, falls defined(FOREIGN)
  #define Rectype_Faddress     12 # nur gebraucht, falls defined(DYNAMIC_FFI)
  #define Rectype_Fvariable    13 # nur gebraucht, falls defined(DYNAMIC_FFI)
  #define Rectype_Ffunction    14 # nur gebraucht, falls defined(DYNAMIC_FFI)
  #define Rectype_Finalizer    15
  #define Rectype_Socket_Server 16 # for SOCKET_STREAMS
  #ifdef YET_ANOTHER_RECORD
  #define Rectype_Yetanother   17
  #endif

# Packages
typedef struct { XRECORD_HEADER
                 object pack_external_symbols;
                 object pack_internal_symbols;
                 object pack_shadowing_symbols;
                 object pack_use_list;
                 object pack_used_by_list;
                 object pack_name;
                 object pack_nicknames;
               }
        *  Package;
#define package_length  ((sizeof(*(Package)0)-offsetofa(record_,recdata))/sizeof(object))
# Mit gelöschten Packages darf man nichts anstellen.
  #define mark_pack_deleted(obj)  ThePackage(obj)->recflags |= bit(7)
  #define pack_deletedp(obj)  (!((ThePackage(obj)->recflags & bit(7)) == 0))

# Hash-Tables
typedef struct { XRECORD_HEADER
                 #ifdef GENERATIONAL_GC
                 object ht_lastrehash;
                 #endif
                 object ht_size;
                 object ht_maxcount;
                 object ht_itable;
                 object ht_ntable;
                 object ht_kvtable;
                 object ht_freelist;
                 object ht_count;
                 object ht_rehash_size;
                 object ht_mincount_threshold;
                 object ht_mincount;
               }
        *  Hashtable;
#define hashtable_length  ((sizeof(*(Hashtable)0)-offsetofa(record_,recdata))/sizeof(object))
# Markiere eine Hash-Table als neu zu reorganisieren:
# mark_ht_invalid(TheHashtable(ht));
  #ifdef GENERATIONAL_GC
    #define mark_ht_invalid(ptr)  (ptr)->ht_lastrehash = unbound
    #define mark_ht_valid(ptr)  (ptr)->ht_lastrehash = O(gc_count)
    #define ht_validp(ptr)  eq((ptr)->ht_lastrehash,O(gc_count))
  #else
    #define mark_ht_invalid(ptr)  (ptr)->recflags |= bit(7)
    #define mark_ht_valid(ptr)  (ptr)->recflags &= ~bit(7)
    #define ht_validp(ptr)  (((ptr)->recflags & bit(7)) == 0)
  #endif

# Readtables
typedef struct { XRECORD_HEADER
                 object readtable_syntax_table;
                 object readtable_macro_table;
                 object readtable_case;
               }
        *  Readtable;
#define readtable_length  ((sizeof(*(Readtable)0)-offsetofa(record_,recdata))/sizeof(object))

# Pathnames
typedef struct { XRECORD_HEADER
                 #if HAS_HOST
                   object pathname_host;
                 #endif
                 #if HAS_DEVICE
                   object pathname_device;
                 #endif
                 #if 1
                   object pathname_directory;
                   object pathname_name;
                   object pathname_type;
                 #endif
                 #if HAS_VERSION
                   object pathname_version;
                 #endif
               }
        *  Pathname;
#define pathname_length  ((sizeof(*(Pathname)0)-offsetofa(record_,recdata))/sizeof(object))

#ifdef LOGICAL_PATHNAMES
# Logical Pathnames
typedef struct { XRECORD_HEADER
                 object pathname_host;
                 object pathname_directory;
                 object pathname_name;
                 object pathname_type;
                 object pathname_version;
               }
        *  Logpathname;
#define logpathname_length  ((sizeof(*(Logpathname)0)-offsetofa(record_,recdata))/sizeof(object))
#endif

# Random-States
typedef struct { XRECORD_HEADER
                 object random_state_seed;
               }
        *  Random_state;
#define random_state_length  ((sizeof(*(Random_state)0)-offsetofa(record_,recdata))/sizeof(object))

# Bytes
typedef struct { XRECORD_HEADER
                 object byte_size;
                 object byte_position;
               }
        *  Byte;
#define byte_length  ((sizeof(*(Byte)0)-offsetofa(record_,recdata))/sizeof(object))

# Fsubrs
typedef struct { XRECORD_HEADER
                 object name;
                 object argtype;
                 object function;
               }
        *  Fsubr;
#define fsubr_length  ((sizeof(*(Fsubr)0)-offsetofa(record_,recdata))/sizeof(object))

# Load-time-evals
typedef struct { XRECORD_HEADER
                 object loadtimeeval_form;
               }
        *  Loadtimeeval;
#define loadtimeeval_length  ((sizeof(*(Loadtimeeval)0)-offsetofa(record_,recdata))/sizeof(object))

# Symbol-macros
typedef struct { XRECORD_HEADER
                 object symbolmacro_expansion;
               }
        *  Symbolmacro;
#define symbolmacro_length  ((sizeof(*(Symbolmacro)0)-offsetofa(record_,recdata))/sizeof(object))

#ifdef FOREIGN
# Foreign-Pointer-Verpackung
typedef struct { XRECORD_HEADER
                 void* fp_pointer;
               }
        *  Fpointer;
#define fpointer_length  0
#define fpointer_xlength  (sizeof(*(Fpointer)0)-offsetofa(record_,recdata)-fpointer_length*sizeof(object))
#define mark_fp_invalid(ptr)  (ptr)->recflags |= bit(7)
#define mark_fp_valid(ptr)  (ptr)->recflags &= ~bit(7)
#define fp_validp(ptr)  (((ptr)->recflags & bit(7)) == 0)
#else
#define mark_fp_invalid(ptr)
#endif

#ifdef DYNAMIC_FFI

# Foreign-Adressen
typedef struct { XRECORD_HEADER
                 object fa_base;
                 uintP fa_offset;
               }
        * Faddress;
#define faddress_length  1
#define faddress_xlength  (sizeof(*(Faddress)0)-offsetofa(record_,recdata)-faddress_length*sizeof(object))

# Foreign-Variables
typedef struct { XRECORD_HEADER
                 object fv_name;
                 object fv_address;
                 object fv_size;
                 object fv_type;
               }
        * Fvariable;
#define fvariable_length  ((sizeof(*(Fvariable)0)-offsetofa(record_,recdata))/sizeof(object))

# Foreign-Functions
typedef struct { XRECORD_HEADER
                 object ff_name;
                 object ff_address;
                 object ff_resulttype;
                 object ff_argtypes;
                 object ff_flags;
               }
        * Ffunction;
#define ffunction_length  ((sizeof(*(Ffunction)0)-offsetofa(record_,recdata))/sizeof(object))

#endif

# Finalisierer
typedef struct { XRECORD_HEADER
                 object fin_alive;    # nur solange dieses Objekt lebt
                 object fin_trigger;  # der Tod dieses Objekts wird abgewartet
                 object fin_function; # dann wird diese Funktion aufgerufen
                 object fin_cdr;
               }
        * Finalizer;
#define finalizer_length  ((sizeof(*(Finalizer)0)-offsetofa(record_,recdata))/sizeof(object))

#ifdef SOCKET_STREAMS
# Socket-Server
typedef struct { XRECORD_HEADER
                 object socket_handle; # socket handle
                 object port; # port number
               }
        * Socket_server;
#define socket_server_length  ((sizeof(*(Socket_server)0)-offsetofa(record_,recdata))/sizeof(object))
#endif

#ifdef YET_ANOTHER_RECORD

# Yet another record
typedef struct { XRECORD_HEADER
                 object yetanother_x;
                 object yetanother_y;
                 object yetanother_z;
               }
        * Yetanother;
#define yetanother_length  ((sizeof(*(Yetanother)0)-offsetofa(record_,recdata))/sizeof(object))

#endif

# Streams
typedef struct {
                 #ifdef case_stream
                 VAROBJECT_HEADER # Selbstpointer für GC
                 uintB strmflags; # Flags
                 uintB strmtype;  # Untertyp (als sintB >=0 !)
                 uintB reclength; # Länge in Objekten
                 uintB recxlength; # Länge der Extra-Elemente
                 #else
                 # Muß strmflags und strmtype aus Platzgründen in einem Fixnum
                 # in recdata[0] unterbringen.
                 #if !((oint_addr_len+oint_addr_shift>=24) && (8>=oint_addr_shift))
                 #error "No room for stream flags -- Stream-Flags neu unterbringen!!"
                 #endif
                 XRECORD_HEADER
                 uintB strmfiller1;
                 uintB strmflags; # Flags
                 uintB strmtype;  # Untertyp
                 uintB strmfiller2;
                 #endif
                 object strm_rd_by;
                 object strm_wr_by;
                 object strm_rd_ch;
                 object strm_rd_ch_last;
                 object strm_wr_ch;
                 object strm_wr_ch_lpos;
                 #ifdef STRM_WR_SS
                 object strm_wr_ss;
                 #endif
                 object strm_other[unspecified]; # typspezifische Komponenten
               }
        *  Stream;
#define strm_len  ((sizeof(*(Stream)0)-offsetofa(record_,recdata))/sizeof(object))
# Bitmaske in den Flags:
  #define strmflags_open_B   0xF0  # gibt an, ob der Stream offen ist
  #define strmflags_rd_ch_bit_B  6  # gesetzt, falls READ-CHAR möglich ist
  #define strmflags_wr_ch_bit_B  7  # gesetzt, falls WRITE-CHAR möglich ist
  #define strmflags_rd_ch_B  bit(strmflags_rd_ch_bit_B)
  #define strmflags_wr_ch_B  bit(strmflags_wr_ch_bit_B)
  #ifdef IMMUTABLE
  #define strmflags_immut_B  0x08  # gibt an, ob gelesene Objekte immutabel sind
  #endif
# Nähere Typinfo:
  enum { # Die Werte dieser Aufzählung sind der Reihe nach 0,1,2,...
                              enum_strmtype_sch_file,
  #define strmtype_sch_file   (uintB)enum_strmtype_sch_file
                              enum_strmtype_ch_file,
  #define strmtype_ch_file    (uintB)enum_strmtype_ch_file
                              enum_strmtype_iu_file,
  #define strmtype_iu_file    (uintB)enum_strmtype_iu_file
                              enum_strmtype_is_file,
  #define strmtype_is_file    (uintB)enum_strmtype_is_file
  #ifdef HANDLES
                              enum_strmtype_handle,
  #define strmtype_handle     (uintB)enum_strmtype_handle
  #endif
  #ifdef KEYBOARD
                              enum_strmtype_keyboard,
  #define strmtype_keyboard   (uintB)enum_strmtype_keyboard
  #endif
                              enum_strmtype_terminal,
  #define strmtype_terminal   (uintB)enum_strmtype_terminal
                              enum_strmtype_synonym,
  #define strmtype_synonym    (uintB)enum_strmtype_synonym
                              enum_strmtype_broad,
  #define strmtype_broad      (uintB)enum_strmtype_broad
                              enum_strmtype_concat,
  #define strmtype_concat     (uintB)enum_strmtype_concat
                              enum_strmtype_twoway,
  #define strmtype_twoway     (uintB)enum_strmtype_twoway
                              enum_strmtype_echo,
  #define strmtype_echo       (uintB)enum_strmtype_echo
                              enum_strmtype_str_in,
  #define strmtype_str_in     (uintB)enum_strmtype_str_in
                              enum_strmtype_str_out,
  #define strmtype_str_out    (uintB)enum_strmtype_str_out
                              enum_strmtype_str_push,
  #define strmtype_str_push   (uintB)enum_strmtype_str_push
                              enum_strmtype_pphelp,
  #define strmtype_pphelp     (uintB)enum_strmtype_pphelp
                              enum_strmtype_buff_in,
  #define strmtype_buff_in    (uintB)enum_strmtype_buff_in
                              enum_strmtype_buff_out,
  #define strmtype_buff_out   (uintB)enum_strmtype_buff_out
  #ifdef SCREEN
                              enum_strmtype_window,
  #define strmtype_window     (uintB)enum_strmtype_window
  #endif
  #ifdef PRINTER
                              enum_strmtype_printer,
  #define strmtype_printer    (uintB)enum_strmtype_printer
  #endif
  #ifdef PIPES
                              enum_strmtype_pipe_in,
  #define strmtype_pipe_in    (uintB)enum_strmtype_pipe_in
                              enum_strmtype_pipe_out,
  #define strmtype_pipe_out   (uintB)enum_strmtype_pipe_out
  #endif
  #ifdef XSOCKETS
                              enum_strmtype_xsocket,
  #define strmtype_xsocket     (uintB)enum_strmtype_xsocket
  #endif
  #ifdef GENERIC_STREAMS
                              enum_strmtype_generic,
  #define strmtype_generic    (uintB)enum_strmtype_generic
  #endif
  #ifdef SOCKET_STREAMS
                              enum_strmtype_socket,
  #define strmtype_socket     (uintB)enum_strmtype_socket
  #endif
                              enum_strmtype_dummy
  };
  # Bei Änderung dieser Tabelle auch
  # - die acht Sprungtabellen bei STREAM-ELEMENT-TYPE, INTERACTIVE-STREAM-P,
  #   CLOSE, LISTEN, CLEAR_INPUT, FINISH_OUTPUT, FORCE_OUTPUT, CLEAR_OUTPUT
  #   in STREAM.D und
  # - die Namenstabelle in CONSTOBJ.D und
  # - die Sprungtabelle bei PR_STREAM in IO.D und
  # - die Pseudofunktionentabelle in PSEUDOFUN.D
  # anpassen!
# weitere typspezifische Komponenten:
  #define strm_file_name       strm_other[3] # Filename, ein Pathname
  #define strm_file_truename   strm_other[4] # Truename, ein nicht-Logical Pathname
  #define strm_file_handle     strm_other[2] # Handle, ein Fixnum >=0, <2^16
  #define strm_sch_file_lineno strm_other[8] # Zeilennummer beim Lesen, ein Fixnum >0
  #define strm_synonym_symbol  strm_other[0]
  #define strm_broad_list      strm_other[0] # Liste von Streams
  #define strm_concat_list     strm_other[0] # Liste von Streams
  #define strm_pphelp_lpos     strm_wr_ch_lpos # Line Position (Fixnum>=0)
  #define strm_pphelp_strings  strm_other[0]   # Semi-Simple-Strings für Output
  #define strm_pphelp_modus    strm_other[1]   # Modus (NIL=Einzeiler, T=Mehrzeiler)
  #define strm_buff_in_fun     strm_other[0] # Lesefunktion
  #define strm_buff_out_fun    strm_other[0] # Ausgabefunktion
  #ifdef PIPES
  #define strm_pipe_pid        strm_other[3] # Prozeß-Id, ein Fixnum >=0
  #endif
  #ifdef XSOCKETS
  #define strm_xsocket_connect strm_other[3] # Liste (host display)
  #endif
  #ifdef GENERIC_STREAMS
  #define strm_controller_object strm_other[0] # Controller (meist CLOS-Instanz)
  #endif
  #ifdef SOCKET_STREAMS
  #define strm_socket_port strm_other[3]
  #define strm_socket_host strm_other[4]
  #endif
# wird verwendet von STREAM, PATHNAME, IO

# Structures
typedef Srecord  Structure;
  #define structure_types   recdata[0]

# CLOS-Klassen (= Instanzen von <class>), siehe clos.lsp
typedef struct { SRECORD_HEADER
                 object structure_types_2;   # Liste (metaclass <class>)
                 object metaclass;           # eine Subklasse von <class>
                 object classname;           # ein Symbol
                 object direct_superclasses; # direkte Oberklassen
                 object all_superclasses;    # alle Oberklassen inkl. sich selbst
                 object precedence_list;     # angeordnete Liste aller Oberklassen
                 object slot_location_table; # Hashtabelle Slotname -> wo der Slot sitzt
                 # ab hier nur bei metaclass = <standard-class>
                 object direct_slots;
                 object slots;
                 object instance_slot_count;
                 object shared_slots;
                 object direct_default_initargs;
                 object default_initargs;
                 object valid_initargs;
                 object other[unspecified];
               }
        *  Class;

# CLOS-Instanzen
typedef struct { SRECORD_HEADER
                 object class; # eine CLOS-Klasse
                 object other[unspecified];
               }
        *  Instance;

# Closures
typedef struct { SRECORD_HEADER
                 object clos_name;
                 object clos_codevec;
                 object other[unspecified];
               }
        *  Closure;
# interpretierte Closure:
typedef struct { SRECORD_HEADER
                 object clos_name;
                 object clos_form;
                 object clos_docstring;
                 object clos_body;
                 object clos_var_env;
                 object clos_fun_env;
                 object clos_block_env;
                 object clos_go_env;
                 object clos_decl_env;
                 object clos_vars;
                 object clos_varflags;
                 object clos_spec_anz;
                 object clos_req_anz;
                 object clos_opt_anz;
                 object clos_opt_inits;
                 object clos_key_anz;
                 object clos_keywords;
                 object clos_key_inits;
                 object clos_allow_flag;
                 object clos_rest_flag;
                 object clos_aux_anz;
                 object clos_aux_inits;
               }
        *  Iclosure;
#define iclos_length  ((sizeof(*(Iclosure)0)-offsetofa(record_,recdata))/sizeof(object))
# compilierte Closure:
typedef struct { SRECORD_HEADER
                 object clos_name;
                 object clos_codevec;
                 object clos_consts[unspecified]; # Closure-Konstanten
               }
        *  Cclosure;
#define clos_venv  clos_consts[0]
# Compilierte Closures, bei denen Bit 4 in den Flags von clos_codevec
# gesetzt ist, sind generische Funktionen.

# Eine compilierte LISP-Funktion bekommt ihre Argumente auf dem STACK
# und liefert ihre Werte im MULTIPLE_VALUE_SPACE. Als C-Funktion liefert
# sie keinen Wert.
  # Rückgabe von Multiple Values geschieht vollständig über den
  # MULTIPLE_VALUE_SPACE. Als C-Funktion: Ergebnistyp Values.
    #ifndef Values
    typedef void Values;
    #endif
  # Um einen Typ vom Wert Values weiterzureichen: return_Values(...);
    #define return_Values  return_void
  # Eine Lisp-Funktion ist ein Pointer auf eine C-Funktion ohne Rückgabewert
    typedef Values (*lisp_function)();
# Sollte dies geändert werden, so ist jeder Aufruf einer C-Funktion vom
# Ergebnistyp 'Values' (insbesondere 'funcall', 'apply', 'eval') zu überprüfen.

# FSUBRs
# Als C-Funktionen: vom Typ fsubr_function (keine Argumente, kein Wert):
  typedef Values fsubr_function (void);
# Die Adressen dieser C-Funktionen werden direkt angesprungen.
# Für SAVEMEM/LOADMEM gibt es eine Tabelle aller FSUBRs.
  typedef fsubr_function * fsubr_;
# Signatur von FSUBRs im Lisp-Sinne:
#         argtype          Kürzel für den Argumente-Typ     fsubr_argtype_
#         req_anz          Anzahl required Parameter        uintW
#         opt_anz          Anzahl optionaler Parameter      uintW
#         body_flag        Body-Flag                        fsubr_body_
# Die Komponente body_flag enthält ein uintW, gemeint ist aber:
  typedef enum { fsubr_nobody, fsubr_body } fsubr_body_;
# Die Komponente argtype enthält ein Fixnum, gemeint ist aber:
  typedef enum {
                fsubr_argtype_1_0_nobody,
                fsubr_argtype_2_0_nobody,
                fsubr_argtype_1_1_nobody,
                fsubr_argtype_2_1_nobody,
                fsubr_argtype_0_body,
                fsubr_argtype_1_body,
                fsubr_argtype_2_body
               }
          fsubr_argtype_;
# Umwandlung siehe SPVW:
# extern fsubr_argtype_ fsubr_argtype (uintW req_anz, uintW opt_anz, fsubr_body_ body_flag);

# SUBRs
# SUBR-Tabellen-Eintrag:
  typedef struct { lisp_function function; # Funktion
                   object name;            # Name
                   object keywords;        # NIL oder Vektor mit den Keywords
                   uintW argtype;          # Kürzel für den Argumente-Typ
                   uintW req_anz;          # Anzahl required Parameter
                   uintW opt_anz;          # Anzahl optionaler Parameter
                   uintB rest_flag;        # Flag für beliebig viele Argumente
                   uintB key_flag;         # Flag für Keywords
                   uintW key_anz;          # Anzahl Keywordparameter
                 }
          subr_;
  typedef subr_ *  Subr;
# GC benötigt Information, wo hierin Objekte stehen:
  #define subr_const_offset  offsetof(subr_,name)
  #define subr_const_anz     2
# Die Komponente rest_flag enthält ein uintB, gemeint ist aber:
  typedef enum { subr_norest, subr_rest } subr_rest_;
# Die Komponente key_flag enthält ein uintB, gemeint ist aber:
  typedef enum { subr_nokey, subr_key, subr_key_allow } subr_key_;
# Die Komponente argtype enthält ein uintW, gemeint ist aber:
  typedef enum {
                subr_argtype_0_0,
                subr_argtype_1_0,
                subr_argtype_2_0,
                subr_argtype_3_0,
                subr_argtype_4_0,
                subr_argtype_5_0,
                subr_argtype_6_0,
                subr_argtype_0_1,
                subr_argtype_1_1,
                subr_argtype_2_1,
                subr_argtype_3_1,
                subr_argtype_4_1,
                subr_argtype_0_2,
                subr_argtype_1_2,
                subr_argtype_2_2,
                subr_argtype_0_3,
                subr_argtype_0_4,
                subr_argtype_0_5,
                subr_argtype_0_0_rest,
                subr_argtype_1_0_rest,
                subr_argtype_2_0_rest,
                subr_argtype_3_0_rest,
                subr_argtype_0_0_key,
                subr_argtype_1_0_key,
                subr_argtype_2_0_key,
                subr_argtype_3_0_key,
                subr_argtype_4_0_key,
                subr_argtype_0_1_key,
                subr_argtype_1_1_key,
                subr_argtype_1_2_key
               }
          subr_argtype_;
# Umwandlung siehe SPVW:
# extern subr_argtype_ subr_argtype (uintW req_anz, uintW opt_anz, subr_rest_ rest_flag, subr_key_ key_flag);

# System-Pointer
  #define make_system(data)  \
    type_data_object(system_type, bit(oint_data_len-1) | bit(0) | ((bitm(oint_data_len)-1) & (data)))
# Alle solchen müssen in io.d:pr_system() eine spezielle print-Routine bekommen.

# Indikator für nicht vorhandenen Wert:
  #define unbound  make_system(0xFFFFFFUL)

# Indikator für nicht vorhandenes Objekt (nur intern verwendet):
  #define nullobj  type_pointer_object(machine_type,NULL) # = as_object((oint)0)

# Um auf die Komponenten eines Objekts zugreifen zu können, muß man erst
# die Typbits entfernen:
  #if !((oint_addr_shift==0) && (addr_shift==0))
    #define pointable(obj)  ((void*)upointer(obj))
  #else
    # Ist oint_addr_shift=0 und addr_shift=0, so braucht man nicht zu shiften.
    #if !(((tint_type_mask<<oint_type_shift) & addressbus_mask) == 0)
      #define pointable(obj)  \
        ((void*)((aint)as_oint(obj) & ((aint)oint_addr_mask | ~addressbus_mask)))
    #else
      # Ist ferner oint_type_mask von addressbus_mask disjunkt, so werden
      # sowieso keine Typbits auf den Adreßbus geschickt.
      # Also ist gar nichts zu tun:
      #define pointable(obj)  ((void*)as_oint(obj))
    #endif
  #endif

# Wenn man auf ein Objekt zugreifen will, das eine bekannte Typinfo hat,
# dessen gesetzte Typbits vom Adreßbus verschluckt werden (auf die
# Typbits, die =0 sind, kommt es nicht an), so kann man auf das 'untype'
# verzichten:
  #if defined(WIDE_STRUCT)
    #define type_pointable(type,obj)  ((void*)((obj).both.addr))
  #elif !((oint_addr_shift==0) && (addr_shift==0) && (((tint_type_mask<<oint_type_shift) & addressbus_mask) == 0))
    #if (addr_shift==0)
      #define type_pointable(type,obj)  \
        ((oint_addr_shift==0) && ((type_zero_oint(type) & addressbus_mask) == 0) \
         ? (void*)(aint)as_oint(obj)                                             \
         : (void*)(aint)pointable(obj)                                           \
        )
    #elif !(addr_shift==0)
      # Analog, nur dass der Macro 'optimized_upointer' die Rolle des Adreßbus übernimmt:
      #define type_pointable(type,obj)  \
        ((optimized_upointer(type_data_object(type,0)) == 0) \
         ? (void*)(aint)optimized_upointer(obj)              \
         : (void*)(aint)pointable(obj)                       \
        )
    #endif
  #else
    # Wenn pointable(obj) = obj, braucht auch type_pointable() nichts zu tun:
    #define type_pointable(type,obj)  ((void*)(aint)as_oint(obj))
  #endif

# Wenn man auf ein Objekt zugreifen will, das eine von mehreren bekannten
# Typinfos hat, kann man evtl. auf das 'untype' verzichten. Maßgeblich
# ist das OR der Typinfos.
  #define types_pointable(ORed_types,obj)  type_pointable(ORed_types,obj)

# TheCons(object) liefert das zu object äquivalente Cons.
# Die Information, daß es Cons darstellt, muß hineingesteckt werden.
# Analog die anderen Typumwandlungen.
  #define TheCons(obj)  ((Cons)(types_pointable(cons_type|imm_cons_type,obj)))
  #define TheRatio(obj)  ((Ratio)(types_pointable(ratio_type|bit(sign_bit_t),obj)))
  #define TheComplex(obj)  ((Complex)(type_pointable(complex_type,obj)))
  #define TheSymbol(obj)  ((Symbol)(type_pointable(symbol_type,obj)))
  #if (oint_symbolflags_shift==oint_type_shift)
  #define TheSymbolflagged(obj)  ((Symbol)(types_pointable(symbol_type|bit(active_bit)|bit(dynam_bit)|bit(svar_bit),obj)))
  #else
  #define TheSymbolflagged(obj)  TheSymbol(symbol_without_flags(obj))
  #endif
  #define TheBignum(obj)  ((Bignum)(types_pointable(bignum_type|bit(sign_bit_t),obj)))
  #ifndef WIDE
  #define TheFfloat(obj)  ((Ffloat)(types_pointable(ffloat_type|bit(sign_bit_t),obj)))
  #endif
  #define TheDfloat(obj)  ((Dfloat)(types_pointable(dfloat_type|bit(sign_bit_t),obj)))
  #define TheLfloat(obj)  ((Lfloat)(types_pointable(lfloat_type|bit(sign_bit_t),obj)))
  #define TheSarray(obj)  ((Sarray)(types_pointable(sbvector_type|imm_sbvector_type|sstring_type|imm_sstring_type|svector_type|imm_svector_type,obj)))
  #define TheSbvector(obj)  ((Sbvector)(types_pointable(sbvector_type|imm_sbvector_type,obj)))
  #define TheSstring(obj)  ((Sstring)(types_pointable(sstring_type|imm_sstring_type,obj)))
  #define TheSvector(obj)  ((Svector)(types_pointable(svector_type|imm_svector_type,obj)))
  #define TheArray(obj)  ((Array)(types_pointable(array_type|imm_array_type|bvector_type|imm_bvector_type|string_type|imm_string_type|vector_type|imm_vector_type,obj)))
  #define TheRecord(obj)  ((Record)(types_pointable(closure_type|structure_type|stream_type|orecord_type|instance_type,obj)))
  #define TheSrecord(obj)  ((Srecord)(types_pointable(closure_type|structure_type|orecord_type|instance_type,obj)))
  #define TheXrecord(obj)  ((Xrecord)(types_pointable(stream_type|orecord_type,obj)))
  #define ThePackage(obj)  ((Package)(type_pointable(orecord_type,obj)))
  #define TheHashtable(obj)  ((Hashtable)(type_pointable(orecord_type,obj)))
  #define TheReadtable(obj)  ((Readtable)(type_pointable(orecord_type,obj)))
  #define ThePathname(obj)  ((Pathname)(type_pointable(orecord_type,obj)))
  #ifdef LOGICAL_PATHNAMES
  #define TheLogpathname(obj)  ((Logpathname)(type_pointable(orecord_type,obj)))
  #endif
  #define The_Random_state(obj)  ((Random_state)(type_pointable(orecord_type,obj)))
  #define TheByte(obj)  ((Byte)(type_pointable(orecord_type,obj)))
  #define TheFsubr(obj)  ((Fsubr)(type_pointable(orecord_type,obj)))
  #define TheLoadtimeeval(obj)  ((Loadtimeeval)(type_pointable(orecord_type,obj)))
  #define TheSymbolmacro(obj)  ((Symbolmacro)(type_pointable(orecord_type,obj)))
  #ifdef FOREIGN
  #define TheFpointer(obj)  ((Fpointer)(type_pointable(orecord_type,obj)))
  #endif
  #ifdef DYNAMIC_FFI
  #define TheFaddress(obj)  ((Faddress)(type_pointable(orecord_type,obj)))
  #define TheFvariable(obj)  ((Fvariable)(type_pointable(orecord_type,obj)))
  #define TheFfunction(obj)  ((Ffunction)(type_pointable(orecord_type,obj)))
  #endif
  #define TheFinalizer(obj)  ((Finalizer)(type_pointable(orecord_type,obj)))
  #ifdef SOCKET_STREAMS
  #define TheSocketServer(obj) ((Socket_server)(type_pointable(orecord_type,obj)))
  #endif
  #ifdef YET_ANOTHER_RECORD
  #define TheYetanother(obj)  ((Yetanother)(type_pointable(orecord_type,obj)))
  #endif
  #define TheStream(obj)  ((Stream)(type_pointable(stream_type,obj)))
  #define TheStructure(obj)  ((Structure)(type_pointable(structure_type,obj)))
  #define TheClass(obj)  ((Class)(type_pointable(structure_type,obj)))
  #define TheClosure(obj)  ((Closure)(type_pointable(closure_type,obj)))
  #define TheIclosure(obj)  ((Iclosure)(type_pointable(closure_type,obj)))
  #define TheCclosure(obj)  ((Cclosure)(type_pointable(closure_type,obj)))
  #define TheInstance(obj)  ((Instance)(type_pointable(instance_type,obj)))
  #define TheSubr(obj)  ((Subr)(type_pointable(subr_type,obj)))
  #define TheFramepointer(obj)  ((object*)(type_pointable(system_type,obj)))
  #define TheMachine(obj)  ((void*)(type_pointable(machine_type,obj)))
  #define ThePseudofun(obj)  ((Pseudofun)TheMachine(obj))
  #ifdef FOREIGN_HANDLE
  # Handle in Sbvector verpackt
  #define TheHandle(obj)  (*(Handle*)(&TheSbvector(obj)->data[0]))
  #else
  # Handle in Fixnum>=0 verpackt
  #define TheHandle(obj)  ((Handle)posfixnum_to_L(obj))
  #endif
  #ifdef IMMUTABLE
  # Read-Write-Zugriff auf immutable Objekte:
  #ifdef IMMUTABLE_ARRAY
  #define TheImmSvector(obj)  \
    ((Svector)(type_pointable(imm_svector_type, \
               objectplus(obj,-type_zero_oint(imm_array_mask)))))
  #define TheImmArray(obj)  \
    ((Array)(types_pointable(imm_sbvector_type|imm_sstring_type|imm_array_type|imm_bvector_type|imm_string_type|imm_vector_type, \
             objectplus(obj,-type_zero_oint(imm_array_mask)))))
  #endif
  #ifdef IMMUTABLE_CONS
  #define TheImmCons(obj)  \
    ((Cons)type_pointable(cons_type,objectplus(obj,type_zero_oint(cons_type)-type_zero_oint(imm_cons_type))))
  #endif
  #endif
  # Objekt variabler Länge:
  #define TheVarobject(obj)  \
    ((Varobject)                                                                               \
     (types_pointable                                                                          \
      (sbvector_type|sstring_type|svector_type|array_type|bvector_type|string_type|vector_type \
       |imm_sbvector_type|imm_sstring_type|imm_svector_type|imm_array_type|imm_bvector_type|imm_string_type|imm_vector_type \
       |closure_type|structure_type|stream_type|orecord_type|symbol_type                       \
       |bignum_type|ffloat_type|dfloat_type|lfloat_type|bit(sign_bit_t),                       \
       obj                                                                                     \
    )))
  # Objekt, das einen Pointer in den Speicher darstellt:
  #define ThePointer(obj)  \
    (types_pointable                                                                            \
     (sbvector_type|sstring_type|svector_type|array_type|bvector_type|string_type|vector_type   \
      |imm_sbvector_type|imm_sstring_type|imm_svector_type|imm_array_type|imm_bvector_type|imm_string_type|imm_vector_type \
      |closure_type|structure_type|stream_type|orecord_type|symbol_type|cons_type|imm_cons_type \
      |bignum_type|ffloat_type|dfloat_type|lfloat_type|ratio_type|complex_type|bit(sign_bit_t), \
      obj                                                                                       \
    ))

# Ein paar Abkürzungen:
  # Zugriff auf Objekte, die Conses sind:
    #define Car(obj)  (TheCons(obj)->car)
    #define Cdr(obj)  (TheCons(obj)->cdr)
  # Zugriff auf Objekte, die Symbole sind:

    # Macros concerning the current shallow binding:
    #define Symbol_symvalue(obj) (TheSymbol(obj)->symvalue)
    #define Symbolflagged_symvalue(obj) (TheSymbolflagged(obj)->symvalue)
    #define set_Symbol_symvalue(obj,val) ((TheSymbol(obj)->symvalue)=(val))
    #define set_Symbolflagged_symvalue(obj,val) ((TheSymbolflagged(obj)->symvalue)=(val))

    # Macros that serve as the normal interface for accessing symbol values:
    #define Symbol_value Symbol_symvalue
    #define set_Symbol_value(obj,val) ((TheSymbol(obj)->symvalue)=(val))
    #define Symbolflagged_value Symbolflagged_symvalue
    #ifndef DYNBIND_LIST
    #define set_Symbolflagged_value_on(obj,val,frameptr) ((TheSymbolflagged(obj)->symvalue)=(val))
    #define set_Symbolflagged_value_off(obj,val) ((TheSymbolflagged(obj)->symvalue)=(val))
    #else
    extern void set_Symbolflagged_value_on(object sym,object val,object *frameptr);
    extern void set_Symbolflagged_value_off(object sym,object val);
    extern void add_frame_to_binding_list(object *stackptr);
    extern void delete_frame_from_binding_list(object *stackptr);
    #endif

    #define Symbol_function(obj)  (TheSymbol(obj)->symfunction)
    #define Symbol_plist(obj)  (TheSymbol(obj)->proplist)
    #define Symbol_name(obj)  (TheSymbol(obj)->pname)
    #define Symbol_package(obj)  (TheSymbol(obj)->homepackage)
  # Länge (Anzahl Objekte) eines Record:
    #define Record_length(obj)  \
      (TheRecord(obj)->rectype < 0 ? TheSrecord(obj)->reclength : TheXrecord(obj)->reclength)


# ####################### Typtestprädikate ################################ #
# Die gibt es in zwei Formen:
# 1.  ???p, mit 'if' abzufragen:  if ???p(object)
# 2.  if_???p, aufzurufen als
#         if_???p(object, statement1, statement2)
#       statt
#         if ???p(object) statement1 else statement2

# UP: testet auf Pointergleichheit EQ
# eq(obj1,obj2)
# > obj1,obj2: Lisp-Objekte
# < ergebnis: TRUE, falls Objekte gleich
  #if defined(WIDE_STRUCT) || defined(OBJECT_STRUCT)
    #define eq(obj1,obj2)  (as_oint(obj1) == as_oint(obj2))
  #else
    #define eq(obj1,obj2)  ((obj1) == (obj2))
  #endif

# Test auf NIL
  #define nullp(obj)  (eq(obj,NIL))
  #define sym_nullp(sym) nullp(Symbol_symvalue(sym))

# Test auf Cons
  #if defined(cons_bit_o) /* || defined(IMMUTABLE_CONS) */
    # define consp(obj)  (as_oint(obj) & wbit(cons_bit_o))
    #define consp(obj)  (wbit_test(as_oint(obj),cons_bit_o))
    #ifdef fast_mtypecode
      #ifdef WIDE_STRUCT
        #undef consp
        #define consp(obj)  (typecode(obj) & bit(cons_bit_t))
      #endif
      #define mconsp(obj)  (mtypecode(obj) & bit(cons_bit_t))
    #else
      #define mconsp(obj)  consp(obj)
    #endif
  #else
    #define consp(obj)  ((typecode(obj) & ~imm_cons_mask) == cons_type)
    #define mconsp(obj)  ((mtypecode(obj) & ~imm_cons_mask) == cons_type)
  #endif

# Test auf Atom
  #if defined(cons_bit_o) /* || defined(IMMUTABLE_CONS) */
    # define atomp(obj)  ((as_oint(obj) & wbit(cons_bit_o))==0)
    #define atomp(obj)  (!wbit_test(as_oint(obj),cons_bit_o))
    #ifdef fast_mtypecode
      #ifdef WIDE_STRUCT
        #undef atomp
        #define atomp(obj)  ((typecode(obj) & bit(cons_bit_t))==0)
      #endif
      #define matomp(obj)  ((mtypecode(obj) & bit(cons_bit_t))==0)
    #else
      #define matomp(obj)  atomp(obj)
    #endif
  #else
    #define atomp(obj)  (!((typecode(obj) & ~imm_cons_mask) == cons_type))
    #define matomp(obj)  (!((mtypecode(obj) & ~imm_cons_mask) == cons_type))
  #endif

# Test auf Liste, obj sollte eine Variable sein
  #define listp(obj)  (nullp(obj) || consp(obj))

# Test auf Symbol
  #if defined(symbol_bit_o)
    # define symbolp(obj)  (as_oint(obj) & wbit(symbol_bit_o))
    #define symbolp(obj)  (wbit_test(as_oint(obj),symbol_bit_o))
    #ifdef fast_mtypecode
      #ifdef WIDE_STRUCT
        #undef symbolp
        #define symbolp(obj)  (typecode(obj) & bit(symbol_bit_t))
      #endif
      #define msymbolp(obj)  (mtypecode(obj) & bit(symbol_bit_t))
    #else
      #define msymbolp(obj)  symbolp(obj)
    #endif
  #else
    #define symbolp(obj)  (typecode(obj) == symbol_type)
    #define msymbolp(obj)  (mtypecode(obj) == symbol_type)
  #endif

# Test auf Zahl
  # define numberp(obj)  (as_oint(obj) & wbit(number_bit_o))
  #define numberp(obj)  (wbit_test(as_oint(obj),number_bit_o))
  #ifdef fast_mtypecode
    #ifdef WIDE_STRUCT
      #undef numberp
      #define numberp(obj)  (typecode(obj) & bit(number_bit_t))
    #endif
    #define mnumberp(obj)  (mtypecode(obj) & bit(number_bit_t))
  #else
    #define mnumberp(obj)  numberp(obj)
  #endif

# Test auf Vector (Typbytes %001,%010,%011,%101,%110,%111)
  #if 0
    #define if_vectorp(obj,statement1,statement2)  \
      {var reg2 object obj_from_if_vectorp = (obj);                          \
       var reg1 tint type_from_if_vectorp = typecode(obj_from_if_vectorp) & !imm_array_mask; \
       type_from_if_vectorp = type_from_if_vectorp & ~bit(notsimple_bit_t);  \
       if (!(type_from_if_vectorp==0)&&(type_from_if_vectorp<=svector_type)) \
         { statement1 } else { statement2 }                                  \
      }
  #else # effizienter
    #define if_vectorp(obj,statement1,statement2)  \
      if (vectorp(obj)) { statement1 } else { statement2 }
  #endif
  #define vectorp(obj)  \
    ((tint)((typecode(obj) & ~imm_array_mask & ~bit(notsimple_bit_t))-1) <= (tint)(svector_type-1))
  #define mvectorp(obj)  \
    ((tint)((mtypecode(obj) & ~imm_array_mask & ~bit(notsimple_bit_t))-1) <= (tint)(svector_type-1))

# Test auf simple-vector oder simple-bit-vector oder simple-string
  #if 0
    #define if_simplep(obj,statement1,statement2)  \
      {var reg2 object obj_from_if_simplep = (obj);                          \
       var reg1 tint type_from_if_simplep = typecode(obj_from_if_simplep) & ~imm_array_mask; \
       if (!(type_from_if_simplep==0)&&(type_from_if_simplep<=svector_type)) \
         { statement1 } else { statement2 }                                  \
      }
  #else # effizienter
    #define if_simplep(obj,statement1,statement2)  \
      if (simplep(obj)) { statement1 } else { statement2 }
  #endif
  #define simplep(obj)  \
    ((tint)((typecode(obj) & ~imm_array_mask) - 1) <= (tint)(svector_type-1))

# Test eines Array auf simple-vector oder simple-bit-vector oder simple-string
  #define array_simplep(obj)  \
    ((typecode(obj) & ~imm_array_mask) <= svector_type)

# Test auf simple-vector
  #define simple_vector_p(obj)  \
    ((typecode(obj) & ~imm_array_mask) == svector_type)
  #define m_simple_vector_p(obj)  \
    ((mtypecode(obj) & ~imm_array_mask) == svector_type)

# Test auf general-vector=(vector t)
  #define general_vector_p(obj)  \
    ((typecode(obj) & ~imm_array_mask & ~bit(notsimple_bit_t)) == svector_type)
  #define m_general_vector_p(obj)  \
    ((mtypecode(obj) & ~imm_array_mask & ~bit(notsimple_bit_t)) == svector_type)

# Test auf simple-string
  #define simple_string_p(obj)  \
    ((typecode(obj) & ~imm_array_mask) == sstring_type)
  #define m_simple_string_p(obj)  \
    ((mtypecode(obj) & ~imm_array_mask) == sstring_type)

# Test auf string
  #define stringp(obj)  \
    ((typecode(obj) & ~imm_array_mask & ~bit(notsimple_bit_t)) == sstring_type)
  #define mstringp(obj)  \
    ((mtypecode(obj) & ~imm_array_mask & ~bit(notsimple_bit_t)) == sstring_type)

# Test auf simple-bit-vector
  #define simple_bit_vector_p(obj)  \
    ((typecode(obj) & ~imm_array_mask) == sbvector_type)
  #define m_simple_bit_vector_p(obj)  \
    ((mtypecode(obj) & ~imm_array_mask) == sbvector_type)

# Test auf bit-vector
  #define bit_vector_p(obj)  \
    (((typecode(obj) & ~imm_array_mask) == sbvector_type)                 \
     || (((typecode(obj) & ~imm_array_mask) == bvector_type)              \
         && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_Bit) \
    )   )
  #define m_bit_vector_p(obj)  \
    (((mtypecode(obj) & ~imm_array_mask) == sbvector_type)                \
     || (((mtypecode(obj) & ~imm_array_mask) == bvector_type)             \
         && ((TheArray(obj)->flags & arrayflags_atype_mask) == Atype_Bit) \
    )   )

# Test auf Array allgemein
  #if 0
    #define if_arrayp(obj,statement1,statement2)  \
      {var reg2 object obj_from_if_arrayp = (obj);                        \
       var reg1 tint type_from_if_arrayp = typecode(obj_from_if_arrayp) & ~imm_array_mask; \
       if (!(type_from_if_arrayp==0)&&(type_from_if_arrayp<=vector_type)) \
         { statement1 } else { statement2 }                               \
      }
  #else # effizienter
    #define if_arrayp(obj,statement1,statement2)  \
      if (arrayp(obj)) { statement1 } else { statement2 }
  #endif
  #define arrayp(obj)  \
    ((tint)((typecode(obj) & ~imm_array_mask) - 1) <= (tint)(vector_type-1))

# Test auf Array, der kein Vector ist (Typbyte %100)
  #define array1p(obj)  \
    ((typecode(obj) & ~imm_array_mask) == array_type)
  #define marray1p(obj)  \
    ((mtypecode(obj) & ~imm_array_mask) == array_type)

# Test auf Closure/Structure/Stream/Instanz/OtherRecord
  #define if_recordp(obj,statement1,statement2)  \
    { switch (typecode(obj))              \
        { case_record: statement1; break; \
          default: statement2; break;     \
    }   }
  #define if_mrecordp(obj,statement1,statement2)  \
    { switch (mtypecode(obj))             \
        { case_record: statement1; break; \
          default: statement2; break;     \
    }   }

# Test auf Closure
  #define closurep(obj)  (typecode(obj)==closure_type)
  #define mclosurep(obj)  (mtypecode(obj)==closure_type)

# Test auf compilierte Closure
  # In einer Closure ist die zweite Komponente
  # entweder eine Liste (der Lambdabody bei interpretierten Closures)
  # oder ein Simple-Bit-Vector (der Codevektor bei compilierten Closures).
  #define cclosurep(obj)  \
    (closurep(obj) && m_simple_bit_vector_p(TheClosure(obj)->clos_codevec))

# Test auf generische Funktion, obj sollte eine Variable sein
  #define genericfunctionp(obj)  \
    (cclosurep(obj)                                                         \
     && (TheSbvector(TheClosure(obj)->clos_codevec)->data[CCHD+4] & bit(4)) \
    )

# Test auf CLOS-Instanz
  #define instancep(obj)  (typecode(obj)==instance_type)
  #define minstancep(obj)  (mtypecode(obj)==instance_type)

# Test auf CLOS-Klasse, obj sollte eine Variable sein.
# Unser CLOS implementiert alle Klassen als Instanzen einer direkten
# Unterklasse von <class>.
  #define classp(obj)  \
    (structurep(obj)                                                         \
     && eq(Cdr(TheStructure(obj)->structure_types),O(class_structure_types)) \
    )

# Test auf Structure, obj sollte eine Variable sein??
  #ifdef case_structure
    #define structurep(obj)  (typecode(obj)==structure_type)
    #define mstructurep(obj)  (mtypecode(obj)==structure_type)
  #else
    #define structurep(obj)  \
      (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Structure))
    #define mstructurep(obj)  \
      (morecordp(obj) && (TheRecord(obj)->rectype == Rectype_Structure))
  #endif

# Test auf Stream, obj sollte eine Variable sein??
  #ifdef case_stream
    #define streamp(obj)  (typecode(obj)==stream_type)
    #define mstreamp(obj)  (mtypecode(obj)==stream_type)
  #else
    #define streamp(obj)  \
      (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Stream))
    #define mstreamp(obj)  \
      (morecordp(obj) && (TheRecord(obj)->rectype == Rectype_Stream))
  #endif
  #define sym_streamp(sym) mtypecode(Symbol_symvalue(sym))

# Test, ob ein Stream vom Typ gebufferter File-Stream ist:
  #define if_strm_bfile_p(strm,statement1,statement2)  \
    switchu (TheStream(strm)->strmtype) \
      { case strmtype_sch_file:        \
        case strmtype_ch_file:         \
        case strmtype_iu_file:         \
        case strmtype_is_file:         \
          statement1; break;           \
        default:                       \
          statement2; break;           \
      }
# wird verwendet von STREAM

# Test, ob ein Stream vom Typ File-Stream ist:
  #ifdef HANDLES
    #define case_strmtype_file  \
      case strmtype_sch_file:   \
      case strmtype_ch_file:    \
      case strmtype_iu_file:    \
      case strmtype_is_file:    \
      case strmtype_handle
  #else
    #define case_strmtype_file  \
      case strmtype_sch_file:   \
      case strmtype_ch_file:    \
      case strmtype_iu_file:    \
      case strmtype_is_file
  #endif
  #define if_strm_file_p(strm,statement1,statement2)  \
    switchu (TheStream(strm)->strmtype) \
      { case_strmtype_file:             \
          statement1; break;            \
        default:                        \
          statement2; break;            \
      }
# wird verwendet von PATHNAME

# Test auf Other-Record
  #define orecordp(obj)  (typecode(obj)==orecord_type)
  #define morecordp(obj)  (mtypecode(obj)==orecord_type)
  #define sym_orecordp(sym) (morecordp(Symbol_symvalue(sym)))

# Test auf Package, obj sollte eine Variable sein
  #define packagep(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Package))

# Test auf Hash-Table, obj sollte eine Variable sein
  #define hash_table_p(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Hashtable))

# Test auf Readtable, obj sollte eine Variable sein
  #define readtablep(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Readtable))
  #define mreadtablep(obj) \
    (morecordp(obj) && (TheRecord(obj)->rectype == Rectype_Readtable))
  #define sym_readtablep(sym) mreadtablep(Symbol_symvalue(sym))

# Test auf Pathname, obj sollte eine Variable sein
  #define pathnamep(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Pathname))

# Test auf Logical Pathname, obj sollte eine Variable sein
#ifdef LOGICAL_PATHNAMES
  #define logpathnamep(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Logpathname))
#else
  #define logpathnamep(obj)  FALSE
#endif

# Test auf Extended Pathname (d.h. Pathname oder Logical Pathname),
# obj sollte eine Variable sein
# define xpathnamep(obj)  (pathnamep(obj) || logpathnamep(obj))
#ifdef LOGICAL_PATHNAMES
  #define xpathnamep(obj)  \
    (orecordp(obj)                                           \
     && ((TheRecord(obj)->rectype == Rectype_Pathname)       \
         || (TheRecord(obj)->rectype == Rectype_Logpathname) \
    )   )
#else
  #define xpathnamep(obj)  pathnamep(obj)
#endif

# Test auf Random-State, obj sollte eine Variable sein
  #define random_state_p(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Random_State))

# Test auf Byte, obj sollte eine Variable sein
  #define bytep(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Byte))

# Test auf Fsubr, obj sollte eine Variable sein
  #define fsubrp(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Fsubr))

# Test auf Loadtimeeval, obj sollte eine Variable sein
  #define loadtimeevalp(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Loadtimeeval))

# Test auf Symbolmacro, obj sollte eine Variable sein
  #define symbolmacrop(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Symbolmacro))
  #define msymbolmacrop(obj) \
    (morecordp(obj) && (TheRecord(obj)->rectype == Rectype_Symbolmacro))
  #define sym_symbolmacrop(sym) msymbolmacrop(Symbol_symvalue(sym))
    
# Test auf Fpointer, obj sollte eine Variable sein
  #define fpointerp(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Fpointer))

# Test auf Faddress, obj sollte eine Variable sein
  #define faddressp(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Faddress))

# Test auf Fvariable, obj sollte eine Variable sein
  #define fvariablep(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Fvariable))

# Test auf Ffunction, obj sollte eine Variable sein
#ifdef DYNAMIC_FFI
  #define ffunctionp(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Ffunction))
#else
  #define ffunctionp(obj)  ((obj), 0)
#endif

#ifdef SOCKET_STREAMS
  #define socket_server_p(obj)  \
      (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Socket_Server))
#endif

#ifdef YET_ANOTHER_RECORD
# Test auf Yetanother, obj sollte eine Variable sein
  #define yetanotherp(obj)  \
    (orecordp(obj) && (TheRecord(obj)->rectype == Rectype_Yetanother))
#endif

# Test auf Character
  #define charp(obj)  (typecode(obj)==char_type)
  #define mcharp(obj)  (mtypecode(obj)==char_type)

# Test auf String-Char
  #define string_char_p(obj)  \
    ((as_oint(obj) & ~(((oint)char_code_mask_c)<<oint_data_shift)) == type_zero_oint(char_type))

# Test auf SUBR (compiliertes funktionales Objekt)
  #define subrp(obj)  (typecode(obj)==subr_type)
  #define msubrp(obj)  (mtypecode(obj)==subr_type)

# Test auf STACK-Environment-Pointer
  #define stack_env_p(obj)  (typecode(obj)==system_type) # andere Fälle??

# Test auf Systeminterne Konstante
  #define systemp(obj)  (typecode(obj)==system_type) # andere Fälle??

# Test auf reelle Zahl
  #define if_realp(obj,statement1,statement2)  \
    {var reg1 object obj_from_if_realp = (obj);                      \
     var reg1 tint type_from_if_realp = typecode(obj_from_if_realp); \
     if ( (type_from_if_realp & bit(number_bit_t))                   \
          && !(type_from_if_realp==complex_type) )                   \
       { statement1 } else { statement2 }                            \
    }

# Test auf rationale Zahl
  #define if_rationalp(obj,statement1,statement2)  \
    {var reg1 object obj_from_if_rationalp = (obj);                          \
     var reg1 tint type_from_if_rationalp = typecode(obj_from_if_rationalp); \
     if ( (!(type_from_if_rationalp==complex_type))                          \
          &&                                                                 \
          ((type_from_if_rationalp &                                         \
            ~((fixnum_type|bignum_type|ratio_type|bit(sign_bit_t)) & ~fixnum_type) \
           ) == fixnum_type                                                  \
        ) )                                                                  \
       { statement1 } else { statement2 }                                    \
    }

# Test auf ganze Zahl
  #define integerp(obj)  \
    ((typecode(obj) &                                             \
      ~((fixnum_type|bignum_type|bit(sign_bit_t)) & ~fixnum_type) \
     ) == fixnum_type                                             \
    )
  #define mintegerp(obj)  \
    ((mtypecode(obj) &                                            \
      ~((fixnum_type|bignum_type|bit(sign_bit_t)) & ~fixnum_type) \
     ) == fixnum_type                                             \
    )

# Test auf Fixnum
  #define fixnump(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == fixnum_type)
  #define mfixnump(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == fixnum_type)

# Test auf Fixnum >=0
  #define posfixnump(obj)  (typecode(obj) == fixnum_type)
  #define mposfixnump(obj)  (mtypecode(obj) == fixnum_type)
  #define sym_posfixnump(sym) mposfixnump(Symbol_symvalue(sym))

# Test auf Bignum
  #define bignump(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == bignum_type)
  #define mbignump(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == bignum_type)

# Test auf Ratio
  #define ratiop(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == ratio_type)
  #define mratiop(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == ratio_type)

# Test auf Float
  #define floatp(obj)  \
    ((typecode(obj) &  \
     ~((sfloat_type|ffloat_type|dfloat_type|lfloat_type|bit(sign_bit_t)) & ~sfloat_type) \
     ) == sfloat_type)
  #define mfloatp(obj)  \
    ((mtypecode(obj) &  \
     ~((sfloat_type|ffloat_type|dfloat_type|lfloat_type|bit(sign_bit_t)) & ~sfloat_type) \
     ) == sfloat_type)

# Test auf Short-Float
  #define short_float_p(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == sfloat_type)
  #define m_short_float_p(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == sfloat_type)

# Test auf Single-Float
  #define single_float_p(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == ffloat_type)
  #define m_single_float_p(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == ffloat_type)

# Test auf Double-Float
  #define double_float_p(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == dfloat_type)
  #define m_double_float_p(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == dfloat_type)

# Test auf Long-Float
  #define long_float_p(obj)  ((typecode(obj) & ~bit(sign_bit_t)) == lfloat_type)
  #define m_long_float_p(obj)  ((mtypecode(obj) & ~bit(sign_bit_t)) == lfloat_type)

# Test auf Complex
  #define complexp(obj)  (typecode(obj) == complex_type)
  #define mcomplexp(obj)  (mtypecode(obj) == complex_type)

# Test einer reellen Zahl, ob sie >=0 ist:
  # define positivep(obj)  ((as_oint(obj) & wbit(sign_bit_o)) == 0)
  #define positivep(obj)  (!wbit_test(as_oint(obj),sign_bit_o))
  #ifdef fast_mtypecode
    #ifdef WIDE_STRUCT
      #undef positivep
      #define positivep(obj)  ((typecode(obj) & bit(sign_bit_t)) == 0)
    #endif
    #define mpositivep(obj)  ((mtypecode(obj) & bit(sign_bit_t)) == 0)
  #else
    #define mpositivep(obj)  positivep(obj)
  #endif

# ################# Deklarationen zur Arithmetik ########################## #


# Typenhierarchie:
# Number (N) =
#    Real (R) =
#       Float (F) =
#          Short float (SF)
#          Single float (FF)
#          Double float (DF)
#          Long float (LF)
#       Rational (RA) =
#          Integer (I) =
#             Fixnum (FN)
#             Bignum (BN)
#          Ratio (RT)
#    Complex (C)


# Typfeld:
# Bits zum Testen, ob dieser Typ vorliegt (Bit gesetzt, wenn ja).
# _bit_t zum Test im Typbyte (tint)
# _bit_o zum Test im Objekt (oint)

# siehe oben:
# #define number_bit_t     4  # gesetzt nur bei Zahlen
# #define number_bit_o     (number_bit_t+oint_type_shift)    # gesetzt nur bei Zahlen

# float_bit:
# in einer Zahl: Bit gesetzt, falls es sich um ein Float handelt.
#                Bit gelöscht, falls es sich um eine rationale oder komplexe Zahl handelt.
# #define float_bit_t      1
# #define float_bit_o      (float_bit_t+oint_type_shift)

# float1_bit:
# In einem Floating-point: entscheidet genauer:
# Float-Bit   1 2
#             0 0    Short Float (SF)
#             0 1    Single Float (FF)
#             1 0    Double Float (DF)
#             1 1    Long Float (LF)
# #define float1_bit_t     3
# #define float1_bit_o     (float1_bit_t+oint_type_shift)
# #define float2_bit_t     2
# #define float2_bit_o     (float2_bit_t+oint_type_shift)

# ratio_bit:
# In rationalen Zahlen: Bit gesetzt, falls es sich um einen echten Bruch hand.
#                       Bit gelöscht, falls es sich um ein Integer handelt.
# #define ratio_bit_t      3
# #define ratio_bit_o      (ratio_bit_t+oint_type_shift)

# bignum_bit:
# In ganzen Zahlen: Bit gesetzt, falls es sich um ein Bignum handelt.
#                   Bit gelöscht, falls es sich um ein Fixnum handelt.
# #define bignum_bit_t     2
# #define bignum_bit_o     (bignum_bit_t+oint_type_shift)

# vorz_bit:
# Bei Reals:
# gibt das Vorzeichen der Zahl an.
# Bit gesetzt, falls Zahl < 0,
# Bit gelöscht, falls Zahl >=0.
  #define vorz_bit_t       sign_bit_t
                           # sollte = 0 sein, damit das Vorzeichen-Extend
                           # bei Fixnums einfacher geht.
  #define vorz_bit_o       (vorz_bit_t+oint_type_shift)

# Liefert das Vorzeichen einer reellen Zahl (0 falls >=0, -1 falls <0)
  #if (vorz_bit_o<32) && !defined(WIDE_STRUCT)
    #define R_sign(obj)  ((signean)sign_of_sint32( (sint32)((uint32)as_oint(obj) << (31-vorz_bit_o)) ))
  #else
    # define R_sign(obj)  ((signean)sign_of_sint32( (sint32)(uint32)(as_oint(obj) >> (vorz_bit_o-31)) ))
    #define R_sign(obj)  ((signean)sign_of_sint32( (sint32)((uint32)typecode(obj) << (31-vorz_bit_t)) ))
  #endif

# Stellt fest, ob zwei reelle Zahlen dasselbe Vorzeichen haben:
  #define same_sign_p(obj1,obj2)  \
    (wbit_test(as_oint(obj1)^as_oint(obj2),vorz_bit_o)==0)


# Typtestmacros:
# (Liefern /=0, falls erfüllt. Präfix 'm', wenn Argument im Speicher sitzt.)

# Testet ein Objekt, ob es eine Zahl ist: (siehe oben)
  # define numberp(obj)  (as_oint(obj) & wbit(number_bit_o))
  # define mnumberp(obj)  (mtypecode(obj) & bit(number_bit_t))

# Testet eine Zahl, ob es ein Float ist.
  # define N_floatp(obj)  (as_oint(obj) & wbit(float_bit_o))
  #define N_floatp(obj)  (wbit_test(as_oint(obj),float_bit_o))
  #define N_mfloatp(obj)  (mtypecode(obj) & bit(float_bit_t))

# Testet eine Zahl, ob es ein Integer ist.
  #define N_integerp(obj)  (!( as_oint(obj) & (wbit(float_bit_o)|wbit(ratio_bit_o)) ))
  #define N_mintegerp(obj)  (!( mtypecode(obj) & (bit(float_bit_t)|bit(ratio_bit_t)) ))

# Testet eine reelle Zahl, ob sie rational ist.
  # define R_rationalp(obj)  (!( as_oint(obj) & wbit(float_bit_o) ))
  #define R_rationalp(obj)  (!wbit_test(as_oint(obj),float_bit_o))
  #define R_mrationalp(obj)  (!( mtypecode(obj) & bit(float_bit_t) ))

# Testet eine reelle Zahl, ob sie ein Float ist.
  # define R_floatp(obj)  ( as_oint(obj) & wbit(float_bit_o) )
  #define R_floatp(obj)  (wbit_test(as_oint(obj),float_bit_o))
  #define R_mfloatp(obj)  ( mtypecode(obj) & bit(float_bit_t) )

# Testet eine reelle Zahl, ob sie <0 ist.
  # define R_minusp(obj)  ( as_oint(obj) & wbit(vorz_bit_o) )
  #define R_minusp(obj)  (wbit_test(as_oint(obj),vorz_bit_o))
  #define R_mminusp(obj)  ( mtypecode(obj) & bit(vorz_bit_t) )

# Testet eine rationale Zahl, ob sie ganz ist.
  # define RA_integerp(obj)  (!( as_oint(obj) & wbit(ratio_bit_o) ))
  #define RA_integerp(obj)  (!wbit_test(as_oint(obj),ratio_bit_o))
  #define RA_mintegerp(obj)  (!( mtypecode(obj) & bit(ratio_bit_t) ))

# Testet eine rationale Zahl, ob sie gebrochen ist.
  # define RA_ratiop(obj)  ( as_oint(obj) & wbit(ratio_bit_o) )
  #define RA_ratiop(obj)  (wbit_test(as_oint(obj),ratio_bit_o))
  #define RA_mratiop(obj)  ( mtypecode(obj) & bit(ratio_bit_t) )

# Testet eine ganze Zahl, ob sie ein Bignum ist.
  # define I_bignump(obj)  ( as_oint(obj) & wbit(bignum_bit_o) )
  #define I_bignump(obj)  (wbit_test(as_oint(obj),bignum_bit_o))
  #define I_mbignump(obj)  ( mtypecode(obj) & bit(bignum_bit_t) )

# Testet eine ganze Zahl, ob sie ein Fixnum ist.
  # define I_fixnump(obj)  (!( as_oint(obj) & wbit(bignum_bit_o) ))
  #define I_fixnump(obj)  (!wbit_test(as_oint(obj),bignum_bit_o))
  #define I_mfixnump(obj)  (!( mtypecode(obj) & bit(bignum_bit_t) ))

# Testet eine Zahl, ob sie eine reelle Zahl ist.
  #define N_realp(obj)  (!( typecode(obj) == complex_type ))
  #define N_mrealp(obj)  (!( mtypecode(obj) == complex_type ))

# Testet eine Zahl, ob sie eine komplexe Zahl ist.
  #define N_complexp(obj)  ( typecode(obj) == complex_type )
  #define N_mcomplexp(obj)  ( mtypecode(obj) == complex_type )

# Test auf ein Integer eines vorgegebenen Bereiches.
# obj sollte eine Variable sein
  #define uint8_p(obj)  \
    ((as_oint(obj) & ~((oint)0xFF << oint_data_shift)) == as_oint(Fixnum_0))
  #define sint8_p(obj)  \
    (((as_oint(obj) ^ (positivep(obj) ? 0 : as_oint(Fixnum_minus1)^as_oint(Fixnum_0))) & ~((oint)0x7F << oint_data_shift)) == as_oint(Fixnum_0))
  #define uint16_p(obj)  \
    ((as_oint(obj) & ~((oint)0xFFFF << oint_data_shift)) == as_oint(Fixnum_0))
  #define sint16_p(obj)  \
    (((as_oint(obj) ^ (positivep(obj) ? 0 : as_oint(Fixnum_minus1)^as_oint(Fixnum_0))) & ~((oint)0x7FFF << oint_data_shift)) == as_oint(Fixnum_0))
  #if (oint_data_len>=32)
    #define uint32_p(obj)  \
      ((as_oint(obj) & ~((oint)0xFFFFFFFFUL << oint_data_shift)) == as_oint(Fixnum_0))
  #else
    #define uint32_p(obj)  \
      ((typecode(obj)==fixnum_type) \
       || ((typecode(obj)==bignum_type) \
           && (TheBignum(obj)->length <= ceiling(33,intDsize)) \
           && ((TheBignum(obj)->length < ceiling(33,intDsize)) \
               || (TheBignum(obj)->data[0] < (uintD)bit(32%intDsize)) \
      )   )   )
  #endif
  #if (oint_data_len>=31)
    #define sint32_p(obj)  \
      (((as_oint(obj) ^ (positivep(obj) ? 0 : as_oint(Fixnum_minus1)^as_oint(Fixnum_0))) & ~((oint)0x7FFFFFFFUL << oint_data_shift)) == as_oint(Fixnum_0))
  #else
    #define sint32_p(obj)  \
      (((typecode(obj) & ~bit(sign_bit_t)) == fixnum_type) \
       || (((typecode(obj) & ~bit(sign_bit_t)) == bignum_type) \
           && (TheBignum(obj)->length <= ceiling(32,intDsize)) \
           && ((TheBignum(obj)->length < ceiling(32,intDsize)) \
               || ((TheBignum(obj)->data[0] ^ (positivep(obj) ? (uintD)0 : ~(uintD)0)) < (uintD)bit(31%intDsize)) \
      )   )   )
  #endif
  #define uint64_p(obj)  \
    ((typecode(obj)==fixnum_type) \
     || ((typecode(obj)==bignum_type) \
         && (TheBignum(obj)->length <= ceiling(65,intDsize)) \
         && ((TheBignum(obj)->length < ceiling(65,intDsize)) \
             || (TheBignum(obj)->data[0] < (uintD)bit(64%intDsize)) \
    )   )   )
  #define sint64_p(obj)  \
    (((typecode(obj) & ~bit(sign_bit_t)) == fixnum_type) \
     || (((typecode(obj) & ~bit(sign_bit_t)) == bignum_type) \
         && (TheBignum(obj)->length <= ceiling(64,intDsize)) \
         && ((TheBignum(obj)->length < ceiling(64,intDsize)) \
             || ((TheBignum(obj)->data[0] ^ (positivep(obj) ? (uintD)0 : ~(uintD)0)) < (uintD)bit(63%intDsize)) \
    )   )   )
  #if (int_bitsize==16)
    #define uint_p  uint16_p
    #define sint_p  sint16_p
  #else # (int_bitsize==32)
    #define uint_p  uint32_p
    #define sint_p  sint32_p
  #endif
  #if (long_bitsize==32)
    #define ulong_p  uint32_p
    #define slong_p  sint32_p
  #else # (long_bitsize==64)
    #define ulong_p  uint64_p
    #define slong_p  sint64_p
  #endif


# ####################### TIMEBIBL zu TIME.D ############################## #

# Typ, der für 'Internal Time' verwendet wird:
#ifdef TIME_1
  typedef uintL internal_time;      # abgegriffener Wert des Tick-Zählers
  #ifdef TIME_AMIGAOS
    #define ticks_per_second  50UL    # 1 Tick = 1/50 sec, 50Hz-Zähler
  #endif
  #ifdef TIME_MSDOS
    #define ticks_per_second  100UL   # 1 Tick = 1/100 sec, 100Hz-Zähler
  #endif
  #if defined(TIME_UNIX_TIMES) || defined(TIME_RISCOS)
    #define ticks_per_second  CLK_TCK
  #endif
  #define sub_internal_time(x,y, z)  z = (x) - (y)
  #define add_internal_time(x,y, z)  z = (x) + (y)
#endif
#ifdef TIME_2
  #if defined(TIME_UNIX) || defined(TIME_WIN32)
    typedef struct { uintL tv_sec;    # ganze Sekunden seit 1.1.1970 00:00 GMT,
                                      # Ein 'uintL' für tv_sec reicht für 136 Jahre.
                     uintL tv_usec;   # zusätzliche Mikrosekunden
                   }
            internal_time;
    #define ticks_per_second  1000000UL  # 1 Tick = 1 µsec
  #endif
  #define sub_internal_time(x,y, z)  # z:=x-y  \
    { (z).tv_sec = (x).tv_sec - (y).tv_sec;                   \
      if ((x).tv_usec < (y).tv_usec)                          \
        { (x).tv_usec += ticks_per_second; (z).tv_sec -= 1; } \
      (z).tv_usec = (x).tv_usec - (y).tv_usec;                \
    }
  #define add_internal_time(x,y, z)  # z:=x+y  \
    { (z).tv_sec = (x).tv_sec + (y).tv_sec;                   \
      (z).tv_usec = (x).tv_usec + (y).tv_usec;                \
      if ((z).tv_usec >= ticks_per_second)                    \
        { (z).tv_usec -= ticks_per_second; (z).tv_sec += 1; } \
    }
#endif

#ifndef HAVE_RUN_TIME

# UP: Hält die Run-Time-Stoppuhr an
# run_time_stop();
  extern void run_time_stop (void);
# wird verwendet von STREAM

# UP: Läßt die Run-Time-Stoppuhr weiterlaufen
# run_time_restart();
  extern void run_time_restart (void);
# wird verwendet von STREAM

#else

# Man braucht keine Run-Time-Stoppuhr
  #define run_time_stop()
  #define run_time_restart()

#endif

#ifdef TIME_1

# UP: Liefert die Real-Time
# get_real_time()
# < uintL ergebnis: Zeit seit LISP-System-Start (in 1/200 sec bzw. in 1/50 sec bzw. in 1/100 sec bzw. in 1/CLK_TCK sec)
  extern uintL get_real_time (void);
# wird verwendet von STREAM, LISPARIT

#endif

#ifdef TIME_2

# UP: Liefert die Real-Time
# get_real_time()
# < internal_time* ergebnis: absolute Zeit
  extern internal_time* get_real_time (void);
# wird verwendet von LISPARIT

#endif

# UP: Liefert die Run-Time
# get_running_times(&timescore);
# < timescore.runtime:  Run-Time seit LISP-System-Start (in Ticks)
# < timescore.realtime: Real-Time seit LISP-System-Start (in Ticks)
# < timescore.gctime:   GC-Time seit LISP-System-Start (in Ticks)
# < timescore.gccount:  Anzahl der GC's seit LISP-System-Start
# < timescore.gcfreed:  Größe des von den GC's bisher wiederbeschafften Platzes
  typedef struct { internal_time runtime;
                   internal_time realtime;
                   internal_time gctime;
                   uintL gccount;
                   uintL2 gcfreed; }
          timescore;
  extern void get_running_times (timescore*);
# wird verwendet von

# UP: Liefert die Run-Time
# get_running_time(runtime);
# < runtime: Run-Time (in Ticks)
  #ifndef HAVE_RUN_TIME
    #define get_running_time(runtime)  runtime = get_time()
    extern uintL get_time (void);
  #endif
  #if defined(TIME_UNIX) || defined(TIME_UNIX_TIMES) || defined(TIME_WIN32)
    #define get_running_time(runtime)  get_run_time(&runtime)
    #ifdef TIME_UNIX
      extern void get_run_time (internal_time* runtime);
    #endif
    #ifdef TIME_UNIX_TIMES
      extern uintL get_run_time (internal_time* runtime);
    #endif
    #ifdef TIME_WIN32
      extern void get_run_time (internal_time* runtime);
    #endif
  #endif
# wird verwendet von SPVW

# Zeitangabe in Decoded-Time:
  typedef struct { object Sekunden, Minuten, Stunden, Tag, Monat, Jahr; }
          decoded_time;

#if defined(MSDOS)
# UP: Wandelt das Zeitformat in Decoded-Time um.
# convert_time(time,date,&timepoint);
# > uintW time: Uhrzeit
#         Als Word: Bits 15..11: Stunde in {0,...,23},
#                   Bits 10..5:  Minute in {0,...,59},
#                   Bits 4..0:   Sekunde/2 in {0,...,29}.
# > uintW date: Datum
#         Als Word: Bits 15..9: Jahr-1980 in {0,...,119},
#                   Bits 8..5:  Monat in {1,...,12},
#                   Bits 4..0:  Tag in {1,...,31}.
# < timepoint.Sekunden, timepoint.Minuten, timepoint.Stunden,
#   timepoint.Tag, timepoint.Monat, timepoint.Jahr, jeweils als Fixnums
  extern void convert_timedate (uintW time, uintW date, decoded_time* timepoint);
# wird verwendet von PATHNAME
#endif
#ifdef AMIGAOS
# UP: Wandelt das Amiga-Zeitformat in Decoded-Time um.
# convert_time(&datestamp,&timepoint);
# > struct DateStamp datestamp: Uhrzeit
#          datestamp.ds_Days   : Anzahl Tage seit 1.1.1978
#          datestamp.ds_Minute : Anzahl Minuten seit 00:00 des Tages
#          datestamp.ds_Tick   : Anzahl Ticks seit Beginn der Minute
# < timepoint.Sekunden, timepoint.Minuten, timepoint.Stunden,
#   timepoint.Tag, timepoint.Monat, timepoint.Jahr, jeweils als Fixnums
  extern void convert_time (struct DateStamp * datestamp, decoded_time* timepoint);
# wird verwendet von PATHNAME
#endif
#if defined(UNIX) || defined(MSDOS) || defined(WIN32_UNIX)
# UP: Wandelt das System-Zeitformat in Decoded-Time um.
# convert_time(&time,&timepoint);
# > time_t time: Zeit im System-Zeitformat
# < timepoint.Sekunden, timepoint.Minuten, timepoint.Stunden,
#   timepoint.Tag, timepoint.Monat, timepoint.Jahr, jeweils als Fixnums
  extern void convert_time (time_t* time, decoded_time* timepoint);
# wird verwendet von PATHNAME
#endif

#ifdef TIME_RELATIVE

# UP: Merkt sich die Uhrzeit beim LISP-System-Start.
# set_start_time(&timepoint);
# > timepoint: Zeit beim LISP-System-Start
# >   timepoint.Sekunden in {0,...,59},
# >   timepoint.Minuten in {0,...,59},
# >   timepoint.Stunden in {0,...,23},
# >   timepoint.Tag in {1,...,31},
# >   timepoint.Monat in {1,...,12},
# >   timepoint.Jahr in {1980,...,2999},
# >   jeweils als Fixnums.
# kann GC auslösen
  extern void set_start_time (decoded_time* timepoint);
# wird verwendet von SPVW

#endif

# UP: Initialisiert die Zeitvariablen beim LISP-System-Start.
# init_time();
  extern void init_time (void);
# wird verwendet von SPVW


# ####################### SPVWBIBL zu SPVW.D ############################## #

/*
                          Die Stacks
                          ==========

Es werden zwei Stacks verwendet:
  - der C-Programmstack (Stackpointer SP = Register A7),
  - der LISP-Stack (Stackpointer STACK).
Alle Unterprogrammaufrufe geschehen mittels BSR/JSR über den Programmstack,
er dient außerdem zur Zwischenspeicherung von Daten, die keine LISP-Objekte
sind. Der LISP-Stack wird verwendet zur Ablage der Frames und zur Zwischen-
speicherung von LISP-Objekten.
Für beide Stacks werden die Wachstumsgrenzen von der Speicherverwaltung
kontrolliert über folgende Macros:
  check_SP();             testet den Programmstack gegen Überlauf
  check_STACK();          testet den LISP-Stack gegen Überlauf
  get_space_on_STACK(n);  testet, ob noch D0.L Bytes auf dem LISP-Stack frei sind
Auf dem LISP-Stack dürfen grundsätzlich nur Langwörter abgelegt werden.
Ist dabei FRAME_BIT gesetzt, so handelt es sich um das untere Ende eines
Frames; dieses Langwort ist ein Pointer über den Frame, zusammen mit
einem Frame-Typ-Byte; falls darin SKIP2_BIT gelöscht ist, ist das
darüberliegende Langwort kein LISP-Objekt.
Alle anderen Langwörter auf dem LISP-Stack stellen LISP-Objekte dar.
*/

# Maschinenstack: SP
# SP() liefert den aktuellen Wert des SP.
# setSP(adresse); setzt den SP auf einen gegebenen Wert. Extrem gefährlich!
# FAST_SP definiert, falls SP-Zugriffe schnell sind.
  #if defined(GNU) && defined(MC680X0) && !defined(NO_ASM)
    # Zugriff auf eine globale Register"variable" SP
    #ifdef __REGISTER_PREFIX__ # GNU C Version >= 2.4 hat %/ und __REGISTER_PREFIX__
      # Aber der Wert von __REGISTER_PREFIX__ ist unbrauchbar, weil wir evtl.
      # cross-compilieren.
      #define REGISTER_PREFIX  "%/"
    #else
      #define REGISTER_PREFIX  "" # oder "%%", je nach verwendetem Assembler
    #endif
    #define SP()  \
      ({var aint __SP;                                                          \
        __asm__ __volatile__ ("movel "REGISTER_PREFIX"sp,%0" : "=g" (__SP) : ); \
        __SP;                                                                   \
       })
    #define setSP(adresse)  \
      ({ __asm__ __volatile__ ("movel %0,"REGISTER_PREFIX"sp" : : "g" ((aint)(adresse)) : "sp" ); })
    #define FAST_SP
  #elif defined(GNU) && defined(SPARC)
    # Zugriff auf eine Register"variable" %sp = %o6
    register __volatile__ aint __SP __asm__("%sp");
    #define SP()  __SP
    # Wir dürfen hier kein setSP() durchführen, ohne zu beachten, daß
    # 1. %sp ein Alignment von 8 Byte beachten muß,
    # 2. oberhalb von %sp immer 92 Byte frei bleiben müssen (dorthin kommen
    #    die Registerinhalte, wenn durch ein 'save' in einem Unterprogramm
    #    ein 'register window overflow trap' ausgelöst wird).
  #elif defined(GNU) && defined(HPPA)
    # Zugriff auf eine Register"variable" %sp = %r30
    register __volatile__ aint __SP __asm__("%r30");
    #define SP()  __SP
  #elif defined(GNU) && defined(MIPS)
    # Zugriff auf eine Register"variable" $sp = $29
    #if (__GNUC__ >= 2) # ab GNU-C 2.0
      #define SP_register "$sp"
    #else
      #define SP_register "sp"
    #endif
    register __volatile__ aint __SP __asm__(SP_register);
    #define SP()  __SP
  #elif defined(GNU) && defined(M88000)
    # Zugriff auf eine Register"variable" %sp = %r31
    register __volatile__ aint __SP __asm__("%r31");
    #define SP()  __SP
  #elif defined(GNU) && defined(CONVEX)
    # Zugriff auf eine Register"variable" $sp = $a0
    register __volatile__ aint __SP __asm__("sp");
    #define SP()  __SP
  #elif defined(GNU) && defined(DECALPHA)
    # Zugriff auf eine Register"variable" $sp = $30
    register __volatile__ aint __SP __asm__("$30");
    #define SP()  __SP
  #elif defined(GNU) && defined(I80Z86) && !defined(NO_ASM)
    # Zugriff auf eine Register"variable" %esp
    #define SP()  \
      ({var aint __SP;                                           \
        __asm__ __volatile__ ("movl %%esp,%0" : "=g" (__SP) : ); \
        __SP;                                                    \
       })
    #define setSP(adresse)  \
      ({ __asm__ __volatile__ ("movl %0,%%esp" : : "g" ((aint)(adresse)) : "sp" ); })
    #define FAST_SP
  #elif defined(WATCOM) && defined(I80Z86) && !defined(NO_ASM)
    # Zugriff auf ein Register %esp
    #define SP  getSP
    extern void* getSP (void);
    extern void setSP (void* adresse);
    #pragma aux  getSP =  0x89 0xe0 /* mov %esp,%eax */  parm value [eax] modify nomemory;
    #pragma aux  setSP =  0x89 0xc4 /* mov %eax,%esp */  parm caller [eax] modify nomemory [esp];
    #define FAST_SP
  #elif defined(MICROSOFT) && defined(I80Z86) && !defined(NO_ASM)
    #define SP getSP
    __inline aint getSP() { __asm mov eax,esp }
    __inline aint setSP(aint address) { __asm mov esp, address }
  #elif defined(MC680X0) || defined(SPARC) || defined(MIPS) || defined(I80Z86)
    # Zugriffsfunktionen extern, in Assembler
    #define SP  getSP
    extern void* SP (void);
    extern void setSP (void* adresse);
  #else
    # Zugriffsfunktion portabel in C
    extern void* SP (void);
  #endif
#if defined(stack_grows_down) # defined(MC680X0) || defined(I80X86) || defined(SPARC) || defined(MIPS) || defined(M88000) || defined(DECALPHA) || ...
  #define SP_DOWN # SP wächst nach unten
  #define SPoffset 0 # top-of-SP ist *(SP+SPoffset)
#endif
#if defined(stack_grows_up) # defined(HPPA) || ...
  #define SP_UP # SP wächst nach oben
  #define SPoffset -1 # top-of-SP ist *(SP+SPoffset)
#endif
#if (defined(SP_DOWN) && defined(SP_UP)) || (!defined(SP_DOWN) && !defined(SP_UP))
  #error "Unknown SP direction -- SP_DOWN/SP_UP neu einstellen!"
#endif
# Darauf aufbauend:
# SPint  ist der Typ der Elemente auf dem SP, ein Integertyp mindestens so
#        breit wie uintL und mindestens so breit wie aint bzw. void*.
# SP_(n) = (n+1)tes Langwort auf dem SP.
# _SP_(n) = &SP_(n).
# pushSP(item)  legt ein Langwort auf dem SP ab. Synonym: -(SP).
# popSP(item=)  liefert item=SP_(0) und nimmt es dabei vom SP herunter.
# skipSP(n);  nimmt n Langworte vom SP herunter.
  #if (oint_addr_len <= intLsize)
    typedef uintL  SPint;
  #else
    typedef aint  SPint;
  #endif
  #ifdef SP_DOWN
    #define skipSPop  +=
    #define SPop      +
  #endif
  #ifdef SP_UP
    #define skipSPop  -=
    #define SPop      -
  #endif
  #define _SP_(n)  (((SPint*)SP()) + SPoffset SPop (uintP)(n))
  #if !(defined(GNU) && (defined(MC680X0)) && !defined(NO_ASM)) # im allgemeinen
    #define SP_(n)  (((SPint*)SP())[SPoffset SPop (uintP)(n)])
    #define skipSP(n)  \
      {var reg1 SPint* sp = (SPint*)SP(); \
       sp skipSPop (uintP)(n);            \
       setSP(sp);                         \
      }
    #define pushSP(item)  \
      {var reg1 SPint* sp = (SPint*)SP();                                    \
       sp skipSPop -1;                                                       \
       setSP(sp);             # Erst SP herabsetzen (wegen Interruptgefahr!) \
       sp[SPoffset] = (item); # dann item als top-of-SP eintragen            \
      }
    #define popSP(item_zuweisung)  \
      {var reg1 SPint* sp = (SPint*)SP();                                        \
       item_zuweisung sp[SPoffset]; # Erst item als top-of-SP holen              \
       sp skipSPop 1;                                                            \
       setSP(sp);                   # dann erst (Interruptgefahr!) SP hochsetzen \
      }
  #endif
  #if defined(GNU) && defined(MC680X0) && !defined(NO_ASM)
    # Mit GNU auf einem 680X0 liegt SP in einem Register. Zugriff und
    # Veränderung von SP bilden daher eine ununterbrechbare Einheit.
    # Und es gilt SP_DOWN und SPoffset=0.
    #define SP_(n)  \
      ({var reg1 uintL __n = sizeof(SPint) * (n); \
        var reg1 SPint __item;                    \
        __asm__ __volatile__ ("movel "REGISTER_PREFIX"sp@(%1:l),%0" : "=g" (__item) : "r" (__n) ); \
        __item;                                   \
       })
    #define skipSP(n)  \
      {var reg1 uintL __n = sizeof(SPint) * (n);                                   \
       __asm__ __volatile__ ("addl %0,"REGISTER_PREFIX"sp" : : "g" (__n) : "sp" ); \
      }
    #define pushSP(item)  \
      {var reg1 SPint __item = (item);                                                   \
       __asm__ __volatile__ ("movel %0,"REGISTER_PREFIX"sp@-" : : "g" (__item) : "sp" ); \
      }
    #define popSP(item_zuweisung)  \
      {var reg1 SPint __item;                                                             \
       __asm__ __volatile__ ("movel "REGISTER_PREFIX"sp@+,%0" : "=r" (__item) : : "sp" ); \
       item_zuweisung __item;                                                             \
      }
  #endif
# Größe eines jmp_buf im SP:
  #ifndef jmpbufsize
    #define jmpbufsize ceiling(sizeof(jmp_buf),sizeof(SPint))
  #endif
# Header im Bytecode einer compilierten Closure:
  #ifndef FAST_SP
    #define CCHD 2
  #else
    #define CCHD 0
  #endif

# LISP-Stack: STACK
  #if defined(GNU) && (SAFETY < 2)
    #if defined(MC680X0)
      #define STACK_register  "a4"  # höchstes Adreßregister nach sp=A7,fp=A6/A5
    #endif
    #if defined(SPARC)
      #define STACK_register  "%g5"  # ein globales Register
    #endif
    #if defined(HPPA_REG_WORKS)
      #define STACK_register  "%r10"  # eines der allgemeinen Register %r5..%r18
    #endif
    #if defined(M88000)
      #define STACK_register  "%r14"  # eines der allgemeinen Register %r14..%r25
    #endif
    #if defined(ARM)
      #define STACK_register  "%r8"  # eines der allgemeinen Register %r4..%r8
    #endif
    #if defined(DECALPHA)
      #define STACK_register  "$9"  # eines der allgemeinen Register $9..$14
    #endif
  #endif
  #if !defined(STACK_register)
    # eine globale Variable
    extern object* STACK;
  #else
    # eine globale Registervariable
    register object* STACK __asm__(STACK_register);
    #ifdef HAVE_SAVED_REGISTERS
      register long STACK_reg __asm__(STACK_register);
    #endif
  #endif
  #if defined(SPARC) && !defined(GNU) && !defined(__SUNPRO_C) && (SAFETY < 2)
    # eine globale Registervariable, aber Zugriffsfunktionen extern in Assembler
    #define STACK  _getSTACK()
    extern object* _getSTACK (void);
    #define setSTACK(zuweisung)  \
      { var object* tempSTACK; _setSTACK(temp##zuweisung); } # Ähem, igitt!
    extern void _setSTACK (void* new_STACK);
  #else
    #define setSTACK(zuweisung)  zuweisung
  #endif
#ifdef AMIGAOS
  #define STACK_DOWN # STACK wächst nach unten
#endif
#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS) || defined(HYPERSTONE) || defined(WIN32_UNIX) || defined(WIN32_DOS)
  #define STACK_UP # STACK wächst nach oben
#endif
#if (defined(STACK_DOWN) && defined(STACK_UP)) || (!defined(STACK_DOWN) && !defined(STACK_UP))
  #error "Unknown STACK direction -- STACK_DOWN/STACK_UP neu einstellen!"
#endif

# Jeder Aufruf einer externen Funktion (oder eine Folge von solchen) muß
# zwischen
#   begin_call();
# und
#   end_call();
# eingerahmt werden.
# Zweck: Damit im Falle einer Unterbrechung während des entsprechenden
# Zeitraums der STACK - falls er in einem Register liegt - auf einen halbwegs
# aktuellen Wert gebracht werden kann.
# Soll während des Ablaufs einer externen Funktion doch wieder auf den STACK
# zugegriffen werden, so ist der entsprechende Code zwischen
#   begin_callback();
# und
#   end_callback();
# einzurahmen.
#if defined(STACK_register) && !(defined(SUN4) && (SAFETY < 2))
  #define HAVE_SAVED_STACK
  extern object* saved_STACK;
  #define begin_call()  saved_STACK = STACK
  #define end_call()  saved_STACK = (object*)NULL
  #if defined(HAVE_SAVED_REGISTERS) # defined(GNU) && defined(DECALPHA)
    extern struct registers
                  { 
                    long STACK_register_contents;
                    long mv_count_register_contents;
                    long value1_register_contents;
                    struct registers *prev;
                  } *callback_saved_registers;
    #define begin_callback()  \
      { struct registers *registers = alloca(sizeof(struct registers)); \
        registers->prev = callback_saved_registers; \
        registers->STACK_register_contents = STACK_reg; \
        registers->mv_count_register_contents = mv_count_reg; \
        registers->value1_register_contents   = value1_reg;   \
        callback_saved_registers = registers; \
        STACK = saved_STACK; end_call();  \
      }
    #define end_callback()  \
      { struct registers *registers = callback_saved_registers; \
        begin_call(); \
        STACK_reg = registers->STACK_register_contents; \
        mv_count_reg = registers->mv_count_register_contents; \
        value1_reg = registers->value1_register_contents; \
        callback_saved_registers = registers->prev; \
      }
  #else
    #define begin_callback()  setSTACK(STACK = saved_STACK); end_call()
    #define end_callback()  begin_call()
  #endif
#elif defined(EMUNIX) && defined(WINDOWS)
  # Bei RSXW32 müssen wir den SP vorübergehend in die unteren 64 KB legen,
  # damit MS-Windows-Aufrufe möglich werden. Ansonsten brauchen wir aber
  # einen größeren Stack.
  #define begin_call()  if ((aint)SP() > (aint)SP_start) alloca((aint)SP() - (aint)SP_start)
  #define end_call()
  # Bei Callbacks bleiben wir im kleinen Stack.
  #define begin_callback()
  #define end_callback()
#else
  # Falls STACK eine globale Variable ist oder in einem Register liegt,
  # das von Betriebssystem und Library intakt gelassen wird (das ist bei
  # SUN4 der Fall), brauchen wir uns auch keine Sorgen zu machen.
  #if defined(GNU) && (SAFETY < 2) && defined(SPARC) && !defined(WIDE)
    # subr_self_register %g4 muß gerettet werden.
    #define HAVE_SAVED_SUBR_SELF
    extern object saved_subr_self;
    #define begin_call()  saved_subr_self = subr_self
    #define end_call()  subr_self = saved_subr_self
    #define begin_callback()  end_call()
    #define end_callback()  begin_call()
  #else
    #define begin_call()
    #define end_call()
    #define begin_callback()  end_call()
    #define end_callback()  begin_call()
  #endif
#endif

# Jeder Betriebsystem-Aufruf (oder eine Folge von solchen) muß zwischen
#   begin_system_call();
# und
#   end_system_call();
# eingerahmt werden.
# Zweck: Damit im Falle einer Unterbrechung während des entsprechenden
# Zeitraums der STACK - falls er in einem Register liegt - auf einen halbwegs
# aktuellen Wert gebracht werden kann.
#if defined(AMIGAOS) || defined(NO_ASYNC_INTERRUPTS)
  # AMIGAOS: Solange nicht ixemul.library benutzt wird, ist während
  #   Betriebssystem-Aufrufen das Programm sowieso nicht unterbrechbar.
  # NO_ASYNC_INTERRUPTS: Wenn wir auf asynchrone Interrupts nicht reagieren,
  #   ist das Programm nicht unterbrechbar.
  #define begin_system_call()
  #define end_system_call()
#else
  #define begin_system_call()  begin_call()
  #define end_system_call()  end_call()
#endif

# Unter Unix wird der Speicherbereich für den SP vom
# Betriebssystem bereitgestellt, kein malloc() nötig.
# Ebenso unter EMX (ausgenommen RSXW32 mit seinem Mini-60KB-Stack).
#if (defined(UNIX) && !defined(UNIX_MINT)) || (defined(EMUNIX) && !defined(WINDOWS)) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS) # || defined(AMIGAOS) # ?JCH??
  #define NO_SP_MALLOC
#endif

# Testet auf SP-Überlauf.
# check_SP();            testet auf Überlauf
# check_SP_notUNIX();    dito, außer wenn temporärer Überlauf nicht ins Gewicht fällt
  #define check_SP()  if (SP_overflow()) SP_ueber()
  #if (defined(EMUNIX) && defined(WINDOWS))
    # Der SP liegt entweder im Original-Bereich (<= SP_start) oder
    # im neu allozierten Bereich, der durch SP_bound begrenzt ist.
    #define SP_overflow()  \
      ( (aint)SP() > (aint)SP_start && (aint)SP() < (aint)SP_bound )
    extern void* SP_start;
  #elif !defined(NO_SP_MALLOC) || defined(AMIGAOS)
    #ifdef SP_DOWN
      #define SP_overflow()  ( (aint)SP() < (aint)SP_bound )
    #endif
    #ifdef SP_UP
      #define SP_overflow()  ( (aint)SP() > (aint)SP_bound )
    #endif
  #else # NO_SP_MALLOC
    # Für den SP ist das Betriebssystem verantwortlich.
    # Woher sollen wir einen vernünftigen Wert für SP_bound bekommen?
    #define SP_overflow()  FALSE
  #endif
  extern void* SP_bound;
  nonreturning_function(extern, SP_ueber, (void));
  #if defined(UNIX) || defined(WIN32_UNIX)
    #define check_SP_notUNIX()
  #else
    #define check_SP_notUNIX()  check_SP()
  #endif

# Testet auf STACK-Überlauf.
# check_STACK();
  #define check_STACK()  if (STACK_overflow()) STACK_ueber()
  #ifdef STACK_DOWN
    #define STACK_overflow()  ( (aint)STACK < (aint)STACK_bound )
  #endif
  #ifdef STACK_UP
    #define STACK_overflow()  ( (aint)STACK > (aint)STACK_bound )
  #endif
  extern void* STACK_bound;
  nonreturning_function(extern, STACK_ueber, (void));

# Testet, ob noch n Bytes auf dem STACK frei sind.
# get_space_on_STACK(n);
  #ifdef STACK_DOWN
    #define get_space_on_STACK(n)  \
      if ( (aint)STACK < (aint)STACK_bound + (aint)(n) ) STACK_ueber()
  #else
    #define get_space_on_STACK(n)  \
      if ( (aint)STACK + (aint)(n) > (aint)STACK_bound ) STACK_ueber()
  #endif

# LISP-Interpreter verlassen
# quit();
# > final_exitcode: 0 bei normalem Ende, 1 bei Abbruch
  nonreturning_function(extern, quit, (void));
  extern boolean final_exitcode;
# wird verwendet von CONTROL, WINDOWS

# Fehlermeldung wegen Erreichen einer unerreichbaren Programmstelle.
# Kehrt nicht zurück.
# fehler_notreached(file,line);
# > file: Filename (mit Anführungszeichen) als konstanter ASCIZ-String
# > line: Zeilennummer
  nonreturning_function(extern, fehler_notreached, (const char * file, uintL line));
# wird von allen Modulen verwendet

#ifndef LANGUAGE_STATIC
# Sprache, in der mit dem Benutzer kommuniziert wird:
  extern uintC language;
  #define language_english   0
  #define language_deutsch   1
  #define language_francais  2
# wird von allen Modulen verwendet
#endif

# Ausgabe eines konstanten ASCIZ-Strings, direkt übers Betriebssystem:
# asciz_out(string);
  extern void asciz_out (const char * asciz);
  extern void err_asciz_out (const char * asciz);
# wird verwendet von SPVW

# uintL in Dezimalnotation direkt übers Betriebssystem ausgeben:
# dez_out(zahl);
  #define dez_out(x)  dez_out_((uintL)(x))
  extern void dez_out_ (uintL zahl);
# wird zum Debuggen verwendet

# unsigned long in Hexadezimalnotation direkt übers Betriebssystem ausgeben:
# hex_out(zahl);
  #define hex_out(x)  hex_out_((unsigned long)(x))
  extern void hex_out_ (unsigned long zahl);
# wird zum Debuggen verwendet

# Speicherbereich in Hexadezimalnotation direkt übers Betriebssystem ausgeben:
# mem_hex_out(buf,count);
  extern void mem_hex_out (void* buf, uintL count);
# wird zum Debuggen verwendet

# Lisp-Objekt in Lisp-Notation relativ direkt übers Betriebssystem ausgeben:
# object_out(obj);
# kann GC auslösen
  extern void object_out (object obj);
# wird zum Debuggen verwendet

# Methode der Speicherverwaltung:
# SPVW_BLOCKS : Speicherverwaltung mit wenigen Speicherblöcken
# SPVW_PAGES  : Speicherverwaltung mit vielen Speicherseiten
# SPVW_MIXED  : Objekte verschiedenen Typs in derselben Seite/demselben Block
#               möglich
# SPVW_PURE   : Jeder Speicherblock/jede Speicherseite enthält nur Objekte
#               ein und desselben Typs
#if defined(WATCOM) || defined(UNIX_LINUX) || defined(MAP_MEMORY) || defined(TRIVIALMAP_MEMORY)
  # On DOS, with WATCOMs extender, we have only a limited amount of memory.
  # Bei Linux legt zu viel malloc() den Rechner für längere Zeit lahm.
  # Multimapping einzelner Pages ist noch nicht implementiert.??
  # Singlemapping einzelner Pages ist noch nicht implementiert.??
  # Verwendet man mmap() als malloc()-Ersatz, braucht man keine einzelnen Pages.
  #define SPVW_BLOCKS
#elif (defined(AMIGA) || defined(VIRTUAL_MEMORY)) && defined(GENTAG)
  # Auf dem Amiga sollte man nicht zu viel Speicher auf einmal holen.
  # Auf Unix-Systemen kann man nachträglich immer noch Speicher holen,
  # man sollte aber die Daten wenn möglich in wenigen Pages konzentrieren.
  # avl.d setzt den Macro GENTAG voraus.
  #define SPVW_PAGES
#else
  #define SPVW_BLOCKS
#endif
#if defined(MULTIMAP_MEMORY)
  # MULTIMAP_MEMORY -> Mixed Pages dienen besserer Speicher-Ausnutzung.
  #define SPVW_MIXED
#elif defined(SINGLEMAP_MEMORY)
  # SINGLEMAP_MEMORY -> Nur Pure Pages/Blocks sinnvoll, denn
  # die Adresse einer Page bestimmt den Typ der Objekte, die sie enthält.
  #define SPVW_PURE
#elif defined(MC68000) || defined(SUN3) || defined(AMIGA) || defined(SPVW_BLOCKS) || defined(TRIVIALMAP_MEMORY)
  # MC68000 oder SUN3 -> type_pointable(...) kostet nichts oder nur wenig.
  # AMIGA -> nur endlich viel Speicher, Mixed Pages nutzen ihn besser.
  # SPVW_BLOCKS -> SPVW_PURE_BLOCKS nur für SINGLEMAP_MEMORY implementiert.
  # TRIVIALMAP_MEMORY -> Nicht viele Blöcke möglich, da wenig Adreßraum.
  #define SPVW_MIXED
#elif 1 # vorläufig! ??
  #define SPVW_MIXED
#endif
#if !(defined(SPVW_BLOCKS) || defined(SPVW_PAGES))
  #error "SPVW_BLOCKS/SPVW_PAGES neu einstellen!"
#endif
#if !(defined(SPVW_MIXED) || defined(SPVW_PURE))
  #error "SPVW_MIXED/SPVW_PURE neu einstellen!"
#endif
#if (defined(SPVW_BLOCKS) && defined(SPVW_PURE)) != defined(SINGLEMAP_MEMORY)
  #error "SINGLEMAP_MEMORY impliziert SPVW_PURE_BLOCKS und umgekehrt!"
#endif
#if (defined(SPVW_BLOCKS) && defined(SPVW_MIXED)) < defined(TRIVIALMAP_MEMORY)
  #error "TRIVIALMAP_MEMORY impliziert SPVW_MIXED_BLOCKS!"
#endif
#if (defined(SPVW_BLOCKS) && (defined(SPVW_PURE) || (defined(SPVW_MIXED) && (defined(TRIVIALMAP_MEMORY) || !defined(UNIX_AIX))))) < defined(GENERATIONAL_GC)
  #error "GENERATIONAL_GC impliziert SPVW_PURE_BLOCKS oder SPVW_MIXED_BLOCKS_TRIVIALMAP oder SPVW_MIXED_BLOCKS_OPPOSITE!"
#endif

# Algorithmus nach Morris, der die Conses kompaktiert, ohne sie dabei
# durcheinanderzuwürfeln:
#if defined(SPVW_BLOCKS) && defined(VIRTUAL_MEMORY) && !defined(NO_MORRIS_GC)
  #define MORRIS_GC
#endif

# Lege subr_tab und symbol_tab per Memory-Mapping an vorgegebene Adressen.
# (Die Morris-GC verwendet bei MULTIMAP_MEMORY den Macro upointer(). Bei
# &symbol_tab = 0x20000000 wäre upointer(NIL)=0. Mist!)
#if defined(MAP_MEMORY) && !(defined(MULTIMAP_MEMORY) && defined(MORRIS_GC))
  #define MAP_MEMORY_TABLES
#endif

# UP, führt eine Garbage Collection aus
# gar_col();
# kann GC auslösen
  extern void gar_col(void);
# wird verwendet von DEBUG

# GC-Statistik
  extern uintL gc_count;
  extern uintL2 gc_space;
  extern internal_time gc_time;
# wird verwendet von TIME

# UP, beschafft ein Cons
# allocate_cons()
# < ergebnis: Pointer auf neues CONS, mit CAR und CDR =NIL
# kann GC auslösen
  extern object allocate_cons (void);
# wird verwendet von LIST, SEQUENCE, PACKAGE, EVAL, CONTROL, RECORD,
#                    PREDTYPE, IO, STREAM, PATHNAME, SYMBOL, ARRAY, LISPARIT

# UP: Liefert ein neu erzeugtes uninterniertes Symbol mit gegebenem Printnamen.
# make_symbol(string)
# > string: Simple-String
# < ergebnis: neues Symbol mit diesem Namen, mit Home-Package=NIL.
# kann GC auslösen
  extern object make_symbol (object string);
# wird verwendet von PACKAGE, IO, SYMBOL

# UP, beschafft Vektor
# allocate_vector(len)
# > len: Länge des Vektors
# < ergebnis: neuer Vektor (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  extern object allocate_vector (uintL len);
# wird verwendet von ARRAY, IO, EVAL, PACKAGE, CONTROL, HASHTABL

# UP, beschafft Bit-Vektor
# allocate_bit_vector(len)
# > len: Länge des Bitvektors (in Bits)
# < ergebnis: neuer Bitvektor (LISP-Objekt)
# kann GC auslösen
  extern object allocate_bit_vector (uintL len);
# wird verwendet von ARRAY, IO, RECORD, LISPARIT, STREAM

# UP, beschafft String
# allocate_string(len)
# > len: Länge des Strings (in Bytes)
# < ergebnis: neuer Simple-String (LISP-Objekt)
# kann GC auslösen
  extern object allocate_string (uintL len);
# wird verwendet von ARRAY, CHARSTRG, STREAM, PATHNAME

# UP, beschafft Array
# allocate_array(flags,rank,type)
# > uintB flags: Flags
# > uintC rank: Rang
# > tint type: Typinfo
# < ergebnis: LISP-Objekt Array
# kann GC auslösen
  extern object allocate_array (uintB flags, uintC rank, tint type);
# wird verwendet von ARRAY, IO

# UP, beschafft Simple-Record
# allocate_srecord(flags,rectype,reclen,type)
# > uintB flags: Flags
# > sintB rectype: nähere Typinfo
# > uintC (eigentlich uintW) reclen: Länge
# > tint type: Typinfo
# < ergebnis: LISP-Objekt Record (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  #define allocate_srecord(flags,rectype,reclen,type)  \
    allocate_srecord_(                                                    \
       (BIG_ENDIAN_P ? ((uintW)(flags)<<intBsize)+(uintW)(uintB)(rectype) \
                     : (uintW)(flags)+((uintW)(uintB)(rectype)<<intBsize) \
       ),                                                                 \
       reclen,                                                            \
       type)
  extern object allocate_srecord_ (uintW flags_rectype, uintC reclen, tint type);
# wird verwendet von RECORD, EVAL

# UP, beschafft Extended-Record
# allocate_xrecord(flags,rectype,reclen,recxlen,type)
# > uintB flags: Flags
# > sintB rectype: nähere Typinfo
# > uintC (eigentlich uintB) reclen: Länge
# > uintC (eigentlich uintB) recxlen: Extra-Länge
# > tint type: Typinfo
# < ergebnis: LISP-Objekt Record (Elemente werden mit NIL bzw. 0 initialisiert)
# kann GC auslösen
  #define allocate_xrecord(flags,rectype,reclen,recxlen,type)  \
    allocate_xrecord_(                                                    \
       (BIG_ENDIAN_P ? ((uintW)(flags)<<intBsize)+(uintW)(uintB)(rectype) \
                     : (uintW)(flags)+((uintW)(uintB)(rectype)<<intBsize) \
       ),                                                                 \
       reclen,                                                            \
       recxlen,                                                           \
       type)
  extern object allocate_xrecord_ (uintW flags_rectype, uintC reclen, uintC recxlen, tint type);
# wird verwendet von

# UP, beschafft Structure
# allocate_structure(reclen)
# > uintC reclen: Länge
# < ergebnis: LISP-Objekt Structure (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  #ifdef case_structure
    #define allocate_structure(reclen)  \
      allocate_srecord(0,Rectype_Structure,reclen,structure_type)
  #else
    #define allocate_structure(reclen)  \
      allocate_srecord(0,Rectype_Structure,reclen,orecord_type)
  #endif
# wird verwendet von RECORD

# UP, beschafft Stream
# allocate_stream(strmflags,strmtype,reclen)
# > uintB strmflags: Flags
# > uintB strmtype: nähere Typinfo
# > uintC reclen: Länge
# < ergebnis: LISP-Objekt Stream (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  #ifdef case_stream
    #define allocate_stream(strmflags,strmtype,reclen)  \
      allocate_xrecord(strmflags,strmtype,reclen,0,stream_type)
  #else
    extern object allocate_stream (uintB strmflags, uintB strmtype, uintC reclen);
  #endif
# wird verwendet von STREAM

# UP, beschafft Package
# allocate_package()
# < ergebnis: LISP-Objekt Package
# kann GC auslösen
  #define allocate_package()  \
    allocate_xrecord(0,Rectype_Package,package_length,0,orecord_type)
# wird verwendet von PACKAGE

# UP, beschafft Hash-Table
# allocate_hash_table()
# < ergebnis: LISP-Objekt Hash-Table
# kann GC auslösen
  #define allocate_hash_table()  \
    allocate_xrecord(0,Rectype_Hashtable,hashtable_length,0,orecord_type)
# wird verwendet von

# UP, beschafft Readtable
# allocate_readtable()
# < ergebnis: LISP-Objekt Readtable
# kann GC auslösen
  #define allocate_readtable()  \
    allocate_xrecord(0,Rectype_Readtable,readtable_length,0,orecord_type)
# wird verwendet von IO

# UP, beschafft Pathname
# allocate_pathname()
# < ergebnis: LISP-Objekt Pathname
# kann GC auslösen
  #define allocate_pathname()  \
    allocate_xrecord(0,Rectype_Pathname,pathname_length,0,orecord_type)
# wird verwendet von PATHNAME

#ifdef LOGICAL_PATHNAMES
# UP, beschafft Logical Pathname
# allocate_logpathname()
# < ergebnis: LISP-Objekt Logical Pathname
# kann GC auslösen
  #define allocate_logpathname()  \
    allocate_xrecord(0,Rectype_Logpathname,logpathname_length,0,orecord_type)
# wird verwendet von PATHNAME
#endif

# UP, beschafft Random-State
# allocate_random_state()
# < ergebnis: LISP-Objekt Random-State
# kann GC auslösen
  #define allocate_random_state()  \
    allocate_xrecord(0,Rectype_Random_State,random_state_length,0,orecord_type)
# wird verwendet von IO, LISPARIT

# UP, beschafft Byte
# allocate_byte()
# < ergebnis: LISP-Objekt Byte
# kann GC auslösen
  #define allocate_byte()  \
    allocate_xrecord(0,Rectype_Byte,byte_length,0,orecord_type)
# wird verwendet von LISPARIT

# UP, beschafft Fsubr
# allocate_fsubr()
# < ergebnis: LISP-Objekt Fsubr
# kann GC auslösen
  #define allocate_fsubr()  \
    allocate_xrecord(0,Rectype_Fsubr,fsubr_length,0,orecord_type)
# wird verwendet von SPVW

# UP, beschafft Load-time-Eval
# allocate_loadtimeeval()
# < ergebnis: LISP-Objekt Load-time-Eval
# kann GC auslösen
  #define allocate_loadtimeeval()  \
    allocate_xrecord(0,Rectype_Loadtimeeval,loadtimeeval_length,0,orecord_type)
# wird verwendet von IO, RECORD

# UP, beschafft Symbol-Macro
# allocate_symbolmacro()
# < ergebnis: LISP-Objekt Symbol-Macro
# kann GC auslösen
  #define allocate_symbolmacro()  \
    allocate_xrecord(0,Rectype_Symbolmacro,symbolmacro_length,0,orecord_type)
# wird verwendet von CONTROL, RECORD

#ifdef FOREIGN
# UP, beschafft Foreign-Pointer-Verpackung
# allocate_fpointer(foreign)
# > foreign: vom Typ FOREIGN
# < ergebnis: LISP-Objekt, das foreign enthält
# kann GC auslösen
  extern object allocate_fpointer (FOREIGN foreign);
# wird verwendet von REXX
#endif

# UP, beschafft Foreign-Addresse
# allocate_faddress()
# < ergebnis: LISP-Objekt Foreign-Addresse
# kann GC auslösen
  #define allocate_faddress()  \
    allocate_xrecord(0,Rectype_Faddress,faddress_length,faddress_xlength,orecord_type)
# wird verwendet von FOREIGN

# UP, beschafft Foreign-Variable
# allocate_fvariable()
# < ergebnis: LISP-Objekt Foreign-Variable
# kann GC auslösen
  #define allocate_fvariable()  \
    allocate_xrecord(0,Rectype_Fvariable,fvariable_length,0,orecord_type)
# wird verwendet von FOREIGN

# UP, beschafft Foreign-Funktion
# allocate_ffunction()
# < ergebnis: LISP-Objekt Foreign-Funktion
# kann GC auslösen
  #define allocate_ffunction()  \
    allocate_xrecord(0,Rectype_Ffunction,ffunction_length,0,orecord_type)
# wird verwendet von FOREIGN

# UP, beschafft Finalisierer
# allocate_finalizer()
# < ergebnis: LISP-Objekt Finalisierer
# kann GC auslösen
  #define allocate_finalizer()  \
    allocate_xrecord(0,Rectype_Finalizer,finalizer_length,0,orecord_type)
# wird verwendet von RECORD

#ifdef SOCKET_STREAMS
  #define allocate_socket_server() \
    allocate_xrecord(0,Rectype_Socket_Server,socket_server_length,0,orecord_type)
#endif

#ifdef YET_ANOTHER_RECORD
# UP, beschafft Yetanother
# allocate_yetanother()
# < ergebnis: LISP-Objekt Yetanother
# kann GC auslösen
  #define allocate_yetanother()  \
    allocate_xrecord(0,Rectype_Yetanother,yetanother_length,0,orecord_type)
# wird verwendet von
#endif

# UP, beschafft Handle-Verpackung
# allocate_handle(handle)
# < ergebnis: LISP-Objekt, das handle enthält
  #ifdef FOREIGN_HANDLE
    # kann GC auslösen
    extern object allocate_handle (Handle handle);
  #else
    #define allocate_handle(handle)  fixnum((uintL)(handle))
  #endif

# UP, beschafft Bignum
# allocate_bignum(len,sign)
# > uintC len: Länge der Zahl (in Digits)
# > sintB sign: Flag für Vorzeichen (0 = +, -1 = -)
# < ergebnis: neues Bignum (LISP-Objekt)
# kann GC auslösen
  extern object allocate_bignum (uintC len, sintB sign);
# wird verwendet von LISPARIT, STREAM

# UP, beschafft Single-Float
# allocate_ffloat(value)
# > ffloat value: Zahlwert (Bit 31 = Vorzeichen)
# < ergebnis: neues Single-Float (LISP-Objekt)
# kann GC auslösen
  extern object allocate_ffloat (ffloat value);
# wird verwendet von LISPARIT

# UP, beschafft Double-Float
#ifdef intQsize
# allocate_dfloat(value)
# > dfloat value: Zahlwert (Bit 63 = Vorzeichen)
# < ergebnis: neues Double-Float (LISP-Objekt)
# kann GC auslösen
  extern object allocate_dfloat (dfloat value);
#else
# allocate_dfloat(semhi,mlo)
# > semhi,mlo: Zahlwert (Bit 31 von semhi = Vorzeichen)
# < ergebnis: neues Double-Float (LISP-Objekt)
# kann GC auslösen
  extern object allocate_dfloat (uint32 semhi, uint32 mlo);
#endif
# wird verwendet von LISPARIT

# UP, beschafft Long-Float
# allocate_lfloat(len,expo,sign)
# > uintC len: Länge der Mantisse (in Digits)
# > uintL expo: Exponent
# > signean sign: Vorzeichen (0 = +, -1 = -)
# < ergebnis: neues Long-Float, noch ohne Mantisse
# Ein LISP-Objekt liegt erst dann vor, wenn die Mantisse eingetragen ist!
# kann GC auslösen
  extern object allocate_lfloat (uintC len, uintL expo, signean sign);
# wird verwendet von LISPARIT

# UP, erzeugt Bruch
# make_ratio(num,den)
# > object num: Zähler (muß Integer /= 0 sein, relativ prim zu den)
# > object den: Nenner (muß Integer > 1 sein)
# < ergebnis: Bruch
# kann GC auslösen
  extern object make_ratio (object num, object den);
# wird verwendet von LISPARIT

# UP, erzeugt komplexe Zahl
# make_complex(real,imag)
# > real: Realteil (muß reelle Zahl sein)
# > imag: Imaginärteil (muß reelle Zahl /= Fixnum 0 sein)
# < ergebnis: komplexe Zahl
# kann GC auslösen
  extern object make_complex (object real, object imag);
# wird verwendet von LISPARIT

# UP: Liefert einen LISP-String mit vorgegebenem Inhalt.
# make_string(charptr,len)
# > uintB* charptr: Adresse einer Zeichenfolge
# > uintL len: Länge der Zeichenfolge
# < ergebnis: Simple-String mit den len Zeichen ab charptr als Inhalt
# kann GC auslösen
  extern object make_string (const uintB* charptr, uintL len);
# wird verwendet von PATHNAME, LISPARIT

# UP: Liefert die Länge eines ASCIZ-Strings.
# asciz_length(asciz)
# > char* asciz: ASCIZ-String
#       (Adresse einer durch ein Nullbyte abgeschlossenen Zeichenfolge)
# < ergebnis: Länge der Zeichenfolge (ohne Nullbyte)
  extern uintL asciz_length (const char * asciz);
# wird verwendet von SPVW

# UP: Vergleicht zwei ASCIZ-Strings.
# asciz_equal(asciz1,asciz2)
# > char* asciz1: erster ASCIZ-String
# > char* asciz2: zweiter ASCIZ-String
# < ergebnis: TRUE falls die Zeichenfolgen gleich sind
  extern boolean asciz_equal (const char * asciz1, const char * asciz2);
# wird verwendet von STREAM

#if defined(GNU) && (SAFETY < 2)
  #if (__GNUC__ >= 2) # GCC 2 hat __builtin_strlen und __builtin_strcmp
    #define asciz_length(a)  ((uintL)__builtin_strlen(a))
    #if !defined(AMIGAOS) # der Amiga-GCC2 macht da aber eine Ausnahme
      #define asciz_equal(a1,a2)  (__builtin_strcmp(a1,a2)==0)
    #endif
  #endif
#endif
#ifndef asciz_length
  #ifdef HAVE_SAVED_STACK
    # Kann nicht strlen() statt asciz_length() benutzen, denn das würde
    # ein begin_system_call()/end_system_call() erfordern.
  #else
    # Gehen wir davon aus, daß strlen() effizient implementiert ist.
    #ifdef STDC_HEADERS
      #include <string.h> # deklariert strlen()
    #endif
    #ifdef RETSTRLENTYPE # wenn strlen() kein Macro ist
      extern RETSTRLENTYPE strlen (STRLEN_CONST char* s);
    #endif
    #define asciz_length(a)  ((uintL)strlen(a))
  #endif
#endif
#ifndef asciz_equal
  #if 1
    # strcmp() ist vermutlich Overkill für asciz_equal().
  #else
    # Gehen wir davon aus, daß strcmp() es auch tut.
    #ifdef STDC_HEADERS
      #include <string.h> # deklariert strcmp()
    #else
      extern int strcmp (char* s1, char* s2);
    #endif
    #define asciz_equal(p1,p2)  (strcmp(p1,p2)==0)
  #endif
#endif

# UP: Wandelt einen ASCIZ-String in einen LISP-String um.
# asciz_to_string(asciz)
# > char* asciz: ASCIZ-String
#       (Adresse einer durch ein Nullbyte abgeschlossenen Zeichenfolge)
# < ergebnis: String mit der Zeichenfolge (ohne Nullbyte) als Inhalt
# kann GC auslösen
  extern object asciz_to_string (const char * asciz);
# wird verwendet von SPVW/CONSTSYM, STREAM, PATHNAME, PACKAGE, GRAPH

# UP: Wandelt einen String in einen ASCIZ-String um.
# string_to_asciz(obj)
# > object obj: String
# < ergebnis: Simple-String mit denselben Zeichen und einem Nullbyte mehr am Schluß
# < TheAsciz(ergebnis): Adresse der darin enthaltenen Zeichenfolge
# kann GC auslösen
  extern object string_to_asciz (object obj);
  #define TheAsciz(obj)  ((char*)(&TheSstring(obj)->data[0]))
# wird verwendet von STREAM, PATHNAME

# Wandelt einen String in einen ASCIZ-String im C-Stack um.
# with_string_0(string,asciz,statement);
# copies the contents of string (which should be a Lisp string) to a safe area
# (zero-terminating it), binds the variable asciz pointing to it, and
# executes the statement.
#if 0
  #define with_string_0(string,ascizvar,statement)  \
    { var char* ascizvar = TheAsciz(string_to_asciz(string)); \
      statement                                               \
    }
#else
  #define with_string_0(string,ascizvar,statement)  \
    { var uintL ascizvar##_len;                                     \
      var reg2 uintB* ptr1 = unpack_string(string,&ascizvar##_len); \
     {var DYNAMIC_ARRAY(_EMA_,ascizvar##_data,uintB,ascizvar##_len+1);   \
      {var reg1 uintB* ptr2 = &ascizvar##_data[0];                  \
       var reg3 uintL count;                                        \
       dotimesL(count,ascizvar##_len, { *ptr2++ = *ptr1++; } );     \
       *ptr2 = '\0';                                                \
      }                                                             \
      {var char* ascizvar = (char*) &ascizvar##_data[0];            \
       statement                                                    \
      }                                                             \
      FREE_DYNAMIC_ARRAY(ascizvar##_data);                          \
    }}
#endif
# wird verwendet von MISC, FOREIGN, STDWIN

# UP: Liefert eine Tabelle aller Zirkularitäten innerhalb eines Objekts.
# (Eine Zirkularität ist ein in diesem Objekt enthaltenes Teil-Objekt,
# auf den es mehr als einen Zugriffsweg gibt.)
# get_circularities(obj,pr_array,pr_closure)
# > object obj: Objekt
# > boolean pr_array: Flag, ob Arrayelemente rekursiv als Teilobjekte gelten
# > boolean pr_closure: Flag, ob Closurekomponenten rekursiv als Teilobjekte gelten
# < ergebnis: T falls Stacküberlauf eintrat,
#             NIL falls keine Zirkularitäten vorhanden,
#             #(0 ...) ein (n+1)-elementiger Vektor, der die Zahl 0 und die n
#                      Zirkularitäten als Elemente enthält, n>0.
# kann GC auslösen
  extern object get_circularities (object obj, boolean pr_array, boolean pr_closure);
# wird verwendet von IO

# UP: Entflicht #n# - Referenzen im Objekt *ptr mit Hilfe der Aliste alist.
# > *ptr : Objekt
# > alist : Aliste (Read-Label --> zu substituierendes Objekt)
# < *ptr : Objekt mit entflochtenen Referenzen
# < ergebnis : fehlerhafte Referenz oder nullobj falls alles OK
  extern object subst_circ (object* ptr, object alist);
# wird verwendet von IO

# Break-Semaphoren
# Solange eine Break-Semaphore gesetzt ist, kann das Lisp-Programm nicht
# unterbrochen werden. Zweck:
# - Sicherstellung von Konsistenzen,
# - Nicht reentrante Datenstrukturen (wie z.B. DTA_buffer) können nicht
#   rekursiv verwendet werden.
  typedef union {uintB einzeln[4]; uintL gesamt; } break_sems_;
  extern break_sems_ break_sems;
  #define break_sem_1  break_sems.einzeln[0]
  #define break_sem_2  break_sems.einzeln[1]
  #define break_sem_3  break_sems.einzeln[2]
  #define break_sem_4  break_sems.einzeln[3]
# wird verwendet von SPVW, Macros set/clr_break_sem_1/2/3/4

# Setzt Break-Semaphore 1 und schützt so gegen Unterbrechungen
# set_break_sem_1();
  #define set_break_sem_1()  (break_sem_1 = 1)
# wird verwendet von SPVW, ARRAY

# Löscht Break-Semaphore 1 und gibt so Unterbrechungen wieder frei
# clr_break_sem_1();
  #define clr_break_sem_1()  (break_sem_1 = 0)
# wird verwendet von SPVW, ARRAY

# Setzt Break-Semaphore 2 und schützt so gegen Unterbrechungen
# set_break_sem_2();
  #define set_break_sem_2()  (break_sem_2 = 1)
# wird verwendet von PACKAGE, HASHTABL

# Löscht Break-Semaphore 2 und gibt so Unterbrechungen wieder frei
# clr_break_sem_2();
  #define clr_break_sem_2()  (break_sem_2 = 0)
# wird verwendet von PACKAGE, HASHTABL

# Setzt Break-Semaphore 3 und schützt so gegen Unterbrechungen
# set_break_sem_3();
  #define set_break_sem_3()  (break_sem_3 = 1)
# wird verwendet von PACKAGE

# Löscht Break-Semaphore 3 und gibt so Unterbrechungen wieder frei
# clr_break_sem_3();
  #define clr_break_sem_3()  (break_sem_3 = 0)
# wird verwendet von PACKAGE

# Setzt Break-Semaphore 4 und schützt so gegen Unterbrechungen
# set_break_sem_4();
  #define set_break_sem_4()  (break_sem_4 = 1)
# wird verwendet von STREAM, PATHNAME

# Löscht Break-Semaphore 4 und gibt so Unterbrechungen wieder frei
# clr_break_sem_4();
  #define clr_break_sem_4()  (break_sem_4 = 0)
# wird verwendet von STREAM, PATHNAME

# Flag, ob SYS::READ-FORM sich ILISP-kompatibel verhalten soll:
  extern boolean ilisp_mode;

# Liefert die Größe des von den LISP-Objekten belegten Platzes.
  extern uintL used_space (void);
# wird verwendet von TIME, DEBUG

# Liefert die Größe des für LISP-Objekte noch verfügbaren Platzes.
  extern uintL free_space (void);
# wird verwendet von DEBUG

# UP, speichert Speicherabbild auf Diskette
# savemem(stream);
# > object stream: offener File-Output-Stream, wird geschlossen
# kann GC auslösen
  extern void savemem (object stream);
# wird verwendet von PATHNAME

# UP: Ruft ein Fremdprogramm auf.
# execute(memneed)
# > -(STACK): Filename des Fremdprogramms, ein Simple-ASCIZ-String
# > -(STACK): Argumente (Command Tail), ein Simple-String
# > uintL memneed: Fürs Fremdprogramm zu reservierende Byte-Zahl (gerade)
# < sintL ergebnis : Falls negativ, Fehlernummer.
#                    Sonst Returncode des aufgerufenen Programms.
# STACK wird aufgeräumt
# kann GC auslösen
  extern sintL execute (uintL memneed);
# wird verwendet von PATHNAME

#ifdef HAVE_SIGNALS
# Temporarily do not ignore the status of subprocesses.
  extern void begin_want_sigcld (void);
  extern void end_want_sigcld (void);
# wird verwendet von PATHNAME
#endif


# Deklaration der FSUBRs.
# Als C-Funktionen: C_name, vom Typ fsubr_function (keine Argumente, kein Wert)

# C-Funktionen sichtbar machen:
  #define LISPSPECFORM  LISPSPECFORM_A
  #include "fsubr.c"
  #undef LISPSPECFORM
# wird verwendet von

# Fsubr-Tabelle sichtbar machen:
  #define LISPSPECFORM  LISPSPECFORM_C
  extern struct fsubr_tab_ {
                             #include "fsubr.c"
                           }
         fsubr_tab;
  #undef LISPSPECFORM
# wird verwendet von CONTROL, SPVW


# Deklaration der SUBR-Tabelle.
# Als C-Funktionen: C_name
# vom Typ subr_norest_function (keine Argumente, kein Wert)
# bzw. subr_rest_function (zwei Argumente, kein Wert):
  typedef Values subr_norest_function (void);
  typedef Values subr_rest_function (reg4 uintC argcount, reg3 object* rest_args_pointer);

# Als LISP-Subr:    L(name)

# C-Funktionen sichtbar machen:
  #define LISPFUN  LISPFUN_A
  #include "subr.c"
  #undef LISPFUN
# wird verwendet von

# Subr-Tabelle sichtbar machen:
  #define LISPFUN  LISPFUN_C
  extern struct subr_tab_ {
                            #include "subr.c"
                          }
         subr_tab_data;
  #undef LISPFUN
# wird verwendet von Macro L

# Abkürzung fürs LISP-Subr mit einem gegebenen Namen: L(name)
  #if !defined(MAP_MEMORY_TABLES)
    #define subr_tab  subr_tab_data
    #define subr_tab_ptr_as_object(subr_addr)  (type_constpointer_object(subr_type,subr_addr))
    #define L(name)  subr_tab_ptr_as_object(&subr_tab.D_##name)
  #else
    # define subr_tab_addr  ((struct subr_tab_ *)type_constpointer_object(subr_type,0))
    #define subr_tab_addr  ((struct subr_tab_ *)type_zero_oint(subr_type))
    #define subr_tab  (*subr_tab_addr)
    #define subr_tab_ptr_as_object(subr_addr)  (as_object((oint)(subr_addr)))
    #define L(name)  subr_tab_ptr_as_object(&subr_tab_addr->D_##name)
  #endif
# wird verwendet von allen Modulen


# Pseudofunktionen sind Adressen von C-Funktionen, die direkt angesprungen werden können.
# Für SAVEMEM/LOADMEM gibt es eine Tabelle aller Pseudofunktionen.
  typedef object pseudofun_(); # C-Funktion mit Objekt als Ergebnis
  typedef pseudofun_ *  Pseudofun; # Pointer auf so eine Funktion

# Deklaration der Pseudofunktionen-Tabelle:
  #ifdef STRM_WR_SS
    #define PSEUDOFUNSS(name)  PSEUDOFUN(name)
  #else
    #define PSEUDOFUNSS(name)
  #endif
  #define PSEUDOFUN  PSEUDOFUN_A
  extern struct pseudofun_tab_ {
                                 #include "pseudofun.c"
                               }
         pseudofun_tab;
  #undef PSEUDOFUN
# wird verwendet von STREAM, SPVW


# Deklaration der Symbol-Tabelle:
  #define LISPSYM  LISPSYM_A
  extern struct symbol_tab_ {
                              #include "constsym.c"
                            }
         symbol_tab_data;
  #undef LISPSYM
# wird verwendet von Macro S

# Abkürzung für LISP-Symbol mit einem gegebenen Namen: S(name)
  #define S(name)  S_help_(S_##name)
  #if !defined(MAP_MEMORY_TABLES)
    #define symbol_tab  symbol_tab_data
    #define S_help_(name)  (type_constpointer_object(symbol_type,&symbol_tab.name))
  #else
    # define symbol_tab_addr ((struct symbol_tab_ *)type_constpointer_object(symbol_type,0))
    #define symbol_tab_addr ((struct symbol_tab_ *)type_zero_oint(symbol_type))
    #define symbol_tab  (*symbol_tab_addr)
    #define S_help_(name)  (as_object((oint)(&symbol_tab_addr->name)))
    #if 0 # Manche Compiler erlauben obigen Ausdruck
          # - obwohl eine 'constant expression' -
          # nicht als Initialisierer von static-Variablen.
          # Wir müssen nachhelfen:
      #undef S_help_
      #define S_help_(name)  (as_object( (char*)(&((struct symbol_tab_ *)0)->name) + (uintP)symbol_tab_addr ))
    #endif
  #endif
# wird verwendet von allen Modulen

#define NIL  S(nil)
#define T    S(t)

# Der Macro NIL_IS_CONSTANT gibt an, ob NIL vom C-Compiler als
# 'constant expression' anerkannt wird. Wenn ja, können die Tabellen
# zum großen Teil bereits vom C-Compiler initialisiert werden.
  #if (oint_addr_shift==0)
    #define NIL_IS_CONSTANT  TRUE
  #else
    #define NIL_IS_CONSTANT  FALSE
  #endif

# Deklaration der Tabelle der sonstigen festen Objekte:
  #define LISPOBJ  LISPOBJ_A
  extern struct object_tab_ {
                              #include "constobj.c"
                            }
         object_tab;
  #undef LISPOBJ
# wird verwendet von Macro O

# Abkürzung für sonstiges LISP-Objekt mit einem gegebenem Namen:
  #define O(name)  (object_tab.name)

# Abkürzung für von language abhängiges LISP-Objekt mit einem gegebenem Namen:
  #ifndef ENABLE_NLS
    #ifdef LANGUAGE_STATIC
      #define OL(name)  O(name)
    #else
      #define OL(name)  ((&O(name))[language])
    #endif
  #else
    #ifdef NLS_COMPILE_TIME_TRANSLATION
      #define OL(name) O(name)
    #else
      #define OL(name) (pushSTACK(O(name)), funcall(L(gettext),1), value1)
    #endif
  #endif

#if defined(GENERATIONAL_GC) && defined(SPVW_MIXED)
# handle_fault_range(PROT_READ,start,end) macht einen Adreßbereich lesbar,
# handle_fault_range(PROT_READ_WRITE,start,end) macht ihn schreibbar.
  extern boolean handle_fault_range (int prot, aint start_address, aint end_address);
#endif


# ###################### MODBIBL zu MODULES.D ############################ #

# Anzahl der externen Module:
  extern uintC module_count;

# Daten für die Initialisierung der subr_tab eines Moduls:
  typedef struct { char* packname; # Name der Home-Package des Symbols oder NULL
                   char* symname; # Name des Symbols
                 }
          subr_initdata;

# Daten für die Initialisierung der object_tab eines Moduls:
  typedef struct { char* initstring; } # Initialisierungs-String
          object_initdata;

# Tabelle bzw. Liste der Module:
  typedef struct module_
                 { char* name; # Name
                   subr_* stab; uintC* stab_size; # eine eigene subr_tab
                   object* otab; uintC* otab_size; # eine eigene object_tab
                   boolean initialized;
                   # Daten zur Initialisierung:
                   subr_initdata* stab_initdata;
                   object_initdata* otab_initdata;
                   # Funktionen zur Initialisierung
                   void (*initfunction1) _ARGS((struct module_ *)); # nur einmal
                   void (*initfunction2) _ARGS((struct module_ *)); # immer bei Programmstart
                   #ifdef DYNAMIC_MODULES
                   struct module_ * next; # verkettete Liste
                   #endif
                 }
          module_;
  #ifdef DYNAMIC_MODULES
    BEGIN_DECLS
    extern void add_module (module_ * new_module);
    END_DECLS
  #else
    extern module_ modules[]; # 1+module_count Einträge, dann ein leerer Eintrag
  #endif


# ####################### EVALBIBL zu EVAL.D ############################## #

/*

Spezifikationen für den Evaluator
#################################

SUBRs und FSUBRs
================

Sie werden konstruiert mit
  LISPFUN             für allgemeine LISP-Funktionen,
  LISPFUNN            für normale LISP-Funktionen (nur required-Parameter),
  LISPSPECFORM        für Special-Forms (FSUBRs).
Beachte, daß SUBRs mit KEY_ANZ=0 vom Evaluator als SUBRs ohne Keyword-
Parameter betrachtet werden (was zur Folge hat, daß in diesem Fall das
ALLOW_FLAG bedeutungslos ist und kein Keyword, auch nicht :ALLOW-OTHER-KEYS,
akzeptiert wird)!

Werte
=====

Folgendes Format wird für die Übergabe von multiple values verwendet:
value1 enthält den ersten Wert (NIL falls keine Werte).
mv_count enthält die Anzahl der Werte.
Falls mindestens ein Wert vorhanden:   value1 = erster Wert.
Falls mindestens zwei Werte vorhanden: value2 = zweiter Wert.
Falls mindestens drei Werte vorhanden: value3 = dritter Wert.
Alle Werte sind in mv_space abgelegt.
Empfohlene Befehle zur Rückgabe (an den Aufrufer) von
  0 Werten:   value1=NIL; mv_count=0;
  1 Wert:     value1=...; mv_count=1;
  2 Werten:   value1=...; value2=...; mv_count=2;
  3 Werten:   value1=...; value2=...; value3=...; mv_count=3;
  mehr als 3 Werten:
              if (Wertezahl >= mv_limit) goto fehler_zuviele_werte;
              Werte der Reihe nach auf den STACK legen
              STACK_to_mv(Wertezahl);

Parameterübergabe an SUBRs
==========================

Die Argumente werden auf dem LISP-Stack übergeben, dabei liegt das erste
Argument zuoberst. Zuerst kommen die required-Argumente, dann die optionalen
Argumente (jeweils #UNBOUND, falls nicht angegeben), dann die
Keyword-Argumente (wieder jeweils #UNBOUND, falls nicht angegeben).
In subr_self befindet sich das SUBR-Objekt.
Ist kein &REST-Argument vorgesehen, so ist dies alles. Ist &REST-Argument
vorgesehen, so folgen im Stack alle weiteren Argumente (nach den optionalen)
einzeln, und es werden übergeben: die Anzahl dieser Argumente und ein Pointer
übers erste dieser Argumente. (Dann ist die Anzahl der LISP-Objekte auf dem
Stack also nicht immer dieselbe!)
Beim Rücksprung müssen alle Argumente vom LISP-Stack entfernt sein
(d.h. z.B. bei SUBRs mit &REST: der Stackpointer STACK muß den Wert
args_pointer = rest_args_pointer STACKop (feste Argumentezahl)
= Pointer übers erste Argument überhaupt) haben, und mv_count/mv_space
muß die Werte enthalten.

Parameterübergabe an FSUBRs
===========================

Die Parameter werden auf dem LISP-Stack übergeben, dabei liegt der erste
Parameter zuoberst. Zuerst kommen die required-Parameter, dann die optionalen
Parameter (#UNBOUND, falls nicht angegeben), dann - falls Body-Flag wahr -
der gesamte restliche Body (meist eine Liste).
Die Anzahl der auf dem LISP-Stack liegenden Objekte ist also immer dieselbe,
nämlich  reqParameterZahl + optParameterZahl + (0 oder 1 falls Body-Flag).
Beim Aufruf enthält subr_self das FSUBR-Objekt, und die gesamte Form befindet
sich im EVAL-Frame, direkt über den Parametern.
Beim Rücksprung müssen alle Parameter vom LISP-Stack entfernt sein
(d.h. der Stackpointer STACK muß um Objektezahl erhöht worden sein),
und mv_count/mv_space muß die Werte enthalten.

Environments
============

Allgemeines
-----------
Das lexikalische Environment ist aufgeteilt in 5 Komponenten:
  - Das Variablen-Environment (VAR_ENV),
  - Das Funktions- und Macro-Environment (FUN_ENV),
  - Das Block-Environment (BLOCK_ENV),
  - Das Tagbody-Environment (GO_ENV),
  - Das Deklarations-Environment (DECL_ENV).
Das Environment wird in 5 "globalen Variablen" gehalten. Bei Veränderung
wird es mit speziellen Frames dynamisch gebunden.
An SYM_FUNCTION, MACROEXP, MACROEXP0, PARSE_DD wird ein einzelnes
Funktions- und Macro-Environment übergeben.
GET_CLOSURE erwartet einen Pointer auf alle Environments en bloc: A3 mit
VAR_(A3)=VAR_ENV, FUN_(A3)=FUN_ENV, BLOCK_(A3)=BLOCK_ENV, GO_(A3)=GO_ENV,
DECL_(A3)=DECL_ENV.

Das Variablen-Environment
-------------------------
Es enthält die lokalen Variablenbindungen.
Ein Variablen-Environment ist gegeben durch einen Pointer auf einen
Variablenbindungs-Frame oder durch NIL (das bedeutet ein leeres lexikalisches
Environment) oder durch einen Vektor folgenden Aufbaus:
Der Vektor enthält n Bindungen und hat die Länge 2n+1. Die Elemente sind
n-mal jeweils Variable (ein Symbol) und zugehöriger Wert (als "Wert" kann
auch #<SPECDECL> auftreten, dann ist die Variable dynamisch zu referenzieren)
und als letztes Element das Vorgänger-Environment.

Das Funktions- und Macro-Environment
------------------------------------
Es enthält die lokalen Funktions- und Macro-Definitionen.
Ein Funktions- und Macro-Environment ist gegeben durch einen Pointer auf
einen Funktions- oder Macrobindungs-Frame oder durch NIL (das bedeutet ein
leeres lexikalisches Environment) oder durch einen Vektor folgenden Aufbaus:
Der Vektor enthält n Bindungen und hat die Länge 2n+1. Die Elemente sind
n-mal jeweils Funktionsname (ein Symbol) und zugehörige Definition (eine
Closure oder NIL oder ein Cons (SYS::MACRO . Closure) ) und als letztes
Element das Vorgänger-Environment.

Das Block-Environment
---------------------
Es enthält die lexikalisch sichtbaren Block-Exitpoints.
Ein Block-Environment ist gegeben durch einen Pointer auf einen Block-Frame
oder durch eine Assoziationsliste, deren Elemente jeweils als CAR den
Block-Namen (ein Symbol) haben und als CDR entweder den Pointer auf den
zugehörigen Frame oder, falls der Block bereits verlassen wurde, #DISABLED.

Das Tagbody-Environment
-----------------------
Es enthält die lexikalisch sichtbaren Go-Marken der Tagbodys.
Ein Tagbody-Environment ist gegeben durch einen Pointer auf einen
Tagbody-Frame oder durch eine Assoziationsliste, deren Elemente jeweils als
CAR einen Vektor (mit den Go-Marken als Elementen) haben und als CDR entweder
den Pointer auf den zugehörigen Frame oder, falls der Tagbody bereits
verlassen wurde, #<DISABLED>.

Das Deklarations-Environment
----------------------------
Es enthält die lexikalisch sichtbaren Deklarationen.
Ein Deklarations-Environment ist gegeben durch eine Liste von Declaration-
Specifiers, deren CAR jeweils entweder OPTIMIZE oder DECLARATION oder
ein benutzerdefinierter Deklarationstyp ist.

Übergabe von Environments an LISP-Funktionen
--------------------------------------------
Dafür gibt es zwei Datenstrukturen:
Bei Übergabe als zweites Argument an Macro-Expander-Funktionen (CLTL S.
145-146) und bei Annahme durch MACROEXPAND und MACROEXPAND-1 (CLTL S. 151)
handelt es sich nur um einen 2-elementigen Simple-Vector, bestehend aus einem
genesteten Variablen-Environment und einem genesteten Funktions- und Macro-
Environment. Dasselbe bei Übergabe an SYSTEM::%EXPAND-LAMBDABODY-MAIN u.ä.
Bei Übergabe als zweites Argument an den Wert von *EVALHOOK* bzw. als drittes
Argument an den Wert von *APPLYHOOK* (CLTL S. 322) und bei Annahme durch
EVALHOOK und APPLYHOOK (CLTL S. 323) handelt es sich um einen 5-elementigen
Simple-Vector mit den fünf Einzelkomponenten, alle genestet.

Frames
======
Für den Aufruf von SUBRs, FSUBRs und compilierten Closures werden keine
Frames verwendet.
Es gibt folgende 14 Arten von Frames:
  - Environmentbindungs-Frame (ENV_FRAME),
  - APPLY-Frame (APPLY_FRAME),
  - EVAL-Frame (EVAL_FRAME),
  - dynamischer Variablenbindungs-Frame (DYNBIND_FRAME),
  - Variablenbindungs-Frame (VAR_FRAME),
  - Funktions- oder Macrobindungs-Frame (FUN_FRAME),
  - interpretierter Block-Frame (IBLOCK_FRAME),
  - compilierter Block-Frame (CBLOCK_FRAME),
  - interpretierter Tagbody-Frame (ITAGBODY_FRAME),
  - compilierter Tagbody-Frame (CTAGBODY_FRAME),
  - Catch-Frame (CATCH_FRAME),
  - Unwind-Protect-Frame (UNWIND_PROTECT_FRAME),
  - Handler-Frame (HANDLER_FRAME),
  - Driver-Frame (DRIVER_FRAME).
Zuunterst in einem Frame kommt ein Langwort, das die Frametyp-Information
und einen Pointer über den Frame (= den Wert des STACK vor Aufbau und nach
Abbau des Frame) enthält.
In der Frame-Info sind die Bits
  SKIP2_BIT      gelöscht, falls darüber noch ein weiteres Langwort kommt,
                   das kein LISP-Objekt ist und deswegen von der GC
                   übersprungen werden muß,
  EXITPOINT_BIT  gesetzt bei allen außer VAR und FUN,
  NESTED_BIT     bei IBLOCK und ITAGBODY gesetzt, wenn Exitpoint bzw.
                   Go-Marken bereits in eine Aliste gesteckt wurden.
Die Normalwerte für die Frametyp-Info-Bytes sind ENVxx_FRAME_INFO,
APPLY_FRAME_INFO, EVAL_FRAME_INFO, VAR_FRAME_INFO, FUN_FRAME_INFO,
IBLOCK_FRAME_INFO, CBLOCK_FRAME_INFO, ITAGBODY_FRAME_INFO, CTAGBODY_FRAME_INFO,
CATCH_FRAME_INFO, UNWIND_PROTECT_FRAME_INFO, DRIVER_FRAME_INFO.
Die Routine, die in (SP).L mit SP=SP_(STACK) steht (bei IBLOCK-, CBLOCK-,
ITAGBODY-, CTAGBODY-, CATCH-, UNWIND-PROTECT-Frames), wird
angesprungen durch   MOVE.L SP_(STACK),SP ! RTS  .
Bei DRIVER-Frames durch   MOVE.L SP_(STACK),SP ! MOVE.L (SP),-(SP) ! RTS  .
In der portablen C-Version steht in SP_(STACK) ein Pointer auf einen
setjmp/longjmp-Buffer.

Environmentbindungs-Frames
--------------------------
Sie enthalten dynamische Bindungen von maximal 5 Environments.
Frame-Info ist ENVxx_FRAME_INFO (xx je nachdem, welche der Environments hier
gebunden sind). Aufbau:
    Offset        Stack-Inhalt
  20/16/12/8/4  [alter Wert von DECL_ENV]
  16/12/8/4     [alter Wert von GO_ENV]
  12/8/4        [alter Wert von BLOCK_ENV]
  8/4           [alter Wert von FUN_ENV]
  4             [alter Wert von VAR_ENV]
  0             Frame-Info; Pointer über Frame
Im einzelnen:
ENV1V_frame    für 1 VAR_ENV
ENV1F_frame    für 1 FUN_ENV
ENV1B_frame    für 1 BLOCK_ENV
ENV1G_frame    für 1 GO_ENV
ENV1D_frame    für 1 DECL_ENV
ENV2VD_frame   für 1 VAR_ENV und 1 DECL_ENV
ENV5_frame     für alle 5 Environments

APPLY-Frames
------------
Sie werden erzeugt bei jedem Aufruf (APPLY oder FUNCALL) einer interpretierten
Closure.
Aufbau:
  Offset     Stack-Inhalt
  4n+12
  4n+8      Argument 1
  ...
  12        Argument n
  8         Funktion, die gerade aufgerufen wird
  4         SP
  0         Frame-Info; Pointer über Frame
SP ist ein Pointer in den Programmstack. Rücksprung zu (SP).L nach Auflösung
des APPLY-Frames gibt den Inhalt von A0/... als Werte der Form zurück.
Die Frame-Info hat den Wert APPLY_FRAME_INFO oder TRAPPED_APPLY_FRAME_INFO.

EVAL-Frames
-----------
Sie werden erzeugt bei jedem Aufruf des EVAL-Unterprogramms.
Aufbau:
  Offset     Stack-Inhalt
  8         Form, die gerade evaluiert wird
  4         SP
  0         Frame-Info; Pointer über Frame
SP ist ein Pointer in den Programmstack. Rücksprung zu (SP).L nach Auflösung
des EVAL-Frames gibt den Inhalt von A0/... als Werte der Form zurück.
Die Frame-Info hat den Wert EVAL_FRAME_INFO oder TRAPPED_EVAL_FRAME_INFO.

Dynamische Variablenbindungs-Frames
-----------------------------------
Sie binden dynamisch Symbole an Werte.
Der Aufbau eines solchen Frames mit n Bindungen ist wie folgt:
  Offset  Stack-Inhalt
  8n+4
  8n      Wert 1
  8n-4    Symbol 1
  ...     ...
  8       Wert n
  4       Symbol n
  0       Frame-Info; Pointer über Frame
Der Inhalt des Frameinfo-Bytes ist DYNBIND_FRAME_INFO.

Variablenbindungs-Frames
------------------------
Sie werden erzeugt beim Anwenden von interpretierten Closures (für die in der
Lambda-Liste spezifizierten Variablenbindungen und ggfs. in den Deklarationen
angegebenen dynamischen Referenzen) und von LET und LET*, sowie von allen
Konstrukten, die implizit LET oder LET* benutzen (wie DO, DO*, PROG, PROG*,
DOLIST, DOTIMES, ...).
Der Aufbau eines Variablenbindungs-Frames mit n Bindungen ist wie folgt:
#ifndef NO_symbolflags
  Offset  Stack-Inhalt
  12+8n
  8+8n    Wert 1
  4+8n    Symbol 1
  ...     ...
  16      Wert n
  12      Symbol n
  8       NEXT_ENV
  4       m
  0       Frame-Info; Pointer über Frame
#else
  Offset  Stack-Inhalt
  12+12n
  8+12n   Wert 1
  4+12n   Symbol 1
  12n     Markierungsbits 1
  ...     ...
  20      Wert n
  16      Symbol n
  12      Markierungsbits n
  8       NEXT_ENV
  4       m
  0       Frame-Info; Pointer über Frame
#endif
Die Symbol/Wert-Paare sind dabei in der Reihenfolge numeriert und abgelegt,
in der die Bindungen aktiv werden (d.h. z.B. bei interpretierten Closures:
zuerst die dynamischen Referenzen (SPECIAL-Deklarationen), dann die required-
Parameter, dann die optionalen Parameter, dann der Rest-Parameter, dann die
Keyword-Parameter, dann die AUX-Variablen).
Die Symbole enthalten im Stack folgende Markierungsbits: ACTIVE_BIT, ist
gesetzt, wenn die Bindung aktiv ist, DYNAM_BIT ist gesetzt, wenn die Bindung
dynamisch ist. (Dynamische Referenzen sind als lexikalisch gekennzeichnet
mit dem speziellen Wert #SPECDECL!).
NEXT_ENV ist das nächsthöhere Variablen-Environment.
m ist ein Langwort, 0 <= m <= n, und bedeutet die Anzahl der Bindungen, die
noch nicht durch NEST-Operationen in einen Vektor gesteckt wurden. Also
sind die Symbol/Wert-Paare 1,...,n-m aktiv gewesen, inzwischen aber genestet
und deswegen im Stack (sofern es statische Bindungen waren) wieder inaktiv.
Nur noch einige der Paare n-m+1,...,n können statisch und aktiv sein.
Der Inhalt des Frameinfo-Bytes ist VAR_FRAME_INFO.

Funktions- und Macrobindungs-Frames
-----------------------------------
Sie werden erzeugt von FLET und MACROLET.
Der Aufbau eines Variablenbindungs-Frames mit n Bindungen ist wie folgt:
  Offset  Stack-Inhalt
  12+8n
  8+8n    Wert 1
  4+8n    Symbol 1
  ...     ...
  16      Wert n
  12      Symbol n
  8       NEXT_ENV
  4       m
  0       Frame-Info; Pointer über Frame
NEXT_ENV ist das nächsthöhere Funktions-Environment.
m ist ein Langwort, 0 <= m <= n, und bedeutet die Anzahl der Bindungen, die
noch nicht durch NEST-Operationen in einen Vektor gesteckt wurden. Also sind
die Symbol/Wert-Paare 1,...,n-m aktiv gewesen, inzwischen aber genestet und
deswegen im Stack wieder inaktiv. Nur noch die Paare n-m+1,...,n sind aktiv.
Markierungsbits werden hier im Gegensatz zu den Variablenbindungs-Frames
nicht benötigt.
Alle Werte sind Closures oder Conses (SYSTEM::MACRO . Closure).
Der Inhalt des Frameinfo-Bytes ist FUN_FRAME_INFO.

Interpretierte Block-Frames
---------------------------
Sie werden erzeugt von BLOCK und allen Konstrukten, die ein implizites BLOCK
enthalten (z.B. DO, DO*, LOOP, PROG, PROG*, ...). Der Aufbau ist folgender:
  Offset  Stack-Inhalt
  16
  12       NAME
  8        NEXT_ENV
  4        SP
  0        Frame-Info; Pointer über Frame
NAME ist der Name des Blocks. NEXT_ENV ist das nächsthöhere Block-Environment.
SP ist ein Pointer in den Programmstack, (SP).L ist eine Routine, die den
Block-Frame auflöst und den Block mit den Werten A0-A2/... verläßt.
Frame-Info ist IBLOCK_FRAME_INFO, evtl. mit gesetztem NESTED_BIT (dann zeigt
NEXT_ENV auf eine Aliste, deren erstes Element das Paar (NAME . <Framepointer>)
ist, weil der Block noch nicht DISABLED ist).

Compilierte Block-Frames
------------------------
Aufbau:
  Offset  Stack-Inhalt
   12
   8        Cons (NAME . <Framepointer>)
   4        SP
   0        Frame-Info; Pointer über Frame
NAME ist der Name des Blocks.
SP ist ein Pointer in den Programmstack, (SP).L ist eine Routine, die den
Block-Frame auflöst und den Block mit den Werten A0-A2/... verläßt.
Frame-Info ist CBLOCK_FRAME_INFO.

Interpretierte Tagbody-Frames
-----------------------------
Sie werden erzeugt von TAGBODY und allen Konstrukten, die ein implizites
TAGBODY enthalten (z.B. DO, DO*, PROG, PROG*, ...).
Der Aufbau eines Tagbody-Frames mit n Tags ist folgender:
  Offset  Stack-Inhalt
  12+8n
  8+8n     BODY 1
  4+8n     MARKE 1
  ...      ...
  16       BODY n
  12       MARKE n
  8        NEXT_ENV
  4        SP
  0        Frame-Info; Pointer über Frame
Die Marken sind die Sprungziele; es sind Symbole ud Integers, die sich im
Body befinden. Der zugehörige "Wert" BODY i enthält den Teil des Bodys, der
auf MARKE i folgt. NEXT_ENV ist das nächsthöhere Tagbody-Environment.
SP ist ein Pointer in den Programmstack, (SP).L ist eine Routine, die die
Aktion (GO MARKEi) ausführt, wenn sie mit BODYi in A0 angesprungen wird.
Frame-Info ist ITAGBODY_FRAME_INFO, evtl. mit gesetztem NESTED_BIT (dann
zeigt NEXT_ENV auf eine Aliste, deren erstes Element die Form
(#(MARKE1 ... MARKEn) . <Framepointer>) hat, weil der Tagbody noch nicht
DISABLED ist).

Compilierte Tagbody-Frames
--------------------------
Aufbau:
  Offset  Stack-Inhalt
   12
   8        Cons (#(MARKE1 ... MARKEn) . <Framepointer>)
   4        SP
   0        Frame-Info; Pointer über Frame
MARKE1, ..., MARKEn sind die Namen der Tags (im compilierten Code eigentlich
nur noch zu Fehlermeldungszwecken vorhanden).
SP ist ein Pointer in den Programmstack, (SP).L ist eine Routine, die die
Aktion (GO MARKEi) ausführt, wenn sie mit value1 = i (1 <= i <= n) angesprungen
wird.
Frame-Info ist CTAGBODY_FRAME_INFO.

Catch-Frames
------------
Sie werden erzeugt von der Special-Form CATCH. Ihr Aufbau ist wie folgt:
  Offset  Stack-Inhalt
   12
   8        TAG
   4        SP
   0        Frame-Info; Pointer über Frame
Dabei ist TAG die Marke des Catchers.
SP ist ein Pointer in den Programmstack, (SP).L ist eine Routine, die den
Frame auflöst und die Werte A0-A2/... zurückgibt.
Frame-Info ist CATCH_FRAME_INFO.

Unwind-Protect-Frames
---------------------
Sie werden erzeugt von der Special-Form UNWIND-PROTECT und allen Konstrukten,
die ein implizites UNWIND-PROTECT enthalten (wie WITH-OPEN-STREAM oder
WITH-OPEN-FILE). Ihr Aufbau ist wie folgt:
  Offset  Stack-Inhalt
   8
   4        SP
   0        Frame-Info; Pointer über Frame
SP ist ein Pointer in den Programmstack. (SP).L ist eine Routine, die den
Frame auflöst, die aktuellen Werte A0-A2/... rettet, den Cleanup durchführt,
die geretteten Werte zurückschreibt und schließlich die Adresse anspringt
(mit RTS), die anstelle ihrer eigenen im Programmstack eingetragen wurde,
und dabei D6 unverändert läßt.

Handler-Frames
--------------
Sie werden erzeugt vom Macro HANDLER-BIND. Ihr Aufbau ist wie folgt:
  Offset  Stack-Inhalt
   16
   12       Cons (#(type1 label1 ... typem labelm) . SPdepth)
   8        Closure
   4        SP
   0        Frame-Info; Pointer über Frame
SP ist ein Pointer in den Programmstack. Wenn eine Condition vom Typ typei
auftritt, wird als Handler die Closure ab Byte labeli abinterpretiert, wobei
zuerst ein Stück Programmstack der Länge SPdepth dupliziert wird.

Driver-Frames
-------------
Sie werden erzeut beim Eintritt in eine Top-Level-Schleife (meist eine
READ-EVAL-PRINT-Schleife) und dienen dazu, nach Fehlermeldungen die
vorherige Top-Level-Schleife fortzusetzen. Der Aufbau ist einfach:
  Offset  Stack-Inhalt
   8
   4        SP
   0        Frame-Info; Pointer über Frame
SP ist ein Pointer in den Programmstack. (SP).L ist eine Routine, die
wieder in die zugehörige Top-Level-Schleife einsteigt.

*/

# STACK:
# STACK ist der LISP-Stack.
# STACK_0 ist das erste Objekt auf dem STACK.
# STACK_1 ist das zweite Objekt auf dem STACK.
# etc., allgemein STACK_(n) = (n+1)tes Objekt auf dem STACK.
# pushSTACK(object)  legt ein Objekt auf dem STACK ab. Synonym: -(STACK).
# popSTACK()  liefert STACK_0 und nimmt es dabei vom STACK herunter.
# skipSTACK(n);  nimmt n Objekte vom STACK herunter.
# Will man den Wert des STACK retten, so geht das so:
#   var object* temp = STACK; ... (kein Zugriff über temp !) ... setSTACK(STACK = temp);
#   jedoch: Zugriff über  STACKpointable(temp)  möglich.
# Will man einen Pointer, der durch den Stack laufen kann, so geht das so:
#   var object* ptr = &STACK_0;  oder  = STACKpointable(STACK);
#   assert( *(ptr STACKop 0) == STACK_0 );
#   assert( *(ptr STACKop 1) == STACK_1 );
#   ...
#   ptr skipSTACKop n;
#   assert( *(ptr STACKop 0) == STACK_(n) );
#   ...
#   Dieser Pointer darf nicht wieder dem STACK zugewiesen werden!
# Bringt man im STACK Blöcke von Objekten unter und will den (n+1)-ten Block,
#   so geht das so:  STACKblock_(type,n). Dabei sollte type ein
#   struct-Typ sein mit sizeof(type) ein Vielfaches  von sizeof(object).

  #ifdef STACK_DOWN
    #define STACK_(n)  (STACK[(sintP)(n)])
    #define STACKpointable(STACKvar)  ((object*)(STACKvar))
    #define skipSTACKop  +=
    #define STACKop      +
    #define cmpSTACKop   <
    #define STACKblock_(type,n)  (((type*)STACK)[(sintP)(n)])
  #endif
  #ifdef STACK_UP
    #define STACK_(n)  (STACK[-1-(sintP)(n)])
    #define STACKpointable(STACKvar)  ((object*)(STACKvar)-1)
    #define skipSTACKop  -=
    #define STACKop      -
    #define cmpSTACKop   >
    #define STACKblock_(type,n)  (((type*)STACK)[-1-(sintP)(n)])
  #endif
  #define pushSTACK(obj)  (STACK_(-1) = (obj), STACK skipSTACKop -1)
    # Fast äquivalent zu  *--STACK = obj  bzw.  *STACK++ = obj  , jedoch
    # Vorsicht: erst Objekt in STACK_(-1) eintragen, dann erst STACK verändern!
  #define popSTACK()  (STACK skipSTACKop 1, STACK_(-1))
  #define skipSTACK(n)  (STACK skipSTACKop (sintP)(n))

  #if defined(GNU) && defined(MC680X0) && !defined(NO_ASM) && !defined(WIDE)
    # Mit GNU auf einem 680X0 liegt STACK in einem Register. Zugriff und
    # Veränderung von STACK bilden daher eine ununterbrechbare Einheit.
    #undef pushSTACK
    #undef popSTACK
    #ifdef STACK_DOWN
      # define pushSTACK(obj)  (*--STACK = (obj))
      #define pushSTACK(obj)  \
        ({ __asm__ __volatile__ ("movel %0,"REGISTER_PREFIX""STACK_register"@-" : : "g" ((object)(obj)) : STACK_register ); })
      # define popSTACK()  (*STACK++)
      #define popSTACK()  \
        ({var object __result;                                                                                         \
          __asm__ __volatile__ ("movel "REGISTER_PREFIX""STACK_register"@+,%0" : "=g" (__result) : : STACK_register ); \
          __result;                                                                                                    \
         })
    #endif
    #ifdef STACK_UP
      # define pushSTACK(obj)  (*STACK++ = (obj))
      #define pushSTACK(obj)  \
        ({ __asm__ __volatile__ ("movel %0,"REGISTER_PREFIX""STACK_register"@+" : : "g" ((object)(obj)) : STACK_register ); })
      # define popSTACK()  (*--STACK)
      #define popSTACK()  \
        ({var object __result;                                                                                         \
          __asm__ __volatile__ ("movel "REGISTER_PREFIX""STACK_register"@-,%0" : "=g" (__result) : : STACK_register ); \
          __result;                                                                                                    \
         })
    #endif
  #endif
  #if defined(SPARC) && !defined(GNU) && !defined(__SUNPRO_C) && (SAFETY < 2)
    #undef pushSTACK
    #undef popSTACK
    #undef skipSTACK
    #define pushSTACK(obj)  (STACK_(-1) = (obj), _setSTACK(STACK STACKop -1))
    #define popSTACK()  (_setSTACK(STACK STACKop 1), STACK_(-1))
    #define skipSTACK(n)  (_setSTACK(STACK STACKop (sintP)(n)))
  #endif

  #define STACK_0  (STACK_(0))
  #define STACK_1  (STACK_(1))
  #define STACK_2  (STACK_(2))
  #define STACK_3  (STACK_(3))
  #define STACK_4  (STACK_(4))
  #define STACK_5  (STACK_(5))
  #define STACK_6  (STACK_(6))
  #define STACK_7  (STACK_(7))
  #define STACK_8  (STACK_(8))
  #define STACK_9  (STACK_(9))
  #define STACK_10  (STACK_(10))
  # usw.


# Werte:

# Maximalzahl multiple values + 1
  #define mv_limit  128
# Werte werden immer im MULTIPLE_VALUE_SPACE mv_space übergeben:
  # uintC mv_count : Anzahl der Werte, >=0, <mv_limit
  # object mv_space [mv_limit-1] : die Werte.
  #   Bei mv_count>0 sind genau die ersten mv_count Elemente belegt.
  #   Bei mv_count=0 ist der erste Wert = NIL.
  #   Die Werte in mv_space unterliegen nicht der Garbage Collection!
  #if defined(GNU) && (SAFETY < 2)
    #if defined(SPARC)
      #define mv_count_register  "%g6"
    #endif
    #if defined(HPPA)
      #define mv_count_register  "%r11"  # eines der allgemeinen Register %r5..%r18
      #define NEED_temp_mv_count
    #endif
    #if defined(M88000)
      #define mv_count_register  "%r15"  # eines der allgemeinen Register %r14..%r25
      #define NEED_temp_mv_count
    #endif
    #if defined(DECALPHA)
      #define mv_count_register  "$10"  # eines der allgemeinen Register $9..$14
      #define NEED_temp_mv_count
    #endif
    #if defined(CONVEX)
      #define mv_count_register  "s5"
    #endif
  #endif
  #if !defined(mv_count_register)
    # eine globale Variable
    extern uintC mv_count;
  #else
    # ein globales Register
    register uintC mv_count __asm__(mv_count_register);
    #ifdef HAVE_SAVED_REGISTERS
      register long mv_count_reg __asm__(mv_count_register);
    #endif
  #endif
  extern object mv_space [mv_limit-1];
  # Synonyme:
  #if defined(GNU) && !defined(WIDE_SOFT) && (SAFETY < 2)
    #if defined(SPARC)
      #define value1_register  "%g7"
    #endif
    #if defined(HPPA)
      #define value1_register  "%r12"  # eines der allgemeinen Register %r5..%r18
      #define NEED_temp_value1
    #endif
    #if defined(M88000)
      #define value1_register  "%r16"  # eines der allgemeinen Register %r14..%r25
      #define NEED_temp_value1
    #endif
    #if defined(DECALPHA)
      #define value1_register  "$11"  # eines der allgemeinen Register $9..$14
      #define NEED_temp_value1
    #endif
    #if defined(CONVEX)
      #define value1_register  "s6"
    #endif
  #endif
  #if !defined(value1_register)
    #define value1  mv_space[0]
  #else
    # Der erste Wert mv_space[0] wird permanent in einem Register gelagert:
    register object value1 __asm__(value1_register);
    #ifdef HAVE_SAVED_REGISTERS
      register long value1_reg __asm__(value1_register);
    #endif
    #define VALUE1_EXTRA # und muß deswegen immer extra behandelt werden...
  #endif
  #define value2  mv_space[1]
  #define value3  mv_space[2]
# Zur Übergabe mit setjmp/longjmp braucht man evtl. noch globale Variablen:
  #ifdef NEED_temp_mv_count
    extern uintC temp_mv_count;
    #define SAVE_mv_count()  temp_mv_count = mv_count
    #define RESTORE_mv_count()  mv_count = temp_mv_count
  #else
    #define SAVE_mv_count()
    #define RESTORE_mv_count()
  #endif
  #ifdef NEED_temp_value1
    extern object temp_value1;
    #define SAVE_value1()  temp_value1 = value1
    #define RESTORE_value1()  value1 = temp_value1
  #else
    #define SAVE_value1()
    #define RESTORE_value1()
  #endif
# wird verwendet von EVAL, CONTROL,
#                    Macros LIST_TO_MV, MV_TO_LIST, STACK_TO_MV, MV_TO_STACK

# Liefert die untersten count Objekte vom STACK als Multiple Values.
# STACK_to_mv(count)
# count: Anzahl der Objekte, < mv_limit.
  #if !defined(VALUE1_EXTRA)
    #define STACK_to_mv(countx)  \
      { var reg2 uintC count = (countx);                       \
        mv_count = count;                                      \
        if (count == 0)                                        \
          { value1 = NIL; }                                    \
          else                                                 \
          { object* mvp = &mv_space[count]; # Zeiger hinter Platz für letzten Wert \
            dotimespC(count,count, { *--mvp = popSTACK(); } ); \
      }   }
  #else
    #define STACK_to_mv(countx)  \
      { var reg2 uintC count = (countx);                           \
        mv_count = count;                                          \
        if (count == 0)                                            \
          { value1 = NIL; }                                        \
          else                                                     \
          { count--;                                               \
            if (count > 0)                                         \
              { object* mvp = &mv_space[1+count]; # Zeiger hinter Platz für letzten Wert \
                dotimespC(count,count, { *--mvp = popSTACK(); } ); \
              }                                                    \
            value1 = popSTACK();                                   \
      }   }
  #endif
# wird verwendet von EVAL, CONTROL

# Legt alle Werte auf dem STACK ab.
# mv_to_STACK()
# > mv_count/mv_space : Werte
# < Werte auf dem Stack (erster Wert zuoberst)
# STACK-Overflow wird abgeprüft.
# verändert STACK
  #if !defined(VALUE1_EXTRA)
    #define mv_to_STACK()  \
      { var reg2 uintC count = mv_count;                      \
        if (count==0) ; # keine Werte -> nichts auf den STACK \
          else                                                \
          { var reg1 object* mvp = &mv_space[0];              \
            dotimespC(count,count, { pushSTACK(*mvp++); } );  \
            check_STACK();                                    \
      }   }
  #else
    #define mv_to_STACK()  \
      { var reg2 uintC count = mv_count;                         \
        if (count==0) ; # keine Werte -> nichts auf den STACK    \
          else                                                   \
          { pushSTACK(value1);                                   \
            count--;                                             \
            if (count > 0)                                       \
              { var reg1 object* mvp = &mv_space[1];             \
                dotimespC(count,count, { pushSTACK(*mvp++); } ); \
              }                                                  \
            check_STACK();                                       \
      }   }
  #endif
# wird verwendet von EVAL, CONTROL

# Liefert die Elemente einer Liste als Multiple Values.
# list_to_mv(list,fehler_statement)
# fehler_statement: im Fehlerfall (zuviele Werte).
  #if !defined(VALUE1_EXTRA)
    #define list_to_mv(lst,fehler_statement)  \
      {var reg1 object l = (lst);                                              \
       var reg3 uintC count = 0;                                               \
       if (atomp(l))                                                           \
         value1 = NIL;                                                         \
         else                                                                  \
         { var reg2 object* mvp = &mv_space[0];                                \
           *mvp++ = Car(l); l = Cdr(l); count++; if (atomp(l)) goto mv_fertig; \
           *mvp++ = Car(l); l = Cdr(l); count++; if (atomp(l)) goto mv_fertig; \
           *mvp++ = Car(l); l = Cdr(l); count++; if (atomp(l)) goto mv_fertig; \
           do { *mvp++ = Car(l); l = Cdr(l);                                   \
                count++; if (count==mv_limit) { fehler_statement; }            \
              }                                                                \
              while (consp(l));                                                \
           mv_fertig: mv_count = count;                                        \
      }  }
  #else
    #define list_to_mv(lst,fehler_statement)  \
      {var reg1 object l = (lst);                                              \
       var reg3 uintC count = 0;                                               \
       if (atomp(l))                                                           \
         value1 = NIL;                                                         \
         else                                                                  \
         { value1 = Car(l); l = Cdr(l); count++; if (atomp(l)) goto mv_fertig; \
          {var reg2 object* mvp = &mv_space[1];                                \
           *mvp++ = Car(l); l = Cdr(l); count++; if (atomp(l)) goto mv_fertig; \
           *mvp++ = Car(l); l = Cdr(l); count++; if (atomp(l)) goto mv_fertig; \
           do { *mvp++ = Car(l); l = Cdr(l);                                   \
                count++; if (count==mv_limit) { fehler_statement; }            \
              }                                                                \
              while (consp(l));                                                \
           mv_fertig: mv_count = count;                                        \
      }  }}
  #endif
# wird verwendet von EVAL, CONTROL

# Liefert die Liste der Multiple Values auf -(STACK).
# mv_to_list()
# kann GC auslösen
  #define mv_to_list()  \
    { mv_to_STACK(); # erst alle Werte auf den Stack               \
      pushSTACK(NIL); # Listenanfang                               \
      { var reg2 uintC count;                                      \
        dotimesC(count,mv_count, # bis alle Werte verbraucht sind: \
          { var reg1 object l = allocate_cons(); # neue Zelle      \
            Cdr(l) = popSTACK(); # Liste bisher                    \
            Car(l) = STACK_0; # nächster Wert                      \
            STACK_0 = l; # neues Cons sichern                      \
          });                                                      \
    } }
# wird verwendet von EVAL, CONTROL, DEBUG

# Fehlermeldung bei zu vielen Werten
# fehler_mv_zuviel(caller);
# > caller: Aufrufer, ein Symbol
  nonreturning_function(extern, fehler_mv_zuviel, (object caller));
# wird verwendet von EVAL, CONTROL, LISPARIT

# Während der Ausführung eines SUBR, FSUBR: das aktuelle SUBR bzw. FSUBR.
# subr_self
# (Nur solange gültig, bis ein anderes SUBR oder eine andere Lisp-Funktion
# aufgerufen wird.)
  #if defined(GNU) && (SAFETY < 2)
    #if defined(SPARC) && !defined(WIDE)
      #define subr_self_register  "%g4"  # ein globales Register
      # Neuerdings - bei gcc 2.3 - ist %g4 offenbar ein Scratch-Register.
      # Ab libc.so.1.6.1 (in getwd()) macht das Probleme.
      # Deswegen ist oben HAVE_SAVED_SUBR_SELF definiert.
    #endif
    #if defined(HPPA) && !defined(WIDE)
      #define subr_self_register  "%r13"  # eines der allgemeinen Register %r5..%r18
    #endif
    #if defined(CONVEX)
      #define subr_self_register  "s7"
    #endif
  #endif
  #if !defined(subr_self_register)
    extern object subr_self;
  #else
    register object subr_self __asm__(subr_self_register);
    #ifdef HAVE_SAVED_REGISTERS
      register long subr_self_reg __asm__(subr_self_register);
    #endif
  #endif

# Innerhalb des Body eines SUBR: Zugriff auf die Argumente.
# Ein SUBR mit fester Argumentezahl kann über den STACK auf die Argumente
#   zugreifen: STACK_0 = letztes Argument, STACK_1 = vorletztes Argument etc.
#   STACK aufräumen: mit skipSTACK(Argumentezahl) .
# Ein SUBR mit beliebig vielen Argumenten (&REST-Parameter) bekommt übergeben:
#     uintC argcount              die Anzahl der restlichen Argumente
#     object* rest_args_pointer   Pointer über die restlichen Argumente
#   Zusätzlich:
#     object* args_end_pointer    Pointer unter alle Argumente, von STACK abhängig
#   Zusätzlich möglich:
#     object* args_pointer = rest_args_pointer STACKop (feste Argumentezahl);
#                                 Pointer über das erste Argument
#   Typische Abarbeitungsschleifen:
#     von vorne:
#       until (argcount==0)
#         { var object arg = NEXT(rest_args_pointer); ...; argcount--; }
#       until (rest_args_pointer==args_end_pointer)
#         { var object arg = NEXT(rest_args_pointer); ...; }
#     von hinten:
#       until (argcount==0)
#         { var object arg = BEFORE(args_end_pointer); ...; argcount--; }
#       until (rest_args_pointer==args_end_pointer)
#         { var object arg = BEFORE(args_end_pointer); ...; }
#   Die Macros NEXT und BEFORE verändern ihr Argument!
#   STACK aufräumen: mit set_args_end_pointer(args_pointer)
#     oder skipSTACK((feste Argumentezahl) + (uintL) (restliche Argumentezahl)) .
  #define args_end_pointer  STACK
  #define set_args_end_pointer(new_args_end_pointer)  \
    setSTACK(STACK = (new_args_end_pointer))
  #ifdef STACK_DOWN
    #define NEXT(argpointer)  (*(--(argpointer)))
    #define BEFORE(argpointer)  (*((argpointer)++))
  #endif
  #ifdef STACK_UP
    #define NEXT(argpointer)  (*((argpointer)++))
    #define BEFORE(argpointer)  (*(--(argpointer)))
  #endif
# Next(pointer) liefert denselben Wert wie NEXT(pointer),
# ohne dabei jedoch den Wert von pointer zu verändern.
# Before(pointer) liefert denselben Wert wie BEFORE(pointer),
# ohne dabei jedoch den Wert von pointer zu verändern.
  #define Next(pointer)  (*(STACKpointable(pointer) STACKop -1))
  #define Before(pointer)  (*(STACKpointable(pointer) STACKop 0))

# Environments:

typedef struct { object var_env;   # Variablenbindungs-Environment
                 object fun_env;   # Funktionsbindungs-Environment
                 object block_env; # Block-Environment
                 object go_env;    # Tagbody/Go-Environment
                 object decl_env;  # Deklarations-Environment
               }
        environment;

# Das aktuelle Environment:
  # extern environment aktenv;
# ist ein Teil der Objekttabelle:
# O(akt_var_env), O(akt_fun_env), O(akt_block_env), O(akt_go_env), O(akt_decl_env).
  #define aktenv  (*(environment*)(&O(akt_var_env)))

# Frameinfobits in Frames:
# im Frame-Info-Byte (tint):
#if (oint_type_len>=7) && 0 # vorläufig??
# Bitnummern im Frame-Info-Byte:
# belegen Bits 6..0 (bzw. Bits 7,5..0 falls garcol_bit_t=7).
  #define FB7  garcol_bit_t
  #define FB6  (garcol_bit_t>TB5 ? TB5 : TB6)
  #define FB5  (garcol_bit_t>TB4 ? TB4 : TB5)
  #define FB4  (garcol_bit_t>TB3 ? TB3 : TB4)
  #define FB3  (garcol_bit_t>TB2 ? TB2 : TB3)
  #define FB2  (garcol_bit_t>TB1 ? TB1 : TB2)
  #define FB1  (garcol_bit_t>TB0 ? TB0 : TB1)
# davon abhängig:
  #define frame_bit_t    FB7  # garcol_bit als FRAME-Kennzeichen
  #define skip2_bit_t    FB6  # gelöscht wenn GC zwei Langworte überspringen muß
  #define unwind_bit_t   FB5  # gesetzt, wenn beim Auflösen (UNWIND) des Frames
                              # etwas zu tun ist
  # skip2-Bit=1 ==> unwind-Bit=1.
  # zur näheren Information innerhalb der Frames mit skip2-Bit=1:
    #define envbind_bit_t  FB4  # Bit ist gesetzt bei ENV-Frames.
                                # Bit ist gelöscht bei DYNBIND-Frames.
    # zur näheren Identifikation innerhalb der ENV-Frames:
      #define envbind_case_mask_t  (bit(FB3)|bit(FB2)|bit(FB1))
  # zur näheren Unterscheidung innerhalb der Frames mit skip2-Bit=0:
    #define entrypoint_bit_t  FB4  # Bit ist gesetzt, wenn FRAME einen
                                   # nicht-lokalen Einsprung enthält, mit Offset SP_ ist SP im STACK.
                                   # Bit ist gelöscht bei VAR-Frame und FUN-Frame.
    # zur näheren Unterscheidung in BLOCK/TAGBODY/APPLY/EVAL/CATCH/UNWIND_PROTECT/HANDLER/DRIVER:
      #define blockgo_bit_t    FB3  # Bit gesetzt bei BLOCK- und TAGBODY-FRAME
      # zur näheren Unterscheidung in BLOCK/TAGBODY:
        # Bit FB2 gesetzt bei TAGBODY, gelöscht bei BLOCK,
        #define cframe_bit_t     FB1  # gesetzt bei compilierten, gelöscht bei
                                    # interpretierten BLOCK/TAGBODY-Frames
        #define nested_bit_t unwind_bit_t # für IBLOCK und ITAGBODY, gesetzt,
                                    # wenn Exitpoint bzw. Tags genestet wurden
      # zur näheren Unterscheidung in APPLY/EVAL/CATCH/UNWIND_PROTECT/HANDLER/DRIVER:
        #define dynjump_bit_t  FB2    # gelöscht bei APPLY und EVAL, gesetzt
                                      # bei CATCH/UNWIND_PROTECT/DRIVER-Frames
        #define trapped_bit_t unwind_bit_t # für APPLY und EVAL, gesetzt, wenn
                                    # beim Auflösen des Frames unterbrochen wird
        # unwind-Bit gesetzt bei UNWIND_PROTECT/DRIVER/TRAPPED_APPLY/TRAPPED_EVAL,
        # gelöscht sonst.
        #define eval_bit_t     FB1    # gesetzt bei EVAL-Frames,
                                      # gelöscht bei APPLY-Frames
        #define driver_bit_t   FB1    # gesetzt bei DRIVER-Frames,
                                      # gelöscht bei UNWIND_PROTECT-Frames
        #define handler_bit_t  FB1    # gesetzt bei HANDLER-Frames,
                                      # gelöscht bei CATCH-Frames
    # zur näheren Unterscheidung in VAR/FUN:
      #define fun_bit_t        FB3  # gesetzt bei FUNCTION-FRAME, gelöscht bei VAR-FRAME
# in Objekten auf dem STACK (oint):
  #define frame_bit_o  (frame_bit_t+oint_type_shift)
  #define skip2_bit_o  (skip2_bit_t+oint_type_shift)
  #define unwind_bit_o  (unwind_bit_t+oint_type_shift)
    #define envbind_bit_o  (envbind_bit_t+oint_type_shift)
    #define entrypoint_bit_o  (entrypoint_bit_t+oint_type_shift)
      #define blockgo_bit_o  (blockgo_bit_t+oint_type_shift)
        #define cframe_bit_o  (cframe_bit_t+oint_type_shift)
        #define nested_bit_o  (nested_bit_t+oint_type_shift)
        #define dynjump_bit_o  (dynjump_bit_t+oint_type_shift)
        #define trapped_bit_o  (trapped_bit_t+oint_type_shift)
        #define eval_bit_o  (eval_bit_t+oint_type_shift)
        #define driver_bit_o  (driver_bit_t+oint_type_shift)
        #define handler_bit_o  (handler_bit_t+oint_type_shift)
      #define fun_bit_o  (fun_bit_t+oint_type_shift)
# einzelne Frame-Info-Bytes:
  #define DYNBIND_frame_info          /* %1110... */ (bit(FB7)|bit(FB6)|bit(FB5))
  #define ENV1V_frame_info            /* %1111000 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4))
  #define ENV1F_frame_info            /* %1111001 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4)|bit(FB1))
  #define ENV1B_frame_info            /* %1111010 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4)|bit(FB2))
  #define ENV1G_frame_info            /* %1111011 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4)|bit(FB2)|bit(FB1))
  #define ENV1D_frame_info            /* %1111100 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4)|bit(FB3))
  #define ENV2VD_frame_info           /* %1111101 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB1))
  #define ENV5_frame_info             /* %1111110 */ (bit(FB7)|bit(FB6)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB2))
  #define VAR_frame_info              /* %10100.. */ (bit(FB7)|bit(FB5))
  #define FUN_frame_info              /* %10101.. */ (bit(FB7)|bit(FB5)|bit(FB3))
  #define IBLOCK_frame_info           /* %1001100 */ (bit(FB7)|bit(FB4)|bit(FB3))
  #define NESTED_IBLOCK_frame_info    /* %1011100 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB3))
  #define CBLOCK_frame_info           /* %1011101 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB1))
  #define ITAGBODY_frame_info         /* %1001110 */ (bit(FB7)|bit(FB4)|bit(FB3)|bit(FB2))
  #define NESTED_ITAGBODY_frame_info  /* %1011110 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB2))
  #define CTAGBODY_frame_info         /* %1011111 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB2)|bit(FB1))
  #define APPLY_frame_info            /* %1001000 */ (bit(FB7)|bit(FB4))
  #define TRAPPED_APPLY_frame_info    /* %1011000 */ (bit(FB7)|bit(FB5)|bit(FB4))
  #define EVAL_frame_info             /* %1001001 */ (bit(FB7)|bit(FB4)|bit(FB1))
  #define TRAPPED_EVAL_frame_info     /* %1011001 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB1))
  #define CATCH_frame_info            /* %1001010 */ (bit(FB7)|bit(FB4)|bit(FB2))
  #define HANDLER_frame_info          /* %1001011 */ (bit(FB7)|bit(FB4)|bit(FB2)|bit(FB1))
  #define UNWIND_PROTECT_frame_info   /* %1011010 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB2))
  #define DRIVER_frame_info           /* %1011011 */ (bit(FB7)|bit(FB5)|bit(FB4)|bit(FB2)|bit(FB1))
#endif
#if (oint_type_len==6) || 1 # vorläufig??
# Bitnummern im Frame-Info-Byte:
# belegen Bits 5..0 (bzw. Bits 7,4..0 falls garcol_bit_t=7).
  #define FB6  garcol_bit_t
  #define FB5  (garcol_bit_t>TB4 ? TB4 : TB5)
  #define FB4  (garcol_bit_t>TB3 ? TB3 : TB4)
  #define FB3  (garcol_bit_t>TB2 ? TB2 : TB3)
  #define FB2  (garcol_bit_t>TB1 ? TB1 : TB2)
  #define FB1  (garcol_bit_t>TB0 ? TB0 : TB1)
# davon abhängig:
  #define frame_bit_t    FB6  # garcol_bit als FRAME-Kennzeichen
  #define skip2_bit_t    FB5  # gelöscht wenn GC zwei Langworte überspringen muß
  # define unwind_limit_t  ...  # darüber:
                              # ist beim Auflösen (UNWIND) des Frames etwas zu tun
  # skip2-Bit=1 ==> >= unwind-limit.
  # zur näheren Information innerhalb der Frames mit skip2-Bit=1:
    #define envbind_bit_t  FB4  # Bit ist gesetzt bei ENV-Frames.
                                # Bit ist gelöscht bei DYNBIND-Frames.
    # zur näheren Identifikation innerhalb der ENV-Frames:
      #define envbind_case_mask_t  (bit(FB3)|bit(FB2)|bit(FB1))
  # zur näheren Unterscheidung innerhalb der Frames mit skip2-Bit=0:
    # define entrypoint_limit_t  ...  # darunter:
                                   # wenn FRAME einen nicht-lokalen Einsprung enthält,
                                   # mit Offset SP_ ist SP im STACK.
                                   # darüber: bei VAR-Frame und FUN-Frame.
    # zur näheren Unterscheidung in BLOCK/TAGBODY/APPLY/EVAL/CATCH/UNWIND_PROTECT/HANDLER/DRIVER:
      #define blockgo_bit_t    FB3  # Bit gesetzt bei BLOCK- und TAGBODY-FRAME
      # zur näheren Unterscheidung in BLOCK/TAGBODY:
        # Bit FB1 gesetzt bei TAGBODY, gelöscht bei BLOCK,
        #define cframe_bit_t   FB2  # gesetzt bei compilierten, gelöscht bei
                                    # interpretierten BLOCK/TAGBODY-Frames
        #define nested_bit_t   FB4  # für IBLOCK und ITAGBODY, gesetzt,
                                    # wenn Exitpoint bzw. Tags genestet wurden
      # zur näheren Unterscheidung in APPLY/EVAL/CATCH/UNWIND_PROTECT/HANDLER/DRIVER:
        #define dynjump_bit_t  FB2  # gelöscht bei APPLY und EVAL, gesetzt
                                    # bei CATCH/UNWIND_PROTECT/HANDLER/DRIVER-Frames
        #define trapped_bit_t  FB4  # für APPLY und EVAL, gesetzt, wenn
                                    # beim Auflösen des Frames unterbrochen wird
        # >= unwind_limit_t bei UNWIND_PROTECT/DRIVER/TRAPPED_APPLY/TRAPPED_EVAL,
        # < unwind_limit_t sonst.
        #define eval_bit_t     FB1  # gesetzt bei EVAL-Frames,
                                    # gelöscht bei APPLY-Frames
        #define driver_bit_t   FB1  # gesetzt bei DRIVER-Frames,
                                    # gelöscht bei UNWIND_PROTECT-Frames
        #define handler_bit_t  FB1  # gesetzt bei HANDLER-Frames,
                                    # gelöscht bei CATCH-Frames
    # zur näheren Unterscheidung in VAR/FUN:
      #define fun_bit_t        FB1  # gesetzt bei FUNCTION-FRAME, gelöscht bei VAR-FRAME
# in Objekten auf dem STACK (oint):
  #define frame_bit_o  (frame_bit_t+oint_type_shift)
  #define skip2_bit_o  (skip2_bit_t+oint_type_shift)
    #define envbind_bit_o  (envbind_bit_t+oint_type_shift)
      #define blockgo_bit_o  (blockgo_bit_t+oint_type_shift)
        #define cframe_bit_o  (cframe_bit_t+oint_type_shift)
        #define nested_bit_o  (nested_bit_t+oint_type_shift)
        #define dynjump_bit_o  (dynjump_bit_t+oint_type_shift)
        #define trapped_bit_o  (trapped_bit_t+oint_type_shift)
        #define eval_bit_o  (eval_bit_t+oint_type_shift)
        #define driver_bit_o  (driver_bit_t+oint_type_shift)
        #define handler_bit_o  (handler_bit_t+oint_type_shift)
      #define fun_bit_o  (fun_bit_t+oint_type_shift)
# einzelne Frame-Info-Bytes:
  #define APPLY_frame_info            /* %100000 */ (bit(FB6))
  #define EVAL_frame_info             /* %100001 */ (bit(FB6)|bit(FB1))
  #define CATCH_frame_info            /* %100010 */ (bit(FB6)|bit(FB2))
  #define HANDLER_frame_info          /* %100011 */ (bit(FB6)|bit(FB2)|bit(FB1))
  #define IBLOCK_frame_info           /* %100100 */ (bit(FB6)|bit(FB3))
  #define ITAGBODY_frame_info         /* %100101 */ (bit(FB6)|bit(FB3)|bit(FB1))
  #define unwind_limit_t                            (bit(FB6)|bit(FB3)|bit(FB2))
  #define CBLOCK_frame_info           /* %100110 */ (bit(FB6)|bit(FB3)|bit(FB2))
  #define CTAGBODY_frame_info         /* %100111 */ (bit(FB6)|bit(FB3)|bit(FB2)|bit(FB1))
  #define TRAPPED_APPLY_frame_info    /* %101000 */ (bit(FB6)|bit(FB4))
  #define TRAPPED_EVAL_frame_info     /* %101001 */ (bit(FB6)|bit(FB4)|bit(FB1))
  #define UNWIND_PROTECT_frame_info   /* %101010 */ (bit(FB6)|bit(FB4)|bit(FB2))
  #define DRIVER_frame_info           /* %101011 */ (bit(FB6)|bit(FB4)|bit(FB2)|bit(FB1))
  #define NESTED_IBLOCK_frame_info    /* %101100 */ (bit(FB6)|bit(FB4)|bit(FB3))
  #define NESTED_ITAGBODY_frame_info  /* %101101 */ (bit(FB6)|bit(FB4)|bit(FB3)|bit(FB1))
  #define entrypoint_limit_t                        (bit(FB6)|bit(FB4)|bit(FB3)|bit(FB2))
  #define VAR_frame_info              /* %101110 */ (bit(FB6)|bit(FB4)|bit(FB3)|bit(FB2))
  #define FUN_frame_info              /* %101111 */ (bit(FB6)|bit(FB4)|bit(FB3)|bit(FB2)|bit(FB1))
  #define DYNBIND_frame_info          /* %110... */ (bit(FB6)|bit(FB5))
  #define ENV1V_frame_info            /* %111000 */ (bit(FB6)|bit(FB5)|bit(FB4))
  #define ENV1F_frame_info            /* %111001 */ (bit(FB6)|bit(FB5)|bit(FB4)|bit(FB1))
  #define ENV1B_frame_info            /* %111010 */ (bit(FB6)|bit(FB5)|bit(FB4)|bit(FB2))
  #define ENV1G_frame_info            /* %111011 */ (bit(FB6)|bit(FB5)|bit(FB4)|bit(FB2)|bit(FB1))
  #define ENV1D_frame_info            /* %111100 */ (bit(FB6)|bit(FB5)|bit(FB4)|bit(FB3))
  #define ENV2VD_frame_info           /* %111101 */ (bit(FB6)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB1))
  #define ENV5_frame_info             /* %111110 */ (bit(FB6)|bit(FB5)|bit(FB4)|bit(FB3)|bit(FB2))
#endif

# Bits für Symbole in VAR-Frames:
  # bit(active_bit),bit(dynam_bit),bit(svar_bit) müssen in ein uintB passen:
  #if !((active_bit<intBsize) && (dynam_bit<intBsize) && (svar_bit<intBsize))
    #error "Symbol bits don't fit in a single byte -- Symbol-Bits passen nicht in ein Byte!"
  #endif
  #ifdef NO_symbolflags
    # Bits werden im Stack separat als Fixnums abgelegt.
    #undef oint_symbolflags_shift
    #define oint_symbolflags_shift  oint_addr_shift
  #else
    #if (oint_symbolflags_shift==oint_addr_shift)
      # bit(active_bit),bit(dynam_bit),bit(svar_bit) müssen echte Teiler
      # von varobject_alignment sein:
      #if (varobject_alignment % bit(active_bit+1)) || (varobject_alignment % bit(dynam_bit+1)) || (varobject_alignment % bit(svar_bit+1))
        #error "No more room for three bits in a symbol -- Kein Platz für drei Bits in der Adresse eines Symbols!"
      #endif
    #endif
  #endif
  #define active_bit_o  (active_bit+oint_symbolflags_shift)  # gesetzt: Bindung ist aktiv
  #define dynam_bit_o   (dynam_bit+oint_symbolflags_shift)   # gesetzt: Bindung ist dynamisch
  #define svar_bit_o    (svar_bit+oint_symbolflags_shift)    # gesetzt: nächster Parameter ist supplied-p-Parameter für diesen

# Offsets für Daten in Frames, über STACK_(Offset) zu adressieren:
  #define frame_form      2  # EVAL
  #define frame_closure   2  # APPLY, HANDLER
  #define frame_anz       1  # VAR, FUN
  #define frame_SP        1  # IBLOCK, CBLOCK, ITAGBODY, CTAGBODY,
                             # EVAL, CATCH, UNWIND-PROTECT, HANDLER, DRIVER
  #define frame_next_env  2  # VAR, FUN, IBLOCK, ITAGBODY
  #define frame_ctag      2  # CBLOCK, CTAGBODY
  #define frame_tag       2  # CATCH
  #define frame_handlers  3  # HANDLER
  #define frame_name      3  # IBLOCK
  #define frame_args      3  # APPLY
  #define frame_bindings  3  # VAR, FUN, ITAGBODY
# Aufbau einzelner Bindungen in VAR-Frames:
  #ifdef NO_symbolflags
    #define varframe_binding_size  3
    #define varframe_binding_mark   0
    #define varframe_binding_sym    1
    #define varframe_binding_value  2
    #define pushSTACK_symbolwithflags(symbol,flags)  \
      pushSTACK(symbol); pushSTACK(as_object(as_oint(Fixnum_0) | (oint)(flags)))
  #else
    #define varframe_binding_size  2
    #define varframe_binding_mark   0
    #define varframe_binding_sym    0
    #define varframe_binding_value  1
    #define pushSTACK_symbolwithflags(symbol,flags)  \
      pushSTACK(as_object(as_oint(symbol) | (oint)(flags)))
  #endif

# Spezieller Wert zur Markierung nicht mehr "lebender" BLOCK- und TAGBODY-
# Referenzen (ersetzt den Frame-Pointer im CDR des entsprechenden Cons)
  #define disabled  make_system(0xDDDDDDUL)

# Wert zur Markierung als special deklarierter Referenzen
  #define specdecl  make_system(0xECDECDUL)

# Hantieren mit Frames:
# Eine lokale Variable FRAME enthalte den Wert von STACK nach Aufbau
# eines Frames. Dann kann man mit FRAME_(n) genauso wie mit STACK_(n)
# zugreifen:
  #ifdef STACK_DOWN
    #define FRAME_(n)  (FRAME[(sintP)(n)])
  #endif
  #ifdef STACK_UP
    #define FRAME_(n)  (FRAME[-1-(sintP)(n)])
  #endif
# make_framepointer(FRAME) ist der Frame-Pointer als Lisp-Objekt.
# mtypecode(FRAME_(0)) ist das Frame-Info-Byte,
# topofframe(FRAME_(0)) ist ein Pointer über den Frame.
# FRAME = uTheFramepointer(obj) ist ein Frame-Pointer als Pointer in den Stack.
#         [uTheFramepointer ist das genaue Gegenteil von make_framepointer.]
# FRAME = TheFramepointer(obj) ebenfalls, aber evtl. doch noch mit Typinfo!
#         [Eine Abschwächung von uTheFramepointer, die zum Zugreifen ausreicht.]
  #if !defined(SINGLEMAP_MEMORY_STACK)
    #define make_framepointer(stack_ptr)  type_pointer_object(system_type,stack_ptr)
    #define topofframe(bottomword)  (object*)upointer(bottomword)
    #define uTheFramepointer(obj)  (object*)upointer(obj)
  #else
    #define make_framepointer(stack_ptr)  (as_object((oint)(stack_ptr)))
    #define topofframe(bottomword)  (object*)as_oint(type_pointer_object(system_type,upointer(bottomword)))
    #define uTheFramepointer(obj)  TheFramepointer(obj) # = (object*)(obj)
  #endif
# wird verwendet von EVAL, CONTROL, DEBUG

# Zur Bestimmung der Größe eines Frames:
# STACK_item_count(new_STACK_ptr,old_STACK_ptr)
# berechnet die Anzahl der STACK-Elemente zwischen einem älteren Stackpointer
# old_STACK_ptr und einem neueren new_STACK_ptr.
# (Also count mit  old_STACK_ptr = new_STACK_ptr STACKop count .)
  #ifdef STACK_DOWN
    #define STACK_item_count(new_STACK_ptr,old_STACK_ptr)  \
      (uintL)((old_STACK_ptr) - (new_STACK_ptr))
  #endif
  #ifdef STACK_UP
    #define STACK_item_count(new_STACK_ptr,old_STACK_ptr)  \
      (uintL)((new_STACK_ptr) - (old_STACK_ptr))
  #endif

# Beendet einen Frame.
# finish_frame(frametype);
# > object* top_of_frame: Pointer übern Frame
# erniedrigt STACK um 1
  #if !defined(SINGLEMAP_MEMORY_STACK)
    #define framebottomword(type,top_of_frame)  \
      type_pointer_object(type,top_of_frame)
  #else # top_of_frame hat selber schon Typinfo system_type
    #define framebottomword(type,top_of_frame)  \
      as_object(type_zero_oint(type)-type_zero_oint(system_type)+(oint)(top_of_frame))
  #endif
  #define finish_frame(frametype)  \
    pushSTACK(framebottomword(frametype##_frame_info,top_of_frame))
# wird verwendet von EVAL, CONTROL

# Baut einen Frame für alle 5 Environments
# make_ENV5_frame();
# erniedrigt STACK um 5
  #define make_ENV5_frame()  \
    {var reg1 object* top_of_frame = STACK; \
     pushSTACK(aktenv.decl_env);            \
     pushSTACK(aktenv.go_env);              \
     pushSTACK(aktenv.block_env);           \
     pushSTACK(aktenv.fun_env);             \
     pushSTACK(aktenv.var_env);             \
     finish_frame(ENV5);                    \
    }
# wird verwendet von EVAL, CONTROL, DEBUG

# Beendet einen Frame mit Entrypoint und setzt den Einsprungpunkt hierher.
# finish_entry_frame(frametype,returner,retval_zuweisung,reentry_statement);
# > object* top_of_frame: Pointer übern Frame
# > jmp_buf* returner: longjmp-Buffer für Wiedereintritt
# > retval_zuweisung: Zuweisung des setjmp()-Wertes an eine Variable
# > reentry_statement: Was sofort nach Wiedereintritt zu tun ist.
# erniedrigt STACK um 1
  #define finish_entry_frame(frametype,returner,retval_zuweisung,reentry_statement)  \
    { pushSTACK(as_object((aint)(returner))); # SP in den Stack                 \
      pushSTACK(nullobj); # Dummy in den Stack, bis Wiedereintritt erlaubt ist  \
      if (!((retval_zuweisung setjmpl(returner))==0)) # Wiedereinspungpunkt herstellen \
        { RESTORE_mv_count(); RESTORE_value1(); reentry_statement } # nach dem Wiedereintritt \
        else                                                                    \
        { STACK_0 = framebottomword(frametype##_frame_info,top_of_frame); }     \
    }
# wird verwendet von EVAL, CONTROL, DEBUG

# Springt einen Frame mit Entrypoint an, der bei STACK beginnt.
# (Wichtig: Beim Einsprung muß der STACK denselben Wert haben wie beim Aufbau
# des Frames, da der STACK bei setjmp/longjmp vielleicht gerettet wird!)
# Kehrt nie zurück und räumt den SP auf!!
# Die multiple values werden übergeben.
# enter_frame_at_STACK();
  #define enter_frame_at_STACK()  \
    { var reg1 jmp_buf* returner = (void*)(aint)as_oint(STACK_(frame_SP)); # der returner von finish_entry_frame \
      SAVE_value1(); SAVE_mv_count();                                                                            \
      longjmpl(&!*returner,(aint)returner); # dorthin springen, eigene Adresse (/=0) übergeben                   \
      NOTREACHED                                                                                                 \
    }
# wird verwendet von EVAL

# Bei Driver-Frames ist evtl. auch noch der Wert
# von NUM_STACK_normal vor Aufbau des Frames enthalten:
  typedef struct { jmp_buf returner; # zuerst - wie bei allen - der jmp_buf
                   #ifdef HAVE_NUM_STACK
                   uintD* old_NUM_STACK_normal;
                   #endif
                 }
          DRIVER_frame_data;

# UP: Wendet eine Funktion auf ihre Argumente an.
# apply(function,args_on_stack,other_args);
# > function: Funktion
# > Argumente: args_on_stack Argumente auf dem STACK,
#              restliche Argumentliste in other_args
# < STACK: aufgeräumt (d.h. STACK wird um args_on_stack erhöht)
# < mv_count/mv_space: Werte
# verändert STACK, kann GC auslösen
  extern Values apply (object fun, uintC args_on_stack, object other_args);
# wird verwendet von EVAL, CONTROL, IO, PATHNAME, ERROR

# UP: Wendet eine Funktion auf ihre Argumente an.
# funcall(function,argcount);
# > function: Funktion
# > Argumente: argcount Argumente auf dem STACK
# < STACK: aufgeräumt (d.h. STACK wird um argcount erhöht)
# < mv_count/mv_space: Werte
# verändert STACK, kann GC auslösen
  extern Values funcall (object fun, uintC argcount);
# wird verwendet von allen Modulen

# UP: Wertet eine Form im aktuellen Environment aus.
# eval(form);
# > form: Form
# < mv_count/mv_space: Werte
# kann GC auslösen
  extern Values eval (object form);
# wird verwendet von CONTROL, DEBUG

# UP: Wertet eine Form in einem gegebenen Environment aus.
# eval_5env(form,var,fun,block,go,decl);
# > var_env: Wert für VAR_ENV
# > fun_env: Wert für FUN_ENV
# > block_env: Wert für BLOCK_ENV
# > go_env: Wert für GO_ENV
# > decl_env: Wert für DECL_ENV
# > form: Form
# < mv_count/mv_space: Werte
# kann GC auslösen
  extern Values eval_5env (object form, object var_env, object fun_env, object block_env, object go_env, object decl_env);
# wird verwendet von

# UP: Wertet eine Form in einem leeren Environment aus.
# eval_noenv(form);
# > form: Form
# < mv_count/mv_space: Werte
# kann GC auslösen
  extern Values eval_noenv (object form);
# wird verwendet von CONTROL, IO, DEBUG, SPVW

# UP: Wertet eine Form im aktuellen Environment aus. Nimmt dabei auf
# *EVALHOOK* und *APPLYHOOK* keine Rücksicht.
# eval_no_hooks(form);
# > form: Form
# < mv_count/mv_space: Werte
# kann GC auslösen
  extern Values eval_no_hooks (object form);
# wird verwendet von CONTROL

# UP: bindet *EVALHOOK* und *APPLYHOOK* dynamisch an die gegebenen Werte.
# bindhooks(evalhook_value,applyhook_value);
# > evalhook_value: Wert für *EVALHOOK*
# > applyhook_value: Wert für *APPLYHOOK*
# verändert STACK
  extern void bindhooks (object evalhook_value, object applyhook_value);
# wird verwendet von CONTROL

# UP: Löst einen Frame auf, auf den STACK zeigt.
# unwind();
# Die Werte mv_count/mv_space bleiben dieselben.
# Falls es kein Unwind-Protect-Frame ist: kehrt normal zurück.
# Falls es ein Unwind-Protect-Frame ist:
#   rettet die Werte, klettert STACK und SP hoch
#   und springt dann unwind_protect_to_save.fun an.
# verändert STACK
# kann GC auslösen
  typedef /* nonreturning */ void (*restart)(object* upto_frame);
  typedef struct { restart fun; object* upto_frame; } unwind_protect_caller;
  extern unwind_protect_caller unwind_protect_to_save;
  extern void unwind (void);
# wird verwendet von CONTROL, DEBUG, SPVW

# UP: "unwindet" den STACK bis zum nächsten DRIVER_FRAME und
# springt in die entsprechende Top-Level-Schleife.
# reset();
  nonreturning_function(extern, reset, (void));
# wird verwendet von SPVW, CONTROL

# UP: bindet dynamisch die Symbole der Liste symlist
# an die Werte aus der Liste vallist.
# progv(symlist,vallist);
# > symlist, vallist: zwei Listen
# Es wird genau ein Variablenbindungsframe aufgebaut.
# verändert STACK
  extern void progv (object symlist, object vallist);
# wird verwendet von CONTROL

# UP: Löst die dynamische Schachtelung im STACK auf bis zu dem Frame
# (ausschließlich), auf den upto zeigt, und springt diesen dann an.
# unwind_upto(upto);
# > upto: Pointer auf einen Frame (in den Stack, ohne Typinfo).
# Rettet die Werte mv_count/mv_space.
# verändert STACK,SP
# kann GC auslösen
# Springt dann den gefundenen Frame an.
  nonreturning_function(extern, unwind_upto, (object* upto_frame));
# wird verwendet von CONTROL, DEBUG

# UP: throwt zum Tag tag und übergibt dabei die Werte mv_count/mv_space.
# Kommt nur dann zurück, wenn es keinen CATCH-Frame dieses Tags gibt.
# throw(tag);
  extern void throw (object tag);
# wird verwendet von CONTROL

# UP: Ruft alle Handler zur Condition cond auf. Kommt nur zurück, wenn keiner
# dieser Handler sich zuständig fühlt (d.h. wenn jeder Handler zurückkehrt).
# invoke_handlers(cond);
# kann GC auslösen
  extern void invoke_handlers (object cond);
# wird verwendet von ERROR

# UP: Stellt fest, ob ein Objekt ein Funktionsname, d.h. ein Symbol oder
# eine Liste der Form (SETF symbol), ist.
# funnamep(obj)
# > obj: Objekt
# < ergebnis: TRUE falls Funktionsname
  extern boolean funnamep (object obj);
# wird verwendet von CONTROL

# UP: Stellt fest, ob ein Symbol im aktuellen Environment einen Macro darstellt.
# sym_macrop(symbol)
# > symbol: Symbol
# < ergebnis: TRUE falls sym einen Symbol-Macro darstellt
  extern boolean sym_macrop (object sym);
# wird verwendet von CONTROL

# UP: Setzt den Wert eines Symbols im aktuellen Environment.
# setq(symbol,value);
# > symbol: Symbol, keine Konstante
# > value: gewünschter Wert des Symbols im aktuellen Environment
  extern void setq (object sym, object value);
# wird verwendet von CONTROL

# UP: Liefert zu einem Symbol seine Funktionsdefinition in einem Environment
# sym_function(sym,fenv)
# > sym: Funktionsname (z.B. Symbol)
# > fenv: ein Funktions- und Macrobindungs-Environment
# < ergebnis: Funktionsdefinition, entweder unbound (falls undefinierte Funktion)
#             oder Closure/SUBR/FSUBR oder ein Cons (SYS::MACRO . expander).
  extern object sym_function (object sym, object fenv);
# wird verwendet von CONTROL

# UP: "nestet" ein FUN-Environment, d.h. schreibt alle aktiven Bindungen
# aus dem Stack in neu allozierte Vektoren.
# nest_fun(env)
# > env: FUN-Env
# < ergebnis: selbes Environment, kein Pointer in den Stack
# kann GC auslösen
  extern object nest_fun (object env);
# wird verwendet von CONTROL

# UP: Nestet die Environments in *env (d.h. schreibt alle Informationen in
# Stack-unabhängige Strukturen) und schiebt sie auf den STACK.
# nest_env(env)
# > environment* env: Pointer auf fünf einzelne Environments
# < environment* ergebnis: Pointer auf die Environments im STACK
# verändert STACK, kann GC auslösen
  extern environment* nest_env (environment* env);
# wird verwendet von Macro nest_aktenv

# UP: Nestet die aktuellen Environments (d.h. schreibt alle Informationen in
# Stack-unabhängige Strukturen) und schiebt sie auf den STACK.
# (Die Werte VAR_ENV, FUN_ENV, BLOCK_ENV, GO_ENV, DECL_ENV werden nicht
# verändert, da evtl. noch inaktive Bindungen in Frames sitzen, die ohne
# Veränderung von VAR_ENV aktiviert werden können müssen.)
# nest_aktenv()
# < environment* ergebnis: Pointer auf die Environments im STACK
# verändert STACK, kann GC auslösen
  # extern environment* nest_aktenv (void);
  #define nest_aktenv()  nest_env(&aktenv)
# wird verwendet von CONTROL

# UP: Ergänzt ein Deklarations-Environment um ein decl-spec.
# augment_decl_env(declspec,env)
# > declspec: Deklarations-Specifier, ein Cons
# > env: Deklarations-Environment
# < ergebnis: neues (evtl. augmentiertes) Deklarations-Environment
# kann GC auslösen
  extern object augment_decl_env (object new_declspec, object env);
# wird verwendet von CONTROL

# UP: expandiert eine Form, falls möglich, (nicht jedoch, wenn FSUBR-Aufruf
# oder Symbol) in einem Environment
# macroexp(form,venv,fenv);
# > form: Form
# > venv: ein Variablen- und Symbolmacro-Environment
# > fenv: ein Funktions- und Macrobindungs-Environment
# < value1: die Expansion
# < value2: NIL, wenn nicht expandiert,
#           T, wenn expandiert wurde
# kann GC auslösen
  extern void macroexp (object form, object venv, object fenv);
# wird verwendet von CONTROL

# UP: expandiert eine Form, falls möglich, (auch, wenn FSUBR-Aufruf)
# in einem Environment
# macroexp0(form,env);
# > form: Form
# > env: ein Macroexpansions-Environment
# < value1: die Expansion
# < value2: NIL, wenn nicht expandiert,
#           T, wenn expandiert wurde
# kann GC auslösen
  extern void macroexp0 (object form, object env);
# wird verwendet von CONTROL

# UP: Parse-Declarations-Docstring. Trennt von einer Formenliste diejenigen
# ab, die als Deklarationen bzw. Dokumentationsstring angesehen werden
# müssen.
# parse_dd(formlist,venv,fenv)
# > formlist: ( {decl|doc-string} . body )
# > venv: ein Variablen- und Symbolmacro-Environment (für die Macroexpansionen)
# > fenv: Funktions- und Macrobindungs-Environment (für die Macroexpansionen)
# < value1: body
# < value2: Liste der decl-specs
# < value3: Doc-String oder NIL
# < ergebnis: TRUE falls eine (COMPILE)-Deklaration vorkam, FALSE sonst
# kann GC auslösen
  extern boolean parse_dd (object formlist, object venv, object fenv);
# wird verwendet von CONTROL

# UP: Erzeugt zu einem Lambdabody die entsprechende Closure durch Zerlegen
# der Lambdaliste und eventuelles Macroexpandieren aller Formen.
# get_closure(lambdabody,name,env)
# > lambdabody: (lambda-list {decl|doc} {form})
# > name: Name, ein Symbol oder (SETF symbol)
# > env: Pointer auf die fünf einzelnen Environments:
#        env->var_env = VENV, env->fun_env = FENV,
#        env->block_env = BENV, env->go_env = GENV,
#        end->decl_env = DENV.
# < ergebnis: Closure
# kann GC auslösen
  extern object get_closure (object lambdabody, object name, environment* env);
# wird verwendet von CONTROL, SYMBOL, PREDTYPE

# UP: Wandelt ein Argument in eine Funktion um.
# coerce_function(obj)
# > obj: Objekt
# > subr_self: Aufrufer (ein SUBR)
# < ergebnis: Objekt als Funktion (SUBR oder Closure)
# kann GC auslösen
  extern object coerce_function (object obj);
# wird verwendet von IO, FOREIGN


#define DYNBIND_SIZE 3

# Bindet ein Symbol dynamisch an einen Wert.
# Baut hierzu einen dynamischen Variablenbindungsframe für 1 Variable auf.
# dynamic_bind(var,val)
# > var: ein Symbol
# > val: der neue Wert
# verringert STACK um 3 Einträge
# verändert STACK

# kann GC auslösen
#define dynamic_bind__(variable,val_to_use)                      \
  { var reg2 object* top_of_frame = STACK;                       \
    var reg1 object sym_to_bind = (variable);                    \
    # Frame aufbauen:                                            \
    pushSTACK(Symbol_symvalue(sym_to_bind));                     \
    pushSTACK(sym_to_bind);                                      \
    pushSTACK(framebottomword(DYNBIND_frame_info,top_of_frame)); \
    # Wert modifizieren:                                         \
    set_Symbol_symvalue(sym_to_bind,(val_to_use));               \
  }
#ifndef DYNBIND_LIST
  # kann GC auslösen
  #define dynamic_bind dynamic_bind__
#else
  # kann GC auslösen
  #define dynamic_bind(variable,val_to_use)  \
    { var reg1 object value = (val_to_use);  \
      dynamic_bind__(variable,value);        \
      add_frame_to_binding_list(&STACK_0);   \
    }
#endif

# wird verwendet von IO, EVAL, DEBUG, ERROR

# Löst einen dynamischen Variablenbindungsframe für 1 Variable auf.
# dynamic_unbind()
# erhöht STACK um 3 Einträge
# verändert STACK
#define dynamic_unbind__()                         \
  { # Wert zurückschreiben:                        \
    set_Symbol_symvalue(STACK_(1),STACK_(2));      \
     # Frame abbauen:                              \
  }

#ifndef DYNBIND_LIST
  #define dynamic_unbind()                         \
    { dynamic_unbind__();                          \
      skipSTACK(3);                                \
    }
#else
  #define dynamic_unbind()                         \
    { dynamic_unbind__();                          \
      delete_frame_from_binding_list(&STACK_0);    \
      skipSTACK(3);                                \
    }
#endif

# wird verwendet von IO, DEBUG

# Führt "implizites PROGN" aus.
# implicit_progn(body,default)
# Führt body als implizites PROGN aus. Falls body leer, ist default der Wert.
# kann GC auslösen
  #define implicit_progn(body,default)  \
    { var reg1 object rest = (body);                                     \
      if atomp(rest)                                                     \
        { value1 = (default); mv_count=1; } # default als Wert           \
        else                                                             \
          do { pushSTACK(Cdr(rest)); eval(Car(rest)); rest=popSTACK(); } \
             while (consp(rest));                                        \
    }
# wird verwendet von EVAL, CONTROL

# Maximalzahl von Parametern in einer Lambdaliste
# (= Wert von LAMBDA-PARAMETERS-LIMIT - 1)
  #define lp_limit_1  ((uintL)(bitm(intCsize)-1))

# Maximalzahl von Argumenten bei einem Funktionsaufruf
# (= Wert von CALL-ARGUMENTS-LIMIT - 1)
  #define ca_limit_1  ((uintL)(bitm(intCsize)-1))

# Der Macro LISPSPECFORM leitet eine LISP-Special-Form-Deklaration ein.
# LISPSPECFORM(name,req_anz,opt_anz,body_flag)
# > name: C-Name der Funktion und des Symbols.
# > req_anz: Anzahl der required Parameter
# > opt_anz: Anzahl der optionalen Parameter
# > body_flag: body oder nobody, zeigt an, ob &BODY vorhanden
# Siehe FSUBR.D
  #define LISPSPECFORM  LISPSPECFORM_B
# wird verwendet von CONTROL

# Der Macro LISPFUN leitet eine LISP-Funktions-Deklaration ein.
# LISPFUN(name,req_anz,opt_anz,rest_flag,key_flag,key_anz,allow_flag,keywords)
# > name: der Funktionsname (ein C-Identifier)
# > req_anz: die Anzahl der required-Parameter (eine Zahl)
# > opt_anz: die Anzahl der optional-Parameter (eine Zahl)
# > rest_flag: entweder norest oder rest, zeigt an, ob &REST vorhanden
# > key_flag: entweder nokey oder key, zeigt an, ob &KEY vorhanden
# > key_anz: Anzahl der Keyword-Parameter, eine Zahl (0 falls nokey)
# > allow_flag: entweder noallow oder allow, zeigt an, on &ALLOW-OTHER-KEYS
#               nach &KEY vorhanden (noallow falls nokey)
# > keywords: entweder NIL oder ein Ausdruck der Form v(kw(keyword1),...,kw(keywordn))
#             (NIL falls nokey)
# Siehe SUBR.D
  #define LISPFUN  LISPFUN_B
# wird verwendet von allen Modulen

# Der Macro LISPFUNN leitet eine einfache LISP-Funktions-Deklaration ein.
# LISPFUNN(name,req_anz)
# > name: der Funktionsname (ein C-Identifier)
# > req_anz: die (feste) Anzahl der Argumente (eine Zahl)
# Siehe SUBR.D
# wird verwendet von allen Modulen


# ##################### CTRLBIBL zu CONTROL.D ############################# #

# Fehler, wenn ein Block bereits verlassen wurde.
# fehler_block_left(name);
# > name: Block-Name
  nonreturning_function(extern, fehler_block_left, (object name));
# wird verwendet von EVAL

# Fehlermeldung wegen undefinierter Funktion.
# fehler_undef_function(caller,symbol);
# > caller: Aufrufer (ein Symbol)
# > symbol: Symbol oder (SETF symbol)
  nonreturning_function(extern, fehler_undef_function, (object caller, object symbol));
# wird verwendet von PREDTYPE

# ####################### ARRBIBL zu ARRAY.D ############################## #

# ARRAY-TOTAL-SIZE-LIMIT wird so groß gewählt, daß die Total-Size eines
# jeden Arrays ein Fixnum (>=0, <2^oint_data_len) ist:
  #define arraysize_limit_1  ((uintL)(bitm(oint_data_len)-1))

# ARRAY-RANK-LIMIT wird so groß gewählt, daß der Rang eines jeden Arrays
# ein uintC ist:
  #define arrayrank_limit_1  ((uintL)(bitm(intCsize)-1))

# UP: Kopiert einen Simple-Vector
# copy_svector(vector)
# > vector : Simple-Vector
# < ergebnis : neuer Simple-Vector desselben Inhalts
# kann GC auslösen
  extern object copy_svector (object vector);
# wird verwendet von IO, REXX

# UP: Bestimmt die aktive Länge eines Vektors (wie in LENGTH)
# vector_length(vector)
# > vector: ein Vektor
# < ergebnis: seine Länge als uintL
  extern uintL vector_length (object vector);
# wird verwendet von SEQUENCE, CHARSTRG, PREDTYPE, IO, HASHTABL, SPVW

# Wandelt element-type in einen der Standard-Typen um
# und liefert seinen Elementtyp-Code.
# eltype_code(element_type)
# > element_type: Type-Specifier
# < ergebnis: Elementtyp-Code Atype_xxx
# Standard-Typen sind die möglichen Ergebnisse von ARRAY-ELEMENT-TYPE
# (Symbole T, BIT, STRING-CHAR und Listen (UNSIGNED-BYTE n)).
# Das Ergebnis ist ein Obertyp von element-type.
# kann GC auslösen
  extern uintB eltype_code (object element_type);
# wird verwendet von SEQUENCE

# UP: Liefert zu einem Array gegebener Größe den Datenvektor und den Offset.
# Überprüft auch, ob alle Elemente des Arrays physikalisch vorhanden sind.
# array1_displace_check(array,size,&index)
# > object array: (echter) Array
# > uintL size: Größe
# < ergebnis: Datenvektor
# < index: wird um den Offset in den Datenvektor erhöht.
  extern object array1_displace_check (object array, uintL size, uintL* index);
# wird verwendet von IO, CHARSTRG, PREDTYPE, STREAM, SEQUENCE

# UP: Liefert zu einem Array gegebener Größe den Datenvektor und den Offset.
# Überprüft auch, ob alle Elemente des Arrays physikalisch vorhanden sind.
# array_displace_check(array,size,&index)
# > object array: Array
# > uintL size: Größe
# < ergebnis: Datenvektor
# < index: wird um den Offset in den Datenvektor erhöht.
  extern object array_displace_check (object array, uintL size, uintL* index);
# wird verwendet von PATHNAME, HASHTABL, PREDTYPE, IO

# Führt einen AREF-Zugriff aus.
# datenvektor_aref(datenvektor,index)
# > datenvektor : ein Datenvektor (simpler Vektor oder semi-simpler Byte-Vektor)
# > index : (geprüfter) Index in den Datenvektor
# < ergebnis : (AREF datenvektor index)
# kann GC auslösen
  extern object datenvektor_aref (object datenvektor, uintL index);
# wird verwendet von IO

# UP: fragt ein Bit in einem Simple-Bit-Vector ab
# if (sbvector_btst(sbvector,index)) ...
# > sbvector: ein Simple-Bit-Vector
# > index: Index (Variable, sollte < (length sbvector) sein)
  #define sbvector_btst(sbvector_from_sbvector_btst,index_from_sbvector_btst)  \
    ( # im Byte (index div 8) das Bit 7 - (index mod 8) : \
     TheSbvector(sbvector_from_sbvector_btst)->data[(uintL)(index_from_sbvector_btst)/8] \
       & bit((~(uintL)(index_from_sbvector_btst)) % 8)    \
    )
# wird verwendet von ARRAY, SEQUENCE, IO

# UP: löscht ein Bit in einem Simple-Bit-Vector
# sbvector_bclr(sbvector,index);
# > sbvector: ein Simple-Bit-Vector
# > index: Index (Variable, sollte < (length sbvector) sein)
  #define sbvector_bclr(sbvector_from_sbvector_bclr,index_from_sbvector_bclr)  \
    ( # im Byte (index div 8) das Bit 7 - (index mod 8) löschen: \
      TheSbvector(sbvector_from_sbvector_bclr)->data[(uintL)(index_from_sbvector_bclr)/8] \
        &= ~bit((~(uintL)(index_from_sbvector_bclr)) % 8)        \
    )
# wird verwendet von IO

# UP: setzt ein Bit in einem Simple-Bit-Vector
# sbvector_bset(sbvector,index);
# > sbvector: ein Simple-Bit-Vector
# > index: Index (Variable, sollte < (length sbvector) sein)
  #define sbvector_bset(sbvector_from_sbvector_bset,index_from_sbvector_bset)  \
    ( # im Byte (index div 8) das Bit 7 - (index mod 8) setzen: \
      TheSbvector(sbvector_from_sbvector_bset)->data[(uintL)(index_from_sbvector_bset)/8] \
        |= bit((~(uintL)(index_from_sbvector_bset)) % 8)        \
    )
# wird verwendet von SEQUENCE, IO

# UP, liefert den Element-Typ eines Arrays
# array_element_type(array)
# > array : ein Array (simple oder nicht)
# < ergebnis : Element-Typ, eines der Symbole T, BIT, STRING-CHAR, oder eine Liste
# kann GC auslösen
  extern object array_element_type (object array);
# wird verwendet von PREDTYPE, IO

# UP, bildet Liste der Dimensionen eines Arrays
# array_dimensions(array)
# > array: ein Array (simple oder nicht)
# < ergebnis: Liste seiner Dimensionen
# kann GC auslösen
  extern object array_dimensions (object array);
# wird verwendet von PREDTYPE, IO

# UP, liefert Dimensionen eines Arrays und ihre Teilprodukte
# array_dims_sizes(array,&dims_sizes);
# > array: (echter) Array vom Rang r
# > struct { uintL dim; uintL dimprod; } dims_sizes[r]: Platz fürs Ergebnis
# < für i=1,...r:  dims_sizes[r-i] = { Dim_i, Dim_i * ... * Dim_r }
  typedef struct { uintL dim; uintL dimprod; }  array_dim_size;
  extern void array_dims_sizes (object array, array_dim_size* dims_sizes);
# wird verwendet von IO

# Liefert die Gesamtgröße eines Arrays
# array_total_size(array)
# > array: ein Array (simple oder nicht)
# < uintL ergebnis: seine Gesamtgröße
  #define array_total_size(array)  \
    (array_simplep(array)                                                   \
      ? TheSarray(array)->length # simpler Vektor: Länge                    \
      : TheArray(array)->totalsize # nicht-simpler Array enthält Total-Size \
    )
# wird verwendet von ARRAY, PREDTYPE, IO, SEQUENCE

# Unterprogramm für Bitvektor-Vergleich:
# bit_compare(array1,index1,array2,index2,count)
# > array1: erster Bit-Array,
# > index1: absoluter Index in array1
# > array2: zweiter Bit-Array,
# > index2: absoluter Index in array2
# > count: Anzahl der zu vergleichenden Bits
# < ergebnis: TRUE, wenn die Ausschnitte bitweise gleich sind, FALSE sonst.
  extern boolean bit_compare (object array1, uintL index1,
                              object array2, uintL index2,
                              uintL bitcount);
# wird verwendet von PREDTYPE

# UP: Testet, ob ein Array einen Fill-Pointer hat.
# array_has_fill_pointer_p(array)
# > array: ein Array
# < TRUE, falls ja; FALSE falls nein.
  extern boolean array_has_fill_pointer_p (object array);
# wird verwendet von SEQUENCE, STREAM, IO

# UP: erzeugt einen mit Nullen gefüllten Bitvektor
# allocate_bit_vector_0(len)
# > uintL len: Länge des Bitvektors (in Bits)
# < ergebnis: neuer Bitvektor, mit Nullen gefüllt
# kann GC auslösen
  extern object allocate_bit_vector_0 (uintL len);
# wird verwendet von SEQUENCE

# Folgende beide Funktionen arbeiten auf "Semi-Simple String"s.
# Das sind STRING-CHAR-Arrays mit FILL-POINTER, die aber nicht adjustierbar
# und nicht displaced sind und deren Datenvektor ein Simple-String ist.
# Beim Überschreiten der Länge wird ihre Länge verdoppelt
# (so daß der Aufwand fürs Erweitern nicht sehr ins Gewicht fällt).

# UP: Liefert einen Semi-Simple String gegebener Länge, Fill-Pointer =0.
# make_ssstring(len)
# > uintL len: Länge >0
# < ergebnis: neuer Semi-Simple String dieser Länge
# kann GC auslösen
  extern object make_ssstring (uintL len);
# wird verwendet von STREAM, IO

# UP: Schiebt ein String-Char in einen Semi-Simple String und erweitert ihn
# dabei eventuell.
# ssstring_push_extend(ssstring,ch)
# > ssstring: Semi-Simple String
# > ch: Character
# < ergebnis: derselbe Semi-Simple String
# kann GC auslösen
  extern object ssstring_push_extend (object ssstring, uintB ch);
# wird verwendet von STREAM, IO

#ifdef STRM_WR_SS
# UP: Stellt sicher, daß ein Semi-Simple String eine bestimmte Länge hat
# und erweitert ihn dazu eventuell.
# ssstring_extend(ssstring,size)
# > ssstring: Semi-Simple String
# > size: gewünschte Mindestgröße
# < ergebnis: derselbe Semi-Simple String
# kann GC auslösen
  extern object ssstring_extend (object ssstring, uintL needed_len);
# wird verwendet von STREAM
#endif

# ##################### CHARBIBL zu CHARSTRG.D ############################ #

# Spezielle Characters: (siehe auch oben)
# #define BEL   7  #  #\Bell
# #define BS    8  #  #\Backspace
# #define TAB   9  #  #\Tab
# #define LF   10  #  #\Linefeed
# #define CR   13  #  #\Return
# #define PG   12  #  #\Page
  #define NL   10  #  #\Newline
  #define NLstring  "\n"  # C-String, der #\Newline enthält
  #define ESC  27  #  #\Escape
  #define ESCstring  "\033"  # C-String, der #\Escape enthält

# Wandelt Byte ch in einen Großbuchstaben
# up_case(ch)
  extern uintB up_case (uintB ch);
# wird verwendet von IO, PREDTYPE, PATHNAME

# Wandelt Byte ch in einen Kleinbuchstaben
# down_case(ch)
  extern uintB down_case (uintB ch);
# wird verwendet von IO, PATHNAME

# Stellt fest, ob ein Character alphanumerisch ist.
# alphanumericp(ch)
# > ch: Character-Code
# < ergebnis: TRUE falls alphanumerisch, FALSE sonst.
  extern boolean alphanumericp (uintB ch);
# wird verwendet von IO, PATHNAME

# Stellt fest, ob ein Character ein Graphic-Character ("druckend") ist.
# graphic_char_p(ch)
# > ch: Character-Code
# < ergebnis: TRUE falls druckend, FALSE sonst.
  extern boolean graphic_char_p (uintB ch);
# wird verwendet von STREAM, PATHNAME

# UP: verfolgt einen String.
# unpack_string(string,&len)
# > object string: ein String.
# < uintL len: Anzahl der Zeichen des Strings.
# < uintB* ergebnis: Anfangsadresse der Bytes
  extern uintB* unpack_string (object string, uintL* len);
# wird verwendet von STREAM, HASHTABL, PACKAGE, SPVW, STDWIN, GRAPH

# UP: vergleicht zwei Strings auf Gleichheit
# string_gleich(string1,string2)
# > string1: String
# > string2: simple-string
# < ergebnis: /=0, wenn gleich
  extern boolean string_gleich (object string1, object string2);
# wird verwendet von PACKAGE, STREAM, IO

# UP: vergleicht zwei Strings auf Gleichheit, case-insensitive
# string_equal(string1,string2)
# > string1: String
# > string2: simple-string
# < ergebnis: /=0, wenn gleich
  extern boolean string_equal (object string1, object string2);
# wird verwendet von IO, PATHNAME

# UP: kopiert einen String und macht dabei einen Simple-String draus.
# copy_string(string)
# > string: String
# < ergebnis: Simple-String mit denselben Zeichen
# kann GC auslösen
  extern object copy_string (object string);
# wird verwendet von IO, PATHNAME

# UP: wandelt einen String in einen Simple-String um.
# coerce_ss(obj)
# > obj: Lisp-Objekt, sollte ein String sein.
# < ergebnis: Simple-String mit denselben Zeichen
# kann GC auslösen
  extern object coerce_ss (object obj);
# wird verwendet von STREAM, PATHNAME, Macro coerce_imm_ss

# UP: wandelt einen String in einen immutablen Simple-String um.
# coerce_imm_ss(obj)
# > obj: Lisp-Objekt, sollte ein String sein.
# < ergebnis: immutabler Simple-String mit denselben Zeichen
# kann GC auslösen
  #ifdef IMMUTABLE_ARRAY
    #define coerce_imm_ss(obj)  make_imm_array(copy_string(obj))
  #else
    #define coerce_imm_ss(obj)  coerce_ss(obj)
  #endif
# wird verwendet von PACKAGE

# UP: Konversion eines Objekts zu einem Character
# coerce_char(obj)
# > obj: Lisp-Objekt
# < ergebnis: Character oder NIL
  extern object coerce_char (object obj);
# wird verwendet von PREDTYPE

# UP: Liefert den Namen eines Zeichens.
# char_name(code)
# > uintB code: Ascii-Code eines Zeichens
# < ergebnis: Simple-String (Name dieses Zeichens) oder NIL
  extern object char_name (uintB code);
# wird verwendet von IO

# UP: Bestimmt das Character mit einem gegebenen Namen
# name_char(string)
# > string: String
# < ergebnis: Character mit diesem Namen, oder NIL falls keins existiert
  extern object name_char (object string);
# wird verwendet von IO

# UP: Überprüft die Grenzen für ein String-Argument
# test_string_limits(&string,&start,&len)
# > STACK_2: String-Argument
# > STACK_1: optionales :start-Argument
# > STACK_0: optionales :end-Argument
# > subr_self: Aufrufer (ein SUBR)
# < object string: String
# < uintL start: Wert des :start-Arguments
# < uintL len: Anzahl der angesprochenen Characters
# < uintB* ergebnis: Ab hier kommen die angesprochenen Characters
# erhöht STACK um 3
  extern uintB* test_string_limits (object* string_, uintL* start_, uintL* len_);
# wird verwendet von STREAM, PATHNAME, IO

# UP: wandelt die Characters eines Stringstücks in Großbuchstaben
# nstring_upcase(charptr,len);
# > uintB* charptr: Ab hier kommen die angesprochenen Characters
# > uintL len: Anzahl der angesprochenen Characters
  extern void nstring_upcase (uintB* charptr, uintL len);
# wird verwendet von

# UP: wandelt die Characters eines Stringstücks in Kleinbuchstaben
# nstring_downcase(charptr,len);
# > uintB* charptr: Ab hier kommen die angesprochenen Characters
# > uintL len: Anzahl der angesprochenen Characters
  extern void nstring_downcase (uintB* charptr, uintL len);
# wird verwendet von PATHNAME

# UP: wandelt die Worte eines Stringstücks in solche, die
# mit Großbuchstaben anfangen und mit Kleinbuchstaben weitergehen.
# nstring_capitalize(charptr,len);
# > uintB* charptr: Ab hier kommen die angesprochenen Characters
# > uintL len: Anzahl der angesprochenen Characters
  extern void nstring_capitalize (uintB* charptr, uintL len);
# wird verwendet von PATHNAME

# UP: wandelt einen String in Großbuchstaben
# string_upcase(string)
# > string: String
# < ergebnis: neuer Simple-String, in Großbuchstaben
# kann GC auslösen
  extern object string_upcase (object string);
# wird verwendet von MISC, PATHNAME

# UP: wandelt einen String in Kleinbuchstaben
# string_downcase(string)
# > string: String
# < ergebnis: neuer Simple-String, in Kleinbuchstaben
# kann GC auslösen
  extern object string_downcase (object string);
# wird verwendet von PATHNAME

# UP: bildet einen aus mehreren Strings zusammengehängten String.
# string_concat(argcount)
# > uintC argcount: Anzahl der Argumente
# > auf dem STACK: die Argumente (sollten Strings sein)
# > subr_self: Aufrufer (ein SUBR) (unnötig, falls alle Argumente Strings sind)
# < ergebnis: Gesamtstring, neu erzeugt
# < STACK: aufgeräumt
# kann GC auslösen
  extern object string_concat (uintC argcount);
# wird verwendet von PACKAGE, PATHNAME, DEBUG, SYMBOL

# ###################### DEBUGBIB zu DEBUG.D ############################ #

# Startet den normalen Driver (Read-Eval-Print-Loop)
# driver();
  extern void driver (void);
# wird verwendet von SPVW

# Startet einen untergeordneten Driver (Read-Eval-Print-Loop)
# break_driver(continuable);
# > continuable: Flag, ob nach Beendigung des Drivers fortgefahren werden kann.
# kann GC auslösen
  extern void break_driver (object continuable);
# wird verwendet von ERROR, EVAL

# ##################### HASHBIBL zu HASHTABL.D ########################## #

# UP: Sucht ein Objekt in einer Hash-Tabelle.
# gethash(obj,ht)
# > obj: Objekt, als Key
# > ht: Hash-Tabelle
# < ergebnis: zugehöriger Value, falls gefunden, nullobj sonst
  extern object gethash (object obj, object ht);
# wird verwendet von EVAL, RECORD, PATHNAME, FOREIGN

# UP: Sucht ein Key in einer Hash-Tabelle und liefert den vorigen Wert.
# shifthash(ht,obj,value) == (SHIFTF (GETHASH obj ht) value)
# > ht: Hash-Tabelle
# > obj: Objekt
# > value: neuer Wert
# < ergebnis: alter Wert
# kann GC auslösen
  extern object shifthash (object ht, object obj, object value);
# wird verwendet von SEQUENCE, PATHNAME, FOREIGN

# ######################### IOBIBL zu IO.D ############################## #

# spezielles Objekt, das EOF anzeigt
  #define eof_value  make_system(0xE0FE0FUL)
# wird verwendet von IO, STREAM, DEBUG, SPVW

# Hilfswert zum Erkennen einzelner Dots
  #define dot_value  make_system(0xD0DD0DUL)
# wird verwendet von IO, SPVW

# UP: Initialisiert den Reader.
# init_reader();
# kann GC auslösen
  extern void init_reader (void);
# wird verwendet von SPVW

# UP: Liest ein Objekt ein.
# read(&stream,recursive-p,whitespace-p)
# > recursive-p: gibt an, ob rekursiver Aufruf von READ, mit Error bei EOF
# > whitespace-p: gibt an, ob danach whitespace zu verbrauchen ist
# > stream: Stream
# < stream: Stream
# < ergebnis: gelesenes Objekt (eof_value bei EOF, dot_value bei einzelnem Punkt)
# kann GC auslösen
  extern object read (object* stream_, object recursive_p, object whitespace_p);
# wird verwendet von SPVW, DEBUG

# UP: Gibt einen Simple-String elementweise auf einen Stream aus.
# write_sstring(&stream,string);
# > string: Simple-String
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void write_sstring (object* stream_, object string);
# wird verwendet von EVAL, DEBUG, ERROR, PACKAGE, SPVW

# UP: Gibt einen String elementweise auf einen Stream aus.
# write_string(&stream,string);
# > string: String
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void write_string (object* stream_, object string);
# wird verwendet von PACKAGE, DEBUG

# UP: Gibt ein Objekt auf einen Stream aus.
# prin1(&stream,obj);
# > obj: Objekt
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void prin1 (object* stream_, object obj);
# wird verwendet von EVAL, DEBUG, PACKAGE, ERROR, SPVW

# UP: Gibt ein Newline auf einen Stream aus.
# terpri(&stream);
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  # extern void terpri (object* stream_);
  #define terpri(stream_)  write_schar(stream_,NL)
# wird verwendet von IO, DEBUG, PACKAGE, ERROR, SPVW

# ####################### LISTBIBL zu LIST.D ############################## #

# UP: Kopiert eine Liste
# copy_list(list)
# > list: Liste
# < ergebnis: Kopie der Liste
# kann GC auslösen
  extern object copy_list (object list);
# wird verwendet von PACKAGE

# UP: Dreht eine Liste konstruktiv um.
# reverse(list)
# > list: Liste (x1 ... xm)
# < ergebnis: umgedrehte Liste (xm ... x1)
# kann GC auslösen
  extern object reverse (object list);
# wird verwendet von SEQUENCE, PACKAGE, PATHNAME

# UP: Bestimmt die Länge einer Liste
# llength(obj)
# > obj: Objekt
# < uintL ergebnis: Länge von obj, als Liste aufgefaßt
# Testet nicht auf zyklische Listen.
  extern uintL llength (object obj);
# wird verwendet von CONTROL, EVAL, SEQUENCE, RECORD, IO, PACKAGE, HASHTABL, STREAM

# UP: Bildet eine Liste mit genau len Elementen
# make_list(len)
# > (STACK): Initialisierungswert für die Elemente
# > uintL len: gewünschte Listenlänge
# < ergebnis: Liste mit D1.L Elementen
# kann GC auslösen
  extern object make_list (uintL len);
# wird verwendet von

# UP: Dreht eine Liste destruktiv um.
# nreverse(list)
# > list: Liste (x1 ... xm)
# < ergebnis: Liste (xm ... x1), EQ zur alten
  extern object nreverse (object list);
# wird verwendet von SEQUENCE, EVAL, CONTROL, IO, PATHNAME, ERROR, DEBUG, PACKAGE

# UP: A0 := (nreconc A0 A1)
# nreconc(list,obj)
# > list: Liste
# > obj: Objekt
# < ergebnis: (nreconc A0 A1)
  extern object nreconc (object list, object obj);
# wird verwendet von SEQUENCE, IO, PATHNAME, CONTROL, DEBUG

# UP: Bilde (delete obj (the list list) :test #'EQ)
# deleteq(list,obj)
# Entferne aus der Liste list alle Elemente, die EQ zu obj sind.
# > obj: zu streichendes Element
# > list: Liste
# < ergebnis: modifizierte Liste
  extern object deleteq (object list, object obj);
# wird verwendet von PACKAGE, STREAM

# UP: Bildet eine Liste mit gegebenen Elementen.
# listof(len)
# > uintC len: gewünschte Listenlänge
# > auf STACK: len Objekte, erstes zuoberst
# < ergebnis: Liste dieser Objekte
# Erhöht STACK
# verändert STACK, kann GC auslösen
  extern object listof (uintC len);
# wird verwendet von STREAM, PATHNAME, PACKAGE, ARRAY, EVAL, PREDTYPE, REXX, ERROR, SPVW

# ####################### MISCBIBL zu MISC.D ############################## #

# ####################### ERRBIBL zu ERROR.D ############################## #

# Klassifikation der bekannten Condition-Typen:
# (Genauer gesagt, handelt es sich hier immer um die SIMPLE-... Typen.)
  typedef enum
  {
    # all kinds of conditions
    condition,
      # conditions that require interactive intervention
      serious_condition,
        # serious conditions that occur deterministically
        error,
          # statically detectable errors of a program
          program_error,
          # not statically detectable errors in program control
          control_error,
          # errors that occur while doing arithmetic operations
          arithmetic_error,
            # trying to evaluate a mathematical function at a singularity
            division_by_zero,
            # trying to get too close to infinity in the floating point domain
            floating_point_overflow,
            # trying to get too close to zero in the floating point domain
            floating_point_underflow,
          # trying to access a location which contains #<UNBOUND>
          cell_error,
            # trying to get the value of an unbound variable
            unbound_variable,
            # trying to get the global function definition of an undefined function
            undefined_function,
          # when some datum does not belong to the expected type
          type_error,
          # errors during operation on packages
          package_error,
          # attempted violation of *PRINT-READABLY*
          print_not_readable,
          # errors while doing stream I/O
          stream_error,
            # unexpected end of stream
            end_of_file,
          # errors with pathnames, OS level errors with streams
          file_error,
        # "Virtual memory exhausted"
        storage_condition,
      # conditions for which user notification is appropriate
      warning,
    # junk
    condition_for_broken_compilers_that_dont_like_trailing_commas
  }
  conditiontype;

# Fehlermeldung mit Errorstring. Kehrt nicht zurück.
# fehler(errortype,errorstring);
# > errortype: Condition-Typ
# > errorstring: Konstanter ASCIZ-String.
#   Bei jeder Tilde wird ein LISP-Objekt vom STACK genommen und statt der
#   Tilde ausgegeben.
# > auf dem STACK: Initialisierungswerte für die Condition, je nach errortype
  nonreturning_function(extern, fehler, (conditiontype errortype, const char * errorstring));
  nonreturning_function(extern, fehler3, (conditiontype errortype, const char *arg1, const char *arg2, const char *arg3));
  nonreturning_function(extern, fehler4, (conditiontype errortype, const char *arg1, const char *arg2, const char *arg3, const char *arg4));
  nonreturning_function(extern, fehler5, (conditiontype errortype, const char *arg1, const char *arg2, const char *arg3, const char *arg4, const char *arg5));
# wird von allen Modulen verwendet

  nonreturning_function(extern, OS_error_debug, (const char *,int));
  # #define OS_error() OS_error_debug(__FILE__,__LINE__)
  #define OS_error() OS_error_()

#ifdef AMIGAOS
  # Behandlung von AMIGAOS-Fehlern
  # OS_error_();
  # > IoErr(): Fehlercode
    nonreturning_function(extern, OS_error_, (void));
  # wird verwendet von SPVW, STREAM, PATHNAME
#endif
#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
  # Behandlung von UNIX-Fehlern
  # OS_error_();
  # > int errno: Fehlercode
    nonreturning_function(extern, OS_error_, (void));
  # wird verwendet von SPVW, STREAM, PATHNAME, GRAPH
#endif
#if defined(UNIX) || defined(EMUNIX) || defined(AMIGAOS) || defined(WATCOM) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
  # Initialisierung der Fehlertabelle:
    extern int init_errormsg_table (void);
#else
  # Nichts zu initialisieren.
    #define init_errormsg_table()  0
#endif

#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS) || defined(WIN32_UNIX) || defined(WIN32_DOS)
  # Ausgabe eines Fehlers, direkt übers Betriebssystem
  # errno_out(errorcode);
  # > int errorcode: Fehlercode
    extern void errno_out (int errorcode);
#endif

# UP: Führt eine Break-Schleife wegen Tastaturunterbrechung aus.
# > -(STACK) : aufrufende Funktion
# verändert STACK, kann GC auslösen
  extern void tast_break (void);
# wird verwendet von EVAL, IO, SPVW, STREAM

# Fehlermeldung, wenn ein Objekt keine Liste ist.
# fehler_list(obj);
# > arg: Nicht-Liste
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_list, (object obj));
# wird verwendet von LIST, EVAL

# Fehlermeldung, wenn ein Objekt kein Symbol ist.
# fehler_kein_symbol(caller,obj);
# > caller: Aufrufer (ein Symbol)
# > obj: Nicht-Symbol
  nonreturning_function(extern, fehler_kein_symbol, (object caller, object obj));
# wird verwendet von EVAL, CONTROL

# Fehlermeldung, wenn ein Objekt kein Symbol ist.
# fehler_symbol(obj);
# > subr_self: Aufrufer (ein SUBR oder FSUBR)
# > obj: Nicht-Symbol
  nonreturning_function(extern, fehler_symbol, (object obj));
# wird verwendet von SYMBOL, CONTROL

# Fehlermeldung, wenn ein Objekt kein Simple-Vector ist.
# fehler_kein_svector(caller,obj);
# > caller: Aufrufer (ein Symbol)
# > obj: Nicht-Svector
  nonreturning_function(extern, fehler_kein_svector, (object caller, object obj));
# wird verwendet von ARRAY, EVAL

# Fehlermeldung, wenn ein Objekt kein Vektor ist.
# fehler_vector(obj);
# > subr_self: Aufrufer (ein SUBR)
# > obj: Nicht-Vektor
  nonreturning_function(extern, fehler_vector, (object obj));
# wird verwendet von ARRAY

# Fehlermeldung, falls ein Argument kein Character ist:
# fehler_char(obj);
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_char, (object obj));
# wird verwendet von CHARSTRG

# Fehler, wenn Argument kein String-Char ist.
# fehler_string_char(obj);
# > obj: fehlerhaftes Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_string_char, (object obj));
# wird verwendet von IO, STDWIN

# Fehlermeldung, falls ein Argument kein String ist:
# fehler_string(obj);
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_string, (object obj));
# wird verwendet von CHARSTRG, FOREIGN, STDWIN

# Fehlermeldung, falls ein Argument kein Simple-String ist:
# fehler_sstring(obj);
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_sstring, (object obj));
# wird verwendet von CHARSTRG

# Fehlermeldung, wenn ein Argument kein Stream ist:
# fehler_stream(obj);
# > obj: Das fehlerhafte Argument
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_stream, (object obj));
# wird verwendet von IO, STREAM, DEBUG

# Fehlermeldung, wenn ein Argument kein Stream vom geforderten Stream-Typ ist:
# fehler_streamtype(obj,type);
# > obj: Das fehlerhafte Argument
# > type: geforderter Stream-Typ
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_streamtype, (object obj, object type));
# wird verwendet von STREAM

#ifdef HAVE_FFI
# Überprüfung eines Arguments
# check_...(obj);
# > obj: Argument
# > subr_self: Aufrufer (ein SUBR)
# obj sollte eine Variable sein
  #define check_string_char(obj)  \
    if (!string_char_p(obj)) { fehler_string_char(obj); }
  #define check_uint8(obj)  \
    if (!uint8_p(obj)) { fehler_uint8(obj); }
  #define check_sint8(obj)  \
    if (!sint8_p(obj)) { fehler_sint8(obj); }
  #define check_uint16(obj)  \
    if (!uint16_p(obj)) { fehler_uint16(obj); }
  #define check_sint16(obj)  \
    if (!sint16_p(obj)) { fehler_sint16(obj); }
  #define check_uint32(obj)  \
    if (!uint32_p(obj)) { fehler_uint32(obj); }
  #define check_sint32(obj)  \
    if (!sint32_p(obj)) { fehler_sint32(obj); }
  #define check_uint64(obj)  \
    if (!uint64_p(obj)) { fehler_uint64(obj); }
  #define check_sint64(obj)  \
    if (!sint64_p(obj)) { fehler_sint64(obj); }
  #define check_uint(obj)  \
    if (!uint_p(obj)) { fehler_uint(obj); }
  #define check_sint(obj)  \
    if (!sint_p(obj)) { fehler_sint(obj); }
  #define check_ulong(obj)  \
    if (!ulong_p(obj)) { fehler_ulong(obj); }
  #define check_slong(obj)  \
    if (!slong_p(obj)) { fehler_slong(obj); }
  #define check_ffloat(obj)  \
    if (!single_float_p(obj)) { fehler_ffloat(obj); }
  #define check_dfloat(obj)  \
    if (!double_float_p(obj)) { fehler_dfloat(obj); }
  nonreturning_function(extern, fehler_uint8, (object obj));
  nonreturning_function(extern, fehler_sint8, (object obj));
  nonreturning_function(extern, fehler_uint16, (object obj));
  nonreturning_function(extern, fehler_sint16, (object obj));
  nonreturning_function(extern, fehler_uint32, (object obj));
  nonreturning_function(extern, fehler_sint32, (object obj));
  nonreturning_function(extern, fehler_uint64, (object obj));
  nonreturning_function(extern, fehler_sint64, (object obj));
  nonreturning_function(extern, fehler_uint, (object obj));
  nonreturning_function(extern, fehler_sint, (object obj));
  nonreturning_function(extern, fehler_ulong, (object obj));
  nonreturning_function(extern, fehler_slong, (object obj));
  nonreturning_function(extern, fehler_ffloat, (object obj));
  nonreturning_function(extern, fehler_dfloat, (object obj));
# wird verwendet vom FFI
#endif

# ##################### PACKBIBL zu PACKAGE.D ############################# #

# UP: testet, ob ein Symbol in einer Package accessible ist und dabei nicht
# von einem anderen Symbol desselben Namens verdeckt wird.
# accessiblep(sym,pack)
# > sym: Symbol
# > pack: Package
# < ergebnis: TRUE falls sym in pack accessible und nicht verdeckt ist,
#             FALSE sonst
  extern boolean accessiblep (object sym, object pack);
# wird verwendet von IO

# UP: testet, ob ein Symbol in einer Package als externes Symbol accessible
# ist.
# externalp(sym,pack)
# > sym: Symbol
# > pack: Package
# < ergebnis: TRUE falls sym in pack als externes Symbol accessible ist,
#             FALSE sonst
  extern boolean externalp (object sym, object pack);
# wird verwendet von IO

# UP: sucht ein externes Symbol gegebenen Printnamens in einer Package.
# find_external_symbol(string,pack,&sym)
# > string: String
# > pack: Package
# < ergebnis: TRUE, falls ein externes Symbol dieses Printnamens in pack gefunden.
# < sym: dieses Symbol, falls gefunden.
  extern boolean find_external_symbol (object string, object pack, object* sym_);
# wird verwendet von IO

# UP: sucht eine Package mit gegebenem Namen oder Nickname
# find_package(string)
# > string: String
# < ergebnis: Package mit diesem Namen oder NIL
  extern object find_package (object string);
# wird verwendet von IO

# UP: Interniert ein Symbol gegebenen Printnamens in einer Package.
# intern(string,pack,&sym)
# > string: String
# > pack: Package
# < sym: Symbol
# < ergebnis: 0, wenn nicht gefunden, sondern neu erzeugt
#             1, wenn als externes Symbol vorhanden
#             2, wenn vererbt über use-list
#             3, wenn als internes Symbol vorhanden
# kann GC auslösen
  extern uintBWL intern (object string, object pack, object* sym_);
# wird verwendet von IO, SPVW

# UP: Interniert ein Symbol gegebenen Printnamens in der Keyword-Package.
# intern_keyword(string)
# > string: String
# < ergebnis: Symbol, ein Keyword
# kann GC auslösen
  extern object intern_keyword (object string);
# wird verwendet von IO, EVAL, GRAPH

# UP: Importiert ein Symbol in eine Package
# import(&sym,&pack);
# > sym: Symbol (im STACK)
# > pack: Package (im STACK)
# < sym: Symbol, EQ zum alten
# < pack: Package, EQ zur alten
# kann GC auslösen
  extern void import (object* sym_, object* pack_);
# wird verwendet von SPVW

# UP: Exportiert ein Symbol aus einer Package
# export(&sym,&pack);
# > sym: Symbol (im STACK)
# > pack: Package (im STACK)
# < sym: Symbol, EQ zum alten
# < pack: Package, EQ zur alten
# kann GC auslösen
  extern void export (object* sym_, object* pack_);
# wird verwendet von SPVW

# UP: liefert die aktuelle Package
# get_current_package()
# < ergebnis: aktuelle Package
  extern object get_current_package (void);
# wird verwendet von IO

# UP: Initialisiert die Packageverwaltung
# init_packages();
  extern void init_packages (void);
# wird verwendet von SPVW

# ##################### PATHBIBL zu PATHNAME.D ############################ #

# UP: Liefert den Directory-Namestring eines halbwegs überprüften Pathname
#     unter der Annahme, daß das Directory dieses Pathname existiert,
#     im Betriebssystem-Format.
# assume_dir_exists()
# > STACK_0: absoluter Pathname, halbwegs überprüft
# < STACK_0: (evtl. derselbe) Pathname, noch besser aufgelöst
# < ergebnis:
#     falls Name=NIL: Directory-Namestring (fürs BS)
#     falls Name/=NIL: Namestring (für BS, mit Nullbyte am Schluß)
# kann GC auslösen
  extern object assume_dir_exists (void);
# wird verwendet von STREAM

# UP: Initialisiert das Pathname-System.
# init_pathnames();
# kann GC auslösen
  extern void init_pathnames (void);
# wird verwendet von SPVW

# Sucht das ausführbare Programm sofort nach Programmstart zu lokalisieren.
# find_executable(argv[0])
  extern int find_executable (const char * program_name);
# wird verwendet von SPVW

# ##################### PREDBIBL zu PREDTYPE.D ############################ #

# UP: testet auf Atomgleichheit EQL
# eql(obj1,obj2)
# > obj1,obj2: Lisp-Objekte
# < ergebnis: TRUE, falls Objekte gleich
  extern boolean eql (object obj1, object obj2);
# wird verwendet von CONTROL, EVAL, HASHTABL, LISPARIT

# UP: testet auf Gleichheit EQUAL
# equal(obj1,obj2)
# > obj1,obj2: Lisp-Objekte
# < ergebnis: TRUE, falls Objekte gleich
  extern boolean equal (object obj1, object obj2);
# wird verwendet von EVAL, PATHNAME, HASHTABL, MISC

# UP: testet auf laschere Gleichheit EQUALP
# equalp(obj1,obj2)
# > obj1,obj2: Lisp-Objekte
# < ergebnis: TRUE, falls Objekte gleich
# kann GC auslösen
  extern boolean equalp (object obj1, object obj2);
# wird verwendet von

# ###################### SEQBIBL zu SEQUENCE.D ############################ #

# UP: Wandelt ein Objekt in eine Sequence gegebenen Typs um.
# coerce_sequence(obj,result_type)
# > obj: Objekt, sollte eine Sequence sein
# > result_type: Bezeichner (Symbol) des Sequence-Typs
# < Wert: Sequence vom Typ result_type
# kann GC auslösen
  extern Values coerce_sequence (object sequence, object result_type);
# wird verwendet von PREDTYPE, EVAL

# Fehler, wenn beide :TEST, :TEST-NOT - Argumente angegeben wurden.
# fehler_both_tests();
# > subr_self: Aufrufer (ein SUBR)
  nonreturning_function(extern, fehler_both_tests, (void));
# wird verwendet von LIST

# ###################### STRMBIBL zu STREAM.D ############################# #

# UP: Initialisiert die Stream-Variablen.
# init_streamvars();
# kann GC auslösen
  extern void init_streamvars (void);
# wird verwendet von SPVW

# Fehlermeldung, wenn eine Stream-Operation auf einem Stream nicht erlaubt ist.
# fehler_illegal_streamop(caller,stream);
# > caller: Aufrufer (ein Symbol)
# > stream: Stream
  nonreturning_function(extern, fehler_illegal_streamop, (object caller, object stream));
# wird verwendet von IO

# Liest ein Byte von einem Stream.
# read_byte(stream)
# > stream: Stream
# < ergebnis: gelesener Integer (eof_value bei EOF)
# kann GC auslösen
  extern object read_byte (object stream);
# wird verwendet von PATHNAME, SEQUENCE

# Schreibt ein Byte auf einen Stream.
# write_byte(stream,byte);
# > stream: Stream
# > byte: auszugebender Integer
# kann GC auslösen
  extern void write_byte(object stream, object byte);
# wird verwendet von SEQUENCE

# Liest ein Character von einem Stream.
# read_char(&stream)
# > stream: Stream
# < stream: Stream
# < ergebnis: gelesenes Character (eof_value bei EOF)
# kann GC auslösen
  extern object read_char (object* stream_);
# wird verwendet von IO, DEBUG, SEQUENCE

# Schiebt das letzte gelesene Character auf einen Stream zurück.
# unread_char(&stream,ch);
# > ch: letztes gelesenes Character
# > stream: Stream
# < stream: Stream
  extern void unread_char (object* stream_, object ch);
# wird verwendet von IO, DEBUG

# Liest ein Character von einem Stream, ohne es zu verbrauchen.
# peek_char(&stream)
# > stream: Stream
# < stream: Stream
# < ergebnis: gelesenes Character (eof_value bei EOF)
# kann GC auslösen
  extern object peek_char (object* stream_);
# wird verwendet von IO

# Schreibt ein Character auf einen Stream.
# write_char(&stream,ch);
# > ch: auszugebendes Character
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void write_char (object* stream_, object ch);
# wird verwendet von LISPARIT, IO, ERROR, SEQUENCE

# Schreibt ein festes Standard-Char auf einen Stream.
# write_schar(&stream,ch);
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  # extern void write_schar (object* stream_, uintB ch);
  #define write_schar(stream_,ch)  write_char(stream_,code_char(ch))
# wird verwendet von LISPARIT, IO, DEBUG, Macro TERPRI

# UP: Schließt einen Stream.
# stream_close(&stream);
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void stream_close (object* stream_);
# wird verwendet von PATHNAME, SPVW, DEBUG, MISC

# UP: Schließt eine Liste offener Files.
# close_some_files(list);
# > list: Liste von offenen Streams
# kann GC auslösen
  extern void close_some_files (object list);
# wird verwendet von SPVW

# UP: Schließt alle offenen Files.
# close_all_files();
# kann GC auslösen
  extern void close_all_files (void);
# wird verwendet von SPVW

# UP: Erklärt alle offenen File-Streams für geschlossen.
# closed_all_files();
  extern void closed_all_files (void);
# wird verwendet von SPVW

# UP: Stellt fest, ob im Stream stream ein Zeichen sofort verfügbar ist.
# stream_listen(stream)
# > stream: Stream
# < ergebnis:  0 falls Zeichen verfügbar,
#             -1 falls bei EOF angelangt,
#             +1 falls kein Zeichen verfügbar, aber nicht wegen EOF
# kann GC auslösen
  extern signean stream_listen (object stream);
# wird verwendet von IO, DEBUG

# UP: Löscht bereits eingegebenen interaktiven Input von einem Stream stream.
# clear_input(stream)
# > stream: Stream
# < ergebnis: TRUE falls Input gelöscht wurde
# kann GC auslösen
  extern boolean clear_input (object stream);
# wird verwendet von IO, DEBUG

# UP: Wartenden Output eines Stream stream ans Ziel bringen.
# finish_output(stream);
# > stream: Stream
# kann GC auslösen
  extern void finish_output (object stream);
# wird verwendet von IO

# UP: Wartenden Output eines Stream stream ans Ziel bringen.
# force_output(stream);
# > stream: Stream
# kann GC auslösen
  extern void force_output (object stream);
# wird verwendet von IO

# UP: Wartenden Output eines Stream stream löschen.
# clear_output(stream);
# > stream: Stream
# kann GC auslösen
  extern void clear_output (object stream);
# wird verwendet von IO

# UP: Liefert die Line-Position eines Streams.
# get_line_position(stream)
# > stream: Stream
# < ergebnis: Line-Position (Fixnum >=0)
  extern object get_line_position (object stream);
# wird verwendet von IO, DEBUG

# UP: Liest mehrere Bytes von einem Stream.
# read_byte_array(stream,byteptr,len)
# > stream: Stream
# > uintB* byteptr: Adresse der zu füllenden Bytefolge
# > uintL len: Länge der zu füllenden Bytefolge
# < uintB* ergebnis: Pointer ans Ende des gefüllten Bereiches oder NULL
  extern uintB* read_byte_array (object stream, uintB* byteptr, uintL len);
# wird verwendet von SEQUENCE

# UP: Schreibt mehrere Bytes auf einen Stream.
# write_byte_array(stream,byteptr,len)
# > stream: Stream
# > uintB* byteptr: Adresse der zu schreibenden Bytefolge
# > uintL len: Länge der zu schreibenden Bytefolge
# < uintB* ergebnis: Pointer ans Ende des geschriebenen Bereiches oder NULL
  extern uintB* write_byte_array (object stream, uintB* byteptr, uintL len);
# wird verwendet von SEQUENCE

# UP: Liest mehrere String-Characters von einem Stream.
# read_schar_array(stream,charptr,len)
# > stream: Stream
# > uintB* charptr: Adresse der zu füllenden Zeichenfolge
# > uintL len: Länge der zu füllenden Zeichenfolge
# < uintB* ergebnis: Pointer ans Ende des gefüllten Bereiches oder NULL
  extern uintB* read_schar_array (object stream, uintB* charptr, uintL len);
# wird verwendet von SEQUENCE

# UP: Schreibt mehrere String-Characters auf einen Stream.
# write_schar_array(stream,charptr,len)
# > stream: Stream
# > uintB* charptr: Adresse der zu schreibenden Zeichenfolge
# > uintL len: Länge der zu schreibenden Zeichenfolge
# < uintB* ergebnis: Pointer ans Ende des geschriebenen Bereiches oder NULL
  extern uintB* write_schar_array (object stream, uintB* charptr, uintL len);
# wird verwendet von SEQUENCE

# UP: Liefert den Stream, der der Wert einer Variablen ist.
# var_stream(sym,strmflags)
# > sym: Variable (Symbol)
# > strmflags: Menge von Operationen, die auf dem Stream möglich sein sollen
# < ergebnis: Stream
  extern object var_stream (object sym, uintB strmflags);
# wird verwendet von IO, PACKAGE, ERROR, DEBUG, SPVW

# UP: erzeugt ein File-Stream
# make_file_stream(handle,direction,type,eltype_size,append_flag)
# > handle: Handle des geöffneten Files
# > STACK_1: Filename, ein Pathname
# > STACK_0: Truename, ein Pathname
# > direction: Modus (0 = :PROBE, 1 = :INPUT, 4 = :OUTPUT, 5 = :IO, 3 = :INPUT-IMMUTABLE)
# > type: nähere Typinfo
#         (STRMTYPE_SCH_FILE oder STRMTYPE_CH_FILE oder
#          STRMTYPE_IU_FILE oder STRMTYPE_IS_FILE)
# > eltype_size: (bei Integer-Streams) Größe der Elemente in Bits,
#         ein Fixnum >0 und <intDsize*uintC_max
# > append_flag: TRUE falls der Stream gleich ans Ende positioniert werden
#         soll, FALSE sonst
# < ergebnis: File-Stream (oder evtl. File-Handle-Stream)
# < STACK: aufgeräumt
# kann GC auslösen
  extern object make_file_stream (object handle, uintB direction, uintB type, object eltype_size, boolean append_flag);
# wird verwendet von PATHNAME

# Liefert einen Broadcast-Stream zum Stream stream.
# make_broadcast1_stream(stream)
# kann GC auslösen
  extern object make_broadcast1_stream (object stream);
# wird verwendet von IO

# Liefert einen Two-Way-Stream zu einem Input-Stream und einem Output-Stream.
# make_twoway_stream(input_stream,output_stream)
# > input_stream : Input-Stream
# > output_stream : Output-Stream
# < ergebnis : Two-Way-Stream
# kann GC auslösen
  extern object make_twoway_stream (object input_stream, object output_stream);
# wird verwendet von SPVW

# Liefert einen String-Output-Stream.
# make_string_output_stream()
# kann GC auslösen
  extern object make_string_output_stream (void);
# wird verwendet von IO, EVAL, DEBUG, ERROR

# UP: Liefert das von einem String-Output-Stream Angesammelte.
# get_output_stream_string(&stream)
# > stream: String-Output-Stream
# < stream: geleerter Stream
# < ergebnis: Angesammeltes, ein Simple-String
# kann GC auslösen
  extern object get_output_stream_string (object* stream_);
# wird verwendet von IO, EVAL, DEBUG, ERROR

# UP: Liefert einen Pretty-Printer-Hilfs-Stream.
# make_pphelp_stream()
# kann GC auslösen
  extern object make_pphelp_stream (void);
# wird verwendet von IO

#if (defined(UNIX) && !defined(NEXTAPP)) || defined(AMIGAOS) || defined(RISCOS)
# UP: Terminal wieder in Normalzustand schalten
# terminal_sane();
  extern void terminal_sane (void);
# wird verwendet von SPVW
#endif

# ####################### SYMBIBL zu SYMBOL.D ############################# #

# UP: Liefert die globale Funktionsdefinition eines Symbols,
# mit Test, ob das Symbol eine globale Funktion darstellt.
# Symbol_function_checked(symbol)
# > symbol: Symbol
# < ergebnis: seine globale Funktionsdefinition
  extern object Symbol_function_checked (object symbol);
# wird verwendet von

# UP: Holt eine Property aus der Property-Liste eines Symbols.
# get(symbol,key)
# > symbol: ein Symbol
# > key: ein mit EQ zu vergleichender Key
# < value: dazugehöriger Wert aus der Property-Liste von symbol, oder unbound.
  extern object get (object symbol, object key);
# wird verwendet von IO, CONTROL, EVAL, PREDTYPE, SEQUENCE

# ##################### ARITBIBL zu LISTARIT.D ############################ #

# UP: Initialisiert die Arithmetik.
# init_arith();
# kann GC auslösen
  extern void init_arith (void);
# wird verwendet von SPVW

# Wandelt Longword in Integer um.
# L_to_I(wert)
# > wert: Wert des Integers, ein signed 32-Bit-Integer.
# < ergebnis: Integer mit diesem Wert.
# kann GC auslösen
  extern object L_to_I (sint32 wert);
# wird verwendet von TIME, REXX

# Wandelt Unsigned Longword in Integer >=0 um.
# UL_to_I(wert)
# > wert: Wert des Integers, ein unsigned 32-Bit-Integer.
# < ergebnis: Integer mit diesem Wert.
# kann GC auslösen
  #if (intLsize<=oint_data_len)
    #define UL_to_I(wert)  fixnum((uintL)(wert))
  #else
    extern object UL_to_I (uintL wert);
  #endif
# wird verwendet von MISC, TIME, STREAM, PATHNAME, HASHTABL, SPVW, ARRAY

# Wandelt Doppel-Longword in Integer um.
# L2_to_I(wert_hi,wert_lo)
# > wert_hi|wert_lo: Wert des Integers, ein signed 64-Bit-Integer.
# < ergebnis: Integer mit diesem Wert.
# kann GC auslösen
  extern object L2_to_I (sint32 wert_hi, uint32 wert_lo);
# wird verwendet von TIME, FOREIGN

#ifdef HAVE_FFI
# Wandelt Unsigned Doppel-Longword in Integer um.
# UL2_to_I(wert_hi,wert_lo)
# > wert_hi|wert_lo: Wert des Integers, ein unsigned 64-Bit-Integer.
# < ergebnis: Integer mit diesem Wert.
# kann GC auslösen
  extern object UL2_to_I (uint32 wert_hi, uint32 wert_lo);
# wird verwendet von FOREIGN, vom FFI
#endif

#ifdef intQsize
# Wandelt Quadword in Integer um.
# Q_to_I(wert)
# > wert: Wert des Integers, ein signed 64-Bit-Integer.
# < ergebnis: Integer mit diesem Wert.
# kann GC auslösen
  extern object Q_to_I (sint64 wert);
# wird verwendet vom FFI
#endif

#if defined(intQsize) || defined(WIDE_HARD)
# Wandelt Unsigned Quadword in Integer >=0 um.
# UQ_to_I(wert)
# > wert: Wert des Integers, ein unsigned 64-Bit-Integer.
# < ergebnis: Integer mit diesem Wert.
# kann GC auslösen
  extern object UQ_to_I (uint64 wert);
# wird verwendet von MISC, TIME, FFI
#endif

# Wandelt ein C-Integer gegebenen Typs in ein Integer um.
# val sollte eine Variable sein.
  #define uint8_to_I(val)  fixnum((uint8)(val))
  #define sint8_to_I(val)  L_to_I((sint32)(sint8)(val))
  #define uint16_to_I(val)  fixnum((uint16)(val))
  #define sint16_to_I(val)  L_to_I((sint32)(sint16)(val))
  #define uint32_to_I(val)  UL_to_I((uint32)(val))
  #define sint32_to_I(val)  L_to_I((sint32)(val))
  #ifdef intQsize
    #define uint64_to_I(val)  UQ_to_I((uint64)(val))
    #define sint64_to_I(val)  Q_to_I((sint64)(val))
  #elif defined(HAVE_FFI)
    #define uint64_to_I(val)  UL2_to_I((uint32)((val)>>32),(uint32)(val))
    #define sint64_to_I(val)  L2_to_I((sint32)((val)>>32),(uint32)(val))
  #endif
  #if (int_bitsize==16)
    #define uint_to_I(val)  uint16_to_I(val)
    #define sint_to_I(val)  sint16_to_I(val)
  #else # (int_bitsize==32)
    #define uint_to_I(val)  uint32_to_I(val)
    #define sint_to_I(val)  sint32_to_I(val)
  #endif
  #if (long_bitsize==32)
    #define ulong_to_I(val)  uint32_to_I(val)
    #define slong_to_I(val)  sint32_to_I(val)
  #else # (long_bitsize==64)
    #define ulong_to_I(val)  uint64_to_I(val)
    #define slong_to_I(val)  sint64_to_I(val)
  #endif
# wird verwendet von MISC, vom FFI

# Wandelt Integer >=0 in Unsigned Longword um.
# I_to_UL(obj)
# > obj: ein Objekt, sollte ein Integer >=0, <2^32 sein
# < ergebnis: der Wert des Integer als Unsigned Longword.
  extern uintL I_to_UL (object obj);
# wird verwendet von TIME, ARRAY

# Wandelt Integer in Signed Longword um.
# I_to_L(obj)
# > obj: ein Objekt, sollte ein Integer >=-2^31, <2^31 sein
# < ergebnis: der Wert des Integer als Longword.
  extern sintL I_to_L (object obj);
# wird verwendet von STDWIN

#if (defined(HAVE_FFI) || defined(HAVE_AFFI)) && defined(HAVE_LONGLONG)

# Wandelt Integer >=0 in Unsigned Quadword um.
# I_to_UQ(obj)
# > obj: ein Objekt, sollte ein Integer >=0, <2^64 sein
# < ergebnis: der Wert des Integer als Unsigned Quadword.
  extern uint64 I_to_UQ (object obj);
# wird verwendet von AFFI, FOREIGN, vom FFI

#endif
#if defined(HAVE_FFI) && defined(HAVE_LONGLONG)

# Wandelt Integer in Signed Quadword um.
# I_to_Q(obj)
# > obj: ein Objekt, sollte ein Integer >=-2^63, <2^63 sein
# < ergebnis: der Wert des Integer als Quadword.
  extern sint64 I_to_Q (object obj);
# wird verwendet von FOREIGN, vom FFI

#endif

#if defined(HAVE_FFI) || defined(HAVE_AFFI)
# Wandelt ein Integer in ein C-Integer gegebenen Typs um.
# I_to_xintyy(obj) setzt voraus, daß xintyy_p(obj) schon abgeprüft wurde.
  #define I_to_uint8(obj)  (uint8)(as_oint(obj) >> oint_data_shift)
  #define I_to_sint8(obj)  (sint8)(as_oint(obj) >> oint_data_shift)
  #define I_to_uint16(obj)  (uint16)(as_oint(obj) >> oint_data_shift)
  #define I_to_sint16(obj)  (sint16)(as_oint(obj) >> oint_data_shift)
  #if (oint_data_len>=32)
    #define I_to_uint32(obj)  (uint32)(as_oint(obj) >> oint_data_shift)
  #else
    #define I_to_uint32(obj)  I_to_UL(obj)
  #endif
  #if (oint_data_len>=31)
    #define I_to_sint32(obj)  (sint32)(as_oint(obj) >> oint_data_shift)
  #else
    #define I_to_sint32(obj)  I_to_L(obj)
  #endif
  #define I_to_uint64(obj)  I_to_UQ(obj)
  #define I_to_sint64(obj)  I_to_Q(obj)
  #if (int_bitsize==16)
    #define I_to_uint  I_to_uint16
    #define I_to_sint  I_to_sint16
  #else # (int_bitsize==32)
    #define I_to_uint  I_to_uint32
    #define I_to_sint  I_to_sint32
  #endif
  #if (long_bitsize==32)
    #define I_to_ulong  I_to_uint32
    #define I_to_slong  I_to_sint32
  #else # (long_bitsize==64)
    #define I_to_ulong  I_to_uint64
    #define I_to_slong  I_to_sint64
  #endif
# wird verwendet von AFFI, vom FFI
#endif

# I_I_comp(x,y) vergleicht zwei Integers x und y.
# Ergebnis: 0 falls x=y, +1 falls x>y, -1 falls x<y.
  extern signean I_I_comp (object x, object y);
# wird verwendet von SEQUENCE

# (1+ x), wo x ein Integer ist. Ergebnis Integer.
# I_1_plus_I(x)
# kann GC auslösen
  extern object I_1_plus_I (object x);
# wird verwendet von SEQUENCE, SPVW, SYMBOL

# (1- x), wo x ein Integer ist. Ergebnis Integer.
# I_minus1_plus_I(x)
# kann GC auslösen
  extern object I_minus1_plus_I (object x);
# wird verwendet von SEQUENCE

# (+ x y), wo x und y Integers sind. Ergebnis Integer.
# I_I_plus_I(x,y)
# kann GC auslösen
  extern object I_I_plus_I (object x, object y);
# wird verwendet von SEQUENCE

# (- x y), wo x und y Integers sind. Ergebnis Integer.
# I_I_minus_I(x,y)
# kann GC auslösen
  extern object I_I_minus_I (object x, object y);
# wird verwendet von SEQUENCE

# (ASH x y), wo x und y Integers sind. Ergebnis Integer.
# I_I_ash_I(x,y)
# kann GC auslösen
  extern object I_I_ash_I (object x, object y);
# wird verwendet von SEQUENCE

# (INTEGER-LENGTH x), wo x ein Integer ist. Ergebnis uintL.
# I_integer_length(x)
  extern uintL I_integer_length (object x);
# wird verwendet von ARRAY

#ifdef HAVE_FFI

# c_float_to_FF(&val) wandelt ein IEEE-Single-Float val in ein Single-Float um.
# kann GC auslösen
  extern object c_float_to_FF (ffloatjanus* val_);

# FF_to_c_float(obj,&val);
# wandelt ein Single-Float obj in ein IEEE-Single-Float val um.
  extern void FF_to_c_float (object obj, ffloatjanus* val_);

# c_double_to_DF(&val) wandelt ein IEEE-Double-Float val in ein Double-Float um.
# kann GC auslösen
  extern object c_double_to_DF (dfloatjanus* val_);

# DF_to_c_double(obj,&val);
# wandelt ein Double-Float obj in ein IEEE-Double-Float val um.
  extern void DF_to_c_double (object obj, dfloatjanus* val_);

#endif

# UP: Wandelt eine Zeichenkette mit Integer-Syntax in ein Integer um.
# Punkte werden überlesen.
# read_integer(base,sign,string,index1,index2)
# > base: Lesebasis (>=2, <=36)
# > sign: Vorzeichen (/=0 falls negativ)
# > string: Simple-String (enthält Ziffern mit Wert <base und evtl. Punkt)
# > index1: Index der ersten Ziffer
# > index2: Index nach der letzten Ziffer
#   (also index2-index1 Ziffern, incl. evtl. Dezimalpunkt am Schluß)
# < ergebnis: Integer
# kann GC auslösen
  extern object read_integer (uintWL base,
         signean sign, object string, uintL index1, uintL index2);
# wird verwendet von IO

# UP: Wandelt eine Zeichenkette mit Rational-Syntax in eine rationale Zahl um.
# read_rational(base,sign,string,index1,index3,index2)
# > base: Lesebasis (>=2, <=36)
# > sign: Vorzeichen (/=0 falls negativ)
# > string: Simple-String (enthält Ziffern mit Wert <base und Bruchstrich)
# > index1: Index der ersten Ziffer
# > index3: Index von '/'
# > index2: Index nach der letzten Ziffer
#   (also index3-index1 Zähler-Ziffern, index2-index3-1 Nenner-Ziffern)
# < ergebnis: rationale Zahl
# kann GC auslösen
  extern object read_rational (uintWL base,
         signean sign, object string, uintL index1, uintL index3, uintL index2);
# wird verwendet von IO

# UP: Wandelt eine Zeichenkette mit Float-Syntax in ein Float um.
# read_float(base,sign,string,index1,index4,index2,index3)
# > base: Lesebasis (=10)
# > sign: Vorzeichen (/=0 falls negativ)
# > string: Simple-String (enthält Ziffern und evtl. Punkt und Exponentmarker)
# > index1: Index vom Mantissenanfang (excl. Vorzeichen)
# > index4: Index nach dem Mantissenende
# > index2: Index beim Ende der Characters
# > index3: Index nach dem Dezimalpunkt (=index4 falls keiner da)
#   (also Mantisse mit index4-index1 Characters: Ziffern und max. 1 '.')
#   (also index4-index3 Nachkommaziffern)
#   (also bei index4<index2: index4 = Index des Exponent-Markers,
#    index4+1 = Index des Exponenten-Vorzeichens oder der ersten
#    Exponenten-Ziffer)
# < ergebnis: Float
# kann GC auslösen
  extern object read_float (uintWL base,
         signean sign, object string, uintL index1, uintL index4, uintL index2, uintL index3);
# wird verwendet von IO

# UP: Gibt ein Integer aus.
# print_integer(z,base,&stream);
# > z: Integer
# > base: Basis (>=2, <=36)
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void print_integer (object z, uintWL base, object* stream_);
# wird verwendet von IO

# UP: Gibt ein Float aus.
# print_float(z,&stream);
# > z: Float
# > stream: Stream
# < stream: Stream
# kann GC auslösen
  extern void print_float (object z, object* stream_);
# wird verwendet von IO

# UP: Multipliziert ein Integer mit 10 und addiert eine weitere Ziffer.
# mal_10_plus_x(y,x)
# > y: Integer Y (>=0)
# > x: Ziffernwert X (>=0,<10)
# < ergebnis: Integer Y*10+X (>=0)
# kann GC auslösen
  extern object mal_10_plus_x (object y, uintB x);
# wird verwendet von IO

# UP: entscheidet auf Zahlgleichheit
# number_gleich(x,y)
# > x,y: zwei Zahlen
# < ergebnis: TRUE, falls (= x y) gilt
# kann GC auslösen
  extern boolean number_gleich (object x, object y);
# wird verwendet von PREDTYPE

# UP: Wandelt ein Objekt in ein Float von gegebenem Typ um.
# coerce_float(obj,type)
# > obj: Objekt
# > type: Eines der Symbole
#         FLOAT, SHORT-FLOAT, SINGLE-FLOAT, DOUBLE-FLOAT, LONG-FLOAT
# > subr_self: Aufrufer (ein SUBR)
# < ergebnis: (coerce obj type)
# kann GC auslösen
  extern object coerce_float (object obj, object type);
# wird verwendet von PREDTYPE

# ###################### FRGNIBL zu FOREIGN.D ############################# #

#ifdef DYNAMIC_FFI

# Return the pointer encoded by a Foreign-Pointer. obj a variable
  #define Fpointer_value(obj)  \
    (fp_validp(TheFpointer(obj)) ? 0 : (validate_fpointer(obj), 0), \
     TheFpointer(obj)->fp_pointer                                   \
    )
  extern void validate_fpointer (object obj);

# Return the pointer encoded by a Foreign-Address. obj a variable
  #define Faddress_value(obj)  \
    ((void*)((uintP)Fpointer_value(TheFaddress(obj)->fa_base) + TheFaddress(obj)->fa_offset))

# Registers a foreign variable.
# register_foreign_variable(address,name,flags,size);
# > address: address of a variable in memory
# > name: its name
# > flags: fv_readonly for read-only variables
# > size: its size in bytes
# kann GC auslösen
  extern void register_foreign_variable (void* address, const char * name, uintBWL flags, uintL size);
# Specifies that the variable will not be written to.
#define fv_readonly  bit(0)
# Specifies that when the value is replaced and the variable contains pointers,
# the old storage will be free()d and new storage will be allocated via malloc().
#define fv_malloc    bit(1)

# Registers a foreign function.
# register_foreign_function(address,name,flags);
# > address: address of the function in memory
# > name: its name
# > flags: its language and parameter passing convention
# kann GC auslösen
  extern void register_foreign_function (void* address, const char * name, uintWL flags);
# Flags for language:
#define ff_lang_asm       bit(8)  # no argument passing conventions
#define ff_lang_c         bit(9)  # K&R C, with argument type promotions
#define ff_lang_ansi_c    bit(10) # ANSI C, without argument type promotions
# define ff_lang_pascal   bit(11) # not yet supported
# Varargs functions are not supported.
# Set this if pointers within the arg should point to alloca()ed data, i.e.
# have dynamic extent: are valid for this call only.
#define ff_alloca         bit(0)
# Set this if pointers within the arg should point to malloc()ed data. The
# function takes over responsibility for that storage. For return values,
# set this if free() shall be called for pointers within the resulting value.
#define ff_malloc         bit(1)
# Set this if the arg should point to a place where a return value can be
# stored.
#define ff_out            bit(4)
# Set this if the arg is also treated as a return value.
#define ff_inout          bit(5)

# Convert foreign data to Lisp data.
# kann GC auslösen
  extern object convert_from_foreign (object fvd, void* data);

# Convert Lisp data to foreign data.
# The foreign data is allocated through malloc() and has more than dynamic
# extent. (Not exactly indefinite extent: It is deallocated the next time
# free_foreign() is called on it.)
  extern void convert_to_foreign_mallocing (object fvd, object obj, void* data);

# Convert Lisp data to foreign data.
# The foreign data storage is reused.
# DANGEROUS, especially for type C-STRING !!
# Also beware against NULL pointers! They are not treated specially.
  extern void convert_to_foreign_nomalloc (object fvd, object obj, void* data);

# Initialize the FFI.
  extern void init_ffi (void);
# wird verwendet von SPVW

# De-Initialize the FFI.
  extern void exit_ffi (void);
# wird verwendet von SPVW

#endif

# ####################### REXXBIBL zu REXX.D ############################## #

#ifdef REXX

# Initialisiert die Rexx-Schnittstelle.
# init_rexx();
# < ergebnis: Flag, ob erfolgreich initialisiert.
  extern boolean init_rexx (void);
# wird verwendet von SPVW

# Schließt die Rexx-Schnittstelle.
# close_rexx();
  extern void close_rexx (void);
# wird verwendet von SPVW

#endif

# ######################## GRAPHBIBL zu GRAPH.D ########################### #

#ifdef GRAPHICS_SWITCH

# Schaltet die Grafik auf Text-Modus zurück.
# switch_text_mode();
  extern void switch_text_mode (void);

#endif

# ######################################################################### #

