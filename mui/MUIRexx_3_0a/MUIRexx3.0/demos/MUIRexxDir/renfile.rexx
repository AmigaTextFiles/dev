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

parse arg portname' ['sfile']' '['dfile']'

call pragma('Directory','muidir:')

address VALUE portname

group ID DIR REGISTER
ndir = result

if dfile ~= '' then do
    window ID WREN CLOSE
    if substr(sfile,1,pos(':',sfile)) = substr(dfile,1,pos(':',dfile)) then
        ctype = 1
    else ctype = 2

/* if the file exists at the destination then put up a requester to allow
the user to decide on the action */

    if exists(dfile) & (type > 0) then do
        request ID MDIR TITLE '" "' GADGETS '"_OK|_CANCEL"' '\033bFile already exists!\033n Do you wish to overwrite?'
        select
            when result = 0 then exit
            when result = 1 then nop
            otherwise nop
        end
    end

    call file portname ndir ctype sfile';'dfile
end

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

/* determine a destination file name.  Of course the user will be 
   free to change this in the requester created below. */

dirlist ID DIR||(3-ndir) ATTRS Dirlist_Directory
ddir = import(d2c(result))
if lastpos('/',ddir) ~= length(ddir) then do
    if lastpos(':',ddir) ~= length(ddir) then ddir = ddir'/'
end
if lastpos('/',sfile) ~= 0 then dfile = ddir||substr(sfile,lastpos('/',sfile)+1)
else dfile = ddir||substr(sfile,lastpos(':',sfile)+1)

/* put up a requester to allow the user to change the destination
   file name.  Also allows the user to cancel the operation.  Note
   that the string gadget command is set to this macro thereby setting
   up a recursive loop.  This is the only way to handle multiple files
   since all operations, in MUIRexx, are asyncronous. */

window ID WREN
    group HORIZ
        label '"rename 'sfile' to "'
        string COMMAND '"muidir:renfile 'portname' ['sfile'] [%s]"' CONTENT dfile
    endgroup
    group HORIZ
        space HORIZ
        button ATTRS Weight 0 COMMAND '"window ID WREN CLOSE"' PORT portname LABEL 'Cancel'
    endgroup
endwindow

exit
