/*==========================================================================+
| cha_bassdrum.e                                                            |
| generate a bassdrum sound                                                 |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37
OPT PREPROCESS

MODULE '*oss', '*oss_output', '*oss_sample', '*outputbuffer', '*errors',
       '*args'

RAISE "^C"   IF CtrlC() <> FALSE,
      "ARGS" IF ReadArgs() = NIL,
      "MEM"  IF New() = NIL,
      "MEM"  IF String() = NIL

/*-------------------------------------------------------------------------*/

ENUM ARG_TO,
     ARG_FREQ,
     ARG_FALLOFF,
     ARG_AT,
     ARG_ST,
     ARG_DT,
     ARG_AL,
     ARG_SL,
     ARG_RATE,
     ARG_BITS,
     ARGCOUNT

PROC main() HANDLE

	DEF out = NIL : PTR TO oss_output,
	    args = NIL : PTR TO LONG,
	    rdargs = NIL,
	    to, freq, falloff, at, st, dt, al, sl, rate, bits

	oss_init()

	-> read args
	args := New(Mul(ARGCOUNT, SIZEOF LONG))
	rdargs := ReadArgs('TO/A,FREQ=FREQUENCY/K,FALLOFF/K,AT=ATTACKTIME/K,'
	                  +'ST=SUSTAINTIME/K,DT=DECAYTIME/K,AL=ATTACKLEVEL/K,'
	                  +'SL=SUSTAINLEVEL/K,RATE/K,BITS/K', args, NIL)

	to      := ossinumarg(ARG_TO)
	freq    := fargd(ARG_FREQ,   150.0)
	falloff := fargd(ARG_FALLOFF, 15.0)
	at      := fargd(ARG_AT,       0.005)
	st      := fargd(ARG_ST,       0.15)
	dt      := fargd(ARG_DT,       0.05)
	al      := fargd(ARG_AL,       2.0)
	sl      := fargd(ARG_SL,       0.5)
	rate    := fargd(ARG_RATE, 16574.0)
	bits    := iargd(ARG_BITS,     8)

	-> check args
	IF (! freq    <= 0.0) THEN Throw("rarg", 'FREQUENCY')
	IF (! falloff <= 0.0) THEN Throw("rarg", 'FALLOFF')
	IF (! at      <  0.0) THEN Throw("rarg", 'ATTACKTIME')
	IF (! st      <  0.0) THEN Throw("rarg", 'SUSTAINTIME')
	IF (! dt      <  0.0) THEN Throw("rarg", 'DELAYTIME')
	IF (! al      <  0.0) THEN Throw("rarg", 'ATTACKLEVEL')
	IF (! sl      <  0.0) THEN Throw("rarg", 'SUSTAINLEVEL')
	IF (! rate    <  0.0) THEN Throw("rarg", 'RATE')
	IF (bits <> 8) AND (bits <> 16) THEN Throw("rarg", 'BITS')

	-> set up output
	oss('in_select \d', to)
	oss('in_settype sample\s', IF bits = 8 THEN '' ELSE '16')
	oss('sa_changesize \d', ! (! at + st + dt) * rate !)
	NEW out.oss_output(to)

	-> generate bassdrum
	bassdrum(out.info.rate !, freq, falloff, at, st, dt, al, sl, out)

EXCEPT DO

	-> cleanup
	END out
	IF rdargs THEN FreeArgs(rdargs)
	oss_cleanup()

	-> report errors
	printerror(exception, exceptioninfo)

ENDPROC IF exception THEN 5 ELSE 0


PROC bassdrum(rate, freq, falloff, attacktime, sustaintime, decaytime,
              attacklevel, sustainlevel, out : PTR TO outputbuffer)
	DEF  time, freq0, freq1, a, b, i, count, v, dv, x
	-> initialise
	time  := ! attacktime + sustaintime + decaytime
	freq0 := freq
	freq1 := ! freq * Fexp(! -Flog(2.0) * time * falloff)
	a := ! -6.28318531 * time * freq0 / Flog(! freq0 / freq1)
	b := Fexp(! -Flog(! freq0 / freq1) / (! rate * time))
	v := 0.0
	-> attack phase
	count := ! attacktime * rate !
	dv := ! attacklevel / (count !)
	FOR i := 1 TO count
		x := ! v * Fsin(a)
		v := ! v + dv
		a := ! a * b
		out.write(x)
	ENDFOR
	-> sustain phase, repeated code is easy but inelegant
	count := ! sustaintime * rate !
	dv := ! (! sustainlevel - attacklevel) / (count !)
	FOR i := 1 TO count
		x := ! v * Fsin(a)
		a := ! a * b
		v := ! v + dv
		out.write(x)
	ENDFOR
	-> decay phase, repeated code is easy but inelegant
	count := ! decaytime * rate !
	dv := ! -sustainlevel / (count !)
	FOR i := 1 TO count
		x := ! v * Fsin(a)
		a := ! a * b
		v := ! v + dv
		out.write(x)
	ENDFOR
	-> clear end of sample (possible rounding errors)
	WHILE out.write(0.0) DO CtrlC()
ENDPROC

version:
	CHAR '$VER: cha_bassdrum 1.2 (1999.12.11) © Claude Heiland-Allen',0

/*--------------------------------------------------------------------------+
| END: cha_bassdrum.e                                                       |
+==========================================================================*/
