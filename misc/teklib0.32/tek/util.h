
#ifndef _TEK_UTIL_H_
#define _TEK_UTIL_H_ 1

/*
**	tek/util.h
*/

#include <tek/type.h>


typedef TAPTR TTAG;

typedef struct
{
	TTAG tag;
	TTAG value;

} TTAGITEM;


#define TTAG_USER		0x80000000
#define TTAG_MORE		0x00000001
#define TTAG_DONE		0x00000000

/* 
**	tag support macros.
**	suboptimal, but may save a few keystrokes.
*/

#define TInitTags(t)			(t)->tag=TTAG_DONE;
#define TAddTag(t,x,y)			{TTAGITEM*tp=t;while(tp->tag)tp++;tp->tag=(TTAG)x;tp->value=(TTAG)y;(tp+1)->tag=TTAG_DONE;}


TBEGIN_C_API

extern TTAG TGetTagValue(TTAG tag, TTAG defaultvalue, TTAGITEM *taglist)									__ELATE_QCALL__(("qcall lib/tek/util/gettagvalue"));
extern TUINT TGetTagArray(TTAGITEM *taglist, TTAG *tagarray)												__ELATE_QCALL__(("qcall lib/tek/util/gettagarray"));
extern TINT TGetRandom(TINT seed)																			__ELATE_QCALL__(("qcall lib/tek/util/getrandom"));

TEND_C_API


#endif
