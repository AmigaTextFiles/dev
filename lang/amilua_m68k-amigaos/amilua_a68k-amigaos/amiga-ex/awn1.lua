-- Creates a GUI with the AWNpipe

local function split(line)
    local ret1
    local ret2
    local ret3
    local pos1
    local pos2

    pos1 = string.find(line, " ", 1, true)
    if not pos1 then
        ret1 = line
    else
        ret1= string.sub(line, 1, pos1 - 1)
        pos2 = string.find(line, " ", pos1 + 1, true)
        if not pos2 then
            ret2 = string.sub(line, pos1 + 1)
        else
            ret2 = string.sub(line, pos1 + 1, pos2 - 1)
            ret3 = string.sub(line, pos2 + 1)
        end
    end
    return ret1, ret2, ret3
end

local function topipe(file, out)
    file:write(out .. "\n")
    file:flush()
    local line = file:read("*line")
    if string.sub(line, 1, 2) == "ok" then
        return string.sub(line, 4)
    else
        error("AWNpipe didn't reply with 'ok'")
    end
end

awnfile = assert(io.open("awnpipe:awnex/xc" , "r+"))
topipe(awnfile, ' "AWNpipe Example" activate v defg defer si so')
topipe(awnfile, ' label gt "Lua" ua')
strgad = topipe(awnfile, ' string chl')
topipe(awnfile, ' layout si so')
button1 = topipe(awnfile, ' button gt "Hello"')
button2 = topipe(awnfile, ' button gt "World"')
topipe(awnfile, ' le')
topipe(awnfile, ' open')
while 1 do
    line = awnfile:read("*line")
    object, gid, value = split(line)
    if object == "close" then
        break
    elseif gid == strgad then
        print("Stringgadget value: " .. value)
    elseif gid == button1 then
        print("Button 1")
    elseif gid == button2 then
        print("Button 2")
    end
end

awnfile:close()
print("Good bye")

