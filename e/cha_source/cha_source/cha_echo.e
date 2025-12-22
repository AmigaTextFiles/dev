/*==========================================================================+
| cha_echo.e                                                                |
| better echo effect for OctaMED SoundStudio                                |
| not much error checking, Fabs() is used to ensure >= 0 instead of failing |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37, PREPROCESS

MODULE '*oss', '*calcs', '*oss_input', '*oss_output', '*oss_sample',
       '*fxecho', '*args', '*errors'

RAISE "ARGS" IF ReadArgs() = NIL,
      "^C"   IF CtrlC() <> FALSE,
      "MEM"  IF New() = NIL

/*-------------------------------------------------------------------------*/

ENUM ARG_FROM,
     ARG_TO,
     ARG_DELAY,
     ARG_DECAY,
     ARG_REVERB,
     ARG_FREQ,
     ARG_RATE,
     ARG_VOLUME,
     ARGCOUNT

PROC main() HANDLE

	DEF in     = NIL : PTR TO oss_input,
	    out    = NIL : PTR TO oss_output,
	    echo   = NIL : PTR TO echo,
	    args   = NIL : PTR TO LONG,
	    rdargs = NIL, i, count = 0, length,
	    from, to, delay, decay, reverb, freq, rate, volume

	-> set up
	oss_init()

	-> parse args
	args := New(Mul(ARGCOUNT, SIZEOF LONG))
	rdargs := ReadArgs('FROM/A,TO/A,DELAY/K,DECAY/K,REVERB/K,'
	                 + 'FREQ=FREQUENCY/K,RATE/K,VOLUME/K', args, NIL)
	from   := ossinumarg(ARG_FROM)
	to     := ossinumarg(ARG_TO)
	delay  := fargd(ARG_DELAY,  0)
	decay  := fargd(ARG_DECAY,  0)
	reverb := fargd(ARG_REVERB, 0)
	freq   := fargd(ARG_FREQ,   0)
	rate   := fargd(ARG_RATE,   0)
	volume := fargd(ARG_VOLUME, 1)

	FOR i := ARG_DELAY TO ARG_REVERB DO IF args[i] THEN count++
	IF (count = 2) AND (freq = 0)
		-> ok
	ELSEIF (count = 1) AND (delay = 0) AND (freq <> 0)
		delay := ! 1.0 / freq
	ELSE
		argerror('exactly 2 of DELAY or FREQUENCY, DECAY and REVERB must be specified')
	ENDIF

	NEW in.oss_input(from)
	IF rate = 0 THEN rate := in.info.rate !
	IF ! rate <= 0.0 THEN argerror('invalid RATE - must be > 0 Hz')

	IF     delay = 0
		delay  := oss_DecayReverb2Delay(Fabs(decay), Fabs(reverb))
	ELSEIF decay = 0
		decay  := ! oss_DelayReverb2Decay(Fabs(delay), Fabs(reverb))
		IF ! reverb < 0.0 THEN decay := ! -decay
	ELSE
		reverb := oss_DelayDecay2Reverb(Fabs(delay), Fabs(decay))
	ENDIF
	length := ! Fabs(delay) * rate !
	IF volume = 0 THEN volume := 1.0

	out := setupoutput(from, to, in, Fabs(reverb), rate, volume)

	NEW echo.echo(in, out, length, decay)

	-> do stuff
	WHILE echo.process() DO CtrlC()

EXCEPT DO

	-> cleanup
	END echo
	END out
	END in
	oss_cleanup()
	IF rdargs THEN FreeArgs(rdargs)

	printerror(exception, exceptioninfo)

ENDPROC IF exception THEN 5 ELSE 0


-> catch exceptions from oss_output
PROC setupoutput(from, to, in:PTR TO oss_input, reverb, rate, volume) HANDLE
	DEF out = NIL : PTR TO oss_output
	NEW out.oss_output(to, volume)
	IF from <> to
		IF out.info.length < (in.info.length + (! reverb * rate !))
			END out
			oss('sa_changesize \d', in.info.length + (! reverb * rate !))
			NEW out.oss_output(to, volume)
		ENDIF
	ENDIF
EXCEPT
	IF exception = "oss"
		END out
		oss('sa_changesize \d', in.info.length + (! reverb * rate !))
		NEW out.oss_output(to, volume)
	ELSE
		ReThrow()
	ENDIF
ENDPROC out

version:
	CHAR '$VER: cha_echo 1.2 (1999.12.11) © Claude Heiland-Allen',0

/*--------------------------------------------------------------------------+
| END: cha_echo.e                                                           |
+==========================================================================*/
