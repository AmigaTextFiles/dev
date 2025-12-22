(*--------------------------------------------------------------------------*
 * WangiPad                                                                 *
 * Lee Kindness - 8 Craigmarn Rd. Portlethen. ABERDEEN AB1 4QR SCOTLAND     *
 *                                                                          *
 * Version 1.15                                                              *
 *--------------------------------------------------------------------------*)
 
(* Registered users:
 * 5750XXXX 
 *
 * 0000 : Lee Kindness
 * 2613 : Bill Falls (bfalls@cais.com) 2613 8th St. South, Apt. 593C, Arlington, VA 22204-2260, USA
 * 1234 : Tom Pettigrew
 *
 *)

{ all version dependent strings }

CONST
{$IFNDEF PREFSEDITOR}
	WVer      : string[31] = '$VER: WangiPad 1.15 (26.02.95)'#0;
	CX_NAME   : String[ 9] = 'WangiPad'#0;
	CX_TITLE  : String[39] = 'WangiPad 1.15 (26.02.95) ©Lee Kindness'#0;
	CX_DESCR  : String[36] = 'Access to your programs from a list'#0;
{$ELSE}
	Win_Title : string[25] = 'WangiPad Preferences'#0;
	Scr_Title : string[46] = 'WangiPad Preferences 1.15 ©94-95 Lee Kindness'#0;
	PrefsVer  : string[37] = '$VER: WangiPad_Prefs 1.15 (26.02.95)'#0;
{$ENDIF}





