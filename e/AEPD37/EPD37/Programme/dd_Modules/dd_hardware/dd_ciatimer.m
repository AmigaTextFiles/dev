             TAG_DONE])

#define Child             MUIA_Group_Child
#define SubWindow         MUIA_Application_Window
#define WindowContents    MUIA_Window_RootObject



/***************************************************************************
**
** Frame Types
** -----------
**
** These macros may be used to specify one of MUI's different frame types.
** Note that every macro consists of one { ti_Tag, ti_Data } pair.
**
** GroupFrameT() is a special kind of frame that contains a centered
** title text.
**
** HGroup, GroupFrameT('Horiz Groups'),
**    Child, RectangleObject, TextFrame  , End,
**    Child, RectangleObject, StringFrame, End,
**    Child, RectangleObject, ButtonFrame, End,
**    Child, RectangleObject, ListFrame  , End,
**    End,
**
***************************************************************************/

#define NoFrame          MUIA_Frame, MUIV_Frame_None
#define ButtonFrame      MUIA_Frame, MUIV_Frame_Button
#define ImageButtonFrame MUIA_Frame, MUIV_Frame_ImageButton
#define TextFrame        MUIA_Frame, MUIV_Frame_Text
#define StringFrame      MUIA_Frame, MUIV_Frame_String
#define ReadListFrame    MUIA_Frame, MUIV_Frame_ReadList
#define InputListFrame   MUIA_Frame, MUIV_Frame_InputList
#define PropFrame        MUIA_Frame, MUIV_Frame_Prop
#define SliderFrame      MUIA_Frame, MUIV_Frame_Slider
#define GaugeFrame       MUIA_Frame, MUIV_Frame_Gauge
#define VirtualFrame     MUIA_Frame, MUIV_Frame_Virtual
#define GroupFrame       MUIA_Frame, MUIV_Frame_Group
#define GroupFrameT(s)   MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s



/***************************************************************************
**
** Spacing Macros
** --------------
**
***************************************************************************/

#define HVSpace           Mui_NewObjectA(MUIC_Rectangle,[TAG_DONE])
#define HSpace(x)         Mui_MakeObjectA(MUIO_HSpace,[x])
#define VSpace(x)         Mui_MakeObjectA(MUIO_VSpace,[x])
#define HCenter(obj)      HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End
#define VCenter(obj)      VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End
#define InnerSpacing(h,v) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x)   MUIA_Group_Spacing,x



#ifdef MUI_OBSOLETE

/***************************************************************************
**
** String-Object
** -------------
**
** The following macro creates a simple string gadget.
**
***************************************************************************/

#define StringMUI(contents,maxlen)\
        StringObject,\
                StringFrame,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#define KeyString(contents,maxlen,controlchar)\
        StringObject,\
                StringFrame,\
                MUIA_ControlChar    , controlchar,\
                MUIA_String_MaxLen  , maxlen,\
                MUIA_String_Contents, contents,\
                End

#endif



#ifdef MUI_OBSOLETE

/***************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following macro creates a checkmark gadget.
**
***************************************************************************/

#define CheckMark(selected)\
        ImageObject,\
                ImageButtonFrame,\
                MUIA_InputMode        , MUIV_InputMode_Toggle,\
                MUIA_Image_Spec       , MUII_CheckMark,\
                MUIA_Image_FreeVert   , MUI_TRUE,\
                MUIA_Selected         , selected,\
                MUIA_Background       , MUII_ButtonBack,\
                MUIA_ShowSelState     , FALSE,\
                End

#define KeyCheckMark(selected,control)\
        ImageObject,\
                ImageButtonFrame,\
                MUIA_InputMode        , MUIV_InputMode_Toggle,\
                MUIA_Image_Spec       , MUII_CheckMark,\
                MUIA_Image_FreeVert   , MUI_TRUE,\
                MUIA_Selected         , selected,\
                MUIA_Background       , MUII_ButtonBack,\
                MUIA_ShowSelState     , FALSE,\
                MUIA_ControlChar      , control,\
                End

#endif


/***************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**       KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
***************************************************************************/

#define SimpleButton(label) Mui_MakeObjectA(MUIO_Button,[label])

#ifdef MUI_OBSOLETE

#define KeyButton(name,key)\
        TextObject,\
                ButtonFrame,\
                MUIA_Text_Contents, name,\
                MUIA_Text_PreParse, '\ec',\
                MUIA_Text_HiChar  , key,\
                MUIA_ControlChar  , key,\
                MUIA_InputMode    , MUIV_InputMode_RelVerify,\
                MUIA_Background   , MUII_ButtonBack,\
                End

#endif


#ifdef MUI_OBSOLETE

/***************************************************************************
**
** Cycle-Object
** ------------
**
*****