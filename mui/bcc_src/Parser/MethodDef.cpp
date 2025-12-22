#include "MethodDef.h"

#include "ParseBC.h"
#include "Global.h"

#include <string.h>

MethodDef::MethodDef( char *n, short len, ClassDef *clsd, unsigned short sw ) : InterDef( n, len, clsd, sw )
{
	msgtype = "Msg";

		if( !strcmp( Name, "MUIM_AskMinMax" ) ) {
			switches |= SW_PRESUPER;
			msgtype = "struct MUIP_AskMinMax*";
		}

		if( !strcmp( Name, "MUIM_Draw" ) ) {
			switches |= SW_PRESUPER;
			msgtype = "struct MUIP_Draw*";
		}

		if( !strcmp( Name, "MUIM_HandleInput" ) ) {
			switches |= SW_POSTSUPER;
			msgtype = "struct MUIP_HandleInput*";
		}

		if( !strcmp( Name, "MUIM_HandleEvent" ) ) {
			msgtype = "struct MUIP_HandleEvent*";
		}

		if( !strcmp( Name, "MUIM_Cleanup" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "Msg";
		}

		if( !strcmp( Name, "OM_GET" ) ) {
			msgtype = "struct opGet*";
		}

		if( !strcmp( Name, "OM_SET" ) ) {
			msgtype = "struct opSet*";
		}

		if( !strcmp( Name, "OM_NEW" ) ) {
			switches |= SW_PRESUPER|SW_SUPERCHECK;
			msgtype = "struct opSet*";
		}

		if( !strcmp( Name, "MUIM_Setup" ) ) {
			switches |= SW_PRESUPER|SW_SUPERCHECK;
			msgtype = "Msg";
		}

		if( !strcmp( Name, "MUIM_Show" ) ) {
			switches |= SW_PRESUPER|SW_SUPERCHECK;
			msgtype = "Msg";
		}

		if( !strcmp( Name, "MUIM_Hide" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "Msg";
		}

		if( !strcmp( Name, "MUIM_DragQuery" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "struct MUIP_DragQuery*";
		}

		if( !strcmp( Name, "MUIM_DragDrop" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "struct MUIP_DragDrop*";
		}

		if( !strcmp( Name, "MUIM_DragBegin" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "struct MUIP_DragBegin*";
		}

		if( !strcmp( Name, "MUIM_DragFinish" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "struct MUIP_DragFinish*";
		}

		if( !strcmp( Name, "MUIM_DragReport" ) ) {
			switches |= SW_POSTSUPER|SW_SUPERCHECK;
			msgtype = "struct MUIP_DragReport*";
		}

		if( !strcmp( Name, "OM_DISPOSE" ) ) {
			switches |= SW_POSTSUPER;
			msgtype = "Msg";
		}

		if( !strcmp( Name, "MUIM_ContextMenuChoice" ) ) {
			switches |= SW_POSTSUPER;
			msgtype = "struct MUIP_ContextMenuChoice*";
		}

		if( !strcmp( Name, "MUIM_ContextMenuBuild" ) ) {
			msgtype = "struct MUIP_ContextMenuBuild*";
		}

		if( !strcmp( Name, "MUIM_DrawBackground" ) ) {
			msgtype = "struct MUIP_DrawBackground*";
		}


}