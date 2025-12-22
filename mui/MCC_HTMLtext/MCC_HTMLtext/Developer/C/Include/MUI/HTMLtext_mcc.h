/*
**  HTMLtext.mcc
**  Copyright Dirk Holtwick, 1997
*/

/*** Include stuff ***/
#ifndef HTMLtext_MCC_H
#define HTMLtext_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

/** Serial number ***/

/*
** My serial number is #4260. But never use it for your classes!
*/

/*** MUI Defines ***/
#define MUIC_HTMLtext "HTMLtext.mcc"
#define HTMLtextObject MUI_NewObject(MUIC_HTMLtext

/*** Methods ***/
#define MUIM_HTMLtext_Mark           0x90a40011
#define MUIM_HTMLtext_Jump           0x90a40012
#define MUIM_HTMLtext_Reload         0x90a40014

/*** Method structs ***/

/*** Special method values ***/

/*** Special method flags ***/

/*** Attributes ***/
#define MUIA_HTMLtext_Contents       0x90a40001
#define MUIA_HTMLtext_Title          0x90a40003
#define MUIA_HTMLtext_Path           0x90a40004
#define MUIA_HTMLtext_OpenURLHook    0x90a40005
#define MUIA_HTMLtext_URL            0x90a40006
#define MUIA_HTMLtext_LoadImages     0x90a4000c
#define MUIA_HTMLtext_Block          0x90a4000d
#define MUIA_HTMLtext_DoubleClick    0x90a4000f
#define MUIA_HTMLtext_ElementList    0x90a40010
#define MUIA_HTMLtext_CloseURLHook   0x90a40013
#define MUIA_HTMLtext_VLinkHook      0x90a40015
#define MUIA_HTMLtext_Clicked        0x90a40016

/*** Special attribute values ***/

#define MUIV_HTMLtext_Element_Text           1
#define MUIV_HTMLtext_Element_Image          2
#define MUIV_HTMLtext_Element_HorizRule      3
#define MUIV_HTMLtext_Element_NewLine        101
#define MUIV_HTMLtext_Element_Space          102
#define MUIV_HTMLtext_Element_MarginLeft     103
#define MUIV_HTMLtext_Element_MarginRight    104
#define MUIV_HTMLtext_Element_Align          105
#define MUIV_HTMLtext_Element_NoLineBreak    106
#define MUIV_HTMLtext_Element_Anchor         107

/*** Structures, Flags & Values ***/

struct MUIS_HTMLtext_Element
{
   struct   MUIS_HTMLtext_Element *next;        /* Next element */
   UWORD    type;                               /* Type of element */
   UWORD    x,y,dx,dy;                          /* Coordinates of object */
   Object   *obj;                               /* MUI-Object */
   char     *text;                              /* Pointer to text */
   LONG     data;
};

/*** Macro to find out, if an MUIS_HTMLtext_Element is related
     to an MUI object ***/

#define MACRO_HTMLtext_IsMUIObject(el) \
   (el->type<100)

/*** Text related macro ***/

#define MACRO_HTMLtext_GetText(el) \
   ((el->type==MUIV_HTMLtext_Element_Text) ? el->text : "")

#endif /* HTMLtext_MCC_H */

