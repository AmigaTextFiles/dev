/* */
options results
parse arg m' 'n1' 'obj1' 'n2' 'obj2

address dock

MUIA_Disabled = 0x80423661
MUIA_Draggable = 0x80420b6e
MUIA_Dropable = 0x8042fbce
MUIA_Frame = 0x8042ac64
MUIA_InputMode = 0x8042fb04

MUIV_Frame_None = 0
MUIV_InputMode_RelVerify = 1
MUIV_List_Insert_Bottom = -3
TRUE = 1
FALSE = 0

attrs1 = MUIA_Frame MUIV_Frame_None MUIA_Draggable TRUE
attrs2 = MUIA_Frame MUIV_Frame_None MUIA_Draggable TRUE

if n2 ~= 0 then do
    if n1 ~= 0 then do
        getvar B||m||n1
        entry1 = result

        getvar B||m||n2
        entry2 = result

        setvar B||m||n1 entry2
        setvar B||m||n2 entry1

        call dock_object m n2
        call dock_mode m n2 0
        callhook ID m||n2 DROP COMMAND """dock_change "m" "n2" "obj1" %s"""
        call dock_object m n1
        call dock_mode m n1 0
        call dock_save m
    end
    else do
        type = 'button'
        object2 = type
        opt2 = ''
        getvar B||m||n2
        entry2 = result

        if entry2 ~= '' then do
            parse var entry2 type' 'opt2
            parse var opt2 'ICON "'obj'"'
            if lastpos('/',obj) ~= 0 then objname = substr(obj,lastpos('/',obj)+1)
            else objname = substr(obj,lastpos(':',obj)+1)
        end
        else exit
        cycle ID BTYPE LABEL type
        list ID LLST STRING
        if type = 'pop' then do
            call open('pop',objname'.pop','R')
            do while ~eof('pop')
                line = readln('pop')
                if line ~= '' then
                    list ID LLST POS MUIV_List_Insert_Bottom INSERT STRING '='line
            end
            call close('pop')
        end

        parse var opt2 'PCOMM "'bcomm'"'
        parse var opt2 'PPORT "'bport'"'
        popasl ID PCOMM CONTENT bcomm
        string ID PPORT CONTENT bport

        parse var opt2 'ACOMM "'bcomm'"'
        parse var opt2 'APORT "'bport'"'
        popasl ID ACOMM CONTENT bcomm
        string ID APORT CONTENT bport

        parse var opt2 'DCOMM "'bcomm'"'
        parse var opt2 'DPORT "'bport'"'
        popasl ID DCOMM CONTENT bcomm
        string ID DPORT CONTENT bport

        list ID ILST STRING
        if exists(objname'.add') then do
            call open('add',objname'.add','R')
            do while ~eof('add')
                line = readln('add')
                if line ~= '' then
                    list ID ILST POS MUIV_List_Insert_Bottom INSERT STRING '='line
            end
            call close('add')
        end

        setvar B00 entry2
        call dock_object 0 0
        group ID 'G00' ATTRS MUIA_Dropable FALSE
        button ID '00' ATTRS MUIA_Draggable TRUE
        setvar ITEM n2
    end
end
else do
    if n1 ~= 0 then do
        call dock_set m n1 obj2
        call dock_object m n1
        call dock_mode m n1 0
        call dock_save m
    end
    else do
        setvar B00 'button ICON "'||obj2||'"'
        cycle ID BTYPE LABEL 'button'
        popasl ID PCOMM CONTENT ""
        string ID PPORT CONTENT ""
        popasl ID ACOMM CONTENT ""
        string ID APORT CONTENT ""
        popasl ID DCOMM CONTENT ""
        string ID DPORT CONTENT ""
        list ID LLST STRING
        list ID ILST STRING

        group ID 'G00'
         button ID '00' ICON obj2 ATTRS MUIA_Frame MUIV_Frame_None MUIA_Draggable TRUE LABEL 0 obj2
        endgroup
        group ID 'G00' ATTRS MUIA_Dropable FALSE
        call dock_object 0 0
    end
end
