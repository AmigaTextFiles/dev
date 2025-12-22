/*

Code:       lhalist.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   This script is used to display an lha archive list.  A
requester id created and allows extraction of archive contents if a
destination directory is selected.

*/

options results

/* TAG ID definitions */

Dirlist_Directory =               0x8042ea41 /* V4  isg STRPTR            */
Weight = '0x80421d1f'

parse arg portname' 'name

/* get archive listing */
address command 'run >nil: lha > pipe:lha v "'name'"'

address VALUE portname
group ID DIR REGISTER
ndir = result

/* get destination directory */
dirlist ID DIR||(3-ndir) ATTRS Dirlist_Directory
ddir = import(d2c(result))

/* create window to display archive contents */
window ID LHA TITLE '"Archive List"' COMMAND '"window ID LHA CLOSE"' PORT portname
/* create view containing archive contents */
    view FILE '"pipe:lha"'
/* if destination directory exists then create a button */
    if ddir ~= '' then do
        group HORIZ
            if lastpos('/',ddir) ~= length(ddir) then do
                if lastpos(':',ddir) ~= length(ddir) then ddir = ddir'/'
            end
            space HORIZ
            button ATTRS Weight 0 COMMAND '"muidir:lhaextract 'portname' 'name' 'ddir'"' LABEL 'Extract to 'ddir
            space HORIZ
        endgroup
    end
endwindow
/*
address command 'delete >nil: T:lha.out QUIET'
*/
return
