#include <dos/dos.h>

class ValidFile {

	struct FileInfoBlock fibs, fibd;

	short CompareDS( struct DateStamp *d1, struct DateStamp *d2 );

public:
	short isValid( char *s, char *d );
};
