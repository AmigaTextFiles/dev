include "inc/exec/nodes.inc";

struct LocalVar is
  lv_Node:Node;
  lv_Flags:uword;
  lv_Value:ulong;
  lv_Len:ulong;
;

def LV_VAR = 0;
def LV_ALIAS = 1;

def LVB_IGNORE = 7;
def LVF_IGNORE = $80;

def GVB_GLOBAL_ONLY = 8;
def GVF_GLOBAL_ONLY = $100;
def GVB_LOCAL_ONLY = 9;
def GVF_LOCAL_ONLY = $200;
def GVB_BINARY_VAR = 10;
def GVF_BINARY_VAR = $400;
def GVB_DONT_NULL_TERM = 11;
def GVF_DONT_NULL_TERM = $800;

def GVB_SAVE_VAR = 12;
def GVF_SAVE_VAR = $1000;

