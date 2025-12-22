@DATABASE "gg:doc/NDK/Guide/Include/inline/alib.h"
@MASTER   "gg:os-include/inline/alib.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:24
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/alib.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/alib.h" LINK File}


@{b}#defines@{ub}

@{"BeginIO()" LINK "gg:doc/NDK/Guide/Include/inline/alib.h/File" 8}  @{"NewList()" LINK "gg:doc/NDK/Guide/Include/inline/alib.h/File" 15}

@ENDNODE
@NODE File "inline/alib.h"
#ifndef _INLINE_ALIB_H
#define _INLINE_ALIB_H

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#define @{"BeginIO" LINK "gg:doc/NDK/Guide/amiga_lib/BeginIO"}(ioReq) \\
({                                                                      \\
        @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *_BeginIO_request = (ioReq);                   \\
        @{"LP1NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 74}(0x1e, @{"BeginIO" LINK File 8}, @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} *, _BeginIO_request, a1,  \\
        , _BeginIO_request->io_Device);                                 \\
})

#define @{"NewList" LINK "gg:doc/NDK/Guide/amiga_lib/NewList"}(list) \\
({                                                                      \\
  @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *_NewList_list = (list);                                  \\
  _NewList_list->lh_TailPred = (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *)_NewList_list;            \\
  _NewList_list->lh_Head = (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *)&_NewList_list->lh_Tail;      \\
  _NewList_list->lh_Tail = 0;                                           \\
})

#endif /* _INLINE_ALIB_H */
@ENDNODE
