include "inc/exec/nodes.inc";
include "inc/exec/lists.inc";

struct KeyMap is
  km_LoKeyMapTypes:ulong;
  km_LoKeyMap:ulong;
  km_LoCapsable:ulong;
  km_LoRepeatable:ulong;
  km_HiKeyMapTypes:ulong;
  km_HiKeyMap:ulong;
  km_HiCapsable:ulong;
  km_HiRepeatable:ulong;
;

struct KeyMapNode is
  kn_Node:Node;
  kn_KeyMap:KeyMap;
;

struct KeyMapResource is
  kr_Node:Node;
  kr_List:List;
;

def KC_NOQUAL = 0;
def KC_VANILLA = 7;
def KCB_SHIFT = 0;
def KCF_SHIFT = $01;
def KCB_ALT = 1;
def KCF_ALT = $02;
def KCB_CONTROL = 2;
def KCF_CONTROL = $04;
def KCB_DOWNUP = 3;
def KCF_DOWNUP = $08;

def KCB_DEAD = 5;
def KCF_DEAD = $20;

def KCB_STRING = 6;
def KCF_STRING = $40;

def KCB_NOP = 7;
def KCF_NOP = $80;

def DPB_MOD = 0;
def DPF_MOD = $01;
def DPB_DEAD = 3;
def DPF_DEAD = $08;

def DP_2DINDEXMASK = $0f;
def DP_2DFACSHIFT = 4;

