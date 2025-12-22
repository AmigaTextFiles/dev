/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

/*
** This program needs at least V39 include files !
*/

OPT PREPROCESS

MODULE 'muimaster','libraries/mui','libraries/muip',
       'mui/muicustomclass','amigalib/boopsi',
       'intuition/classes','intuition/classusr',
       'intuition/screens','intuition/intuition',
       'utility/tagitem',
       'gadgets/colorwheel','colorwheel',
       'intuition/icclass','intuition/gadgetclass'

/*
** Gauge object macro to display colorwheels
** hue and saturation values.
*/

#define InfoGauge GaugeObject,\
  GaugeFrame    , \
  MUIA_Background  , MUII_BACKGROUND,\
  MUIA_Gauge_Max   , 16384,\
  MUIA_Gauge_Divide, 262144,\
  MUIA_Gauge_Horiz , MUI_TRUE,\
  End


PROC main() HANDLE

  DEF app,window,wheel,hue,sat,sigs=0
  
  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN 
    Raise('Failed to open muimaster.library')
  IF  (colorwheelbase:=OpenLibrary('gadgets/colorwheel.gadget',0))=NIL THEN
    Raise('colorwheel boopsi gadget not available')
  app:= ApplicationObject,
    MUIA_Application_Title      , 'BoopsiDoor',
    MUIA_Application_Version    , '$VER: BoopsiDoor 14.19 (21.02.96)',
    MUIA_Application_Copyright  , 'c1992/93, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Show a boopsi colorwheel with MUI.',
    MUIA_Application_Base       , 'BOOPSIDOOR',
    SubWindow, window:= WindowObject,
      MUIA_Window_Title, 'BoopsiDoor',
      MUIA_Window_ID   , "BOOP",
      WindowContents, VGroup,
        Child, ColGroup(2),
          Child, Label('Hue:'       ), Child, hue:= InfoGauge,
          Child, Label('Saturation:'), Child, sat:= InfoGauge,
          Child, RectangleObject,MUIA_Weight,0,End, Child, ScaleObject, End,
        End,
        Child, wheel:= BoopsiObject,  /* MUI and Boopsi tags mixed */
          GroupFrame,
          MUIA_Boopsi_ClassID  , 'colorwheel.gadget',
          MUIA_Boopsi_MinWidth , 30, /* boopsi objects don't know */
          MUIA_Boopsi_MinHeight, 30, /* their sizes, so we help   */
          MUIA_Boopsi_Remember , WHEEL_SATURATION, /* keep important values */
          MUIA_Boopsi_Remember , WHEEL_HUE,        /* during window resize  */
          MUIA_Boopsi_TagScreen, WHEEL_SCREEN, /* this magic fills in */
          WHEEL_SCREEN         , NIL,         /* the screen pointer  */
          GA_LEFT     , 0,
          GA_TOP      , 0, /* MUI will automatically     */
          GA_WIDTH    , 0, /* fill in the correct values */
          GA_HEIGHT   , 0,
          ICA_TARGET  , ICTARGET_IDCMP, /* needed for notification */
          WHEEL_SATURATION, 0, /* start in the center */
          MUIA_FillArea, MUI_TRUE, /* use this because it defaults to FALSE
                                  for boopsi gadgets but the colorwheel
                                  doesnt bother about redrawing its background */
        End,
      End,
    End,
  End

  IF app=NIL THEN Raise('Failed to create Application.')

/*
** you can react on every boopsi notification
** event as on any other MUI attribute.
*/

  doMethodA(wheel,[MUIM_Notify,WHEEL_HUE       ,MUIV_EveryTime,hue,4,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])
  doMethodA(wheel,[MUIM_Notify,WHEEL_SATURATION,MUIV_EveryTime,sat,4,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])

  doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

  set(window,MUIA_Window_Open,MUI_TRUE)

  WHILE doMethodA(app,[MUIM_Application_NewInput,{sigs}])<> MUIV_Application_ReturnID_Quit
    IF sigs THEN sigs:=Wait(sigs)
  ENDWHILE
  set(window,MUIA_Window_Open,FALSE)

/*
** shut down.
*/

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)
  IF colorwheelbase THEN CloseLibrary(colorwheelbase)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n',exception)
ENDPROC
