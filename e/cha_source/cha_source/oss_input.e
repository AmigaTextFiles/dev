/*==========================================================================+
| oss_input.e                                                               |
| input buffer to read from OSS sample space                                |
+--------------------------------------------------------------------------*/

OPT PREPROCESS
OPT MODULE

MODULE '*inputbuffer', '*oss', '*oss_sample', '*word', '*debug'

/*-------------------------------------------------------------------------*/

EXPORT OBJECT oss_input OF inputbuffer
PUBLIC
	info : PTR TO oss_sample
PRIVATE
	rptr : LONG   -> current index
ENDOBJECT

PROC oss_input(sample) OF oss_input HANDLE
	self.inputbuffer()
	NEW self.info.oss_sample(sample)
	IF self.info.channels <> 1 THEN Throw("oss", 'only mono supported')
	IF (self.info.type <> SAMPLETYPE_SAMPLE8) AND
	   (self.info.type <> SAMPLETYPE_SAMPLE16)
		Throw("oss", 'only 8/16 bit samples supported')
	ENDIF
EXCEPT
	self.end()
	ReThrow()
ENDPROC

PROC end() OF oss_input
	END self.info
ENDPROC SUPER self.end()

PROC read() OF oss_input
	DEF x = 0.0, byteptr : PTR TO CHAR, wordptr : PTR TO INT
	IF self.rptr < self.info.length
		IF     self.info.bits =  8
			byteptr := self.info.data
			x := sbyte2f(sbyte(byteptr[self.rptr]))
		ELSE
		->ELSEIF self.info.bits = 16
			wordptr := self.info.data
			x := sword2f(sword(wordptr[self.rptr]))
		ENDIF
		self.rptr := self.rptr + 1
	ENDIF
	debug(['read = \d', ! x * 100.0 !])
ENDPROC x

/*--------------------------------------------------------------------------+
| END: oss_input.e                                                          |
+==========================================================================*/
