PROC wait4message() /*"wait4message()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Parse Msg on ViewWindow.
 *******************************************************************************/
    DEF view_mes:PTR TO intuimessage
    DEF para_r=NIL,test_wait=NIL
    REPEAT
        view_type:=0
        IF view_mes:=Gt_GetIMsg(view_window.userport)
            view_type:=view_mes.class
            IF view_type=IDCMP_RAWKEY
                view_infos:=view_mes.code
                /*WriteF('\h\n',view_infos)*/
                SELECT view_infos
                    CASE $10 /* ADD OBJECT */
                        IF my_filerequester()
                            IF (test_wait:=readfile())=OK_FICHIER
                                rebuildminmax()
                                draw_base()
                            ENDIF
                        ENDIF
                    CASE $28 /* LOAD NEW OBJECT */
                        IF my_filerequester()
                            cleanupbase()
                            IF (test_wait:=readfile())=OK_FICHIER
                                rebuildminmax()
                                draw_base()
                            ENDIF
                        ENDIF
                    CASE $29 /* MULTI LOAD OBJECT */
                        cleanupbase()
                        loadmultiobject()
                        rebuildminmax()
                        draw_base()
                    CASE $4F /* Left  */
                        para_r:=SpDiv(180.0,SpMul(angle_rotation,3.14159))
                        SELECT plan
                            CASE PLAN_XOY
                                rotationbase(AXE_Y,para_r)
                            CASE PLAN_YOZ
                                rotationbase(AXE_Z,para_r)
                            CASE PLAN_XOZ
                                rotationbase(AXE_Z,para_r)
                            DEFAULT; NOP
                        ENDSELECT
                        rebuildminmax()
                        draw_base()
                    CASE $4C /* Up    */
                        para_r:=SpDiv(180.0,SpMul(angle_rotation,3.14159))
                        SELECT plan
                            CASE PLAN_XOY
                                rotationbase(AXE_X,para_r)
                            CASE PLAN_YOZ
                                rotationbase(AXE_Y,para_r)
                            CASE PLAN_XOZ
                                rotationbase(AXE_X,para_r)
                            DEFAULT; NOP
                        ENDSELECT
                        draw_base()
                        rebuildminmax()
                    CASE $4E /* Right */
                        para_r:=SpDiv(180.0,SpMul(SpNeg(angle_rotation),3.14159))
                        SELECT plan
                            CASE PLAN_XOY
                                rotationbase(AXE_Y,para_r)
                            CASE PLAN_YOZ
                                rotationbase(AXE_Z,para_r)
                            CASE PLAN_XOZ
                                rotationbase(AXE_Z,para_r)
                            DEFAULT; NOP
                        ENDSELECT
                        draw_base()
                        rebuildminmax()
                    CASE $4D /* Down  */
                        para_r:=SpDiv(180.0,SpMul(SpNeg(angle_rotation),3.14159))
                        SELECT plan
                            CASE PLAN_XOY
                                rotationbase(AXE_X,para_r)
                            CASE PLAN_YOZ
                                rotationbase(AXE_Y,para_r)
                            CASE PLAN_XOZ
                                rotationbase(AXE_X,para_r)
                            DEFAULT; NOP
                        ENDSELECT
                        draw_base()
                        rebuildminmax()
                    CASE $45; view_type:=IDCMP_CLOSEWINDOW
                    CASE $5C /* DIVISER */
                        echelle:=SpMul(echelle,0.5)
                        draw_base()
                    CASE $5D /* Multiplier */
                        echelle:=SpMul(echelle,2.0)
                        draw_base()
                    CASE $5E  /* Plus */
                        echelle:=SpAdd(echelle,0.01)
                        draw_base()
                    CASE $4A  /* Moins */
                        echelle:=SpSub(0.01,echelle)
                        draw_base()
                    CASE $1D /* Touche numpad 1 plan xoy */
                        plan:=PLAN_XOY
                        draw_base()
                    CASE $1E /* Touche numpad 2 plan xoz */
                        plan:=PLAN_XOZ
                        draw_base()
                    CASE $1F /* Touche numad 3 plan yoz */
                        plan:=PLAN_YOZ
                        draw_base()
                    CASE $2D /* Touche numpad 4 */
                        IF signe_x=1 THEN signe_x:=-1 ELSE signe_x:=1
                        draw_base()
                    CASE $2E /* Touche numpad 5 */
                        IF signe_y=1 THEN signe_y:=-1 ELSE signe_y:=1
                        draw_base()
                    CASE $2F /* Touche numpad 6 */
                        IF signe_z=1 THEN signe_z:=-1 ELSE signe_z:=1
                        draw_base()
                    CASE $33 /* Centrage objets touche C */
                        centre_objs()
                        draw_base()
                        rebuildminmax()
                    CASE $59 /* F10 Info object */
                        initlookcloseinfowindow()
                        draw_base()
                    CASE $58 /*F9 Save objects selected in Geo Format */
                        savegeofile()
                    CASE $57 /*F8 Save Objects selected in .DXF format */
                        savedxffile()
                    CASE $56 /*F7 Save Objects selected in .RAY format */
                        saverayfile()
                    CASE $5F /* HELP */
                        RtEZRequestA('Touche     Fonctions\n'+
                                     '                                                   \n'+
                                     'NUMPAD 1   - Vue en XOY.\n'+
                                     'NUMPAD 2   - Vue en XOZ.\n'+
                                     'NUMPAD 3   - Vue En YOZ.\n'+
                                     'NUMPAD 4   - Inverse les coordonnées en X.\n'+
                                     'NUMPAD 5   - Inverse les coordonnées en Y.\n'+
                                     'NUMPAD 6   - Inverse les coordonnées en Z.\n'+
                                     'NUMPAD +   - Zoom In (Par pas de 0.01).\n'+
                                     'NUMPAD -   - Zoom Out(Par pas de 0.01).\n'+
                                     'NUMPAD /   - Divise l\aechelle par 2.\n'+
                                     'NUMPAD *   - Multiplie l\aechelle par 2.\n'+
                                     'Up         - Rotation (Suivant le plan de vue).\n'+
                                     'Down       - Rotation           "              \n'+
                                     'Left       - Rotation           "              \n'+
                                     'Right      - Rotation           "              \n'+
                                     'C          - Centre les objets.\n'+
                                     'L          - Charge un nouvel objet.\n'+
                                     'A          - Ajoute un nouvel objet.\n'+
                                     'M          - Charge plusieurs objects.\n'+
                                     'S          - Stop le dessin.\n'+
                                     'F7         - Sauve les objets séléctionnés (.RAY)\n'+
                                     'F8         - Sauve les objets sélectionnés (.DXF)\n'+
                                     'F9         - Sauve les objets sélectionnés (.GEO)\n'+
                                     'F10        - Informations objets.\n'+
                                     'ESC        - Quitter.','_Ok',0,0,[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,
                                                                                                     RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",TAG_DONE,0])
                    CASE $17 /* INFORMATION */
                        RtEZRequestA('    <<<< Information >>>>    \n'+
                                     '                             \n'+
                                     '    Nbrs Object(s() :\d      \n'+
                                     '    Total Vertices  :\d      \n'+
                                     '    Total Faces     :\d      \n'+
                                     '                             \n'+
                                     '    <<<<   © NasGûl  >>>>    \n','_Ok',0,[my_database.nbrsobjs,
                                                                                my_database.totalpts,
                                                                                my_database.totalfaces],[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,
                                                                                                         RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",TAG_DONE,0])
                    DEFAULT; NOP
                ENDSELECT
            ELSEIF view_type<>IDCMP_CLOSEWINDOW
                view_type:=0
            ENDIF
            Gt_ReplyIMsg(view_mes)
        ELSE
            Wait(viewwindow_sig)
        ENDIF
    UNTIL view_type
ENDPROC

