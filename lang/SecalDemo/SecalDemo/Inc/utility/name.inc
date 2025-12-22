include "inc/exec/types.inc";

struct NamedObject is
  no_Object:ulong;
;

def ANO_NameSpace = 4000;
def ANO_UserSpace = 4001;
def ANO_Priority = 4002;
def ANO_Flags = 4003;

def NSB_NODUPS = 0;
def NSB_CASE = 1;

def NSF_NODUPS = (1<<NSB_NODUPS);
def NSF_CASE = (1<<NSB_CASE);

