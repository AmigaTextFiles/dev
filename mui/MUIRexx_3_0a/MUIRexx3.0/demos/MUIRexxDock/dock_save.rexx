/* */
options results
parse arg m' 'flag' 'value

address dock

getvar 'F'||m
flags = result

if flag ~= '' then do
    if flag = 'DOCK' then do
        if value then setvar 'X'||m 'DOCK'm+1
        else do
            setvar 'X'||m ''
            window ID 'DOCK'm+1 CLOSE
        end
    end
    else do
        if value then flags = flags flag
        else do
            i = index(flags,flag)
            n = length(flag)
            flags = substr(flags,1,i-1)||substr(flags,i+n)
        end
        setvar 'F'||m flags
    end
end

getvar 'D'||m
n = result
dockname = 'DOCK'm

call open('dock',dockname,'W')

getvar 'X'||m
call writeln('dock',result)

call writeln('dock',flags)

do i = 1 to n
    getvar B||m||i
    entry = result
    if entry ~= '' then call writeln('dock',entry)
end
call close('dock')

if flag ~= '' then do
    if flag = 'DOCK' then do
        if ~value then exit
        m = m + 1
    end
    call dock m
    call dock_mode m 0 0
end
