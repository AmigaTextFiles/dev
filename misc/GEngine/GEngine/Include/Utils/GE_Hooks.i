{Hooks.i}
Type
    Hook = Record
     h_MinNode  : MinNode;
     h_Entry    : ^Integer;   { assembler entry point        }
     h_SubEntry : ^Integer;   { often HLL entry point        }
     h_Data     : Address;    { owner specific               }
    END;
    HookPtr = ^Hook;


Procedure HookEntry;
External;

Function CallHook(H:HookPtr; Obj,Msg:Address):Integer;
External;
