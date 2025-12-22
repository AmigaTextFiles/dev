#ifndef NEWSTRING_MACROS_H
#define NEWSTRING_MACROS_H
/*
**      $VER: NewString_macros.h 1.1 (12.12.95)
**      bgui.library macros.
**
**      (C) Copyright 1993-1995 Doguet Emmanuel.
**      All Rights Reserved.
**/


#ifndef LIBRARIES_BGUI_H
#include "bgui.h"
#endif  /* LIBRARIES_BGUI_H */


#define NewString( label, contents, maxchars, id ) \
        StringObject,\
            LAB_Label,              label,\
            LAB_Underscore,         '_',\
            RidgeFrame,\
            STRINGA_TextVal,        contents,\
            STRINGA_MaxChars,       maxchars+1,\
            GA_ID,                  id,\
            STRINGA_EditHook,       (ULONG)&StringHook,\
        EndObject

#define NewStringReturn( label, contents, maxchars, id ) \
        StringObject,\
            LAB_Label,              label,\
            LAB_Underscore,         '_',\
            RidgeFrame,\
            STRINGA_TextVal,        contents,\
            STRINGA_MaxChars,       maxchars+1,\
            GA_ID,                  id,\
            STRINGA_EditHook,       (ULONG)&StringHookReturn,\
        EndObject

#define NewStringCommand( label, contents, maxchars, id ) \
        StringObject,\
            LAB_Label,              label,\
            LAB_Underscore,         '_',\
            RidgeFrame,\
            STRINGA_TextVal,        contents,\
            STRINGA_MaxChars,       maxchars+1,\
            GA_ID,                  id,\
            STRINGA_EditHook,       (ULONG)&StringHookCommand,\
        EndObject



#endif      /* NEWSTRING_MACROS_H */
