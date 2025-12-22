/*
**	rexxhost.library - ARexx host management support library
**
**	Copyright © 1990-1992 by Olaf `Olsen' Barthel
**		All Rights Reserved
*/

	/* CreateRexxHost(HostName):
	 *
	 *	Creates a RexxHost (special MsgPort) with a given name.
	 *	Returns NULL if port already exists.
	 */

struct RexxHost * __saveds __asm
CreateRexxHost(register __a0 STRPTR HostName)
{
	struct RexxHost *RexxHost;

		/* Valid name given? */

	if(HostName)
	{
		if(HostName[0])
		{
				/* Already present? */

			if(!FindPort(HostName))
			{
					/* Allocate the port body. */

				if(RexxHost = (struct RexxHost *)AllocMem(sizeof(struct RexxHost),MEMF_PUBLIC | MEMF_CLEAR))
				{
						/* Allocate a signal bit. */

					if((RexxHost -> rh_Port . mp_SigBit = AllocSignal(-1)) != -1)
					{
							/* Initialize the MsgPort node head. */

						RexxHost -> rh_Port . mp_Node . ln_Type	= NT_MSGPORT;
						RexxHost -> rh_Port . mp_Node . ln_Pri	= 1;

							/* Allocate memory for MsgPort name. */

						if(RexxHost -> rh_Port . mp_Node . ln_Name = (UBYTE *)AllocMem(strlen(HostName) + 1,MEMF_PUBLIC))
						{
								/* Copy the name. */

							strcpy(RexxHost -> rh_Port . mp_Node . ln_Name,HostName);

								/* Deal with the rest of the flags. */

							RexxHost -> rh_Port . mp_Flags		= PA_SIGNAL;
							RexxHost -> rh_Port . mp_SigTask	= SysBase -> ThisTask;

								/* A dummy ID. */

							RexxHost -> rh_SpecialID = 'REXX';

								/* Finally add it to the public port list. */

							AddPort(&RexxHost -> rh_Port);

								/* And return it to the caller. */

							return(RexxHost);
						}

						FreeSignal(RexxHost -> rh_Port . mp_SigBit);
					}

					FreeMem(RexxHost,sizeof(struct RexxHost));
				}
			}
		}
	}

	return(NULL);
}

	/* DeleteRexxHost(RexxHost):
	 *
	 *	Deletes a MsgPort as created by CreateRexxHost().
	 *	Returns NULL, so user can do 'Host = DeleteRexxHost(Host);'.
	 */

VOID * __saveds __asm
DeleteRexxHost(register __a0 struct RexxHost *RexxHost)
{
		/* Valid host port given? */

	if(RexxHost)
	{
		if(RexxHost -> rh_SpecialID == 'REXX')
		{
				/* Remove it from the public list. */

			RemPort(&RexxHost -> rh_Port);

				/* Free the name. */

			FreeMem(RexxHost -> rh_Port . mp_Node . ln_Name,strlen(RexxHost -> rh_Port . mp_Node . ln_Name) + 1);

				/* Free the allocated signal bit. */

			FreeSignal(RexxHost -> rh_Port . mp_SigBit);

				/* Free the body. */

			FreeMem(RexxHost,sizeof(struct RexxHost));
		}
	}

	return(NULL);
}

	/* SendRexxCommand(HostPort,CommandString,FileExtension,HostName):
	 *
	 *	Sends a command to the rexx server, requires pointers
	 *	to the MsgPort of the calling Host and the command string.
	 *	File extension and host name are optional and may be
	 *	NULL.
	 */

LONG __saveds __asm
SendRexxCommand(register __a0 struct RexxHost *HostPort,register __a1 STRPTR CommandString,register __a2 STRPTR FileExtension,register __a3 STRPTR HostName)
{
	struct MsgPort	*RexxPort = (struct MsgPort *)FindPort(RXSDIR);
	struct RexxMsg	*HostMessage;

		/* Valid pointers given? */

	if(CommandString && HostPort && RexxPort)
	{
		if(HostPort -> rh_SpecialID == 'REXX')
		{
				/* No special host name given? Take the MsgPort name. */

			if(!HostName)
				HostName = (STRPTR)HostPort -> rh_Port . mp_Node . ln_Name;

				/* No file name extension? Take the default. */

			if(!FileExtension)
				FileExtension = (STRPTR)"rexx";

				/* Create the message. */

			if(HostMessage = CreateRexxMsg((struct MsgPort *)HostPort,FileExtension,HostName))
			{
					/* Add the command. */

				if(HostMessage -> rm_Args[0] = CreateArgstring(CommandString,strlen(CommandString)))
				{
						/* This is a command, not a function. */

					HostMessage -> rm_Action = RXCOMM;

						/* Release it... */

					PutMsg(RexxPort,HostMessage);

						/* Successful action. */

					return(TRUE);
				}

				DeleteRexxMsg(HostMessage);
			}
		}
	}

	return(FALSE);
}

	/* FreeRexxCommand(RexxMessage):
	 *
	 *	Frees the contents of a RexxMsg.
	 */

VOID __saveds __asm
FreeRexxCommand(register __a0 struct RexxMsg *RexxMessage)
{
		/* Valid pointer given? */

	if(RexxMessage)
	{
		if(RexxMessage -> rm_Node . mn_Node . ln_Type == NT_REPLYMSG)
		{
				/* Remove argument. */

			if(RexxMessage -> rm_Args[0])
				DeleteArgstring(RexxMessage -> rm_Args[0]);

				/* Free the message. */

			DeleteRexxMsg(RexxMessage);
		}
	}
}

	/* ReplyRexxCommand(RexxMessage,Primary,Secondary,Result):
	 *
	 *	Sends a RexxMsg back to the rexx server, can include
	 *	result codes.
	 */

VOID __saveds __asm
ReplyRexxCommand(register __a0 struct RexxMsg *RexxMessage,register __d0 LONG Primary,register __d1 LONG Secondary,register __a1 STRPTR Result)
{
		/* Valid pointer given? */

	if(RexxMessage)
	{
		if(RexxMessage -> rm_Node . mn_Node . ln_Type == NT_MESSAGE)
		{
				/* No secondary result and results wanted? */

			if(Secondary == NULL && (RexxMessage -> rm_Action & RXFF_RESULT))
			{
					/* Build result string... */

				if(Result)
					Secondary = (LONG)CreateArgstring(Result,strlen(Result));
			}

				/* Set both results... */

			RexxMessage -> rm_Result1 = Primary;
			RexxMessage -> rm_Result2 = Secondary;

				/* ...and reply the message. */

			ReplyMsg(RexxMessage);
		}
	}
}

	/* GetRexxCommand(RexxMessage):
	 *
	 *	Returns a pointer to the command string if
	 *	the RexxMsg is a command request.
	 */

STRPTR __saveds __asm
GetRexxCommand(register __a0 struct RexxMsg *RexxMessage)
{
	if(RexxMessage)
	{
		if(RexxMessage -> rm_Node . mn_Node . ln_Type != NT_REPLYMSG)
			return(RexxMessage -> rm_Args[0]);
	}

	return(NULL);
}

	/* GetRexxArg(RexxMessage):
	 *
	 *	Returns a pointer to the first RexxMsg argument.
	 */

STRPTR __saveds __asm
GetRexxArg(register __a0 struct RexxMsg *RexxMessage)
{
	if(!RexxMessage)
		return(NULL);
	else
		return(RexxMessage -> rm_Args[0]);
}

	/* GetRexxResult1(RexxMessage):
	 *
	 *	Returns the 1st RexxMsg result.
	 */

LONG __saveds __asm
GetRexxResult1(register __a0 struct RexxMsg *RexxMessage)
{
	if(!RexxMessage)
		return(NULL);
	else
		return(RexxMessage -> rm_Result1);
}

	/* GetRexxResult2(RexxMessage):
	 *
	 *	Returns the 2nd RexxMsg result.
	 */

LONG __saveds __asm
GetRexxResult2(register __a0 struct RexxMsg *RexxMessage)
{
	if(!RexxMessage)
		return(NULL);
	else
		return(RexxMessage -> rm_Result2);
}

	/* IsSpace():
	 *
	 *	Returns TRUE if the input character is a space, tab,
	 *	carriage return, newline, form feed or vertical tab.
	 */

STATIC BYTE __regargs
IsSpace(UBYTE c)
{
	if((c >= 13 && c <= 17) || c == 32)
		return(TRUE);
	else
		return(FALSE);
}

	/* GetToken(String,StartChar,AuxBuff,MaxLength):
	 *
	 *	Fills a string with the next given string
	 *	argument.
	 */

STRPTR __saveds __asm
GetToken(register __a0 STRPTR String,register __a1 LONG *StartChar,register __a2 STRPTR AuxBuff,register __d0 LONG MaxLength)
{
	LONG i,StrEnd = 0,MaxPos = strlen(String);

		/* Last counter position. */

	if(MaxPos >= MaxLength + *StartChar)
		MaxPos = MaxLength + *StartChar - 1;

		/* Already finished with argument string? */

	if(*StartChar <= strlen(String) - 1 && String && String[0] && AuxBuff && MaxLength)
	{
			/* Parse the argument string... */

		for(i = *StartChar ; i <= MaxPos ; i++)
		{
				/* Skip leading blanks... */

			if(!StrEnd && IsSpace(String[i]))
			{
				while(IsSpace(String[i]) && i < MaxPos)
				{
					i++;

					(*StartChar)++;
				}
			}

				/* Found an argument. */

			if(IsSpace(String[i]) || String[i] == 0)
			{
					/* Copy it to the auxiliary buffer. */

				strncpy(AuxBuff,(String + *StartChar),StrEnd);
				AuxBuff[StrEnd] = 0;

					/* Change the position counter (since
					 * we can't use static data initialisation
					 * calling program has to supply a
					 * counter variable).
					 */

				(*StartChar) += StrEnd;

				return(AuxBuff);
			}

				/* Increment character counter. */

			StrEnd++;
		}
	}

	return(NULL);
}

	/* GetStringValue(String):
	 *
	 *	Returns the numeric value taken from given string
	 *	(just like atoi(), taken from example source code
	 *	by K&R).
	 */

LONG __saveds __asm
GetStringValue(register __a0 STRPTR String)
{
	LONG	Value,i;
	BYTE	Sign = 1;

		/* Valid argument given? */

	if(String)
	{
		if(String[0])
		{
				/* Skip leading blank characters. */

			for(i = 0 ; String[i] == ' ' || String[i] == '\n' || String[i] == '\t' ; i++);

				/* Remember sign extension. */

			if(String[i] == '+' || String[i] == '-')
				Sign = (String[i++] == '+') ? 1 : -1;

				/* Convert from ASCII to decimal. */

			for(Value = 0 ; String[i] >= '0' && String[i] <= '9' ; i++)
				Value = 10 * Value + String[i] - '0';

				/* Return real value. */

			return(Sign * Value);
		}
	}

	return(0);
}

	/* BuildValueString(Value,String):
	 *
	 *	Puts a numeric value in decimal form into a
	 *	given string (similar to itoa(), taken from
	 *	example source code by K&R).
	 */

STRPTR __saveds __asm
BuildValueString(register __d0 LONG Value,register __a0 STRPTR String)
{
	LONG	Sign,i = 0,j;
	UBYTE	c;

		/* Valid argument given? */

	if(String)
	{
			/* Remember sign extension. */

		if((Sign = Value) < 0)
			Value = -Value;

			/* Convert it into ASCII characters (in
			 * reverse order, i.e. 1234 = "4321").
			 */

		do
			String[i++] = Value % 10 + '0';
		while((Value /= 10) > 0);

			/* Add sign extension. */

		if(Sign < 0)
			String[i++] = '-';

			/* String NULL-termination. */

		String[i] = 0;

			/* Reverse the string. */

		for(i = 0, j = strlen(String) - 1 ; i < j ; i++, j--)
		{
			c		= String[i];
			String[i]	= String[j];
			String[j]	= c;
		}
	}

	return(String);
}

	/* AmigaToUpper(c):
	 *
	 *	Replacement for toupper() macro, also knows how to
	 *	map international characters to uppercase. Note: not
	 *	a real library module.
	 */

STATIC UBYTE __regargs
AmigaToUpper(UBYTE c)
{
	/* -------- DEC ---------    -------- ASCII ------- */

	if((c >= 224 && c <= 254) || (c >= 'a' && c <= 'z'))
		c -= 32;

	return(c);
}

	/* RexxStrCmp(Source,Target):
	 *
	 *	Compares two strings ignoring case.
	 */

LONG __saveds __asm
RexxStrCmp(register __a0 STRPTR Source,register __a1 STRPTR Target)
{
		/* Do the string comparison ignoring case. */

	for( ; AmigaToUpper(*Source) == AmigaToUpper(*Target) ; Source++, Target++)
	{
		if(!(*Source))
			return(0);
	}

	return(AmigaToUpper(*Source) - AmigaToUpper(*Target));
}

	/* GetRexxMsg():
	 *
	 *	Picks up pending RexxMessages from a RexxHost and
	 *	returns them to the caller. I desired, will wait
	 *	for new messages to arrive if none is present yet.
	 */

struct RexxMsg * __saveds __asm
GetRexxMsg(register __a0 struct RexxHost *RexxHost,register __d0 LONG Wait)
{
	struct RexxMsg *RexxMessage = NULL;

		/* Valid pointer given? */

	if(RexxHost)
	{
		if(RexxHost -> rh_SpecialID == 'REXX')
		{
				/* Try to pick up a message. */

			while(!(RexxMessage = (struct RexxMsg *)GetMsg((struct MsgPort *)RexxHost)))
			{
					/* No message available. Are we to wait? */

				if(Wait)
					WaitPort((struct MsgPort *)RexxHost);
				else
					break;
			}
		}
	}

		/* Return the result (may be NULL). */

	return(RexxMessage);
}

	/* SendRexxMsg():
	 *
	 *	Sends a single (or a list of) command(s) to Rexx host
	 *	and returns the secondary result.
	 */

ULONG __saveds __asm
SendRexxMsg(register __a0 STRPTR HostName,register __a1 STRPTR *MsgList,register __a2 STRPTR SingleMsg,register __d0 LONG GetResult)
{
	struct RexxMsg	*RexxMessage;
	struct MsgPort	*HostPort,*ReplyPort;
	ULONG		 Result = 0;
	SHORT		 i;

		/* Valid pointers given? */

	if(HostName && (MsgList || SingleMsg))
	{
			/* Can we find the host? */

		if(HostPort = (struct MsgPort *)FindPort(HostName))
		{
				/* Allocate a reply port. */

			if(ReplyPort = (struct MsgPort *)AllocMem(sizeof(struct MsgPort),MEMF_PUBLIC | MEMF_CLEAR))
			{
				if((ReplyPort -> mp_SigBit = AllocSignal(-1)) != -1)
				{
					ReplyPort -> mp_Node . ln_Type	= NT_MSGPORT;
					ReplyPort -> mp_Flags		= PA_SIGNAL;
					ReplyPort -> mp_SigTask		= SysBase -> ThisTask;

					NewList(&ReplyPort -> mp_MsgList);

						/* Create a Rexx message. */

					if(RexxMessage = (struct RexxMsg *)CreateRexxMsg(ReplyPort,"",HostName))
					{
							/* A list of arguments or only a single arg? */

						if(MsgList)
						{
							for(i = 0 ; i < 16 ; i++)
								RexxMessage -> rm_Args[i] = MsgList[i];
						}
						else
							RexxMessage -> rm_Args[0] = SingleMsg;

							/* Do we want result codes? */

						if(GetResult)
							RexxMessage -> rm_Action = RXFF_RESULT;

							/* Send packet and wait for the reply. */

						PutMsg(HostPort,RexxMessage);

						WaitPort(ReplyPort);

							/* Remember result. */

						if(GetResult && !RexxMessage -> rm_Result1)
							Result = RexxMessage -> rm_Result2;

							/* Remove Rexx message. */

						DeleteRexxMsg(RexxMessage);
					}

						/* Free reply port signal bit. */

					FreeSignal(ReplyPort -> mp_SigBit);
				}

					/* Free the replyport itself. */

				FreeMem(ReplyPort,sizeof(struct MsgPort));
			}
		}
	}

		/* Return the result. */

	return(Result);
}

	/* GetRexxString():
	 *
	 *	Copy the result string returned by SendRexxMsg to user
	 *	buffer and/or remove the original string.
	 */

VOID __saveds __asm
GetRexxString(register __d0 STRPTR SourceString,register __d1 STRPTR DestString)
{
		/* Valid pointer given? */

	if(SourceString)
	{
			/* Destination memory buffer given? */

		if(DestString)
			strcpy(DestString,SourceString);

			/* Deallocate the original string. */

		DeleteArgstring(SourceString);
	}
}

	/* GetRexxClip():
	 *
	 *	Searches the rexx clip list for a node with given
	 *	name.
	 */

LONG __saveds __asm
GetRexxClip(register __a0 UBYTE *Name,register __d0 LONG WhichArg)
{
		/* Do we have valid buffers and size? */

	if(Name)
	{
		if(Name[0])
		{
			struct RexxRsrc *Node;

				/* Can we find the clip node? */

			if(Node = (struct RexxRsrc *)FindRsrcNode(&RexxSysBase -> rl_ClipList,Name,RRT_CLIP))
			{
				if(WhichArg)
					return(Node -> rr_Arg1);
				else
					return(Node -> rr_Arg2);
			}
		}
	}

	return(NULL);
}
