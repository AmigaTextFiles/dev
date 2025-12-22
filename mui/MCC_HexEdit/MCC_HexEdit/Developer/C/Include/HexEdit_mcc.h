

/*** Include stuff ***/

#ifndef HEXEDIT_MCC_H
#define HEXEDIT_MCC_H

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

#define REGISTER_NR		31284
#define HE_BASE				(TAG_USER | (REGISTER_NR << 16)) + 0x0100

/*** MUI Defines ***/

#define MUIC_HexEdit	"HexEdit.mcc"
#define MUIC_HexEditP	"HexEdit.mcp"

#define HexEditObject MUI_NewObject(MUIC_HexEdit

/*** Methods ***/
#define HE_METH HE_BASE + 0x0000

#define MUIM_HexEdit_Redraw								HE_METH + 0x0001
#define MUIM_HexEdit_ReadMemoryByte				HE_METH + 0x0002
#define MUIM_HexEdit_WriteMemoryByte			HE_METH + 0x0003
#define MUIM_HexEdit_CreateDisplayAddress	HE_METH + 0x0004
#define MUIM_HexEdit_FilterChar						HE_METH + 0x0005

/*** Method structs ***/

struct MUIP_HexEdit_Redraw								{ ULONG MethodID; };
struct MUIP_HexEdit_ReadMemoryByte				{ ULONG MethodID; UBYTE *value; ULONG address; };
struct MUIP_HexEdit_WriteMemoryByte				{ ULONG MethodID; ULONG value; ULONG address; };
struct MUIP_HexEdit_CreateDisplayAddress	{ ULONG MethodID; UBYTE **cp; ULONG address; };
struct MUIP_HexEdit_FilterChar						{ ULONG MethodID; ULONG value; UBYTE *buffer; };


/*** Attributes ***/

#define HE_ATTS HE_BASE + 0x0040

#define MUIA_HexEdit_ColumnsPerLine	HE_ATTS + 0x0000
#define MUIA_HexEdit_BytesPerColumn	HE_ATTS + 0x0001
#define MUIA_HexEdit_LowBound				HE_ATTS + 0x0002
#define MUIA_HexEdit_HighBound			HE_ATTS + 0x0003
#define MUIA_HexEdit_AddressChars		HE_ATTS + 0x0004
#define MUIA_HexEdit_First					HE_ATTS + 0x0005
#define MUIA_HexEdit_BytesPerLine		HE_ATTS + 0x0006
#define MUIA_HexEdit_ActiveField		HE_ATTS + 0x0007
#define MUIA_HexEdit_VisibleLines		HE_ATTS + 0x0008
#define MUIA_HexEdit_BaseAddressOffset	HE_ATTS + 0x0009
#define MUIA_HexEdit_FullRefresh		HE_ATTS + 0x000a
#define MUIA_HexEdit_FirstLine			HE_ATTS + 0x000b
#define MUIA_HexEdit_SelectMode			HE_ATTS + 0x000c
#define MUIA_HexEdit_MoveCursor			HE_ATTS + 0x000d
#define MUIA_HexEdit_CursorAddress	HE_ATTS + 0x000e
#define MUIA_HexEdit_EditMode				HE_ATTS + 0x000f
#define MUIA_HexEdit_CursorVisible	HE_ATTS + 0x0010
#define MUIA_HexEdit_CursorNibble		HE_ATTS + 0x0011
#define MUIA_HexEdit_ByteValue			HE_ATTS + 0x0012
#define MUIA_HexEdit_NibbleValue		HE_ATTS + 0x0013
#define MUIA_HexEdit_PropObject			HE_ATTS + 0x0014

/*** Special attribute values ***/

#define MUIV_HexEdit_ColumnsPerLine_Auto		-1

#define MUIV_HexEdit_FirstLine_Up				-1
#define MUIV_HexEdit_FirstLine_Down			-2
#define MUIV_HexEdit_FirstLine_PageUp		-3
#define MUIV_HexEdit_FirstLine_PageDown	-4
#define MUIV_HexEdit_FirstLine_Top			-5
#define MUIV_HexEdit_FirstLine_Bottom		-6

#define MUIV_HexEdit_MoveCursor_Up					-1
#define MUIV_HexEdit_MoveCursor_Down				-2
#define MUIV_HexEdit_MoveCursor_Left				-3
#define MUIV_HexEdit_MoveCursor_Right				-4
#define MUIV_HexEdit_MoveCursor_Top					-5
#define MUIV_HexEdit_MoveCursor_Bottom			-6
#define MUIV_HexEdit_MoveCursor_WordLeft		-7
#define MUIV_HexEdit_MoveCursor_WordRight		-8
#define MUIV_HexEdit_MoveCursor_LineStart		-9
#define MUIV_HexEdit_MoveCursor_LineEnd			-10
#define MUIV_HexEdit_MoveCursor_PageUp			-11
#define MUIV_HexEdit_MoveCursor_PageDown		-12

#define MUIV_HexEdit_SelectMode_Nibble		-1
#define MUIV_HexEdit_SelectMode_Byte			-2

#define MUIV_HexEdit_ActiveField_HexDump	-1
#define MUIV_HexEdit_ActiveField_Chars		-2

#endif /* HEXEDIT_MCC_H */
