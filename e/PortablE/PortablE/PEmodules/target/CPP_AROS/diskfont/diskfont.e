/* $Id: diskfont.h 21762 2004-06-17 19:25:36Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/graphics/text', 'target/dos/bptr'
MODULE 'target/exec/types', 'target/dos/dos'
{#include <diskfont/diskfont.h>}
NATIVE {DISKFONT_DISKFONT_H} CONST

NATIVE {MAXFONTPATH}	CONST MAXFONTPATH	= 256

NATIVE {FontContents} OBJECT fc
	{fc_FileName}	filename[MAXFONTPATH]	:ARRAY OF CHAR
	{fc_YSize}	ysize	:UINT
	{fc_Style}	style	:UBYTE
	{fc_Flags}	flags	:UBYTE
ENDOBJECT

NATIVE {TFontContents} OBJECT tfc
	{tfc_FileName}	filename[MAXFONTPATH - 2]	:ARRAY OF CHAR
	{tfc_TagCount}	tagcount	:UINT
	{tfc_YSize}	ysize	:UINT
	{tfc_Style}	style	:UBYTE
	{tfc_Flags}	flags	:UBYTE
ENDOBJECT

NATIVE {FCH_ID}	CONST FCH_ID	= $0f00
NATIVE {TFCH_ID}	CONST TFCH_ID	= $0f02
NATIVE {OFCH_ID}	CONST OFCH_ID	= $0f03

NATIVE {FontContentsHeader} OBJECT fch
	{fch_FileID}	fileid	:UINT
	{fch_NumEntries}	numentries	:UINT
ENDOBJECT

NATIVE {DFH_ID}	CONST DFH_ID	= $0f80
NATIVE {MAXFONTNAME}	CONST MAXFONTNAME	= 32

NATIVE {DiskFontHeader} OBJECT diskfontheader
	{dfh_DF}	df	:ln
	{dfh_FileID}	fileid	:UINT
	{dfh_Revision}	revision	:UINT
	{dfh_Segment}	segment	:BPTR
	{dfh_Name}	name[MAXFONTNAME]	:ARRAY OF CHAR
	{dfh_TF}	tf	:textfont
ENDOBJECT

NATIVE {dfh_TagList} CONST

NATIVE {AFB_MEMORY}	CONST AFB_MEMORY	= 0
NATIVE {AFF_MEMORY}	CONST AFF_MEMORY	= $0001
NATIVE {AFB_DISK}	CONST AFB_DISK	= 1
NATIVE {AFF_DISK}	CONST AFF_DISK	= $0002
NATIVE {AFB_SCALED}	CONST AFB_SCALED	= 2
NATIVE {AFF_SCALED}	CONST AFF_SCALED	= $0004
NATIVE {AFB_BITMAP}	CONST AFB_BITMAP	= 3
NATIVE {AFF_BITMAP}	CONST AFF_BITMAP	= $0008

NATIVE {AFB_TAGGED}	CONST AFB_TAGGED	= 16
NATIVE {AFF_TAGGED}	CONST AFF_TAGGED	= $10000

NATIVE {AvailFonts} OBJECT af
	{af_Type}	type	:UINT
	{af_Attr}	attr	:textattr
ENDOBJECT

NATIVE {TAvailFonts} OBJECT taf
	{taf_Type}	type	:UINT
	{taf_Attr}	attr	:ttextattr
ENDOBJECT

NATIVE {AvailFontsHeader} OBJECT afh
	{afh_NumEntries}	numentries	:UINT
ENDOBJECT
