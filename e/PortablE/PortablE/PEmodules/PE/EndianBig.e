/* PE/EndianBig.e
   For use on big-endian machines.
*/
OPT INLINE
PUBLIC MODULE 'PE/EndianShared'
MODULE 'target/PE/base'

PROC IsBigEndian()    RETURNS    isBigEndian:BOOL IS TRUE
PROC IsLittleEndian() RETURNS isLittleEndian:BOOL IS FALSE

PROC LittleEndianINT(in:INT) IS SwapEndianINT(in)
PROC LittleEndianLONG(in:LONG) IS SwapEndianLONG(in)
PROC LittleEndianBIGVALUE(in:BIGVALUE) IS SwapEndianBIGVALUE(in)

PROC BigEndianINT(in:INT) IS in
PROC BigEndianLONG(in:LONG) IS in
PROC BigEndianBIGVALUE(in:BIGVALUE) IS in

->depreciated
PROC EndianSwapINT(in:INT) IS in
PROC EndianSwapLONG(in:LONG) IS in
PROC EndianSwapBIGVALUE(in:BIGVALUE) IS in
