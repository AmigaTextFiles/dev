/* */
options results
parse arg comm' 'aname

/* Attribute TAG ID definitions */

MUIA_Background = 0x8042545b
MUIA_Draggable = 0x80420b6e
MUIA_Frame = 0x8042ac64
MUIA_Group_Spacing = 0x8042866d
Listview_DragType = 0x80425cd3
List_Active = 0x8042391c
List_Quiet = 0x8042d8c7
Weight = 0x80421d1f

/* TAG variable definitions */

TRUE = 1
FALSE = 0
MUIV_Frame_None = 0
MUII_BACKGROUND = 128
Listview_DragType_Immediate = 1
List_Insert_Bottom = -3

address BUILD

select
    when comm = 'ADD' then do
        parse var aname name','value .
        list ID ALST INSERT STRING name',='
        list ID VLST INSERT POS List_Insert_Bottom NODUP STRING strip(name) '=' strip(value)
    end
    when comm = 'VADD' then do
        parse var aname name','value .
        list ID VLST INSERT POS List_Insert_Bottom NODUP STRING strip(name) '=' strip(value)
    end
    when comm = 'MADD' then do
        parse var aname name','value .
        list ID ALST INSERT STRING name
        list ID VLST INSERT POS List_Insert_Bottom NODUP STRING strip(name) '=' strip(value)
    end
    when comm = 'LIST' then do
        window ID WATTR TITLE '"Attribute List"' COMMAND '"window ID WATTR CLOSE"' PORT BUILD
            list ID BLST ATTRS Listview_DragType Listview_DragType_Immediate
        endwindow

        call open('attrs','build:attrs.lst','R')
        list ID BLST ATTRS List_Quiet TRUE
        do while ~eof('attrs')
            line = readln('attrs')
            if line = '' then leave
            parse var line name '=' value .
            list ID BLST INSERT POS List_Insert_Bottom STRING name','value
        end
        list ID BLST ATTRS List_Quiet FALSE
        call close('attrs')
    end
    when comm = 'VLIST' then do
        window ID WVAR TITLE '"Variable List"' COMMAND '"window ID WVAR CLOSE"' PORT BUILD
            list ID CLST ATTRS Listview_DragType Listview_DragType_Immediate
        endwindow

        call open('vars','build:vars.lst','R')
        list ID CLST ATTRS List_Quiet TRUE
        do while ~eof('vars')
            line = readln('vars')
            if line = '' then leave
            parse var line name '=' value .
            list ID CLST INSERT POS List_Insert_Bottom STRING name','value
        end
        list ID CLST ATTRS List_Quiet FALSE
        call close('vars')
    end
    when comm = 'MLIST' then do
        window ID WMETH TITLE '"Method List"' COMMAND '"window ID WMETH CLOSE"' PORT BUILD
            list ID MLST ATTRS Listview_DragType Listview_DragType_Immediate
        endwindow

        call open('meths','build:meths.lst','R')
        list ID MLST ATTRS List_Quiet TRUE
        do while ~eof('meths')
            line = readln('meths')
            if line = '' then leave
            parse var line name '=' value .
            list ID MLST INSERT POS List_Insert_Bottom STRING name','value
        end
        list ID MLST ATTRS List_Quiet FALSE
        call close('meths')
    end
    when comm = 'ASKSET' then do
        call open('vars','build:vars.lst','R')
        entries = ''
        do while ~eof('vars')
            line = readln('vars')
            if line = '' then leave
            parse var line vname .
            n = index(upper(substr(vname,6)),upper(substr(aname,6,4)))
            if n > 0 then entries = entries','vname
        end
        call close('vars')
        parse var aname name','value
        window ID ASET COMMAND '"build:attrs SET 'strip(name)'"'
            group HORIZ
                text ATTRS Weight 0 MUIA_Frame MUIV_Frame_None MUIA_Background 0 LABEL strip(name)' = '
                poplist ID ASTR SPEC '6:18' LABELS entries CONTENT value
            endgroup
        endwindow
    end
    when comm = 'SET' then do
        poplist ID ASTR
        val = result
        window ID ASET CLOSE
        list ID ALST ATTRS List_Active
        n = result
        list ID ALST POS n STRING aname',='val
        call open('vars','build:vars.lst','R')
        do while ~eof('vars')
            line = readln('vars')
            if line = '' then leave
            parse var line vname '=' value .
            if compare(vname,val) = 0 then do
                list ID VLST INSERT POS List_Insert_Bottom NODUP STRING strip(vname) '=' strip(value)
                leave
            end
        end
        call close('vars')
    end
    otherwise nop
end
exit
