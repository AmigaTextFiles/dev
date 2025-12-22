/*
 *	File:					ToggleSwitches.rexx
 *	Description:	Toggles all switches of the current selected argument
 *								
 *	(C) 1995, Ketil Hunn
 *
 */

OPTIONS RESULTS

GETATTR ALWAYS
always=~RESULT

GETATTR KEYWORD
keyword=~RESULT

GETATTR NUMBER
number=~RESULT

GETATTR SWITCH
switch=~RESULT

GETATTR TOGGLE
toggle=~RESULT

GETATTR MULTIPLE
multiple=~RESULT

GETATTR FINAL
final=~RESULT

SETATTR "ALWAYS="|| always "KEYWORD="|| keyword "NUMBER="|| number "SWITCH="|| switch "TOGGLE="|| toggle "multiple="|| multiple "FINAL="|| final
