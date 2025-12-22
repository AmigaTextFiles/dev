#ifndef _INCLUDE_FILEDEFS_H
#define _INCLUDE_FILEDEFS_H

/*
**  $VER: filedefs.h 1.0 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

struct filehandle { 
	struct filehandle *next;
	struct filehandle *pred;
	unsigned int handle;
	int ungetC;
	unsigned int mode;
	unsigned int flags;
	int error;
	void *buffer;
	unsigned int size;
	unsigned int fill;
	unsigned int pos;
	unsigned int bufmode;
	int (*read)(struct filehandle *, void *, unsigned int, unsigned int);
	int (*write)(struct filehandle *, void *, unsigned int);
	int (*eof)(struct filehandle *);
	int (*seek)(struct filehandle *, int, int);
	int (*getch)(struct filehandle *);
	int (*ungetch)(struct filehandle *, int); 
	int (*putch)(struct filehandle *, int);
	int (*flush)(struct filehandle *);
	int (*close)(struct filehandle *);
};

#endif
