
/*

   simple_play.c

   Ein einfacher CD-Player auf Shell-Basis mit der cdplayer.library
   (c) 1995 by Patrick Hess, alle Rechte reserviert

*/

#include <exec/types.h>

#include <dos/dos.h>
#include <dos/rdargs.h>

#include <libraries/cdplayer.h>

#include <proto/cdplayer.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <pragmas/cdplayer_pragmas.h>

struct IOStdReq	*CD_Request;
struct MsgPort	*CD_Port;

struct Library	*CDPlayerBase = NULL;

STRPTR Version = "$VER: SimplePlay 1.0 (29.5.1995)";

enum
{
	ARG_DEVICE, ARG_UNIT, ARG_EJECT, ARG_STOP, ARG_PAUSE,
	ARG_RESUME, ARG_PLAY, ARG_JUMP, ARG_VOL_LEFT, ARG_VOL_RIGHT, ARG_FULL, ARG_MAX
};

void main (void)
{
	struct RDArgs *rda;
	LONG vec[ARG_MAX];
	ULONG i = 0, Unit = 2;
	STRPTR Device = "scsi.device";

	struct CD_TOC table;	/* Inhaltsverzeichniss */
	struct CD_Time cd_time;	/* Zeittabelle */
	struct CD_Volume vol;	/* Lautstärke */
	struct CD_Info info;	/* Info über Device */

	vec[ARG_DEVICE] = (LONG) Device;	/* Default ist scsi.device */
	vec[ARG_UNIT]   = (LONG) &Unit;		/* Unit 2 */

	/* andere Werte initialisieren */

	vec[ARG_EJECT] = vec[ARG_STOP]  = vec[ARG_PAUSE]    = vec[ARG_RESUME]    = 
	vec[ARG_PLAY]  = vec[ARG_JUMP]  = vec[ARG_VOL_LEFT] = vec[ARG_VOL_RIGHT] =
	vec[ARG_FULL]  = 0L;

	if ((rda = ReadArgs ("DEVICE/K,UNIT/N,EJECT/S,STOP/S,PAUSE/S,RESUME/S,PLAY/N,JUMP/N,VL=VOL_LEFT/N,VR=VOL_RIGHT/N,FULL/S", vec, NULL)))
	{
		/* Argumente bearbeiten */

		if (CDPlayerBase = OpenLibrary (CDPLAYERNAME, CDPLAYERVERSION))
		{
			/* cdplayer.library öffnen */

			if (NULL != (CD_Port = CreateMsgPort ()))
			{
				/* MsgPort basteln */

				if (NULL != (CD_Request = (struct IOStdReq *) CreateIORequest (CD_Port, sizeof (struct IOStdReq))))
				{
					/* IORequest zusammennbacken */

					if (NULL == (OpenDevice ((STRPTR) vec[ARG_DEVICE], * (const LONG *) vec[ARG_UNIT], (struct IORequest *) CD_Request, 0)))
					{
						/* ...und das Device öffnen! */

						/* Nun lesen wir direkt am Anfang das Inhaltsverzeichniss */
						/* ein, das bleibt bis auf den aktuellen Titel eh immer */
						/* gültig, solange die CD im Laufwerk ist */

						if (0 == CDReadTOC (&table, CD_Request))
						{
							/* TOC ist gelesen */

							Printf ("\nTable of Contents:\n\n%ld Tracks. Aktueller Track: %ld\n\n", table.cdc_NumTracks, CDCurrentTitle (CD_Request));

							/* Will USER alles sehen? */

							if (vec[ARG_FULL])
							{
								/* nun geben wir zu jedem Track die entsprechenden Daten aus */

								for (i = 0; i < table.cdc_NumTracks; i++)
									Printf ("%3ld. %s %08ld %02ld:%02ld\n", i+1, (table.cdc_Flags[i] ? "DATA " : "AUDIO"), table.cdc_Addr[i], BASE2MIN (table.cdc_Addr[i+1] - table.cdc_Addr[i]), BASE2MIN (table.cdc_Addr[i+1] - table.cdc_Addr[i]));

								/* wir holen uns die aktuelle Position auf der CD -> Zeiten */

								if (0 == (CDTitleTime (&cd_time, CD_Request)))
								{
									/* ...und geben diese auf den Bildschirm aus */

									Printf ("\n"

											"Track: Aktuell %02ld:%02ld, "
											"Restzeit %02ld:%02ld, "
											"Gesammt %02ld:%02ld\n"
											"CD: Aktuell %02ld:%02ld, "
											"Restzeit %02ld:%02ld, "
											"Gesammt %02ld:%02ld\n\n",

											BASE2MIN (cd_time.cdt_TrackCurBase), BASE2SEC (cd_time.cdt_TrackCurBase),
											BASE2MIN (cd_time.cdt_TrackRemainBase), BASE2SEC (cd_time.cdt_TrackRemainBase),
											BASE2MIN (cd_time.cdt_TrackCompleteBase), BASE2SEC (cd_time.cdt_TrackCompleteBase),
											BASE2MIN (cd_time.cdt_AllCurBase), BASE2SEC (cd_time.cdt_AllCurBase),
											BASE2MIN (cd_time.cdt_AllRemainBase), BASE2SEC (cd_time.cdt_AllRemainBase),
											BASE2MIN (cd_time.cdt_AllCompleteBase), BASE2SEC (cd_time.cdt_AllCompleteBase));
								}
								else
									PutStr ("Kann aktuelle Spielzeit nicht ermitteln.\n");

								/* Nachsehen, ob die CD gerade läuft */
	
								Printf ("Die CD wird gerade %sgespielt.\n", (CDActive (CD_Request) ? "" : "nicht "));
	
								/* Infos über das Laufwerk holen */

								if (0 == CDInfo (&info, CD_Request))
									Printf ("Gerätetyp: %ld, entnehmbares Medium: %s\n"
											"SCSI %ld, Vendor: %s, VendorSpec: %s\n"
											"ProductID: %s, ProductRev: %s\n\n",

											info.cdi_DeviceType, (info.cdi_RemovableMedium ? "JA" : "NEIN"),
											info.cdi_ANSIVersion, info.cdi_VendorID, info.cdi_VendorSpec,
											info.cdi_ProductID, info.cdi_ProductRev);
								else
									PutStr ("Bekomme keine Infos über SCSI-Gerät.\n\n");
							}

							/* Nun holen wir uns mal die Lautstärke und geben die aus */

							if (0 == CDGetVolume (&vol, CD_Request))
								Printf ("Lautstärke: Kanal 0 = %ld, Kanal 1 = %ld, Kanal 2 = %ld, Kanal 3 = %ld.\n\n",
									vol.cdv_Chan0, vol.cdv_Chan1, vol.cdv_Chan2, vol.cdv_Chan3);
							else
								PutStr ("Bekomme keine Infos über Lautstärke.\n");				

							/* nun folgen die direkten Kommandos */

							if (vec[ARG_EJECT])
								Printf ("CDEject (...) - Result: %d\n", CDEject (CD_Request));

							if (vec[ARG_STOP])
								Printf ("CDStop (...) - Result: %d\n", CDStop (CD_Request));

							if (vec[ARG_PAUSE])
								Printf ("CDResume (TRUE, ...) - Result: %d\n", CDResume (TRUE, CD_Request));

							if (vec[ARG_RESUME])
								Printf ("CDResume (FALSE, ...) - Result: %d\n", CDResume (FALSE, CD_Request));

							if (vec[ARG_PLAY])
								Printf ("CDPlay (%ld, ...) TO %ld - Result: %d\n", * (const LONG *) vec[ARG_PLAY], table.cdc_NumTracks - 1, CDPlay (* (const LONG *) vec[ARG_PLAY], table.cdc_NumTracks - 1, CD_Request));

							if (vec[ARG_JUMP])
								Printf ("CDJump (%ld, ...) - Result: %d\n", * (const LONG *) vec[ARG_JUMP], CDJump (* (const LONG *) vec[ARG_JUMP], CD_Request));

							if (vec[ARG_VOL_RIGHT])
								vol.cdv_Chan0 = (UBYTE) * (const LONG *) vec[ARG_VOL_RIGHT];

							if (vec[ARG_VOL_LEFT])
								vol.cdv_Chan1 = (UBYTE) * (const LONG *) vec[ARG_VOL_LEFT];

							if ((vec[ARG_VOL_LEFT]) || (vec[ARG_VOL_RIGHT]))
								Printf ("CDSetVolume (...) %d/%d - Result: %d\n", vol.cdv_Chan0, vol.cdv_Chan1, CDSetVolume (&vol, CD_Request));

							CloseDevice ((struct IORequest *) CD_Request);
						}
						else
							PutStr ("Kann Inhaltsverzeichniss nicht lesen.\n");
					}
					else
						Printf ("Kann das \"%s\" Unit %ld nicht öffnen.\n", (STRPTR) vec[ARG_DEVICE], * (const LONG *) vec[ARG_UNIT]);
	
					DeleteIORequest (CD_Request);
				}
				else
					PutStr ("Fehler bei CreateIORequest().\n");

				DeleteMsgPort (CD_Port);
			}
			else
				PutStr ("Fehler bei CreateMsgPort().\n");

			CloseLibrary (CDPlayerBase);
		}
		else
			PutStr ("Kann die cdplayer.library nicht öffnen.\n");

		FreeArgs (rda);
	}
	else
		PrintFault (IoErr(), "SimplePlay");
}

