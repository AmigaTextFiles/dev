/* */
options results
parse arg comm

/* Attribute TAG ID definitions */

List_Active =                     0x8042391c /* V4  isg LONG              */
ASLFR_DrawersOnly =               0x8008002f
ASLFR_InitialDrawer =             0x80080009

TRUE = 1
List_Insert_Bottom = -3

address BUILD

select
    when comm = 'LEFT' then do
        list ID DLST ATTRS List_Active
        dpos = result
        list ID DLST POS dpos
        gobj = result
        parse var gobj obj .
        nspc = pos(obj,gobj)-1
        if nspc > 0 then do
            list ID DLST POS dpos STRING '='||insert(strip(gobj),'',nspc-1)
        end
    end
    when comm = 'RIGHT' then do
        list ID DLST ATTRS List_Active
        dpos = result
        list ID DLST POS dpos
        gobj = result
        parse var gobj obj .
        nspc = pos(obj,gobj)-1
        if nspc >= 0 then do
            list ID DLST POS dpos STRING '='||insert(strip(gobj),'',nspc+1)
        end
    end
    when comm = 'COPY' then do
        list ID DLST ATTRS List_Active
        dpos = result
        i = 0
        do forever
            list ID DLST
            if result = '' then break
            i = i + 1
            line.i = result
        end
        do n = 1 to i
            list ID DLST INSERT POS dpos+n STRING line.n
        end
    end
    when comm = 'CREATE' then do
        string ID APRT
        aport = upper(result)
        if aport = '' then exit
        if show('ports',aport) then do
            address value aport
            quit
            address
            do while show('ports',aport)
            end
        end
        call writemacro 't:tmp'
        address command 'run >nil: MUIRexx:MUIRexx PORT 'aport' t:tmp'
        address command 'delete t:tmp.rexx QUIET'
    end
    when comm = 'CLOSE' then do
        string ID APRT
        aport =  upper(result)
        if show('ports',aport) then do
            address value aport
            quit
            address
        end
    end
    when comm = 'NEW' then do
        list ID DLST STRING
        list ID VLST STRING
        string ID APRT CONTENT 'TEST'
        setvar objlist
    end
    when comm = 'SAVE' then do
        getvar directory
        aslrequest ID BWIN TITLE '"Select Directory"' ATTRS ASLFR_DrawersOnly TRUE ASLFR_InitialDrawer result
        if rc = 0 then do
            dir = result
            if (~exists(dir)) then exit
            setvar directory dir
            if lastpos('/',dir) ~= length(dir) then do
                if lastpos(':',dir) ~= length(dir) then dir = dir'/'
            end
            string ID APRT
            aport = result
            name = dir||aport
            call writemacro name
            address command 'copy build:build.info 'name'.info QUIET'
        end
    end
    when comm = 'SAVEAS' then do
        getvar directory
        aslrequest ID BWIN TITLE '"Select File"' ATTRS ASLFR_InitialDrawer result
        if rc = 0 then do
            file = result
            if lastpos('/',file) ~= 0 then dir = substr(file,1,lastpos('/',file)-1)
            else dir = substr(file,1,lastpos(':',file))
            setvar directory dir
            call writemacro file
        end
    end
    when comm = 'READ' then do
        getvar directory
        aslrequest ID BWIN TITLE '"Select File"' ATTRS ASLFR_InitialDrawer result
        if rc = 0 then do
            name = result
            if (~exists(name)) then exit
            if lastpos('/',name) ~= 0 then dir = substr(name,1,lastpos('/',name)-1)
            else dir = substr(name,1,lastpos(':',name))
            setvar objlist
            setvar directory dir
            list ID DLST STRING
            list ID VLST STRING
            call open('file',name,'R')

            aport = ''
            do while ~eof('file')
                line = readln('file')
                if strip(line) = '' then iterate
                if index(strip(line),'/*') = 1 then iterate
                if index(line,'=') > 0 then do
                    parse var line vname op value .
                    if strip(op) = '=' then do
                        list ID VLST INSERT POS List_Insert_Bottom STRING strip(vname)' = 'strip(value)
                        iterate
                    end
                end
                if aport = '' then do
                    if index(line,'address') = 1 then do
                        parse var line 'address 'pname comm
                        if comm = '' then do
                            aport = pname
                            string ID APRT CONTENT aport
                            iterate
                        end
                    end
                end
                parse var line obj args
                if index(strip(args),'ID') = 1 then do
                    parse var args 'ID 'gid args
                    call addobj(gid)
                end
                list ID DLST INSERT POS List_Insert_Bottom STRING '='||line
            end
            call close('file')
        end
    end
    otherwise nop
end

exit

writemacro: procedure
parse arg name

string ID APRT
aport = result
if index(name,'.rexx') = 0 then name = name'.rexx'
call open('file',name,'W')
call writeln('file','/* Application created by MUIBuild */')
call writeln('file','')
call writeln('file','address 'aport)
call writeln('file','')
i = 0
do forever
    list ID VLST POS i
    line = result
    if line = '' then break
    call writeln('file',line)
    i = i + 1
end
call writeln('file','')
i = 0
do forever
    list ID DLST POS i
    line = result
    if line = '' then break
    call writeln('file',line)
    i = i + 1
end
call close('file')
return

addobj: procedure
parse arg obj

getvar objlist
objects = result
if index(objects,obj) = 0 then objects = objects||obj||','
setvar objlist objects
return
