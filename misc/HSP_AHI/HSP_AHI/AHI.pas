unit AHI;
{ AHI v4 Unit for HSPascal v1.0						}
{ by Daniel Mealha Cabrita	(dancab@polbox.com)		}
{ 17 november, 1997									}

INTERFACE

uses Exec, IFFParse, Utility;

type
	Fixed	= longint;					{ A fixed-point value, 16 bits
											to the left of the point and
											16 bits to the right		}
	sposition = Fixed;

	pAHIAudioCtrl = ^tAHIAudioCtrl;
	tAHIAudioCtrl = record
		ahiac_UserData	: pointer;
        { Lots of private data follows! }
	end;

	pAHISoundMessage = ^tAHISoundMessage;
	tAHISoundMessage = record
		ahism_Channel	: word;
	end;

	pAHIRecordMessage = ^tAHIRecordMessage;
	tAHIRecordMessage = record
		ahirm_Type		: longint;	{ Format of buffer (object)			}
		ahirm_Buffer	: pointer;	{ Pointer to the sample array		}
		ahirm_Length 	: longint;	{ Number of sample frames in buffer	}
	end;

	pAHISampleInfo = ^tAHISampleInfo;
	tAHISampleInfo = record
		ahisi_Type		: longint;	{ Format of samples				}
		ahisi_Address	: pointer;	{ Address to array of samples	}
		ahisi_Length	: longint;	{ Number of samples in array	}
	end;

	pAHIAudioModeRequester = ^tAHIAudioModeRequester;
	tAHIAudioModeRequester = record
		ahiam_AudioID		: longint;		{ Selected audio mode					}
		ahiam_MixFreq		: longint;		{ Selected mixing/sampling frequency	}
        
		ahiam_LeftEdge		: word;			{ Coordinates of requester on exit		}
		ahiam_TopEdge		: word;
		ahiam_Width			: word;
		ahiam_Height		: word;

		ahiam_InfoOpened	: boolean;		{ Info window opened on exit?			}
		ahiam_InfoLeftEdge	: word;			{ Last coordinates of Info window		}
		ahiam_InfoTopEdge	: word;
		ahiam_InfoWidth		: word;
		ahiam_InfoHeight	: word;

		ahiam_UserData		: pointer;		{ You can store your own data here		}

		{ Lots of private data follows!	}
	end;

	pAHIEffMasterVolume = ^tAHIEffMasterVolume;
	tAHIEffMasterVolume = record
		ahie_Effect		: longint;		{ Set to AHIET_MASTERVOLUME	}
		ahiemv_Volume	: Fixed;		{ See autodocs for range!	}
	end;

	pAHIEffOutputBuffer = ^tAHIEffOutputBuffer;
	tAHIEffOutputBuffer = record
		ahie_Effect		: longint;		{ Set to AHIET_OUTPUTBUFFER 		}
		ahieob_Func		: pHook;
	{ These fields are filled by AHI }
		ahieob_Type		: longint;		{ Format of buffer					}
		ahieob_Buffer	: pointer;		{ Pointer to the sample array		}
		ahieob_Length	: longint;		{ Number of sample frames in buffer	}
	end;

	{ V4	}
	pAHIEffDSPMask = ^tAHIEffDSPMask;
	tAHIEffDSPMask = record
		ahie_Effect		: longint;				{ Set to AHIET_DSPMASK			}
		ahiedm_Channels	: word;					{ Number of elements in array	}
		ahiedm_Mask		: array [0..255] of byte;	{ Here follows the array		}
		{ IMPORTANT NOTE -- verify ahiedm_Channels before accessing
							the array to avoid dealing with INNOCENT memory!
		(sorry for the trick, but Pascal only permits pre-sized arrays)	}
	end;

	{ V4	}
	pAHIDSPEcho = ^tAHIDSPEcho;
	tAHIDSPEcho = record
		ahie_Effect		: longint;			{ Set to AHIET_DSPECHO	}
		ahiede_Delay	: longint;			{ In samples			}
		ahiede_Feedback	: Fixed;
		ahiede_Mix		: Fixed;
		ahiede_Cross	: Fixed;
	end;

	{ V4	}
	pAHIEffChannelInfo = ^tAHIEffChannelInfo;
	tAHIEffChannelInfo = record
		ahie_Effect			: longint;		{ Set to AHIET_CHANNELINFO	}
		ahieci_Func			: pHook;
		ahieci_Channels		: word;
		ahieci_Pad			: word;
	{ The rest is filled by AHI }
		ahieci_Offset		: array [0..255] of longint;	{ The array follows			}
		{ IMPORTANT NOTE -- verify number of channels before accessing
							the array to avoid dealing with INNOCENT memory!
		(sorry for the trick, but Pascal only permits pre-sized arrays)	}
	end;

{ DEVICE INTERFACE DEFINITIONS FOLLOWS ************************************	}

	pAHIUnitPrefs = ^tAHIUnitPrefs;
	tAHIUnitPrefs = record
		ahiup_Unit			: byte;
		ahiup_Pad			: byte;
		ahiup_Channels		: word;
		ahiup_AudioMode		: longint;
		ahiup_Frequency		: longint;
		ahiup_MonitorVolume : Fixed;
		ahiup_InputGain		: Fixed;
		ahiup_OutputVolume	: Fixed;
		ahiup_Input			: longint;
		ahiup_Output		: longint;
	end;

	pAHIGlobalPrefs = ^tAHIGlobalPrefs;
	tAHIGlobalPrefs = record
		ahigp_DebugLevel		: word;		{ Range: 0-3 (for None, Low,
														High and All)	}
		ahigp_DisableSurround	: boolean;
		ahigp_DisableEcho		: boolean;
		ahigp_FastEcho			: boolean;
		ahigp_MaxCPU			: Fixed;
		ahigp_ClipMasterVolume	: boolean;
	end;

	pAHIRequest = ^tAHIRequest;
	tAHIRequest = record
		ahir_Std		: tIOStdReq;		{ Standard IO request		}
		ahir_Version	: word;				{ Needed version			}
	{ --- New for V4, they will be ignored by V2 and earlier --- 	}
		ahir_Pad1		: word;
		ahir_Private	: array [0..1] of longint;	{ Hands off!				}
		ahir_Type		: longint;			{ Sample format				}
		ahir_Frequency	: longint;			{ Sample/Record frequency	}
		ahir_Volume		: Fixed;			{ Sample volume				}
		ahir_Position	: Fixed;			{ Stereo position			}
		ahir_Link		: pAHIRequest;		{ For double buffering		}
	end;


var
	AHIBase : pLibrary;


const
	AHIEDM_WET			= 0;
	AHIEDM_DRY			= 1;

	AHINAME				= 'ahi.device';
	AHI_INVALID_ID 		= 0;		{ (~0) Invalid Audio ID				}
	AHI_DEFAULT_ID 		= 0;		{ Only for AHI_AllocAudioA()!		}
	AHI_LOOPBACK_ID		= 1;		{ Special sample render Audio ID	}
	AHI_DEFAULT_FREQ	= 0;        { Only for AHI_AllocAudioA()!		}
	AHI_MIXFREQ			= 0;        { (~0) Special frequency for AHI_SetFreq() }
	AHI_NOSOUND			= #$0ffff;	{ Turns a channel off				}

	{ Set#? Flags }
	AHISF_IMM			= 1;
	AHISB_IMM			= 0;

	{ Effect Types }
	AHIET_CANCEL		= $80000000; { (1<<31)	{ OR with effect to disable			}
	AHIET_MASTERVOLUME  = 1;
	AHIET_OUTPUTBUFFER	= 2;
	{ --- New for V4 --- }
	AHIET_DSPMASK		= 3;
	AHIET_DSPECHO		= 4;
	AHIET_CHANNELINFO	= 5;

	{ Sound Types }
	AHIST_NOTYPE		= 0;		{ (~0) Private						}
	AHIST_SAMPLE		= 0;		{ 8 or 16 bit sample				}
	AHIST_DYNAMICSAMPLE	= 1;		{ Dynamic sample					}
	AHIST_INPUT			= $20000000; { (1<<29) The input from your sampler		}
	AHIST_BW			= $40000000; { (1<<30) Private							}

	{ Sample types }
	{ Note that only AHIST_M8S, AHIST_S8S, AHIST_M16S and AHIST_S16S
	are supported by AHI_LoadSound(). }
	AHIST_M8S			= 0;		{ Mono, 8 bit signed (BYTE)			}
	AHIST_M16S			= 1;		{ Mono, 16 bit signed (WORD)		}
	AHIST_S8S			= 2;		{ Stereo, 8 bit signed (2×BYTE)		}
	AHIST_S16S			= 3;		{ Stereo, 16 bit signed (2×WORD)	}
	AHIST_M32S			= 8;		{ Mono, 32 bit signed (LONG)		}
	AHIST_S32S			= 10;		{ Stereo, 32 bit signed (2×LONG)	}

	AHIST_M8U			= 4;		{ OBSOLETE!							}

	{ Error codes }
	AHIE_OK				= 0;		{ No error							}
	AHIE_NOMEM			= 1;		{ Out of memory						}
	AHIE_BADSOUNDTYPE	= 2;		{ Unknown sound type				}
	AHIE_BADSAMPLETYPE	= 3;		{ Unknown/unsupported sample type	}
	AHIE_ABORTED		= 4;		{ User-triggered abortion			}
	AHIE_UNKNOWN		= 5;		{ Error, but unknown				}
	AHIE_HALFDUPLEX		= 6;		{ CMD_WRITE/CMD_READ failure		}

	{ Device units }
	AHI_DEFAULT_UNIT	= 0;
	AHI_NO_UNIT			= 255;

	{ The preference file	}
	{ SORRY! these ones are not done..	}
	{ID_AHIU MAKE_ID		= ('A','H','I','U');}
	{ID_AHIG MAKE_ID		= ('A','H','I','G');}

	{ Debug levels }
	AHI_DEBUG_NONE		= 0;
	AHI_DEBUG_LOW		= 1;
	AHI_DEBUG_HIGH		= 2;
	AHI_DEBUG_ALL		= 3;

	{ Flags for OpenDevice()	}
	AHIDF_NOMODESCAN	= 1;
	AHIDB_NOMODESCAN	= 0;





{struct AHIAudioCtrl *AHI_AllocAudioA( struct TagItem * );}
function AHI_AllocAudioA (AHIPntr: pTagItem): pAHIAudioCtrl;

{struct AHIAudioCtrl *AHI_AllocAudio( Tag, ... );}

{void AHI_FreeAudio( struct AHIAudioCtrl * );}
procedure AHI_FreeAudio (AHIPntr: pAHIAudioCtrl);

{void AHI_KillAudio( void );}
{procedure AHI_KillAudio;	{ *****	}

{ULONG AHI_ControlAudioA( struct AHIAudioCtrl *, struct TagItem * );}
function AHI_ControlAudioA (AHIPntr: pAHIAudioCtrl; AHIPntr2: pTagItem): longint;

{ULONG AHI_ControlAudio( struct AHIAudioCtrl *, Tag, ... );}

{void AHI_SetVol( UWORD, Fixed, sposition, struct AHIAudioCtrl *, ULONG );}
procedure AHI_SetVol (AHIDado: word; AHIDado2: Fixed; AHIDado3: sposition;
						AHIPntr: pAHIAudioCtrl; AHIDado4: longint);

{void AHI_SetFreq( UWORD, ULONG, struct AHIAudioCtrl *, ULONG );}
procedure AHI_SetFreq (AHIDado: word; AHIDado2: longint;
						AHIPntr: pAHIAudioCtrl; AHIDado3: longint);

{void AHI_SetSound( UWORD, UWORD, ULONG, LONG, struct AHIAudioCtrl *, ULONG );}
procedure AHI_SetSound (AHIDado: word; AHIDado2: word; AHIDado3: longint;
			AHIDado4: longint; AHIPntr: pAHIAudioCtrl; AHIDado5: longint);

{ULONG AHI_SetEffect( APTR, struct AHIAudioCtrl * );}
function AHI_SetEffect (AHIPntr: pointer; AHIPntr2: pAHIAudioCtrl): longint;

{ULONG AHI_LoadSound( UWORD, ULONG, APTR, struct AHIAudioCtrl * );}
function AHI_LoadSound (AHIDado: word; AHIDado2: longint; AHIPntr: pointer;
						AHIPntr2: pAHIAudioCtrl): longint;

{void AHI_UnloadSound( UWORD, struct AHIAudioCtrl * );}
procedure AHI_UnloadSound (AHIDado: word; AHIPntr: pAHIAudioCtrl);

{ULONG AHI_NextAudioID( ULONG );}
function AHI_NextAudioID (AHIDado: longint): longint;

{BOOL AHI_GetAudioAttrsA( ULONG, struct AHIAudioCtrl *, struct TagItem * );}
function AHI_GetAudioAttrsA (AHIDado: longint; AHIPntr: pAHIAudioCtrl;
							AHIPntr2: pTagItem): boolean;

{BOOL AHI_GetAudioAttrs( ULONG, struct AHIAudioCtrl *, Tag, ... );}

{ULONG AHI_BestAudioIDA( struct TagItem * );}
function AHI_BestAudioIDA (AHIPntr: pTagItem): longint;

{ULONG AHI_BestAudioID( Tag, ... );}

{struct AHIAudioModeRequester *AHI_AllocAudioRequestA( struct TagItem * );}
function AHI_AllocAudioRequestA (AHIPntr: pTagItem): pAHIAudioModeRequester;

{struct AHIAudioModeRequester *AHI_AllocAudioRequest( Tag, ... );}

{BOOL AHI_AudioRequestA( struct AHIAudioModeRequester *, struct TagItem * );}
function AHI_AudioRequestA (AHIPntr: pAHIAudioModeRequester;
							AHIPntr2: pTagItem): boolean;

{BOOL AHI_AudioRequest( struct AHIAudioModeRequester *, Tag, ... );}

{void AHI_FreeAudioRequest( struct AHIAudioModeRequester * );}
procedure AHI_FreeAudioRequest (AHIPntr: pAHIAudioModeRequester);

{ --- New for V4 --- }
{void AHI_PlayA( struct AHIAudioCtrl *, struct TagItem * );}
procedure AHI_PlayA (AHIPntr: pAHIAudioCtrl; AHIPntr2: pTagItem);

{void AHI_Play( struct AHIAudioCtrl *, Tag, ... );}

{ULONG AHI_SampleFrameSize( ULONG );}
function AHI_SampleFrameSize (AHIDado: longint): longint;

{ULONG AHI_AddAudioMode(struct TagItem * );}
{function AHI_AddAudioMode (AHIPntr: pTagItem): longint;	{ *****	}

{ULONG AHI_RemoveAudioMode( ULONG );}
{function AHI_RemoveAudioMode (AHIDado: longint): longint;	{ *****	}

{ULONG AHI_LoadModeFile( STRPTR );}
{function AHI_LoadModeFile (AHIPntr: pointer): longint;	{ *****	}


IMPLEMENTATION

function AHI_AllocAudioA; xassembler;
{ (AHIPntr: pTagItem): pAHIAudioCtrl;}
asm
	move.l	a6,-(sp)

	{ 1	}
	move.l	$8(sp),a1

	{ 1	}
	lea		$8(sp),a6
	move.l	(a6)+,d1
	move.l	(a6)+,d0
	move.l	(a6)+,a0

	move.l	AHIBase,a6
	jsr		-$2a(a6)	{ ALTERAR	}

	{ 2 - se procedure, RETIRAR	}
	{     se function, ALTERAR conforme número de operandos	}
	move.l	d0,$C(sp)

	move.l	(sp)+,a6
end;

procedure AHI_FreeAudio; xassembler;
{ (AHIPntr: pAHIAudioCtrl);}
asm
	move.l	a6,-(sp)
	move.l	$8(sp),a2
	move.l	AHIBase,a6
	jsr		-$30(a6)
	move.l	(sp)+,a6
end;

function AHI_ControlAudioA; xassembler;
{ (AHIPntr: pAHIAudioCtrl; AHIPntr2: pTagItem): longint;}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a2
	move.l	AHIBase,a6
	jsr		-$3c(a6)
	move.l	d0,$10(sp)
	move.l	(sp)+,a6
end;

procedure AHI_SetVol; xassembler;
{ (AHIDado: word; AHIDado2: Fixed; AHIDado3: sposition; AHIPntr: pAHIAudioCtrl; AHIDado4: longint);}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,d3
	move.l	(a6)+,a2
	move.l	(a6)+,d2
	move.l	(a6)+,d1
	move.w	(a6)+,d0
	move.l	AHIBase,a6
	jsr		-$42(a6)
	move.l	(sp)+,a6
end;

procedure AHI_SetFreq; xassembler;
{ (AHIDado: word; AHIDado2: longint; AHIPntr: pAHIAudioCtrl; AHIDado3: longint);}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,d2
	move.l	(a6)+,a2
	move.l	(a6)+,d1
	move.w	(a6)+,d0
	move.l	AHIBase,a6
	jsr		-$48(a6)
	move.l	(sp)+,a6
end;

procedure AHI_SetSound; xassembler;
{ (AHIDado: word; AHIDado2: word; AHIDado3: longint; AHIDado4: longint; AHIPntr: pAHIAudioCtrl; AHIDado5: longint);}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,d4
	move.l	(a6)+,a2
	move.l	(a6)+,d3
	move.l	(a6)+,d2
	move.w	(a6)+,d1
	move.w	(a6)+,d0
	move.l	AHIBase,a6
	jsr		-$4e(a6)
	move.l	(sp)+,a6
end;

function AHI_SetEffect; xassembler;
{ (AHIPntr: pointer; AHIPntr2: pAHIAudioCtrl): longint;}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a2
	move.l	(a6)+,a0
	move.l	AHIBase,a6
	jsr		-$54(a6)
	move.l	d0,$10(sp)
	move.l	(sp)+,a6
end;

function AHI_LoadSound; xassembler;
{ (AHIDado: word; AHIDado2: longint; AHIPntr: pointer; AHIPntr2: pAHIAudioCtrl): longint;}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a2
	move.l	(a6)+,a0
	move.l	(a6)+,d1
	move.w	(a6)+,d0
	move.l	AHIBase,a6
	jsr		-$5a(a6)
	move.l	d0,$16(sp)
	move.l	(sp)+,a6
end;

procedure AHI_UnloadSound; xassembler;
{ (AHIDado: word; AHIPntr: pAHIAudioCtrl);}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a2
	move.w	(a6)+,d0
	move.l	AHIBase,a6
	jsr		-$60(a6)
	move.l	(sp)+,a6
end;

function AHI_NextAudioID; xassembler;
{ (AHIDado: longint): longint;}
asm
	move.l	a6,-(sp)
	move.l	$8(sp),d0
	move.l	AHIBase,a6
	jsr		-$66(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function AHI_GetAudioAttrsA; xassembler;
{ (AHIDado: longint; AHIPntr: pAHIAudioCtrl; AHIPntr2: pTagItem): boolean;}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a2
	move.l	(a6)+,d0
	move.l	AHIBase,a6
	jsr		-$6c(a6)
	move.b	d0,$14(sp)	{ since it's boolean..	}
	move.l	(sp)+,a6
end;

function AHI_BestAudioIDA; xassembler;
{ (AHIPntr: pTagItem): longint;}
asm
	move.l	a6,-(sp)
	move.l	$8(sp),a1
	move.l	AHIBase,a6
	jsr		-$72(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function AHI_AllocAudioRequestA; xassembler;
{ (AHIPntr: pTagItem): pAHIAudioModeRequester;}
asm
	move.l	a6,-(sp)
	move.l	$8(sp),a0
	move.l	AHIBase,a6
	jsr		-$78(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;

function AHI_AudioRequestA; xassembler;
{ (AHIPntr: pAHIAudioModeRequester; AHIPntr2: pTagItem): boolean;}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a0
	move.l	AHIBase,a6
	jsr		-$7e(a6)
	move.b	d0,$10(sp)	{ since it's boolean..	}
	move.l	(sp)+,a6
end;

procedure AHI_FreeAudioRequest; xassembler;
{ (AHIPntr: pAHIAudioModeRequester);}
asm
	move.l	a6,-(sp)
	move.l	$8(sp),a0
	move.l	AHIBase,a6
	jsr		-$84(a6)
	move.l	(sp)+,a6
end;

{ --- New for V4 --- }

procedure AHI_PlayA; xassembler;
{ (AHIPntr: pAHIAudioCtrl; AHIPntr2: pTagItem);}
asm
	move.l	a6,-(sp)
	lea		$8(sp),a6
	move.l	(a6)+,a1
	move.l	(a6)+,a2
	move.l	AHIBase,a6
	jsr		-$8a(a6)
	move.l	(sp)+,a6
end;

function AHI_SampleFrameSize; xassembler;
{ (AHIDado: longint): longint;}
asm
	move.l	a6,-(sp)
	move.l	$8(sp),d0
	move.l	AHIBase,a6
	jsr		-$90(a6)
	move.l	d0,$C(sp)
	move.l	(sp)+,a6
end;


end.
