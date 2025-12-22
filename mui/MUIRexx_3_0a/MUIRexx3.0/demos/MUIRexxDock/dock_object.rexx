/* */
options results
options failat 20
parse arg m' 'n

address dock

MUIA_Frame = 0x8042ac64
MUIA_Group_Spacing = 0x8042866d
MUIA_InputMode = 0x8042fb04

MUIV_Frame_None = 0
MUIV_InputMode_RelVerify = 1

if (m ~= 0) & (n = 0) then do
    getvar 'D'||m
    n = result
    i = 1
end
else i = n

do j = i to n
    getvar 'B'||m||j
    entry = result
    if entry ~= '' then do
        parse var entry type' ICON "'obj'"'
        if lastpos('/',obj) ~= 0 then objname = substr(obj,lastpos('/',obj)+1)
        else objname = substr(obj,lastpos(':',obj)+1)
        if m = 0 then type = 'button'
        gattrs = MUIA_Frame MUIV_Frame_None
        group ID 'G'||m||j
          if exists(objname'.add') then do
            call open('add',objname'.add','R')
            do while ~eof('add')
                line = readln('add')
                if line ~= '' then interpret line
            end
            call close('add')
          end
          select
            when type = 'pop' then do
                group ID m||j POP ICON '"'obj'"' ATTRS MUIA_Frame 0 MUIA_Group_Spacing 0 LABEL j||' '||obj
                call open('pop',objname'.pop','R')
                do while ~eof('pop')
                    line = readln('pop')
                    if line ~= '' then interpret line
                end
                call close('pop')
                endgroup
            end
            otherwise do
                type ID m||j ICON '"'obj'"' ATTRS gattrs LABEL j||' '||obj
            end
          end
        endgroup
    end
end
