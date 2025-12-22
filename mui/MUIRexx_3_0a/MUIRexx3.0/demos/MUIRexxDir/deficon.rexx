/*

Code:       deficon.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   This script tries to determine the file type of the named file.
It returns the icon name for the file (or a default icon name) and a
command and help string associated with the file type.  It makes use of the
datatype.library function 'examinedt()'.

Note that this script should be edited to taste (mine is undoubtedly
different from yours).

*/

parse arg name .

call examinedt(name,dt.,STEM)

type = upper(dt.DataType)

if lastpos('/',name) ~= 0 then file = substr(name,lastpos('/',name)+1)
else file = substr(name,lastpos(':',name)+1)

/* check for known datatypes. Note that some of the "command" strings only
specify a port.  This will result in the command being set to the icons
default tool. */

select
    when pos('ASCII',type) = 1 then return iconname(name,'env:sys/def_ascii')||' HELP "Edit 'file'"'
    when pos('JFIF',type) = 1 then return iconname(name,'env:sys/def_picture')||' HELP "View 'file'"'
    when pos('GIF',type) = 1 then return iconname(name,'env:sys/def_picture')||' HELP "View 'file'"'
    when pos('ILBM',type) = 1 then return iconname(name,'env:sys/def_ILBM')||' HELP "View 'file'"'
    when pos('ANIM',type) = 1 then return iconname(name,'env:sys/def_anim')||' HELP "Play 'file'"'
    when pos('C-SOURCE',type) = 1 then return iconname(name,'env:sys/def_c')||' HELP "Edit 'file'"'
    when pos('AMIGAGUIDE',type) = 1 then return iconname(name,'env:sys/def_AmigaGuide')||' HELP "View 'file'"'
    when pos('POSTSCRIPT',type) = 1 then return iconname(name,'env:sys/def_postscript')||' HELP "View 'file'"'
    when pos('LHA',type) = 1 then return iconname(name,'env:sys/def_archive')||' HELP "View/Extract 'file'"'
    when pos('8SVX',type) = 1 then return iconname(name,'env:sys/def_8SVX')||' HELP "Play 'file'"'
    when pos('BINARY',type) = 1 then return findicon(name)
    otherwise return iconname(name,'env:sys/def_project')||' HELP "'file'"'
end
exit

/* this procedure is called when a generic binary type is encountered.
Additional file types could (and should) be added here if no appropriate 
datatype exists. */

findicon:
    arg name
    select
        when index(name,'.DVI') ~= 0 then return iconname(name,'env:sys/def_project')||' HELP "Preview 'file'"'
        when index(name,'.MOD') ~= 0 then return iconname(name,'env:sys/def_mod')||' HELP "Play 'file'"'
        when index(name,'MOD.') ~= 0 then return iconname(name,'env:sys/def_mod')||' HELP "Play 'file'"'
        otherwise return iconname(name,'env:sys/def_project')||' HELP "'file'"'
    end
return

/* this procedure extracts the icon name.  Note that the icon name is the
.info file name without the .info extension.  If the passed argument
contains the .info extension it is removed.  Otherwise the existence of an
associated .info file is checked and the original file name is returned if
found, else the second argument is returned (presumably containing the name
of a default icon).  */

iconname:
    if index(upper(arg(1)),'.INFO') > 1 then return substr(arg(1),1,pos('.INFO',upper(arg(1)))-1)
    if exists(arg(1)'.info') then return '"'arg(1)'"'
    else return arg(2)
return
