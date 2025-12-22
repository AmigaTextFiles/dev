// Include Header to gain access to 'C' version of load_file()

struct FileCache {
	char		*filebuf;		// ptr to cached file
	unsigned int bufsize;		// # of bytes in cache (incl padding)
	char		*filename;		// name of file in this cache
};

IMPORT BOOL load_file( char * fname, struct FileCache * fc);
