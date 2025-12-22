@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/keymap.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT keymapresource
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   list:lh @{fg shine}(or ARRAY OF lh)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=28 */

@{fg shine}(----)@{fg text} OBJECT keymapnode
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   keymap:keymap @{fg shine}(or ARRAY OF keymap)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=46 */

@{fg shine}(----)@{fg text} OBJECT keymap
@{fg shine}(   0)@{fg text}   lokeymaptypes:PTR TO CHAR
@{fg shine}(   4)@{fg text}   lokeymap:PTR TO LONG
@{fg shine}(   8)@{fg text}   locapsable:PTR TO CHAR
@{fg shine}(  12)@{fg text}   lorepeatable:PTR TO CHAR
@{fg shine}(  16)@{fg text}   hikeymaptypes:PTR TO CHAR
@{fg shine}(  20)@{fg text}   hikeymap:PTR TO LONG
@{fg shine}(  24)@{fg text}   hicapsable:PTR TO CHAR
@{fg shine}(  28)@{fg text}   hirepeatable:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

CONST DP_2DINDEXMASK=15,
      KCF_CONTROL=4,
      KCB_CONTROL=2,
      KC_VANILLA=7,
      KCF_ALT=2,
      KCB_ALT=1,
      KCF_STRING=$40,
      KCB_STRING=6,
      DP_2DFACSHIFT=4,
      KCF_SHIFT=1,
      KCB_SHIFT=0,
      DPF_DEAD=8,
      DPB_DEAD=3,
      KCF_DEAD=$20,
      KCB_DEAD=5,
      DPF_MOD=1,
      DPB_MOD=0,
      KC_NOQUAL=0,
      KCF_DOWNUP=8,
      KCB_DOWNUP=3,
      KCF_NOP=$80,
      KCB_NOP=7
@endnode
