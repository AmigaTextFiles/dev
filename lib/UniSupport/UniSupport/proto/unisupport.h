#ifndef  _PROTO_UNISUPPORT_H
#define  _PROTO_UNISUPPORT_H

/*
**  :ts=4
**
**	$VER: unisupport.h 1.0 (17.07.2008)
**
**	C prototypes. For use with 32 bit integers only.
**
**	Copyright © 200 J.v.d.Loo
**	   All Rights Reserved
*/

#include <exec/types.h>
#include <utility/hooks.h>


#ifndef MapTableSBCES
	#ifndef MT_PAIRS_PER_TABLE
	#define MT_PAIRS_PER_TABLE (95)  /* Each supported table has got 95 entries */
	#endif	/* MT_PAIRS_PER_TABLE */

	struct MapTableSBCES	/* Single Byte Character Encoding Scheme */
	{
		UWORD mt_SbcCode;
		UWORD mt_UniCode;	/* mt = mapping table, Sbc = Single Byte Character */
	};
#endif	/* MapTableSBCES */


#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*--- Functions in release 1.0 ---*/

struct MapTableSBCES * GetMappingTable( ULONG iana_id);
void InitLocalHook( struct Hook *hook, HOOKFUNC callbackfunc, APTR data);
const TEXT * UniLegalUTF8Boundary( const TEXT *src, const TEXT *stop);
ULONG UniAccuUTF8StrLen( const void *src, const ULONG inlength, const ULONG encoding, const struct MapTableSBCES *mt);
BOOL UniConvertToUTF8( void *src, ULONG inlength, ULONG iana_id, ULONG encoding, TEXT **dest, ULONG *outlen, ULONG *cps);
BOOL UniFromUTF8ToSces( const TEXT *src, const ULONG inlength, const ULONG cps, TEXT **dest, ULONG *outlen, ULONG iana_id);


#ifdef __cplusplus
}
#endif	/* __cplusplus */

#endif   /* _PROTO_UNISUPPORT_H */
