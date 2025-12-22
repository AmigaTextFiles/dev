@DATABASE "gg:doc/NDK/Guide/Include/clib/reaction_lib_protos.h"
@MASTER   "gg:os-include/clib/reaction_lib_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/reaction_lib_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/reaction_lib_protos.h" LINK File}

@ENDNODE
@NODE File "clib/reaction_lib_protos.h"
#ifndef CLIB_REACTION_LIB_PROTOS_H
#define CLIB_REACTION_LIB_PROTOS_H
/*
**      $VER: reaction_lib_protos.h 45.1 (17.12.2001)
**      Includes Release 45.1
**
**      C prototypes. For use with 32 bit integers only.
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <@{"intuition/classusr.h" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File"}>
#endif

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

#ifdef __cplusplus
extern "C" {
#endif

@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *ChooserLabelsA( STRPTR * );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *ChooserLabels( STRPTR, ... );
void FreeChooserLabels( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} * );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *RadioButtonsA( STRPTR * );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *RadioButtons( STRPTR, ... );
void FreeRadioButtons( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} * );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *OpenLayoutWindowTagList( struct Gadget *, struct Screen *, struct TagItem * );
@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *OpenLayoutWindowTags( struct Gadget *, struct Screen *, Tag, ... );
@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} GetCode( @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} * );
@{"struct ClassLibrary" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 105} *OpenClass(STRPTR, ULONG);
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} OpenLibs(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49});
void CloseLibs(@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49});
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} LibDoGadgetMethodA( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, struct Window *, struct Requester *, Msg );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} LibDoGadgetMethod( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, struct Window *, struct Requester *, Tag, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} GetAttrsA( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *t );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} GetAttrs( @{"Object" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 19} *o, @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} t, ... );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *BrowserNodesA( STRPTR * );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *BrowserNodes( STRPTR, ... );
void FreeBrowserNodes( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} * );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *ClickTabsA( STRPTR * );
@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *ClickTabs( STRPTR, ... );
void FreeClickTabs( @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} * );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *LBAddNodeA( struct Gadget *, struct Window *, struct Requester *, struct Node *, struct TagItem * );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} LBEditNodeA( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, struct Window *, struct Requester *, struct Node *, struct TagItem * );
@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *LBAddNode( struct Gadget *lb, struct Window *w, struct Requester *r, struct Node *n, ULONG tag, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} LBEditNode( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *lb, struct Window *w, struct Requester *r, struct Node *n, ULONG tag, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} LBRemNode( @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *, struct Window *, struct Requester *, struct Node * );

#ifdef __cplusplus
}
#endif

#endif /* CLIB_REACTION_LIB_PROTOS_H */
@ENDNODE
