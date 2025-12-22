{ GFXNodes.i }

{$I   "Include:Exec/Nodes.i"}

Type
 ExtendedNode = Record
  xln_Succ,
  xln_Pred  : NodePtr;
  xln_Type  : Byte;
  xln_Pri   : Byte;
  xln_Name  : String;
  xln_Subsystem : Byte;
  xln_Subtype   : Byte;
  xln_Library : Address;
  xln_Init : Address;
 END;
 ExtendedNodePtr = ^ExtendedNode;

CONST
 SS_GRAPHICS   =  $02;

 VIEW_EXTRA_TYPE       =  1;
 VIEWPORT_EXTRA_TYPE   =  2;
 SPECIAL_MONITOR_TYPE  =  3;
 MONITOR_SPEC_TYPE     =  4;

PROCEDURE GfxAssociate(Pointer : Address; ENode : ExtendedNodePtr);
    External;

PROCEDURE GfxFree(ENode : ExtendedNodePtr);
    External;

FUNCTION GfxLookUp(Pointer : Address) : ExtendedNodePtr;
    External;

FUNCTION GfxNew(Node_Type : Integer) : ExtendedNodePtr;
    External;


