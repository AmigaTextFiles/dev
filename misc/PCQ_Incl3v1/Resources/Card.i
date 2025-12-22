   {   card.resource include file }

{$I "Include:Exec/Nodes.i"}
{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Resident.i"}

const
 CARDRESNAME   =  "card.resource";

{ Structures used by the card.resource                         }

Type
 CardHandle = Record
        cah_CardNode        : Node;
        cah_CardRemoved,
        cah_CardInserted,
        cah_CardStatus      : InterruptPtr;
        cah_CardFlags       : Byte;
 end;
 CardHandlePtr = ^CardHandle;

 DeviceTData = Record
        dtd_DTsize,                 { Size in bytes                }
        dtd_DTspeed     : Integer;  { Speed in nanoseconds         }
        dtd_DTtype,                 { Type of card                 }
        dtd_DTflags     : Byte;     { Other flags                  }
 end;
 DeviceTDataPtr = ^DeviceTDataPtr;

 CardMemoryMap = Record
        cmm_CommonMemory,
        cmm_AttributeMemory,
        cmm_IOMemory        : Address;

{ Extended for V39 - These are the size of the memory spaces above }

        cmm_CommonMemSize,
        cmm_AttributeMemSize,
        cmm_IOMemSize       : Integer;

 end;
 CardMemoryMapPtr = ^CardMemoryMapPtr;

const
{ CardHandle.cah_CardFlags for OwnCard() function              }

 CARDB_RESETREMOVE      = 0;
 CARDF_RESETREMOVE      = 1;

 CARDB_IFAVAILABLE      = 1;
 CARDF_IFAVAILABLE      = 2;

 CARDB_DELAYOWNERSHIP   = 2;
 CARDF_DELAYOWNERSHIP   = 4;

 CARDB_POSTSTATUS       = 3;
 CARDF_POSTSTATUS       = 8;

{ ReleaseCreditCard() function flags                           }

 CARDB_REMOVEHANDLE     = 0;
 CARDF_REMOVEHANDLE     = 1;

{ ReadStatus() return flags                                    }

 CARD_STATUSB_CCDET             = 6;
 CARD_STATUSF_CCDET             = 64;

 CARD_STATUSB_BVD1              = 5;
 CARD_STATUSF_BVD1              = 32;

 CARD_STATUSB_SC                = 5;
 CARD_STATUSF_SC                = 32;

 CARD_STATUSB_BVD2              = 4;
 CARD_STATUSF_BVD2              = 16;

 CARD_STATUSB_DA                = 4;
 CARD_STATUSF_DA                = 16;

 CARD_STATUSB_WR                = 3;
 CARD_STATUSF_WR                = 8;

 CARD_STATUSB_BSY               = 2;
 CARD_STATUSF_BSY               = 4;

 CARD_STATUSB_IRQ               = 2;
 CARD_STATUSF_IRQ               = 4;

{ CardProgramVoltage() defines }

 CARD_VOLTAGE_0V        = 0;       { Set to default; may be the same as 5V }
 CARD_VOLTAGE_5V        = 1;
 CARD_VOLTAGE_12V       = 2;

{ CardMiscControl() defines }

 CARD_ENABLEB_DIGAUDIO  = 1;
 CARD_ENABLEF_DIGAUDIO  = 2;

 CARD_DISABLEB_WP       = 3;
 CARD_DISABLEF_WP       = 8;

{
 * New CardMiscControl() bits for V39 card.resource.  Use these bits to set,
 * or clear status change interrupts for BVD1/SC, BVD2/DA, and BSY/IRQ.
 * Write-enable/protect change interrupts are always enabled.  The defaults
 * are unchanged (BVD1/SC is enabled, BVD2/DA is disabled, and BSY/IRQ is enabled).
 *
 * IMPORTANT -- Only set these bits for V39 card.resource or greater (check
 * resource base VERSION)
 *
 }

 CARD_INTB_SETCLR       = 7;
 CARD_INTF_SETCLR       = 128;

 CARD_INTB_BVD1         = 5;
 CARD_INTF_BVD1         = 32;

 CARD_INTB_SC           = 5;
 CARD_INTF_SC           = 32;

 CARD_INTB_BVD2         = 4;
 CARD_INTF_BVD2         = 16;

 CARD_INTB_DA           = 4;
 CARD_INTF_DA           = 16;

 CARD_INTB_BSY          = 2;
 CARD_INTF_BSY          = 4;

 CARD_INTB_IRQ          = 2;
 CARD_INTF_IRQ          = 4;


{ CardInterface() defines }

 CARD_INTERFACE_AMIGA_0  = 0;

{
 * Tuple for Amiga execute-in-place software (e.g., games, or other
 * such software which wants to use execute-in-place software stored
 * on a credit-card, such as a ROM card).
 *
 * See documentatin for IfAmigaXIP().
 }

 CISTPL_AMIGAXIP = $91;

Type
 TP_AmigaXIP = Record
        TPL_CODE,
        TPL_LINK        : Byte;
        TP_XIPLOC       : Array[0..3] of Byte;
        TP_XIPFLAGS,
        TP_XIPRESRV     : Byte;
 end;
{

        ; The XIPFLAGB_AUTORUN bit means that you want the machine
        ; to perform a reset if the execute-in-place card is inserted
        ; after DOS has been started.  The machine will then reset,
        ; and execute your execute-in-place code the next time around.
        ;
        ; NOTE -- this flag may be ignored on some machines, in which
        ; case the user will have to manually reset the machine in the
        ; usual way.

}

const
 XIPFLAGSB_AUTORUN      = 0;
 XIPFLAGSF_AUTORUN      = 1;

FUNCTION OwnCard(h : CardHandlePtr) : CardHandlePtr;
    External;

PROCEDURE ReleaseCard(h : CardHandlePtr; Flags : Integer);
    External;

FUNCTION GetCardMap : CardMemoryMapPtr;
    External;

FUNCTION BeginCardAccess(h : CardHandlePtr) : Boolean;
    External;

FUNCTION EndCardAccess(h : CardHandlePtr) : Boolean;
    External;

FUNCTION ReadCardStatus : Byte;
    External;

FUNCTION CardResetRemove(h : CardHandlePtr; flag : Integer) : Boolean;
    External;

FUNCTION CardMiscControl(h : CardHandlePtr; control_bits : Integer) : Byte;
    External;

FUNCTION CardAccessSpeed(h : CardHandlePtr; nanoseconds : Integer) : Integer;
    External;

FUNCTION CardProgramVoltage(h : CardHandlePtr; voltage : Integer) : Integer;
    External;

FUNCTION CardResetCard(h : CardHandlePtr) : Boolean;
    External;

FUNCTION CopyTuple(h : CardHandlePtr; Buffer : Address;
                   TupleCode, size : Integer) : Boolean;
    External;

FUNCTION DeviceTumple(Tumple_Data : Address; Storage : DeviceTDataPtr) : Integer;
    External;

FUNCTION IfAmigaXIP(h : CardHandlePtr) : ResidentPtr;
    External;

FUNCTION CardForceChange : Boolean;
    External;

FUNCTION CardChangeCount : Integer;
    External;

FUNCTION CardInterface : Integer;
    External;



