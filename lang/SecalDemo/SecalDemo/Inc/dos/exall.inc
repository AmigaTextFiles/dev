include "inc/exec/types.inc";
include "inc/utility/hooks.inc";

def ED_NAME = 1;
def ED_TYPE = 2;
def ED_SIZE = 3;
def ED_PROTECTION = 4;
def ED_DATE = 5;
def ED_COMMENT = 6;
def ED_OWNER = 7;

struct ExAllData is
  ed_Next:ulong;
  ed_Name:ulong;
  ed_Type:long;
  ed_Size:ulong;
  ed_Prot:ulong;
  ed_Days:ulong;
  ed_Mins:ulong;
  ed_Ticks:ulong;
  ed_Comment:ulong;
  ed_OwnerUID:uword;
  ed_OwnerGID:uword;
;

struct ExAllControl is
  eac_Entries:ulong;
  eac_LastKey:ulong;
  eac_MatchString:ulong;
  eac_MatchFunc:ulong;
;

