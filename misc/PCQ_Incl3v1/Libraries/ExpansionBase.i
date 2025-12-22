{
        ExpansionBase.i for PCQ Pascal
}

{$I   "Include:Exec/Libraries.i"}
{$I   "Include:Exec/Interrupts.i"}
{$I   "Include:Exec/Semaphores.i"}
{$I   "Include:Libraries/ConfigVars.i"}

Const

    TOTALSLOTS  = 256;

Type

{ BootNodes are scanned by dos.library at startup.  Items found on the
   list are started by dos. BootNodes are added with the AddDosNode() or
   the V36 AddBootNode() calls. }

   BootNode = Record
    bn_Node     : Node;
    bn_Flags    : Short;
    bn_DeviceNode  : Address;
   END;
   BootNodePtr = ^BootNode;

    ExpansionBaseRec = record
        LibNode         : Library;
        Flags           : Byte;
        pad             : Byte;
        ExecBase        : Address;
        SegList         : Address;
        eb_CurrentBinding       : CurrentBinding;
        BoardList       : List;
        MountList       : List;
        { private }
    end;
    ExpansionBasePtr = ^ExpansionBaseRec;

CONST
{ error codes }
     EE_OK          = 0 ;
     EE_LASTBOARD   = 40;  { could not shut him up }
     EE_NOEXPANSION = 41;  { not enough expansion mem; board shut up }
     EE_NOMEMORY    = 42;  { not enough normal memory }
     EE_NOBOARD     = 43;  { no board at that address }
     EE_BADMEM      = 44;  { tried to add bad memory card }

{ Flags }
     EBB_CLOGGED    = 0;       { someone could not be shutup }
     EBF_CLOGGED    = 1;
     EBB_SHORTMEM   = 1;       { ran out of expansion mem }
     EBF_SHORTMEM   = 2;
     EBB_BADMEM     = 2;       { tried to add bad memory card }
     EBF_BADMEM     = 4;
     EBB_DOSFLAG    = 3;       { reserved for use by AmigaDOS }
     EBF_DOSFLAG    = 8;
     EBB_KICKBACK33 = 4;       { reserved for use by AmigaDOS }
     EBF_KICKBACK33 = 16;
     EBB_KICKBACK36 = 5;       { reserved for use by AmigaDOS }
     EBF_KICKBACK36 = 32;
{ If the following flag is set by a floppy's bootblock code, the initial
   open of the initial shell window will be delayed until the first output
   to that shell.  Otherwise the 1.3 compatible behavior applies. }
     EBB_SILENTSTART = 6;
     EBF_SILENTSTART = 64;

{ Magic kludge for CC0 use }
    EBB_START_CC0    = 7;
    EBF_START_CC0    = 128;




