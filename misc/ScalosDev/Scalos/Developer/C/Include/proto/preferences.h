#ifndef PROTO_PREFERENCES_H
#define PROTO_PREFERENCES_H

#include <exec/types.h>
extern struct Library *PreferencesBase;

#include <clib/preferences_protos.h>

#ifdef __VBCC__
	#include <inline/preferences_protos.h>
#else
	#include <pragmas/preferences_pragmas.h>
#endif /* __VBCC__ */

#endif /* PROTO_PREFERENCES_H */

