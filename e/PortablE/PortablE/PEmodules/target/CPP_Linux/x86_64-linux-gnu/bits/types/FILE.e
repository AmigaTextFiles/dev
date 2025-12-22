OPT NATIVE
{#include <x86_64-linux-gnu/bits/types/FILE.h>}
->NATIVE {__FILE_defined} CONST ->__FILE_DEFINED = 1

NATIVE {_IO_FILE} OBJECT ->_io_file ; ENDOBJECT
TYPE IO_FILE_ IS NATIVE {_IO_FILE} VALUE

/* The opaque type of streams.  This is the definition used elsewhere.  */
->NATIVE {FILE} CONST
TYPE FILE IS NATIVE {FILE} IO_FILE_
