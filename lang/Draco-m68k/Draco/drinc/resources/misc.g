/*requirespriorinclusionofexec/libraries.g*/

uint
„MR_SERIALPORT‡=0,
„MR_SERIALBITS‡=1,
„MR_PARALLELPORT…=2,
„MR_PARALLELBITS…=3,

„NUMMRTYPESŠ=4;

type
„Library_t=unknown34,

„MiscResource_t=struct{
ˆLibrary_tmr_Library;
ˆ[NUMMRTYPES]ulongmr_AllocArray;
„};

int
„MR_ALLOCMISCRESOURCEˆ=LIB_BASE,
„MR_FREEMISCRESOURCE‰=LIB_BASE+LIB_VECTSIZE;

*charMISCNAME‚="misc.resource";

extern
„FreeMiscResource(longunitNum)void,
„GetMiscResource(longunitNum;*charname)*char;
