
#ifndef _TEK_ARRAY_H
#define _TEK_ARRAY_H 1

/*
**	tek/array.h
**
**	dynamic arrays and strings.
**	this section is considered experimental.
*/

#include <tek/mem.h>


#define	ARRAY_ALIGNMENT	7

typedef	struct
{
	TAPTR mmu;			/* memory manager */
	TUINT len;			/* number of elements currently in use */
	TUINT alloclen;		/* number of elements currently allocated */
	TUINT size;			/* size of a single element [bytes] */
	TUINT valid;		/* validation status */

} TARRAY;



TBEGIN_C_API


extern TAPTR TCreateArray(TAPTR mmu, TUINT size, TUINT len, TTAGITEM *tags)		__ELATE_QCALL__(("qcall lib/tek/array/createarray"));
extern TUINT TArrayGetLen(TAPTR arraydata)										__ELATE_QCALL__(("qcall lib/tek/array/arraygetlen"));
extern TBOOL TArraySetLen(TAPTR *memp, TUINT len)								__ELATE_QCALL__(("qcall lib/tek/array/arraysetlen"));
extern TUINT TArrayValid(TAPTR arraydata)										__ELATE_QCALL__(("qcall lib/tek/array/arrayvalid"));
extern TVOID TDestroyArray(TAPTR array)											__ELATE_QCALL__(("qcall lib/tek/array/destroyarray"));
extern TVOID TDestroyString(TSTRPTR string)										__ELATE_QCALL__(("qcall lib/tek/array/destroystring"));

extern TUINT TStrLen(TSTRPTR s)													__ELATE_QCALL__(("qcall lib/tek/array/strlen"));
extern TVOID TStrCat(TSTRPTR dest, TSTRPTR addstr)								__ELATE_QCALL__(("qcall lib/tek/array/strcat"));
extern TINT TStrCmp(TSTRPTR s1, TSTRPTR s2)										__ELATE_QCALL__(("qcall lib/tek/array/strcmp"));
extern TVOID TStrCopy(TSTRPTR source, TSTRPTR dest)								__ELATE_QCALL__(("qcall lib/tek/array/strcopy"));
extern TSTRPTR TStrDup(TAPTR mmu, TSTRPTR s)									__ELATE_QCALL__(("qcall lib/tek/array/strdup"));

extern TSTRPTR TCreateString(TAPTR mmu, TUINT numchars)							__ELATE_QCALL__(("qcall lib/tek/array/createstring"));
extern TSTRPTR TCreateStringStr(TAPTR mmu, TSTRPTR initial)						__ELATE_QCALL__(("qcall lib/tek/array/createstringstr"));
extern TVOID TDeleteString(TSTRPTR s)											__ELATE_QCALL__(("qcall lib/tek/array/deletestring"));
extern TBOOL TStringValid(TSTRPTR string)										__ELATE_QCALL__(("qcall lib/tek/array/stringvalid"));
extern TUINT TStringLen(TSTRPTR string)											__ELATE_QCALL__(("qcall lib/tek/array/stringlen"));
extern TBOOL TStringSetLen(TSTRPTR *string, TUINT len)							__ELATE_QCALL__(("qcall lib/tek/array/stringsetlen"));
extern TBOOL TStringCat(TSTRPTR *s1, TSTRPTR s2)								__ELATE_QCALL__(("qcall lib/tek/array/stringcat"));
extern TBOOL TStringCatChar(TSTRPTR *s1, TBYTE c)								__ELATE_QCALL__(("qcall lib/tek/array/stringcatchar"));
extern TBOOL TStringCatStr(TSTRPTR *s1, TSTRPTR s2)								__ELATE_QCALL__(("qcall lib/tek/array/stringcatstr"));
extern TBOOL TStringCopy(TSTRPTR *s1, TSTRPTR s2)								__ELATE_QCALL__(("qcall lib/tek/array/stringcopy"));
extern TBOOL TStringCopyStr(TSTRPTR *s1, TSTRPTR s2)							__ELATE_QCALL__(("qcall lib/tek/array/stringcopystr"));
extern TBOOL TStringCopyStrN(TSTRPTR *s1, TSTRPTR s2, TUINT n)					__ELATE_QCALL__(("qcall lib/tek/array/stringcopystrn"));
extern TSTRPTR TStringDup(TSTRPTR s)											__ELATE_QCALL__(("qcall lib/tek/array/stringdup"));
extern TINT TStringFind(TSTRPTR s1, TSTRPTR s2)									__ELATE_QCALL__(("qcall lib/tek/array/stringfind"));

/* 
**	private functions:
*/

extern TINT TStringFindSimple(TSTRPTR string, TSTRPTR search, TINT stringlen, TINT searchlen)	__ELATE_QCALL__(("qcall lib/tek/array/stringfindsimple"));


TEND_C_API


#endif

