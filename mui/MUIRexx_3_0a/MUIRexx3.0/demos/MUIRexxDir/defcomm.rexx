/*

Code:       defcomm.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   This script tries to determine the file type of the named file.
It executes a default command based on the file type.  It makes use of the
datatype.library function 'examinedt()'.

Note that this script should be edited to taste (mine is undoubtedly
different from yours).

*/
options results

parse arg portname' 'file

call examinedt(file,dt.,STEM)

type = upper(dt.DataType)

address value portname
getvar screen
pub = result

select
    when pos('ASCII',type) = 1 then address command 'ced -pubscreen='pub' "'file'"'
    when pos('JFIF',type) = 1 then address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
    when pos('GIF',type) = 1 then address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
    when pos('ILBM',type) = 1 then address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
    when pos('ANIM',type) = 1 then address command 'xanim "'file'"'
    when pos('C-SOURCE',type) = 1 then address command 'ced -pubscreen='pub' "'file'"'
    when pos('AMIGAGUIDE',type) = 1 then address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
    when pos('POSTSCRIPT',type) = 1 then address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
    when pos('LHA',type) = 1 then call 'muidir:lhalist' portname file
    when pos('8SVX',type) = 1 then address command 'tools:music/Play16/Play16 "'file'"'
    when pos('BINARY',type) = 1 then call findtool(file)
    otherwise address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
end
exit

findtool:
    parse arg file
    upfile = upper(file)
    select
        when index(upfile,'.DVI') ~= 0 then address command 'preview "'file'"'
        when index(upfile,'.MOD') ~= 0 then call 'playmod "'file'"'
        when index(upfile,'MOD.') ~= 0 then call 'playmod "'file'"'
        otherwise address command 'sys:utilities/multiview PUBSCREEN 'pub' "'file'"'
    end
return
