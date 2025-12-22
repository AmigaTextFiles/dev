/* PortablE target module for C++ */
OPT NATIVE, INLINE, POINTER, PREPROCESS
{

#define _CRT_SECURE_NO_DEPRECATE 1	//silence depreciated warnings of Visual C++
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
//#include <errno.h>
#include <limits.h>
#include <math.h>
#include <string.h>

#define NULLA NULL
#define NULLS NULL
#define NULLL NULL
#define EMPTY (void)0
#define TRUE -1
#define FALSE 0
#define QuadChara(a, b, c, d) ((a << 24) | (b << 16) | (c << 8) | d)
typedef signed char BOOLEAN;	//enum BOOLEAN {FALSE=0, TRUE=-1};
class eException {};

void* FastNew(long size, BOOLEAN noClear);
void* FastDispose(void* mem, long size);
}
NATIVE {QuadChara} PROC
NATIVE {BOOLEAN} CONST
NATIVE {end} PROC	->reserve this, since "new" is too, so that both procedure/method names match
/* #### 
{
extern int    main_argc;
extern char** main_argv;
}
{
int    main_argc;
char** main_argv;
}
NATIVE {main_argc} DEF
NATIVE {main_argv} DEF
PROC PrivateGetMainArgc() IS NATIVE {main_argc} ENDNATIVE !!VALUE
PROC PrivateGetMainArgv() IS NATIVE {main_argv} ENDNATIVE !!ARRAY OF ARRAY OF CHAR
 #### */

PRIVATE
DEF eException:NATIVE {class eException} VALUE
DEF main_argc :NATIVE {long} VALUE
DEF main_argv :NATIVE {char**} ARRAY OF ARRAY OF CHAR
PUBLIC
PROC PrivateGetMainArgc() IS main_argc
PROC PrivateGetMainArgv() IS main_argv

STATIC pe_TargetLanguage = 'CPP'
#define pe_TargetLanguage_CPP

PROC OptMultiThreaded() RETURNS multiThreaded:BOOL PROTOTYPE IS EMPTY

/* reserve keywords for C/C++ */
NATIVE {asm} PROC
NATIVE {auto} PROC
NATIVE {bool} PROC
NATIVE {break} PROC
NATIVE {case} PROC
NATIVE {catch} PROC
NATIVE {char} PROC
NATIVE {class} PROC
NATIVE {const} PROC
NATIVE {const_cast} PROC
NATIVE {continue} PROC
NATIVE {default} PROC
NATIVE {delete} PROC
NATIVE {do} PROC
NATIVE {double} PROC
NATIVE {dynamic_cast} PROC
NATIVE {else} PROC
NATIVE {enum} PROC
NATIVE {explicit} PROC
NATIVE {export} PROC
NATIVE {extern} PROC
NATIVE {false} PROC
NATIVE {float} PROC
NATIVE {for} PROC
NATIVE {friend} PROC
NATIVE {goto} PROC
NATIVE {if} PROC
NATIVE {inline} PROC
NATIVE {int} PROC
NATIVE {long} PROC
NATIVE {mutable} PROC
NATIVE {namespace} PROC
NATIVE {new} PROC
NATIVE {operator} PROC
NATIVE {private} PROC
NATIVE {protected} PROC
NATIVE {public} PROC
NATIVE {register} PROC
NATIVE {reinterpret_cast} PROC
NATIVE {return} PROC
NATIVE {short} PROC
NATIVE {signed} PROC
NATIVE {sizeof} PROC
NATIVE {static} PROC
NATIVE {static_cast} PROC
NATIVE {struct} PROC
NATIVE {switch} PROC
NATIVE {template} PROC
NATIVE {this} PROC
NATIVE {throw} PROC
NATIVE {true} PROC
NATIVE {try} PROC
NATIVE {typedef} PROC
NATIVE {typeid} PROC
NATIVE {typename} PROC
NATIVE {union} PROC
NATIVE {unsigned} PROC
NATIVE {using} PROC
NATIVE {virtual} PROC
NATIVE {void} PROC
NATIVE {volatile} PROC
->NATIVE {wchar_t} PROC
NATIVE {while} PROC
NATIVE {and} PROC
NATIVE {and_eq} PROC
NATIVE {bitand} PROC
NATIVE {bitor} PROC
NATIVE {compl} PROC
NATIVE {not} PROC
NATIVE {not_eq} PROC
NATIVE {or} PROC
NATIVE {or_eq} PROC
NATIVE {xor} PROC
NATIVE {xor_eq} PROC

/* reserve keywords for stddef.h */
NATIVE {NULL} CONST NIL =  0!!VALUE!!PTR
NATIVE {offsetof} PROC

NATIVE {ptrdiff_t} OBJECT
NATIVE {size_t} OBJECT
NATIVE {wchar_t} OBJECT

/* reserve keywords for stdio.h */
NATIVE {_IOFBF} PROC
NATIVE {_IOLBF} PROC
NATIVE {_IONBF} PROC

NATIVE {BUFSIZ} CONST
NATIVE {EOF} CONST
NATIVE {FILENAME_MAX} CONST
NATIVE {FOPEN_MAX} CONST
NATIVE {L_tmpnam} CONST
->NATIVE {NULL} CONST
NATIVE {SEEK_CUR} CONST
NATIVE {SEEK_END} CONST
NATIVE {SEEK_SET} CONST
NATIVE {TMP_MAX} CONST

NATIVE {stderr} DEF
NATIVE {stdin}  DEF stdin :NATIVE {FILE*} PTR
NATIVE {stdout} DEF stdout:NATIVE {FILE*} PTR

NATIVE {FILE} CONST
NATIVE {fpos_t} PROC
->NATIVE {size_t} PROC

NATIVE {clearerr} PROC
NATIVE {fclose} PROC
NATIVE {feof} PROC
NATIVE {ferror} PROC
NATIVE {fflush} PROC
NATIVE {fopen} PROC
NATIVE {freopen} PROC
NATIVE {remove} PROC
NATIVE {rename} PROC
NATIVE {rewind} PROC
NATIVE {setbuf} PROC
NATIVE {setvbuf} PROC
NATIVE {tmpfile} PROC
NATIVE {tmpnam} PROC

NATIVE {fseek} PROC
NATIVE {fsetpos} PROC
NATIVE {fgetpos} PROC
NATIVE {ftell} PROC

NATIVE {fgetc} PROC
NATIVE {fgets} PROC
NATIVE {fread} PROC
NATIVE {getc} PROC
NATIVE {getchar} PROC
NATIVE {gets} PROC
NATIVE {ungetc} PROC

NATIVE {fputc} PROC
NATIVE {fputs} PROC
NATIVE {fwrite} PROC
NATIVE {perror} PROC
NATIVE {putc} PROC
NATIVE {putchar} PROC
NATIVE {puts} PROC

NATIVE {fscanf} PROC
NATIVE {scanf} PROC
NATIVE {sscanf} PROC
NATIVE {vfscanf} PROC
NATIVE {vscanf} PROC
NATIVE {vsscanf} PROC

NATIVE {fprintf} PROC
NATIVE {printf} PROC
NATIVE {snprintf} PROC
NATIVE {sprintf} PROC
NATIVE {vfprintf} PROC
NATIVE {vprintf} PROC
NATIVE {vsnprintf} PROC
NATIVE {vsprintf} PROC

/* reserve keywords for stdlib.h */
NATIVE {EXIT_FAILURE} CONST
NATIVE {EXIT_SUCCESS} CONST
NATIVE {MB_CUR_MAX} CONST
->NATIVE {NULL} CONST
NATIVE {RAND_MAX} CONST

NATIVE {div_t} PROC
NATIVE {ldiv_t} PROC
NATIVE {lldiv_t} PROC

->NATIVE {size_t} PROC
->NATIVE {wchar_t} PROC

NATIVE {abs} PROC
NATIVE {llabs} PROC
NATIVE {labs} PROC

NATIVE {div} PROC
NATIVE {lldiv} PROC
NATIVE {ldiv} PROC

NATIVE {rand} PROC
NATIVE {srand} PROC

NATIVE {atof} PROC
NATIVE {atoi} PROC
NATIVE {atol} PROC
NATIVE {atoll} PROC

NATIVE {strtod} PROC
NATIVE {strtof} PROC
NATIVE {strtold} PROC

NATIVE {strtoll} PROC
NATIVE {strtoull} PROC

NATIVE {strtol} PROC
NATIVE {strtoul} PROC

NATIVE {calloc} PROC
NATIVE {free} PROC
NATIVE {malloc} PROC
NATIVE {realloc} PROC

NATIVE {mblen} PROC
NATIVE {mbstowcs} PROC
NATIVE {mbtowc} PROC
NATIVE {wcstombs} PROC
NATIVE {wctomb} PROC

NATIVE {_Exit} PROC
NATIVE {exit} PROC
NATIVE {abort} PROC
NATIVE {getenv} PROC
NATIVE {system} PROC

NATIVE {atexit} PROC
NATIVE {bsearch} PROC
NATIVE {qsort} PROC

->/* reserve keywords for errno.h */
->NATIVE {EDOM} CONST
->NATIVE {EILSEQ} CONST
->NATIVE {ERANGE} CONST
->NATIVE {errno} PROC

/* reserve keywords for limits.h */
NATIVE {CHAR_BIT} CONST
NATIVE {CHAR_MAX} CONST
NATIVE {CHAR_MIN} CONST
NATIVE {INT_MAX} CONST
NATIVE {INT_MIN} CONST
NATIVE {LLONG_MAX} CONST
NATIVE {LLONG_MIN} CONST
NATIVE {LONG_MAX} CONST
NATIVE {LONG_MIN} CONST
NATIVE {MB_LEN_MAX} CONST
NATIVE {SCHAR_MAX} CONST
NATIVE {SCHAR_MIN} CONST
NATIVE {SHRT_MAX} CONST
NATIVE {SHRT_MIN} CONST
NATIVE {UCHAR_MAX} CONST
NATIVE {UINT_MAX} CONST
NATIVE {ULLONG_MAX} CONST
NATIVE {ULONG_MAX} CONST
NATIVE {USHRT_MAX} CONST

/* reserve keywords for math.h */
NATIVE {HUGE_VAL} CONST
NATIVE {HUGE_VALF} CONST
NATIVE {HUGE_VALL} CONST
NATIVE {INFINITY} CONST
NATIVE {NAN} CONST
NATIVE {FP_FAST_FMA} CONST
NATIVE {FP_FAST_FMAF} CONST
NATIVE {FP_FAST_FMAL} CONST
NATIVE {FP_INFINITE} CONST
NATIVE {FP_NAN} CONST
NATIVE {FP_NORMAL} CONST
NATIVE {FP_SUBNORMAL} CONST
NATIVE {FP_ZERO} CONST
NATIVE {FP_ILOGB0} CONST
NATIVE {FP_ILOGBNAN} CONST
NATIVE {MATH_ERRNO} CONST
NATIVE {MATH_ERREXCEPT} CONST

NATIVE {math_errhandling} PROC
NATIVE {double_t} PROC
NATIVE {float_t} PROC

NATIVE {signbit} PROC

NATIVE {fpclassify} PROC
NATIVE {isfinite} PROC
NATIVE {isinf} PROC
NATIVE {isnan} PROC
NATIVE {isnormal} PROC

NATIVE {isgreater} PROC
NATIVE {isgreaterequal} PROC
NATIVE {isless} PROC
NATIVE {islessequal} PROC
NATIVE {islessgreater} PROC
NATIVE {isunordered} PROC

->NATIVE {abs} PROC
NATIVE {acos} PROC
NATIVE {acosf} PROC
NATIVE {acosl} PROC
NATIVE {asin} PROC
NATIVE {asinf} PROC
NATIVE {asinl} PROC
NATIVE {atan} PROC
NATIVE {atanf} PROC
NATIVE {atanl} PROC
NATIVE {atan2} PROC
NATIVE {atan2f} PROC
NATIVE {atan2l} PROC
NATIVE {ceil} PROC
NATIVE {ceilf} PROC
NATIVE {ceill} PROC
NATIVE {cos} PROC
NATIVE {cosf} PROC
NATIVE {cosl} PROC
NATIVE {cosh} PROC
NATIVE {coshf} PROC
NATIVE {coshl} PROC
NATIVE {exp} PROC
NATIVE {expf} PROC
NATIVE {expl} PROC
NATIVE {fabs} PROC
NATIVE {fabsf} PROC
NATIVE {fabsl} PROC
NATIVE {floor} PROC
NATIVE {floorf} PROC
NATIVE {floorl} PROC
NATIVE {fmod} PROC
NATIVE {fmodf} PROC
NATIVE {fmodl} PROC
NATIVE {frexp} PROC
NATIVE {frexpf} PROC
NATIVE {frexpl} PROC
NATIVE {ldexp} PROC
NATIVE {ldexpf} PROC
NATIVE {ldexpl} PROC
NATIVE {log} PROC
NATIVE {logf} PROC
NATIVE {logl} PROC
NATIVE {log10} PROC
NATIVE {log10f} PROC
NATIVE {log10l} PROC
NATIVE {modf} PROC
NATIVE {modff} PROC
NATIVE {modfl} PROC
NATIVE {pow} PROC
NATIVE {powf} PROC
NATIVE {powl} PROC
NATIVE {sin} PROC
NATIVE {sinf} PROC
NATIVE {sinl} PROC
NATIVE {sinh} PROC
NATIVE {sinhf} PROC
NATIVE {sinhl} PROC
NATIVE {sqrt} PROC
NATIVE {sqrtf} PROC
NATIVE {sqrtl} PROC
NATIVE {tan} PROC
NATIVE {tanf} PROC
NATIVE {tanl} PROC
NATIVE {tanh} PROC
NATIVE {tanhf} PROC
NATIVE {tanhl} PROC
NATIVE {acosh} PROC
NATIVE {acoshf} PROC
NATIVE {acoshl} PROC
NATIVE {asinh} PROC
NATIVE {asinhf} PROC
NATIVE {asinhl} PROC
NATIVE {atanh} PROC
NATIVE {atanhf} PROC
NATIVE {atanhl} PROC
NATIVE {cbrt} PROC
NATIVE {cbrtf} PROC
NATIVE {cbrtl} PROC
NATIVE {copysign} PROC
NATIVE {copysignf} PROC
NATIVE {copysignl} PROC
NATIVE {erf} PROC
NATIVE {erff} PROC
NATIVE {erfl} PROC
NATIVE {erfc} PROC
NATIVE {erfcf} PROC
NATIVE {erfcl} PROC
NATIVE {exp2} PROC
NATIVE {exp2f} PROC
NATIVE {exp2l} PROC
NATIVE {expm1} PROC
NATIVE {expm1f} PROC
NATIVE {expm1l} PROC
NATIVE {fdim} PROC
NATIVE {fdimf} PROC
NATIVE {fdiml} PROC
NATIVE {fma} PROC
NATIVE {fmaf} PROC
NATIVE {fmal} PROC
NATIVE {fmax} PROC
NATIVE {fmaxf} PROC
NATIVE {fmaxl} PROC
NATIVE {fmin} PROC
NATIVE {fminf} PROC
NATIVE {fminl} PROC
NATIVE {hypot} PROC
NATIVE {hypotf} PROC
NATIVE {hypotl} PROC
NATIVE {ilogb} PROC
NATIVE {ilogbf} PROC
NATIVE {ilogbl} PROC
NATIVE {lgamma} PROC
NATIVE {lgammaf} PROC
NATIVE {lgammal} PROC
NATIVE {llrint} PROC
NATIVE {llrintf} PROC
NATIVE {llrintl} PROC
NATIVE {llround} PROC
NATIVE {llroundf} PROC
NATIVE {llroundl} PROC
NATIVE {log1p} PROC
NATIVE {log1pf} PROC
NATIVE {log1pl} PROC
NATIVE {log2} PROC
NATIVE {log2f} PROC
NATIVE {log2l} PROC
NATIVE {logb} PROC
NATIVE {logbf} PROC
NATIVE {logbl} PROC
NATIVE {lrint} PROC
NATIVE {lrintf} PROC
NATIVE {lrintl} PROC
NATIVE {lround} PROC
NATIVE {lroundf} PROC
NATIVE {lroundl} PROC
NATIVE {nan} PROC
NATIVE {nanf} PROC
NATIVE {nanl} PROC
NATIVE {nearbyint} PROC
NATIVE {nearbyintf} PROC
NATIVE {nearbyintl} PROC
NATIVE {nextafter} PROC
NATIVE {nextafterf} PROC
NATIVE {nextafterl} PROC
NATIVE {nexttoward} PROC
NATIVE {nexttowardf} PROC
NATIVE {nexttowardl} PROC
NATIVE {remainder} PROC
NATIVE {remainderf} PROC
NATIVE {remainderl} PROC
NATIVE {remquo} PROC
NATIVE {remquof} PROC
NATIVE {remquol} PROC
NATIVE {rint} PROC
NATIVE {rintf} PROC
NATIVE {rintl} PROC
NATIVE {round} PROC
NATIVE {roundf} PROC
NATIVE {roundl} PROC
NATIVE {scalbln} PROC
NATIVE {scalblnf} PROC
NATIVE {scalblnl} PROC
NATIVE {scalbn} PROC
NATIVE {scalbnf} PROC
NATIVE {scalbnl} PROC
NATIVE {tgamma} PROC
NATIVE {tgammaf} PROC
NATIVE {tgammal} PROC
NATIVE {trunc} PROC
NATIVE {truncf} PROC
NATIVE {truncl} PROC
NATIVE {laguerre} PROC
NATIVE {laguerref} PROC
NATIVE {laguerrel} PROC
NATIVE {assoc_laguerre} PROC
NATIVE {assoc_laguerref} PROC
NATIVE {assoc_laguerrel} PROC
NATIVE {legendre} PROC
NATIVE {legendref} PROC
NATIVE {legendrel} PROC
NATIVE {assoc_legendre} PROC
NATIVE {assoc_legendref} PROC
NATIVE {assoc_legendrel} PROC
NATIVE {sph_legendre} PROC
NATIVE {sph_legendref} PROC
NATIVE {sph_legendrel} PROC
NATIVE {beta} PROC
NATIVE {betaf} PROC
NATIVE {betal} PROC
NATIVE {ellint_1} PROC
NATIVE {ellint_1f} PROC
NATIVE {ellint_1l} PROC
NATIVE {ellint_2} PROC
NATIVE {ellint_2f} PROC
NATIVE {ellint_2l} PROC
NATIVE {ellint_3} PROC
NATIVE {ellint_3f} PROC
NATIVE {ellint_3l} PROC
NATIVE {comp_ellint_1} PROC
NATIVE {comp_ellint_1f} PROC
NATIVE {comp_ellint_1l} PROC
NATIVE {comp_ellint_2} PROC
NATIVE {comp_ellint_2f} PROC
NATIVE {comp_ellint_2l} PROC
NATIVE {comp_ellint_3} PROC
NATIVE {comp_ellint_3f} PROC
NATIVE {comp_ellint_3l} PROC
NATIVE {cyl_bessel_i} PROC
NATIVE {cyl_bessel_if} PROC
NATIVE {cyl_bessel_il} PROC
NATIVE {cyl_bessel_j} PROC
NATIVE {cyl_bessel_jf} PROC
NATIVE {cyl_bessel_jl} PROC
NATIVE {cyl_bessel_k} PROC
NATIVE {cyl_bessel_kf} PROC
NATIVE {cyl_bessel_kl} PROC
NATIVE {sph_bessel} PROC
NATIVE {sph_besself} PROC
NATIVE {sph_bessell} PROC
NATIVE {cyl_neumann} PROC
NATIVE {cyl_neumannf} PROC
NATIVE {cyl_neumannl} PROC
NATIVE {sph_neumann} PROC
NATIVE {sph_neumannf} PROC
NATIVE {sph_neumannl} PROC
NATIVE {expint} PROC
NATIVE {expintf} PROC
NATIVE {expintl} PROC
NATIVE {hermite} PROC
NATIVE {hermitef} PROC
NATIVE {hermitel} PROC
NATIVE {riemann_zeta} PROC
NATIVE {riemann_zetaf} PROC
NATIVE {riemann_zetal} PROC

/* reserve keywords for string.h */
->NATIVE {NULL} CONST
->NATIVE {size_t} PROC

NATIVE {memcmp} PROC
NATIVE {memcpy} PROC
NATIVE {memmove} PROC
NATIVE {memset} PROC
NATIVE {strcat} PROC
NATIVE {strcmp} PROC
NATIVE {strcoll} PROC
NATIVE {strcpy} PROC
NATIVE {strcspn} PROC
NATIVE {strerror} PROC
NATIVE {strlen} PROC
NATIVE {strncat} PROC
NATIVE {strncmp} PROC
NATIVE {strncpy} PROC
NATIVE {strspn} PROC
NATIVE {strtok} PROC
NATIVE {strxfrm} PROC

NATIVE {memchr} PROC
NATIVE {strchr} PROC
NATIVE {strpbrk} PROC
NATIVE {strrchr} PROC
NATIVE {strstr} PROC


NATIVE {stricmp} PROC
NATIVE {strnicmp} PROC
NATIVE {strlwr} PROC
NATIVE {strupr} PROC

NATIVE {bzero} PROC

/* spurious reserved keywords */

NATIVE {read}  DEF
NATIVE {write} DEF

/* system constants */
NATIVE {TRUE}  CONST TRUE  = -1
NATIVE {FALSE} CONST FALSE =  0
NATIVE {NULLA} CONST NILA = 0!!VALUE!!ARRAY		->equivalent of NIL for arrays
NATIVE {NULLS} CONST NILS = 0!!VALUE!!STRING	->equivalent of NIL for strings
NATIVE {NULLL} CONST NILL = 0!!VALUE!!LIST		->equivalent of NIL for lists
CONST ALL = -1!!LONG

/* system globals */

DEF exception:QUAD
DEF exceptionInfo:ARRAY OF CHAR

/* system procedure calls */

PROC Print( fmtString:ARRAY OF CHAR, arg=0, ...) IS NATIVE {printf(} fmtString {,} arg {,} ... {)} ENDNATIVE

PROC PrintL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) PROTOTYPE IS EMPTY
PROC PrintFlush() IS NATIVE {fflush(stdout)} ENDNATIVE
PROC Out(fileHandle:PTR, char:CHAR) IS IF NATIVE {putc(} char {,(FILE*)} fileHandle {)} ENDNATIVE !!INT = ({EOF}!!INT) THEN -1 ELSE 1
PROC Inp(fileHandle:PTR) RETURNS char:INT
	char := NATIVE {getc((FILE*)} fileHandle {)} ENDNATIVE !!INT
	IF char = ({EOF}!!INT) THEN char := -1
ENDPROC
PROC FileLength(path:ARRAY OF CHAR) RETURNS size
	
	NATIVE {FILE* stream = fopen(} path {,"rb")} ENDNATIVE
	IF {stream}!!PTR = NIL
		size := -1
	ELSE
		{fseek(stream, 0, SEEK_END)}
		size := {ftell(stream)} !!VALUE
		{fclose(stream)}
	ENDIF
ENDPROC

PROC StrCmp(first:ARRAY OF CHAR, second:ARRAY OF CHAR, len=ALL, firstOffset=0, secondOffset=0) RETURNS match:BOOL
->IS 0 = (IF len=ALL THEN NATIVE {strcmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {)} ENDNATIVE) ELSE (0 = NATIVE {strncmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {,} len {)} ENDNATIVE))
	IF len = ALL
		match := (NATIVE {strcmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {)} ENDNATIVE!!VALUE = 0)	->!!BYTE
	ELSE
		match := (NATIVE {strncmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {,} len {)} ENDNATIVE!!VALUE = 0)	->!!BYTE
	ENDIF
ENDPROC

PROC StrCmpNoCase(first:ARRAY OF CHAR, second:ARRAY OF CHAR, len=ALL, firstOffset=0, secondOffset=0) RETURNS match:BOOL
->IS 0 = (IF len=ALL THEN NATIVE {strcasecmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {)} ENDNATIVE) ELSE (0 = NATIVE {strncasecmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {,} len {)} ENDNATIVE))
	IF len = ALL
		match := (NATIVE {strcasecmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {)} ENDNATIVE!!VALUE = 0)	->!!BYTE
	ELSE
		match := (NATIVE {strncasecmp(} firstOffset*SIZEOF CHAR + first {,} secondOffset*SIZEOF CHAR + second {,} len {)} ENDNATIVE!!VALUE = 0)	->!!BYTE
	ENDIF
ENDPROC

PROC StrLen(string:ARRAY OF CHAR) IS NATIVE {strlen(} string {)} ENDNATIVE !!VALUE

PROC Val(string:ARRAY OF CHAR, addrRead=NILA:ARRAY OF LONG, startPos=0) RETURNS value, read
	DEF   str:PTR TO CHAR, i
	DEF final:PTR TO CHAR, base:BYTE, isNegative:BOOL
	
	->find start of number (skip any spaces & tabs)
	/*i := startPos
	WHILE (string[i]=" ") OR (string[i]="\t") DO i++
	*/
	i := NATIVE {strspn(} string {+} startPos {,} ' \t' {)} ENDNATIVE !!VALUE
	str := string + (startPos+i * SIZEOF CHAR)
	
	->determine sign & base of number (and skip their symbols)
	IF isNegative := (str[0] = "-") THEN str++
	
	IF      str[0] = "\0"; base :=  0	->string is empty
	ELSE IF str[0] = "%" ; base :=  2 ; str++
	ELSE IF str[0] = "$" ; base := 16 ; str++
	ELSE                 ; base := 10
	ENDIF
	
	->interpret value
	IF base = 0
		value := 0
		read  := 0
	ELSE
		IF base = 10
			value := NATIVE  {strtol(} str {,&} final {,} base {)} ENDNATIVE !!VALUE
		ELSE
			value := NATIVE {strtoul(} str {,&} final {,} base {)} ENDNATIVE !!VALUE
		ENDIF
		IF final <> str
			read  := (final - string) / SIZEOF CHAR !!LONG - startPos
		ELSE
			value := 0
			read  := 0
		ENDIF
	ENDIF
	
	IF addrRead THEN addrRead[0] := read !!LONG
	IF isNegative THEN value := -value
ENDPROC

PROC InStr(haystack:ARRAY OF CHAR, needle:ARRAY OF CHAR, startPos=0) RETURNS matchPos
	DEF start:PTR TO CHAR, found:PTR TO CHAR
	
	start := haystack + (startPos * SIZEOF CHAR)
	
	found := NATIVE {strstr(} start {,} needle {)} ENDNATIVE !!PTR TO CHAR
	IF found
		matchPos := (found - haystack) / SIZEOF CHAR
	ELSE
		matchPos := -1
	ENDIF
ENDPROC

PROC InStrNoCase(haystack:ARRAY OF CHAR, needle:ARRAY OF CHAR, startPos=0) RETURNS matchPos
	DEF haystackPos, needlePos, haystackChara:CHAR, needleChara:CHAR
	
	haystackPos := startPos
	  needlePos := 0
	
	haystackChara := haystack[haystackPos]
	  needleChara :=   needle[needlePos]
	
	matchPos := IF needleChara<>0 THEN -1 ELSE haystackPos
	WHILE (haystackChara<>0) AND (needleChara<>0)
		IF lowerChar(haystackChara) = lowerChar(needleChara)
			->(matching charas)
			IF matchPos = -1 THEN matchPos := haystackPos
			needlePos++ ; needleChara := needle[needlePos]
		ELSE
			->(mismatched charas) so restart search
			IF matchPos <> -1
				haystackPos := matchPos
				matchPos := -1
			ENDIF
			needlePos := 0 ; needleChara := needle[needlePos]
		ENDIF
		
		haystackPos++ ; haystackChara := haystack[haystackPos]
	ENDWHILE
	
	IF needle[needlePos]<>0 THEN matchPos := -1
ENDPROC
PRIVATE
PROC lowerChar(chara:CHAR) IS IF (chara >= "A") AND (chara <= "Z") THEN chara + "a" - "A" ELSE chara
PUBLIC

PROC TrimStr(string:ARRAY OF CHAR) IS (NATIVE {strspn(} string {,} ' \t\n\b' {)} ENDNATIVE !!VALUE + string)!!ARRAY OF CHAR
PROC UpperStr(string:ARRAY OF CHAR)
	DEF i, chara:CHAR
	i := 0
	WHILE chara := string[i]
		IF (chara >= "a") AND (chara <= "z") THEN string[i] := chara + "A" - "a"
		i++
	ENDWHILE
ENDPROC string
PROC LowerStr(string:ARRAY OF CHAR)
	DEF i, chara:CHAR
	i := 0
	WHILE chara := string[i]
		IF (chara >= "A") AND (chara <= "Z") THEN string[i] := chara + "a" - "A"
		i++
	ENDWHILE
ENDPROC string
PROC AstrCopy(destination:ARRAY, source:ARRAY OF CHAR, destSize)
	{strncpy((char*)} destination {,} source {,} destSize-1 {)}
	{((char*)} destination {)[} destSize - 1 {] = 0}
ENDPROC
->OstrCmp()
->OstrCmpNoCase()

PROC QuadToStr(value:QUAD) RETURNS string:ARRAY OF CHAR
	quadStr[0] := Max(32, value SHR 24 AND $FF) !!CHAR
	quadStr[1] := Max(32, value SHR 16 AND $FF) !!CHAR
	quadStr[2] := Max(32, value SHR  8 AND $FF) !!CHAR
	quadStr[3] := Max(32, value SHR  0 AND $FF) !!CHAR
	quadStr[4] := 0
	
	string := quadStr
ENDPROC
PRIVATE
DEF quadStr[5]:ARRAY OF CHAR
PUBLIC

PROC CleanUp(returnValue=0)
	Throw(-1, returnValue!!ARRAY OF CHAR)	->use reserved exception -1 for CleanUp()
ENDPROC
->FreeStack()
->CtrlC()

PROC New(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY PROTOTYPE IS EMPTY
PROC NewR(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY PROTOTYPE IS EMPTY
PROC Dispose(mem:ARRAY) PROTOTYPE IS NILA

/*NATIVE {FastNew}*/     PROC FastNew(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY PROTOTYPE IS EMPTY
/*NATIVE {FastDispose}*/ PROC FastDispose(mem:ARRAY, size) PROTOTYPE IS NILA
PROC FastVerify(quiet=FALSE:BOOL) RETURNS failed:BOOL PROTOTYPE IS EMPTY
PROC FastReport(quiet=FALSE:BOOL) RETURNS leakSize, leakCount, unusedSize, unusedCount, poolCount PROTOTYPE IS EMPTY

PROC MemCopy(target:ARRAY, source:ARRAY, sizeInBytes, targetOffsetInBytes=0, sourceOffsetInBytes=0) IS NATIVE {memmove(} target + targetOffsetInBytes {,} source + sourceOffsetInBytes {,} sizeInBytes {)} ENDNATIVE !!ARRAY

->PROC NewArray(sizeInItems, itemSizeInBytes:INT) IS NATIVE {calloc(} sizeInItems {,} itemSizeInBytes {)} ENDNATIVE !!PTR		->returns !!PTR to ensure it can only used with OPT POINTER
->PROC DisposeArray(array:ARRAY) IS NATIVE {free(} array {)} ENDNATIVE BUT NILA
PROC NewArray(sizeInItems, itemSizeInBytes:INT) IS FastNew(sizeInItems * itemSizeInBytes) !!PTR		->returns !!PTR to ensure it can only used with OPT POINTER
PROC DisposeArray(array:ARRAY) IS FastDispose(array, -999) BUT NILA
PROC ArrayCopy(target:PTR, source:ARRAY, sizeInItems, itemSizeInBytes:INT) IS MemCopy(target/*!!PTR*/, source!!PTR, sizeInItems * itemSizeInBytes)	->accepts :PTR to ensure that it can only be used with OPT POINTER

PROC  And(a, b) IS a AND b
PROC   Or(a, b) IS a OR b
PROC  Xor(a, b) IS a XOR b
PROC  Not(a)    IS NOT a
PROC  Mul(a, b) IS a * b
PROC  Div(a, b) IS a / b
PROC  Odd(a) IS (a AND 1)<>0
PROC Even(a) IS (a AND 1)=0
PROC  Min(a, b) IS IF a<b THEN a ELSE b
PROC  Max(a, b) IS IF a>b THEN a ELSE b
PROC  Rnd(max) RETURNS num
	IF max >= 0
		num := FastMod( {rand()}!!VALUE , max )
	ELSE
		num := NATIVE {srand(labs(} max {))} ENDNATIVE BUT 0
	ENDIF
ENDPROC
PROC RndQ(seed) IS NATIVE {srand(labs(} seed {))} ENDNATIVE BUT ({rand()}!!VALUE)
PROC  Abs(a) IS NATIVE {labs(} a {)} ENDNATIVE !!VALUE
PROC Sign(a) RETURNS sign:RANGE -1 TO 1 IS IF a=0 THEN 0 ELSE IF a<0 THEN -1 ELSE 1
PROC FastMod(a, b) IS NATIVE {((} a {) % (} b {))} ENDNATIVE !!VALUE
PROC Mod(a, b) RETURNS c, d
	d := a / b
	c := a - (d * b)
ENDPROC
/*->ldiv() simply does not work on too many compilers
PROC Mod(a, b) RETURNS c, d
	{ldiv_t temp = ldiv(} a {,} b {)}
	c := {temp.rem}!!VALUE
	d := {temp.quot}!!VALUE
ENDPROC*/
PROC Pow(a, b) RETURNS c
	c := 1
	WHILE b > 0
		c := c * a
		b--
	ENDWHILE
ENDPROC
PROC Shl(a, b) IS IF b >= 0 THEN a SHL b ELSE a SHR Abs(b)
PROC Shr(a, b) IS IF b >= 0 THEN a SHR b ELSE a SHL Abs(b)
PROC Bounds(num, min, max) IS IF num<min THEN min ELSE (IF num>max THEN max ELSE num)

PROC BigMax(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE IS IF a > b THEN a ELSE b
PROC BigMin(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE IS IF a < b THEN a ELSE b
PROC BigFastMod(a:BIGVALUE, b) IS NATIVE {((} a {) % (} b {))} ENDNATIVE !!VALUE

PROC Fsin(a:FLOAT) IS NATIVE {sin(} a {)} ENDNATIVE !!FLOAT
PROC Fcos(a:FLOAT) IS NATIVE {cos(} a {)} ENDNATIVE !!FLOAT
PROC Ftan(a:FLOAT) IS NATIVE {tan(} a {)} ENDNATIVE !!FLOAT
PROC Fatan(a:FLOAT) IS NATIVE {atan(} a {)} ENDNATIVE !!FLOAT
PROC Fasin(a:FLOAT) IS NATIVE {asin(} a {)} ENDNATIVE !!FLOAT
PROC Facos(a:FLOAT) IS NATIVE {acos(} a {)} ENDNATIVE !!FLOAT
/*PROC Fsincos(a:FLOAT, b:FLOAT) RETURNS c:FLOAT
	c := Fsin(b)
ENDPROC*/
PROC Fsinh(a:FLOAT) IS NATIVE {sinh(} a {)} ENDNATIVE !!FLOAT
PROC Fcosh(a:FLOAT) IS NATIVE {cosh(} a {)} ENDNATIVE !!FLOAT
PROC Ftanh(a:FLOAT) IS NATIVE {tanh(} a {)} ENDNATIVE !!FLOAT
PROC Fabs(a:FLOAT)   IS NATIVE {fabs(} a {)}  ENDNATIVE !!FLOAT
PROC Ffloor(a:FLOAT) IS NATIVE {floor(} a {)} ENDNATIVE !!FLOAT
PROC Fceil(a:FLOAT)  IS NATIVE {ceil(} a {)}  ENDNATIVE !!FLOAT
PROC Fexp(a:FLOAT)   IS NATIVE {exp(} a {)}   ENDNATIVE !!FLOAT
PROC Flog(a:FLOAT)   IS NATIVE {log(} a {)}   ENDNATIVE !!FLOAT
PROC Flog10(a:FLOAT) IS NATIVE {log10(} a {)} ENDNATIVE !!FLOAT
PROC Fpow(a:FLOAT, b:FLOAT) IS NATIVE {pow(} a {,} b {)} ENDNATIVE !!FLOAT
PROC Fsqrt(a:FLOAT)  IS NATIVE {sqrt(} a {)}  ENDNATIVE !!FLOAT
PROC RealVal(string:ARRAY OF CHAR) RETURNS value:FLOAT, read
	DEF final:PTR TO CHAR
	
	value := NATIVE {strtod(} string {,&} final {)} ENDNATIVE !!FLOAT
	IF final <> string
		read  := (final - string) / SIZEOF CHAR
	ELSE
		value := 0.0
		read  := 0
	ENDIF
ENDPROC

->Does not work in StormC: IS (exception := a) BUT (exceptionInfo := b) BUT {throw new Exception()}
PROC Throw(a:QUAD, b=NILA:ARRAY OF CHAR)
	exception     := a
	exceptionInfo := b
	{throw } eException
ENDPROC
PROC Raise(a:QUAD)
	exception := a
	{throw } eException
ENDPROC
->Does not work in StormC: IS IF exception<>0 THEN {throw eException } ELSE EMPTY
PROC ReThrow() IS NATIVE {if (}exception{!=0) \{throw } eException {;\} else \{EMPTY;\}} ENDNATIVE

PROC PrintException()
	IF (exception <> 0) AND (exception <> -1)
		IF exceptionInfo
			Print('EXCEPTION: "\s"; \s.\n', QuadToStr(exception), exceptionInfo)
		ELSE
			Print('EXCEPTION: "\s".\n'    , QuadToStr(exception))
		ENDIF
	ENDIF
ENDPROC


PROC KickVersion(version) IS version BUT TRUE !!BOOL

->peek
PROC GetBool( ptr:PTR TO BOOL ) IS NATIVE {(*} ptr {)} ENDNATIVE !!BOOL
PROC GetByte( ptr:PTR TO BYTE ) IS NATIVE {(*} ptr {)} ENDNATIVE !!BYTE
PROC GetChar( ptr:PTR TO CHAR ) IS NATIVE {(*} ptr {)} ENDNATIVE !!CHAR
PROC GetInt(  ptr:PTR TO INT  ) IS NATIVE {(*} ptr {)} ENDNATIVE !!INT
PROC GetLong( ptr:PTR TO LONG ) IS NATIVE {(*} ptr {)} ENDNATIVE !!LONG
PROC GetQuad( ptr:PTR TO QUAD ) IS NATIVE {(*} ptr {)} ENDNATIVE !!QUAD
PROC GetFloat(ptr:PTR TO FLOAT) IS NATIVE {(*} ptr {)} ENDNATIVE !!FLOAT
PROC GetPtr(  ptr:PTR TO PTR  ) IS NATIVE {(*} ptr {)} ENDNATIVE !!PTR
PROC GetArray(ptr:PTR TO ARRAY) IS NATIVE {(*} ptr {)} ENDNATIVE !!ARRAY
PROC GetValue(ptr:PTR TO VALUE) IS NATIVE {(*} ptr {)} ENDNATIVE !!VALUE

->poke
PROC PutBool( ptr:PTR TO BOOL , value:BOOL ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutByte( ptr:PTR TO BYTE , value:BYTE ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutChar( ptr:PTR TO CHAR , value:CHAR ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutInt(  ptr:PTR TO INT  , value:INT  ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutLong( ptr:PTR TO LONG , value:LONG ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutQuad( ptr:PTR TO QUAD , value:QUAD ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutFloat(ptr:PTR TO FLOAT, value:FLOAT) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutPtr(  ptr:PTR TO PTR  , value:PTR  ) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutArray(ptr:PTR TO ARRAY, value:ARRAY) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE
PROC PutValue(ptr:PTR TO VALUE, value:VALUE) IS NATIVE {(*} ptr {=} value {)} ENDNATIVE

/* non-native code */

->possible cast functions
->PROC Bool(value)  IS value <> FALSE
->PROC Byte(value)  IS (IF value>=0 THEN (value AND $7F) ELSE -(value AND $7F))!!BYTE
->PROC Char(value)  IS (value AND $FF)!!CHAR
->PROC Int(value)   IS (IF value>=0 THEN (value AND $7FFF) ELSE -(value AND $7FFF))!!INT
->PROC Long(value)  IS value!!LONG
->PROC Quad(value)  IS value!!QUAD
->PROC Float(value) IS value!!FLOAT
->PROC Ptr(value)   IS value!!PTR


OBJECT object
ENDOBJECT

TYPE CLASSTYPE IS VALUE
PROC HaveSameClassTypes(first:CLASSTYPE, second:CLASSTYPE) IS first = second

OBJECT class OF object PRIVATE
	notCalledDestructor:BOOL
ENDOBJECT
PROC end() OF class IS EMPTY
PROC InfoClassType() OF class IS TYPEOF class
PROC IsSameClassTypeAs(type:CLASSTYPE) OF class IS HaveSameClassTypes(type, self.InfoClassType())
PROC IsOfClassType(parent:CLASSTYPE) OF class IS HaveSameClassTypes(parent, TYPEOF class)

OBJECT function OF class
ENDOBJECT
PROC new() OF function IS EMPTY
