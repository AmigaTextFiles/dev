program MODTest;
uses PTReplay, Exec;

const
	MOD_Filename = 'dh1:nemesis.MOD';	{ *** CHANGE THIS *** }

var
	LugarMod	: pModule;	{ pointer for MOD module in memory	}
	RetCode 	: longint;  { function return code				}
	bibibi		: string;	{ 'press enter for stopping'		}

begin
	{ open library	}
	PTReplayBase := OpenLibrary ('ptreplay.library',6);

	if (longint (PTReplayBase) = 0) then
	begin
		writeln ('oops..');
		halt;
	end;

	{ load and, then, play..	}
	LugarMod := PTLoadModule (MOD_Filename);

	PTSetPri (0);
	writeln ('Pri: ', PTGetPri);

	writeln ('lugarmod: ', longint (lugarmod));
	PTPlay (LugarMod);

	writeln ('GetChan: ', PTGetChan);

	{PTOffChannel (LugarMod, 14);}

	{PTSetVolume (LugarMod, 63);	{ volume..	}

	writeln (longint (PTPatternData (LugarMod, 2, 3)));
	writeln (longint (PTPatternData (LugarMod, 2, 3)));

	{PTStartFade (LugarMod, 5);	{ fade..	}

	{ wait for [enter], then, stop playing	}
	writeln ('press [enter] for stop playing');
	read (bibibi);
	PTStop (LugarMod);
	writeln ('music stopped.');

	{ unload module from mem, de-allocate channels, close library	}
	PTUnloadModule (LugarMod);
	CloseLibrary (PTReplayBase);
end.