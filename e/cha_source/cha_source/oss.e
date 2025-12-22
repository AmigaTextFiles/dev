/*==========================================================================+
| oss.e                                                                     |
| linkage with OSS                                                          |
+--------------------------------------------------------------------------*/

OPT PREPROCESS,
    MODULE
OPT EXPORT

MODULE '*debug', 'other/nsm', 'other/nsm_extra'

/*-------------------------------------------------------------------------*/

DEF octabase

/*-------------------------------------------------------------------------*/

PROC oss(fstring, a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0)
	DEF buffer[256] : STRING
	StringF(buffer, fstring, a,b,c,d,e,f,g,h)
	debug(['oss(\s)', buffer])
ENDPROC nsm_sendrexx(buffer)

PROC ossv(fstring, a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0)
ENDPROC Val(oss(fstring, a,b,c,d,e,f,g,h))

/*-------------------------------------------------------------------------*/

PROC oss_init(neednsm = TRUE)
	DEF rexxport
	Disable()
	rexxport := FindPort('OCTAMED_REXX')
	Enable()
	IF rexxport = NIL THEN Throw("oss", 'OctaMED SoundStudio is not running')
	IF neednsm
		octabase := nsm_getoctabase()
		IF octabase = NIL THEN Throw("oss",
	    	                'nsm patched OctaMED SoundStudio is not running')
		-> bug in nsm patch system means octabase isn't actually 0 if oss
		-> hasn't been started after nsmport.  check for oss running means
		-> that oss must have been started before nsmport in this case
		IF octabase = $0000B00E THEN Throw("oss",
		                    'nsmport started after OctaMED SoundStudio')
		debug(['octabase = \z\h[8]',octabase])
	ENDIF
ENDPROC

PROC oss_cleanup()
	oss_updatedisplay()
	nsm_freeresult()
ENDPROC

/*-------------------------------------------------------------------------*/

PROC oss_updatedisplay(on = TRUE)
	IF on
		oss('ed_setdata_update on')
		oss('ed_setdata_update')
		oss('sa_refresh')
	ELSE
		oss('ed_setdata_update off')
	ENDIF
ENDPROC

/*-------------------------------------------------------------------------*/

PROC oss_samplebase(i) IS nsm_getsamplebase(octabase,i)

/*-------------------------------------------------------------------------*/

PROC oss_ed_inumtonumber(inum : PTR TO CHAR)
	DEF m, n, l
	l := StrLen(inum)
	SELECT l
	CASE 1
		m := "0"
		n := inum[0]
	CASE 2
		m := inum[0]
		n := inum[1]
	DEFAULT
		RETURN 0
	ENDSELECT
	IF     m = "0"
		   m := 0
	ELSEIF m = "1"
		   m := 1
	ELSE
		RETURN 0
	ENDIF
	IF     ("0" <= n) AND (n <= "9")
		   n := n - "0"
	ELSEIF ("A" <= n) AND (n <= "V")
	       n := n - ("A" - 10)
	ELSE
		RETURN 0
	ENDIF
ENDPROC 32 * m + n

PROC oss_ed_numbertoinum(inum : LONG, to : PTR TO CHAR)
	DEF m, n
	m := Div(inum, 32)
	n := Mod(inum, 32)
	to[0] := 0
	to[1] := 0
	to[2] := 0
	IF     m = 0
		to[0] := "0"
	ELSEIF m = 1
		to[0] := "1"
	ELSE
		RETURN 0
	ENDIF
	IF     (0 <= n) AND (n <= 9)
		to[1] := "0" + n
	ELSEIF (10 <= n) AND (n <= 31)
		to[1] := "A" + (n - 10)
	ELSE
		RETURN 0
	ENDIF
ENDPROC to

/*-------------------------------------------------------------------------*/

CONST CURRENT = -1
PROC oss_ed_getblockname(block=CURRENT) IS nsm_getblockname(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block))
PROC oss_ed_getcurrblock() IS nsm_getcurrblock(octabase)
PROC oss_ed_getcurrline() IS nsm_getcurrline(octabase)
PROC oss_ed_getcurrpage() IS nsm_getcurrpage(octabase)
PROC oss_ed_getcurrtrack() IS nsm_getcurrtrack(octabase)
PROC oss_ed_getdata_note(block=CURRENT, track=CURRENT, line=CURRENT) IS nsm_getnote(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line)
PROC oss_ed_getdata_inum(block=CURRENT, track=CURRENT, line=CURRENT) IS nsm_getinum(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line)
PROC oss_ed_getdata_cmdnum(block=CURRENT, track=CURRENT, line=CURRENT, page=CURRENT) IS nsm_getcmdnum(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line, IF page = CURRENT THEN nsm_getcurrpage(octabase) ELSE page)
PROC oss_ed_getdata_cmdlvl(block=CURRENT, track=CURRENT, line=CURRENT, page=CURRENT) IS nsm_getcmdlvl(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line, IF page = CURRENT THEN nsm_getcurrpage(octabase) ELSE page)
PROC oss_ed_getlinehighlight(line=CURRENT, block=CURRENT) IS nsm_getlinehighlight(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line)
PROC oss_ed_getnumblocks() IS nsm_getnumblocks(octabase)
PROC oss_ed_getnumlines(block=CURRENT) IS nsm_getnumlines(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block))
PROC oss_ed_getnumpages(block=CURRENT) IS nsm_getnumpages(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block))
PROC oss_ed_getnumtracks(block=CURRENT) IS nsm_getnumtracks(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block))
PROC oss_ed_setlinehighlight_on(line=CURRENT, block=CURRENT) IS nsm_setlinehighlight(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line)
PROC oss_ed_setlinehighlight_off(line=CURRENT, block=CURRENT) IS nsm_unsetlinehighlight(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line)
PROC oss_ed_setdata_note(note, block=CURRENT, track=CURRENT, line=CURRENT) IS nsm_setnote(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line, note)
PROC oss_ed_setdata_inum(inum, block=CURRENT, track=CURRENT, line=CURRENT) IS nsm_setinum(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line, inum)
PROC oss_ed_setdata_cmdnum(cmdnum, block=CURRENT, track=CURRENT, line=CURRENT, page=CURRENT) IS nsm_setcmdnum(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line, IF page = CURRENT THEN nsm_getcurrpage(octabase) ELSE page, cmdnum)
PROC oss_ed_setdata_cmdlvl(cmdlvl, block=CURRENT, track=CURRENT, line=CURRENT, page=CURRENT) IS nsm_setcmdlvl(IF block = CURRENT THEN nsm_getcurrblockbase(octabase) ELSE nsm_getblockbase(octabase, block), IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track, IF line = CURRENT THEN nsm_getcurrline(octabase) ELSE line, IF page = CURRENT THEN nsm_getcurrpage(octabase) ELSE page, cmdlvl)
PROC oss_in_getdecay() IS nsm_getdecay(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getdefaultpitch() IS nsm_getdefaultpitch(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getdisable() IS nsm_getdisable(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getextendedpreset() IS nsm_getextendedpreset(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getfinetune() IS nsm_getfinetune(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_gethold() IS nsm_gethold(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getlooppingpong() IS nsm_getlooppingpong(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getmidichannel() IS nsm_getmidichannel(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getmidipreset() IS nsm_getmidipreset(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getname() IS nsm_getinname(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getnumber() IS nsm_getcurrinstrument(octabase)
PROC oss_in_getsuppressnoteoff() IS nsm_getsuppressnoteonoff(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_gettranspose() IS nsm_gettranspose(octabase, nsm_getcurrinstrument(octabase))
PROC oss_in_getvolume() IS nsm_getvolume(octabase, nsm_getcurrinstrument(octabase))
PROC oss_rn_getrangeendline() IS nsm_getrangeendline(octabase)
PROC oss_rn_getrangeendtrack() IS nsm_getrangeendtrack(octabase)
PROC oss_rn_getrangestartline() IS nsm_getrangestartline(octabase)
PROC oss_rn_getrangestarttrack() IS nsm_getrangestarttrack(octabase)
PROC oss_rn_isranged() IS nsm_ranged(octabase)
PROC oss_sa_getlooplength() IS nsm_getlooplength(octabase, nsm_getcurrinstrument(octabase))
PROC oss_sa_getloopstart() IS nsm_getloopstart(octabase, nsm_getcurrinstrument(octabase))
PROC oss_sa_getloopstate() IS nsm_getloopstate(octabase, nsm_getcurrinstrument(octabase))
PROC oss_sa_getsamplelength() IS nsm_getsamplelength(nsm_getcurrsamplebase(octabase))
PROC oss_sg_istrackon(track=CURRENT) IS nsm_trackon(octabase, IF track = CURRENT THEN nsm_getcurrtrack(octabase) ELSE track)

/*-------------------------------------------------------------------------*/

/*
todo

ED_NOTETONUMBER
ED_NUMBERTONOTE
PROC oss_ed_setlinehighlight_toggle(line=-1, block=-1) IS EMPTY
OP_GETKEYBOARDOCT
octave      nsm_getcurroctave(octabase)
PL_GETSTATE = STOPPED,PLAYSONG,PLAYBLOCK
isplaying   nsm_playing(octabase)
SA_GETSAMPLE O=OFFSET/N/A
SA_SETSAMPLE O=OFFSET/N/A,V=VALUE/N/A
sample      nsm_getsample(samplebase, offset)
            nsm_setsample(samplebase, offset, sample)

*/

/*
octamed arexx commands not accessible via nsm, but should be

ED_GETCURRPLAYSEQ
ED_GETCURRSECLIST
ED_GETCURRSECTION
ED_GETNUMPLAYSEQ
ED_GETNUMSECLIST
ED_GETNUMSECTIONS
ED_GETPLAYSEQBLOCK O=OFFSET/N
ED_GETSECLISTSECTION O=OFFSET/N
ED_GETSECTIONNAME
IN_GETNUMOCTAVES
IN_GETOUTPUT
IN_GETTYPE = EMPTY,SAMPLE,SYNTH,HYBRID,EXTSAMPLE,SAMPLE16,UNKNOWN
IN_ISSLOTUSED SL=SLOT/N
IN_ISSTEREO
MM_GETCURRMSGNUM
OP_GET OPT/A
OP_SET OPT/A,VAL/N,ON/S,OFF/S,TOGGLE/S
OP_SETKEYBOARDOCT OCT/N,FKEY/K/N
OP_TOGGLEBETWEEN OPT/A,VAL1/N/A,VAL2/N/A
OP_UPDATE ON/S,OFF/S
RN_BUFFEREXISTS BUFF/N/A
RN_GETBUFFDATA BUFF/N/A,L=LINE/K/N/A,T=TRACK/K/N/A,P=PAGE/K/N,NOTE/S,INUM/S,CMDNUM=CMDTYPE/S,QUAL=CMDLVL/S
RN_GETBUFFLINES BUFF/N/A
RN_GETBUFFPAGES BUFF/N/A
RN_GETBUFFTRACKS BUFF/N/A
RN_SETBUFFDATA BUFF/N/A,L=LINE/K/N/A,T=TRACK/K/N/A,P=PAGE/K/N,NOTE/K/N,INUM/K/N,CMDNUM=CMDTYPE/K/N,QUAL=CMDLVL/K/N
SA_GETBUFFERLENGTH
SA_GETDISPLAYCHANNEL = LEFT,RIGHT,BOTH
SA_GETDISPLAYSIZE
SA_GETDISPLAYSTART
SA_GETRANGEEND
SA_GETRANGESTART
SG_GETANNOSTRING
SG_GETCHANNELMODE (9 = mixing)
SG_GETCURRENTSONGNUMBER
SG_GETFILTER
SG_GETHQ
SG_GETMASTERVOL
SG_GETNAME
SG_GETNUMBEROFSONGS
SG_GETPLAYTRANSPOSE
SG_GETSLIDEMODE
SG_GETTEMPO
SG_GETTEMPOLPB
SG_GETTEMPOMODE = SPD,BPM
SG_GETTEMPOTPL
SG_GETTRACKPAN TRACK/N/A
SG_GETTRACKVOL TRACK/N/A
SG_GETVOLMODE = HEX,DEC
SG_ISMODIFIED
SG_ISTRACKSELECTED TRK=TRACK/N
SY_GETNUMBEROFWAVES
SY_GETPROGCOMMAND O=OFFSET/N/A,VOL/S,WF/S
SY_GETPROGCURSORX
SY_GETPROGLENGTH VOL/S,WF/S
SY_GETPROGLINE
SY_GETPROGSPEED VOL/S,WF/S
SY_GETSAMPLE O=OFFSET/N/A
SY_GETSELECTEDWAVE
SY_GETWAVELENGTH
SY_GETWAVENUM
SY_SETSAMPLE O=OFFSET/N/A,V=VALUE/N/A
VE_OCTAMED
VE_OCTAMEDREXX
WI_ISOPEN WINDOW/A
*/

/*
nsm commands not accessible via octamed arexx

resultstr   nsm_sendrexx(commandstr)
            nsm_freeresult()
bool        nsm_resultstringfalse(str)
bool        nsm_resultstringtrue(str)
            nsm_updateeditor(blockbase)
octabase    nsm_getoctabase()
blockbase   nsm_getblockbase(octabase,block)
blockbase   nsm_getcurrblockbase(octabase)
samplebase  nsm_getcurrsamplebase(octabase)
            nsm_setmed(part, blockbase, track, line, page, data)
data        nsm_getmed(part, blockbase, track, line, page)
subpos      nsm_getsubpos(octabase)
*/

/*--------------------------------------------------------------------------+
| END: oss.e                                                                |
+==========================================================================*/
