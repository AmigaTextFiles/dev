#ifndef	EXEC_INITIALIZERS_H
#define	EXEC_INITIALIZERS_H

#define	OFFSET(structName, structEntry) \
				(&((   0).structEntry))
#define	INITBYTE(offset,value)	$e000,(UWORD) (offset),(UWORD) ((value)<<8)
#define	INITWORD(offset,value)	$d000,(UWORD) (offset),(UWORD) (value)
#define	INITLONG(offset,value)	$c000,(UWORD) (offset), \
				(UWORD) ((value)>>16), \
				(UWORD) ((value) & $ffff)
#define	INITSTRUCT(size,offset,value,count) \
				(UWORD) $($c000OR(size<<12)OR(count<<8)OR \
				((UWORD) ((offset)>>16)), \
				((UWORD) (offset)) & $ffff)
#endif 
