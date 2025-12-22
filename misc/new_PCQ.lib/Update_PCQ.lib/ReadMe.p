Program The_hearing_and_the_sense_of_balance;

{ ***********************************************************************
  * 									*
  * This little piece of code is less to test the dos.library function	*
  * NameFromFH() with using PCQ-Pascal, but more for this information	*
  * text.								*
  * 									*
  * We found a bug in the pcq.lib ( NameFromFH always went meditating	*
  * in India, caused by a wrong implemented offset ) and in the include	*
  * file dos/dos.i ( Not enough the function guru'd, the parameter      *
  * 'buffer' was passed by wrong. ) , so in this packet you'll find the *
  * debugged versions :							*
  * 									*
  *   dos.i      15528 Bytes	to be placed in Include:dos/		*
  *   pcq.lib   104684 Bytes	to be placed so that BLink finds it	*
  * 									*
  * Notice that NameFromFH() no longer handles the parameter 'Buffer'	*
  * as global variable, but as local.					*
  * 									*
  * If anyone finds another bug, please email us.			*
  * 									*
  *     Andreas Tetzl			Bernd Künnen			*
  *	A.Tetzl@Saxonia.De		Diesel@Uni-Muenster.De		*
  * 									*
  ******* GreetinX to all fans of  'Fury in the Slaughterhouse' ! *******


{$I "Include:dos/dos.i" }  { * Use the new one ! * }

VAR
	my_string	: String;
	my_buffer	: Array[1..132] of Char;
	my_filehandle	: FileHandle;

Begin
	{ * Assign the buffer * }
	my_string := adr( my_buffer );

	{ * Open e.g. the startup-sequence, to have an filehandle * }
	my_filehandle := DosOpen("s:startup-sequence", mode_oldfile );
	if my_filehandle = NIL then Exit;  { * hello & goodbye * }

	{ * Test NameFromFH() * }
	WriteLn("Result(Boolean): ",
		NameFromFH( my_filehandle, my_string, 132 )
	       );

	{ * And the winner is ... * }
	WriteLn("Name of file is: ", my_string );

	{ * Hang the DJ kiss goodbye * }
	DosClose( my_filehandle );

end.

