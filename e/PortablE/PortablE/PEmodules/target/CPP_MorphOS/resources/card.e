/* $VER: card.h 1.11 (14.12.1992) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/interrupts'
{#include <resources/card.h>}
NATIVE {RESOURCES_CARD_H} CONST

NATIVE {CARDRESNAME}	CONST
#define CARDRESNAME cardresname
STATIC cardresname	= 'card.resource'

/* Structures used by the card.resource				*/

NATIVE {CardHandle} OBJECT cardhandle
	{cah_CardNode}		cardnode	:ln
	{cah_CardRemoved}	cardremoved	:PTR TO is
	{cah_CardInserted}	cardinserted	:PTR TO is
	{cah_CardStatus}	cardstatus	:PTR TO is
	{cah_CardFlags}		cardflags	:UBYTE
ENDOBJECT

NATIVE {DeviceTData} OBJECT devicetdata
	{dtd_DTsize}	dtsize	:ULONG	/* Size in bytes		*/
	{dtd_DTspeed}	dtspeed	:ULONG	/* Speed in nanoseconds		*/
	{dtd_DTtype}	dttype	:UBYTE	/* Type of card			*/
	{dtd_DTflags}	dtflags	:UBYTE	/* Other flags			*/
ENDOBJECT

NATIVE {CardMemoryMap} OBJECT cardmemorymap
	{cmm_CommonMemory}		commonmemory	:PTR TO UBYTE
	{cmm_AttributeMemory}	attributememory	:PTR TO UBYTE
	{cmm_IOMemory}			iomemory	:PTR TO UBYTE

/* Extended for V39 - These are the size of the memory spaces above */

	{cmm_CommonMemSize}		commonmemsize	:ULONG
	{cmm_AttributeMemSize}	attributememsize	:ULONG
	{cmm_IOMemSize}			iomemsize	:ULONG

ENDOBJECT

/* CardHandle.cah_CardFlags for OwnCard() function		*/

NATIVE {CARDB_RESETREMOVE}	CONST CARDB_RESETREMOVE	= 0
NATIVE {CARDF_RESETREMOVE}	CONST CARDF_RESETREMOVE	= 1

NATIVE {CARDB_IFAVAILABLE}	CONST CARDB_IFAVAILABLE	= 1
NATIVE {CARDF_IFAVAILABLE}	CONST CARDF_IFAVAILABLE	= 2

NATIVE {CARDB_DELAYOWNERSHIP}	CONST CARDB_DELAYOWNERSHIP	= 2
NATIVE {CARDF_DELAYOWNERSHIP}	CONST CARDF_DELAYOWNERSHIP	= 4

NATIVE {CARDB_POSTSTATUS}	CONST CARDB_POSTSTATUS	= 3
NATIVE {CARDF_POSTSTATUS}	CONST CARDF_POSTSTATUS	= 8

/* ReleaseCreditCard() function flags				*/

NATIVE {CARDB_REMOVEHANDLE}	CONST CARDB_REMOVEHANDLE	= 0
NATIVE {CARDF_REMOVEHANDLE}	CONST CARDF_REMOVEHANDLE	= 1

/* ReadStatus() return flags					*/

NATIVE {CARD_STATUSB_CCDET}		CONST CARD_STATUSB_CCDET		= 6
NATIVE {CARD_STATUSF_CCDET}		CONST CARD_STATUSF_CCDET		= 64

NATIVE {CARD_STATUSB_BVD1}		CONST CARD_STATUSB_BVD1		= 5
NATIVE {CARD_STATUSF_BVD1}		CONST CARD_STATUSF_BVD1		= 32

NATIVE {CARD_STATUSB_SC}			CONST CARD_STATUSB_SC			= 5
NATIVE {CARD_STATUSF_SC}			CONST CARD_STATUSF_SC			= 32

NATIVE {CARD_STATUSB_BVD2}		CONST CARD_STATUSB_BVD2		= 4
NATIVE {CARD_STATUSF_BVD2}		CONST CARD_STATUSF_BVD2		= 16

NATIVE {CARD_STATUSB_DA}			CONST CARD_STATUSB_DA			= 4
NATIVE {CARD_STATUSF_DA}			CONST CARD_STATUSF_DA			= 16

NATIVE {CARD_STATUSB_WR}			CONST CARD_STATUSB_WR			= 3
NATIVE {CARD_STATUSF_WR}			CONST CARD_STATUSF_WR			= 8

NATIVE {CARD_STATUSB_BSY}		CONST CARD_STATUSB_BSY		= 2
NATIVE {CARD_STATUSF_BSY}		CONST CARD_STATUSF_BSY		= 4

NATIVE {CARD_STATUSB_IRQ}		CONST CARD_STATUSB_IRQ		= 2
NATIVE {CARD_STATUSF_IRQ}		CONST CARD_STATUSF_IRQ		= 4

/* CardProgramVoltage() defines */

NATIVE {CARD_VOLTAGE_0V}		CONST CARD_VOLTAGE_0V		= 0	/* Set to default; may be the same as 5V */
NATIVE {CARD_VOLTAGE_5V}		CONST CARD_VOLTAGE_5V		= 1
NATIVE {CARD_VOLTAGE_12V}	CONST CARD_VOLTAGE_12V	= 2

/* CardMiscControl() defines */

NATIVE {CARD_ENABLEB_DIGAUDIO}	CONST CARD_ENABLEB_DIGAUDIO	= 1
NATIVE {CARD_ENABLEF_DIGAUDIO}	CONST CARD_ENABLEF_DIGAUDIO	= 2

NATIVE {CARD_DISABLEB_WP}	CONST CARD_DISABLEB_WP	= 3
NATIVE {CARD_DISABLEF_WP}	CONST CARD_DISABLEF_WP	= 8

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

NATIVE {CARD_INTB_SETCLR}	CONST CARD_INTB_SETCLR	= 7
NATIVE {CARD_INTF_SETCLR}	CONST CARD_INTF_SETCLR	= 128

NATIVE {CARD_INTB_BVD1}		CONST CARD_INTB_BVD1		= 5
NATIVE {CARD_INTF_BVD1}		CONST CARD_INTF_BVD1		= 32

NATIVE {CARD_INTB_SC}		CONST CARD_INTB_SC		= 5
NATIVE {CARD_INTF_SC}		CONST CARD_INTF_SC		= 32

NATIVE {CARD_INTB_BVD2}		CONST CARD_INTB_BVD2		= 4
NATIVE {CARD_INTF_BVD2}		CONST CARD_INTF_BVD2		= 16

NATIVE {CARD_INTB_DA}		CONST CARD_INTB_DA		= 4
NATIVE {CARD_INTF_DA}		CONST CARD_INTF_DA		= 16

NATIVE {CARD_INTB_BSY}		CONST CARD_INTB_BSY		= 2
NATIVE {CARD_INTF_BSY}		CONST CARD_INTF_BSY		= 4

NATIVE {CARD_INTB_IRQ}		CONST CARD_INTB_IRQ		= 2
NATIVE {CARD_INTF_IRQ}		CONST CARD_INTF_IRQ		= 4


/* CardInterface() defines */

NATIVE {CARD_INTERFACE_AMIGA_0}	CONST CARD_INTERFACE_AMIGA_0	= 0

/*
 * Tuple for Amiga execute-in-place software (e.g., games, or other
 * such software which wants to use execute-in-place software stored
 * on a credit-card, such as a ROM card).
 *
 * See documentatin for IfAmigaXIP().
 */

NATIVE {CISTPL_AMIGAXIP}	CONST CISTPL_AMIGAXIP	= $91

NATIVE {TP_AmigaXIP} OBJECT amigaxip
	{TPL_CODE}	code	:UBYTE
	{TPL_LINK}	link	:UBYTE
	{TP_XIPLOC}	xiploc[4]	:ARRAY OF UBYTE
	{TP_XIPFLAGS}	xipflags	:UBYTE
	{TP_XIPRESRV}	xipresrv	:UBYTE
	ENDOBJECT
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

NATIVE {XIPFLAGSB_AUTORUN}	CONST XIPFLAGB_AUTORUN	= 0
NATIVE {XIPFLAGSF_AUTORUN}	CONST XIPFLAGF_AUTORUN	= 1
