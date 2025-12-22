/* */
options results
parse arg comm' 'name

MUIA_AppMessage =                 0x80421955 /* V5  ..g struct AppMessage * */
MUIA_Frame =                           0x8042ac64 /* V4  i.. LONG              */
Disabled =                        0x80423661 /* V4  isg BOOL              */
Image_FontMatch =                 0x8042815d /* V4  i.. BOOL              */

MUIV_EveryTime = 0x49893131
TRUE = 1
FALSE = 0

address BUILD

cycle ID L2
type = result

select
    when comm = 'SET' then do
        if name = '' then do
            popasl ID S7
            name = result
        end
        if index(name,'.info') > 0 then do
            name = substr(name,1,index(name,'.info')-1)
            type = 'Icon'
            switch ID C1 ATTRS Disabled TRUE
            cycle ID L2 LABEL 'Icon'
        end
        switch ID C1
        if result ~= 'Transparent' then TRANS = ''
        group ID GIMG
            select
                when type = 'Icon' then switch ID AIMG ICON name
                when type = 'Picture' then switch ID AIMG PICT name TRANS
                when type = 'None' then switch ID AIMG ATTRS MUIA_Frame 0
                otherwise nop
            end
        endgroup
        callhook ID AIMG APP COMMAND '"build:ask_comm SET %s"'
        popasl ID S7 CONTENT name
    end
    when comm = 'IMAGE' then do
        select
            when type = 'Icon' then do
                switch ID C1 ATTRS Disabled TRUE
                popasl ID S7 ATTRS Disabled FALSE
                poplist ID S8 ATTRS Disabled TRUE
            end
            when type = 'Image' then do
                switch ID C1 ATTRS Disabled TRUE
                popasl ID S7 ATTRS Disabled TRUE
                poplist ID S8 ATTRS Disabled FALSE
            end
            when type = 'Picture' then do
                switch ID C1 ATTRS Disabled FALSE
                popasl ID S7 ATTRS Disabled FALSE
                poplist ID S8 ATTRS Disabled TRUE
            end
            when type = 'None' then do
                switch ID C1 ATTRS Disabled TRUE
                popasl ID S7 ATTRS Disabled TRUE
                poplist ID S8 ATTRS Disabled TRUE
            end
            otherwise nop
        end
        popasl ID S7 CONTENT ''
        poplist ID S8 CONTENT ''
    end
    when comm = 'ISET' then do
        poplist ID S8
        sname = result
        sval = name
        name = ''
        call open('images','build:images.lst','R')
        do while ~eof('images')
            line = readln('images')
            if line = '' then leave
            parse var line vname '=' value .
            if sname = '' then do
                if value = sval then do
                    sname = vname
                    poplist ID S8 CONTENT sname
                    leave
                end
            end
            else do
                if index(vname,sname) > 0 then do
                    sval = value
                    leave
                end
            end
        end
        call close('images')
        group ID GIMG
            switch ID AIMG SPEC '"6:'sval'"' ATTRS Image_FontMatch TRUE MUIA_Frame 0
        endgroup
    end
    when comm = 'CLASS' then do
        check ID C1
        if result then dirlist ID D1 PATH '"SYS:Classes/Gadgets"'
        else dirlist ID D1 PATH '"MUI:Libs/MUI"'
        string ID S6 CONTENT ''
    end
    when comm = 'CSET' then do
        string ID S6 CONTENT substr(name,lastpos('/',name)+1)
    end
    otherwise nop
end
exit
