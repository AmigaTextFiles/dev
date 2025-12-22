#ifndef INSERTFILE_H
#define INSERTFILE_H

#include <stdio.h>

class InsertFile {

	char *fname;
	
	unsigned long size;
	void *data;

	void Load( void );
	void Free( void );	
	
public:

	InsertFile( char *name ) {
		fname = name;
		data = 0;
	}
	~InsertFile() {
		Free();
	}
	
	short Insert( FILE *fh );

};

#endif
