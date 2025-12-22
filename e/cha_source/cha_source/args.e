/*==========================================================================+
| args.e                                                                    |
| functions and macros to make reading arguments easier                     |
| NB: the arg array from ReadArgs() must be called args                     |
+--------------------------------------------------------------------------*/

OPT MODULE,
    PREPROCESS
OPT EXPORT

MODULE '*oss'

/*-------------------------------------------------------------------------*/

-> get integer, float, boolean, string, oss instrument number
-> throws ("IARG", id), ("FARG", id), ("SARG", id) if bad format
-> throws ("ARG", id) if argument not given

#define iarg(id) _iarg(args[id], id, 'id' + 4)
#define farg(id) _farg(args[id], id, 'id' + 4)
#define barg(id) _barg(args[id], id, 'id' + 4)
#define sarg(id) _sarg(args[id], id, 'id' + 4)
#define ossinumarg(id) _ossinumarg(args[id], id, 'id' + 4)

/*-------------------------------------------------------------------------*/

-> get with default value integer, float, boolean, string
-> default for boolean is xor'ed with value (to allow switches to turn
-> off features if specified)
-> throws ("IARG", id), ("FARG", id) if bad format

#define iargd(id, def) _iargd(args[id], id, 'id' + 4, def)
#define fargd(id, def) _fargd(args[id], id, 'id' + 4, def)
#define bargd(id, def) _bargd(args[id], id, 'id' + 4, def)
#define sargd(id, def) _sargd(args[id], id, 'id' + 4, def)

/*-------------------------------------------------------------------------*/

-> helper functions (private)

PROC _iarg(a, id, sid)
	DEF v, ok
	IF a
		v, ok := Val(a)
		IF ok <> StrLen(a) THEN Throw("IARG", sid)
	ELSE
		Throw("ARG", sid)
	ENDIF
ENDPROC v

PROC _farg(a, id, sid)
	DEF v, ok
	IF a
		v, ok := RealVal(a)
		IF ok <> StrLen(a) THEN Throw("FARG", sid)
	ELSE
		Throw("ARG", sid)
	ENDIF
ENDPROC v

PROC _barg(a, id, sid) IS a

PROC _sarg(a, id, sid)
	IF a
		IF StrLen(a) = 0 THEN Throw("SARG", sid)
	ELSE
		Throw("ARG", sid)
	ENDIF
ENDPROC a

PROC _ossinumarg(a, id, sid)
	DEF v
	IF a
		IF (StrLen(a) <> 1) AND (StrLen(a) <> 2) THEN Throw("OARG", sid)
		v := oss_ed_inumtonumber(a)
		IF v = 0 THEN Throw("rarg", sid)
		RETURN v
	ELSE
		Throw("ARG", sid)
	ENDIF
ENDPROC

PROC _iargd(a, id, sid, def)
	DEF v, ok = FALSE
	IF a
		v, ok := Val(a)
		IF ok <> StrLen(a) THEN Throw("IARG", sid)
	ENDIF
ENDPROC IF ok THEN v ELSE def

PROC _fargd(a, id, sid, def)
	DEF v, ok = FALSE
	IF a
		v, ok := RealVal(a)
		IF ok <> StrLen(a) THEN Throw("FARG", sid)
	ENDIF
ENDPROC IF ok THEN v ELSE def

PROC _bargd(a, id, sid, def) IS Eor(a, def)

PROC _sargd(a, id, sid, def)
	IF a
		IF StrLen(a) <> 0 THEN RETURN a
	ENDIF
ENDPROC def

/*--------------------------------------------------------------------------+
| END: args.e                                                               |
+==========================================================================*/
