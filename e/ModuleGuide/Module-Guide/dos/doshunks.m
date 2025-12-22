@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}no
w showing: "dos/doshunks.m"@{fg text}

NOTE: don't use this output in your code, use the module instead.

CONST HUNKF_FAST=$80000000,
      EXT_RELREF32=$88,
      EXT_ABSREF32=$81,
      EXT_REF32=$81,
      EXT_ABSREF8=$8B,
      EXT_RELREF8=$84,
      EXT_REF8=$84,
      HUNK_RELRELOC8=$3EE,
      HUNK_RELOC8=$3EE,
      EXT_SYMB=0,
      HUNK_CODE=$3E9,
      EXT_DEXT16=$86,
      HUNK_DATA=$3EA,
      HUNK_UNIT=$3E7,
      HUNK_LIB=$3FA,
      EXT_COMMONDEF=4,
      HUNK_DREL16=$3F8,
      HUNKF_ADVISORY=$20000000,
      EXT_DEXT32=$85,
      HUNK_INDEX=$3FB,
      HUNK_END=$3F2,
      HUNK_RELOC32SHORT=$3FC,
      HUNK_BSS=$3EB,
      HUNK_DREL32=$3F7,
      HUNK_EXT=$3EF,
      EXT_DEXT8=$87,
      HUNKF_CHIP=$40000000,
      HUNK_HEADER=$3F3,
      HUNK_DREL8=$3F9,
      EXT_DEF=1,
      EXT_RES=3,
      HUNK_BREAK=$3F6,
      EXT_ABS=2,
      HUNK_ABSRELOC16=$3FE,
      HUNK_RELRELOC16=$3ED,
      HUNK_RELOC16=$3ED,
      EXT_RELCOMMON=$89,
      EXT_ABSCOMMON=$82,
      EXT_COMMON=$82,
      HUNK_DEBUG=$3F1,
      EXT_ABSREF16=$8A,
      EXT_RELREF16=$83,
      EXT_REF16=$83,
      HUNK_OVERLAY=$3F5,
      HUNK_SYMBOL=$3F0,
      HUNK_RELRELOC32=$3FD,
      HUNK_ABSRELOC32=$3EC,
      HUNK_RELOC32=$3EC,
      HUNK_NAME=$3E8
@endnode
