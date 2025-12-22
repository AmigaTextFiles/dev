
#define FILEDATE_SIZE 8

class FileDate {

public:

	char data[12];

	void Set( char *f );
	short Compare( FileDate &fd );

};
