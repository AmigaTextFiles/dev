/*************************************************************************
;  :Module.	class.c
;  :Author.	Bert Jahn
;  :Address.	Clara-Zetkin-Straﬂe 52, Zwickau, 08058, Germany
;  :Version.	$Id: class.c 1.4 2006/05/07 19:47:03 wepl Exp wepl $
;  :History.	07.06.04 separated from winmem.c
;		18.04.06 goto_abs added
;  :Copyright.	All Rights Reserved
;  :Language.	C
;  :Translator.	GCC
*************************************************************************/

#include <libraries/mui.h>
#include <mui/BetterString_mcc.h>
#include <mui/HexEdit_mcc.h>

#include <clib/alib_protos.h>
#include <clib/muimaster_protos.h>
#include <clib/utility_protos.h>

#include "WHDLoadGCI.h"
#include "class.h"
#include "whddump.h"

/************************************************************************/
/* Compiler Stuff                                                       */
/************************************************************************/

#define REG(x) register __ ## x
#define ASM    __asm
#define SAVEDS __saveds

/************************************************************************/
/* defines								*/
/************************************************************************/

/************************************************************************/
/* extern variables							*/
/************************************************************************/

extern APTR gad_goto_abs[];	/* goto gadgets absolut */
extern APTR gad_goto_rel[];	/* goto gadgets relative */

/************************************************************************/
/* static variables							*/
/************************************************************************/

struct MUI_CustomClass *GCIHexEdit_Class = NULL;
struct MUI_CustomClass *GCIStringCustom_Class = NULL;
struct MUI_CustomClass *GCIStringRegister_Class = NULL;

const char* StringHexAccept = "$0123456789abcdefABCDEF";

/************************************************************************/
/* function declarations						*/
/************************************************************************/

/************************************************************************/

struct GCIHexEdit_Data {
	int low_bound;
	int high_bound;
	int base_address;
	int len_base;
	int len_off;
};

SAVEDS ULONG
GCIHexEdit_mNew(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	struct TagItem *tags,*tag;
	int i;
	struct GCIHexEdit_Data tmp = {0,0,0,0,0};

	for (tags=((struct opSet *)msg)->ops_AttrList; (tag=NextTagItem(&tags)); )
	{
		switch (tag->ti_Tag)
		{
			case MUIA_HexEdit_LowBound: tmp.low_bound = tag->ti_Data; break;
			case MUIA_HexEdit_HighBound: tmp.high_bound = tag->ti_Data; break;
			case MUIA_HexEdit_BaseAddressOffset: tmp.base_address = tag->ti_Data; break;
			case MUIA_HexEdit_AddressChars:
				i = tmp.high_bound + tmp.base_address;
				tmp.len_base =	i < 0x10000 ? 4 :
						i < 0x100000 ? 5 :
						i < 0x1000000 ? 6 :
						i < 0x10000000 ? 7 : 8;
				if (tmp.low_bound + tmp.base_address) {
					i = tmp.high_bound - tmp.low_bound;
					tmp.len_off =	i < 0x1000 ? 3 :
							i < 0x10000 ? 4 :
							i < 0x100000 ? 5 : 6;
				} else {
					tmp.len_off = 0;
				}
				tag->ti_Data = tmp.len_base + (tmp.len_off ? 1 + tmp.len_off : 0);
				break;
		}
	}

	if (!(obj = (Object *)DoSuperMethodA(cl,obj,msg))) return(0);

	memcpy(INST_DATA(cl,obj), &tmp, sizeof(tmp));

	return ((ULONG)obj);
}

SAVEDS ULONG
GCIHexEdit_mSet(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	struct GCIHexEdit_Data *d = INST_DATA(cl,obj);
	struct TagItem *tags,*tag;
	char *s;
	int i;

	for (tags=((struct opSet *)msg)->ops_AttrList; (tag=NextTagItem(&tags)); )
	{
		switch (tag->ti_Tag)
		{
			case MUIA_GCIHexEdit_CursorAddressAbs:
				get( gad_goto_abs[tag->ti_Data], MUIA_String_Contents, &s );
				i = htoi( s ) - d->base_address - d->low_bound;
				/*printf("MUIA_GCIHexEdit_CursorAddressAbs num=%ld adr='%s'=%d=$%x low=$%lx high=$%lx base=$%lx\n",tag->ti_Data,s,i,i,d->low_bound,d->high_bound,d->base_address);*/
				set( obj, MUIA_HexEdit_CursorAddress, i );
				break;
			case MUIA_GCIHexEdit_CursorAddressRel:
				get( gad_goto_rel[tag->ti_Data], MUIA_String_Contents, &s );
				i = htoi( s );
				/*printf("MUIA_GCIHexEdit_CursorAddressRel num=%ld adr='%s'=%d=$%x\n",tag->ti_Data,s,i,i);*/
				set( obj, MUIA_HexEdit_CursorAddress, i );
				break;
		}
	}

	return DoSuperMethodA(cl,obj,msg);
}

SAVEDS ULONG
GCIHexEdit_mCreateDisplayAddress(
	struct IClass *cl,
	Object *obj,
	struct MUIP_HexEdit_CreateDisplayAddress *msg
) {
	struct GCIHexEdit_Data *d = INST_DATA(cl,obj);
	ULONG address;
	UBYTE i;
	UBYTE *hextable = "0123456789ABCDEF";

	address = (d->base_address + msg->address) << (32 - d->len_base * 4);
	for(i = 0; i < d->len_base; i++)
	{
		*(*msg->cp)++ = hextable[address >> (32 - 4)];
		address <<= 4;
	}

	address = (msg->address - d->low_bound) << (32 - d->len_off * 4);
	if (d->len_off) {
		*(*msg->cp)++ = (unsigned char) '∑';
		for(i = 0; i < d->len_off; i++)
		{
			*(*msg->cp)++ = hextable[address >> (32 - 4)];
			address <<= 4;
		}
	}

	return(TRUE);
}

/*
SAVEDS ASM ULONG
GCIHexEdit_Dispatcher(
	REG(a0) struct IClass *cl,
	REG(a2) Object *obj,
	REG(a1) Msg msg
*/
SAVEDS ULONG
GCIHexEdit_Dispatcher(
	struct IClass *cl __asm("a0"),
	Object *obj __asm("a2"),
	Msg msg __asm("a1")
) {
	switch (msg->MethodID)
	{
		case OM_NEW				: return(GCIHexEdit_mNew			(cl,obj,(APTR)msg));
		case OM_SET				: return(GCIHexEdit_mSet			(cl,obj,(APTR)msg));
		case MUIM_HexEdit_CreateDisplayAddress	: return(GCIHexEdit_mCreateDisplayAddress	(cl,obj,(APTR)msg));
	}
	return(DoSuperMethodA(cl,obj,msg));
}

/************************************************************************/

struct GCIStringCustom_Data {
	UWORD offset;
	UWORD readwrite;	/* write offset */
	char *(*help)(ULONG);
	char lw;
};

SAVEDS ULONG
GCIStringCustom_mNew(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	struct TagItem *tags,*tag;
	struct GCIStringCustom_Data data = {0,0,0,0};
	ULONG v;

	for (tags=((struct opSet *)msg)->ops_AttrList; (tag=NextTagItem(&tags)); )
	{
		switch (tag->ti_Tag)
		{
			case MUIA_GCIStringCustom_Offset:
				data.offset = tag->ti_Data;
				break;
			case MUIA_GCIStringCustom_ReadWrite:
				data.readwrite = tag->ti_Data;
				break;
			case MUIA_GCIStringCustom_Help:
				data.help = (char *(*)(ULONG)) tag->ti_Data;
				break;
			case MUIA_GCIStringCustom_Long:
				data.lw = -1;
				break;
		}
	}

	if (!(obj = (Object *)DoSuperMethodA(cl,obj,msg))) return(0);

	memcpy(INST_DATA(cl,obj), &data, sizeof(data));
	
	set(obj,MUIA_String_MaxLen,data.lw ? 10 : 6);
	set(obj,MUIA_String_Format,MUIV_String_Format_Right);
	set(obj,MUIA_CycleChain,1);
	
	if (custom->wdcu_flags[data.offset].read || custom->wdcu_flags[data.offset].modi) {
		if (data.lw) {
			v = *(ULONG*)&(custom->wdcu_regs[data.offset/2]);
		} else {
			v = custom->wdcu_regs[data.offset/2];
		}
		set(obj,MUIA_String_Contents,val2hex(v));
		if (data.help)
			set(obj,MUIA_ShortHelp,data.help(v));
	}
	if (custom->wdcu_flags[data.offset].read && ! data.readwrite) {
		set(obj,MUIA_BetterString_NoInput,TRUE);
	/*	set(obj,MUIA_Background,"2:ffffffff,0,0");	doesn't work */
	} else {
		set(obj,MUIA_String_Accept,StringHexAccept);
		DoMethod(obj,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,obj,1,MUIM_GCIStringCustom_Changed);
		DoMethod(obj,MUIM_Notify,MUIA_String_Accept,MUIV_EveryTime,obj,1,MUIM_GCIStringCustom_Accept); /* doesn't work??? */
	}

	return ((ULONG)obj);
}

SAVEDS ULONG
GCIStringCustom_mChanged(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	struct GCIStringCustom_Data *data = INST_DATA(cl,obj);
	char *s;
	ULONG v;
	
	get(obj, MUIA_String_Contents, &s );
	v = htoi( s );
	
	if (data->lw) {
		*(ULONG*)&(custom->wdcu_regs[data->offset/2]) = v;
	} else {
		v &= 0x0ffff;
		custom->wdcu_regs[data->offset/2] = v;
	}

	if (data->help) set(obj,MUIA_ShortHelp,data->help(v));

	return(TRUE);
}

/* gets never called! don't know why */
SAVEDS ULONG
GCIStringCustom_mAccept(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	char *s;
	
	get(obj, MUIA_String_Contents, &s );
	set(obj, MUIA_String_Contents, val2hex(htoi(s)) );
	
	return(TRUE);
}

SAVEDS ULONG
GCIStringCustom_Dispatcher(
	struct IClass *cl __asm("a0"),
	Object *obj __asm("a2"),
	Msg msg __asm("a1")
) {
	switch (msg->MethodID)
	{
		case OM_NEW				: return(GCIStringCustom_mNew			(cl,obj,(APTR)msg));
		case MUIM_GCIStringCustom_Changed	: return(GCIStringCustom_mChanged		(cl,obj,(APTR)msg));
		case MUIM_GCIStringCustom_Accept	: return(GCIStringCustom_mAccept		(cl,obj,(APTR)msg));
	}
	return(DoSuperMethodA(cl,obj,msg));
}

/************************************************************************/

struct GCIStringRegister_Data {
	APTR ptr;		/* where data is stored */
	char *(*help)(ULONG);	/* bubble help */
	char type;		/* 8..64 bit */
	char readonly;
};

SAVEDS ULONG
GCIStringRegister_mNew(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	struct TagItem *tags,*tag;
	struct GCIStringRegister_Data data = {0,0,0,0};
	ULONG v=0;
	UWORD maxlen=1;

	for (tags=((struct opSet *)msg)->ops_AttrList; (tag=NextTagItem(&tags)); )
	{
		switch (tag->ti_Tag)
		{
			case MUIA_GCIStringRegister_Pointer:
				data.ptr = (APTR)tag->ti_Data;
				break;
			case MUIA_GCIStringRegister_Help:
				data.help = (char *(*)(ULONG)) tag->ti_Data;
				break;
			case MUIA_GCIStringRegister_Type:
				data.type = tag->ti_Data;
				break;
			case MUIA_GCIStringRegister_ReadOnly:
				data.readonly = TRUE;
				break;
		}
	}

	if (!(obj = (Object *)DoSuperMethodA(cl,obj,msg))) return(0);

	memcpy(INST_DATA(cl,obj), &data, sizeof(data));
	
	switch (data.type)
	{
		case RegType_8:	
			v = *(UBYTE*)data.ptr;
			maxlen = 4;
			break;
		case RegType_16:
			v = *(UWORD*)data.ptr;
			maxlen = 6;
			break;
		case RegType_24:
			v = *(ULONG*)data.ptr;
			maxlen = 8;
			break;
		case RegType_32:
			v = *(ULONG*)data.ptr;
			maxlen = 10;
			break;
		case RegType_64:
			set(obj,MUIA_String_Contents,val2hex64(*(ULONG*)data.ptr,*(1+(ULONG*)data.ptr)));
			maxlen = 18;
			break;
	}
	
	set(obj,MUIA_String_MaxLen,maxlen);
	set(obj,MUIA_String_Format,MUIV_String_Format_Right);
	if (data.type != RegType_64) set(obj,MUIA_String_Contents,val2hex(v));
	if (data.help) set(obj,MUIA_ShortHelp,data.help(v));
	
	
	if (data.readonly) {
		set(obj,MUIA_BetterString_NoInput,TRUE);
	} else {
		set(obj,MUIA_String_Accept,StringHexAccept);
		set(obj,MUIA_CycleChain,1);
		DoMethod(obj,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,obj,1,MUIM_GCIStringRegister_Changed);
	}

	return ((ULONG)obj);
}

SAVEDS ULONG
GCIStringRegister_mChanged(
	struct IClass *cl,
	Object *obj,
	Msg msg
) {
	struct GCIStringRegister_Data *data = INST_DATA(cl,obj);
	char *s;
	ULONG v;
	
	get(obj, MUIA_String_Contents, &s );
	v = htoi( s );

	switch (data->type)
	{
		case RegType_8:	
			*(UBYTE*)data->ptr = v;
			break;
		case RegType_16:
			*(UWORD*)data->ptr = v;
			break;
		case RegType_24:
			*(ULONG*)data->ptr = v;
			break;
		case RegType_32:
			*(ULONG*)data->ptr = v;
			break;
	}
	
	if (data->help) set(obj,MUIA_ShortHelp,data->help(v));

	return(TRUE);
}

SAVEDS ULONG
GCIStringRegister_Dispatcher(
	struct IClass *cl __asm("a0"),
	Object *obj __asm("a2"),
	Msg msg __asm("a1")
) {
	switch (msg->MethodID)
	{
		case OM_NEW				: return(GCIStringRegister_mNew			(cl,obj,(APTR)msg));
		case MUIM_GCIStringRegister_Changed	: return(GCIStringRegister_mChanged		(cl,obj,(APTR)msg));
	}
	return(DoSuperMethodA(cl,obj,msg));
}

/****************************************************************************/

int class_init() {
	GCIHexEdit_Class	= MUI_CreateCustomClass(NULL,MUIC_HexEdit,NULL,sizeof(struct GCIHexEdit_Data),GCIHexEdit_Dispatcher);
	GCIStringCustom_Class	= MUI_CreateCustomClass(NULL,MUIC_BetterString,NULL,sizeof(struct GCIStringCustom_Data),GCIStringCustom_Dispatcher);
	GCIStringRegister_Class = MUI_CreateCustomClass(NULL,MUIC_BetterString,NULL,sizeof(struct GCIStringRegister_Data),GCIStringRegister_Dispatcher);
	if (GCIHexEdit_Class || GCIStringCustom_Class || GCIStringRegister_Class) {
		return 1;
	} else {
		class_finit();
		return 0;
	}
}

void class_finit() {
	if (GCIHexEdit_Class)		MUI_DeleteCustomClass(GCIHexEdit_Class);
	if (GCIStringCustom_Class)	MUI_DeleteCustomClass(GCIStringCustom_Class);
	if (GCIStringRegister_Class)	MUI_DeleteCustomClass(GCIStringRegister_Class);
}

/****************************************************************************/

