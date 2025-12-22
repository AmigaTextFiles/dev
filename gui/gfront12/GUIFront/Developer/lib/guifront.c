
#include <libraries/guifront.h>
#include <utility/tagitem.h>
#include <proto/guifront.h>
#include <proto/exec.h>

struct Library *GUIFrontBase;
static struct Library *libbase;

extern void __regargs __autoopenfail(char *lib);

GUIFrontApp *GF_CreateGUIApp(char * const appid, ...)
{
	return (GF_CreateGUIAppA(appid, (struct TagItem *)(&appid+1)));
}

ULONG GF_GetGUIAppAttr(GUIFrontApp * const guiapp, ...)
{
	return (GF_GetGUIAppAttrA(guiapp, (struct TagItem *)(&guiapp+1)));
}

ULONG GF_SetGUIAppAttr(GUIFrontApp * const guiapp, ...)
{
	return (GF_SetGUIAppAttrA(guiapp, (struct TagItem *)(&guiapp+1)));
}

GUIFront *GF_CreateGUI(GUIFrontApp * const guiapp, ULONG * const layoutlist, GadgetSpec ** const gspecs, ...)
{
	return (GF_CreateGUIA(guiapp, layoutlist, gspecs, (struct TagItem *)(&gspecs+1)));
}

ULONG GF_GetGUIAttr(GUIFront * const gui, ...)
{
	return (GF_GetGUIAttrA(gui, (struct TagItem *)(&gui+1)));
}

ULONG GF_SetGUIAttr(GUIFront * const gui, ...)
{
	return (GF_SetGUIAttrA(gui, (struct TagItem *)(&gui+1)));
}

void GF_SetGadgetAttrs(GUIFront * const gui, struct Gadget * const gad, ...)
{
	GF_SetGadgetAttrsA(gui, gad, (struct TagItem *)(&gad+1));
}

ULONG GF_GetGadgetAttrs(GUIFront * const gui, struct Gadget * const gad, ...)
{
	return (GF_GetGadgetAttrsA(gui, gad, (struct TagItem *)(&gad+1)));
}

GF_GetPrefsAttr(char * const appid, ...)
{
	return (GF_GetPrefsAttrA(appid, (struct TagItem *)(&appid+1)));
}

GF_SetPrefsAttr(char * const appid, ...)
{
	return (GF_SetPrefsAttrA(appid, (struct TagItem *)(&appid+1)));
}

BOOL GF_AslRequestTags(APTR const requester, ...)
{
	return (GF_AslRequest(requester, (struct TagItem *)(&requester+1)));
}

long GF_EasyRequest(GUIFrontApp * const guiapp,struct Window * const window,struct EasyStruct * const easystruct,ULONG * const idcmpptr, ...)
{
	return (GF_EasyRequestArgs(guiapp, window, easystruct, idcmpptr, (struct TagItem *)(&idcmpptr+1)));
}

ULONG GF_GetPubScreenAttr(char * const pubname, ...)
{
	return (GF_GetPubScreenAttrA(pubname, (struct TagItem *)(&pubname+1)));
}

ULONG GF_SetPubScreenAttr(char * const pubname, ...)
{
	return (GF_SetPubScreenAttrA(pubname, (struct TagItem *)(&pubname+1)));
}

/* V38.1 - Autoinit code for SAS/C */

int __stdargs _STI_openguifront(void)
{
	if (GUIFrontBase = libbase = OpenLibrary(GUIFRONTNAME,0))
		return(0);

	__autoopenfail("guifront.library");
	return(1);
}

void __stdargs _STD_closeguifront(void)
{
    if (libbase)
    {
        CloseLibrary(libbase);
        libbase = GUIFrontBase = NULL;
    }
}
