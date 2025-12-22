include "inc/exec/types.inc";
include "inc/exec/libraries.inc";
include "inc/exec/nodes.inc";

struct GlyphEngine is
  gle_Library:ulong;
  gle_Name:ulong;
;

struct GlyphMap is
  glm_BMModulo:uword;
  glm_BMRows:uword;
  glm_BlackLeft:uword;
  glm_BlackTop:uword;
  glm_BlackWidth:uword;
  glm_BlackHeight:uword;
  glm_XOrigin:long;
  glm_YOrigin:long;
  glm_X0:word;
  glm_Y0:word;
  glm_X1:word;
  glm_Y1:word;
  glm_Width:long;
  glm_BitMap:ulong;
;

struct GlyphWidthEntry is
  gwe_Node:MinNode;
  gwe_Code:uword;
  gwe_Width:long;
;

