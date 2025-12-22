/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

OPT PREPROCESS

MODULE 'utility/tagitem'
MODULE 'libraries/gadtools'
MODULE 'muimaster','libraries/mui','libraries/muip',
       'mui/muicustomclass','amigalib/boopsi',
       'intuition/classes','intuition/classusr',
       'intuition/screens','intuition/intuition'

/*
** We want our images displayed in a group with five columns.
*/

#define cols 4
#define startimg 11

/*
** This is a image object at its standard size.
*/

#define FixedImg(x) ImageObject,\
  ButtonFrame,\
  MUIA_InputMode, MUIV_InputMode_RelVerify,\
  MUIA_Image_FreeHoriz, FALSE,\
  MUIA_Image_FreeVert, FALSE,\
  MUIA_Image_Spec, x,\
  MUIA_Background, MUII_BACKGROUND,\
  End


/*
** This is a resizable image.
** Since the user might have configured a fixed size image,
** we need to enclose our image in groups of spacing objects
** to make it centered. The spacing objects have a very little
** weight, so the images will get every pixel they want.
*/

#define sp            RectangleObject, MUIA_Weight, 1, End
#define hcenter(obj)  HGroup, Child, sp, Child, obj, Child, sp, End
#define vcenter(obj)  VGroup, Child, sp, Child, obj, Child, sp, End
#define hvcenter(obj) hcenter(vcenter(obj))

#define FreeImg(x) hcenter(vcenter(xFreeImg(x)))

#define xFreeImg(x) ImageObject,\
  ButtonFrame,\
  MUIA_InputMode, MUIV_InputMode_RelVerify,\
  MUIA_Image_FreeHoriz, MUI_TRUE,\
  MUIA_Image_FreeVert, MUI_TRUE,\
  MUIA_Image_Spec, x,\
  MUIA_Background, MUII_BACKGROUND,\
  End

PROC main() HANDLE
  DEF signal, app, wi_Master
  DEF fixGroup,freeGroup,i

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN
    Raise('failed to open muimaster.library')

  /*
  ** Create the application.
  ** Note that we generate two empty groups without children.
  ** These children will be added later with OM_ADDMEMBER.
  */

  app := ApplicationObject,
    MUIA_Application_Title      , 'ShowImg',
    MUIA_Application_Version    , '$VER: ShowImg 10.11 (23.12.94)',
    MUIA_Application_Copyright  , 'c1992/93, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Show MUI standard images',
    MUIA_Application_Base       , 'SHOWIMG',
    SubWindow, wi_Master := WindowObject,
      MUIA_Window_ID, "MAIN",
      MUIA_Window_Title, 'MUI Standard Images',
      WindowContents, HGroup,
        Child, VGroup,
          Child, VSpace(0),
          Child, fixGroup := ColGroup(cols), GroupFrameT('Minimum Size'), End,
          Child, VSpace(0),
        End,
        Child, freeGroup := ColGroup(cols), GroupFrameT('Free Size'), End,
      End,
    End,
  End

  IF app=NIL THEN Raise('Failed to create Application.')

  /*
  ** No we insert the image elements in our groups.
  */

  FOR i:=0 TO MUII_Count-startimg-1
    doMethodA(fixGroup,[OM_ADDMEMBER,FixedImg(i+startimg)])
    doMethodA(freeGroup,[OM_ADDMEMBER,FreeImg(i+startimg)])
  ENDFOR

  /*
  ** Append some empty objects to make our columnized
  ** group contain exactly cols*rows elements.
  */

  WHILE (Mod(i,cols))
    doMethodA(fixGroup,[OM_ADDMEMBER,HVSpace])
    doMethodA(freeGroup,[OM_ADDMEMBER,HVSpace])
    i++
  ENDWHILE

  /*
  ** Simplest possible MUI input loop.
  */

  doMethodA(wi_Master,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
    
  set(wi_Master,MUIA_Window_Open,MUI_TRUE)

  WHILE (doMethodA(app,[MUIM_Application_Input,{signal}]) <> MUIV_Application_ReturnID_Quit)
    IF (signal) THEN Wait(signal)
  ENDWHILE
  
  set(wi_Master,MUIA_Window_Open,FALSE)

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n',exception)
ENDPROC

