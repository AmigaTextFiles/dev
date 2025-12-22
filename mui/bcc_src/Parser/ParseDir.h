#include <stdio.h>
#include <proto/dos.h>

class ParseDir {

 struct AnchorPath ap;
 
 unsigned long stat;
 short first;

public:

	ParseDir( char *temp );
	~ParseDir();


	char *Next( void );
	


};
