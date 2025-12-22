/*
 Demo program for DebuggerTool  $VER: GetDescription V1.0 20.08.1993
		Get the function description with CED
*/

OPTIONS RESULTS

ADDRESS DT.1

IF ~Exists('AD:exec.guide') Then Do
    DTTOFRONT
    MESSAGE 'You have to assign your Autodocs-Directory to AD:'
    Exit 10
End

GetOffSetName

String = result
String2 = String;
IF LastPos('.',String)~=0 THEN String2=left(String,LastPos('.',String)-1)

ADDRESS "rexx_ced";

OPEN "AD:"||String2||".guide";
search for '""'||String||'()""';
EXIT 0
