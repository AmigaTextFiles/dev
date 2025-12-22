OPT INLINE

PROC isspace(a:CHAR) IS a = " "

PROC isupper(a:CHAR) IS (a >= "A") AND (a <= "Z")

PROC islower(a:CHAR) IS (a >= "a") AND (a <= "z")

PROC isalpha(a:CHAR) IS isupper(a) OR islower(a)

PROC isalnum(a:CHAR) IS isalpha(a) OR isdigit(a)

PROC isxdigit(a:CHAR) IS isdigit(a) OR ((a >= "a") AND (a <= "f")) OR ((a >= "A") AND (a <= "F"))

PROC isdigit(a:CHAR) IS (a >= "0") AND (a <= "9")

PROC iscntrl(a:CHAR)
	DEF i
	i := CharToUnsigned(a)
ENDPROC ((i >= 0) AND (i <= 31)) OR ((i >= 128) AND (i <= 159))


PROC isgraph(a:CHAR) IS isprint(a) AND NOT isspace(a)

PROC ispunct(a:CHAR) IS isgraph(a) AND NOT isalnum(a)

PROC isprint(a:CHAR)
	DEF i
	i := CharToUnsigned(a)
ENDPROC ((i >= 32) AND (i <= 127)) OR ((i >= 160) AND (i <= 255))


PROC toupper(c:CHAR) IS IF islower(c) THEN c + "A" - "a" ELSE c

PROC tolower(c:CHAR) IS IF isupper(c) THEN c + "a" - "A" ELSE c
