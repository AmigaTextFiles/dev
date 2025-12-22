include "inc/dos/dos.inc";

struct DateTime is
  dat_Stamp:DateStamp;
  dat_Format:ubyte;
  dat_Flags:ubyte;
  dat_StrDay:ulong;
  dat_StrDate:ulong;
  dat_StrTime:ulong;
;

def LEN_DATSTRING = 16;

def DTB_SUBST = 0;
def DTF_SUBST = 1;
def DTB_FUTURE = 1;
def DTF_FUTURE = 2;

def FORMAT_DOS = 0;
def FORMAT_INT = 1;
def FORMAT_USA = 2;
def FORMAT_CDN = 3;
def FORMAT_MAX = FORMAT_CDN;

