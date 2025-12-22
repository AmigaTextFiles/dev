/* */
options results
parse arg '['obj']'

address BUILD

parse var obj gobj .
select
    when index(gobj,'window') > 0 then call set_window(obj)
    when index(gobj,'group') > 0 then call set_group(obj)
    when index(gobj,'menu') > 0 then call set_menu(obj)
    when index(gobj,'do') > 0 then call set_do(obj)
    when index(gobj,'item') > 0 then call set_item(obj)
    when index(gobj,'space') > 0 then call set_space(obj)
    when index(gobj,'label') > 0 then call set_label(obj)
    when index(gobj,'view') > 0 then call set_view(obj)
    when index(gobj,'gauge') > 0 then call set_gauge(obj)
    when index(gobj,'meter') > 0 then call set_gauge(obj)
    when index(gobj,'button') > 0 then call set_gadget(obj)
    when index(gobj,'text') > 0 then call set_gadget(obj)
    when index(gobj,'switch') > 0 then call set_gadget(obj)
    when index(gobj,'image') > 0 then call set_gadget(obj)
    when index(gobj,'check') > 0 then call set_gadget(obj)
    when index(gobj,'cycle') > 0 then call set_cycle(obj)
    when index(gobj,'radio') > 0 then call set_cycle(obj)
    when index(gobj,'string') > 0 then call set_string(obj)
    when index(gobj,'popasl') > 0 then call set_popasl(obj)
    when index(gobj,'poplist') > 0 then call set_popasl(obj)
    when index(gobj,'slider') > 0 then call set_slider(obj)
    when index(gobj,'popslider') > 0 then call set_slider(obj)
    when index(gobj,'knob') > 0 then call set_slider(obj)
    when index(gobj,'dirlist') > 0 then call set_dirlist(obj)
    when index(gobj,'volumelist') > 0 then call set_volumelist(obj)
    when index(gobj,'list') > 0 then call set_list(obj)
    when index(gobj,'object') > 0 then call set_object(obj)
    when index(gobj,'application') > 0 then call set_application(obj)
    when index(gobj,'method') > 0 then call set_method(obj)
    when index(gobj,'callhook') > 0 then call set_callhook(obj)
    otherwise call set_generic(obj)
end

exit

set_window: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' TITLE """'||result||'"""'
line = line||get_attrs()
call finish line
return

set_group: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
string ID S2
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S3
if result ~= '' then line = line||' NODE '||result
check ID C1
if result then line = line||' FRAME'
check ID C2
if result then line = line||' HORIZ'
cycle ID L1
gtype = result
if gtype ~= 'NORMAL' then line = line||' '||upper(gtype)
if gtype = 'POP' then do
    cycle ID L2
    type = result
    select
        when type = 'Icon' then do
            popasl ID S7
            name = result
            if name ~= '' then line = line||' ICON "'||name||'"'
        end
        when type = 'Image' then do
            poplist ID S8
            sval = result
            sname = sval
            call open('images','build:images.lst','R')
            do while ~eof('images')
                iline = readln('images')
                if iline = '' then leave
                parse var iline vname '=' value .
                if index(vname,sname) > 0 then do
                    sval = value
                    leave
                end
            end
            call close('images')
            line = line||' SPEC "'||'6:'sval||'"'
        end
        otherwise nop
    end
end
line = line||get_attrs()
string ID S4
if result ~= '' then line = line||' LABELS "'||result||'"'
call finish line
return

set_menu: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
line = line||get_attrs()
string ID S2
if result ~= '' then line = line||' LABEL "'||result||'"'
call finish line
return

set_do: procedure
parse arg obj

line = obj
string ID P1
if result ~= '' then line = line||' '||strip(result)
string ID P2
if result ~= '' then line = line||' = '||strip(result)
string ID P3
if result ~= '' then line = line||' to '||strip(result)
call finish line
return

set_item: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
line = line||get_attrs()
string ID S4
if result ~= '' then line = line||' LABEL "'||result||'"'
call finish line
return

set_space: procedure
parse arg obj

line = obj
check ID C1
if result then line = line||' BAR'
check ID C2
if result then line = line||' HORIZ'
string ID S1
if result ~= '' then line = line||' '||result
call finish line
return

set_label: procedure
parse arg obj

line = obj
check ID C1
if result then line = line||' LEFT'
check ID C2
if result then line = line||' CENTER'
check ID C3
if result then line = line||' SINGLE'
check ID C4
if result then line = line||' DOUBLE'
string ID S1
if result ~= '' then line = line||' "'||result||'"'
call finish line
return

set_view: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
string ID S2
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S3
if result ~= '' then line = line||' NODE '||result
popasl ID S4
if result ~= '' then line = line||' FILE "'||result'"'
line = line||get_attrs()
string ID S5
if result ~= '' then line = line||' STRING "'||result||'"'
call finish line
return

set_gauge: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
string ID S2
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S3
if result ~= '' then line = line||' NODE '||result
line = line||get_attrs()
string ID S4
if result ~= '' then line = line||' LABEL "'||result||'"'
call finish line
return

set_gadget: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
cycle ID L2
type = result
select
    when type = 'Icon' then do
        popasl ID S7
        name = result
        if name ~= '' then line = line||' ICON "'||name||'"'
    end
    when type = 'Image' then do
        poplist ID S8
        sval = result
        sname = sval
        call open('images','build:images.lst','R')
        do while ~eof('images')
            iline = readln('images')
            if iline = '' then leave
            parse var iline vname '=' value .
            if index(vname,sname) > 0 then do
                sval = value
                leave
            end
        end
        call close('images')
        line = line||' SPEC "'||'6:'sval||'"'
    end
    when type = 'Picture' then do
        popasl ID S7
        name = result
        if name ~= '' then do
            line = line||' PICT "'||name||'"'
            switch ID C1
            if result = 'Transparent' then line = line||' TRANS'
        end
    end
    otherwise nop
end
line = line||get_attrs()
string ID S6
if result ~= '' then line = line||' LABEL "'||result||'"'
call finish line
return

set_cycle: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
line = line||get_attrs()
string ID S6
if result ~= '' then line = line||' LABELS "'||result||'"'
call finish line
return

set_string: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
line = line||get_attrs()
string ID S6
if result ~= '' then line = line||' CONTENT "'||result||'"'
call finish line
return

set_popasl: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
cycle ID R1
spec = result
poplist ID S8
sval = result
if spec = 6 then do
    sname = sval
    call open('images','build:images.lst','R')
    do while ~eof('images')
        iline = readln('images')
        if iline = '' then leave
        parse var iline vname '=' value .
        if index(vname,sname) > 0 then do
            sval = value
            leave
        end
    end
    call close('images')
    if sval = 18 then sval = ''
end
if sval ~= '' then line = line||' SPEC "'||spec':'sval||'"'
if index(obj,'poplist') > 0 then do
    string ID S7
    if result ~= '' then line = line||' LABELS """'||result||'"""'
end
line = line||get_attrs()
string ID S6
if result ~= '' then line = line||' CONTENT "'||result||'"'
call finish line
return

set_slider: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
line = line||get_attrs()
call finish line
return

set_list: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
string ID S6
if result ~= '' then line = line||' TITLE """'||result||'"""'
string ID S7
if result ~= '' then line = line||' POS '||result
check ID C1
if result then line = line||' INSERT'
check ID C2
if result then line = line||' NODUP'
check ID C3
if result then line = line||' TOGGLE'
line = line||get_attrs()
string ID S8
if result ~= '' then line = line||' STRING '||result
call finish line
return

set_dirlist: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
string ID S6
if result ~= '' then line = line||' PATH "'||result||'"'
string ID S7
if result ~= '' then line = line||' PATTERN "'||result||'"'
check ID C1
if result then line = line||' REREAD'
check ID C2
if result then line = line||' TOGGLE'
line = line||get_attrs()
call finish line
return

set_volumelist: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
line = line||get_attrs()
call finish line
return

set_object: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||addobj(result)
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then line = line||' HELP """'||result||'"""'
string ID S5
if result ~= '' then line = line||' NODE '||result
string ID S6
if result ~= '' then line = line||' CLASS "'||result||'"'
check ID C1
if result then line = line||' BOOPSI'
line = line||get_attrs()
call finish line
return

set_application: procedure
parse arg obj

line = obj||get_attrs()
call finish line
return

set_method: procedure
parse arg obj

line = obj
string ID S1
if result ~= '' then line = line||' ID '||result
i = 0
do forever
    list ID ALST POS i
    aname = result
    if aname = '' then break
    line = line||' '||strip(aname)
    i = i + 1
end
call finish line
return

set_callhook: procedure
parse arg obj

Selected =                        0x8042654b /* V4  isg BOOL              */

line = obj
string ID S1
if result ~= '' then line = line||' ID '||result
switch ID C1 ATTRS Selected
if result then line = line||' PRESS'
switch ID C2 ATTRS Selected
if result then line = line||' APP'
switch ID C3 ATTRS Selected
if result then line = line||' DROP'
popasl ID S2
if result ~= '' then line = line||' COMMAND """'||result||'"""'
string ID S3
if result ~= '' then line = line||' PORT '||result
string ID S4
if result ~= '' then do
    line = line||' ATTRS '||result
    string ID S5
    if result ~= '' then line = line||' '||result
end
string ID S6
if result ~= '' then line = line||' INCLUDE "'||result||'"'
string ID S7
if result ~= '' then line = line||' EXCLUDE "'||result||'"'
call finish line
return

set_generic: procedure

line = ''
string ID P1
if result ~= '' then line = result
call finish line
return

finish: procedure
parse arg line

List_Active =                     0x8042391c /* V4  isg LONG              */

window ID SET CLOSE
list ID DLST ATTRS List_Active
n = result
list ID DLST POS n STRING '='||line
return

get_attrs: procedure

line = ''
i = 0
do forever
    list ID ALST POS i
    aname = result
    if aname = '' then break
    if i = 0 then line = line||' ATTRS'
    parse var aname name','value
    if strip(value) ~= '' then line = line||' '||strip(name)||' '||strip(value)
    i = i + 1
end
return line

addobj: procedure
parse arg obj

getvar objlist
objects = result
if index(objects,obj) = 0 then objects = objects||obj||','
setvar objlist objects
return obj
