pattern localePrivate1 is
	push a6;
	a6:=LocaleBase; jsr [a6-30];
	pop a6;
endp;															# LOCALEPRIVATE1

pattern CloseCatalog(_catalog) is
	push a6;
	a0:=_catalog;
	a6:=LocaleBase; jsr [a6-36];
	pop a6;
endp;															# CLOSECATALOG

pattern CloseLocale(_locale) is
	push a6;
	a0:=_locale;
	a6:=LocaleBase; jsr [a6-42];
	pop a6;
endp;															# CLOSELOCALE

pattern ConvToLower(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-48];
	pop a6;
endp;															# CONVTOLOWER

pattern ConvToUpper(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-54];
	pop a6;
endp;															# CONVTOUPPER

pattern FormatDate(_locale,_fmtTemplate,_date,_putCharFunc) is
	push a2\a3\a6;
	safe a0:=_locale; a1:=_fmtTemplate; a2:=_date; a3:=_putCharFunc;;
	a6:=LocaleBase; jsr [a6-60];
	pop a2\a3\a6;
endp;															# FORMATDATE

pattern FormatString(_locale,_fmtTemplate,_dataStream,_putCharFunc) is
	push a2\a3\a6;
	safe a0:=_locale; a1:=_fmtTemplate; a2:=_dataStream; a3:=_putCharFunc;;
	a6:=LocaleBase; jsr [a6-66];
	pop a2\a3\a6;
endp;															# FORMATSTRING

pattern GetCatalogStr(_catalog,_stringNum,_defaultString) is
	push a6;
	safe a0:=_catalog; d0.l:=_stringNum; a1:=_defaultString;;
	a6:=LocaleBase; jsr [a6-72];
	pop a6;
endp;															# GETCATALOGSTR

pattern GetLocaleStr(_locale,_stringNum) is
	push a6;
	safe a0:=_locale; d0.l:=_stringNum;;
	a6:=LocaleBase; jsr [a6-78];
	pop a6;
endp;															# GETLOCALESTR

pattern IsAlNum(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-84];
	pop a6;
endp;															# ISALNUM

pattern IsAlpha(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-90];
	pop a6;
endp;															# ISALPHA

pattern IsCntrl(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-96];
	pop a6;
endp;															# ISCNTRL

pattern IsDigit(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-102];
	pop a6;
endp;															# ISDIGIT

pattern IsGraph(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-108];
	pop a6;
endp;															# ISGRAPH

pattern IsLower(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-114];
	pop a6;
endp;															# ISLOWER

pattern IsPrint(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-120];
	pop a6;
endp;															# ISPRINT

pattern IsPunct(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-126];
	pop a6;
endp;															# ISPUNCT

pattern IsSpace(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-132];
	pop a6;
endp;															# ISSPACE

pattern IsUpper(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-138];
	pop a6;
endp;															# ISUPPER

pattern IsXDigit(_locale,_character) is
	push a6;
	safe a0:=_locale; d0.l:=_character;;
	a6:=LocaleBase; jsr [a6-144];
	pop a6;
endp;															# ISXDIGIT

pattern OpenCatalogA(_locale,_name,_tags) is
	push a2\a6;
	safe a0:=_locale; a1:=_name; a2:=_tags;;
	a6:=LocaleBase; jsr [a6-150];
	pop a2\a6;
endp;															# OPENCATALOGA

pattern OpenLocale(_name) is
	push a6;
	a0:=_name;
	a6:=LocaleBase; jsr [a6-156];
	pop a6;
endp;															# OPENLOCALE

pattern ParseDate(_locale,_date,_fmtTemplate,_getCharFunc) is
	push a2\a3\a6;
	safe a0:=_locale; a1:=_date; a2:=_fmtTemplate; a3:=_getCharFunc;;
	a6:=LocaleBase; jsr [a6-162];
	pop a2\a3\a6;
endp;															# PARSEDATE

pattern localePrivate2 is
	push a6;
	a6:=LocaleBase; jsr [a6-168];
	pop a6;
endp;															# LOCALEPRIVATE2

pattern StrConvert(_locale,_string,_buffer,_bufferSize,_type) is
	push a2\a6;
	safe a0:=_locale; a1:=_string; a2:=_buffer; d0.l:=_bufferSize; d1.l:=_type;;
	a6:=LocaleBase; jsr [a6-174];
	pop a2\a6;
endp;															# STRCONVERT

pattern StrnCmp(_locale,_string1,_string2,_length,_type) is
	push a2\a6;
	safe a0:=_locale; a1:=_string1; a2:=_string2; d0.l:=_length; d1.l:=_type;;
	a6:=LocaleBase; jsr [a6-180];
	pop a2\a6;
endp;															# STRNCMP

pattern localePrivate3 is
	push a6;
	a6:=LocaleBase; jsr [a6-186];
	pop a6;
endp;															# LOCALEPRIVATE3

pattern localePrivate4 is
	push a6;
	a6:=LocaleBase; jsr [a6-192];
	pop a6;
endp;															# LOCALEPRIVATE4

pattern localePrivate5 is
	push a6;
	a6:=LocaleBase; jsr [a6-198];
	pop a6;
endp;															# LOCALEPRIVATE5

pattern localePrivate6 is
	push a6;
	a6:=LocaleBase; jsr [a6-204];
	pop a6;
endp;															# LOCALEPRIVATE6

pattern localePrivate7 is
	push a6;
	a6:=LocaleBase; jsr [a6-210];
	pop a6;
endp;															# LOCALEPRIVATE7

pattern localePrivate8 is
	push a6;
	a6:=LocaleBase; jsr [a6-216];
	pop a6;
endp;															# LOCALEPRIVATE8

