	IFND SOUND_SOUND_I
SOUND_SOUND_I  SET  1

**
**	$VER: sound.i V1.4
**
**	Sound Definitions.
**
**	(C) Copyright 1996-1998 DreamWorld Productions.
**	    All Rights Reserved
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

*****************************************************************************
* Module definitions.

SND_ModVersion  = 1
SND_ModRevision = 4

*****************************************************************************
* Sound object.

VER_SOUND  =	1
TAGS_SOUND =	(ID_SPCTAGS<<16)|ID_SOUND

   STRUCTURE	SND,HEAD_SIZEOF
	WORD	SND_emp          ;
	WORD	SND_Priority     ;Priority.
	APTR	SND_Data         ;Address of sample data.
	LONG	SND_Length       ;Length of sample data in bytes.
	WORD	SND_Octave       ;Octave/Note setting.
	WORD	SND_Volume       ;Volume of sample (1 - 100).
	LONG	SND_Attrib       ;Sound attributes.
	APTR	SND_Source       ;Where the sound comes from.
	LONG	SND_Frequency    ;Frequency of sampled sound.
	APTR	SND_Pair         ;Pair a sound for modulation.

        *** Private fields start now ***

	APTR	SNDP_Header      ;Sample info header, if any.
	BYTE	SNDP_AFlags      ;Private.
	BYTE	SNDP_Pad         ;Private.
	WORD	SNDP_LastChannel ;Last channel to play through.

* Sound Tags.

SA_Priority  = (TWORD|SND_Priority)
SA_Data      = (TLONG|SND_Data)
SA_Length    = (TLONG|SND_Length)
SA_Octave    = (TWORD|SND_Octave)
SA_Volume    = (TWORD|SND_Volume)
SA_Attrib    = (TLONG|SND_Attrib)
SA_Source    = (TLONG|SND_Source)
SA_Frequency = (TLONG|SND_Frequency)
SA_Pair      = (TAPTR|SND_Pair)

*** Flags for SND_Attrib.

SDB_SBIT16   = 0
SDB_MODVOL   = 1
SDB_MODPER   = 2
SDB_REPEAT   = 3
SDB_EMPTY    = 4
SDB_LEFT     = 5
SDB_RIGHT    = 6
SDB_FORCE    = 7
SDB_STOPLAST = 8

;SDF_BIT8     = 0               ;Sound data is 8 bit.
;SDF_BIT16    = 1<<SDB_SBIT16   ;Sound data is 16 bit.
SDF_MODVOL   = 1<<SDB_MODVOL    ;Modulate volume with next channel.
SDF_MODPER   = 1<<SDB_MODPER    ;Modulate period with next channel.
SDF_REPEAT   = 1<<SDB_REPEAT    ;Repeat sample forever.
SDF_EMPTY    = 1<<SDB_EMPTY     ;Only play if a channel is empty.
SDF_LEFT     = 1<<SDB_LEFT      ;Preferably play through left speaker.
SDF_RIGHT    = 1<<SDB_RIGHT     ;Preferably play through right speaker.
SDF_FORCE    = 1<<SDB_FORCE     ;Only play through selected speaker.
SDF_STOPLAST = 1<<SDB_STOPLAST  ;Only play through specified channel.

*****************************************************************************
* Octave definitions for SND_Octave.  An 'S' at the end of an octave
* definition indicates a sharp note.  The comments on the right tell
* you the period resulting from the octant used.  This is good if
* you are converting an old program that programmed the periods
* directly.

OCT_G0S	=  0	;068
OCT_G0	=  2	;072
OCT_F0S	=  4	;076
OCT_F0	=  6	;080
OCT_E0	=  8	;085
OCT_D0S	=  10	;090
OCT_D0	=  12	;095
OCT_C0S	=  14	;101
OCT_C0  =  16	;107
OCT_B0	=  18	;113
OCT_A0S	=  20	;120
OCT_A0	=  22	;127

OCT_G1S	=  24	;135
OCT_G1	=  26	;143
OCT_F1S	=  28	;151
OCT_F1	=  30	;160
OCT_E1	=  32	;170
OCT_D1S	=  34	;180
OCT_D1	=  36	;190
OCT_C1S	=  38	;202
OCT_C1	=  40	;214
OCT_B1	=  42	;226
OCT_A1S	=  44	;240
OCT_A1	=  46	;254

OCT_G2S	=  48	;269
OCT_G2	=  50	;285
OCT_F2S	=  52	;302
OCT_F2	=  54	;320
OCT_E2	=  56	;339
OCT_D2S	=  58	;360
OCT_D2	=  60	;381
OCT_C2S	=  62	;404
OCT_C2	=  64	;428
OCT_B2	=  66	;453
OCT_A2S	=  68	;480
OCT_A2	=  70	;508

OCT_G3S	=  72	;538
OCT_G3	=  74	;570
OCT_F3S	=  76	;604
OCT_F3	=  78	;640
OCT_E3	=  80	;678
OCT_D3S	=  82	;720
OCT_D3	=  84	;762
OCT_C3S	=  86	;808
OCT_C3	=  88	;856
OCT_B3	=  90	;906
OCT_A3S	=  92	;960
OCT_A3	=  94	;1016

OCT_G4S =  96	;1076
OCT_G4  =  98	;1140
OCT_F4S =  100	;1208
OCT_F4  =  102	;1280
OCT_E4  =  104	;1356
OCT_D4S =  106	;1440
OCT_D4  =  108	;1524
OCT_C4S =  110	;1616
OCT_C4  =  112	;1712
OCT_B4  =  114	;1812
OCT_A4S =  116	;1920
OCT_A4  =  118	;2032

OCT_G5S =  120	;2152
OCT_G5  =  122	;2280
OCT_F5S =  124	;2416
OCT_F5  =  126	;2560
OCT_E5  =  128	;2712
OCT_D5S =  130	;2880
OCT_D5  =  132	;3048
OCT_C5S =  134	;3232
OCT_C5  =  136	;3424
OCT_B5  =  138	;3624
OCT_A5S =  140	;3840
OCT_A5  =  142	;4064

OCT_G6S =  144	;4304
OCT_G6  =  146	;4560
OCT_F6S =  148	;4832
OCT_F6  =  150	;5120
OCT_E6  =  152	;5424
OCT_D6S =  154	;5760
OCT_D6  =  156	;6096
OCT_C6S =  158	;6464
OCT_C6  =  160	;6848
OCT_B6  =  162	;7248
OCT_A6S =  164	;7680
OCT_A6  =  166	;8128

OCT_G7S =  168	;8608
OCT_G7  =  170	;9120
OCT_F7S =  172	;9664
OCT_F7  =  174	;10240
OCT_E7  =  176	;10848
OCT_D7S =  178	;11520
OCT_D7  =  180	;12192
OCT_C7S =  182	;12928
OCT_C7  =  184	;13696
OCT_B7  =  186	;14496
OCT_A7S =  188	;15360

	ENDC	;SOUND_SOUND_I
