/* */
options results
parse arg m' 'n' 'obj

address dock

if obj = '' then do
    getvar B00
    if result ~= '' then parse var result 'ICON "'obj'"'
    else exit
end
cycle ID BTYPE
type = result
entry = type 'ICON "'||obj||'"'
if lastpos('/',obj) ~= 0 then objname = substr(obj,lastpos('/',obj)+1)
else objname = substr(obj,lastpos(':',obj)+1)
select
    when type = 'pop' then do
        call open('pop',objname'.pop','W')
        i = 0
        do forever
            list ID LLST POS i
            line = result
            if line = '' then break
            call writeln('pop',line)
            i = i + 1
        end
        call close('pop')
    end
    otherwise nop
end

popasl ID PCOMM
if result ~= '' then do
    entry = entry||' PCOMM "'||result||'"'
    string ID PPORT
    if result ~= '' then entry = entry||' PPORT "'||result||'"'
end

popasl ID ACOMM
if result ~= '' then do
    entry = entry||' ACOMM "'||result||'"'
    string ID APORT
    if result ~= '' then entry = entry||' APORT "'||result||'"'
end

popasl ID DCOMM
if result ~= '' then do
    entry = entry||' DCOMM "'||result||'"'
    string ID DPORT
    if result ~= '' then entry = entry||' DPORT "'||result||'"'
end

list ID ILST POS 0
if result ~= '' then do
    call open('add',objname'.add','W')
    i = 0
    do forever
            list ID ILST POS i
            line = result
            if line = '' then break
            call writeln('add',line)
            i = i + 1
    end
    call close('add')
end

setvar B||m||n entry
