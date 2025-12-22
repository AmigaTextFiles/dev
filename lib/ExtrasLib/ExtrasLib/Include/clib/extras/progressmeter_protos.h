#ifndef CLIB_EXTRAS_PROGRESSMETER_PROTOS_H
#define CLIB_EXTRAS_PROGRESSMETER_PROTOS_H

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef EXTRAS_PROGRESSMETER_H
#include <extras/progressmeter.h>
#endif

ProgressMeter AllocProgressMeter(Tag FirstTag, ... );
ProgressMeter AllocProgressMeterA(struct TagItem *TagList);

void   FreeProgressMeter(ProgressMeter PM);

LONG   UpdateProgressMeter(ProgressMeter PM, Tag FirstTag, ... );
LONG   UpdateProgressMeterA(ProgressMeter PM, struct TagItem *TagList);

#endif /* CLIB_EXTRAS_PROGRESSMETER_PROTOS_H */
