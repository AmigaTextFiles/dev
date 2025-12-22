/* */
options results

/* Method TAG ID definitions */

MUIM_Notify = 0x8042c9cb
MUIM_Set = 0x8042549a
MUIM_NoNotifySet = 0x8042216f
MUIM_Application_AboutMUI = 0x8042d21d
MUIM_Application_OpenConfigWindow = 0x804299ba

/* Attribute TAG ID definitions */

MUIA_AppMessage =                      0x80421955 /* V5  ..g struct AppMessage * */
MUIA_Dropable =                        0x8042fbce /* V11 isg BOOL              */
MUIA_Draggable = 0x80420b6e
MUIA_Listview_DragType = 0x80425cd3
MUIA_List_Format =                     0x80423c0a /* V4  isg STRPTR            */
MUIA_FillArea =                        0x804294a3 /* V4  is. BOOL              */
MUIA_Frame =                           0x8042ac64 /* V4  i.. LONG              */
MUIA_Weight =                          0x80421d1f /* V4  i.. WORD              */
MUIA_Gauge_Current =                   0x8042f0dd /* V4  isg LONG              */
MUIA_Gauge_Divide =                    0x8042d8df /* V4  isg BOOL              */
MUIA_Gauge_Horiz =                     0x804232dd /* V4  i.. BOOL              */
MUIA_Gauge_Max =                       0x8042bcdb /* V4  isg LONG              */
MUIA_Numeric_Value = 0x8042ae3a
MUIA_Menuitem_Title = 0x804218be
MUIA_Menuitem_Shortcut =               0x80422030 /* V8  isg STRPTR            */
MUIA_Boopsi_MinHeight =                0x80422c93 /* V4  isg ULONG             */
MUIA_Boopsi_MinWidth =                 0x80428fb2 /* V4  isg ULONG             */
MUIA_Boopsi_Remember =                 0x8042f4bd /* V4  i.. ULONG             */
MUIA_Boopsi_TagScreen =                0x8042bc71 /* V4  isg ULONG             */
WHEEL_Hue =                            0x84000001
WHEEL_Saturation =                     0x84000002
WHEEL_Screen =                         0x84000009

/* TAG variable definitions */

TRUE = 1
FALSE = 0
MUIV_Listview_DragType_None = 0
MUIV_Listview_DragType_Immediate = 1
MUIV_Frame_None = 0
MUIV_Frame_Text = 3
MUIV_TriggerValue = 0x49893131
MUIV_EveryTime = 0x49893131

address DEMO

window ID WDEMO TITLE '"MUIRexx Demo"' COMMAND '"quit"' PORT DEMO
    menu LABEL "Project"
        item COMMAND '"method 'MUIM_Application_AboutMUI' 0"' PORT DEMO LABEL "About MUI"
        menu LABEL "Settings"
            item COMMAND '"method 'MUIM_Application_OpenConfigWindow'"' PORT DEMO LABEL "MUI..."
        endmenu
        item ATTRS MUIA_Menuitem_Title '-1'
        item COMMAND '"quit"' PORT DEMO ATTRS MUIA_Menuitem_Shortcut 'Q' LABEL "Quit"
    endmenu
    text LABEL 'A demonstration of MUIRexx'
    group REGISTER LABELS "Gadgets,Lists,Cycles,Icons,Strings,Boopsi"
        group
            menu LABEL "Demo"
                item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Menuitem 1"
                item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Menuitem 2"
                menu LABEL "Submenu"
                    item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Submenuitem 1"
                    item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Submenuitem 2"
                endmenu
            endmenu
            view ID GVIEW STRING "A simple demonstration of some of the gadgets available. 
Most gadgets are internal to MUIRexx but others are built from internal and 
external classes.  Notice that some gadgets are linked to others."
            object CLASS '"Balance.mui"'
            group HORIZ
                object ID GCLR CLASS '"Coloradjust.mui"'
                object CLASS '"Balance.mui"'
                group
                    space
                    group HORIZ
                        space HORIZ
                        group
                            knob ID KNOB HELP '"an example knob gadget\012Press HELP for more info"' NODE '"knob"'
                            popslider ID PSLD HELP '"an example popup slider gadget\nPress HELP for more info"' NODE '"popslider"'
                        endgroup
                        meter ID METR NODE '"meter"' LABEL "meter"
                        space HORIZ
                    endgroup
                    slider ID SLDR HELP '"an example slider gadget\nPress HELP for more info"' NODE '"slider"'
                    gauge ID GAUG NODE '"gauge"' ATTRS MUIA_Gauge_Horiz TRUE LABEL "level %ld"
                    object CLASS '"Scale.mui"'
                    space
                endgroup
            endgroup
            group FRAME HORIZ
                check COMMAND '"string ID STR CONTENT %s"' PORT DEMO NODE '"check"' LABEL "unselected,selected"
                text COMMAND '"string ID STR CONTENT %s"' PORT DEMO NODE '"text"' LABEL 'text'
                button COMMAND '"string ID STR CONTENT %s"' PORT DEMO NODE '"button"' LABEL 'button'
                image COMMAND '"string ID STR CONTENT %s"' PORT DEMO NODE '"image"' SPEC '"4:MUI:Images/WD/13pt/PopUp.mf0"' LABEL 'image'
                object CLASS '"Balance.mui"'
                string ID STR
            endgroup
            object CLASS '"Busy.mcc"' ATTRS MUIA_Weight 0
        endgroup
        group
            view STRING "A demonstration of some lists available. Notice that the 
volume list is linked to the directory list and the directory list is linked 
to the string gadget. This view list is another example of a possible list. 
Note that view lists are read-only."
            group HORIZ
                group ATTRS MUIA_Weight 0
                    button ID DF0 ATTRS MUIA_Draggable TRUE LABEL 'DF0:'
                    button ID DH0 ATTRS MUIA_Draggable TRUE LABEL 'DH0:'
                    button ID DH1 ATTRS MUIA_Draggable TRUE LABEL 'DH1:'
                    button ID SYS ATTRS MUIA_Draggable TRUE LABEL 'SYS:'
                    button ID RAM ATTRS MUIA_Draggable TRUE LABEL 'RAM:'
                endgroup
                dirlist ID DIR1 PATH '"ram:"',
                    COMMAND '"dirlist ID DIR1 PATH %s"' PORT DEMO NODE '"dirlist"',
                    ATTRS MUIA_Frame MUIV_Frame_Text MUIA_Listview_DragType MUIV_Listview_DragType_Immediate
                volumelist,
                    COMMAND '"dirlist ID DIR1 PATH %s"' PORT DEMO NODE '"volumelist"',
                    ATTRS MUIA_Weight 50
                group
                    space
                    button ID VIEW ICON '"muirexx:demos/icons/multiview"' NODE '"button"'
                    space
                endgroup
            endgroup
            string ID FILE
        endgroup
        group
            view STRING "A demonstration of cycle and radio gadgets. This page shows 
some more examples of linked gadgets."
            group HORIZ
                group FRAME LABEL "Computer:"
                    radio ID RCMP,
                        COMMAND '"cycle ID CCMP LABEL %s"' PORT DEMO NODE '"radio"',
                        LABELS 'Amiga 500,Amiga 600,Amiga 1000,Amiga 1200,Amiga 2000,Amiga 3000,Amiga 4000,Amiga 4000T'
                endgroup
                group
                    group FRAME LABEL "Printer:"
                        radio ID RPRT,
                            COMMAND '"cycle ID CPRT LABEL %s"' PORT DEMO NODE '"radio"',
                            LABELS 'HP Deskjet,NEC P6,Okimate 20'
                    endgroup
                    group FRAME LABEL "Display:"
                        radio ID RDSP,
                            COMMAND '"cycle ID CDSP LABEL %s"' PORT DEMO NODE '"radio"',
                            LABELS 'A1081,NEC 3D,A2024,Eizo T660i'
                    endgroup
                endgroup
                group FRAME LABEL "Cycle Gadgets"
                    group HORIZ
                        group
                            label "Computer:"
                            label "Printer:"
                            label "Display:"
                        endgroup
                        group
                            cycle ID CCMP,
                                COMMAND '"radio ID RCMP LABEL %s"' PORT DEMO NODE '"cycle"',
                                LABELS 'Amiga 500,Amiga 600,Amiga 1000,Amiga 1200,Amiga 2000,Amiga 3000,Amiga 4000,Amiga 4000T'
                            cycle ID CPRT,
                                COMMAND '"radio ID RPRT LABEL %s"' PORT DEMO NODE '"cycle"',
                                LABELS 'HP Deskjet,NEC P6,Okimate 20'
                            cycle ID CDSP,
                                COMMAND '"radio ID RDSP LABEL %s"' PORT DEMO NODE '"cycle"',
                                LABELS 'A1081,NEC 3D,A2024,Eizo T660i'
                        endgroup
                    endgroup
                endgroup
            endgroup
        endgroup
        group
            view STRING "A demonstration of icon gadgets. Try clicking on the icons 
below. Also try dropping some icons from the Workbench onto these icons.  Try 
to figure out what is unusual about the image on the right (hint: it is a gadget)."
            group HORIZ
                button ID ICN1 ICON '"muirexx:demos/icons/edit"',
                    COMMAND '"string ID ISTR CONTENT edit %s"' PORT DEMO NODE '"button"',
                    LABEL 'ascii'
                button ID ICN2 ICON '"muirexx:demos/icons/paint"',
                    COMMAND '"string ID ISTR CONTENT view %s"' PORT DEMO NODE '"button"',
                    LABEL 'picture'
                button ID ICN3 ICON '"muirexx:demos/icons/multiview"',
                    COMMAND '"string ID ISTR CONTENT play %s"' PORT DEMO NODE '"button"',
                    LABEL 'anim'
                button ID ICN4 ICON '"muirexx:demos/icons/help"',
                    COMMAND '"string ID ISTR CONTENT %s"' PORT DEMO NODE '"button"',
                    LABEL 'project'
                button ID ICN5 ICON '"muirexx:demos/icons/shell"',
                    COMMAND '"string ID ISTR CONTENT execute %s"' PORT DEMO NODE '"button"',
                    LABEL 'tool'
                space HORIZ
                button PICT '"muirexx:demos/muirexx.brush"' TRANS,
                    ATTRS MUIA_Frame MUIV_Frame_None MUIA_Draggable TRUE,
                    LABEL 'muirexx.brush'
            endgroup
            string ID ISTR
        endgroup
        group
            view STRING "A demonstration of string gadgets. Try typing in some text 
into the string gadget. Also select a file using the popasl gadget. Once some 
lines have been added to the list try double clicking on one."
            list ID SLST COMMAND '"string ID SSTR CONTENT %s"' PORT DEMO NODE '"list"'
            group HORIZ
                group
                    label DOUBLE "Entry:"
                    label DOUBLE "File:"
                endgroup
                group
                    string ID SSTR COMMAND '"list ID SLST INSERT STRING %s"' PORT DEMO NODE '"string"'
                    popasl ID SASL COMMAND '"list ID SLST INSERT STRING %s"' PORT DEMO NODE '"popasl"'
                endgroup
            endgroup
        endgroup
        group
            view STRING "A simple demonstration of boopsi gadgets.  This demo 
essentially duplicates the BoopsiDoor demo included with the MUI 
distribution.  It illustrates use of boopsi gadgets in MUIRexx and also 
shows an example of notification methods."
            group HORIZ
                group
                    label DOUBLE "Hue:"
                    label DOUBLE "Saturation:"
                endgroup
                group
                    gauge ID HUE ATTRS MUIA_Gauge_Max 16384,
                                       MUIA_Gauge_Divide 262144,
                                       MUIA_Gauge_Horiz TRUE
                    gauge ID SAT ATTRS MUIA_Gauge_Max 16384,
                                       MUIA_Gauge_Divide 262144,
                                       MUIA_Gauge_Horiz TRUE
                endgroup
            endgroup
            object ID BOOP BOOPSI CLASS '"colorwheel.gadget"',
                ATTRS MUIA_Boopsi_MinWidth 30,
                      MUIA_Boopsi_MinHeight 30,
                      MUIA_Boopsi_Remember WHEEL_Hue,
                      MUIA_Boopsi_Remember WHEEL_Saturation,
                      MUIA_Boopsi_TagScreen WHEEL_Screen,
                      WHEEL_Screen 0,
                      WHEEL_Saturation 0,
                      MUIA_FillArea TRUE
        endgroup
    endgroup
    menu LABEL "Demo"
        item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Menuitem 1"
        item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Menuitem 2"
        menu LABEL "Submenu"
            item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Submenuitem 1"
            item COMMAND '"string ID STR CONTENT %s"' PORT DEMO LABEL "Submenuitem 2"
        endmenu
    endmenu
endwindow

method ID KNOB MUIM_Notify MUIA_Numeric_Value MUIV_EveryTime @METR 3 MUIM_Set MUIA_Numeric_Value MUIV_TriggerValue
method ID KNOB MUIM_Notify MUIA_Numeric_Value MUIV_EveryTime @PSLD 3 MUIM_NoNotifySet MUIA_Numeric_Value MUIV_TriggerValue
method ID PSLD MUIM_Notify MUIA_Numeric_Value MUIV_EveryTime @METR 3 MUIM_Set MUIA_Numeric_Value MUIV_TriggerValue
method ID PSLD MUIM_Notify MUIA_Numeric_Value MUIV_EveryTime @KNOB 3 MUIM_NoNotifySet MUIA_Numeric_Value MUIV_TriggerValue
method ID SLDR MUIM_Notify MUIA_Numeric_Value MUIV_EveryTime @GAUG 3 MUIM_Set MUIA_Gauge_Current MUIV_TriggerValue

method ID BOOP MUIM_Notify WHEEL_Hue MUIV_EveryTime @HUE 4 MUIM_Set MUIA_Gauge_Current MUIV_TriggerValue
method ID BOOP MUIM_Notify WHEEL_Saturation MUIV_EveryTime @SAT 4 MUIM_Set MUIA_Gauge_Current MUIV_TriggerValue

callhook ID VIEW DROP COMMAND '"string ID FILE CONTENT view %s"' PORT DEMO

callhook ID ICN1 APP DROP COMMAND '"string ID ISTR CONTENT edit %s"' PORT DEMO
callhook ID ICN2 APP DROP COMMAND '"string ID ISTR CONTENT view %s"' PORT DEMO
callhook ID ICN3 APP DROP COMMAND '"string ID ISTR CONTENT play %s"' PORT DEMO
callhook ID ICN4 APP DROP COMMAND '"string ID ISTR CONTENT %s"' PORT DEMO
callhook ID ICN5 APP DROP COMMAND '"string ID ISTR CONTENT execute %s"' PORT DEMO

callhook ID DIR1 APP DROP COMMAND '"dirlist ID DIR1 PATH %s"' PORT DEMO
callhook ID SLST APP COMMAND '"list ID SLST INSERT STRING %s"' PORT DEMO

exit
