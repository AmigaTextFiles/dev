*/
CONST MUIA_Group_Columns                  = $8042f416 /* V4  is. LONG              */
CONST MUIA_Group_Horiz                    = $8042536b /* V4  i.. BOOL              */
CONST MUIA_Group_HorizSpacing             = $8042c651 /* V4  is. LONG              */
CONST MUIA_Group_LayoutHook               = $8042c3b2 /* V11 i.. struct Hook *     */
CONST MUIA_Group_PageMode                 = $80421a5f /* V5  i.. BOOL              */
CONST MUIA_Group_Rows                     = $8042b68f /* V4  is. LONG              */
CONST MUIA_Group_SameHeight               = $8042037e /* V4  i.. BOOL              */
CONST MUIA_Group_SameSize                 = $80420860 /* V4  i.. BOOL              */
CONST MUIA_Group_SameWidth                = $8042b3ec /* V4  i.. BOOL              */
CONST MUIA_Group_Spacing                  = $8042866d /* V4  is. LONG              */
CONST MUIA_Group_VertSpacing              = $8042e1bf /* V4  is. LONG              */

CONST MUIV_Group_ActivePage_First   =  0
CONST MUIV_Group_ActivePage_Last    = -1
CONST MUIV_Group_ActivePage_Prev    = -2
CONST MUIV_Group_ActivePage_Next    = -3
CONST MUIV_Group_ActivePage_Advance = -4


/****************************************************************************/
/** Mccprefs                                                               **/
/****************************************************************************/

#define MUIC_Mccprefs 'Mccprefs.mui'


/****************************************************************************/
/** Register                                                               **/
/****************************************************************************/

#define MUIC_Register 'Register.mui'

/* Attributes */

CONST MUIA_Register_Frame                 = $8042349b /* V7  i.g BOOL              */
CONST MUIA_Register_Titles                = $804297ec /* V7  i.g STRPTR *          */



/****************************************************************************/
/** Settingsgroup                                                          **/
/****************************************************************************/

#define MUIC_Settingsgroup 'Settingsgroup.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Settings                                                               **/
/****************************************************************************/

#define MUIC_Settings 'Settings.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Frameadjust                                                            **/
/****************************************************************************/

#define MUIC_Frameadjust 'Frameadjust.mui'

/* Methods */


/* Attributes */




/****************************************************************************/
/** Penadjust                                                              **/
/****************************************************************************/

#define MUIC_Penadjust 'Penadjust.mui'

/* Methods */


/* Attributes */

CONST MUIA_Penadjust_PSIMode              = $80421cbb /* V11 i.. BOOL              */



/****************************************************************************/
/** Imageadjust                                                            **/
/****************************************************************************/

#define MUIC_Imageadjust 'Imageadjust.mui'

/* Methods */


/* Attributes */


CONST MUIV_Imageadjust_Type_All = 0
CONST MUIV_Imageadjust_Type_Image = 1
CONST MUIV_Imageadjust_Type_Background = 2
CONST MUIV_Imageadjust_Type_Pen = 3


/****************************************************************************/
/** Virtgroup                                                              **/
/****************************************************************************/

#define MUIC_Virtgroup 'Virtgroup.mui'

/* Methods */


/* Attributes */

CONST MUIA_Virtgroup_Height               = $80423038 /* V6  ..g LONG              */
CONST MUIA_Virtgroup_Input                = $80427f7e /* V11 i.. BOOL              */
CONST MUIA_Virtgroup_Left                 = $80429371 /* V6  isg LONG              */
CONST MUIA_Virtgroup_Top                  = $80425200 /* V6  isg LONG              */
CONST MUIA_Virtgroup_Width                = $80427c49 /* V6  ..g LONG              */



/****************************************************************************/
/** Scrollgroup                                                            **/
/****************************************************************************/

#define MUIC_Scrollgroup 'Scrollgroup.mui'

/* Methods */


/* Attributes */

CONST MUIA_Scrollgroup_Contents           = $80421261 /* V4  i.. Object *          */
CONST MUIA_Scrollgroup_FreeHoriz          = $804292f3 /* V9  i.. BOOL              */
CONST MUIA_Scrollgroup_FreeVert           = $804224f2 /* V9  i.. BOOL              */
CONST MUIA_Scrollgroup_UseWinBorder       = $804284c1 /* V13 i.. BOOL              */



/****************************************************************************/
/** Scrollbar                                                              **/
/****************************************************************************/

#define MUIC_Scrollbar 'Scrollbar.mui'

/* Attributes */

CONST MUIA_Scrollbar_Type                 = $8042fb6b /* V11 i.. LONG              */

CONST MUIV_Scrollbar_Type_Default = 0
CONST MUIV_Scrollbar_Type_Bottom = 1
CONST MUIV_Scrollbar_Type_Top = 2
CONST MUIV_Scrollbar_Type_Sym = 3


/*********************************