/*

Code:       lhaextract.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:   This script is used to extract lha archive contents.

*/
options results

parse arg portname' 'name' 'ddir

address command 'lha > nil: x 'name ddir

address VALUE portname

group ID DIR REGISTER
ndir = result

check ID ICN||(3-ndir)
dirlist ID DIR||(3-ndir) REREAD result
window ID LHA CLOSE
