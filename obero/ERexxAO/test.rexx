/*
 *	File:			test.rexx
 *	Description:	Small AREXX file that uses all commands known to
 *					the test program
 *
 *	(C) 1994, Ketil Hunn
 *
 */

ADDRESS EASYREXX_TEST

clear

open project "ram:foo digg"
open text "ram:foo"
open "ram:foo"			/* defaults to OPEN PROJECT */
saveas NAME "ram:foo"

help amigaguide "arexx"
help "arexx"

smiley=":-)"
text "Hello World!" smiley
row 54

/* pause in case we started the script from WB */

do i=1 to 4000
 nop
end

quit
