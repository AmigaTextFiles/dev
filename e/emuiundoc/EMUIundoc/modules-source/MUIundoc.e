/***************************************************************************
** The Hacker's include to MUI v1.8 :-)
**
** Copyright 1997-98 by Alessandro Zummo
** azummo@ita.flashnet.it
**
** Translated to AmigaE at 01/1999 by Rene Zimmerling
**
** This include is unofficial, use at your own risk!
**
** You can also find other undocumented tags in emodules:libraries/mui.m :-)
**
****************************************************************************
** Class Tree
****************************************************************************
**
** rootclass                   (BOOPSI's base class)
** +--Notify                   (implements notification mechanism)
** !  +--Area                  (base class for all GUI elements)
** !     +--Framedisplay       (displays frame specification)
** !     !  \--Popframe        (popup button to adjust a frame spec)
** !     +--Imagedisplay       (displays image specification)
** !     !  \--Popimage        (popup button to adjust an image spec)
** !     +--Pendisplay         (displays a pen specification)
** !     !  \--Poppen          (popup button to adjust a pen spec)
** !     +--Group              (groups other GUI elements)
** !        +--Register        (handles page groups with titles)
** !        !  \--Penadjust    (group to adjust a pen)
** !        +--Frameadjust     (group to adjust a frame)
** !        +--Imageadjust     (group to adjust an image)
**
*/

OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'libraries/mui','graphics/gfx'

-> Uncomment this if you want be able to use all the undocumented features
-> But remember to modify your libraries/mui.h include

/*************************************************************************
** Black box specification structures for images, pens, frames            
*************************************************************************/

/* Defined in mui.m */

-> OBJECT mui_penspec
->    buf[32]:ARRAY OF CHAR
-> ENDOBJECT

OBJECT mui_imagespec
   buf[64]:ARRAY OF CHAR
ENDOBJECT

OBJECT mui_framespec
   buf[32]:ARRAY OF CHAR
ENDOBJECT

-> I'm not sure if MUI_ImageSpec and MUI_FrameSpec are 32 or 64 bytes wide.

/*************************************************************************
** The real MUI_NotifyData structure
*************************************************************************/

-> OBJECT mui_notifydata
->    mnd_globalinfo:ARRAY OF mui_globalinfo
->    mnd_userdata:LONG
->    mnd_objectid:LONG
->    priv1:LONG
->    mnd_parentobject:PTR TO obj
->    priv3:LONG
->    priv4:LONG
-> ENDOBJECT

-> #define _parent(obj) muinotifydata(obj)->mnd_parentobject

-> #define _parent(obj) xget(obj,muia_parent)

-> The use of _parent(obj) macro is strictly forbidden! Use xget(obj,MUIA_Parent) instead.

/****************************************************************************/
/** Flags                                                                  **/
/****************************************************************************/

#define MADF_OBJECTVISIBLE     Shl(1,14) // The object is visible
#define MUIMRI_INVIRTUALGROUP  Shl(1,29) // The object is inside a virtual group
#define MUIMRI_ISVIRTUALGROUP  Shl(1,30) // The object is a virtual group


/****************************************************************************/
/** Crawling                                                               **/
/****************************************************************************/

#define MUIC_Crawling "Crawling.mcc"
#define CrawlingObject MUI_NewObject(MUIC_Crawling

/****************************************************************************/
/** Application                                                            **/
/****************************************************************************/

/* Attributes */

#define MUIA_Application_UsedClasses   $8042E9A7 /* V20 (!) */


/****************************************************************************/
/** Window                                                                 **/
/****************************************************************************/

/* Methods */

#define MUIM_Window_ActionIconify $80422cc0 /* V18 */
#define MUIM_Window_Cleanup       $8042ab26 /* Custom Class */ /* V18 */
#define MUIM_Window_Setup         $8042c34c /* Custom Class */ /* V18 */

#define MUIP_Window_Cleanup       (methodid:LONG) /* Custom Class */
#define MUIP_Window_Setup         (methodid:LONG) /* Custom Class */

/* Attributes */

#define MUIA_Window_DisableKeys   $80424c36 /* V15 isg ULONG */


/****************************************************************************/
/** Area                                                                   **/
/****************************************************************************/

/* Methods */

#define MUIM_DoDrag          $804216bb /* V18 */ /* Custom Class */
#define MUIM_CreateDragImage $8042eb6f /* V18 */ /* Custom Class */
#define MUIM_DeleteDragImage $80423037 /* V18 */ /* Custom Class */
#define MUIM_GoActive        $8042491a
#define MUIM_GoInactive      $80422c0c
#define MUIM_CustomBackfill  $80428d73

#define MUIP_CustomBackfill  (methodid:LONG,left:LONG,top:LONG,right:LONG,bottom:LONG,xoffset:LONG,yoffset:LONG)
#define MUIP_DeleteDragImage (methodid:LONG,di:mui_dragimage)
#define MUIP_CreateDragImage (methodid:LONG,touchx:LONG,touchy:LONG,flags:LONG) /* Custom Class */
#define MUIP_DoDrag          (methodid:LONG,touchx:LONG,touchy:LONG,flags:LONG) /* Custom Class */

/* Attributes */

#define MUIA_CustomBackfill  $80420a63

#define MUIV_CreateBubble_DontHidePointer Shl(1,0)

OBJECT mui_dragimage
   bm:PTR TO bitmap
   width:INT           /* exact width and height of bitmap */
   height:INT
   touchx:INT          /* position of pointer click relative to bitmap */
   touchy:INT
   flags:LONG          /* must be set to 0 */
ENDOBJECT

/****************************************************************************/
/** Imagedisplay                                                           **/
/****************************************************************************/

/* Attributes */

#define MUIA_Imagedisplay_Spec $8042a547 /* V11 isg struct MUI_ImageSpec * */


/****************************************************************************/
/** Imageadjust                                                            **/
/****************************************************************************/

/* Attributes */

#define MUIA_Imageadjust_Type  $80422f2b /* V11 i.. LONG */


/****************************************************************************/
/** Framedisplay                                                           **/
/****************************************************************************/

/* Attributes */

#define MUIA_Framedisplay_Spec $80421794 /* isg struct MUI_FrameSpec * */


/****************************************************************************/
/** Prop                                                                   **/
/****************************************************************************/

/* Attributes */

#define MUIA_Prop_DeltaFactor $80427c5e /* V4 .s. LONG */
#define MUIA_Prop_DoSmooth    $804236ce /* V4 i.. LONG */
#define MUIA_Prop_Release     $80429839 /* V? g BOOL */ /* private */
#define MUIA_Prop_Pressed     $80422cd7 /* V6 g BOOL */ /* private */


/****************************************************************************/
/** Group                                                                  **/
/****************************************************************************/

/* Attributes */

#define MUIA_Group_Forward    $80421422 /* V11 .s. BOOL */

/****************************************************************************/
/** List                                                                   **/
/****************************************************************************/

/* Attributes */

#define MUIA_List_Prop_Entries  $8042a8f5 /* V? ??? */
#define MUIA_List_Prop_Visible  $804273e9 /* V? ??? */
#define MUIA_List_Prop_First    $80429df3 /* V? ??? */


/****************************************************************************/
/** Text                                                                   **/
/****************************************************************************/

/* Attributes */

#define MUIA_Text_HiCharIdx   $804214f5


/****************************************************************************/
/** Dtpic                                                                  **/
/****************************************************************************/

/* Attributes */

#define MUIA_Dtpic_Name $80423d72

