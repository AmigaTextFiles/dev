/* ------------------------------------------------------------------------
   :Program.    MakeUser.rexx
   :Contents.   create a new UMS user
   :Author.     Kai Bolay [kai]
   :Address.    Snail Mail:
   :Address.    Hoffmannstraﬂe 168
   :Address.    D-71229 Leonberg        EMail: kai@studbox.uni-stuttgart.de
   :History.    v1.0 [kai] 14-Oct-95
   :History.    v1.1 [kai]  3-Nov-95 added PASSWORD
   :Version.    $VER: MakeUser.rexx 1.1 (3.11.95)
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
ArgsTemplate = "NAME/A,PWD,SERVER/K,USER/A,ALIASES/M,SYSOP/S,EXPORTER/S,READACCESS/K,WRITEACCESS/K,NETACCESS/K,IMPORT/K,EXPORT/K,PASSWORD/K,OPTIONS/K,ACTIONCOMMAND/K"
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

if args.SYSOP & args.EXPORTER then do
  say "SYSOP and EXPORTER are mutally exclusive!"
  rc = 20; call logout
end

kind = "USER"
if args.SYSOP    then kind = "SYSOP"
if args.EXPORTER then kind = "EXPORTER"

if ~UMSCreateUser(account,args.USER, kind) then do
  call CheckErr
  rc = 20; call logout
end

do i = 0 TO args.ALIASES.COUNT-1
  if ~UMSCreateAlias(account,args.USER,args.ALIASES.i) then do
    call CheckErr
    rc = 20; call logout
  end
end

vars.0 = OPTIONS
vars.1 = READACCESS
vars.2 = WRITEACCESS
vars.3 = NETACCESS
vars.4 = IMPORT
vars.5 = EXPORT
vars.6 = ACTIONCOMMAND
vars.7 = PASSWORD
vars.count = 7

do i = 0 to vars.count-1
  if symbol("args."vars.i) = "VAR" then do
    if ~UMSWriteConfig(account,vars.i,value("args."vars.i),args.user) then do
      call CheckErr
      rc = 20; call logout
    end
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
