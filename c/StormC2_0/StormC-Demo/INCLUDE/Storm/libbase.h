#ifndef _INCLUDE_LIBBASE_H
#define _INCLUDE_LIBBASE_H

/*
**  $VER: libbase.h 1.0 (7.1.96)
**  StormC Release 1.0
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef __cplusplus
#error <libbase.h> must be compiled in C++ mode.
#pragma +
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

class LibBaseC {
public:
	LibBaseC(STRPTR name, ULONG version, BOOL exitOnFail = TRUE);
	~LibBaseC();
	BOOL isOpen() const { return Base != NULL; };
	static BOOL areAllOpen() const { return !not_open; };
	operator struct Library *() const { return Base; };
	UWORD version() const;
private:
	LibBaseC(const LibBaseC &);
	LibBaseC &operator= (const LibBaseC &);
	struct Library *Base;
	static BOOL not_open;
};

#endif
