/* */
options results
parse arg m' 'n' 'mode

address dock

MUIA_Draggable = 0x80420b6e

FALSE = 0
TRUE = 1

if (m ~= 0) & (n = 0) then do
    getvar 'D'||m
    n = result
    i = 1
end
else i = n

if mode then do
    do j = i to n
        getvar 'B'||m||j
        entry = result
        if entry ~= '' then do
            parse var entry type' ICON "'obj'"'
            bcomm = ''
            select
                when type = 'pop' then do
                    parse var entry 'PCOMM "'bcomm'"'
                    object = 'group POP'
                end
                otherwise do
                    parse var entry 'PCOMM "'bcomm'"'
                    object = type
                end
            end
            object ID m||j ATTRS MUIA_Draggable FALSE
            if bcomm ~= '' then do
                bcomm = '"'bcomm'"'
                parse var entry 'PPORT "'bport'"'
                if bport ~= '' then bcomm = bcomm' PORT "'bport'"'
                callhook ID m||j PRESS COMMAND bcomm
            end
            parse var entry 'ACOMM "'bcomm'"'
            if bcomm ~= '' then do
                bcomm = '"'bcomm'"'
                parse var entry 'APORT "'bport'"'
                if bport ~= '' then bcomm = bcomm' PORT "'bport'"'
                callhook ID m||j APP COMMAND bcomm
            end
            parse var entry 'DCOMM "'bcomm'"'
            if bcomm ~= '' then do
                bcomm = '"'bcomm'"'
                parse var entry 'DPORT "'bport'"'
                if bport ~= '' then bcomm = bcomm' PORT "'bport'"'
                callhook ID m||j DROP COMMAND bcomm
            end
        end
    end
end
else do
    do j = i to n
        getvar 'B'||m||j
        parse var result type' ICON "'obj'"'
        if m = 0 then type = 'button'
        select
            when type = 'pop' then object = 'group POP'
            otherwise object = type
        end
        object ID m||j ATTRS MUIA_Draggable TRUE
        callhook ID m||j DROP COMMAND """dock_change "m" "j" "obj" %s"""
        callhook ID m||j PRESS
        callhook ID m||j APP
    end
end
