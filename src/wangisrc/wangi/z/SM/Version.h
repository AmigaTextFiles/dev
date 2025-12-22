(*--------------------------------------------------------------------------*
 * Startup-Menu                                                             *
 * Lee Kindness - 8 Craigmarn Rd. Portlethen. ABERDEEN AB1 4QR SCOTLAND     *
 *                                                                          *
 * Version 1.45                                                             *
 *--------------------------------------------------------------------------*)

{ all version dependent strings }

CONST
{$IFNDEF PREFSEDITOR}
	SMVer     : string[35] = '$VER: Startup-Menu 1.45 (26.03.96)'#0;
{$ELSE}
	PrefsVer  : string[30] = '$VER: SMPrefs 1.45 (26.03.96)'#0;
	Win_Title : string[25] = 'Startup-Menu preferences'#0;
	Scr_Title : string[47] = 'SMPrefs 1.45 Copyright ©1994-1996 Lee Kindness'#0;
	InfoHead  : String[29] = 'Startup-Menu 1.45 (26.03.96)'#10;
{$ENDIF}

{Startup-Menu 1.42 (30.05.95)}
