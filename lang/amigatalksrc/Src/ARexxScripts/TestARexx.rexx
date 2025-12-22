/*************************************************************
** TestARexx.rexx Test the ARexxManager & ARexxFuncs for
**                AmigaTalk!
**************************************************************/

/* ------------------------------------------------------------
** Command syntax for all the commands that the AmigaTalk
** ARexxManager recognizes:
**
** TurnOnConsole ConsoleName Height
**
** TurnOffConsole DETACH | DEACTIVATE  Both flags currently do the same thing.
**
** FeedText2Interp SmallTalk_TextString
**
** Interpret SmallTalk_TextFile
**    Issues a ")r file_name \n" command to the SmallTalk interpreter.
**
** SaveEnv  Env_FileName
**
** Quit
**
** GetError ErrorNumber_String
**
**
** ReportStatus %s (Private to AmigaTalk).     NOT implemented!
** --------------------------------------------------------------- */

Options FailAt 5

if ~show( 'l', "rexxsupport.library" ) then do
   check = addlib( 'rexxsupport.library', 0, -30, 0 )
end

ADDRESS "AmigaTalk_Rexx"

Do
   'Interpret CPGM:SmallTalk/TestFiles/PushScript'

RETURN 
