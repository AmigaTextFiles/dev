->> EDEVHEADER
/*= © NasGûl ==========================
 ESOURCE 3DViewMUI.e
 EDIR    Emodules:/Sources/3DView/3DLib
 ECOPT   ERRLINE
 EXENAME 3DViewMUI.m
 MAKE    BUILD
 AUTHOR  NasGûl
 TYPE    EMOD
=====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !! SEULES LES DISTRIBUTIONS DE FRED FISH ET AMINET CDROM SONT AUTO-  !!
 !! RISES A DISTRIBUER CES PROGRAMMES/SOURCES.                        !!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
/*=======================================================
 La majeure partie (pour ne pas dire la totalité) de ces lignes
 ont été faites avec le couple MUIBuilder/GenCodeE,merci donc a
 Eric Totel et Lionel Vintenat qui de quelques clic souris vous
 font une interface MUI.
=======================================================*/
OPT MODULE
OPT PREPROCESS
OPT EXPORT
->> MODULES

MODULE 'muimaster' , 'libraries/mui'
MODULE 'tools/boopsi'
MODULE 'utility/tagitem','utility/hooks'
MODULE '*3DViewHeader'

-><
->> DEFINE

#define SBH(label,help)\
        TextObject,\
        ButtonFrame,\
        MUIA_Text_Contents,label,\
        MUIA_Text_PreParse,'\ec',\
        MUIA_InputMode,MUIV_InputMode_RelVerify,\
        MUIA_Background,MUII_ButtonBack,\
        MUIA_HelpNode,help,\
    End

-><
->> OBJECTS

->> OBJECT app_arexx
OBJECT app_arexx
    commands :  PTR TO mui_command
    error    :  hook
ENDOBJECT
-><
->> OBJECT app_bj
OBJECT app_obj
    app           : PTR TO LONG

    wi_3dmain         : PTR TO LONG
    bt_fichier        : PTR TO LONG
    bt_vues       : PTR TO LONG
    bt_objets         : PTR TO LONG
    bt_prefs          : PTR TO LONG

    wi_3dfichier      : PTR TO LONG
    gr_root       : PTR TO LONG
    bt_loadnewobj     : PTR TO LONG
    bt_addnewobj      : PTR TO LONG
    cy_savewhat       : PTR TO LONG
    cy_saveformat     : PTR TO LONG
    bt_save       : PTR TO LONG
    bt_config         : PTR TO LONG
    bt_quitter        : PTR TO LONG
    lv_primitives     : PTR TO LONG
    bt_loadnewprims   : PTR TO LONG
    bt_addnewprims    : PTR TO LONG
    wi_config         : PTR TO LONG
    st_fimagine       : PTR TO LONG
    st_fsculpt        : PTR TO LONG
    st_f3dpro         : PTR TO LONG
    st_fvertex        : PTR TO LONG

    wi_vues       : PTR TO LONG
    cy_planvue        : PTR TO LONG
    cy_modevue        : PTR TO LONG
    cy_invcoord       : PTR TO LONG
    im_gloupemoins    : PTR TO LONG
    im_gloupeplus     : PTR TO LONG
    im_ploupemoins    : PTR TO LONG
    im_ploupeplus     : PTR TO LONG
    bt_rotation       : PTR TO LONG

    wi_rotation       : PTR TO LONG
    im_centerbase     : PTR TO LONG
    im_up         : PTR TO LONG
    im_left       : PTR TO LONG
    im_draw       : PTR TO LONG
    im_right          : PTR TO LONG
    im_down       : PTR TO LONG
    sl_angle          : PTR TO LONG

    wi_objets         : PTR TO LONG
    lv_objlist        : PTR TO LONG
    bt_vector         : PTR TO LONG
    bt_delobj         : PTR TO LONG
    tx_typeobj        : PTR TO LONG
    ra_objetact       : PTR TO LONG
    tx_nbrspts        : PTR TO LONG
    tx_nbrsfcs        : PTR TO LONG
    tx_minx       : PTR TO LONG
    tx_maxx       : PTR TO LONG
    tx_miny       : PTR TO LONG
    tx_maxy       : PTR TO LONG
    tx_minz       : PTR TO LONG
    tx_maxz       : PTR TO LONG
    tx_totalpts       : PTR TO LONG
    tx_totalfcs       : PTR TO LONG
    tx_totalobj       : PTR TO LONG
    tx_centrex        : PTR TO LONG
    tx_centrey        : PTR TO LONG
    tx_centrez        : PTR TO LONG
    bt_ok         : PTR TO LONG

    wi_primcal        : PTR TO LONG
    st_primx          : PTR TO LONG
    st_primy          : PTR TO LONG
    st_nomobj         : PTR TO LONG
    st_fct3d          : PTR TO LONG
    bt_primok         : PTR TO LONG
    bt_primcancel     : PTR TO LONG
    cy_primfaces      : PTR TO LONG

    wi_prefs          : PTR TO LONG
    st_drawingwinx    : PTR TO LONG
    st_drawingwiny    : PTR TO LONG
    st_drawingwinw    : PTR TO LONG
    st_drawingwinh    : PTR TO LONG
    cy_colorobjs      : PTR TO LONG
    ch_autoactive     : PTR TO LONG
    bt_saveprefs      : PTR TO LONG

    wi_vector         : PTR TO LONG
    tx_vobjinfo       : PTR TO LONG
    cy_vsens          : PTR TO LONG
    cy_vsupport       : PTR TO LONG
    st_vfactor        : PTR TO LONG
    st_vduree         : PTR TO LONG
    st_vrotx          : PTR TO LONG
    st_vroty          : PTR TO LONG
    st_vrotz          : PTR TO LONG
    bt_vrender        : PTR TO LONG
    bt_genecode       : PTR TO LONG
    bt_vcancel        : PTR TO LONG

    st_tx_typeobj    : PTR TO CHAR
    st_tx_nbrspts    : PTR TO CHAR
    st_tx_nbrsfcs    : PTR TO CHAR
    st_tx_minx       : PTR TO CHAR
    st_tx_maxx       : PTR TO CHAR
    st_tx_miny       : PTR TO CHAR
    st_tx_maxy       : PTR TO CHAR
    st_tx_minz       : PTR TO CHAR
    st_tx_maxz       : PTR TO CHAR
    st_tx_totalpts   : PTR TO CHAR
    st_tx_totalfcs   : PTR TO CHAR
    st_tx_totalobj   : PTR TO CHAR
    st_tx_centrex    : PTR TO CHAR
    st_tx_centrey    : PTR TO CHAR
    st_tx_centrez    : PTR TO CHAR
    st_tx_drawing    : PTR TO CHAR
    st_tx_vobjinfo   : PTR TO CHAR

    cy_savewhatContent    : PTR TO LONG
    cy_saveformatContent  : PTR TO LONG
    cy_modevueContent     : PTR TO LONG
    cy_planvueContent     : PTR TO LONG
    cy_invcoordContent    : PTR TO LONG
    ra_objetactContent    : PTR TO LONG
    cy_primfacesContent   : PTR TO LONG
    cy_colorobjsContent   : PTR TO LONG
    cy_vsensContent   : PTR TO LONG
    cy_vsupportContent    : PTR TO LONG
ENDOBJECT
-><

-><
->> CONSTANTES

EXPORT ENUM    ID_LOADNEWOBJ = 1, ID_ADDNEWOBJ  ,
    ID_SAVEWHAT     ,    ID_SAVEFORMAT      ,    ID_SAVE               ,    ID_FCTIMAGINE         ,
    ID_FCTSCULPT    ,    ID_FCT3DPRO        ,    ID_FCTVERTEX          ,    ID_MODEVUE            ,
    ID_PLANVUE      ,    ID_INVCOORD        ,    ID_GLOUPEMOINS        ,    ID_GLOUPEPLUS         ,
    ID_PLOUPEMOINS  ,    ID_PLOUPEPLUS      ,    ID_ROTUP              ,    ID_ROTLEFT            ,
    ID_ROTRIGHT     ,    ID_ROTDOWN     ,    ID_OBJLISTACTIVE          ,    ID_LISTOBJDBC         ,
    ID_DELOBJ       ,    ID_OBJACTMODIF     ,    ID_PRIMX              ,    ID_PRIMY              ,
    ID_PRIMOK       ,    ID_PRIMCANCEL      ,    ID_PRIMNAME           ,    ID_PRIMFACES          ,
    ID_PRIMFCT3D    ,    ID_LOADNEWPRIM     ,    ID_ADDNEWPRIM         ,    ID_DRAWING            ,
    ID_CENTERBASE   ,    ID_DRAWINGWINX     ,    ID_DRAWINGWINY        ,    ID_DRAWINGWINW        ,
    ID_DRAWINGWINH  ,    ID_COLOROBJ        ,    ID_MAINWINCLOSE           ,    ID_MAINWINOPEN        ,
    ID_SAVEPREFS    ,    ID_NEWANGLE        ,    ID_AUTOACTIVE         ,    ID_VECTSENS           ,
    ID_VECTSUPPORT  ,    ID_VECTFACTOR      ,    ID_VECTTIME           ,    ID_VECTROTX           ,
    ID_VECTROTY     ,    ID_VECTRENDER      ,    ID_VECTROTZ           ,    ID_VECTGENCODEE       ,
    ID_VECTCANCEL   ,    ID_VECTOPENWIN

-><
->> create(icon=NIL,arexx=NIL:PTR TO app_arexx,menu=NIL) OF app_obj
PROC create(icon=NIL,arexx=NIL:PTR TO app_arexx,menu=NIL) OF app_obj

    DEF grOUP_ROOT_0 , gr_fichier , gr_prims
    DEF grOUP_ROOT_2 , obj_aux0 , obj_aux1 , obj_aux2 , obj_aux3
    DEF obj_aux4 , obj_aux5 , obj_aux6 , obj_aux7 , grOUP_ROOT_3
    DEF gr_loupe , gr_grandeloupe
    DEF gr_petiteloupe
    DEF grOUP_ROOT_4 , gr_rotation
    DEF reC_label_1 , reC_label_3
    DEF reC_label_4 , grOUP_ROOT_5 , gr_objets
    DEF gr_objetsbis , gr_objetat , gr_objinfo , gr_objetster
    DEF grOUP_ROOT_7 , obj_aux8 , obj_aux9 , obj_aux10 , obj_aux11
    DEF obj_aux12 , obj_aux13 ,obj_aux14,obj_aux15 , gr_gadprim

    DEF grOUP_ROOT_8 , gr_prefs
    DEF gr_drawingwindow , obj_aux16
    DEF obj_aux17 , obj_aux18 , obj_aux19 , obj_aux20 , obj_aux21,obj_aux22,obj_aux23
    DEF gr_couleurs,gr_angle
    DEF obj_aux24,obj_aux25

    DEF grOUP_ROOT_9 , gr_v , obj_vaux22 , obj_vaux23
    DEF gr_vv , obj_vaux24 , obj_vaux25 , obj_vaux26 , obj_vaux27
    DEF obj_vaux28 , obj_vaux29 , obj_vaux30 , obj_vaux31 , gr_vvv

    self.st_tx_typeobj        := ''
    self.st_tx_nbrspts        := ''
    self.st_tx_nbrsfcs        := ''
    self.st_tx_minx       := '0000.0000'
    self.st_tx_maxx       := '0000.0000'
    self.st_tx_miny       := '0000.0000'
    self.st_tx_maxy       := '0000.0000'
    self.st_tx_minz       := '0000.0000'
    self.st_tx_maxz       := '0000.0000'
    self.st_tx_totalpts       := ''
    self.st_tx_totalfcs       := ''
    self.st_tx_totalobj       := ''
    self.st_tx_centrex        := '0000.0000'
    self.st_tx_centrey        := '0000.0000'
    self.st_tx_centrez        := '0000.0000'
    self.st_tx_drawing        := ''

    self.cy_savewhatContent   := ['Sauver tous les objets','Sauver objets séléctionnés','Sauver objets non-séléctionnés',NIL]
    self.cy_saveformatContent := ['Sauver sous DXF','Sauver sous GEO','Sauver sous RAY','Sauver sous BIN' ,'Sauver sous POV1', 'Sauver sous POV2', NIL ]
    self.cy_modevueContent    := ['Mode points','Mode faces','Mode points & faces' , NIL ]
    self.cy_planvueContent     := ['Vue en XOY','Vue en XOZ','Vue en YOZ',NIL]
    self.cy_invcoordContent    := ['Inversion de coordonnées','Inverse les coordonnées en X' ,'Inverse les coordonnées en Y' ,'Inverse les coordonnées en Z' , NIL ]
    self.ra_objetactContent    := ['Normal' ,'Séléctionné' ,'Encadré' ,'Caché' , NIL ]
    self.cy_primfacesContent   := ['Faces supérieures' ,        'Faces inférieurs' ,        'Faces sup. et inf.' ,        NIL ]
    self.cy_colorobjsContent   := ['Couleur des points','Couleur des faces','Couleur des objets séléctionnés','Couleur de l''encadrement',NIL]
    self.cy_vsensContent       := ['Sens Indirect' , 'Sens Direct' , 'Doubler' , NIL ]
    self.cy_vsupportContent    := [ 'vector.library' , 'FilledVector' , NIL ]

    self.bt_fichier := SBH('Fichier','BT_fichier')
    self.bt_vues    := SBH('Vues','BT_vues')
    self.bt_objets  := SBH('Objets','BT_objets')
    self.bt_prefs   := SBH('Préférences','BT_prefs')

    grOUP_ROOT_0 := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , self.bt_fichier ,
    Child , self.bt_vues ,
    Child , self.bt_objets ,
    Child , self.bt_prefs ,
    End
    self.wi_3dmain := WindowObject ,
    MUIA_Window_Title , PRG_TITLE ,
    MUIA_Window_ID , "0WIN" ,
    MUIA_HelpNode,'WI_3dmain',
    WindowContents , grOUP_ROOT_0 ,
    End
    self.bt_loadnewobj := SBH('Charger Objet(s)','BT_loadnewobj')
    self.bt_addnewobj  := SBH('Ajouter Objet(s)','BT_addnewobj')

    self.cy_savewhat := CycleObject ,
    MUIA_HelpNode , 'CY_savewhat' ,
    MUIA_Cycle_Entries , self.cy_savewhatContent ,
    End
    self.cy_saveformat := CycleObject ,
    MUIA_HelpNode , 'CY_saveformat' ,
    MUIA_Cycle_Entries , self.cy_saveformatContent ,
    End
    self.bt_save    := SBH( 'Sauver','BT_save' )
    self.bt_config  := SBH('Configuration','BT_config' )
    self.bt_quitter := SBH( 'Quitter','BT_quitter' )

    gr_fichier := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Fichier' ,
    Child , self.bt_loadnewobj ,
    Child , self.bt_addnewobj ,
    Child , self.cy_savewhat ,
    Child , self.cy_saveformat ,
    Child , self.bt_save ,
    Child , self.bt_config ,
    Child , self.bt_quitter ,
    End
    self.lv_primitives := ListObject ,
    MUIA_Frame , MUIV_Frame_InputList ,
    MUIA_List_SourceArray,['Torus','Moebius','Plan','Trbl','Sphere','Spirale','Vagues','Cylindre','ConeD','Dome','Cube','Tetra','Octa','Dodeca','Icosa','OctaTronqué','Cubo',NIL],
    End
    self.lv_primitives := ListviewObject ,
    MUIA_HelpNode , 'LV_primitives' ,
    MUIA_Listview_Input , MUI_TRUE ,
    MUIA_Listview_List , self.lv_primitives ,
    End

    self.bt_loadnewprims := SBH( 'Charger Primitive','BT_loadnewprims' )
    self.bt_addnewprims  := SBH( 'Ajouter Primitive','BT_addnewprims' )

    gr_prims := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Primitives' ,
    Child , self.lv_primitives ,
    Child , self.bt_loadnewprims ,
    Child , self.bt_addnewprims ,
    End
    self.gr_root := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , gr_fichier ,
    Child , gr_prims ,
    End
    self.wi_3dfichier := WindowObject ,
    MUIA_Window_Title , '3DView (Fichier)' ,
    MUIA_HelpNode,'WI_3dfichier',
    MUIA_Window_ID , "1WIN" ,
    WindowContents , self.gr_root ,
    End

    self.st_fimagine := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'STR_fimagine' ,
    MUIA_String_Contents , '1.0' ,
    End
    obj_aux1 := Label2( 'Imagine' )
    obj_aux0 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux1 ,
    Child , self.st_fimagine ,
    End
    self.st_fsculpt := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'STR_fsculpt' ,
    MUIA_String_Contents , '0.1' ,
    End
    obj_aux3 := Label2( 'sculpt ' )
    obj_aux2 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux3 ,
    Child , self.st_fsculpt ,
    End
    self.st_f3dpro := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'STR_f3dpro' ,
    MUIA_String_Contents , '0.1' ,
    End
    obj_aux5 := Label2( '3DPro  ' )
    obj_aux4 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux5 ,
    Child , self.st_f3dpro ,
    End
    self.st_fvertex := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'STR_fvertex' ,
    MUIA_String_Contents , '0.1' ,
    End
    obj_aux7 := Label2( 'Vertex ' )
    obj_aux6 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux7 ,
    Child , self.st_fvertex ,
    End
    grOUP_ROOT_2 := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , obj_aux0 ,
    Child , obj_aux2 ,
    Child , obj_aux4 ,
    Child , obj_aux6 ,
    End
    self.wi_config := WindowObject ,
    MUIA_Window_Title , 'Facteur 3D' ,
    MUIA_HelpNode,'WI_config',
    MUIA_Window_ID , "2WIN" ,
    WindowContents , grOUP_ROOT_2 ,
    End
    self.cy_modevue := CycleObject ,
    MUIA_HelpNode , 'CY_modevue' ,
    MUIA_Cycle_Entries , self.cy_modevueContent ,
    End
    self.cy_planvue := CycleObject ,
    MUIA_HelpNode , 'CY_planvue' ,
    MUIA_Cycle_Entries , self.cy_planvueContent ,
    End
    self.cy_invcoord := CycleObject ,
    MUIA_HelpNode , 'CY_invcoord' ,
    MUIA_Cycle_Entries , self.cy_invcoordContent ,
    End
    self.im_gloupemoins := ImageObject ,
    MUIA_Image_Spec , 31 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    self.im_gloupeplus := ImageObject ,
    MUIA_Image_Spec , 30 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    gr_grandeloupe := GroupObject ,
    MUIA_HelpNode , 'GR_grandeloupe' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.im_gloupemoins ,
    Child , self.im_gloupeplus ,
    End
    self.im_ploupemoins := ImageObject ,
    MUIA_Image_Spec , 13 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    self.im_ploupeplus := ImageObject ,
    MUIA_Image_Spec , 14 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    gr_petiteloupe := GroupObject ,
    MUIA_HelpNode , 'GR_petiteloupe' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.im_ploupemoins ,
    Child , self.im_ploupeplus ,
    End
    gr_loupe := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Loupe' ,
    Child , gr_grandeloupe ,
    Child , gr_petiteloupe ,
    End
    self.bt_rotation := SBH( 'Rotation','BT_rotation' )
    grOUP_ROOT_3 := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , self.cy_modevue ,
    Child , self.cy_planvue ,
    Child , self.cy_invcoord ,
    Child , gr_loupe ,
    Child , self.bt_rotation ,
    End
    self.wi_vues := WindowObject ,
    MUIA_Window_Title , '3DView (Vues)' ,
    MUIA_HelpNode,'WI_vues',
    MUIA_Window_ID , "3WIN" ,
    WindowContents , grOUP_ROOT_3 ,
    End

    self.im_centerbase :=ImageObject ,
    MUIA_Image_Spec , MUII_TapeRecord ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    self.im_up := ImageObject ,
    MUIA_Image_Spec , 11 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    reC_label_1 := RectangleObject ,
    End
    self.im_left := ImageObject ,
    MUIA_Image_Spec , 13 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    self.im_draw := ImageObject ,
    MUIA_Image_Spec , MUII_TapePause ,
    MUIA_InputMode,MUIV_InputMode_RelVerify ,
    MUIA_Frame, MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert, MUI_TRUE,
    MUIA_Image_FreeHoriz,MUI_TRUE,
    End
    self.im_right := ImageObject ,
    MUIA_Image_Spec , 14 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    reC_label_3 := RectangleObject ,
    End
    self.im_down := ImageObject ,
    MUIA_Image_Spec , 12 ,
    MUIA_InputMode , MUIV_InputMode_RelVerify ,
    MUIA_Frame , MUIV_Frame_ImageButton ,
    MUIA_Image_FreeVert , MUI_TRUE ,
    MUIA_Image_FreeHoriz , MUI_TRUE ,
    End
    reC_label_4 := RectangleObject ,
    End
    gr_rotation := GroupObject ,
    MUIA_HelpNode , 'GR_rotation' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Rotation' ,
    MUIA_Group_Columns , 3 ,
    Child , self.im_centerbase ,
    Child , self.im_up ,
    Child , reC_label_1 ,
    Child , self.im_left ,
    Child , self.im_draw ,
    Child , self.im_right ,
    Child , reC_label_3 ,
    Child , self.im_down ,
    Child , reC_label_4 ,
    End
    self.sl_angle := SliderObject ,
    MUIA_HelpNode ,'SL_angle',
    MUIA_Slider_Min, 0 ,
    MUIA_Slider_Max,360,
    MUIA_Slider_Level,10,
    End
    gr_angle := GroupObject ,
    MUIA_Frame,MUIV_Frame_Group,
    MUIA_FrameTitle,'Angle',
    Child,self.sl_angle,
    End
    grOUP_ROOT_4 := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , gr_rotation ,
    Child , gr_angle ,
    End
    self.wi_rotation := WindowObject ,
    MUIA_Window_Title , '3DView (Rotation)' ,
    MUIA_Window_ID , "4WIN" ,
    MUIA_HelpNode,'WI_rotation',
    WindowContents , grOUP_ROOT_4 ,
    End
    self.lv_objlist := ListObject ,
    MUIA_Frame , MUIV_Frame_InputList ,
    End
    self.lv_objlist := ListviewObject ,
    MUIA_HelpNode , 'LV_objlist' ,
    MUIA_Weight , 50 ,
    MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
    MUIA_Listview_Input , MUI_TRUE ,
    MUIA_Listview_List , self.lv_objlist ,
    End
    self.bt_vector := SBH( 'Vectorise ','BT_vector')
    self.bt_delobj := SBH( 'Efface objet actif','BT_delobj' )
    self.tx_typeobj := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Type' ,
    MUIA_Text_Contents , self.st_tx_typeobj ,
    End
    gr_objets := GroupObject ,
    MUIA_HelpNode , 'GR_objets' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Objet(s)' ,
    Child , self.lv_objlist ,
    Child , self.bt_vector ,
    Child , self.bt_delobj ,
    Child , self.tx_typeobj ,
    End
    self.ra_objetact := RadioObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Etat' ,
    MUIA_HelpNode , 'RA_objetact' ,
    MUIA_Radio_Entries , self.ra_objetactContent ,
    End
    gr_objetat := GroupObject ,
    MUIA_HelpNode , 'GR_objetat' ,
    Child , self.ra_objetact ,
    End
    self.tx_nbrspts := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Pts' ,
    MUIA_Text_Contents , self.st_tx_nbrspts ,
    End
    self.tx_nbrsfcs := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Fcs' ,
    MUIA_Text_Contents , self.st_tx_nbrsfcs ,
    End
    self.tx_minx := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'MinX' ,
    MUIA_Text_SetMax,FALSE,
    MUIA_Text_Contents , self.st_tx_minx ,
    End
    self.tx_maxx := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'MaxX' ,
    MUIA_Text_Contents , self.st_tx_maxx ,
    End
    self.tx_miny := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'MinY' ,
    MUIA_Text_Contents , self.st_tx_miny ,
    End
    self.tx_maxy := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'MaxY' ,
    MUIA_Text_Contents , self.st_tx_maxy ,
    End
    self.tx_minz := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'MinZ' ,
    MUIA_Text_Contents , self.st_tx_minz ,
    End
    self.tx_maxz := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'MaxZ' ,
    MUIA_Text_Contents , self.st_tx_maxz ,
    End
    gr_objinfo := GroupObject ,
    MUIA_HelpNode , 'GR_objinfo' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Infos' ,
    MUIA_Group_Columns , 2 ,
    MUIA_Group_SameSize , MUI_TRUE ,
    Child , self.tx_nbrspts ,
    Child , self.tx_nbrsfcs ,
    Child , self.tx_minx ,
    Child , self.tx_maxx ,
    Child , self.tx_miny ,
    Child , self.tx_maxy ,
    Child , self.tx_minz ,
    Child , self.tx_maxz ,
    End
    gr_objetsbis := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , gr_objetat ,
    Child , gr_objinfo ,
    End
    self.tx_totalpts := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'TotalPts' ,
    MUIA_Text_Contents , self.st_tx_totalpts ,
    End
    self.tx_totalfcs := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Total Fcs' ,
    MUIA_Text_Contents , self.st_tx_totalfcs ,
    End
    self.tx_totalobj := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Total Objet(s)' ,
    MUIA_Text_Contents , self.st_tx_totalobj ,
    End
    self.tx_centrex := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Centre en X' ,
    MUIA_Text_Contents , self.st_tx_centrex ,
    End
    self.tx_centrey := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Centre en Y' ,
    MUIA_Text_Contents , self.st_tx_centrey ,
    End
    self.tx_centrez := TextObject ,
    MUIA_Background , MUII_WindowBack ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Centre en Z' ,
    MUIA_Text_Contents , self.st_tx_centrez ,
    End
    self.bt_ok := SimpleButton( 'Ok' )
    gr_objetster := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , self.tx_totalpts ,
    Child , self.tx_totalfcs ,
    Child , self.tx_totalobj ,
    Child , self.tx_centrex ,
    Child , self.tx_centrey ,
    Child , self.tx_centrez ,
    Child , self.bt_ok ,
    End
    grOUP_ROOT_5 := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Columns , 3 ,
    Child , gr_objets ,
    Child , gr_objetsbis ,
    Child , gr_objetster ,
    End
    self.wi_objets := WindowObject ,
    MUIA_Window_Title , '3DView (Objets)' ,
    MUIA_Window_ID , "5WIN" ,
    MUIA_HelpNode,'WI_objets',
    WindowContents , grOUP_ROOT_5 ,
    End

    self.st_primx := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_primx' ,
    MUIA_String_Contents , '16' ,
    MUIA_String_Accept , '-0123456789' ,
    End

    obj_aux9 := Label2( 'Séparation en X' )

    obj_aux8 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux9 ,
    Child , self.st_primx ,
    End

    self.st_primy := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_primy' ,
    MUIA_String_Contents , '16' ,
    MUIA_String_Accept , '-0123456789' ,
    End

    obj_aux11 := Label2( 'Séparation en Y' )

    obj_aux10 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux11 ,
    Child , self.st_primy ,
    End

    self.st_nomobj := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_nomobj' ,
    MUIA_String_Contents , 'Object_' ,
    End

    obj_aux13 := Label2( 'Nom de l''objet' )

    obj_aux12 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux13 ,
    Child , self.st_nomobj ,
    End

    self.st_fct3d := StringObject,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_fct3d' ,
    MUIA_String_Contents , '50.0' ,
    End

    obj_aux15 := Label2('Facteur 3D')

    obj_aux14 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux15,
    Child , self.st_fct3d ,
    End

    self.bt_primok := SBH( 'Ok','BT_primok' )

    self.bt_primcancel := SBH( 'Cancel','BT_primcancel' )

    gr_gadprim := GroupObject ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.bt_primok ,
    Child , self.bt_primcancel ,
    End

    self.cy_primfaces := CycleObject ,
    MUIA_HelpNode , 'CY_primfaces' ,
    MUIA_Cycle_Entries , self.cy_primfacesContent ,
    End

    grOUP_ROOT_7 := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Paramètres' ,
    Child , obj_aux8 ,
    Child , obj_aux10 ,
    Child , obj_aux12 ,
    Child , obj_aux14 ,
    Child , gr_gadprim ,
    Child , self.cy_primfaces ,
    End

    self.wi_primcal := WindowObject ,
    MUIA_Window_Title , '3DView (Primitives)' ,
    MUIA_HelpNode,'WI_primcal',
    MUIA_Window_ID , "6WIN" ,
    WindowContents , grOUP_ROOT_7 ,
    End
    /*==================================================*/
    self.st_drawingwinx := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_drawingwinx' ,
    MUIA_String_Accept , '-0123456789' ,
    MUIA_String_MaxLen , 5 ,
    End

    obj_aux17 := Label2( 'Fenêtre en X   :' )

    obj_aux16 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    MUIA_Weight , 75 ,
    Child , obj_aux17 ,
    Child , self.st_drawingwinx ,
    End

    self.st_drawingwiny := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_drawingwiny' ,
    MUIA_String_Accept , '-0123456789' ,
    MUIA_String_MaxLen , 5 ,
    End

    obj_aux19 := Label2( 'Fenêtre en Y   :' )

    obj_aux18 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux19 ,
    Child , self.st_drawingwiny ,
    End

    self.st_drawingwinw := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_drawingwinw' ,
    MUIA_String_Accept , '-0123456789' ,
    MUIA_String_MaxLen , 5 ,
    End

    obj_aux21 := Label2( 'Fenêtre Largeur:' )

    obj_aux20 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux21 ,
    Child , self.st_drawingwinw ,
    End

    self.st_drawingwinh := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_drawingwinh' ,
    MUIA_String_Accept , '-0123456789' ,
    MUIA_String_MaxLen , 5 ,
    End

    obj_aux23 := Label2( 'Fenêtre hauteur:' )

    obj_aux22 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux23 ,
    Child , self.st_drawingwinh ,
    End

    gr_drawingwindow := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , '3DView (Représentation)' ,
    Child , obj_aux16 ,
    Child , obj_aux18 ,
    Child , obj_aux20 ,
    Child , obj_aux22 ,
    End

    self.cy_colorobjs := CycleObject ,
    MUIA_HelpNode , 'CY_colorobjs' ,
    MUIA_Cycle_Entries , self.cy_colorobjsContent ,
    End

    self.ch_autoactive := CheckMark( FALSE )

    obj_aux24 := Label2( 'Auto Activation' )

    obj_aux25 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_aux24 ,
    Child , self.ch_autoactive ,
    End

    self.bt_saveprefs := SBH('Sauver Prefs','BT_saveprefs')

    gr_couleurs := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_FrameTitle , 'Couleurs' ,
    Child , self.cy_colorobjs ,
    Child , obj_aux25 ,
    Child ,self.bt_saveprefs,
    End

    gr_prefs := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , gr_drawingwindow ,
    Child , gr_couleurs ,
    End

    grOUP_ROOT_8 := GroupObject ,
    Child , gr_prefs ,
    End

    self.wi_prefs := WindowObject ,
    MUIA_Window_Title , '3DView (Prefs)' ,
    MUIA_Window_ID , "7WIN" ,
    MUIA_HelpNode,'WI_prefs',
    WindowContents , grOUP_ROOT_8 ,
    End
    /*=========================================*/
    self.tx_vobjinfo := TextObject ,
    MUIA_Background , MUII_TextBack ,
    MUIA_Frame , MUIV_Frame_Text ,
    MUIA_Text_Contents , self.st_tx_vobjinfo ,
    MUIA_Text_SetMin , MUI_TRUE ,
    End
    self.cy_vsens := CycleObject ,
    MUIA_HelpNode , 'CY_vsens' ,
    MUIA_Cycle_Entries , self.cy_vsensContent ,
    End
    self.cy_vsupport := CycleObject ,
    MUIA_HelpNode , 'CY_vsupport' ,
    MUIA_Cycle_Entries , self.cy_vsupportContent ,
    End
    self.st_vfactor := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_vfactor' ,
    End

    obj_vaux23 := Label2( 'Facteur 3D:' )

    obj_vaux22 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_vaux23 ,
    Child , self.st_vfactor ,
    End

    self.st_vduree := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_vduree' ,
    End

    obj_vaux25 := Label2( 'Durée :' )

    obj_vaux24 := GroupObject ,
        MUIA_Group_Columns , 2 ,
        Child , obj_vaux25 ,
        Child , self.st_vduree ,
    End

    self.st_vrotx := StringObject ,
        MUIA_Frame , MUIV_Frame_String ,
        MUIA_HelpNode , 'ST_vrotx' ,
    End

    obj_vaux27 := Label2( 'Rot. X:' )

    obj_vaux26 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_vaux27 ,
    Child , self.st_vrotx ,
    End

    self.st_vroty := StringObject ,
    MUIA_Frame , MUIV_Frame_String ,
    MUIA_HelpNode , 'ST_vroty' ,
    End

    obj_vaux29 := Label2( 'Rot Y:' )

    obj_vaux28 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_vaux29 ,
    Child , self.st_vroty ,
    End

    self.st_vrotz := StringObject ,
        MUIA_Frame , MUIV_Frame_String ,
        MUIA_HelpNode , 'ST_vrotz' ,
    End

    obj_vaux31 := Label2( 'Rot Z:' )

    obj_vaux30 := GroupObject ,
    MUIA_Group_Columns , 2 ,
    Child , obj_vaux31 ,
    Child , self.st_vrotz ,
    End

    gr_vv := GroupObject ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , obj_vaux24 ,
    Child , obj_vaux26 ,
    Child , obj_vaux28 ,
    Child , obj_vaux30 ,
    End

    self.bt_vrender := SBH( 'Voir','BT_vrender' )

    self.bt_genecode := SBH( 'Générer Source','BT_gencode' )

    self.bt_vcancel := SBH( 'Annuler' ,'BT_vcancel')

    gr_vvv := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.bt_vrender ,
    Child , self.bt_genecode ,
    Child , self.bt_vcancel ,
    End

    gr_v := GroupObject ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , self.tx_vobjinfo ,
    Child , self.cy_vsens ,
    Child , self.cy_vsupport ,
    Child , obj_vaux22 ,
    Child , gr_vv ,
    Child , gr_vvv ,
    End

    grOUP_ROOT_9 := GroupObject ,
    Child , gr_v ,
    End

    self.wi_vector := WindowObject ,
    MUIA_Window_Title , '3DView : (Vectorisation objet)' ,
    MUIA_Window_ID , "8WIN" ,
    MUIA_HelpNode,'WI_vector',
    WindowContents , grOUP_ROOT_9 ,
    End


    self.app := ApplicationObject ,

    ( IF icon THEN MUIA_Application_DiskObject ELSE TAG_IGNORE ) , icon ,
    MUIA_Application_HelpFile,'PROGDIR:3DView.Guide',
    MUIA_Application_Commands,arexx.commands,
    MUIA_Application_RexxHook,arexx.error,
    MUIA_Application_Author , 'NasGûl' ,
    MUIA_Application_Base , PRG_NAME ,
    MUIA_Application_Title , PRG_NAME ,
    MUIA_Application_Version , PRG_VER ,
    MUIA_Application_Copyright , '© NasGûl 1995' ,
    MUIA_Application_Description , 'Viewer d\aobjets 3D' ,
    MUIA_Application_SingleTask , TRUE ,
    SubWindow , self.wi_3dmain ,
    SubWindow , self.wi_3dfichier ,
    SubWindow , self.wi_config ,
    SubWindow , self.wi_vues ,
    SubWindow , self.wi_rotation ,
    SubWindow , self.wi_objets ,
    SubWindow , self.wi_primcal,
    SubWindow , self.wi_prefs ,
    SubWindow , self.wi_vector ,
    End

ENDPROC self.app
-><
->> dispose()
PROC dispose() OF app_obj IS Mui_DisposeObject( self.app )
-><
->> init_notifications() OF app_obj
PROC init_notifications() OF app_obj
    /*==== SELF.WI_3DMAIN ====*/
    domethod( self.bt_fichier,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_3dfichier,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
    domethod( self.bt_vues   ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_vues     ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
    domethod( self.bt_objets ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_objets   ,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
    domethod( self.bt_prefs , [MUIM_Notify , MUIA_Pressed ,FALSE ,        self.wi_prefs ,        3 ,        MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )
    domethod( self.wi_3dmain ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit ] )
    domethod( self.wi_3dmain ,[MUIM_Window_SetCycleChain,self.bt_fichier,self.bt_vues,self.bt_objets ,self.bt_prefs ,0 ] )
    domethod( self.wi_3dfichier,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_3dfichier,3,MUIM_Set,MUIA_Window_Open,FALSE])
    /*==== SELF.WI_3DFICHIER ====*/
    domethod( self.bt_loadnewobj   ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_LOADNEWOBJ])
    domethod( self.bt_addnewobj    ,[MUIM_Notify,MUIA_Pressed,FALSE ,self.app,2,MUIM_Application_ReturnID,ID_ADDNEWOBJ])
    domethod( self.cy_savewhat     ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_SAVEWHAT])
    domethod( self.cy_saveformat   ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_SAVEFORMAT])
    domethod( self.bt_save         ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_SAVE])
    domethod( self.bt_config       ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_config,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
    domethod( self.bt_quitter      ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

    domethod( self.bt_loadnewprims ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_LOADNEWPRIM])

    domethod( self.bt_loadnewprims ,[MUIM_Notify,MUIA_Pressed,FALSE,self.gr_root,3,MUIM_Set,MUIA_Disabled,MUI_TRUE])
    domethod( self.bt_loadnewprims ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_primcal,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])

    domethod( self.bt_addnewprims ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_ADDNEWPRIM])

    domethod( self.bt_addnewprims  ,[MUIM_Notify,MUIA_Pressed,FALSE,self.gr_root,3,MUIM_Set,MUIA_Disabled,MUI_TRUE])
    domethod( self.bt_addnewprims  ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_primcal,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
    domethod( self.wi_3dfichier    ,[MUIM_Window_SetCycleChain,self.bt_loadnewobj,self.bt_addnewobj,self.cy_savewhat,self.cy_saveformat,
                    self.bt_save,self.bt_config,self.bt_quitter,self.lv_primitives,self.bt_loadnewprims,self.bt_addnewprims,0])

    /*==== SELF.WI_CONFIG ====*/
    domethod( self.st_fimagine     ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_FCTIMAGINE])
    domethod( self.st_fsculpt      ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_FCTSCULPT])
    domethod( self.st_f3dpro       ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_FCT3DPRO ] )
    domethod( self.st_fvertex      ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_FCTVERTEX ] )
    domethod( self.wi_config       ,[MUIM_Window_SetCycleChain,self.st_fimagine,self.st_fsculpt,self.st_f3dpro,self.st_fvertex,0 ] )
    domethod( self.wi_config       ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_config,3,MUIM_Set,MUIA_Window_Open,FALSE ] )

    /*==== SELF.WI_VUES ====*/
    domethod( self.cy_modevue      ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_MODEVUE ] )
    domethod( self.cy_planvue      ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_PLANVUE ] )
    domethod( self.cy_invcoord     ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_INVCOORD ] )
    domethod(self.im_gloupemoins   ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_GLOUPEMOINS])
    domethod( self.im_gloupeplus   ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_GLOUPEPLUS ] )
    domethod( self.im_ploupemoins  ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_PLOUPEMOINS ] )
    domethod( self.im_ploupeplus   ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_PLOUPEPLUS ] )
    domethod( self.bt_rotation     ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_rotation,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE ] )
    domethod( self.wi_vues         ,[MUIM_Window_SetCycleChain,self.cy_modevue,self.cy_planvue,
                     self.im_gloupemoins,self.im_gloupeplus,self.im_ploupemoins,self.im_ploupeplus,self.cy_invcoord,self.bt_rotation,0 ] )
    domethod( self.wi_vues         ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_vues,3,MUIM_Set,MUIA_Window_Open,FALSE ] )
    /*==== SELF.WI_ROTATION ====*/
    domethod( self.im_centerbase   ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_CENTERBASE ] )
    domethod( self.im_up           ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_ROTUP ] )
    domethod( self.im_left         ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_ROTLEFT ] )
    domethod( self.im_right        ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_ROTRIGHT ] )
    domethod( self.im_down         ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_ROTDOWN ] )
    domethod( self.im_draw         ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_DRAWING ] )
    domethod( self.sl_angle        ,[MUIM_Notify,MUIA_Slider_Level,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_NEWANGLE])
    domethod( self.wi_rotation     ,[MUIM_Window_SetCycleChain , 0 ] )
    domethod( self.wi_rotation     ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_rotation,3,MUIM_Set , MUIA_Window_Open , FALSE ] )
    /*==== SELF.WI_OBJETS ====*/
    domethod( self.lv_objlist      ,[MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_OBJLISTACTIVE ] )
    domethod( self.lv_objlist      ,[MUIM_Notify,MUIA_Listview_DoubleClick,MUI_TRUE,self.app,2,MUIM_Application_ReturnID ,ID_LISTOBJDBC ] )
->    domethod( self.bt_vector       ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_vector,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE] )
    domethod( self.bt_vector       ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID, ID_VECTOPENWIN] )
    domethod( self.bt_delobj       ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_DELOBJ ] )
    domethod( self.ra_objetact     ,[MUIM_Notify,MUIA_Radio_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID , ID_OBJACTMODIF ] )
    domethod( self.bt_ok           ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_objets,3,MUIM_Set , MUIA_Window_Open , FALSE ] )
    domethod( self.wi_objets       ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_objets,3,MUIM_Set , MUIA_Window_Open , FALSE ] )
    domethod( self.wi_objets       ,[MUIM_Window_SetCycleChain,self.lv_objlist,self.bt_vector,self.bt_delobj,self.ra_objetact,self.bt_ok,0 ] )
    /*=== SELF.WI_PRIMCAL ====*/
    domethod(self.st_primx       ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app ,2,MUIM_Application_ReturnID,ID_PRIMX])
    domethod( self.st_primy      ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID , ID_PRIMY ] )
    domethod( self.st_nomobj     ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID , ID_PRIMNAME ] )
    domethod( self.st_fct3d      ,[MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID , ID_PRIMFCT3D ] )
    domethod( self.bt_primok     ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_PRIMOK ] )
    domethod( self.bt_primok     ,[MUIM_Notify,MUIA_Pressed,FALSE,self.gr_root,3,MUIM_Set , MUIA_Disabled , FALSE ] )
    domethod( self.bt_primok     ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_primcal,3,MUIM_Set , MUIA_Window_Open , FALSE ] )
    domethod( self.bt_primcancel ,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID , ID_PRIMCANCEL ] )
    domethod( self.bt_primcancel ,[MUIM_Notify,MUIA_Pressed,FALSE,self.gr_root,3,MUIM_Set , MUIA_Disabled , FALSE ] )
    domethod( self.bt_primcancel ,[MUIM_Notify,MUIA_Pressed,FALSE,self.wi_primcal,3,MUIM_Set , MUIA_Window_Open , FALSE ] )
    domethod( self.cy_primfaces  ,[MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID , ID_PRIMFACES ] )
    domethod( self.wi_primcal    ,[MUIM_Window_SetCycleChain,self.st_primx,self.st_primy,self.st_nomobj,self.bt_primok,self.bt_primcancel,self.cy_primfaces,0 ] )
    /*=== SELF.PREFS ===*/
    domethod( self.st_drawingwinx , [        MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime ,        self.app ,        2 ,        MUIM_Application_ReturnID , ID_DRAWINGWINX ] )
    domethod( self.st_drawingwiny , [        MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime ,        self.app ,        2 ,        MUIM_Application_ReturnID , ID_DRAWINGWINY ] )
    domethod( self.st_drawingwinw , [        MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime ,        self.app ,        2 ,        MUIM_Application_ReturnID , ID_DRAWINGWINW ] )
    domethod( self.st_drawingwinh , [        MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime ,        self.app ,        2 ,        MUIM_Application_ReturnID , ID_DRAWINGWINH ] )
    domethod( self.cy_colorobjs   , [MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,self.app,2,MUIM_Application_ReturnID,ID_COLOROBJ ] )
    domethod( self.ch_autoactive , [ MUIM_Notify , MUIA_Selected , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_AUTOACTIVE ] )
    domethod( self.bt_saveprefs   , [        MUIM_Notify , MUIA_Pressed,FALSE,self.app,2,MUIM_Application_ReturnID,ID_SAVEPREFS])
    domethod( self.wi_prefs       ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_prefs,3,MUIM_Set , MUIA_Window_Open , FALSE ] )

    domethod( self.wi_prefs , [
    MUIM_Window_SetCycleChain , self.st_drawingwinx ,
    self.st_drawingwiny ,
    self.st_drawingwinw ,
    self.st_drawingwinh ,
    self.cy_colorobjs ,
    self.ch_autoactive ,
    self.bt_saveprefs ,
    0 ] )
    /*=== SELF.VECTOR ===*/
    domethod( self.cy_vsens , [ MUIM_Notify , MUIA_Cycle_Active , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTSENS ] )
    domethod( self.cy_vsupport , [ MUIM_Notify , MUIA_Cycle_Active , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTSUPPORT ] )
    domethod( self.st_vfactor , [ MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTFACTOR ] )
    domethod( self.st_vduree , [ MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTTIME ] )
    domethod( self.st_vrotx , [ MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTROTX ] )
    domethod( self.st_vroty , [ MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTROTY ] )
    domethod( self.st_vrotz , [ MUIM_Notify , MUIA_String_Contents , MUIV_EveryTime , self.app , 2 , MUIM_Application_ReturnID , ID_VECTROTZ ] )
    domethod( self.bt_vrender , [ MUIM_Notify , MUIA_Pressed , FALSE , self.app , 2 , MUIM_Application_ReturnID , ID_VECTRENDER ] )

    domethod( self.bt_genecode , [ MUIM_Notify , MUIA_Pressed , FALSE , self.app , 2 , MUIM_Application_ReturnID , ID_VECTGENCODEE ] )

    domethod( self.bt_vcancel , [ MUIM_Notify , MUIA_Pressed , FALSE , self.app , 2 , MUIM_Application_ReturnID , ID_VECTCANCEL ] )

    domethod( self.bt_vcancel , [ MUIM_Notify , MUIA_Pressed , FALSE , self.wi_vector , 3 , MUIM_Set , MUIA_Window_Open , FALSE ] )

    domethod( self.wi_vector , [
        MUIM_Window_SetCycleChain , self.cy_vsens ,
        self.cy_vsupport ,
        self.st_vfactor ,
        self.st_vduree ,
        self.st_vrotx ,
        self.st_vroty ,
        self.st_vrotz ,
        self.bt_vrender ,
        self.bt_genecode ,
        self.bt_vcancel ,
        0 ] )

    domethod( self.wi_vector       ,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,self.wi_vector,3,MUIM_Set , MUIA_Window_Open , FALSE ] )




    domethod(self.wi_3dmain,[MUIM_Notify,MUIA_Window_Open,FALSE,self.app,2,MUIM_Application_ReturnID,ID_MAINWINCLOSE])
    domethod(self.wi_3dmain,[MUIM_Notify,MUIA_Window_Open,MUI_TRUE,self.app,2,MUIM_Application_ReturnID,ID_MAINWINOPEN])
    set(self.wi_3dmain,MUIA_Window_Open,MUI_TRUE)
ENDPROC
-><
