/* */
options results
parse arg obj

/* Attribute TAG ID definitions */

List_DropMark =                   0x8042aba6 /* V11 ..g LONG              */

address BUILD

list ID DLST ATTRS List_DropMark
dpos = result
if dpos > 0 then do
    list ID DLST POS dpos-1
    temp = result
    prev = strip(temp)
    nspc = index(temp,prev)-1
    select
        when index(prev,'end') > 0 then nop
        when index(prev,'window') > 0 then nspc = nspc + 1
        when index(prev,'group') > 0 then nspc = nspc + 1
        when index(prev,'menu') > 0 then nspc = nspc + 1
        when index(prev,'do') > 0 then nspc = nspc + 1
        otherwise nop
    end
    if nspc < 0 then nspc = 0
end
else nspc = 0

list ID DLST INSERT POS dpos STRING '='||insert(obj,'',nspc)
select
    when obj = 'window' then
        list ID DLST INSERT POS dpos+1 STRING '='||insert('end'obj,'',nspc)
    when obj = 'group' then
        list ID DLST INSERT POS dpos+1 STRING '='||insert('end'obj,'',nspc)
    when obj = 'menu' then
        list ID DLST INSERT POS dpos+1 STRING '='||insert('end'obj,'',nspc)
    when obj = 'do' then
        list ID DLST INSERT POS dpos+1 STRING '='||insert('end','',nspc)
    otherwise nop
end

exit
