with System;
with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with exec_Nodes; use exec_Nodes;

with Incomplete_Type; use Incomplete_Type; 

package graphics_GfxNodes is

type ExtendedNode;
type ExtendedNodePtr is access ExtendedNode;

type ExtendedNode is record
   xln_Succ : Node_Ptr;
   xln_Pred : Node_Ptr;
   xln_Type : Unsigned_8;
   xln_Pri : Integer_8;
   xln_Name : Chars_Ptr;
   xln_Subsystem : Unsigned_8;
   xln_Subtype : Unsigned_8;
   xln_Library : Integer;
   xln_Init : System.Address;
end record;

SS_GRAPHICS : constant Integer := 16#02#;
VIEW_EXTRA_TYPE : constant Integer := 1;
VIEWPORT_EXTRA_TYPE : constant Integer := 2;
SPECIAL_MONITOR_TYPE : constant Integer := 3;
MONITOR_SPEC_TYPE : constant Integer := 4;

end graphics_GfxNodes;