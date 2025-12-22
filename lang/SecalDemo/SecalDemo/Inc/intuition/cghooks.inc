include "inc/exec/types.inc";
include "inc/intuition/intuition.inc";

struct GadgetInfo is
  gi_Screen:ulong;
  gi_Window:ulong;
  gi_Requester:ulong;
  gi_RastPort:ulong;
  gi_Layer:ulong;
  gi_Domain:IBox;
  gi_Pens:struct is
    DetailPen:ubyte;
    BlockPen:ubyte;
  ;
  gi_DrInfo:ulong;
  gi_Reserved[6]:ulong;
;

struct PGX is
  pgx_Container:IBox;
  pgx_NewKnob:IBox;
;

