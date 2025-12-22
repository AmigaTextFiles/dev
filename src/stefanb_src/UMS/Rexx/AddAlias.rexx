/* ------------------------------------------------------------------------
   :Program.    AddAlias.rexx
   :Contents.   adds aliases to UMS user
   :Author.     Kai Bolay [kai]
   :Address.    Snail Mail:
   :Address.    Hoffmannstraﬂe 168
   :Address.    D-71229 Leonberg        EMail: kai@studbox.uni-stuttgart.de
   :History.    v1.0 [kai] 13-Jan-96
   :Version.    $VER: AddAlias.rexx 1.0 (13.1.96)
   :Copyright.  Public Domain
   :Language.   ARexx
   :Translator. RexxMast
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
ArgsTemplate = "NAME/A,PWD,SERVER/K,USER/A,ALIASES/M"
args.SERVER = ""
args.PWD = ""

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

account = UMSLogin(args.name, args.pwd, args.server)
if account = 0 then do
  say "unable to login."
  exit 10
end

/*** Do the magic ***/

do i = 0 TO args.ALIASES.COUNT-1
  if ~UMSCreateAlias(account,args.USER,args.ALIASES.i) then do
    call CheckErr
    rc = 20; call logout
  end
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
  rc = 20
END

/*** Logout ***/

LOGOUT:

if account ~= 0 then do
  call UMSLogout(account)
  account = 0
end

exit rc

/*** Support ***/

CheckErr: procedure expose account
  err = UMSErrNum(account)
  if err ~= 0 then do
    say "UMS Error #" || err || ": " || UMSErrTxt(account)
  end
return
