#define MUIMASTER_NAME 'muimaster.library'

#define MUIC_Notify      'Notify.mui'
#define MUIC_Family      'Family.mui'
#define MUIC_Menustrip   'Menustrip.mui'
#define MUIC_Menu        'Menu.mui'
#define MUIC_Menuitem    'Menuitem.mui'
#define MUIC_Application 'Application.mui'
#define MUIC_Window      'Window.mui'
#define MUIC_Area        'Area.mui'
#define MUIC_Rectangle   'Rectangle.mui'
#define MUIC_Image       'Image.mui'
#define MUIC_Bitmap      'Bitmap.mui'
#define MUIC_Bodychunk   'Bodychunk.mui'
#define MUIC_Text        'Text.mui'
#define MUIC_String      'String.mui'
#define MUIC_Prop        'Prop.mui'
#define MUIC_Gauge       'Gauge.mui'
#define MUIC_Scale       'Scale.mui'
#define MUIC_Boopsi      'Boopsi.mui'
#define MUIC_Colorfield  'Colorfield.mui'
#define MUIC_List        'List.mui'
#define MUIC_Floattext   'Floattext.mui'
#define MUIC_Volumelist  'Volumelist.mui'
#define MUIC_Scrmodelist 'Scrmodelist.mui'
#define MUIC_Dirlist     'Dirlist.mui'
#define MUIC_Group       'Group.mui'
#define MUIC_Register    'Register.mui'
#define MUIC_Virtgroup   'Virtgroup.mui'
#define MUIC_Scrollgroup 'Scrollgroup.mui'
#define MUIC_Scrollbar   'Scrollbar.mui'
#define MUIC_Listview    'Listview.mui'
#define MUIC_Radio       'Radio.mui'
#define MUIC_Cycle       'Cycle.mui'
#define MUIC_Slider      'Slider.mui'
#define MUIC_Coloradjust 'Coloradjust.mui'
#define MUIC_Palette     'Palette.mui'
#define MUIC_Colorpanel  'Colorpanel.mui'
#define MUIC_Popstring   'Popstring.mui'
#define MUIC_Popobject   'Popobject.mui'
#define MUIC_Poplist     'Poplist.mui'
#define MUIC_Popasl      'Popasl.mui'

#define MUIX_R '\er'
#define MUIX_C '\ec'
#define MUIX_L '\el'
#define MUIX_N '\en'
#define MUIX_B '\eb'
#define MUIX_I '\ei'
#define MUIX_U '\eu'
#define MUIX_PT '\e2'
#define MUIX_PH '\e8'

#define MenustripObject   MuI_NewObjectA(MUIC_Menustrip,[TAG_IGNORE,0
#define MenuObject        MuI_NewObjectA(MUIC_Menu,[TAG_IGNORE,0
#define MenuObjectT(name) MuI_NewObjectA(MUIC_Menu,[MUIA_Menu_Title,name
#define MenuitemObject    MuI_NewObjectA(MUIC_Menuitem,[TAG_IGNORE,0
#define WindowObject      MuI_NewObjectA(MUIC_Window,[TAG_IGNORE,0
#define ImageObject       MuI_NewObjectA(MUIC_Image,[TAG_IGNORE,0
#define BitmapObject      MuI_NewObjectA(MUIC_Bitmap,[TAG_IGNORE,0
#define BodychunkObject   MuI_NewObjectA(MUIC_Bodychunk,[TAG_IGNORE,0
#define NotifyObject      MuI_NewObjectA(MUIC_Notify,[TAG_IGNORE,0
#define ApplicationObject MuI_NewObjectA(MUIC_Application,[TAG_IGNORE,0
#define TextObject        MuI_NewObjectA(MUIC_Text,[TAG_IGNORE,0
#define RectangleObject   MuI_NewObjectA(MUIC_Rectangle,[TAG_IGNORE,0
#define ListObject        MuI_NewObjectA(MUIC_List,[TAG_IGNORE,0
#define PropObject        MuI_NewObjectA(MUIC_Prop,[TAG_IGNORE,0
#define StringObject      MuI_NewObjectA(MUIC_String,[TAG_IGNORE,0
#define ScrollbarObject   MuI_NewObjectA(MUIC_Scrollbar,[TAG_IGNORE,0
#define ListviewObject    MuI_NewObjectA(MUIC_Listview,[TAG_IGNORE,0
#define RadioObject       MuI_NewObjectA(MUIC_Radio,[TAG_IGNORE,0
#define VolumelistObject  MuI_NewObjectA(MUIC_Volumelist,[TAG_IGNORE,0
#define FloattextObject   MuI_NewObjectA(MUIC_Floattext,[TAG_IGNORE,0
#define DirlistObject     MuI_NewObjectA(MUIC_Dirlist,[TAG_IGNORE,0
#define SliderObject      MuI_NewObjectA(MUIC_Slider,[TAG_IGNORE,0
#define CycleObject       MuI_NewObjectA(MUIC_Cycle,[TAG_IGNORE,0
#define GaugeObject       MuI_NewObjectA(MUIC_Gauge,[TAG_IGNORE,0
#define ScaleObject       MuI_NewObjectA(MUIC_Scale,[TAG_IGNORE,0
#define BoopsiObject      MuI_NewObjectA(MUIC_Boopsi,[TAG_IGNORE,0
#define ColorfieldObject  MuI_NewObjectA(MUIC_Colorfield,[TAG_IGNORE,0
#define ColorpanelObject  MuI_NewObjectA(MUIC_Colorpanel,[TAG_IGNORE,0
#define ColoradjustObject MuI_NewObjectA(MUIC_Coloradjust,[TAG_IGNORE,0
#define PaletteObject     MuI_NewObjectA(MUIC_Palette,[TAG_IGNORE,0
#define GroupObject       MuI_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define RegisterObject    MuI_NewObjectA(MUIC_Register,[TAG_IGNORE,0
#define VirtgroupObject   MuI_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define ScrollgroupObject MuI_NewObjectA(MUIC_Scrollgroup,[TAG_IGNORE,0
#define PopstringObject   MuI_NewObjectA(MUIC_Popstring,[TAG_IGNORE,0
#define PopobjectObject   MuI_NewObjectA(MUIC_Popobject,[TAG_IGNORE,0
#define PoplistObject     MuI_NewObjectA(MUIC_Poplist,[TAG_IGNORE,0
#define PopaslObject      MuI_NewObjectA(MUIC_Popasl,[TAG_IGNORE,0
#define ScrmodelistObject MuI_NewObjectA(MUIC_Scrmodelist,[TAG_IGNORE,0
#define VGroup            MuI_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define HGroup            MuI_NewObjectA(MUIC_Group,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroup(cols)    MuI_NewObjectA(MUIC_Group,[MUIA_Group_Columns,(cols)
#define RowGroup(rows)    MuI_NewObjectA(MUIC_Group,[MUIA_Group_Rows   ,(rows)
#define PageGroup         MuI_NewObjectA(MUIC_Group,[MUIA_Group_PageMode,MUI_TRUE
#define VGroupV           MuI_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define HGroupV           MuI_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroupV(cols)   MuI_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Columns,(cols)
#define RowGroupV(rows)   MuI_NewObjectA(MUIC_Virtgroup,[MUIA_Group_Rows   ,(rows)
#define PageGroupV        MuI_NewObjectA(MUIC_Virtgroup,[MUIA_Group_PageMode,MUI_TRUE
#define RegisterGroup(t)  MuI_NewObjectA(MUIC_Register,[MUIA_Register_Titles,(t)
#define End               TAG_DONE])

#define Child             MUIA_Group_Child
#define SubWindow         MUIA_Application_Window
#define WindowContents    MUIA_Window_RootObject

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
#define HVSpace           MuI_NewObjectA(MUIC_Rectangle,[TAG_DONE])
#define HSpace(x)         MuI_MakeObjectA(MUIO_HSpace,[x])
#define VSpace(x)         MuI_MakeObjectA(MUIO_VSpace,[x])
#define HCenter(obj)      HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End
#define VCenter(obj)      VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End
#define InnerSpacing(h,v) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x)   MUIA_Group_Spacing,x

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

#define SimpleButton(label) MuI_MakeObjectA(MUIO_Button,[label])

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

#define Cycle(entries)        CycleObject, MUIA_Cycle_Entries, entries, End
#define KeyCycle(entries,key) CycleObject, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End

#define Radio(name,array)\
        RadioObject,\
                GroupFrameT(name),\
                MUIA_Radio_Entries,array,\
                End

#define KeyRadio(name,array,key)\
        RadioObject,\
                GroupFrameT(name),\
                MUIA_Radio_Entries,array,\
                MUIA_ControlChar, key,\
                End

#define Slider(min,max,level)\
        SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                End

#define KeySlider(min,max,level,key)\
        SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                MUIA_ControlChar , key,\
                End

#define PopButton(img) MuI_MakeObjectA(MUIO_PopButton,[img])

#define Label(label)   MuI_MakeObjectA(MUIO_Label,[label,0])
#define Label1(label)  MuI_MakeObjectA(MUIO_Label,[label,MUIO_Label_SingleFrame])
#define Label2(label)  MuI_MakeObjectA(MUIO_Label,[label,MUIO_Label_DoubleFrame])
#define LLabel(label)  MuI_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned])
#define LLabel1(label) MuI_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned + MUIO_Label_SingleFrame])
#define LLabel2(label) MuI_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame])

#define KeyLabel(label,key)   MuI_MakeObjectA(MUIO_Label,[label,key])
#define KeyLabel1(label,key)  MuI_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_SingleFrame,key)])
#define KeyLabel2(label,key)  MuI_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_DoubleFrame,key)])
#define KeyLLabel(label,key)  MuI_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned,key)])
#define KeyLLabel1(label,key) MuI_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key)])
#define KeyLLabel2(label,key) MuI_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key)])

#define get(obj,attr,store) GetAttr(attr,obj,store)
#define set(obj,attr,value) SetAttrsA(obj,[setAttrsA+(attr),value,TAG_DONE])
#define nnset(obj,attr,value) SetAttrsA(obj,[MUIA_NoNotify,MUI_TRUE,setAttrsA+(attr),value,TAG_DONE])

#define setmutex(obj,n)     set(obj,MUIA_Radio_Active,n)
#define setcycle(obj,n)     set(obj,MUIA_Cycle_Active,n)
#define setstring(obj,s)    set(obj,MUIA_String_Contents,s)
#define setcheckmark(obj,b) set(obj,MUIA_Selected,b)
#define setslider(obj,l)    set(obj,MUIA_Slider_Level,l)

#define MUIP_BoopsiQuery MUI_BoopsiQuery

#define MUIV_Window_AltHeight_MinMax(p) (0-(p))
#define MUIV_Window_AltHeight_Visible(p) (-100-(p))
#define MUIV_Window_AltHeight_Screen(p) (-200-(p))
#define MUIV_Window_AltTopEdge_Delta(p) (-3-(p))
#define MUIV_Window_AltWidth_MinMax(p) (0-(p))
#define MUIV_Window_AltWidth_Visible(p) (-100-(p))
#define MUIV_Window_AltWidth_Screen(p) (-200-(p))
#define MUIV_Window_Height_MinMax(p) (0-(p))
#define MUIV_Window_Height_Visible(p) (-100-(p))
#define MUIV_Window_Height_Screen(p) (-200-(p))
#define MUIV_Window_TopEdge_Delta(p) (-3-(p))
#define MUIV_Window_Width_MinMax(p) (0-(p))
#define MUIV_Window_Width_Visible(p) (-100-(p))
#define MUIV_Window_Width_Screen(p) (-200-(p))

