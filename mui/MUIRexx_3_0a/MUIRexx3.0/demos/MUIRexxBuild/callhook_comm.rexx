/* */
options results
parse arg comm' 'aname

/* TAG variable definitions */

List_Insert_Bottom = -3

address BUILD

select
    when comm = 'ADD' then do
        parse var aname name','value .
        string ID S4 CONTENT name
        list ID VLST INSERT POS List_Insert_Bottom NODUP STRING strip(name) '=' strip(value)
    end
    when comm = 'VADD' then do
        parse var aname name','value .
        string ID S5 CONTENT name
        list ID VLST INSERT POS List_Insert_Bottom NODUP STRING strip(name) '=' strip(value)
    end
    when comm = 'IADD' then do
        string ID S6
        if result ~= '' then name = result','aname
        else name = aname
        string ID S6 CONTENT name
    end
    when comm = 'XADD' then do
        string ID S7
        if result ~= '' then name = result','aname
        else name = aname
        string ID S7 CONTENT name
    end
    otherwise nop
end
