#ifndef _GAUGE_H
#define _GAUGE_H 1

/*
**	$VER: Gauge.h 1.1 (26.1.97)
**
**	Gauge.h -- An implementation of a progress requester as per the
**	           Amiga User Interface Style Guide.
**
**	Copyright © 1997 by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
**		Freely Distributable
*/

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif	/* UTILITY_TAGITEM_H */

	/* Control tags for the creation of the gauge. */

#define GAUGE_Window		(TAG_USER+1)
#define GAUGE_Screen		(TAG_USER+2)
#define GAUGE_PubScreen		(TAG_USER+3)
#define GAUGE_PubScreenName	(TAG_USER+4)
#define GAUGE_PubScreenFallback	(TAG_USER+5)
#define GAUGE_UserPort		(TAG_USER+6)
#define GAUGE_ButtonLabel	(TAG_USER+7)
#define GAUGE_Title		(TAG_USER+8)
#define GAUGE_Hit		(TAG_USER+9)
#define GAUGE_SigBit		(TAG_USER+10)
#define GAUGE_MsgPort		(TAG_USER+11)
#define GAUGE_Fill		(TAG_USER+0x778)

	/* Prototypes for the gauge code. */

LONG GetGaugeA(struct Gauge *Gauge,struct TagItem *TagList);
VOID SetGaugeA(struct Gauge *Gauge,struct TagItem *TagList);
VOID DisposeGauge(struct Gauge *Gauge);
struct Gauge * NewGaugeA(struct TagItem *TagList);

LONG GetGauge(struct Gauge *Gauge,...);
VOID SetGauge(struct Gauge *Gauge,...);
struct Gauge * NewGauge(Tag tag1,...);

#endif	/* _GAUGE_H */
