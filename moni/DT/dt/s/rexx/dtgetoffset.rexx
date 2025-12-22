/*
 Demo program for DebuggerTool  $VER: GetDescription V1.0 25.08.1993
      Get DT-Offset and show the Autodoc-File
         with Multiview
*/
OPTIONS RESULTS

ADDRESS DT.1

IF ~Exists('AD:exec') Then Do
    DTTOFRONT
    MESSAGE 'You have to assign your Autodocs-Directory to AD:'
    Exit 10
End

GetOffsetName

Offset=result
IF (Offset='') THEN
 DO
  MESSAGE 'No last function found!';
  EXIT 0;
 END

Guideln=Pos('.',Offset)
Guideln=Guideln-1
GuideName=Left(Offset,Guideln)
GuideName=GuideName		/* ||'.guide' */
Guideln=Pos('/',Offset)
Guideln=Guideln
GuideFunc=Right(Offset,Length(Offset)-Guideln)
GuideName='ad:'||GuideName

  function = GuideFunc ||'()' /* ------   () optional with some amigaguide versions! */

IF SHOW('P','AUTODOCS') Then DO
   cmd="QUIT"
   ADDRESS AUTODOCS cmd
  END

do while SHOW('p','AUTODOCS')

end

  cmd = "run AmigaGuide "||GuideName||" document "||function||" portname AUTODOCS pubscreen DTSCREEN.1"
 ADDRESS COMMAND 'c:assign "DT-Debugger by TRZIL Bernhard :" envarc:'
 ADDRESS COMMAND 'c:assign "AmigaGuide/DT-Debugger by TRZI:" envarc:'

 ADDRESS COMMAND cmd

EXIT 0
