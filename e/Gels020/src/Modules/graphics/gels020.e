OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'graphics/gels'

OBJECT ac020
  pad:INT
  compflags:INT
  timer:INT
  timeset:INT
  nextcomp:PTR TO ac
  prevcomp:PTR TO ac
  nextseq:PTR TO ac
  prevseq:PTR TO ac
  animcroutine:LONG
  ytrans:INT
  xtrans:INT
  headob:PTR TO ao
  animbob:PTR TO bob
ENDOBJECT     /* SIZEOF=40 */

#define GET_AC(x) {x.compflags}
