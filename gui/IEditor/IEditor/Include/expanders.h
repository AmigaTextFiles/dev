#ifndef IEDIT_EXPANDER_H
#define IEDIT_EXPANDER_H
/*
**      Interface Editor expanders definitions.
**
**      (C) Copyright 1996 Simone Tellini
**          All Rights Reserved
*/

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef IEDIT_IEDIT_H
#include "DEV_IE:Include/IEditor.h"
#endif
#ifndef IEDIT_GENERATOR_H
#include "DEV_IE:Include/generatorlib.h"
#endif



/*********************
**   ExpanderBase   **
*********************/

struct Expander {
	struct Library          Lib;
	struct Node             Node;       /* node displayed in the Add   */
					    /* Gadget list                 */
	UBYTE                   Kind;       /* Kind of expander. See below */
	UBYTE                   Resizable;  /* can this object be resized? */
	UBYTE                   Movable;    /* can we be moved?            */
	UBYTE                   HasItems;   /* has items (like MX_KIND)?   */
	UBYTE                   UseFonts;   /* we use a font?              */
	UBYTE                   Reserved;   /* for future use              */
	UWORD                   Width;      /* fixed size. Used when       */
	UWORD                   Height;     /* Resizable = FALSE;          */
};


/*************************
**  Expander Kinds      **
*************************/

#define IEX_OBJECT_KIND     0       /* we add objects                      */
#define IEX_ATTRIBUTE_KIND  1       /* doesn't add objects, just attributes*/
#define IEX_AREXX_KIND      2       /* adds just ARexx commands            */
#define IEX_BOOPSI_KIND     3       /* adds BOOPSI objects                 */


/************************
**  BOOPSI Expanders   **
************************/

struct BOOPSIExp {
	struct Expander IEX;
	struct MinList  Tags;       /* list of BOOPSITag items      */
	UBYTE           BOOPSIType; /* see below                    */
};

/*  BOOPSI type */

#define BT_GADGET   0
#define BT_IMAGE    1


struct BOOPSITag {
	struct BOOPSITag   *Succ;
	struct BOOPSITag   *Pred;
	UBYTE               Type;   /* see below                    */
	UBYTE               Reserved;   /*  *** DON'T TOUCH !!! *** */
	STRPTR              Name;   /* ti_Tag name                  */
	ULONG               Value;  /* ti_Tag value                 */
	struct MinList      Items;  /* possible values for this tag */
};


/*  Tag types   */

#define TT_BYTE             0
#define TT_WORD             1
#define TT_LONG             2
#define TT_BYTE_PTR         3       /* ptr to byte or to array of bytes */
#define TT_WORD_PTR         4
#define TT_LONG_PTR         5
#define TT_STRING           6
#define TT_STRING_ARRAY     7
#define TT_STRING_LIST      8
#define TT_BOOL             9
#define TT_CHOOSE          10       /* choose the value from the list   */
#define TT_OBJECT          11       /* pointer to another BOOPSI object */
#define TT_USER_STRUCT     12       /* pointer to an user structure     */
#define TT_SCREEN          13       /* pointer to the screen used       */



/************************
**  Objects structure  **
************************/

/*
    This is the standard object structure. If your object should appear
    as any other IE gadget, then it MUST use a structure whose fields
    match these. Anyway, if your object has set Resizable = FALSE,
    Movable = FALSE and HasItems = FALSE, you can change the structure
    as you want, provided that the first three fields (o_Node, o_Kind,
    o_Flags) aren't taken away, otherwise IE could wonder what sort of
    object it has found in its list... ;-)

    NOTE WELL: the o_Node.ln_Type field is NOT to be touched by the
	       expander!
*/

struct ObjectInfo {
	struct  Node o_Node;
	UWORD   o_Kind;         /* fill with the ID passed by IE    */
	UBYTE   o_Flags;        /* used by IE                       */
				/* you can only check the G_ATTIVO  */
				/* bit (means that this object is   */
				/* selected)                        */
	UBYTE   o_Key;          /* if you're object has a selection */
				/* key you must put it here and     */
				/* increment the wi_NumKeys field   */
				/* of the gadget's window info      */
	struct TxtAttrNode *o_Font; /* if your object supports fonts*/
				/* here you'll find a ptr to a      */
				/* TxtAttrNode structure when the   */
				/* user selects Gadgets/Font...     */
	UBYTE   o_Title[80];    /* title  */
	UBYTE   o_Label[40];    /* label  */
	APTR    o_User1;        /* use it as you like               */
	WORD    o_Left;         /* this fields are updated by IE if */
	WORD    o_Top;          /* your object is resizable/movable */
	UWORD   o_Width;
	UWORD   o_Height;
	APTR    o_User2;        /* all these fields are for your    */
	APTR    o_User3;        /* use. If your object doesn't have */
	WORD    o_User4;        /* items (HasItems = FALSE) and you */
	APTR    o_User5;        /* don't need these fields, then    */
	APTR    o_User6;        /* allocate a shorter structure ;-) */
	APTR    o_User7;        /* But if you're object has items,  */
	APTR    o_User8;        /* you'll have to allocate them even*/
	APTR    o_User9;        /* if it's just a waste of memory,  */
	ULONG   o_User10[7];    /* for compatibility... :-|         */
	UWORD   o_NumItems;     /* num items if HasItems = TRUE     */
	struct MinList o_Items; /* item list                        */
};



/******************
**  Descriptors  **
******************/

struct Descriptor {
	UBYTE   Key;        /* character following '%' */
	STRPTR  Meaning;    /* the string that must be put instead of */
			    /* the formatting code                    */
};


/******************
**  Error codes  **
******************/


#define IEX_OK                  0
#define IEX_ERROR_NO_DESC_FILE  1   /* source descriptor file not found   */


#endif  /*  IEDIT_EXPANDER_H  */
