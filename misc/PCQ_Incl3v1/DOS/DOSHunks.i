
CONST
{   hunk types }
     HUNK_UNIT      = 999 ;
     HUNK_NAME      = 1000;
     HUNK_CODE      = 1001;
     HUNK_DATA      = 1002;
     HUNK_BSS       = 1003;
     HUNK_RELOC32   = 1004;
     HUNK_RELOC16   = 1005;
     HUNK_RELOC8    = 1006;
     HUNK_EXT       = 1007;
     HUNK_SYMBOL    = 1008;
     HUNK_DEBUG     = 1009;
     HUNK_END       = 1010;
     HUNK_HEADER    = 1011;

     HUNK_OVERLAY   = 1013;
     HUNK_BREAK     = 1014;

     HUNK_DREL32    = 1015;
     HUNK_DREL16    = 1016;
     HUNK_DREL8     = 1017;

     HUNK_LIB       = 1018;
     HUNK_INDEX     = 1019;

{   hunk_ext sub-types }
     EXT_SYMB       = 0  ;     {   symbol table }
     EXT_DEF        = 1  ;     {   relocatable definition }
     EXT_ABS        = 2  ;     {   Absolute definition }
     EXT_RES        = 3  ;     {   no longer supported }
     EXT_REF32      = 129;     {   32 bit reference to symbol }
     EXT_COMMON     = 130;     {   32 bit reference to COMMON block }
     EXT_REF16      = 131;     {   16 bit reference to symbol }
     EXT_REF8       = 132;     {    8 bit reference to symbol }
     EXT_DEXT32     = 133;     {   32 bit data releative reference }
     EXT_DEXT16     = 134;     {   16 bit data releative reference }
     EXT_DEXT8      = 135;     {    8 bit data releative reference }

