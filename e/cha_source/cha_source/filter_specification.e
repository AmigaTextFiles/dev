/*==========================================================================+
| filter_specification.e                                                    |
| various filters for OctaMED SoundStudio                                   |
|                                                                           |
| get filter specification into a structure, via CLI currently              |
|                                                                           |
| Based on mkfilter/mkshape/genplot:                                        |
|   A. J. Fisher                                                            |
|   fisher@minster.york.ac.uk                                               |
+--------------------------------------------------------------------------*/

OPT MODULE, PREPROCESS, OSVERSION=37

MODULE '*args'

RAISE "ARGS" IF ReadArgs() = NIL,
      "MEM"  IF New() = NIL

EXPORT ENUM FILTERTYPE_UNKNOWN,
            FILTERTYPE_BUTTERWORTH,
            FILTERTYPE_CHEBYSHEV,
            FILTERTYPE_BESSEL,
            FILTERTYPE_RESONATOR

EXPORT ENUM FILTERMODE_UNKNOWN,
            FILTERMODE_BILINEAR,
            FILTERMODE_MATCHEDZ

EXPORT ENUM FILTERSHAPE_UNKNOWN,
            FILTERSHAPE_LOWPASS,
            FILTERSHAPE_HIGHPASS,
            FILTERSHAPE_BANDPASS,
            FILTERSHAPE_BANDSTOP,
            FILTERSHAPE_ALLPASS,
            FILTERSHAPE_NOTCH

EXPORT CONST RATE_UNKNOWN = $49742400   -> 1000000.0

EXPORT OBJECT filterspecification
PUBLIC
	from    : LONG
	to      : LONG
	rate    : LONG
	volume  : LONG
	type    : LONG
	mode    : LONG
	shape   : LONG
	freq    : LONG
	lfreq   : LONG
	hfreq   : LONG
	ripple  : LONG
	order   : LONG
	qfactor : LONG
PRIVATE
	-> cli
	args    : PTR TO LONG
	rdargs  : LONG
	-> gui
ENDOBJECT

ENUM ARG_FROM,
     ARG_TO,
     ARG_RATE,
     ARG_VOLUME,
     ARG_BW,
     ARG_CH,
     ARG_BE,
     ARG_RES,
     ARG_HP,
     ARG_LP,
     ARG_BP,
     ARG_BS,
     ARG_AP,
     ARG_NOTCH,
     ARG_BLT,
     ARG_MZT,
     ARG_O,
     ARG_R,
     ARG_F,
     ARG_LF,
     ARG_HF,
     ARG_Q,
     ARGCOUNT

#define arg_int(index)    _arg_int(self.args,index,'index'+4)
#define arg_float(index)  _arg_float(self.args,index,'index'+4)
#define arg_switch(index) _arg_switch(self.args,index,'index'+4)

ENUM ERR_NONE,
     ERR_FROM,
     ERR_TO,
     ERR_RATE,
     ERR_TYPE,
     ERR_MODE_NO,
     ERR_MODE_YES,
     ERR_SHAPE_HP,
     ERR_SHAPE_LP,
     ERR_SHAPE_BS,
     ERR_SHAPE_AP,
     ERR_SHAPE_NOTCH,
     ERR_SHAPE_S,
     ERR_SHAPE_R,
     ERR_FREQ_NO,
     ERR_FREQ_YES,
     ERR_FREQ_RANGE,
     ERR_LFREQ_NO,
     ERR_LFREQ_YES,
     ERR_LFREQ_RANGE,
     ERR_HFREQ_NO,
     ERR_HFREQ_YES,
     ERR_HFREQ_RANGE,
     ERR_O_NO,
     ERR_O_YES,
     ERR_O_RANGE,
     ERR_R_NO,
     ERR_R_YES,
     ERR_R_RANGE,
     ERR_Q_NO,
     ERR_Q_YES,
     ERR_Q_RANGE,
     ERR_COUNT

PROC cli() OF filterspecification HANDLE

	DEF x, ok, splaneflag, args : PTR TO LONG

	self.end()

	self.args := New(SIZEOF LONG * ARGCOUNT)
	self.rdargs := ReadArgs(
	    'FROM/A,TO/A,SR=RATE/K,V=VOLUME/K,BW=BUTTERWORTH/S,CH=CHEBYSHEV/S,'
	   +'BE=BESSEL/S,RES=RESONATOR/S,HP=HIGHPASS/S,LP=LOWPASS/S,'
	   +'BP=BANDPASS/S,BS=BANDSTOP/S,AP=ALLPASS/S,NOTCH/S,BLT=BILINEAR/S,'
	   +'MZT=MATCHEDZ/S,O=ORDER/K,R=RIPPLE/K,F=FREQUENCY/K,'
	   +'LF=LOWFREQUENCY/K,HF=HIGHFREQUENCY/K,Q=QFACTOR/K',
	                         self.args, NIL)

	args := self.args

	self.from := ossinumarg(ARG_FROM) ->arg_int(ARG_FROM)
	IF (1 > self.from) OR (self.from > 63) THEN Throw("args", ERR_FROM)

	self.to   := ossinumarg(ARG_TO)
	IF (1 > self.to) OR (self.to > 63) THEN Throw("args", ERR_TO)

	x, ok := arg_float(ARG_RATE)
	self.rate := x
	IF ok = FALSE THEN self.rate := RATE_UNKNOWN ELSE IF ! self.rate <= 0.0 THEN Throw("args", ERR_RATE)

	x, ok := arg_float(ARG_VOLUME)
	self.volume := x
	IF ok = FALSE THEN self.volume := 1.0

	self.type := FILTERTYPE_UNKNOWN
	IF arg_switch(ARG_BW)
		IF self.type <> FILTERTYPE_UNKNOWN THEN Throw("args", ERR_TYPE)
		self.type := FILTERTYPE_BUTTERWORTH
	ENDIF
	IF arg_switch(ARG_CH) AND (self.type = FILTERTYPE_UNKNOWN)
		IF self.type <> FILTERTYPE_UNKNOWN THEN Throw("args", ERR_TYPE)
		self.type := FILTERTYPE_CHEBYSHEV
	ENDIF
	IF arg_switch(ARG_BE) AND (self.type = FILTERTYPE_UNKNOWN)
		IF self.type <> FILTERTYPE_UNKNOWN THEN Throw("args", ERR_TYPE)
		self.type := FILTERTYPE_BESSEL
	ENDIF
	IF arg_switch(ARG_RES) AND (self.type = FILTERTYPE_UNKNOWN)
		IF self.type <> FILTERTYPE_UNKNOWN THEN Throw("args", ERR_TYPE)
		self.type := FILTERTYPE_RESONATOR
	ENDIF
	IF self.type = FILTERTYPE_UNKNOWN THEN Throw("args", ERR_TYPE)
	splaneflag := (self.type <> FILTERTYPE_RESONATOR)

	self.mode := FILTERMODE_UNKNOWN
	IF arg_switch(ARG_BLT)
		IF splaneflag = FALSE THEN Throw("args", ERR_MODE_NO)
		IF self.mode <> FILTERMODE_UNKNOWN THEN Throw("args", ERR_MODE_YES)
		self.mode := FILTERMODE_BILINEAR
	ENDIF
	IF arg_switch(ARG_MZT)
		IF splaneflag = FALSE THEN Throw("args", ERR_MODE_NO)
		IF self.mode <> FILTERMODE_UNKNOWN THEN Throw("args", ERR_MODE_YES)
		self.mode := FILTERMODE_MATCHEDZ
	ENDIF
	IF splaneflag THEN IF self.mode = FILTERMODE_UNKNOWN THEN Throw("args", ERR_MODE_YES)

	self.shape := FILTERSHAPE_UNKNOWN
	IF arg_switch(ARG_HP)
		IF splaneflag = FALSE THEN Throw("args", ERR_SHAPE_HP)
		IF self.shape <> FILTERSHAPE_UNKNOWN THEN Throw("args", ERR_SHAPE_S)
		self.shape := FILTERSHAPE_HIGHPASS
	ENDIF
	IF arg_switch(ARG_LP)
		IF splaneflag = FALSE THEN Throw("args", ERR_SHAPE_LP)
		IF self.shape <> FILTERSHAPE_UNKNOWN THEN Throw("args", ERR_SHAPE_S)
		self.shape := FILTERSHAPE_LOWPASS
	ENDIF
	IF arg_switch(ARG_BS)
		IF splaneflag = FALSE THEN Throw("args", ERR_SHAPE_BS)
		IF self.shape <> FILTERSHAPE_UNKNOWN THEN Throw("args", ERR_SHAPE_S)
		self.shape := FILTERSHAPE_BANDSTOP
	ENDIF
	IF arg_switch(ARG_BP)
		IF self.shape <> FILTERSHAPE_UNKNOWN THEN Throw("args", IF splaneflag THEN ERR_SHAPE_S ELSE ERR_SHAPE_R)
		self.shape := FILTERSHAPE_BANDPASS
	ENDIF
	IF arg_switch(ARG_AP)
		IF splaneflag THEN Throw("args", ERR_SHAPE_AP)
		IF self.shape <> FILTERSHAPE_UNKNOWN THEN Throw("args", ERR_SHAPE_R)
		self.shape := FILTERSHAPE_ALLPASS
	ENDIF
	IF arg_switch(ARG_NOTCH)
		IF splaneflag THEN Throw("args", ERR_SHAPE_NOTCH)
		IF self.shape <> FILTERSHAPE_UNKNOWN THEN Throw("args", ERR_SHAPE_R)
		self.shape := FILTERSHAPE_NOTCH
	ENDIF
	IF self.shape = FILTERSHAPE_UNKNOWN THEN Throw("args", IF splaneflag THEN ERR_SHAPE_S ELSE ERR_SHAPE_R)

	x, ok := arg_float(ARG_F)
	self.freq := x
	IF ok AND splaneflag AND (self.shape = FILTERSHAPE_BANDPASS) THEN Throw("args", ERR_FREQ_NO)
	IF (! 0.0 > self.freq) OR (! self.freq > (! self.rate / 2.0)) THEN Throw("args", ERR_FREQ_RANGE)
	IF (ok = FALSE) AND ((splaneflag = FALSE) OR (self.shape <> FILTERSHAPE_BANDPASS)) THEN Throw("args", ERR_FREQ_YES)
	x, ok := arg_float(ARG_LF)
	self.lfreq := x
	IF ok AND (IF splaneflag THEN (self.shape <> FILTERSHAPE_BANDPASS) ELSE TRUE) THEN Throw("args", ERR_LFREQ_NO)
	IF (ok = FALSE) AND splaneflag AND (self.shape = FILTERSHAPE_BANDPASS) THEN Throw("args", ERR_LFREQ_YES)
	IF (! 0.0 > self.lfreq) OR (! self.lfreq > (! self.rate / 2.0)) THEN Throw("args", ERR_LFREQ_RANGE)
	x, ok := arg_float(ARG_HF)
	self.hfreq := x
	IF ok AND (IF splaneflag THEN (self.shape <> FILTERSHAPE_BANDPASS) ELSE TRUE) THEN Throw("args", ERR_HFREQ_NO)
	IF (ok = FALSE) AND splaneflag AND (self.shape = FILTERSHAPE_BANDPASS) THEN Throw("args", ERR_HFREQ_YES)
	IF (! self.lfreq > self.hfreq) OR (! self.hfreq > (! self.rate / 2.0)) THEN Throw("args", ERR_HFREQ_RANGE)

	x, ok := arg_int(ARG_O)
	self.order := x
	IF splaneflag AND (ok = FALSE) THEN Throw("args", ERR_O_YES)
	IF ok AND (splaneflag = FALSE) THEN Throw("args", ERR_O_NO)
	IF splaneflag AND ((1 > self.order) OR (self.order > 16)) THEN Throw("args", ERR_O_RANGE)

	x, ok := arg_float(ARG_R)
	self.ripple := x
	IF self.type = FILTERTYPE_CHEBYSHEV
		IF ok
			IF (! 0.0 <= self.ripple) THEN Throw("args", ERR_R_RANGE)
		ELSE
			Throw("args", ERR_R_YES)
		ENDIF
	ELSE
		IF ok THEN Throw("args", ERR_R_NO)
	ENDIF

	x, ok := arg_float(ARG_Q)
	self.qfactor := x
	IF self.type = FILTERTYPE_RESONATOR
		IF ok
			IF (! 0.0 >= self.qfactor) THEN Throw("args", ERR_Q_RANGE)
		ELSE
			Throw("args", ERR_Q_YES)
		ENDIF
	ELSE
		IF ok THEN Throw("args", ERR_Q_NO)
	ENDIF

EXCEPT

	IF exception
		self.end()
		IF exception = "args"
			IF (ERR_NONE < exceptioninfo) AND (exceptioninfo < ERR_COUNT)
				exceptioninfo := ListItem([
'FROM must be in the range 1..63',
'TO must be in the range 1..63',
'RATE must be greater than 0',
'exactly one of BUTTERWORTH, CHEBYSHEV, BESSEL or RESONATOR must be specified',
'BILINEAR or MATCHEDZ must not be specified for this filter type',
'either BILINEAR or MATCHEDZ must be specified for s-plane filters',
'HIGHPASS must not be specified for this filter type',
'LOWPASS must not be specified for this filter type',
'BANDSTOP must not be specified for this filter type',
'ALLPASS must not be specified for this filter type',
'NOTCH must not be specified for this filter type',
'exactly one of HIGHPASS, LOWPASS, BANDPASS or BANDSTOP must be specified for this filter type',
'exactly one of BANDPASS, ALLPASS or NOTCH must be specified for this filter type',
'FREQUENCY must not be specified for this filter type and shape',
'FREQUENCY must be specified for this filter type',
'FREQUENCY must be in the range 0..RATE/2',
'LOWFREQUENCY must not be specified for this filter type and shape',
'LOWFREQUENCY must be specified for this filter type',
'LOWFREQUENCY must be in the range 0..RATE/2',
'HIGHFREQUENCY must not be specified for this filter type and shape',
'HIGHFREQUENCY must be specified for this filter type',
'HIGHFREQUENCY must be in the range 0..RATE/2',
'ORDER must not be specified for this filter type',
'ORDER must be specified for this filter type',
'ORDER must be in the range 1..16',
'RIPPLE must not be specified for this filter type',
'RIPPLE must be specified for this filter type',
'RIPPLE must be less than 0',
'QFACTOR must not be specified for this filter type',
'QFACTOR must be specified for this filter type',
'QFACTOR must be greater than 0'
				        ], exceptioninfo-1)
			ELSE
				Throw("bug", 'filterspecification.cli."args"')
			ENDIF
		ENDIF
	ENDIF

	ReThrow()

ENDPROC

PROC end() OF filterspecification
	IF self.rdargs
		FreeArgs(self.rdargs)
		self.rdargs := NIL
	ENDIF
	IF self.args
		Dispose(self.args)
		self.args := NIL
	ENDIF
ENDPROC

PROC _arg_int(args : PTR TO LONG, index, sid)
	DEF x, l, s
	s := args[index]
	x, l := Val(s)
	IF l <> StrLen(s) THEN Throw("IARG", sid)
ENDPROC x, l <> 0

PROC _arg_float(args : PTR TO LONG, index, sid)
	DEF x, l, s
	s := args[index]
	x, l := RealVal(s)
	IF l <> StrLen(s) THEN Throw("FARG", sid)
ENDPROC x, l <> 0

PROC _arg_switch(args : PTR TO LONG, index, sid) IS args[index], TRUE

/*--------------------------------------------------------------------------+
| END: filter_specification.e                                               |
+==========================================================================*/
