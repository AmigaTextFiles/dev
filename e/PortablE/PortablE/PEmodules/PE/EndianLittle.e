/* PE/EndianLittle.e 27-04-10
   For use on little-endian machines.
*/
OPT INLINE
PUBLIC MODULE 'PE/EndianShared'
MODULE 'target/PE/base'

PROC IsBigEndian()    RETURNS    isBigEndian:BOOL IS FALSE
PROC IsLittleEndian() RETURNS isLittleEndian:BOOL IS TRUE

PROC LittleEndianINT(in:INT) IS in
PROC LittleEndianLONG(in:LONG) IS in
PROC LittleEndianBIGVALUE(in:BIGVALUE) IS in

PROC BigEndianINT(in:INT) IS SwapEndianINT(in)
PROC BigEndianLONG(in:LONG) IS SwapEndianLONG(in)
PROC BigEndianBIGVALUE(in:BIGVALUE) IS SwapEndianBIGVALUE(in)

->depreciated
PROC EndianSwapINT(in:INT) IS SwapEndianINT(in)
PROC EndianSwapLONG(in:LONG) IS SwapEndianLONG(in)
PROC EndianSwapBIGVALUE(in:BIGVALUE) IS SwapEndianBIGVALUE(in)
