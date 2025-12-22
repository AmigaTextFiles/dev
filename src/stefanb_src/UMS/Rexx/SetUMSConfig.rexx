/* ------------------------------------------------------------------------
   :Program.    SetUMSConfig.rexx
   :Contents.   writes a variable UMS' config
   :Author.     Kai Bolay [kai]
   :Address.    Hoffmannstraﬂe 168
   :Address.    D-71229 Leonberg        
   :EMail.      kai@studbox.uni-stuttgart.de
   :Version.    $VER: SetUMSConfig.rexx 1.0 (14.9.95)
   :Copyright.  Public Domain
   :Language.   ARexx
   :Translator. RexxMast
   
$Id: SetUMSConfig.rexx 1.0 1995/11/11 12:10:05 kai Exp $
$Log: SetUMSConfig.rexx $
# Revision 1.0  1995/11/11  12:10:05  kai
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
ArgsTemplate = "NAME/A,PASSWORD,SERVER/K,VARIABLE/A,DATA,USER,GLOBAL/S,LOCAL/S,QUOTED/S"
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
  exit 10
end

/*** Do the magic ***/

if ~(symbol("args."data) = "VAR") then do
  res = UMSWriteConfig(account,args.variable,,args.user,args.global,args.local,args.quoted)
end; else do
  res = UMSWriteConfig(account,args.variable,args.data,args.user,args.global,args.local,args.quoted)
end

if ~res then do
  call CheckErr
  RC = 20; call LOGOUT
end

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
  RC = 20
END

/*** Logout ***/

LOGOUT:

if account ~= 0 then do
  call UMSLogout(account)
  account = 0
end

exit RC

/*** Support ***/

CheckErr: procedure expose account
  err = UMSErrNum(account)
  if err ~= 0 then do
    say "UMS Error #" || err || ": " || UMSErrTxt(account)
  end
return
