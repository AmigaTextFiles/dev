/*==========================================================================+
| oss_output.e                                                              |
| output buffer to write to OSS sample space                                |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

MODULE '*outputbuffer', '*oss', '*oss_sample', '*word', '*debug'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT oss_output OF outputbuffer
PUBLIC
	info   : PTR TO oss_sample
PRIVATE
	volume : LONG   -> output scaling factor
	wptr   : LONG   -> current index
ENDOBJECT

->                             = 1.0
PROC oss_output(sample, volume = $3F800000) OF oss_output HANDLE
	self.outputbuffer()
	NEW self.info.oss_sample(sample)
	IF self.info.channels <> 1 THEN Throw("oss", 'only mono supported')
	IF (self.info.type <> SAMPLETYPE_SAMPLE8) AND
	   (self.info.type <> SAMPLETYPE_SAMPLE16)
		Throw("oss", 'only 8/16 bit samples supported')
	ENDIF
	self.volume := volume
EXCEPT
	self.end()
	ReThrow()
ENDPROC

PROC end() OF oss_output
	END self.info
ENDPROC SUPER self.end()

PROC write(float) OF oss_output
	DEF byteptr : PTR TO CHAR, wordptr : PTR TO INT
	debug(['write = \d (\z\h[8])', ! float * 100.0 !, float])
	IF self.wptr < self.info.length
		IF     self.info.bits =  8
			byteptr := self.info.data
			byteptr[self.wptr] := f2sbyte(! float * self.volume)
		ELSE
		->ELSEIF self.bits = 16
			wordptr := self.info.data
			wordptr[self.wptr] := f2sword(! float * self.volume)
		ENDIF
		self.wptr := self.wptr + 1
		RETURN TRUE
	ELSE
		RETURN FALSE
	ENDIF
ENDPROC

/*--------------------------------------------------------------------------+
| END: oss_output.e                                                         |
+==========================================================================*/
