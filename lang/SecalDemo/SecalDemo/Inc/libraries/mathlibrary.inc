include "inc/exec/libraries.inc";

struct MathIEEELibBase is
  MathIEEEBase_LibNode:Library;
  MathIEEEBase_reserved[18]:ubyte;
  MathIEEEBase_TaskOpenLib:ulong;
  MathIEEEBase_TaskCloseLib:ulong;
;

