long
ÑLIB_VECTSIZEÅ=Å6,
ÑLIB_RESERVEDÅ=Å4,
ÑLIB_BASEÖ=Å-LIB_VECTSIZE,
ÑLIB_USERDEFÇ=ÅLIB_BASEÅ-ÅLIB_RESERVEDÅ*ÅLIB_VECTSIZE,
ÑLIB_NONSTDÉ=ÅLIB_USERDEF,

ÑLIB_OPENÖ=Å-6,
ÑLIB_CLOSEÑ=Å-12,
ÑLIB_EXPUNGEÇ=Å-18,
ÑLIB_EXTFUNCÇ=Å-24;

type
ÑNode_tÅ=ÅunknownÅ14,

ÑLibrary_tÅ=ÅstructÅ{
àNode_tÅlib_Node;
àushortÅlib_Flags;
àushortÅlib_pad;
àuintÅlib_NegSize;
àuintÅlib_PosSize;
àuintÅlib_Version;
àuintÅlib_Revision;
à*charÅlib_IdString;
àulongÅlib_Sum;
àuintÅlib_OpenCnt;
Ñ};

ushort
ÑLIBF_SUMMINGÅ=Å1Å<<Å0,
ÑLIBF_CHANGEDÅ=Å1Å<<Å1,
ÑLIBF_SUMUSEDÅ=Å1Å<<Å2,
ÑLIBF_DELEXPÇ=Å1Å<<Å3;

extern
ÑAddLibrary(*Library_tÅlib)void,
ÑCloseLibrary(*Library_tÅlib)void,
ÑMakeFunctions(*byteÅtarget;Å**byteÅfunctionArray;Å*byteÅfuncDispBase)ulong,
ÑMakeLibrary(**byteÅvectors;Å*byteÅstructure,Åinit;ÅulongÅdataSize;
ê*SegList_tÅsegList)*Library_t,
ÑOldOpenLibrary(*charÅname)*Library_t,
ÑOpenLibrary(*charÅname;ÅulongÅversion)*Library_t,
ÑRemLibrary(*Library_tÅlib)uint,
ÑSetFunction(*Library_tÅlib;ÅulongÅfuncOffset;Å*byteÅfuncEntry)*byte,
ÑSumLibrary(*Library_tÅlib)void;
