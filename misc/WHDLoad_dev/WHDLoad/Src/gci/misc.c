/****************************************************************************
;  :Module.	misc.c
;  :Author.	Bert Jahn
;  :Address.	Franz-Liszt-Straﬂe 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: misc.c 1.7 2004/06/14 19:20:07 wepl Exp wepl $
;  :History.	28.03.00 extracted from whdloadgci.c
;		06.06.04 htoi added
;  :Copyright.	All Rights Reserved
;  :Language.	C
;  :Translator.	GCC
****************************************************************************/

#include <stdio.h>

#include <exec/types.h>

/***************************************************************************/

/*
 *	return string containing hexadecimal representation of value
 */
STRPTR val2hex(ULONG value) {
	static char s[10];
	sprintf(s,value < 16 ? "%d" : "$%x",value);
	return s;
}

/*
 *	return string containing 64-bit hexadecimal representation of value
 */
STRPTR val2hex64(ULONG value1, ULONG value2) {
	static char s[20];
	if (value1) {
		sprintf(s,"$%lx%08lx",value1,value2);
		return s;
	} else {
		return val2hex(value2);
	}
}

/*
 *	convert ascii into number, supports '$' as hex
 */
int htoi(const char *s) {
	int i=0;
	char c;
	while (*s == ' ' || *s == '\t') s++;
	if (*s == '$') {
		/* hex */
		s++;
		while ((c = *s++)) {
			if (c >= '0' && c <= '9') {
				c -= '0';
			} else if (c >= 'a' && c <= 'f') {
				c -= 'a' - 10;
			} else if (c >= 'A' && c <= 'F') {
				c -= 'A' - 10;
			} else {
				break;
			}
			i = i*16 + c;
		}
	} else {
		/* decimal */
		while (*s >= '0' && *s <= '9') {
			i = i*10 + *s++ - '0';
		}
	}
	return i;
}

