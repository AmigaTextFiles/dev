/* ------------------------------------------------------------------------
   :Program.    AddAKAs.rexx
   :Contents.   adds AKAs
   :Author.     Kai Bolay [kai]
   :Address.    Snail Mail:
   :Address.    Hoffmannstraﬂe 168
   :Address.    D-71229 Leonberg        EMail: kai@studbox.uni-stuttgart.de
   :History.    v1.0 [kai] 13-Jan-96
   :Version.    $VER: RemoveAKA.rexx 1.0 (13.1.96)
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
ArgsTemplate = "NAME/A,PASSWORD,SERVER/K,AKAS/A/M"
args.SERVER = ""
args.PASSWORD = ""

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

aka = UMSReadConfig(account,"AKA",,TRUE,TRUE,TRUE)
do i = 0 TO args.AKAS.COUNT-1
  aka = '"' || args.AKAS.i || '\n"' || '0A'x || aka
end

if ~UMSWriteConfig(account,"AKA",aka,,TRUE,,TRUE,TRUE) then do
  call CheckErr;
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
  rc = 20
END

/*** Logout ***/

LOGOUT:

if account ~= 0 then do
  call UMSLogout(account)
  account = 0
end

exit rc
