OPT NATIVE

->Based on https://stackoverflow.com/questions/2513505/how-to-get-available-memory-c-g/26639774
{#include <windows.h>}
PROC MemAvail() RETURNS sizeInBytes:BIGVALUE
	NATIVE {
    MEMORYSTATUSEX status;
    status.dwLength = sizeof(status);
    GlobalMemoryStatusEx(&status);
    return status.ullTotalPhys;
    } ENDNATIVE
ENDPROC
