/*************************************************************************/
/*                                                                       */
/*   GUI designed with GUICreator V1.4 - © 1995 by Markus Hillenbrand    */
/*                                                                       */
/*************************************************************************/

char *V="$VER: Strings 1.0 (01.11.95)";

/*************************************************************************/
/*                                                                       */
/*   Includes                                                            */
/*                                                                       */
/*************************************************************************/

#ifdef __MAXON__
#include <wbstartup.h>
#endif
#include "Strings_Includes.h"
#include "Strings.h"

/*************************************************************************/
/*                                                                       */
/*   Variables and Structures                                            */
/*                                                                       */
/*************************************************************************/

struct IntuitionBase *IntuitionBase = NULL;
struct UtilityBase   *UtilityBase   = NULL;
struct GfxBase       *GfxBase       = NULL;
struct Library *GadToolsBase  = NULL;
struct Library *AslBase       = NULL;
struct Library *DataTypesBase = NULL;
struct Library *TextFieldBase = NULL;

/*************************************************************************/
/*                                                                       */
/*   main()                                                              */
/*                                                                       */
/*************************************************************************/

int main (int argc, char *argv[])
{
	IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",39);
	UtilityBase  =(struct UtilityBase   *)OpenLibrary("utility.library"  ,39);
	GfxBase      =(struct GfxBase       *)OpenLibrary("graphics.library" ,39);
	GadToolsBase =OpenLibrary("gadtools.library" ,39);
	AslBase      =OpenLibrary("asl.library"      ,39);
	DataTypesBase=OpenLibrary("datatypes.library",39);
	TextFieldBase=OpenLibrary("gadgets/textfield.gadget",3);

	if (IntuitionBase && GadToolsBase && GfxBase && AslBase && DataTypesBase && UtilityBase && TextFieldBase)
		{
		struct Screen *screen;
		screen=LockPubScreen(NULL);
		if (screen)
			{
			HandleWindow(screen,-1,-1,NULL);
			UnlockPubScreen(NULL,screen);
			}
		else printf("Cannot lock screen\n");
		}
	else printf("Cannot open the following libraries:\n");

	if (TextFieldBase) CloseLibrary(TextFieldBase); else printf("- Texfield.gadget   v03\n");
	if (AslBase)       CloseLibrary(AslBase);       else printf("- Asl.library       v39\n");
	if (GadToolsBase)  CloseLibrary(GadToolsBase);  else printf("- Gadtools.library  v39\n");
	if (DataTypesBase) CloseLibrary(DataTypesBase); else printf("- Datatypes.library v39\n");
	if (GfxBase)       CloseLibrary((struct Library *)GfxBase);       else printf("- Graphics.library  v39\n");
	if (UtilityBase)   CloseLibrary((struct Library *)UtilityBase);   else printf("- Utility.library   v39\n");
	if (IntuitionBase) CloseLibrary((struct Library *)IntuitionBase); else printf("- Intuition.library v39\n");
	exit(RETURN_OK);
}
