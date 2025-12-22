/*
** Demosource on how to use customclasses in E.
** Based on the C example 'Class1.c'.
** Translated to E by Jan Hendrik Schulz
*/

OPT PREPROCESS

MODULE 'muimaster', 'libraries/mui', 'libraries/muip',
       'tools/muicustomclass', 'amigalib/boopsi',
       'intuition/classes', 'intuition/classusr',
       'intuition/screens', 'intuition/intuition',
       'utility/tagitem'

/***************************************************************************/
/* Here is the beginning of our simple new class...                        */
/***************************************************************************/

/*
** This is an example for the simplest possible MUI class. It's just some
** kind of custom image and supports only two methods: 
** MUIM_AskMinMax and MUIM_Draw.
*/

/*
** This is the instance data for our custom class.
** Since it's a very simple class, it contains just a dummy entry.
*/

OBJECT mydata
    dummy:LONG
ENDOBJECT


/*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*/

PROC mAskMinMax(cl:PTR TO iclass,obj,msg:PTR TO muip_askminmax)

    /*
    ** let our superclass first fill in what it thinks about sizes.
    ** this will e.g. add the size of frame and inner spacing.
    */

    doSuperMethodA(cl,obj,msg)

    /*
    ** now add the values specific to our object. note that we
    ** indeed need to *add* these values, not just set them!
    */

    msg.minmaxinfo.minwidth := msg.minmaxinfo.minwidth + 100
    msg.minmaxinfo.defwidth := msg.minmaxinfo.defwidth + 120
    msg.minmaxinfo.maxwidth := msg.minmaxinfo.maxwidth + 500

    msg.minmaxinfo.minheight := msg.minmaxinfo.minheight + 40
    msg.minmaxinfo.defheight := msg.minmaxinfo.defheight + 90
    msg.minmaxinfo.maxheight := msg.minmaxinfo.maxheight + 300

ENDPROC 0


/*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*/

-> Note2: The following 'obj' isn't really a 'PTR TO mydata',
->        but obj must be a 'PTR TO <someobject>' to use the
->        macros like _mleft() etc. (see comments in mui.e)
->        I hope Wouter will change this in a futur version
->        of E !

PROC mDraw(cl:PTR TO iclass,obj:PTR TO mydata,msg:PTR TO muip_draw)

    DEF i

    /*
    ** let our superclass draw itself first, area class would
    ** e.g. draw the frame and clear the whole region. What
    ** it does exactly depends on msg.flags.
    */

    doSuperMethodA(cl,obj,msg)

    /*
    ** if MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
    ** MUI just wanted to update the frame or something like that.
    */

    IF (msg.flags AND MADF_DRAWOBJECT)=0 THEN RETURN 0

    /*
    ** ok, everything ready to render...
    */

    SetAPen(_rp(obj),_dri(obj).pens[TEXTPEN])

    FOR i:=_mleft(obj) TO _mright(obj) STEP 5
        Move(_rp(obj),_mleft(obj),_mbottom(obj))
        Draw(_rp(obj),i,_mtop(obj))
        Move(_rp(obj),_mright(obj),_mbottom(obj))
        Draw(_rp(obj),i,_mtop(obj))
    ENDFOR

ENDPROC 0


/*
** Here comes the dispatcher for our custom class. We only need to
** care about MUIM_AskMinMax and MUIM_Draw in this simple case.
** Unknown/unused methods are passed to the superclass immediately.
*/

PROC myDispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
    DEF methodID

    methodID:=msg.methodid
    SELECT methodID
        CASE MUIM_AskMinMax; RETURN mAskMinMax(cl,obj,msg)
        CASE MUIM_Draw     ; RETURN mDraw     (cl,obj,msg)
    ENDSELECT

    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC



/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main() HANDLE

    DEF app=NIL,window,myobj,sigs=0,
        mcc=NIL:PTR TO mui_customclass

    IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
        Raise('Failed to open muimaster.library')

    /* Create the new custom class with a call to eMui_CreateCustomClass().*/

    IF (mcc:=eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF mydata,{myDispatcher}))=NIL THEN
        Raise('Could not create custom class.')

    app:=ApplicationObject,
        MUIA_Application_Title      , 'Class1',
        MUIA_Application_Version    , '$VER: Class1 12.9E (26.11.95)',
        MUIA_Application_Copyright  , '©1993, Stefan Stuntz',
        MUIA_Application_Author     , 'Stefan Stuntz & JHS',
        MUIA_Application_Description, 'Demonstrate the use of custom classes.',
        MUIA_Application_Base       , 'CLASS1',

        SubWindow, window := WindowObject,
            MUIA_Window_Title, 'A Simple Custom Class',
            MUIA_Window_ID   , "CLS1",
            WindowContents, VGroup,

                Child, myobj := NewObjectA(mcc.mcc_class,NIL,
                    [TextFrame,
                    MUIA_Background, MUII_BACKGROUND,
                   End,
                End,
            End,
        End

    IF app=NIL THEN Raise('Failed to create Application.')

    doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
              app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

    set(window,MUIA_Window_Open,MUI_TRUE)

    WHILE Not(doMethodA(app,[MUIM_Application_NewInput,{sigs}]) = MUIV_Application_ReturnID_Quit)
        IF sigs THEN sigs := Wait(sigs)
    ENDWHILE

    set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

EXCEPT DO
    IF app THEN Mui_DisposeObject(app)                /* dispose all objects. */
    IF mcc THEN Mui_DeleteCustomClass(mcc)            /* delete the custom class. */
    IF muimasterbase THEN CloseLibrary(muimasterbase) /* close library */
    IF exception THEN WriteF('\s\n',exception)
ENDPROC

