/*
**
** $VER: MimeEditor_mcc.h V1.4 (22-Sep-98)
** Copyright @ 1997-98 Ole Friis Østergaard. All rights reserved.
**
*/

#ifndef	MIMEEDITOR_MCC_H
#define MIMEEDITOR_MCC_H

#define MUIC_MimeEditor	"MimeEditor.mcc"
#define MimeEditorObject MUI_NewObject(MUIC_MimeEditor

#define MUIA_MimeEditor_Changed					0xfad40005
#define MUIA_MimeEditor_EMail					0xfad40011
#define MUIA_MimeEditor_EMailMode				0xfad4000F
#define MUIA_MimeEditor_FixedFont				0xfad40014
#define MUIA_MimeEditor_IconDrawer				0xfad40001
#define MUIA_MimeEditor_NewsgroupMode			0xfad40010
#define MUIA_MimeEditor_Newsgroups				0xfad40012
#define MUIA_MimeEditor_Okay					0xfad40002
#define MUIA_MimeEditor_ReplyTo					0xfad4000D
#define MUIA_MimeEditor_Subject					0xfad40003
#define MUIA_MimeEditor_To						0xfad40004
#define MUIA_MimeEditor_WordWrap				0xfad4000E
#define MUIM_MimeEditor_CreateNewsgroupsList	0xfad40013
#define MUIM_MimeEditor_CreateToList			0xfad4000C
#define MUIM_MimeEditor_InsertFile				0xfad40006
#define MUIM_MimeEditor_InsertText				0xfad40007
#define MUIM_MimeEditor_OpenFile				0xfad40008
#define MUIM_MimeEditor_SaveFile				0xfad40009
/* Private methods, don't use */
#define MUIM_MimeEditor_ChangePage				0xfad4000A
#define MUIM_MimeEditor_DeletePart				0xfad4000B

/* Attribute values */
#define MUIV_MimeEditor_Okay_To					1
#define MUIV_MimeEditor_Okay_Subject			2
#define MUIV_MimeEditor_Okay_Contents			4
#define MUIV_MimeEditor_Okay_Newsgroups			8
#define MUIV_MimeEditor_Okay_ToEntered			16
#define MUIV_MimeEditor_Okay_NewsgroupEntered	32
#define MUIV_MimeEditor_Newsgroups_Activate		-1
#define MUIV_MimeEditor_To_Activate				-1
#define MUIV_MimeEditor_Subject_Activate		-1

struct MUIP_MimeEditor_InsertFile      { ULONG MetodID; char *FileName; };
struct MUIP_MimeEditor_InsertText      { ULONG MethodID; char *InitText; };
struct MUIP_MimeEditor_OpenFile        { ULONG MethodID; char *FileName; char *CiteString; char *StartReply; char *SignatureText; };
struct MUIP_MimeEditor_SaveFile        { ULONG MethodID; char *DestFile; char *From; char **ExtraHeaders; };

/* Only use Name, EMail, and Newsgroup. The other things might (will!) change! */
#ifndef MimeEditor_AddressEntry
struct MimeEditor_AddressEntry
{
	struct MimeEditor_AddressEntry *Next;
	char	*EMail;
	char	*Name;
	char	*Group;
	char	*Newsgroup;
	char	*Junk;
};
#endif

#endif