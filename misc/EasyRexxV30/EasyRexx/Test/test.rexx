/*
 *	File:					test.rexx
 *	Description:	Small AREXX file that uses all commands known to
 *								the test program
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

OPTIONS RESULTS

address EASYREXX_TEST

CLEAR
CLEAR FORCE

GETVAR HELLOWORLD
SAY result

HELP "index"
HELP AMIGAGUIDE "Pretty neat, huh?"

OPEN "ram:file"
OPEN PROJECT "ram:foo"
OPEN TEXT "ram:text"

SAVE
SAVE AS
SAVE AS "ram:foobar"

ROW 3

TEXT "EasyREXX demonstration"

RX "GETVAR HELLOWORLD"

/* The next 4 commands are internal commands */
/* All applications using easyrexx.library will inherit these */

GET AUTHOR			/* name of application's author */
SAY "Author:" RESULT

GET COPYRIGHT		/* application's copyright */
SAY "Copyright:" RESULT

GET VERSION			/* application's version */
SAY "Version:" RESULT

SAY ""
SAY "List of commands:"
GET COMMANDLIST	/* list of all commands known to this application */
SAY RESULT
SAY ""

/* How to get error messages: */
CAUSEERROR
if RC~=0 then do
	GET LASTERROR
	say RESULT
end

QUIT
