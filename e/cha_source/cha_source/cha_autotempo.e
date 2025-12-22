/*==========================================================================+
| autotempo.e                                                               |
| automatically transpose/finetune sample to fit tempo                      |
$VER: cha_autotempo.e 1.4 (1999.12.17) © Claude Heiland-Allen               |
| changes since 1.3 (1999.12.11)                                            |
| - command line arguments                                                  |
| - uses nsm functions                                                      |
| changes since 1.2 (1999.09.16)                                            |
| - now uses errors.m                                                       |
| changes since 1.1 (1999.08.05)                                            |
| - some source code shared with other plugins                              |
| - bug fix: earlier versions needed public screen "OCTAMED"                |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37, PREPROCESS

MODULE '*calcs', '*oss', '*errors', '*args'

RAISE "ARGS" IF ReadArgs() = NIL

/*-------------------------------------------------------------------------*/

-> default settings
CONST DEFAULTPITCH = 25, -> C-3
      LINES        = 16

ENUM ARG_INST,
     ARG_LINES,
     ARG_NOTE,
     ARG_LEN,
     ARG_BPM,
     ARG_LPB,
     ARGCOUNT

/*-------------------------------------------------------------------------*/

PROC main() HANDLE

	DEF defaultpitch, samplelength, tempo, tempolpb, lines,
	    rangestartline, rangeendline, note, transpose, finetune,
	    args[ARGCOUNT] : ARRAY OF LONG, rdargs = NIL

	oss_init()

	/** 1.4 **/
	-> get oss / arg data
	rdargs := ReadArgs('INST=INSTRUMENT,LINES/K,NOTE/K,LEN=SAMPLELENGTH/K,'
	                  +'BPM/K,LPB/K', args, NIL)

	IF args[ARG_INST] THEN oss('IN_SELECT \d', ossinumarg(ARG_INST))

	rangestartline := oss_rn_getrangestartline()
	rangeendline   := oss_rn_getrangeendline()
	lines := rangeendline - rangestartline + 1
	IF lines = 1 THEN lines := LINES
	lines := iargd(ARG_LINES, lines)

	-> ignore NOTE for the moment
	defaultpitch := oss_in_getdefaultpitch() ->ossv('IN_GETDEFAULTPITCH')
	IF defaultpitch = 0 THEN defaultpitch := DEFAULTPITCH

	samplelength := iargd(ARG_LEN, oss_sa_getsamplelength())
	IF samplelength = 0 THEN error('no sample')

	IF StrCmp(oss('SG_GETTEMPOMODE'), 'BPM') = FALSE THEN error('tempo mode must be BPM')
	tempo := iargd(ARG_BPM, ossv('SG_GETTEMPO'))

	tempolpb := iargd(ARG_LPB, ossv('SG_GETTEMPOLPB'))
	/** 1.4 **/

/*
	-> previous version
	defaultpitch := oss_in_getdefaultpitch() ->ossv('IN_GETDEFAULTPITCH')
	IF defaultpitch = 0 THEN defaultpitch := DEFAULTPITCH
	tempomode      := oss ('SG_GETTEMPOMODE')
	IF StrCmp(tempomode,'BPM')=FALSE THEN error('tempo mode must be BPM')
	tempo          := ossv('SG_GETTEMPO')
	tempolpb       := ossv('SG_GETTEMPOLPB')
	rangestartline := ossv('RN_GETRANGESTARTLINE')
	rangeendline   := ossv('RN_GETRANGEENDLINE')
	lines := rangeendline - rangestartline + 1
	IF lines = 1 THEN lines := LINES
*/

/*
	-> debugging
	WriteF('+++ cha_autotempo\n'
	      +'+++    INSTRUMENT   = \d[8]\n'
	      +'+++    LINES        = \d[8]\n'
	      +'+++    NOTE         = \d[8]\n'
	      +'+++    SAMPLELENGTH = \d[8]\n'
	      +'+++    BPM          = \d[8]\n'
	      +'+++    LPB          = \d[8]\n',
	        oss_in_getnumber(),
	        lines,
	        defaultpitch,
	        samplelength,
	        tempo,
	        tempolpb)
*/

	-> the all-important calculation
	-> freq = length * lpb * bpm / lines * 60
	note,finetune := oss_Period2NoteFinetune(oss_Frequency2Period(
	          Div(Mul(Mul(tempo,tempolpb),samplelength),Mul(lines,60))))

	-> set oss data
	IF note = 0 THEN error('pitch change required is too large')
	transpose := note - defaultpitch
	oss('IN_SETTRANSPOSE \d', transpose)
	oss('IN_SETFINETUNE  \d', finetune)

/*
	-> more debugging
	WriteF('+++\n'
	      +'+++    TRANSPOSE = \d[8]\n'
	      +'+++    FINETUNE  = \d[8]\n',
	        transpose,
	        finetune)
*/

EXCEPT DO

	-> clean up
	oss_cleanup()

	-> report errors
	printerror(exception, exceptioninfo)

ENDPROC IF exception THEN 5 ELSE 0

/*-------------------------------------------------------------------------*/

-> version string
version: CHAR '$VER: cha_autotempo 1.4 (1999.12.17) © Claude Heiland-Allen',0

/*--------------------------------------------------------------------------+
| END: cha_autotempo.e                                                      |
+==========================================================================*/
