/* */
options results
parse arg '['obj']'

address BUILD

window ID SET CLOSE

parse var obj gobj .
gobj = strip(gobj)
select
    when index(gobj,'end') = 1 then nop
    when index(gobj,'window') = 1 then call open_ask_window(obj)
    when index(gobj,'group') = 1 then call open_ask_group(obj)
    when index(gobj,'menu') = 1 then call open_ask_menu(obj)
    when index(gobj,'do') = 1 then call open_ask_do(obj)
    when index(gobj,'item') = 1 then call open_ask_item(obj)
    when index(gobj,'space') = 1 then call open_ask_space(obj)
    when index(gobj,'label') = 1 then call open_ask_label(obj)
    when index(gobj,'view') = 1 then call open_ask_view(obj)
    when index(gobj,'gauge') = 1 then call open_ask_gauge(obj)
    when index(gobj,'meter') = 1 then call open_ask_gauge(obj)
    when index(gobj,'button') = 1 then call open_ask_gadget(obj)
    when index(gobj,'text') = 1 then call open_ask_gadget(obj)
    when index(gobj,'switch') = 1 then call open_ask_gadget(obj)
    when index(gobj,'image') = 1 then call open_ask_gadget(obj)
    when index(gobj,'check') = 1 then call open_ask_gadget(obj)
    when index(gobj,'cycle') = 1 then call open_ask_cycle(obj)
    when index(gobj,'radio') = 1 then call open_ask_cycle(obj)
    when index(gobj,'string') = 1 then call open_ask_string(obj)
    when index(gobj,'popasl') = 1 then call open_ask_popasl(obj)
    when index(gobj,'poplist') = 1 then call open_ask_popasl(obj)
    when index(gobj,'slider') = 1 then call open_ask_slider(obj)
    when index(gobj,'popslider') = 1 then call open_ask_slider(obj)
    when index(gobj,'knob') = 1 then call open_ask_slider(obj)
    when index(gobj,'dirlist') = 1 then call open_ask_dirlist(obj)
    when index(gobj,'volumelist') = 1 then call open_ask_volumelist(obj)
    when index(gobj,'list') = 1 then call open_ask_list(obj)
    when index(gobj,'object') = 1 then call open_ask_object(obj)
    when index(gobj,'application') = 1 then call open_ask_application(obj)
    when index(gobj,'method') = 1 then call open_ask_method(obj)
    when index(gobj,'callhook') = 1 then call open_ask_callhook(obj)
    otherwise call open_ask_generic(obj)
end

exit

open_ask_window: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'TITLE """'glabel'"""' .,'ATTRS 'gattrs

window ID SET TITLE '"Window Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Title:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT glabel
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_group: procedure
parse arg line

MUIA_Frame =                      0x8042ac64 /* V4  i.. LONG              */
Disabled =                        0x80423661 /* V4  isg BOOL              */
Selected =                        0x8042654b /* V4  isg BOOL              */
Weight =                          0x80421d1f /* V4  i.. WORD              */
TRUE = 1
FALSE = 0

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
parse var args 'HELP """'ghelp'"""' .,'NODE 'gnode .,'ICON "'gicon'"' .,'SPEC "6:'gimage'"' .,'ATTRS 'gattrs 'LABEL' .,'LABELS "'glabel'"'

window ID SET TITLE '"Group Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Image,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Labels:"
                label SINGLE "Frame:"
                label SINGLE "Horiz:"
                label SINGLE "Type:"
            endgroup
            group
                string ID S1 CONTENT gid
                string ID S2 CONTENT ghelp
                string ID S3 CONTENT gnode
                string ID S4 CONTENT glabel
                group HORIZ
                    group
                        if index(args,'FRAME') ~= 0 then check ID C1 ATTRS Selected TRUE
                        else check ID C1 ATTRS Selected FALSE
                        if index(args,'HORIZ') ~= 0 then check ID C2 ATTRS Selected TRUE
                        else check ID C2 ATTRS Selected FALSE
                    endgroup
                    space HORIZ
                endgroup
                cycle ID L1 ATTRS Weight 0 LABELS 'NORMAL,REGISTER,VIRTUAL,SCROLL,POP'
            endgroup
        endgroup
        group
            space
            group HORIZ
                cycle ID L2 COMMAND '"build:ask_comm IMAGE"' ATTRS Weight 0 LABELS 'Icon,Image,None'
                space HORIZ
                group ID GIMG
                    switch ID AIMG ATTRS MUIA_Frame 0
                endgroup
                space HORIZ
            endgroup
            space
            group HORIZ
                group
                    label DOUBLE "File:"
                    label DOUBLE "Spec:"
                endgroup
                group
                    popasl ID S7 COMMAND '"build:ask_comm SET %s"'
                    poplist ID S8 COMMAND '"build:ask_comm ISET %s"' LABELS 'ArrowUp,ArrowDown,ArrowLeft,ArrowRight,CheckMark,RadioButton,Cycle,PopUp,PopFile,PopDrawer,PropKnob,Drawer,HardDisk,Disk,Chip,Volume,Network,Assign,TapePlay,TapePlayBack,TapePause,TapeStop,TapeRecord,SliderKnob,TapeUp,TapeDown'
                endgroup
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
if index(line,'REGISTER') ~= 0 then cycle ID L1 LABEL 'REGISTER'
if index(line,'VIRTUAL') ~= 0 then cycle ID L1 LABEL 'VIRTUAL'
if index(line,'SCROLL') ~= 0 then cycle ID L1 LABEL 'SCROLL'
if index(line,'POP') ~= 0 then cycle ID L1 LABEL 'POP'
callhook ID AIMG APP COMMAND '"build:ask_comm SET %s"'
select
    when gicon ~= '' then do
        poplist ID S8 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'Icon'
        popasl ID S7 CONTENT gicon
        call 'build:ask_comm' SET gicon
    end
    when gimage ~= '' then do
        popasl ID S7 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'Image'
        call 'build:ask_comm' ISET gimage
    end
    otherwise do
        popasl ID S7 ATTRS Disabled TRUE
        poplist ID S8 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'None'
    end
end
call attrscomm gattrs
return

open_ask_menu: procedure
parse arg line

parse var line obj .,'ID 'gid .,'ATTRS 'gattrs 'LABEL' .,'LABEL "'glabel'"'

gobj = insert(obj,'',pos(obj,line)-1)
window ID SET TITLE '"Menu Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Label:"
            endgroup
            group
                string ID S1 CONTENT gid
                string ID S2 CONTENT glabel
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_do: procedure
parse arg line

CycleChain =                      0x80421ce7 /* V11 isg LONG              */
Frame =                           0x8042ac64 /* V4  i.. LONG              */

Frame_None = 0

parse var line obj counter' = 'begin' to 'finish

gobj = insert(obj,'',pos(obj,line)-1)
window ID SET TITLE '"Do Loop"' COMMAND '"build:set_object ['gobj']"'
    group HORIZ
        space HORIZ
        group HORIZ 'FRAME'
            label DOUBLE 'do'
            string ID P1 ATTRS CycleChain 1 Frame Frame_None CONTENT counter
            label DOUBLE '"="'
            string ID P2 ATTRS CycleChain 1 Frame Frame_None CONTENT begin
            label DOUBLE 'to'
            string ID P3 ATTRS CycleChain 1 Frame Frame_None CONTENT finish
        endgroup
        space HORIZ
    endgroup
    call okgroup gobj
endwindow
return

open_ask_item: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'ATTRS 'gattrs 'LABEL' .,'LABEL "'glabel'"'

window ID SET TITLE '"Item Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Label:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT glabel
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_space: procedure
parse arg line

Selected =                        0x8042654b /* V4  isg BOOL              */
TRUE = 1
FALSE = 0

parse var line obj opt

gobj = insert(obj,'',pos(obj,line)-1)
window ID SET TITLE '"Space Object"' COMMAND '"build:set_object ['gobj']"'
    group HORIZ
        group
            label SINGLE "Bar:"
            label SINGLE "Horiz:"
            label DOUBLE "Value:"
        endgroup
        group
            group HORIZ
                group
                    if index(opt,'BAR') ~= 0 then do
                        check ID C1 ATTRS Selected TRUE
                        opt = substr(opt,index(opt,'BAR')+4)
                    end
                    else check ID C1 ATTRS Selected FALSE
                    if index(opt,'HORIZ') ~= 0 then do
                        check ID C2 ATTRS Selected TRUE
                        opt = substr(opt,index(opt,'HORIZ')+6)
                    end
                    else check ID C2 ATTRS Selected FALSE
                endgroup
                space HORIZ
            endgroup
            string ID S1 CONTENT opt
        endgroup
    endgroup
    call okgroup gobj
endwindow
return

open_ask_label: procedure
parse arg line

Selected =                        0x8042654b /* V4  isg BOOL              */
TRUE = 1
FALSE = 0

parse var line obj .,'"'glabel'"'

gobj = insert(obj,'',pos(obj,line)-1)
window ID SET TITLE '"Label Object"' COMMAND '"build:set_object ['gobj']"'
    group HORIZ
        group
            label SINGLE "Left:"
            label SINGLE "Center:"
            label SINGLE "Single:"
            label SINGLE "Double:"
            label DOUBLE "Label:"
        endgroup
        group
            group HORIZ
                group
                    if index(line,'LEFT') ~= 0 then check ID C1 ATTRS Selected TRUE
                    else check ID C1 ATTRS Selected FALSE
                    if index(line,'CENTER') ~= 0 then check ID C2 ATTRS Selected TRUE
                    else check ID C2 ATTRS Selected FALSE
                    if index(line,'SINGLE') ~= 0 then check ID C3 ATTRS Selected TRUE
                    else check ID C3 ATTRS Selected FALSE
                    if index(line,'DOUBLE') ~= 0 then check ID C4 ATTRS Selected TRUE
                    else check ID C4 ATTRS Selected FALSE
                endgroup
                space HORIZ
            endgroup
            string ID S1 CONTENT glabel
        endgroup
    endgroup
    call okgroup gobj
endwindow
return

open_ask_view: procedure
parse arg line

parse var line obj .,'ID 'gid .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'FILE "'gfile'"' .,'ATTRS 'gattrs 'STRING' .,'STRING "'gstring'"'

gobj = insert(obj,'',pos(obj,line)-1)
window ID SET TITLE '"View Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "File:"
                label DOUBLE "String:"
            endgroup
            group
                string ID S1 CONTENT gid
                string ID S2 CONTENT ghelp
                string ID S3 CONTENT gnode
                popasl ID S4 CONTENT gfile
                string ID S5 CONTENT gstring
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_gauge: procedure
parse arg line

parse var line obj .,'ID 'gid .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'ATTRS 'gattrs 'LABEL' .,'LABEL "'glabel'"'

gobj = insert(obj,'',pos(obj,line)-1)
window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Label:"
            endgroup
            group
                string ID S1 CONTENT gid
                string ID S2 CONTENT ghelp
                string ID S3 CONTENT gnode
                string ID S4 CONTENT glabel
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_gadget: procedure
parse arg line

MUIA_AppMessage =                 0x80421955 /* V5  ..g struct AppMessage * */
MUIA_Frame =                      0x8042ac64 /* V4  i.. LONG              */
MUIA_String_MaxLen =              0x80424984 /* V4  i.g LONG              */
Disabled =                        0x80423661 /* V4  isg BOOL              */
Selected =                        0x8042654b /* V4  isg BOOL              */
Weight =                          0x80421d1f /* V4  i.. WORD              */

MUIV_EveryTime = 0x49893131
TRUE = 1
FALSE = 0

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'ICON "'gicon'"' .,'SPEC "6:'gimage'"' .,'PICT "'gpict'"' .,'ATTRS 'gattrs 'LABEL' .,'LABEL "'glabel'"'

window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Image,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Label:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
                string ID S6 CONTENT glabel
            endgroup
        endgroup
        group
            space
            group HORIZ
                group
                    cycle ID L2 COMMAND '"build:ask_comm IMAGE"' ATTRS Weight 0 LABELS 'Icon,Image,Picture,None'
                    if index(args,'TRANS') ~= 0 then switch ID C1 COMMAND '"build:ask_comm SET"' ATTRS Selected TRUE LABELS "Opaque,Transparent"
                    else switch ID C1 COMMAND '"build:ask_comm SET"' LABELS "Opaque,Transparent"
                endgroup
                space HORIZ
                group ID GIMG
                    switch ID AIMG ATTRS MUIA_Frame 0
                endgroup
                space HORIZ
            endgroup
            space
            group HORIZ
                group
                    label DOUBLE "File:"
                    label DOUBLE "Spec:"
                endgroup
                group
                    popasl ID S7 COMMAND '"build:ask_comm SET %s"'
                    poplist ID S8 COMMAND '"build:ask_comm ISET %s"' LABELS 'ArrowUp,ArrowDown,ArrowLeft,ArrowRight,CheckMark,RadioButton,Cycle,PopUp,PopFile,PopDrawer,PropKnob,Drawer,HardDisk,Disk,Chip,Volume,Network,Assign,TapePlay,TapePlayBack,TapePause,TapeStop,TapeRecord,SliderKnob,TapeUp,TapeDown'
                endgroup
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
callhook ID AIMG APP COMMAND '"build:ask_comm SET %s"'
select
    when gicon ~= '' then do
        switch ID C1 ATTRS Disabled TRUE
        poplist ID S8 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'Icon'
        popasl ID S7 CONTENT gicon
        call 'build:ask_comm' SET gicon
    end
    when gimage ~= '' then do
        switch ID C1 ATTRS Disabled TRUE
        popasl ID S7 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'Image'
        call 'build:ask_comm' ISET gimage
    end
    when gpict ~= '' then do
        poplist ID S8 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'Picture'
        popasl ID S7 CONTENT gpict
        call 'build:ask_comm' SET gpict
    end
    otherwise do
        switch ID C1 ATTRS Disabled TRUE
        popasl ID S7 ATTRS Disabled TRUE
        poplist ID S8 ATTRS Disabled TRUE
        cycle ID L2 LABEL 'None'
    end
end
call attrscomm gattrs
return

open_ask_cycle: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'ATTRS 'gattrs 'LABELS' .,'LABELS "'glabel'"'

window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Labels:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
                string ID S6 CONTENT glabel
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_string: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'ATTRS 'gattrs 'CONTENT' .,'CONTENT "'glabel'"'

window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Content:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
                string ID S6 CONTENT glabel
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_popasl: procedure
parse arg line

MUIA_Frame =                           0x8042ac64 /* V4  i.. LONG              */
MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */
Weight =                          0x80421d1f /* V4  i.. WORD              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'SPEC "'gspec':'gimage'"' .,'LABELS """'glabels'"""' .,'ATTRS 'gattrs 'CONTENT' .,'CONTENT "'glabel'"'

window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Image,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Content:"
                if obj = 'poplist' then label DOUBLE "Labels:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
                string ID S6 CONTENT glabel
                if obj = 'poplist' then string ID S7 CONTENT glabels
            endgroup
        endgroup
        group
            space
            group HORIZ
                space HORIZ
                group ID GIMG
                    image ID AIMG ATTRS MUIA_Frame 0
                endgroup
                space HORIZ
            endgroup
            space
            group HORIZ
                label DOUBLE "Spec:"
                poplist ID S8 COMMAND '"build:ask_comm ISET %s"' LABELS 'ArrowUp,ArrowDown,ArrowLeft,ArrowRight,CheckMark,RadioButton,Cycle,PopUp,PopFile,PopDrawer,PropKnob,Drawer,HardDisk,Disk,Chip,Volume,Network,Assign,TapePlay,TapePlayBack,TapePause,TapeStop,TapeRecord,SliderKnob,TapeUp,TapeDown'
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
if gimage = '' then gimage = 18
call 'build:ask_comm' ISET gimage
call attrscomm gattrs
return

open_ask_slider: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'ATTRS 'gattrs

window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_list: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */
Selected =                        0x8042654b /* V4  isg BOOL              */
Weight =                          0x80421d1f /* V4  i.. WORD              */
TRUE = 1
FALSE = 0

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'TITLE """'gtitle'"""' .,'POS 'gpos .,'ATTRS 'gattrs 'STRING' .,'STRING 'gstring

window ID SET TITLE '"List Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Title:"
                label DOUBLE "Pos:"
                label DOUBLE "String:"
                label SINGLE "Insert:"
                label SINGLE "Nodup:"
                label SINGLE "Toggle:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
                string ID S6 CONTENT gtitle
                string ID S7 CONTENT gpos
                string ID S8 CONTENT gstring
                group HORIZ
                    group
                        if index(args,'INSERT') ~= 0 then check ID C1 ATTRS Selected TRUE
                        else check ID C1 ATTRS Selected FALSE
                        if index(args,'NODUP') ~= 0 then check ID C2 ATTRS Selected TRUE
                        else check ID C2 ATTRS Selected FALSE
                        if index(args,'TOGGLE') ~= 0 then check ID C3 ATTRS Selected TRUE
                        else check ID C3 ATTRS Selected FALSE
                    endgroup
                    space HORIZ
                endgroup
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_dirlist: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */
Selected =                        0x8042654b /* V4  isg BOOL              */
Weight =                          0x80421d1f /* V4  i.. WORD              */
TRUE = 1
FALSE = 0

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'PATH "'gpath'"' .,'PATTERN "'gpattern'"' .,'ATTRS 'gattrs

window ID SET TITLE '"Dirlist Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
                label DOUBLE "Path:"
                label DOUBLE "Pattern:"
                label SINGLE "Reread:"
                label SINGLE "Toggle:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
                string ID S6 CONTENT gpath
                string ID S7 CONTENT gpattern
                group HORIZ
                    group
                        if index(args,'REREAD') ~= 0 then check ID C1 ATTRS Selected TRUE
                        else check ID C1 ATTRS Selected FALSE
                        if index(args,'TOGGLE') ~= 0 then check ID C2 ATTRS Selected TRUE
                        else check ID C2 ATTRS Selected FALSE
                    endgroup
                    space HORIZ
                endgroup
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_volumelist: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'ATTRS 'gattrs

window ID SET TITLE '"Volumelist Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_object: procedure
parse arg line

MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */
Selected =                        0x8042654b /* V4  isg BOOL              */
List_Format =                     0x80423c0a /* V4  isg STRPTR            */
TRUE = 1
FALSE = 0

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'HELP """'ghelp'"""' .,'NODE 'gnode .,'CLASS "'gclass'"' .,'ATTRS 'gattrs

window ID SET TITLE '"Object"' COMMAND '"build:set_object ['gobj']"'
    group REGISTER LABELS "Options,Classes,Attributes"
        group HORIZ
            group
                label DOUBLE "ID:"
                label DOUBLE "Command:"
                label DOUBLE "Port:"
                label DOUBLE "Help:"
                label DOUBLE "Node:"
            endgroup
            group
                string ID S1 CONTENT gid
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                string ID S3 CONTENT gport
                string ID S4 CONTENT ghelp
                string ID S5 CONTENT gnode
            endgroup
        endgroup
        group
            dirlist ID D1 COMMAND '"build:ask_comm CSET %s"' ATTRS List_Format '""'
            group HORIZ
                group
                    label DOUBLE "Class:"
                    label SINGLE "Boopsi:"
                endgroup
                group
                    string ID S6 CONTENT gclass
                    group HORIZ
                        group
                            if index(args,'BOOPSI') ~= 0 then check ID C1 COMMAND '"build:ask_comm CLASS"' ATTRS Selected TRUE
                            else check ID C1 COMMAND '"build:ask_comm CLASS"' ATTRS Selected FALSE
                        endgroup
                        space HORIZ
                    endgroup
                endgroup
            endgroup
        endgroup
        call attrsgroup
    endgroup
    call okgroup gobj
endwindow
check ID C1
if result then dirlist ID D1 PATH '"SYS:Classes/Gadgets"'
else dirlist ID D1 PATH '"MUI:Libs/MUI"'
call attrscomm gattrs
return

open_ask_generic: procedure
parse arg line

window ID SET TITLE '"Generic Object"' COMMAND '"build:set_object []"'
    string ID P1 CONTENT line
    call okgroup gobj
endwindow
return

open_ask_application: procedure
parse arg line

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
parse var args 'ATTRS 'gattrs

window ID SET TITLE '"Application"' COMMAND '"build:set_object ['gobj']"'
    call attrsgroup
    call okgroup gobj
endwindow
call attrscomm gattrs
return

open_ask_method: procedure
parse arg line

Dropable =                        0x8042fbce /* V11 isg BOOL              */
Listview_DragType =               0x80425cd3 /* V11 isg LONG              */
List_DragSortable =               0x80426099 /* V11 isg BOOL              */
Listview_DragType_Immediate = 1
List_Insert_Bottom = -3
List_GetEntry_Active = -1
TRUE = 1

parse var line obj args
gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
parse var args gattrs

window ID SET TITLE '"Method"' COMMAND '"build:set_object ['gobj']"'
    group
        group HORIZ
            label DOUBLE "ID:"
            string ID S1 CONTENT gid
        endgroup
        list ID ALST COMMAND '"build:attrs ASKSET %s"',
            ATTRS Listview_DragType Listview_DragType_Immediate,
                  List_DragSortable TRUE
        string COMMAND '"list ID ALST INSERT POS List_Insert_Bottom STRING %s"' PORT BUILD
        group
            button COMMAND '"build:attrs MLIST"' LABEL 'Method List'
            button COMMAND '"build:attrs LIST"' LABEL 'Attribute List'
            button COMMAND '"build:attrs VLIST"' LABEL 'Variable List'
            button COMMAND '"list ID ALST POS 'List_GetEntry_Active' STRING"' PORT BUILD LABEL 'Remove'
        endgroup
    endgroup
    call okgroup gobj
endwindow
callhook ID ALST DROP COMMAND '"build:attrs MADD %s"' INCLUDE 'BLST,CLST,MLST'
do while gattrs ~= ''
    parse var gattrs name gattrs
    list ID ALST INSERT POS List_Insert_Bottom STRING name
end
return

open_ask_callhook: procedure
parse arg line

MUIA_Weight = 0x80421d1f
MUIA_Group_Spacing = 0x8042866d
MUIA_String_MaxLen =                   0x80424984 /* V4  i.g LONG              */
Listview_DragType =               0x80425cd3 /* V11 isg LONG              */
Dropable =                        0x8042fbce /* V11 isg BOOL              */
Selected =                        0x8042654b /* V4  isg BOOL              */
List_Format =                     0x80423c0a /* V4  isg STRPTR            */

TRUE = 1
FALSE = 0
Listview_DragType_Immediate = 1

parse var line obj args

gobj = insert(obj,'',pos(obj,line)-1)
if index(strip(args),'ID') = 1 then parse var args 'ID 'gid args
else gid = ''
if index(args,'COMMAND') > 0 then parse var args 'COMMAND """'gcommand'"""' args
else gcommand = ''
parse var args 'PORT 'gport .,'INCLUDE "'ginclude'"' .,'EXCLUDE "'gexclude'"' .,'ATTRS 'gtrig' 'gval

window ID SET TITLE '"Callhook"' COMMAND '"build:set_object ['gobj']"'
    group HORIZ
        group
            label DOUBLE "ID:"
            label DOUBLE "Command:"
            label DOUBLE "Port:"
            label DOUBLE "Trigger:"
            label DOUBLE "Value:"
            label DOUBLE "Include:"
            label DOUBLE "Exclude:"
        endgroup
        group
            string ID S1 CONTENT gid
            group HORIZ
                popasl ID S2 ATTRS MUIA_String_MaxLen 160 CONTENT gcommand
                group HORIZ ATTRS MUIA_Weight 0 MUIA_Group_Spacing 0
                    switch ID C1 LABEL "P,\033bP"
                    switch ID C2 LABEL "A,\033bA"
                    switch ID C3 LABEL "D,\033bD"
                endgroup
            endgroup
            string ID S3 CONTENT gport
            string ID S4 CONTENT gtrig
            string ID S5 CONTENT gval
            string ID S6 CONTENT ginclude
            string ID S7 CONTENT gexclude
        endgroup
    endgroup
    group REGISTER LABELS "Attributes,Variables,Objects"
        list ID OALST ATTRS Listview_DragType Listview_DragType_Immediate
        list ID OVLST ATTRS Listview_DragType Listview_DragType_Immediate
        list ID OOLST ATTRS Listview_DragType Listview_DragType_Immediate
    endgroup
    call okgroup gobj
endwindow
callhook ID S4 DROP COMMAND '"build:callhook_comm ADD %s"' INCLUDE OALST
callhook ID S5 DROP COMMAND '"build:callhook_comm VADD %s"' INCLUDE OVLST
callhook ID S6 DROP COMMAND '"build:callhook_comm IADD %s"' INCLUDE OOLST
callhook ID S7 DROP COMMAND '"build:callhook_comm XADD %s"' INCLUDE OOLST
if index(line,'PRESS') ~= 0 then switch ID C1 ATTRS Selected TRUE
if index(line,'APP') ~= 0 then switch ID C2 ATTRS Selected TRUE
if index(line,'DROP') ~= 0 then switch ID C3 ATTRS Selected TRUE

list ID OALST INSERT STRING 'MUIA_Window_Activate,0x80428d2f'
list ID OALST INSERT STRING 'MUIA_Timer,0x80426435'
list ID OALST INSERT STRING 'MUIA_Selected,0x8042654b'
list ID OALST INSERT STRING 'MUIA_Pressed,0x80423535'
list ID OALST INSERT STRING 'MUIA_Numeric_Value,0x8042ae3a'
list ID OALST INSERT STRING 'MUIA_List_Active,0x8042391c'
list ID OALST INSERT STRING 'MUIA_Listview_SelectChange,0x8042178f'

list ID OVLST INSERT STRING 'TRUE,1'
list ID OVLST INSERT STRING 'FALSE,0'
list ID OVLST INSERT STRING 'MUIV_EveryTime,0x49893131'

getvar objlist
objects = result
do while objects ~= ''
    parse var objects obj','objects
    list ID OOLST INSERT STRING obj
end
return

attrsgroup: procedure

Dropable =                        0x8042fbce /* V11 isg BOOL              */
List_Format =                     0x80423c0a /* V4  isg STRPTR            */
List_DragSortable =               0x80426099 /* V11 isg BOOL              */
Listview_DragType =               0x80425cd3 /* V11 isg LONG              */
Listview_DragType_Immediate = 1
List_GetEntry_Active = -1
TRUE = 1

group
    list ID ALST COMMAND '"build:attrs ASKSET %s"',
        ATTRS List_Format '"BAR,"',
              Listview_DragType Listview_DragType_Immediate,
              List_DragSortable TRUE,
        HELP '"Drag and drop an attribute from list.\nDouble click on attribute to edit."'
    string COMMAND '"build:attrs ADD %s"'
    group HORIZ
        button COMMAND '"build:attrs LIST"' LABEL 'Attribute List'
        button COMMAND '"list ID ALST POS 'List_GetEntry_Active' STRING"' PORT BUILD LABEL 'Remove'
    endgroup
endgroup
return

attrscomm: procedure
parse arg gattrs

List_Insert_Bottom = -3

do while gattrs ~= ''
    parse var gattrs name value gattrs
    if index(value,'"""') = 1 then do
        parse var gattrs addval'"""' gattrs
        value = value||addval||'"""'
    end
    list ID ALST INSERT POS List_Insert_Bottom STRING name',='value
end
callhook ID ALST DROP COMMAND '"build:attrs ADD %s"' INCLUDE 'BLST'
return

okgroup: procedure
parse arg gobj

group HORIZ
    button COMMAND '"build:set_object ['gobj']"' LABEL 'OK'
    space HORIZ
    button COMMAND '"window ID SET CLOSE"' PORT BUILD LABEL 'CANCEL'
endgroup
return
