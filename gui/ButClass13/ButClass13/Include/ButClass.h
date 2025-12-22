/****************************************************\
** ButClass.lib  ** 1.3  **  (26.1.96)              **
******************************************************
**                                                  **
** C Header for the BOOPSI button gadget class.     **
**                                                  **
** ButtonClass with special features:               **
**                                                  **
**  ClipText, Justify...                            **
**                                                  **
\****************************************************/



#ifndef BUTCLASS_H
#define BUTCLASS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/* Tags */
#define BUT_TB                  TAG_USER+0x70000

#define BUT_Label               (BUT_TB+1)              /* ISG-- */
#define BUT_ClipText            (BUT_TB+2)              /* I-G-- */
#define BUT_Justify             (BUT_TB+3)              /* I-G-- */


#define BUT_LabelPen            (BUT_TB+4)              /* ISG-- */
#define BUT_SelectedLabelPen    (BUT_TB+5)              /* ISG-- */

#define BUT_TextFont            (BUT_TB+6)              /* I---- */
#define BUT_Underscore          (BUT_TB+7)              /* I---- */

/* Can use follow TAGS of the bgui.library */
/* FRM_BackPen                                (ISG--)      */
/* FRM_SelectedBackPen                        (ISG--)      */
/* FRM_BackFill                               (ISG--)      */
/* FRM_Recessed                               (ISG--)      */


/* Definitions */
#define BSEQ_J                  "\x2"


/* Prototypes */
Class *InitButClass( void );
BOOL FreeButClass( Class * );


/*
**  Macros
**/
#define ButObject( class )   NewObject( class, NULL

#define But( class, label, id )\
    ButObject( class ),\
        BUT_Label,      label,\
        BUT_Underscore, '_',\
        GA_ID,          id,\
        ButtonFrame,\
    EndObject


#define ButClip( class, label, id )\
    ButObject( class ),\
        BUT_Label,      label,\
        BUT_ClipText,   TRUE,\
        BUT_Underscore, '_',\
        GA_ID,          id,\
        ButtonFrame,\
    EndObject

#define ButJustify( class, label, id )\
    ButObject( class ),\
        BUT_Label,      label,\
        BUT_Justify,    TRUE,\
        BUT_Underscore, '_',\
        GA_ID,          id,\
        ButtonFrame,\
    EndObject

#define ButClipJust( class, label, id )\
    ButObject( class ),\
        BUT_Label,      label,\
        BUT_Justify,    TRUE,\
        BUT_ClipText,   TRUE,\
        BUT_Underscore, '_',\
        GA_ID,          id,\
        ButtonFrame,\
    EndObject


#endif
