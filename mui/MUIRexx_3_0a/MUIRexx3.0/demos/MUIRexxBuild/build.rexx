/* A MUIRexx application for building MUIRexx Applications */
options results

/* Method TAG ID definitions */

List_InsertSingle = 0x804254d5 /*               { ULONG MethodID; APTR entry; LONG pos; }; */
Application_OpenConfigWindow = 0x804299ba /*    { ULONG MethodID; ULONG flags; }; */

/* Attribute TAG ID definitions */

Draggable =                       0x80420b6e /* V11 isg BOOL              */
Dropable =                        0x8042fbce /* V11 isg BOOL              */
Group_Columns =                   0x8042f416 /* V4  is. LONG              */
Listview_DragType =               0x80425cd3 /* V11 isg LONG              */
Listview_MultiSelect =            0x80427e08
List_DragSortable =               0x80426099 /* V11 isg BOOL              */
List_ShowDropMarks =              0x8042c6f3 /* V11 isg BOOL              */
Menuitem_Shortcut =               0x80422030 /* V8  isg STRPTR            */
Menuitem_Title =                  0x804218be /* V8  isg STRPTR            */
Weight =                          0x80421d1f /* V4  i.. WORD              */

/* TAG variable definitions */

TRUE = 1
FALSE = 0
Listview_DragType_Immediate = 1
Listview_MultiSelect_Shifted = 2
List_GetEntry_Active = -1
List_Insert_Active = -1
List_Insert_Bottom = -3

address command "assign build: MUIRexx:demos/MUIRexxBuild"

address BUILD

window ID BWIN TITLE """MUIRexx GUI Builder""" COMMAND """quit""" PORT BUILD
    menu LABEL "Project"
        item COMMAND """build:about""" ATTRS Menuitem_Shortcut 'A' LABEL "About"
        item ATTRS Menuitem_Title '-1'
        menu LABEL "Settings"
            item COMMAND '"method 'Application_OpenConfigWindow'"' PORT BUILD LABEL "MUI..."
        endmenu
        item ATTRS Menuitem_Title '-1'
        item COMMAND """build:comm SAVE""" ATTRS Menuitem_Shortcut 'S' LABEL "Save"
        item COMMAND """build:comm SAVEAS""" ATTRS Menuitem_Shortcut 'W' LABEL "Save as..."
        item COMMAND """build:comm READ""" ATTRS Menuitem_Shortcut 'R' LABEL "Read"
        item ATTRS Menuitem_Title "-1"
        item COMMAND """quit""" PORT BUILD ATTRS Menuitem_Shortcut 'Q' LABEL "Quit"
    endmenu
    group
        group HORIZ
            group ATTRS Weight 0
                group HORIZ
                    label DOUBLE "Port:"
                    string ID APRT CONTENT "TEST"
                endgroup
                group HORIZ FRAME LABEL "containers"
                    button ATTRS Draggable TRUE NODE "window" LABEL "window"
                    button ATTRS Draggable TRUE NODE "group" LABEL "group"
                    button ATTRS Draggable TRUE NODE "menu" LABEL "menu"
                    button ATTRS Draggable TRUE LABEL "do"
                endgroup
                group FRAME ATTRS Group_Columns 3 LABEL "objects"
                    button ATTRS Draggable TRUE NODE "item" LABEL "item"
                    button ATTRS Draggable TRUE NODE "space" LABEL "space"
                    button ATTRS Draggable TRUE NODE "label" LABEL "label"
                    button ATTRS Draggable TRUE NODE "view" LABEL "view"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "gauge" LABEL "gauge"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "meter" LABEL "meter"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "button" LABEL "button"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "text" LABEL "text"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "switch" LABEL "switch"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "image" LABEL "image"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "check" LABEL "check"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "cycle" LABEL "cycle"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "radio" LABEL "radio"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "string" LABEL "string"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "popasl" LABEL "popasl"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "poplist" LABEL "poplist"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "slider" LABEL "slider"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "popslider" LABEL "popslider"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "knob" LABEL "knob"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "list" LABEL "list"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "dirlist" LABEL "dirlist"
                    button ATTRS Draggable TRUE COMMAND """build:change_object %s""" NODE "volumelist" LABEL "volumelist"
                    button ATTRS Draggable TRUE NODE "object" LABEL "object"
                    button ATTRS Draggable TRUE LABEL
                endgroup
                group HORIZ FRAME LABEL "miscellaneous"
                    button ATTRS Draggable TRUE NODE "application" LABEL "application"
                    button ATTRS Draggable TRUE NODE "method" LABEL "method"
                    button ATTRS Draggable TRUE NODE "callhook" LABEL "callhook"
                endgroup
                space
            endgroup
            group REGISTER LABELS "Commands,Variables"
                group
                    list ID DLST COMMAND """build:ask_object [%s]""",
                        HELP """Drag and drop an object to create.\nDouble click on object to edit.\nClick on other object to change.""",
                        ATTRS Listview_DragType Listview_DragType_Immediate,
                              Listview_MultiSelect Listview_MultiSelect_Shifted,
                              List_DragSortable TRUE
                    group HORIZ
                        button COMMAND """build:comm LEFT""" LABEL "<-"
                        button COMMAND """build:comm RIGHT""" LABEL "->"
                        button COMMAND """build:comm COPY""" LABEL "Copy"
                        button COMMAND """list ID DLST POS "List_GetEntry_Active" STRING""" PORT BUILD LABEL "Remove"
                    endgroup
                    group HORIZ
                        button COMMAND """build:comm CREATE""" LABEL "Create"
                        button COMMAND """build:comm CLOSE""" LABEL "Close"
                        button COMMAND """build:comm NEW""" LABEL "New"
                    endgroup
                endgroup
                group
                    list ID VLST COMMAND """string ID VSTR CONTENT %s""" PORT BUILD,
                        HELP """Drag and drop a variable name to define.""",
                        ATTRS Listview_DragType Listview_DragType_Immediate,
                              List_DragSortable TRUE
                    string ID VSTR COMMAND """list ID VLST INSERT POS "List_Insert_Bottom" NODUP STRING %s""" PORT BUILD
                    group HORIZ
                        button COMMAND """build:attrs LIST""" LABEL "Attribute List"
                        button COMMAND """build:attrs VLIST""" LABEL "Variable List"
                    endgroup
                    group HORIZ
                        button COMMAND """list ID VLST POS "List_GetEntry_Active" STRING""" PORT BUILD LABEL "Remove"
                    endgroup
                endgroup
            endgroup
        endgroup
    endgroup
endwindow
callhook ID DLST DROP COMMAND """build:drop_object %s""" EXCLUDE 'BLST,CLST,MLST,ELST,OOLST,OALST,OVLST'
callhook ID VLST DROP COMMAND """build:attrs VADD %s""" INCLUDE 'BLST,CLST,MLST'
setvar directory 'build:test'
setvar objlist
exit
