/* */
options results
parse arg obj

/* Attribute TAG ID definitions */

List_Active =                     0x8042391c /* V4  isg LONG              */

address BUILD

list ID DLST ATTRS List_Active
dpos = result
list ID DLST POS dpos
line = delword(result,1,1)
npos = wordindex(line,1)-1
if npos > 0 then line = insert(obj' ',line,npos)
else line = line||obj
call 'build:ask_object' '['line']'
exit
