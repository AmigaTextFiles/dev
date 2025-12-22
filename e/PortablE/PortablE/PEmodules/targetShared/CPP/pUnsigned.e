/* C++ implementation of pUnsigned */
OPT NATIVE, INLINE

TYPE UBYTE IS NATIVE {unsigned char}  RANGE 0 TO 255
TYPE UINT  IS NATIVE {unsigned short} RANGE 0 TO 65535
TYPE ULONG IS NATIVE {unsigned int}  LONG					->this is a bit of a hack
TYPE UCLONG IS NATIVE {unsigned int}  CLONG				->ditto
TYPE UBIGVALUE IS NATIVE {unsigned long long}  BIGVALUE		->ditto

PROC BigEndianUINT(in:UINT) RETURNS out:UINT IS BigEndianINT(in!!VALUE!!INT) !!VALUE!!UINT
PROC BigEndianULONG(in:ULONG) RETURNS out:ULONG IS BigEndianLONG(in)
PROC BigEndianUBIGVALUE(in:UBIGVALUE) RETURNS out:UBIGVALUE IS BigEndianBIGVALUE(in)

PROC LittleEndianUINT(in:UINT) RETURNS out:UINT IS LittleEndianINT(in!!VALUE!!INT) !!VALUE!!UINT
PROC LittleEndianULONG(in:ULONG) RETURNS out:ULONG IS LittleEndianLONG(in)
PROC LittleEndianUBIGVALUE(in:UBIGVALUE) RETURNS out:UBIGVALUE IS LittleEndianBIGVALUE(in)

PROC SwapEndianUINT(in:UINT) RETURNS out:UINT IS SwapEndianINT(in!!VALUE!!INT) !!VALUE!!UINT
PROC SwapEndianULONG(in:ULONG) RETURNS out:ULONG IS SwapEndianLONG(in)
PROC SwapEndianUBIGVALUE(in:UBIGVALUE) RETURNS out:UBIGVALUE IS SwapEndianBIGVALUE(in)
