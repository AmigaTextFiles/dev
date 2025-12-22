/*
 	Includes for linked library bcc.lib.
	bcc.lib supplies functions required by BCC precompiler
*/
#ifndef LIBRARIES_BCC_H
#define LIBRARIES_BCC_H

/* Identical to mui.h macros: set() and get() */
#define BCC_Get(obj,attr,store) GetAttr(attr,obj,(ULONG *)store)
#define BCC_Set(obj,attr,value) SetAttrs(obj,attr,value,TAG_DONE)

/* Attribute get that returns value */
LONG BCC_XGet(Object *obj,ULONG attribute);

/* DoSuperMethod for OM_NEW and pass extra parameters */
ULONG BCC_DoSuperNew(struct IClass *cl,Object *obj,ULONG tag1,...);

/* Useful macros */
#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif
#ifndef End
#define End TAG_DONE)
#endif

#endif
