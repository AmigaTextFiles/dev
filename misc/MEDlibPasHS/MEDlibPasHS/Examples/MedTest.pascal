program MedTest;
uses MedPlayer, Exec;

const
	MED_Filename = 'dh1:x3.med';	{ *** CHANGE THIS *** }

var
	LugarMed	: pointer;	{ pointer for MED module in memory	}
	RetCode 	: longint;  { function return code				}
	bibibi		: string;	{ 'press enter for stopping'		}

begin
	{ open library	}
	MedPlayerBase := OpenLibrary ('medplayer.library',2);

	{ allocate channels and whatever..	}
	RetCode := GetPlayer (0);

	{ load and, then, play..	}
	LugarMed := LoadModule (MED_Filename);
	PlayModule (LugarMed);

	{ wait for [enter], then, stop playing	}
	writeln ('press [enter] for stop playing');
	read (bibibi);
	StopPlayer;
	writeln ('music stopped.');

	{ unload module from mem, de-allocate channels, close library	}
	UnLoadModule (LugarMed);
	FreePlayer;
	CloseLibrary (MedPlayerBase);
end.