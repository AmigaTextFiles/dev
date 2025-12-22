#ifndef UI_H
#define UI_H

#include "apptags.h"
#define CATCOMP_NUMBERS
#include "locale.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <tagitemmacros.h>

#include <proto/classes/requesters/palette.h>
#include <classes/requesters/palette.h>

#include <proto/classes/gadgets/tcpalette.h>
#include <classes/gadgets/tcpalette.h>

#include <proto/classes/supermodel.h>
#include <classes/supermodel.h>


#include <exec/types.h>
#include <libraries/gadtools.h>
#include <intuition/icclass.h>
#include <intuition/classes.h>
#include <dos/dos.h>

#include <clib/extras_protos.h>
#include <clib/macros.h>
#include <clib/alib_protos.h>
#include <clib/reaction_lib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/bevel.h>
#include <proto/label.h>
#include <proto/button.h>
//#include <proto/checkbox.h>
//#include <proto/chooser.h>
//#include <proto/clicktab.h>
//#include <proto/getfile.h>
//#include <proto/getfont.h>
//#include <proto/getscreenmode.h>
#include <proto/integer.h>
#include <proto/layout.h>
//#include <proto/listbrowser.h>
//#include <proto/palette.h>
#include <proto/slider.h>
#include <proto/space.h>
#include <proto/string.h>
#include <proto/window.h>
#include <proto/utility.h>
#include <proto/locale.h>

#include <classes/window.h>
#include <gadgets/button.h>
//#include <gadgets/checkbox.h>
//#include <gadgets/chooser.h>
//#include <gadgets/clicktab.h>
//#include <gadgets/getfont.h>
//#include <gadgets/getfile.h>
#include <gadgets/integer.h>
#include <gadgets/layout.h>
//#include <gadgets/listbrowser.h>
//#include <gadgets/palette.h>
#include <gadgets/slider.h>
#include <gadgets/space.h>
#include <gadgets/string.h>

#include <images/label.h>
#include <images/bevel.h>

#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include "apptags.h"

Class *MyMakeClass(STRPTR ClassID, STRPTR SuperClassID, APTR SuperClassPtr, ULONG ISize, ULONG Nil, ULONG(*Entry)() );

ULONG __asm DispatcherStub(register __a0 Class *Cl, register __a2 Object *Obj, register __a1 Msg M);
ULONG __asm __saveds GM_Set(register __a0 struct smGlueData     *GD, 
                            register __a1 struct TagItem        *TagList, 
                            register __a2 struct EData        *edata);

ULONG __saveds __asm EditorDispatcher(register __a0 Class *C, register __a2 Object *Obj, register __a1 Msg M, register __a6 struct Library *Lib);
BOOL  i_NewWindowObject    (Class *C, Object *Obj, struct opSet *Set);
BOOL  i_DisposeWindowObject(Class *C, Object *Obj);
ULONG i_OpenEditor         (Class *C, Object *Obj, struct opSet *Set);

STRPTR GetString(LONG stringNum);

#define ADD_DUMMY(x) ((0xffffffff)-(x))
#define ADD_TARGET ADD_DUMMY(0)
#define ADD_MEMBER ADD_DUMMY(1)
#define ADD_IDCMP  ADD_DUMMY(2)

Object *BuildModel(Tag Tags, ...);
STRPTR GetString(LONG stringNum);

extern Class *GlueClass,  *GlueICClass;
Class *MakeGlueClass(void);
void FreeGlueClass(void);


#endif /* UI_H */
