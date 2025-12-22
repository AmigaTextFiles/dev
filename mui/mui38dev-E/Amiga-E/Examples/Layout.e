/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/


OPT PREPROCESS

MODULE 'tools/installhook'
MODULE 'muimaster','libraries/mui','libraries/muip',
       'mui/muicustomclass','amigalib/boopsi',
       'intuition/classes','intuition/classusr',
       'intuition/screens','intuition/intuition',
       'utility/hooks','utility/tagitem','utility',
       'exec/lists'


CONST ID_REWARD = 1
DEF lastnum =-1

/*
** Custom layout function.
** Perform several actions according to the messages lm_Type
** field. Note that you must return MUILM_UNKNOWN if you do
** not implement a specific lm_Type.
*/

PROC layoutFunc(h:PTR TO hook,obj:PTR TO object,lm:PTR TO mui_layoutmsg)
  DEF type,cstate:PTR TO object,child:PTR TO object,maxminwidth=0,maxminheight=0,
      mw,mh,l,t
  type:=lm.lm_type
  SELECT type
    CASE MUILM_MINMAX
      /*
      ** MinMax calculation function. When this is called,
      ** the children of your group have already been asked
      ** about their min/max dimension so you can use their
      ** dimensions to calculate yours.
      **
      ** In this example, we make our minimum size twice as
      ** big as the biggest child in our group.
      */

      cstate := lm.lm_children.head

      /* find out biggest widths & heights of our children */

      WHILE (child := NextObject({cstate}))
        IF ( (maxminwidth <MUI_MAXMAX) AND (_minwidth(child) > maxminwidth)) THEN maxminwidth  := _minwidth(child)
        IF ( (maxminheight<MUI_MAXMAX) AND (_minheight(child) > maxminheight)) THEN maxminheight := _minheight(child)
      ENDWHILE

      /* set the result fields in the message */

      lm.lm_minmax.minwidth  := 2*maxminwidth
      lm.lm_minmax.minheight := 2*maxminheight
      lm.lm_minmax.defwidth  := 4*maxminwidth
      lm.lm_minmax.defheight := 4*maxminheight
      lm.lm_minmax.maxwidth  := MUI_MAXMAX
      lm.lm_minmax.maxheight := MUI_MAXMAX

      RETURN (0)

    CASE MUILM_LAYOUT
      /*
      ** Layout function. Here, we have to call MUI_Layout() for each
      ** our children. MUI wants us to place them in a rectangle
      ** defined by (0,0,lm->lm_Layout.Width-1,lm->lm_Layout.Height-1)
      ** You are free to put the children anywhere in this rectangle.
      **
      ** If you are a virtual group, you may also extend
      ** the given dimensions and place your children anywhere. Be sure
      ** to return the dimensions you need in lm->lm_Layout.Width and
      ** lm->lm_Layout.Height in this case.
      **
      ** Return TRUE if everything went ok, FALSE on error.
      ** Note: Errors during layout are not easy to handle for MUI.
      **       Better avoid them!
      */

      cstate := lm.lm_children.head

      WHILE (child := NextObject({cstate}))
        mw := _minwidth (child)
        mh := _minheight(child)
        l  := Rnd(lm.lm_layout.width - mw)
        t  := Rnd(lm.lm_layout.height - mh)

        IF (Mui_Layout(child,l,t,mw,mh,0))=NIL THEN
          RETURN (FALSE)
      ENDWHILE

      RETURN (MUI_TRUE)
  ENDSELECT
ENDPROC (MUILM_UNKNOWN)


PROC pressFunc(app:PTR TO object,num:PTR TO LONG)
 lastnum++
 IF (lastnum<>num[])
   DisplayBeep(0)
   lastnum := -1
 ELSEIF (lastnum=7)
   doMethodA(app,[MUIM_Application_ReturnID,ID_REWARD])
   lastnum := -1
 ENDIF
ENDPROC

PROC main() HANDLE
  DEF app,window,signals,running=TRUE,i,result
  DEF b[8]:ARRAY OF LONG,yeah,b0,b1,b2,b3,b4,b5,b6,b7
  DEF layoutHook:hook
  DEF pressHook:hook

  installhook(layoutHook,{layoutFunc})
  installhook(pressHook,{pressFunc})

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN
    Raise('Failed to open muimaster.library')

  randomize() -> I use a randomize-routine by (C) Martin F. Combs

  app := ApplicationObject,
    MUIA_Application_Title      , 'Layout',
    MUIA_Application_Version    , '$VER: Layout 13.56 (30.01.96)',
    MUIA_Application_Copyright  , '©1993, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Demonstrate custom layout hooks.',
    MUIA_Application_Base       , 'Layout',
    SubWindow, window := WindowObject,
      MUIA_Window_Title, 'Custom Layout',
      MUIA_Window_ID   , "CLS3",
      WindowContents, VGroup,
        Child, TextObject,
          TextFrame,
          MUIA_Background, MUII_TextBack,
          MUIA_Text_Contents, '\ecDemonstration of a custom layout hook.\nSince it\as usually no good idea to have overlapping\nobjects, your hooks should be more sophisticated.',
        End,
        Child, VGroup,
          GroupFrame,
          MUIA_Group_LayoutHook,layoutHook,
          Child, b0 := SimpleButton('Click'),
          Child, b1 := SimpleButton('me'),
          Child, b2 := SimpleButton('in'),
          Child, b3 := SimpleButton('correct'),
          Child, b4 := SimpleButton('sequence'),
          Child, b5 := SimpleButton('to'),
          Child, b6 := SimpleButton('be'),
          Child, b7 := SimpleButton('rewarded!'),
          Child, yeah := SimpleButton('Yeah!\nYou did it!\nClick to quit!'),
        End,
      End,
    End,
  End

  IF (app=NIL) THEN
    Raise('Failed to create Application.')

  doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  doMethodA(yeah,[MUIM_Notify,MUIA_Pressed,FALSE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
  b[0]:=b0
  b[1]:=b1
  b[2]:=b2
  b[3]:=b3
  b[4]:=b4
  b[5]:=b5
  b[6]:=b6
  b[7]:=b7

  FOR i:=0 TO 7
    doMethodA(b[i],[MUIM_Notify,MUIA_Pressed,FALSE,
      app,3,MUIM_CallHook,pressHook,i])
  ENDFOR
  set(yeah,MUIA_ShowMe,FALSE)


/*
** Input loop...
*/

  set(window,MUIA_Window_Open,MUI_TRUE)

  WHILE (running)
    result:=doMethodA(app,[MUIM_Application_Input,{signals}])
    SELECT result
      CASE MUIV_Application_ReturnID_Quit
        running := FALSE
      CASE ID_REWARD
        set(yeah,MUIA_ShowMe,MUI_TRUE)
    ENDSELECT
    IF (running AND signals) THEN Wait(signals)
  ENDWHILE

  set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)    /* dispose all objects. */
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n',exception)
ENDPROC

/*
**  randomize
**      by
**  Martin F. Combs
**
*/

PROC randomize()
DEF i, currentsecs, currentmicros, seed
  CurrentTime({currentsecs},{currentmicros})
  seed:=-currentmicros
  FOR i:=0 TO currentsecs AND $FF DO seed:=RndQ(seed)
  IF seed<0 THEN Rnd(seed) ELSE Rnd(-seed)
ENDPROC seed

