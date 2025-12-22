OPT NATIVE

->Based on https://stackoverflow.com/questions/2513505/how-to-get-available-memory-c-g/26639774
MODULE 'target/unistd'	->{#include <unistd.h>}

PROC MemAvail() RETURNS sizeInBytes:BIGVALUE
	NATIVE {
	long pages = sysconf(_SC_PHYS_PAGES);
	long page_size = sysconf(_SC_PAGE_SIZE);
	return pages * page_size;
    } ENDNATIVE
ENDPROC
