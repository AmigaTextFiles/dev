#include <stdio.h>

class InsertFile {

	char fname;
	
	unsigned long size;
	void *data;

	void Load( void );
	void Free( void );	
	
public:

	InserFile( char name ): fname = name, data = 0 { }
	~InsertFile() {
		Free();
	}
	
	short Insert( FILE *fh );

};