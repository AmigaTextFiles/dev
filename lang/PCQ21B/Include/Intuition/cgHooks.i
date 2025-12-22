{ cghooks.i }

{$I   "Include:Exec/Types.i"}

{
 * Package of information passed to custom and 'boopsi'
 * gadget "hook" functions.  This structure is READ ONLY.
 }
Type
   gi_Pens_Struct = Record
    DetailPen, BlockPen : Byte;
   END;

   GadgetInfo = Record
    gi_Screen                   : Address;       { ScreenPtr }
    gi_Window                   : Address;       { null for screen gadgets }    { WindowPtr }
    gi_Requester                : Address;       { null IF not GTYP_REQGADGET } { RequesterPtr }

    { rendering information:
     * don't use these without cloning/locking.
     * Official way is to call ObtainRPort()
     }
    gi_RastPort                 : Address;       { RastPortPtr }
    gi_Layer                    : Address;       { LayerPtr }

    { copy of dimensions of screen/window/g00/req(/group)
     * that gadget resides in.  Left/Top of this box is
     * offset from window mouse coordinates to gadget coordinates
     *          screen gadgets:                 0,0 (from screen coords)
     *  window gadgets (no g00):        0,0
     *  GTYP_GZZGADGETs (borderlayer):          0,0
     *  GZZ innerlayer gadget:          borderleft, bordertop
     *  Requester gadgets:              reqleft, reqtop
     }
    gi_Domain                   : Address;   { IBoxPtr }

    gi_Pens                     : gi_Pens_Struct;

    { the Detail and Block pens in gi_DrInfo->dri_Pens[] are
     * for the screen.  Use the above for window-sensitive
     * colors.
     }
    gi_DrInfo                   : Address;  { DrawInfoPtr }

    { reserved space: this structure is extensible
     * anyway, but using these saves some recompilation
     }
    gi_Reserved                 : Array[0..5] of Integer;
   END;
   GadgetInfoPtr = ^GadgetInfo;

{** system private data structure for now **}
{ prop gadget extra info       }
   PGX = Record
    pgx_Container : Address;     { IBoxPtr }
    pgx_NewKnob   : Address;     { IBoxPtr }
   END;

{ this casts MutualExclude for easy assignment of a hook
 * pointer to the unused MutualExclude field of a custom gadget
 }

                     { g : GadgetPtr }
FUNCTION CUSTOM_HOOK(g : Address) : HookPtr;
 External;
