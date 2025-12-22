include "inc/exec/types.inc";

struct TagItem is
  ti_Tag:ulong;
  ti_Data:ulong;
;

def TAG_DONE = (0);
def TAG_END = (0);
def TAG_IGNORE = (1);
def TAG_MORE = (2);
def TAG_SKIP = (3);

def TAG_USER = (1<<31);

def TAGFILTER_AND = 0;
def TAGFILTER_NOT = 1;

def MAP_REMOVE_NOT_FOUND = 0;
def MAP_KEEP_NOT_FOUND = 1;

