{ ClassUsr.i }

{$I   "Include:Exec/Lists.i"}
{$I   "Include:Utility/Hooks.i"}
{$I   "Include:Utility/TagItem.i"}
{$I   "Include:Intuition/cgHooks.i"}

{** User visible handles on objects, classes, messages **}
Type
 Object = Integer;
 ObjectPtr = ^Object;
 ClassID = ^Byte;

{
 you can use this type to point to a "generic" message,
 * in the object-oriented programming parlance.  Based on
 * the value of 'MethodID', you dispatch to processing
 * for the various message types.  The meaningful parameter
 * packet structure definitions are defined below.

typedef struct
    ULONG MethodID;
     method-specific data follows, some examples below
               *Msg; }

{
 * Class id strings for Intuition classes.
 * There's no real reason to use the uppercase constants
 * over the lowercase strings, but this makes a good place
 * to list the names of the built-in classes.
 }
CONST
 ROOTCLASS      = "rootclass"    ;         { classusr.h   }
 IMAGECLASS     = "imageclass"   ;         { imageclass.h }
 FRAMEICLASS    = "frameiclass"  ;
 SYSICLASS      = "sysiclass"    ;
 FILLRECTCLASS  = "fillrectclass";
 GADGETCLASS    = "gadgetclass"  ;         { gadgetclass.h }
 PROPGCLASS     = "propgclass"   ;
 STRGCLASS      = "strgclass"    ;
 BUTTONGCLASS   = "buttongclass" ;
 FRBUTTONCLASS  = "frbuttonclass";
 GROUPGCLASS    = "groupgclass"  ;
 ICCLASS        = "icclass"      ;         { icclass.h    }
 MODELCLASS     = "modelclass"   ;
 ITEXTICLASS    = "itexticlass"  ;
 POINTERCLASS   = "pointerclass" ;         { pointerclass.h }


{ Dispatched method ID's
 * NOTE: Applications should use Intuition entry points, not direct
 * DoMethod() calls, for NewObject, DisposeObject, SetAttrs,
 * SetGadgetAttrs, and GetAttr.
 }

 OM_Dummy       = ($100);
 OM_NEW         = ($101); { 'object' parameter is "true class"   }
 OM_DISPOSE     = ($102); { delete self (no parameters)          }
 OM_SET         = ($103); { set attributes (in tag list)         }
 OM_GET         = ($104); { return single attribute value        }
 OM_ADDTAIL     = ($105); { add self to a List (let root do it)  }
 OM_REMOVE      = ($106); { remove self from list                }
 OM_NOTIFY      = ($107); { send to self: notify dependents      }
 OM_UPDATE      = ($108); { notification message from somebody   }
 OM_ADDMEMBER   = ($109); { used by various classes with lists   }
 OM_REMMEMBER   = ($10A); { used by various classes with lists   }

{ Parameter "Messages" passed to methods       }

{ OM_NEW and OM_SET    }
Type
   opSet = Record
    MethodID            : Integer;
    ops_AttrList        : TagItemPtr;   { new attributes       }
    ops_GInfo           : GadgetInfoPtr; { always there for gadgets,
                                         * when SetGadgetAttrs() is used,
                                         * but will be NULL for OM_NEW
                                         }
   END;
   opSetPtr = ^opSet;

{ OM_NOTIFY, and OM_UPDATE     }
  opUpdate = Record
    MethodID            : Integer;
    opu_AttrList        : TagItemPtr;   { new attributes       }
    opu_GInfo           : GadgetInfoPtr;  { non-NULL when SetGadgetAttrs OR
                                         * notification resulting from gadget
                                         * input occurs.
                                         }
    opu_Flags           : Integer;      { defined below        }
  END;
  opUpdatePtr = ^opUpdate;

{ this flag means that the update message is being issued from
 * something like an active gadget, a la GACT_FOLLOWMOUSE.  When
 * the gadget goes inactive, it will issue a final update
 * message with this bit cleared.  Examples of use are for
 * GACT_FOLLOWMOUSE equivalents for propgadclass, and repeat strobes
 * for buttons.
 }
CONST
 OPUF_INTERIM   = 1;

{ OM_GET       }
Type
  opGet = Record
    MethodID,
    opg_AttrID          : Integer;
    opg_Storage         : Address;   { may be other types, but "int"
                                         * types are all ULONG
                                         }
  END;
  opGetPtr = ^opGet;

{ OM_ADDTAIL   }
  opAddTail = Record
    MethodID  : Integer;
    opat_List : ListPtr;
  END;
  opAddTailPtr = ^opAddTail;

{ OM_ADDMEMBER, OM_REMMEMBER   }
Type
   opMember = Record
    MethodID   : Integer;
    opam_Object : ObjectPtr;
   END;
   opMemberPtr = ^opMember;

