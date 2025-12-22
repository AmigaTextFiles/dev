#include "PH_Include.h"
extern struct DosLibrary *DOSBase;
UBYTE ToExecute[250];

/***************************************************************************/
/*                               AddAString                                */
/*-------------------------------------------------------------------------*/
/*                       Add a string in the buffer.                       */
/***************************************************************************/

UBYTE *StringBuffer = NULL;
UBYTE nb_char_in_StringBuffer = 0, nb_char_memory = 0;
#define STEP_ADD_STRING		1024

UBYTE *AddAString(string)
UBYTE *string;
{
	UBYTE *ts;
	UWORD lenstring;

	lenstring = strlen(string) + 1;
	if (nb_char_in_StringBuffer + lenstring > nb_char_memory)
	{
		nb_char_memory = nb_char_in_StringBuffer + lenstring + STEP_ADD_STRING;
		if (ts = realloc(StringBuffer, nb_char_memory))
			StringBuffer = ts;
		else
		{
			printf("Not enough memory for StringBuffer!\n");
			return (NULL);
		}
	}

	ts = &StringBuffer[nb_char_in_StringBuffer];
	strcpy(ts, string);
	nb_char_in_StringBuffer += lenstring;
	return (ts);
}

void FreeStringBuffer()
{
	if (StringBuffer)
		free(StringBuffer);
}

/***************************************************************************/
/*                        FillSourceNameLineNumber                         */
/*-------------------------------------------------------------------------*/
/*   Call 'Findline' to get the SourceName and line number of this hit.    */
/***************************************************************************/

UWORD FillSourceNameLineNumber(newhit)
struct InfoHit *newhit;
{
	UBYTE *buffer, *bt;
	int error;

	sprintf(ToExecute, "findline >T:FindLineTemp MODNAME \"%s\" OFFSET %X HUNK %X", newhit->FileName, newhit->Offset, newhit->Hunk);
	error = system(ToExecute);
	if (error < 0)
	{
		printf("An error occur with the 'system' command!\n");
		return (ERROR);
	}

	newhit->mode = MODE_UNDEFINE;
	if (buffer = LoadFileInMemory("T:FindLineTemp"))
	{
		bt = buffer;
		while ((newhit->mode == MODE_UNDEFINE) && (*bt != 0))
		{
			if (!strnicmp(bt, ", Line ", 7))
			{
				if (!PutAnEnd(bt + 7, '.'))
					break;
				stch_l(bt + 7, &(newhit->LineNumber));

				*(--bt) = 0; /* Put a end to the SourceName (PassOver `'`) */
				while (*bt != '\'')
					bt--;
				bt++;

				if (!(newhit->SourceName = AddAString(bt)))
				{
					free(buffer);
					return(ERROR);
				}
				newhit->mode = MODE_OK;
			}
			else
			{
				if (!strnicmp(bt, "Symbol ", 7))
				{
					bt += 7;
					if (!PutAnEnd(bt, '\n'))
						break;

					if (!(newhit->SourceName = AddAString(bt)))
					{
						free(buffer);
						return(ERROR);
					}
					newhit->mode = MODE_SYMBOL;
				}
				else
					bt++;
			}
		}

		free(buffer);
	}
	else
		return (ERROR);

	return (NO_ERROR);
}

/***************************************************************************/
/*                                AddToHit                                 */
/*-------------------------------------------------------------------------*/
/*                    Add an Enforcer Hit to the list.                     */
/*              If it is already there, just increase nb_hit.              */
/***************************************************************************/

struct InfoHit *hitlist = NULL;
ULONG nb_hit_in_list = 0, nb_hit_memory = 0;
#define STEP_HIT_MEMORY 	300

UWORD AddToHit(newhit)
struct InfoHit *newhit;
{
	struct InfoHit *hitlisttemp;
	ULONG i;

	/* Search if already there ***************/
	for (i = 0; i < nb_hit_in_list; i++)
		if ((newhit->Offset == hitlist[i].Offset)
			&& (newhit->Hunk == hitlist[i].Hunk)
			&& (!stricmp(newhit->FileName, hitlist[i].FileName)))
		{
			hitlist[i].nb_hit++;
			return (NO_ERROR_ADDED);
		}

	if (nb_hit_in_list == nb_hit_memory)
	{
		nb_hit_memory += STEP_HIT_MEMORY;
		if (hitlisttemp = realloc(hitlist, nb_hit_memory * sizeof(struct InfoHit)))
			hitlist = hitlisttemp;
		else
		{
			printf("Not enough memory for the hit list!\n");
			return (ERROR);
		}
	}

	if (!FillSourceNameLineNumber(newhit))
		return (ERROR);
	hitlist[nb_hit_in_list++] = *newhit;

	return (NO_ERROR_CREATED);
}

void FreeHitList()
{
	if (hitlist)
		free(hitlist);
}

/***************************************************************************/
/*                            ParseEnfHitBuffer                            */
/*-------------------------------------------------------------------------*/
/*  Parse the EnforcerHitBuffer and get the real line number for each of   */
/*          the distinct Hits. A distinct Hit is a hit where the           */
/*           FileName-Hunk-Offset is not egal to any other Hit.            */
/***************************************************************************/

UBYTE *PutAnEnd(EnfHitBuffer, character)
UBYTE *EnfHitBuffer, character;
{
	if (*EnfHitBuffer == 0) return(FALSE);

	while (*EnfHitBuffer != character)
	{
		if (*EnfHitBuffer == 0) return(FALSE);
		EnfHitBuffer++;
	}
	*EnfHitBuffer++ = 0;
	return (EnfHitBuffer);
}

void ParseEnfHitBuffer(EnfHitBuffer)
UBYTE *EnfHitBuffer;
{
	UBYTE *temp;
	struct InfoHit infohit;

	infohit.FileName = "";
	while (*EnfHitBuffer != 0)
	{
		if (!strnicmp(EnfHitBuffer, "CLI: \"", 6))
		{
			EnfHitBuffer += 6;
			infohit.FileName = EnfHitBuffer;
			if (!(EnfHitBuffer = PutAnEnd(EnfHitBuffer, '\"')))
				return;
		}
		else
		{
			if (!strnicmp(EnfHitBuffer, "Hunk ", 5))
			{
				EnfHitBuffer += 5;
				temp = EnfHitBuffer;
				if (!(EnfHitBuffer = PutAnEnd(EnfHitBuffer, ' ')))
					return;
				stch_l(temp, &(infohit.Hunk));
			}
			else
			{
				if (!strnicmp(EnfHitBuffer, "Offset ", 7))
				{
					EnfHitBuffer += 7;
					temp = EnfHitBuffer;
					if (!(EnfHitBuffer = PutAnEnd(EnfHitBuffer, '\n')))
						return;
					stch_l(temp, &(infohit.Offset));
					infohit.nb_hit = 1;

					if (AddToHit(&infohit) == ERROR)
						return;
				}
				else
					EnfHitBuffer++;
			}
		}
	}
}

/***************************************************************************/
/*                            PutMessageinSCMSG                            */
/*-------------------------------------------------------------------------*/
/*                  Add some message to the SCMSG list...                  */
/***************************************************************************/

void PutMessageinSCMSG()
{
	LONG i;
	if (system("run >nil: <nil: SCMsg") >= 0)
	{
		for (i = 0; i < nb_hit_in_list; i++)
		{
			switch(hitlist[i].mode)
			{
				case MODE_UNDEFINE:
					sprintf(ToExecute, "SYS:RexxC/rx Rexx:PutMsg.rexx \"%s\" 0 There is %d Enforcer hit%s at Hunk %X - Offset %X", hitlist[i].FileName, hitlist[i].nb_hit, (hitlist[i].nb_hit > 1) ? "s" : "", hitlist[i].Hunk, hitlist[i].Offset);
					break;
				case MODE_SYMBOL:
					sprintf(ToExecute, "SYS:RexxC/rx Rexx:PutMsg.rexx \"%s\" 0 There is %d Enforcer hit%s near the Symbol %s", hitlist[i].FileName, hitlist[i].nb_hit, (hitlist[i].nb_hit > 1) ? "s" : "", hitlist[i].SourceName);
					break;
				case MODE_OK:
					sprintf(ToExecute, "SYS:RexxC/rx Rexx:PutMsg.rexx \"%s\" %d There is %d Enforcer hit%s at the line %d", hitlist[i].SourceName, hitlist[i].LineNumber, hitlist[i].nb_hit, (hitlist[i].nb_hit > 1) ? "s" : "", hitlist[i].LineNumber);
					break;
			}
			
			if (system(ToExecute) < 0)
			{
				printf("Can't find or execute 'SYS:RexxC/rx'!\n");
				return;
			}
		}
	}
	else
		printf("Can't execute SCMsg!\n");
}

/***************************************************************************/
/*                                  Main                                   */
/***************************************************************************/

void main(argc, argv)
int argc;
UBYTE *argv[];
{
	UBYTE *EnfHitBuffer, *EnfHitFileName;

	EnfHitFileName = (argc > 2) ? argv[1] : "EnforcerHit";

	if (EnfHitBuffer = LoadFileInMemory(EnfHitFileName))
	{
		ParseEnfHitBuffer(EnfHitBuffer);
		if (nb_hit_in_list)
			PutMessageinSCMSG();
		FreeHitList();
		free(EnfHitBuffer);
		FreeStringBuffer();
	}
}

/***************************************************************************/
/*                            LoadFileInMemory                             */
/*-------------------------------------------------------------------------*/
/*                        Load a file in memory...                         */
/***************************************************************************/

UBYTE *LoadFileInMemory(FileName)
UBYTE *FileName;
{
	struct FileHandle *filehandle;
	ULONG nb_byte;
	UBYTE *BufFile;

	BufFile = NULL;
	if (filehandle = (struct FileHandle *) Open(FileName, MODE_OLDFILE))
	{
		if ((Seek((BPTR) filehandle, 0, OFFSET_END) >= 0)
			&& ((nb_byte = Seek((BPTR) filehandle, 0, OFFSET_BEGINNING)) >= 0))
		{
			if (BufFile = malloc(nb_byte + 1))
			{
				BufFile[nb_byte] = 0;
				if (Read((BPTR) filehandle, BufFile, nb_byte) != nb_byte)
				{
					printf("Error reading EnforcerFile!\n");
					free(BufFile);
				}
			}
			else
				printf("Not enough memory to load the File!\n");
		}
		else
			printf("Error of seeking in the File!\n");
		Close((BPTR) filehandle);
	}
	else
		printf("Can't find File!\n");

	system ("Delete T:FindLineTemp");
	return(BufFile);
}

