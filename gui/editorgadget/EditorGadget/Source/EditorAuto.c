/*
 * EditorGadget autoinit and autoterminate functions
 * for SAS/C 6.50 and up.
 *
 * If you just compile and link this into your app
 * then EditorClassBase will automatically get setup
 * before main() is called.  All your app source has
 * to include in order to call EDIT_GetClass() is the
 * <proto/editor.h> file.
 */

#include <exec/types.h>

#include <proto/exec.h>

struct Library *EditorClassBase;

int _STI_200_EditorClassInit(void)
{
	EditorClassBase = OpenLibrary("gadgets/editor.gadget", 0);
	if (EditorClassBase) {
		return 0;
	} else {
		return 1;
	}
}

void _STD_200_EditorClassTerm(void)
{
	CloseLibrary(EditorClassBase);
	EditorClassBase = NULL;
}
