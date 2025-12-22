/* ------------------------------------------------------------------------
   :Program.    GetUMSConfig.rexx
   :Contents.   reads a variable from UMS' config
   :Author.     Kai Bolay [kai]
   :Address.    Hoffmannstraﬂe 168
   :Address.    D-71229 Leonberg
   :EMail.      kai@studbox.uni-stuttgart.de
   :Version.    $VER: GetUMSConfig.rexx 1.0 (25.9.95)
   :Copyright.  Public Domain
   :Language.   ARexx
   :Translator. RexxMast
   
$Id: GetUMSConfig.rexx 1.0 1995/11/11 12:11:51 kai Exp $
$Log: GetUMSConfig.rexx $
# Revision 1.0  1995/11/11  12:11:51  kai
# Initial revision
#

------------------------------------------------------------------------ */

options results

signal on BREAK_C
signal on BREAK_D
signal on BREAK_E
signal on BREAK_F
signal on ERROR
signal on HALT
signal on IOERR
signal on SYNTAX

/*** Init ***/

call addlib("rexxdossupport.library", 0, -30)
call addlib("ums.library", 0, -210, 11)
call UMSInitConsts()

/*** Arguments ***/

parse SOURCE . " " . " " ProgramName .
ArgsTemplate = "NAME/A,PASSWORD,SERVER/K,VARIABLE/A,USER,GLOBALONLY/S,QUOTED/S"
args.SERVER = ""
args.PASSWORD = ""
args.USER = ""

parse arg arguments
if strip(arguments) = '?' then do
  call writech(STDOUT, ArgsTemplate || ': ')
  arguments = readln(STDIN)
end; else nop
if ~ReadArgs(arguments,ArgsTemplate,"args.") then do
  say Fault(RC, ProgramName)
  exit 10
end; else nop

/*** Login ***/

account = UMSLogin(args.name, args.password, args.server)
if account = 0 then do
  say "unable to login."
  exit 20
end

/*** Do the magic ***/

res = UMSReadConfig(account,args.variable,args.user,args.globalonly,args.quoted)

if res = "" then do
  err = UMSErrNum(account)
  if err ~= 0 then do
    say "UMS Error #" || err || ": " || UMSErrTxt(account)
    rc = 10
    call logout
  end
end

say res

/*** Final cleanup ***/

BREAK_C:
BREAK_D:
BREAK_E:
BREAK_F:

RC = 0

ERROR:
HALT:
IOERR:
SYNTAX:

IF RC ~= 0 THEN DO
  SAY "Error: " rc errortext(rc) "Line" sigl
  rc = 10
END

/*** Logout ***/

LOGOUT:

if account ~= 0 then do
  call UMSLogout(account)
  account = 0
end

exit rc
