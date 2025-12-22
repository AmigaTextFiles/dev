/*
 * $RCSfile: EAGUI_macros.h,v $
 *
 * $Author: marcel $
 *
 * $Revision: 3.0 $
 *
 * $Date: 1994/10/27 19:45:48 $
 *
 * $Locker: marcel $
 *
 * $State: Exp $
 */

#ifndef EAGUI_MACROS_H
#define EAGUI_MACROS_H

#define HGroup \
     ea_NewObject(EA_TYPE_HGROUP,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\

#define VGroup \
     ea_NewObject(EA_TYPE_VGROUP,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\

#define GTString(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          STRING_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_LEFT,

#define GTText(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          TEXT_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_LEFT,

#define GTButton(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          BUTTON_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_IN,

#define GTScroller \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          SCROLLER_KIND,

#define GTSlider \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          SLIDER_KIND,

#define GTCheckBox(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          CHECKBOX_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_LEFT,

#define GTInteger(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          INTEGER_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_LEFT,

#define GTNumber(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          NUMBER_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_LEFT,

#define GTListView(text) \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          LISTVIEW_KIND,\
          EA_GTText,          (ULONG)text,\
          EA_GTFlags,         PLACETEXT_ABOVE,

#define GTMX \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          MX_KIND,\

#define GTCycle \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          CYCLE_KIND,\

#define GTPalette \
     ea_NewObject(EA_TYPE_GTGADGET,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_GTType,          PALETTE_KIND,\

#define EmptyBox(weight)\
     ea_NewObject(EA_TYPE_CUSTOMIMAGE,\
          EA_StandardMethod,  EASM_MINSIZE|EASM_BORDER,\
          EA_Weight,          weight,

#define End \
          TAG_DONE)

#endif /* EAGUI_MACROS_H */
