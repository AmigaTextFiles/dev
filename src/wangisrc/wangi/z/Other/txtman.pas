Program TxtMan;
(*
 * txtman.pas
 *
 * Lee Kindness
 * May 1995
 *
 *)

{ Turn off I/O checking (will handle within the program) }
{$I-}

Uses
	DLList,
{$IfDef Windows}
	WinCrt
{$Else}
	Crt
{$EndIf}
	;

Const
	{ Menu options }
	OPT_LOAD = '1';
	OPT_SAVE = '2';
	OPT_VIEW = '3';
	OPT_DELT = '4';
	OPT_QUIT = '5';
	{ File to open }
	FILENAME = 'STRINGS.TXT';
	{ Error strings }
	ERROR_CANTWRITE = 'ERROR - Can''t open file to write ';
	ERROR_CANTLOAD  = 'ERROR - Can''t load ';
	ERROR_NOINFO    = 'ERROR - File contains no information';
	ERROR_NODATA    = 'ERROR - No data loaded';
	ERROR_NOTFOUND  = 'ERROR - Item not found';
	ERROR_NOLIST    = 'ERROR - Can''t create list';
	ERROR_MEM       = 'ERROR - Not all memory has been returned! ';

(***********************************************************)
{ Wait util a key is pressed... }
Procedure AnyKey;

Var
	ch : Char;

Begin
	Write('Press any key to continue.');
	ch := Readkey;
	Writeln;
End;

(***********************************************************)
{ load the text file fname into the list, inserting in alphabetical order... }
Function LoadStrings(VAR list : pDLList; fname : String) : Boolean;

Var
	ret  : Boolean;
	f    : Text;
	s    : String;
	node : pDLNode;

Begin
	ret := False;
	{ assign and open the file for reading }
	Assign(f, fname);
	Reset(f);
	If IOResult = 0 Then Begin
		{ file opened okay, read lines until EOF is reached }
		While NOT Eof(f) Do Begin
			Readln(f,s);
			node := dl_AllocNode;
			dl_SetData(node, s);
			{ add to list in alphabetical order }
			dl_AddOrder(list, node);
		End;
		{ Close the file }
		Close(f);
		{ and return success }
		ret := True;
	End;
	LoadStrings := ret;
End;

(***********************************************************)
{ save the list to the file fname }
Procedure SaveStrings(list : pDLList; fname : String);

Var
	node : pDLNode;
	f    : Text;

Begin
	{ assign file and open for writting }
	Assign(f, fname);
	ReWrite(f);
	If IOResult = 0 Then Begin
		{ file opened ok... for each node do... }
		node := dl_Head(list);
		While dl_NodeValid(node) Do Begin
			{ output the data }
			Writeln(f, dl_Data(node));
			{ get the next node }
			node := dl_Next(node);
		End;
		Writeln('Written data to ',fname);
		{ close file }
		Close(f);
	End else
		{ otherwise print error }
		Writeln(ERROR_CANTWRITE,fname);
End;

(***********************************************************)
{ view the contents of a list }
Procedure ViewList(list : pDLList);

Var
	node : pDLNode;

Begin
	Writeln('List Contents:');
	{ for each node do... }
	node := dl_Head(list);
	While dl_NodeValid(node) Do Begin
		{ dump the data }
		Writeln(' "',dl_Data(node),'"');
		node := dl_Next(node);
	End;
End;

(***********************************************************)
{ prompt the user for a string, and then remove the first }
{ node in the list which matches exactly }
Procedure DeleteMatch(list : pDLList);

Var
	node : pDLNode;
	s    : String;

Begin
	{ get the required deletion }
	Write('Enter text to remove from data list (case sensitive) : ');
	Readln(s);
	{ find a match }
	node := dl_Find(list, s);
	If node <> NIL Then Begin
		{ found, so remove }
		dl_Remove(node);
		{ free mem }
		dl_FreeNode(node);
		Writeln('"',s,'" removed.');
	End Else
		{ not found.. error report }
		Writeln(ERROR_NOTFOUND);
End;

(***********************************************************)
{ main procedure }
Procedure Main;

Var
	list : pDLList;
	ch   : Char;

Begin
	{ alloc the list }
	list := dl_AllocList;
	{ list MUST be valid.... }
	If list <> NIL Then Begin
		Repeat
			{ clear screen and display menu }
			ClrScr;
			Writeln('TextManager - Select an option:');
			Writeln;
			Writeln('  [',OPT_LOAD,'] Load STRINGS.TXT');
			Writeln('  [',OPT_SAVE,'] Save STRINGS.TXT');
			Writeln('  [',OPT_VIEW,'] View Data');
			Writeln('  [',OPT_DELT,'] Delete a data item');
			Writeln('  [',OPT_QUIT,'] Exit');
			ch := Readkey;
			Case ch Of
				OPT_LOAD : Begin
					{ load file into list }
					ClrScr;
					{ free all nodes in list }
					dl_FreeAllNode(list);
					If NOT LoadStrings(list, FILENAME) Then
						{ write error }
						Writeln(ERROR_CANTLOAD,FILENAME)
					Else Begin
						{ check to see if file was empty }
						If dl_IsEmpty(list) Then
							Writeln(ERROR_NOINFO)
						Else
							Writeln('Data loaded.');
					End;
					AnyKey;
				End;
				OPT_SAVE : Begin
					{ save the list to a text file }
					ClrScr;
					If dl_IsEmpty(list) Then
						Writeln(ERROR_NODATA)
					else
						SaveStrings(list, FILENAME);
					AnyKey;
				End;
				OPT_VIEW : Begin
					{ view the list }
					ClrScr;
					If dl_IsEmpty(list) Then
						{ error... }
						Writeln(ERROR_NODATA)
					else Begin
						ViewList(list);
						Writeln;
					End;
					AnyKey;
				End;
				OPT_DELT : Begin
					{ delete an item from the list }
					ClrScr;
					If dl_IsEmpty(list) Then
						{ error... }
						Writeln(ERROR_NODATA)
					else
						DeleteMatch(list);
					AnyKey;
				End;
				OPT_QUIT : Begin
					{ quit }
					Writeln('Quitting...');
					ClrScr;
				End;
			End;
		Until ch = OPT_QUIT;
		{ free all nodes and list }
		dl_FreeList(list);
		If dl_mem <> 0 Then Begin
			{ not all memory returned!!! }
			Writeln(ERROR_MEM,dl_mem);
		End;
	End Else
		{ couldnt alloc list... }
		Writeln(ERROR_NOLIST);
End;

(***********************************************************)
Begin main End.
(***********************************************************)