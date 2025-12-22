/*==========================================================================+
| oss_sample.e                                                              |
| get info about an OSS sample                                              |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

MODULE '*oss', '*calcs', '*debug', 'utility', 'utility/tagitem'

/*-------------------------------------------------------------------------*/

EXPORT ENUM OSS_SA_SAMPLE = TAG_USER,
            OSS_SA_TYPE,
            OSS_SA_CHANNELS,
            OSS_SA_BITS,
            OSS_SA_LENGTH,
            OSS_SA_NOTE,
            OSS_SA_FINETUNE,
            OSS_SA_TRANSPOSE,
            OSS_SA_RATE,
            OSS_SA_DATA,
            SAMPLETYPE_EMPTY = 0,
            SAMPLETYPE_SAMPLE8,
            SAMPLETYPE_SAMPLE16,
            SAMPLETYPE_UNKNOWN,
            CHANNELS_MONO = 1,
            CHANNELS_STEREO,
            BITS_8 = 8,
            BITS_16 = 16,
            NOTE_C_3 = 25

/*-------------------------------------------------------------------------*/

EXPORT OBJECT oss_sample
PUBLIC
	sample    : LONG   -> octamed sample number (1 .. 63)
	type      : LONG   -> SAMPLETYPE_#?
	-> following only for samples
	channels  : LONG   -> 1 or 2
	bits      : LONG   -> 8 or 16
	length    : LONG   -> length of sample (in samples)
	note      : LONG   -> note number
	finetune  : LONG   -> finetune
	transpose : LONG   -> transpose
	rate      : LONG   -> sample rate
	-> following only for mono samples
	data      : LONG   -> sample data (either SBYTES or SWORDS)
ENDOBJECT

PROC oss_sample(sample) OF oss_sample
	DEF type
	IF (1 <= sample) AND (sample <= 63)
		self.sample := sample
		oss('in_select \d', sample)
		self.channels := IF ossv('in_isstereo') THEN CHANNELS_STEREO ELSE CHANNELS_MONO
		type := oss('in_gettype')
		IF     StrCmp('EMPTY', type)
			self.type := SAMPLETYPE_EMPTY
		ELSEIF StrCmp('SAMPLE', type)
			self.type := SAMPLETYPE_SAMPLE8
			self.bits := BITS_8
			IF self.channels = CHANNELS_MONO THEN self.data := oss_samplebase(sample)
		ELSEIF StrCmp('SAMPLE16', type)
			self.type := SAMPLETYPE_SAMPLE16
			self.bits := BITS_16
			IF self.channels = CHANNELS_MONO THEN self.data := oss_samplebase(sample)
		ELSE
			self.type := SAMPLETYPE_UNKNOWN
		ENDIF
		self.length := ossv('sa_getsamplelength')
		self.note      := ossv('in_getdefaultpitch')
		IF self.note = 0 THEN self.note := NOTE_C_3
		self.finetune  := ossv('in_getfinetune')
		self.transpose := ossv('in_gettranspose')
		self.rate := oss_Period2Frequency(type := oss_NoteFinetune2Period(
		                        self.note + self.transpose, self.finetune))
		debug(['oss_input.sample = \d[8]',   self.sample])
		debug(['oss_input.bits   = \d[8]',   self.bits  ])
		debug(['oss_input.length = \d[8]',   self.length])
		debug(['oss_input.data   = \z\h[8]', self.data  ])
	ELSE
		Throw("oss", 'sample number out of range')
	ENDIF
ENDPROC

PROC end() OF oss_sample IS EMPTY

/*--------------------------------------------------------------------------+
| END: oss_sample.e                                                         |
+==========================================================================*/
