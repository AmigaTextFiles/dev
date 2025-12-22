OPT MODULE
OPT PREPROCESS
OPT EXPORT
/*
**
** $VER: BetterString_mcc.h V11.5 (21-May-00)
** Copyright © 2000 Allan Odgaard. All rights reserved.
**
** Translated to Amiga-E by Daniel 'Deniil' Westerberg.
** Macro #defines also added by Daniel 'Deniil' Westerberg.
*/

MODULE 'exec/types'

#define   MUIC_BetterString     'BetterString.mcc'
#define   BetterStringObject    Mui_NewObjectA(MUIC_BetterString,[TAG_IGNORE,0

#define MUIA_BetterString_Columns       $ad001005
#define MUIA_BetterString_NoInput       $ad001007
#define MUIA_BetterString_SelectSize    $ad001001
#define MUIA_BetterString_StayActive    $ad001003
#define MUIM_BetterString_ClearSelected $ad001004
#define MUIM_BetterString_FileNameStart $ad001006
#define MUIM_BetterString_Insert        $ad001002

#define MUIV_BetterString_Insert_StartOfString  $00000000
#define MUIV_BetterString_Insert_EndOfString    $fffffffe
#define MUIV_BetterString_Insert_BufferPos      $ffffffff

#define MUIR_BetterString_FileNameStart_Volume  $ffffffff

#define BString(contents)\
        BetterStringObject,\
                StringFrame,\
                MUIA_String_Contents, contents,\
                MUIA_CycleChain, MUI_TRUE,\
                End

#define BStringID(contents,id)\
        BetterStringObject,\
                StringFrame,\
                MUIA_String_Contents, contents,\
                MUIA_ObjectID,id,\
                MUIA_CycleChain, MUI_TRUE,\
                End

#define BKeyString(contents,controlchar)\
        BetterStringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_CycleChain     ,MUI_TRUE,\
                MUIA_String_Contents, contents,\
                End

#define BKeyStringID(contents,controlchar,id)\
        BetterStringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_CycleChain     ,MUI_TRUE,\
                MUIA_String_Contents, contents,\
                MUIA_ObjectID,id,\
                End

#define BLString(contents,maxlen)\
        BetterStringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                MUIA_CycleChain, MUI_TRUE,\
                End

#define BLStringID(contents,maxlen,id)\
        BetterStringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                MUIA_ObjectID,id,\
                MUIA_CycleChain, MUI_TRUE,\
                End

#define BLKeyString(contents,maxlen,controlchar)\
        BetterStringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_CycleChain     ,MUI_TRUE,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#define BLKeyStringID(contents,maxlen,controlchar,id)\
        BetterStringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_CycleChain     ,MUI_TRUE,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                MUIA_ObjectID,id,\
                End

