// $Id: myimagegclass.h,v 1.12 94/01/11 03:01:12 rick Exp Locker: rick $
/* Prototypes for functions defined in
myimagegclass.c
 */

void Free_myimagegclass(Class * );

Class * Init_myimagegclass(void);

// Attribute Tags
#define GA_ScaleFlags      (TAG_USER+1)
#define GA_ScaleRelWidth   (TAG_USER+2)
#define GA_ScaleRelHeight  (TAG_USER+3)
#define GA_MUIRemember     (TAG_USER+4)

// GA_ScaleFlags flags
#define GAFL_ScaleX        (1<<0)   // scale dimension
#define GAFL_ScaleY        (1<<1)
#define GAFL_RelX          (1<<2)   // relative scale dimension
#define GAFL_RelY          (1<<3)   // (relative to GA_ScaleRelWidth & GA_ScaleRelHeight
#define GAFL_AspectRatio   (1<<4)   // preserve pixel aspect ratio
// useful combinations
#define GAFL_ScaleXY          (GAFL_ScaleX|GAFL_ScaleY)
#define GAFL_RelXY            (GAFL_RelX|GAFL_RelY)
#define GAFL_ScaleRelX        (GAFL_ScaleX|GAFL_RelX)
#define GAFL_ScaleRelY        (GAFL_ScaleY|GAFL_RelY)
#define GAFL_ScaleRelXY       (GAFL_ScaleRelX|GAFL_ScaleRelY)
#define GAFL_ScaleXYAspect    (GAFL_ScaleXY|GAFL_AspectRatio)
#define GAFL_ScaleRelXYAspect (GAFL_ScaleRelXY|GAFL_AspectRatio)

#ifdef LIBRARIES_MUI_H
#ifndef MUI_NOSHORTCUTS
#define MyImage(minWidth,minHeight,image,returnID)\
   BoopsiObject,\
      MUIA_Boopsi_Class, myimagegclass,\
      MUIA_Boopsi_MinWidth , minWidth,\
      MUIA_Boopsi_MinHeight, minHeight,\
      MUIA_Boopsi_Remember, GA_MUIRemember,\
      GA_Image, image,\
      GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0,\
      GA_ID, returnID,\
      ICA_TARGET  , ICTARGET_IDCMP,\
      End
#define MyImageScaled(minWidth,minHeight,image,returnID,flags)\
   BoopsiObject,\
      MUIA_Boopsi_Class, myimagegclass,\
      MUIA_Boopsi_MinWidth , minWidth,\
      MUIA_Boopsi_MinHeight, minHeight,\
      MUIA_Boopsi_Remember, GA_MUIRemember,\
      GA_Image, image,\
      GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0,\
      GA_ID, returnID,\
      GA_ScaleFlags, flags,\
      ICA_TARGET  , ICTARGET_IDCMP,\
      End
#define MyImageScaledRel(minWidth,minHeight,image,returnID,flags,relWidth,relHeight)\
   BoopsiObject,\
      MUIA_Boopsi_Class, myimagegclass,\
      MUIA_Boopsi_MinWidth , minWidth,\
      MUIA_Boopsi_MinHeight, minHeight,\
      MUIA_Boopsi_Remember, GA_MUIRemember,\
      GA_Image, image,\
      GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0,\
      GA_ID, returnID,\
      GA_ScaleFlags, flags,\
      GA_ScaleRelWidth, relWidth,\
      GA_ScaleRelHeight, relHeight,\
      ICA_TARGET  , ICTARGET_IDCMP,\
      End
#define MyImageBorder(minWidth,minHeight,image,returnID)\
   BoopsiObject,\
      TextFrame,\
      MUIA_Boopsi_Class, myimagegclass,\
      MUIA_Boopsi_MinWidth , minWidth,\
      MUIA_Boopsi_MinHeight, minHeight,\
      MUIA_Boopsi_Remember, GA_MUIRemember,\
      GA_Image, image,\
      GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0,\
      GA_ID, returnID,\
      ICA_TARGET  , ICTARGET_IDCMP,\
      End
#define MyImageScaledBorder(minWidth,minHeight,image,returnID,flags)\
   BoopsiObject,\
      TextFrame,\
      MUIA_Boopsi_Class, myimagegclass,\
      MUIA_Boopsi_MinWidth , minWidth,\
      MUIA_Boopsi_MinHeight, minHeight,\
      MUIA_Boopsi_Remember, GA_MUIRemember,\
      GA_Image, image,\
      GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0,\
      GA_ID, returnID,\
      GA_ScaleFlags, flags,\
      ICA_TARGET  , ICTARGET_IDCMP,\
      End
#define MyImageScaledRelBorder(minWidth,minHeight,image,returnID,flags,relWidth,relHeight)\
   BoopsiObject,\
      TextFrame,\
      MUIA_Boopsi_Class, myimagegclass,\
      MUIA_Boopsi_MinWidth , minWidth,\
      MUIA_Boopsi_MinHeight, minHeight,\
      MUIA_Boopsi_Remember, GA_MUIRemember,\
      GA_Image, image,\
      GA_Left,0,GA_Top,0,GA_Width,0,GA_Height,0,\
      GA_ID, returnID,\
      GA_ScaleFlags, flags,\
      GA_ScaleRelWidth, relWidth,\
      GA_ScaleRelHeight, relHeight,\
      ICA_TARGET  , ICTARGET_IDCMP,\
      End
#define NotifyFromMyImage(obj,id)\
   DoMethod(obj,MUIM_Notify,GA_ID,id,app,2,MUIM_Application_ReturnID,id)
#endif
#endif
