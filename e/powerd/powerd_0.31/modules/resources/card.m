MODULE 'exec/interrupts'
#define CARDRESNAME 'card.resource'

/* Structures used by the card.resource       */

OBJECT CardHandle
 CardNode:Node,
 CardRemoved:PTR TO Interrupt,
 CardInserted:PTR TO Interrupt,
 CardStatus:PTR TO Interrupt,
 CardFlags:UBYTE

OBJECT DeviceTData
 DTsize:ULONG,     /* Size in bytes   */
 DTspeed:ULONG,    /* Speed in nanoseconds    */
 DTtype:UBYTE,     /* Type of card      */
 DTflags:UBYTE     /* Other flags     */

OBJECT CardMemoryMap
 CommonMemory:PTR TO UBYTE,
 AttributeMemory:PTR TO UBYTE,
 IOMemory:PTR TO UBYTE,           /* Extended for V39 - These are the size of the memory spaces above */
 CommonMemSize:ULONG,
 AttributeMemSize:ULONG,
 IOMemSize:ULONG

/* CardHandle.cah_CardFlags for OwnCard() function    */
FLAG CARD_RESETREMOVE,
 CARD_IFAVAILABLE,
 CARD_DELAYOWNERSHIP,
 CARD_POSTSTATUS

/* ReleaseCreditCard() function flags       */
FLAG CARD_REMOVEHANDLE

/* ReadStatus() return flags          */
CONST CARD_STATUSB_CCDET=6,
 CARD_STATUSF_CCDET=(1<<CARD_STATUSB_CCDET),
 CARD_STATUSB_BVD1=5,
 CARD_STATUSF_BVD1=(1<<CARD_STATUSB_BVD1),
 CARD_STATUSB_SC=5,
 CARD_STATUSF_SC=(1<<CARD_STATUSB_SC),
 CARD_STATUSB_BVD2=4,
 CARD_STATUSF_BVD2=(1<<CARD_STATUSB_BVD2),
 CARD_STATUSB_DA=4,
 CARD_STATUSF_DA=(1<<CARD_STATUSB_DA),
 CARD_STATUSB_WR=3,
 CARD_STATUSF_WR=(1<<CARD_STATUSB_WR),
 CARD_STATUSB_BSY=2,
 CARD_STATUSF_BSY=(1<<CARD_STATUSB_BSY),
 CARD_STATUSB_IRQ=2,
 CARD_STATUSF_IRQ=(1<<CARD_STATUSB_IRQ),

/* CardProgramVoltage() defines */
 CARD_VOLTAGE_0V=0,  /* Set to default; may be the same as 5V */
 CARD_VOLTAGE_5V=1,
 CARD_VOLTAGE_12V=2,

/* CardMiscControl() defines */
 CARD_ENABLEB_DIGAUDIO=1,
 CARD_ENABLEF_DIGAUDIO=(1<<CARD_ENABLEB_DIGAUDIO),
 CARD_DISABLEB_WP=3,
 CARD_DISABLEF_WP=(1<<CARD_DISABLEB_WP),

/*
 * New CardMiscControl() bits for V39 card.resource.  Use these bits to set,
 * or clear status change interrupts for BVD1/SC, BVD2/DA, and BSY/IRQ.
 * Write-enable/protect change interrupts are always enabled.  The defaults
 * are unchanged (BVD1/SC is enabled, BVD2/DA is disabled, and BSY/IRQ is enabled).
 *
 * IMPORTANT -- Only set these bits for V39 card.resource or greater (check
 * resource base VERSION)
 *
 */
 CARD_INTB_SETCLR=7,
 CARD_INTF_SETCLR=(1<<CARD_INTB_SETCLR),
 CARD_INTB_BVD1=5,
 CARD_INTF_BVD1=(1<<CARD_INTB_BVD1),
 CARD_INTB_SC=5,
 CARD_INTF_SC=(1<<CARD_INTB_SC),
 CARD_INTB_BVD2=4,
 CARD_INTF_BVD2=(1<<CARD_INTB_BVD2),
 CARD_INTB_DA=4,
 CARD_INTF_DA=(1<<CARD_INTB_DA),
 CARD_INTB_BSY=2,
 CARD_INTF_BSY=(1<<CARD_INTB_BSY),
 CARD_INTB_IRQ=2,
 CARD_INTF_IRQ=(1<<CARD_INTB_IRQ),

/* CardInterface() defines */
 CARD_INTERFACE_AMIGA_0=0,
/*
 * Tuple for Amiga execute-in-place software (e.g., games, or other
 * such software which wants to use execute-in-place software stored
 * on a credit-card, such as a ROM card).
 *
 * See documentatin for IfAmigaXIP().
 */
 CISTPL_AMIGAXIP=$91

OBJECT TP_AmigaXIP
 TPL_CODE:UBYTE,
 TPL_LINK:UBYTE,
 TP_XIPLOC[4]:UBYTE,
 TP_XIPFLAGS:UBYTE,
 TP_XIPRESRV:UBYTE

/*
  ; The XIPFLAGB_AUTORUN bit means that you want the machine
  ; to perform a reset if the execute-in-place card is inserted
  ; after DOS has been started.  The machine will then reset,
  ; and execute your execute-in-place code the next time around.
  ;
  ; NOTE -- this flag may be ignored on some machines, in which
  ; case the user will have to manually reset the machine in the
  ; usual way.
*/
FLAG XIPFLAGS_AUTORUN
