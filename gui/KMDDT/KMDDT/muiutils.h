 /* Copyright © 1996 Kai Hofmann. All rights reserved. */

 #define STACKARGS	__stdargs


 #include <exec/types.h>
 #include <libraries/mui.h>

 /* ------------------------------------------------------------------------ */

 #ifndef MAKE_ID
   #define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
 #endif


 #define MUISERIALNR		0 /* Your personal MUI registration number! */
 #define TAGBASE		(TAG_USER | (MUISERIALNR << 16) | 0x8000)

 /* ------------------------------------------------------------------------ */

 ULONG STACKARGS DoSuperNew(struct IClass *cl, Object *obj, ULONG tags, ...);
 BOOL getbool(Object *obj, ULONG attr);
 Object *getobj(Object *obj, ULONG attr);
 Object *getapp(Object *obj);
 STRPTR copystr(Object *obj, ULONG attr);
