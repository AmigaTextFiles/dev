#ifndef PROTO_EXIF_H
#define PROTO_EXIF_H

/****************************************************************************/

#ifndef __NOLIBBASE__
 extern struct Library * ExifBase;
#endif /* __NOLIBBASE__ */

/****************************************************************************/

#include <interfaces/exif.h>

#ifdef __USE_INLINE__
	#include <inline4/exif.h>
#endif /* __USE_INLINE__ */
#ifndef __NOGLOBALIFACE__
	extern struct ExifIFace *IExif;
#endif /* __NOGLOBALIFACE__ */

/****************************************************************************/

#endif /* PROTO_EXIF_H */
