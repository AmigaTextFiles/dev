/*

Code:       renfile.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   

*/

options results

/* TAG ID definitions */

Weight =                          0x80421d1f /* V4  i.. WORD              */
Dirlist_Directory =               0x8042ea41 /* V4  isg STRPTR            */
Dirlist_RejectIcons =             0x80424808 /* V4  is. BOOL              */
MUIA_Group_Spacing =                   0x8042866d /* V4  is. LONG              */
MUIA_Selected =                        0x8042654b /* V4  isg BOOL              */

parse arg portname' ['sfile']'

call pragma('Directory','muidir:')

address VALUE portname

group ID DIR REGISTER
ndir = result

if sfile ~= '' then do
    protect = ''
    switch ID PS ATTRS MUIA_Selected
    if result=1 then protect = protect||'S'
    switch ID PP ATTRS MUIA_Selected
    if result=1 then protect = protect||'P'
    switch ID PA ATTRS MUIA_Selected
    if result=1 then protect = protect||'A'
    switch ID PR ATTRS MUIA_Selected
    if result=1 then protect = protect||'R'
    switch ID PW ATTRS MUIA_Selected
    if result=1 then protect = protect||'W'
    switch ID PE ATTRS MUIA_Selected
    if result=1 then protect = protect||'E'
    switch ID PD ATTRS MUIA_Selected
    if result=1 then protect = protect||'D'
    address command 'protect "'sfile'" 'protect
end
window ID WPRO CLOSE

/* find next selected file */

dirlist ID DIR||ndir
sfile = result

/* if there is no selected file then reread dirlist and return */

if sfile = '' then do
    check ID ICN||ndir
    flag = result
    dirlist ID DIR||ndir REREAD ATTRS Dirlist_RejectIcons flag
    dirlist ID DIR||(3-ndir) REREAD ATTRS Dirlist_RejectIcons flag
    exit
end

/* get file information */

    state = statef(sfile)
    parse var state type size blocks protect s1 s2 s3 .

/* put up a requester to allow the user to change the protection
   bits of the file.  Also allows the user to cancel the operation.  Note
   that the string gadget command is set to this macro thereby setting
   up a recursive loop.  This is the only way to handle multiple files
   since all operations, in MUIRexx, are asyncronous. */

window ID WPRO
    group HORIZ
        label '"protect 'sfile' "'
    group HORIZ ATTRS MUIA_Group_Spacing 0
        if pos('S',protect) = 0 then flag = 0
        else flag = 1
        switch ID PS ATTRS MUIA_Selected flag LABEL 'S'
        if pos('P',protect) = 0 then flag = 0
        else flag = 1
        switch ID PP ATTRS MUIA_Selected flag LABEL 'P'
        if pos('A',protect) = 0 then flag = 0
        else flag = 1
        switch ID PA ATTRS MUIA_Selected flag LABEL 'A'
        if pos('R',protect) = 0 then flag = 0
        else flag = 1
        switch ID PR ATTRS MUIA_Selected flag LABEL 'R'
        if pos('W',protect) = 0 then flag = 0
        else flag = 1
        switch ID PW ATTRS MUIA_Selected flag LABEL 'W'
        if pos('E',protect) = 0 then flag = 0
        else flag = 1
        switch ID PE ATTRS MUIA_Selected flag LABEL 'E'
        if pos('D',protect) = 0 then flag = 0
        else flag = 1
        switch ID PD ATTRS MUIA_Selected flag LABEL 'D'
    endgroup
    endgroup
    group HORIZ
        button ATTRS Weight 0 COMMAND '"muidir:protfile 'portname' ['sfile']"' LABEL 'Ok'
        space HORIZ
        button ATTRS Weight 0 COMMAND '"window ID WPRO CLOSE"' PORT portname LABEL 'Cancel'
    endgroup
endwindow

exit
