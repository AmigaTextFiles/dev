/*==========================================================================+
| cha_stanley.e                                                             |
| a tool for cutting up samples in OctaMED SoundStudio                      |
|                                                                           |
| .stanley 2.4 file format                                                  |
|   'cha_stanley \d.\d\n', version, revision                                |
|   '\d\n', length                                                          |
|   '\d\n', marker position                                                 |
|   ...                                                                     |
|   '\n'                                                                    |
|   EOF                                                                     |
|                                                                           |
| NB: loading is a bit dodgy - no error checking                            |
|                                                                           |
| OBJECT marker   -> all the operations on a marker (some change gui list)  |
| OBJECT stanley  -> all the operations on the current marker and list      |
| PROC findnode   -> utility function                                       |
| PROC oss#?      -> octamed interfacing functions                          |
| PROC a_#?       -> gui action functions                                   |
| PROC main       -> program entrypoint                                     |
|                                                                           |
| cha_stanley v2.4 (1999.12.17)                                             |
| - save and load marker info                                               |
| - bugfix to select (didn't update text display for to sample)             |
| cha_stanley v2.3 (1999.12.11)                                             |
| - now uses OSS instrument numbering                                       |
| - uses errors.m                                                           |
| cha_stanley v2.2 (1999.06.19)                                             |
| - minor changes for source code sharing                                   |
| - arexx put inline for clarity                                            |
| - fixed oss_update()                                                      |
| - fixed default pitch; uses C-3 instead of -|- if not specified           |
| stanley v2.1 (1999.06.19)                                                 |
| - changes since previous version are enclosed in /* + + + */              |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37
OPT LARGE

MODULE 'amigalib/lists', 'exec/lists', 'exec/nodes', 'tools/easygui',
       'asl', 'libraries/asl', '*oss', '*errors'

RAISE "MEM" IF String() = NIL

/*--------------------------------------------------------------------------*/

CONST SIZE_LVX = 5, SIZE_LVY = 5, SIZE_SLX = 5, SIZE_STX = 5, -> gadget sizes
      NAMELEN = 40      -> max editable part of name, limit set by OSS

/* + + + */
DEF screen = NIL
/* + + + */

/*=========================================================================*/

OBJECT marker OF ln
	name2 : PTR TO CHAR -> user editable part
	start : LONG        -> sample start offset
	to    : LONG        -> value = sample slot, negative = use auto
ENDOBJECT

/*-------------------------------------------------------------------------*/

PROC new(list : PTR TO lh, offset, name = NIL) OF marker
	DEF m : PTR TO marker
	self.type  := NT_UNKNOWN
	self.pri   := 0
	self.name  := String(NAMELEN + 20)
	self.name2 := StrCopy(String(NAMELEN), name)
	self.start := offset
	self.to    := -ossv('in_getnumber')           -> auto
	m := list.head
	WHILE m.succ
	EXIT m.start > self.start
		m := m.succ
	ENDWHILE
	-> m = node to insert before
	self.succ := m
	self.pred := m.pred
	self.succ.pred := self
	self.pred.succ := self
	self.updatename()
ENDPROC

/*-------------------------------------------------------------------------*/

PROC end() OF marker
	Remove(self)
	DisposeLink(self.name2)
	DisposeLink(self.name)
ENDPROC

/*-------------------------------------------------------------------------*/

PROC updatename() OF marker
	/* - - - */
	DEF buf[3] : STRING
	/* - - - */
	IF self.to < 0  -> auto
		StringF(self.name, '\d[6] (--): \s', self.start, self.name2)
	ELSE            -> manual set
	/* - - - */
		StringF(self.name, '\d[6] (\s[2]): \s', self.start, oss_ed_numbertoinum(self.to, buf), self.name2)
	/* - - - */
	ENDIF
ENDPROC

/*-------------------------------------------------------------------------*/

PROC findnode(list : PTR TO lh, start)
	DEF m : PTR TO marker
	m := list.head
	WHILE m.succ
		IF m.start = start THEN RETURN TRUE
		m := m.succ
	ENDWHILE
ENDPROC FALSE

/*=========================================================================*/

OBJECT stanley
	-> GUI state
	gh : PTR TO guihandle      ->>>>>>> OFFSET = 4
	-> GUI definitions
	g_button_add
	g_button_close
	g_button_delete
	g_button_play
	g_button_range
	g_button_reset
	g_button_stanley
	/* + + + */
	g_button_notify
	g_check_hires
	/* + + + */
	g_check_setto
	g_listview_select
	/* - - - */
	g_text_setto
	/* - - - */
	g_slider_setto
	g_string_setname
	/** 2.4 **/
	g_button_load
	g_button_save
	/** 2.4 **/
	g_gui
	-> Variables
	v_from                          -> from sample
	v_cur                           -> current marker id (as in listview)
	v_curmarker : PTR TO marker     -> current marker
	v_markers   : mlh               -> ordered list of markers
	/* + + + */
	v_hires
	v_defpitch                      -> filled by stanley()
	v_stanleyed                     -> stanley has been clicked recently
	g_title                         -> default window title
	/* + + + */
ENDOBJECT

/*-------------------------------------------------------------------------*/

PROC new()          OF stanley
	self.v_from := -1
	self.v_cur  := -1
	self.v_curmarker := NIL
	newList(self.v_markers)
	/* + + + */
	self.v_hires := TRUE
	-> skip version tag part
	self.g_title := 6 + '$VER: cha_stanley v2.4 (1999.12.17) © Claude Heiland-Allen'
	/* + + + */
	self.g_button_add      := NEW [ SBUTTON, {a_button_add},      'Add',     0, 0, 0, FALSE ]
	self.g_button_delete   := NEW [ SBUTTON, {a_button_delete},   'Delete',  0, 0, 0, TRUE  ]
	self.g_button_play     := NEW [ SBUTTON, {a_button_play},     'Play',    0, 0, 0, TRUE  ]
	self.g_button_range    := NEW [ SBUTTON, {a_button_range},    'Range',   0, 0, 0, TRUE  ]
	self.g_button_reset    := NEW [ SBUTTON, {a_button_reset},    'Reset',   0, 0, 0, FALSE ]
	self.g_button_stanley  := NEW [ SBUTTON, {a_button_stanley},  'Stanley', 0, 0, 0, FALSE ]
	/* + + + */
	self.g_button_notify   := NEW [ SBUTTON, {a_button_notify},   'Notify',  0, 0, 0, FALSE ]
	self.g_check_hires     := NEW [ CHECK,   {a_check_hires},     'Hires',   TRUE, FALSE, 0, 0, FALSE ]
	/* + + + */
	self.g_check_setto     := NEW [ CHECK,   {a_check_autoto},    'Auto',    TRUE, FALSE, 0, 0, FALSE ]
	self.g_listview_select := NEW [ LISTV,   {a_listview_select}, 'Markers', SIZE_LVX, SIZE_LVY, self.v_markers, FALSE, TRUE, self.v_cur, 0, 0, 0, FALSE ]
	/* - - - */
	self.g_text_setto      := NEW [ TEXT,    '  ',                'To: ', FALSE, 0 ]
	self.g_slider_setto    := NEW [ SLIDE,   {a_slider_setto},    '',  FALSE, 1, 63, 1, SIZE_SLX, '', 0, 0, TRUE ]
	/* - - - */
	self.g_string_setname  := NEW [ STR,     {a_string_setname},  'Name: ',  String(NAMELEN), NAMELEN, SIZE_STX, FALSE, 0, 0, 0, FALSE ]
	/** 2.4 **/
	self.g_button_load     := NEW [ SBUTTON, {a_button_load},     'Load',    0, 0, 0, FALSE ]
	self.g_button_save     := NEW [ SBUTTON, {a_button_save},     'Save',    0, 0, 0, FALSE ]
	/** 2.4 **/
	self.g_gui :=	NEW [ EQCOLS,
						self.g_listview_select,
						NEW [ ROWS,
	/** 2.4 **/
							NEW [ BEVELR,
								self.g_button_add
								],
	/** 2.4 **/
							NEW [ SPACE ],
							NEW [ BEVELR,
								NEW [ ROWS,
									NEW [ EQCOLS,
										self.g_button_delete,
										self.g_button_range,
										self.g_button_play
										],
									NEW [ COLS,
	/* - - - */
										self.g_text_setto,
	/* - - - */
										self.g_slider_setto,
										self.g_check_setto
										],
									self.g_string_setname
									]
								],
							NEW [ SPACE ],
							NEW [ BEVELR,
								NEW [ ROWS,
									/* + + + */
									NEW [ COLS,
										self.g_button_notify,
										self.g_check_hires
										],
									/* + + + */
									self.g_button_stanley
									]
								],
	/** 2.4 **/
							NEW [ SPACE ],
							NEW [ BEVELR,
								NEW [ EQCOLS,
									self.g_button_reset,
									self.g_button_load,
									self.g_button_save
									]
								]
	/** 2.4 **/
							]
						]
	self.reset()
ENDPROC

/*-------------------------------------------------------------------------*/

PROC end()          OF stanley
	DEF m : PTR TO marker, t
	m := self.v_markers.head
	WHILE t := m.succ
		END m
		m := t
	ENDWHILE
ENDPROC

/*-------------------------------------------------------------------------*/

/** 2.4 **/
PROC add(start=-1)  OF stanley
	DEF m = NIL : PTR TO marker
	IF start = -1 THEN start := ossv('sa_getrangestart')
/** 2.4 **/
	IF findnode(self.v_markers, start) = FALSE
		setlistvlabels(self.gh, self.g_listview_select, -1)
		NEW m.new(self.v_markers, start, oss('in_getname'))
		/* + + + */
		self.cannotify(FALSE)
		/* + + + */
		setlistvlabels(self.gh, self.g_listview_select, self.v_markers)
	ENDIF
ENDPROC

/*-------------------------------------------------------------------------*/

PROC close()        OF stanley IS TRUE -> true = close window, had requester but got annoying

/*-------------------------------------------------------------------------*/

PROC delete()       OF stanley      -> cannot be called for end markers
	setlistvlabels(self.gh, self.g_listview_select, -1)
	END self.v_curmarker
	self.select(self.v_cur, TRUE)   -> next marker
	/* + + + */
	self.cannotify(FALSE)
	/* + + + */
	setlistvlabels(self.gh, self.g_listview_select, self.v_markers)
ENDPROC

/*-------------------------------------------------------------------------*/

PROC play()         OF stanley IS self.range() BUT oss('sa_play range')  -> cannot be called for end markers

/*-------------------------------------------------------------------------*/

PROC range()        OF stanley IS oss('sa_range \d \d', self.v_curmarker.start, self.v_curmarker.succ::marker.start - 1)      -> cannot be called for end markers

/*-------------------------------------------------------------------------*/

PROC reset()        OF stanley
	DEF m : PTR TO marker, t, len, nosample
	setlistvlabels(self.gh, self.g_listview_select, -1)
	-> Flush list
	m := self.v_markers.head
	WHILE t := m.succ
		END m
		m := t
	ENDWHILE
	-> Get current instrument
	self.v_from := ossv('in_getnumber')
	-> Add start and end markers
	len := ossv('sa_getsamplelength')
	nosample := (len = 0)
->	setdisabled(self.gh, self.g_listview_select, nosample)  -> broken in v37?
	setdisabled(self.gh, self.g_button_add,      nosample)
	setdisabled(self.gh, self.g_button_stanley,  nosample)
	/* + + + */
	self.cannotify(FALSE)
	/* + + + */
	IF nosample = FALSE THEN NEW m.new(self.v_markers, 0, oss('in_getname'))
	NEW m.new(self.v_markers, len, '«« END »»')
	-> Update GUI
	self.select(0, TRUE)
	setlistvlabels(self.gh, self.g_listview_select, self.v_markers)
ENDPROC

/*-------------------------------------------------------------------------*/

PROC select(index, force = FALSE)  OF stanley
	DEF islast, isauto, isfirst, gh, m : PTR TO marker, i, s[4] : STRING
	IF (self.v_cur <> index) OR force
		gh := self.gh
		self.v_cur := index
		m := self.v_markers.head
		FOR i := 0 TO index - 1 DO m := m.succ
		self.v_curmarker := m
		islast  := (m.succ.succ = 0)
		isauto  := (m.to < 0)
		isfirst := (index = 0)
		setdisabled(gh, self.g_slider_setto,   islast OR isauto)
		setdisabled(gh, self.g_button_delete,  islast OR isfirst)
		setdisabled(gh, self.g_button_range,   islast)
		setdisabled(gh, self.g_button_play,    islast)
		setdisabled(gh, self.g_check_setto,    islast)
		setdisabled(gh, self.g_string_setname, islast)
		setstr     (gh, self.g_string_setname, m.name2)
		/** 2.4 **/
		settext    (gh, self.g_text_setto, oss_ed_numbertoinum(Abs(m.to), s))
		/** 2.4 **/
		setslide   (gh, self.g_slider_setto, Abs(m.to))
		setcheck   (gh, self.g_check_setto, isauto)
	ENDIF
ENDPROC

/*-------------------------------------------------------------------------*/

PROC setname(name)  OF stanley
	setlistvlabels(self.gh, self.g_listview_select, -1)
	StrCopy(self.v_curmarker.name2, name)
	self.v_curmarker.updatename()
	setlistvlabels(self.gh, self.g_listview_select, self.v_markers)
ENDPROC

/*-------------------------------------------------------------------------*/

PROC setto(to)      OF stanley
	DEF s[4] : STRING
	setlistvlabels(self.gh, self.g_listview_select, -1)
	self.v_curmarker.to := to
	self.v_curmarker.updatename()
	setdisabled(self.gh, self.g_slider_setto, to < 0)
	/* - - - */
	settext(self.gh, self.g_text_setto, oss_ed_numbertoinum(Abs(to), s))
	/* - - - */
	/* + + + */
	self.cannotify(FALSE)
	/* + + + */
	setlistvlabels(self.gh, self.g_listview_select, self.v_markers)
ENDPROC

/*-------------------------------------------------------------------------*/

PROC stanley()      OF stanley
	DEF m : PTR TO marker, finetune, transpose, pitch, volume
	/* + + + */
	-> hmmm, are changes really visible? better safe than sorry...
	changetitle(self.gh, 'cha_stanley: working...')
	setlistvlabels(self.gh, self.g_listview_select, -1)
	/* + + + */
	oss('in_select \d', self.v_from)
	pitch     := ossv('in_getdefaultpitch')
	IF pitch = 0 THEN pitch := 25 -> C-3
	/* + + + */
	self.v_defpitch := pitch
	self.cannotify(TRUE)
	/* + + + */
	finetune  := ossv('in_getfinetune')
	transpose := ossv('in_gettranspose')
	volume    := ossv('in_getvolume')
	m := self.v_markers.head
	WHILE m.succ.succ <> NIL    -> all but end marker
		-> copy sample
		oss('sa_range \d \d', m.start, m.succ::marker.start - 1)
		oss('sa_copyrange')
		IF m.to < 0 THEN oss('in_select nextfree') ELSE oss('in_select \d', m.to)
		/* + + + */
		-> store sample actually copied to
		m.to := IF m.to < 0 THEN -ossv('in_getnumber') ELSE ossv('in_getnumber')
		m.updatename()
		IF m = self.v_curmarker THEN setslide(self.gh, self.g_slider_setto, Abs(m.to))
		/* + + + */
		oss('sa_buffertosample')
		-> copy settings
		oss('in_setname "\s"', m.name2)
		oss('in_setdefaultpitch \d', pitch)
		oss('in_setfinetune \d', finetune)
		oss('in_settranspose \d', transpose)
		oss('in_setvolume \d', volume)
		-> next
		oss('in_select \d', self.v_from)
		m := m.succ
	ENDWHILE
	/* + + + */
	setlistvlabels(self.gh, self.g_listview_select, self.v_markers)
	changetitle(self.gh, self.g_title)
	/* + + + */
ENDPROC

/* + + + */

PROC cannotify(can) OF stanley
	self.v_stanleyed := can
	setdisabled(self.gh, self.g_button_notify, can = FALSE)
ENDPROC

PROC notify() OF stanley HANDLE
	DEF tpl, start, end, track, totaltp, totalsmp, note,
	    smp, line, tp, m : PTR TO marker, prevline = -1,
	    tp4, totaltp4
	changetitle(self.gh, 'Stanley: working...')
	oss_update(FALSE)
	IF ossv('rn_isranged') = FALSE THEN self.notify_warn(
	        ' No range selected for notify ',
	        ' Select a range in the tracker editor ')
	tpl   := ossv('sg_gettempotpl')
	end   := ossv('rn_getrangeendline')
	start := ossv('rn_getrangestartline')
	track := ossv('rn_getrangestarttrack')
	oss('rn_erase range')   -> do this after getting range info
	totaltp := Mul(end - start + 1, tpl)
	totalsmp := self.v_markers.tailpred::marker.start
	note  := self.v_defpitch
	m := self.v_markers.head
	totaltp4 := Shl(totaltp, 2)
	WHILE m.succ.succ
		smp := m.start
		IF self.v_hires
			-> this formula selects the timing pulse before the
			-> exact time, unless it is 3/4 of the way through
			tp4 := Div(Mul(totaltp4, smp), totalsmp)
			IF (tp4 AND %11) = %11 THEN tp4 := tp4 + 1
			tp, line := Mod(Shr(tp4, 2), tpl)
			line := line + start
			IF line = prevline THEN self.notify_warn(
			      ' Not enough space in notify ', ' Select a longer range ')
			oss('ed_setdata track=\d line=\d note=\d inum=\d cmdnum=\d qual=\d',
			                        track, line, note, Abs(m.to),
			                        IF tp THEN $1F ELSE 0,
			                        IF tp THEN Shl(tp, 4) AND $F0 ELSE 0)
		ELSE
			tp, line := Mod(Div(Mul(totaltp, smp), totalsmp), tpl)
			line := line + start
			-> get nearest line
			IF Mul(tp, 2) >= tpl THEN line := line + 1
			IF line = prevline THEN self.notify_warn(
			      ' Not enough space in notify ', ' Select a longer range ')
			oss('ed_setdata track=\d line=\d note=\d inum=\d cmdnum=\d qual=\d',
			                track, line, note, Abs(m.to), 0, 0)
		ENDIF
		prevline := line
		m := m.succ
	ENDWHILE
EXCEPT DO
	oss_update(TRUE)
	changetitle(self.gh, self.g_title)
	IF exception <> "warn" THEN ReThrow()
ENDPROC

PROC notify_warn(text1, text2) OF stanley
	easyguiA('cha_stanley',
	        NEW [ ROWS,
	            NEW [ TEXT, text1, 0,0,1 ],
	            NEW [ TEXT, text2, 0,0,1 ],
	            NEW [ BUTTON, 0, 'Ok'    ]
	        ],
	        NEW [ EG_SCRN, screen, EG_WTYPE, WTYPE_NOSIZE, NIL ])
	Raise("warn")
ENDPROC

/* + + + */


/** 2.4 **/

PROC save(filename) OF stanley HANDLE
	DEF fh = NIL, s[256] : STRING, m : PTR TO marker, len
	IF fh := Open(filename, NEWFILE)
		Fputs(fh, 'cha_stanley 2.4\n')
		-> last marker
		m := self.v_markers.head
		WHILE m.succ.succ DO m := m.succ
		len := m.start
		StringF(s, '\d\n', m.start)
		Fputs(fh, s)
		m := self.v_markers.head
		-> all but last marker
		WHILE m.succ.succ
			StringF(s, '\d\n', m.start)
			Fputs(fh, s)
			m := m.succ
		ENDWHILE
	ELSE
		Throw("OPEN", filename)
	ENDIF
EXCEPT DO
	IF fh THEN Close(fh)
	ReThrow()
ENDPROC

-> dos.FGets() has a bug in OS < v39, so pass len-1
PROC load(filename) OF stanley HANDLE
	DEF fh = NIL, s[256] : STRING, m : PTR TO marker, len, v, ok, reallen, f
	IF fh := Open(filename, OLDFILE)
		-> reset
		self.reset()
		-> get real length
		m := self.v_markers.head
		WHILE m.succ.succ DO m := m.succ
		reallen := m.start
		-> header
		Fgets(fh, s, 256-1)
		-> length
		Fgets(fh, s, 256-1)
		len, ok := Val(s)
		-> factor
		f := ! (reallen !) / (len !)
		-> markers
		WHILE Fgets(fh, s, 256-1)
			v, ok := Val(s)
			self.add(v ! * f !)
		ENDWHILE
	ELSE
		Throw("OPEN", filename)
	ENDIF
EXCEPT DO
	IF fh THEN Close(fh)
	ReThrow()
ENDPROC

/** 2.4 **/

/*=========================================================================*/

PROC a_button_add       (s : PTR TO stanley)        IS s.add()
PROC a_button_close     (s : PTR TO stanley)        IS IF s.close() THEN Raise("QUIT") ELSE 0
PROC a_button_delete    (s : PTR TO stanley)        IS s.delete()
PROC a_button_play      (s : PTR TO stanley)        IS s.play()
PROC a_button_range     (s : PTR TO stanley)        IS s.range()
PROC a_button_reset     (s : PTR TO stanley)        IS s.reset()
PROC a_button_stanley   (s : PTR TO stanley)        IS s.stanley()
/* + + + */
PROC a_button_notify    (s : PTR TO stanley)        IS s.notify()
PROC a_check_hires      (s : PTR TO stanley, hires) ;  s.v_hires := hires; ENDPROC      -> x.y:=z  is a statement not an expression...
/* + + + */
PROC a_check_autoto     (s : PTR TO stanley, to)    IS s.setto(IF to THEN -Abs(s.v_curmarker.to) ELSE Abs(s.v_curmarker.to))
PROC a_listview_select  (s : PTR TO stanley, index) IS s.select(index)
PROC a_slider_setto     (s : PTR TO stanley, to)    IS s.setto(to)
PROC a_string_setname   (s : PTR TO stanley, name)  IS s.setname(name)

/** 2.4 **/

PROC a_button_load(s : PTR TO stanley) HANDLE
	DEF filename
	IF filename := filerequester(FALSE) THEN s.load(filename)
EXCEPT
	SELECT exception
	CASE "OPEN"; displayerror('Can''t open file', exceptioninfo)
	CASE "FORM"; displayerror('Bad format in file', exceptioninfo)
	DEFAULT;     ReThrow()
	ENDSELECT
ENDPROC

PROC a_button_save(s : PTR TO stanley) HANDLE
	DEF filename
	IF filename := filerequester(TRUE) THEN s.save(filename)
EXCEPT
	SELECT exception
	CASE "OPEN"; displayerror('Can''t open file', exceptioninfo)
	CASE "FORM"; displayerror('Bad format in file', exceptioninfo)
	DEFAULT;     ReThrow()
	ENDSELECT
ENDPROC

-> based on rkrm example libraries/asl/filereq.e
PROC filerequester(save) HANDLE
	DEF fr : PTR TO filerequester, s = NIL
	IF fr := AllocAslRequest(ASL_FILEREQUEST,
	          NEW [ ASL_HAIL,             'cha_stanley',
	                ASLFR_SCREEN,         screen,
	                ASL_OKTEXT,           IF save THEN 'Save' ELSE 'Load',
	                ASL_CANCELTEXT,       'Cancel',
	                ASLFR_DOSAVEMODE,     save,
	                ASL_DIR,              'RAM:',
	                ASL_FILE,             '',
	                ASLFR_INITIALPATTERN, '#?.stanley',
	                ASLFR_DOPATTERNS,     TRUE,
	                NIL
	              ])
		IF AslRequest(fr, NIL)
			s := String(1024)
			StrCopy(s, fr.drawer)
			IF AddPart(s, fr.file, 1024) = 0
				DisposeLink(s)
				s := NIL
			ENDIF
		ENDIF
	ELSE
		displayerror('Couldn''t create file requester', '(out of memory?)')
	ENDIF
EXCEPT DO
	IF fr THEN FreeAslRequest(fr)
ENDPROC s

PROC displayerror(text1, text2)
	easyguiA('cha_stanley',
	        NEW [ ROWS,
	            NEW [ TEXT, text1, 0,0,1 ],
	            NEW [ TEXT, text2, 0,0,1 ],
	            NEW [ BUTTON, 0, 'Cancel' ]
	        ],
	        NEW [ EG_SCRN, screen, EG_WTYPE, WTYPE_NOSIZE, NIL ])
ENDPROC

/** 2.4 **/

/*=========================================================================*/

-> fixed
PROC oss_update(on)
	IF on
		oss('ed_setdata_update on')
		oss('ed_setdata_update')
	ELSE
		oss('ed_setdata_update off')
	ENDIF
ENDPROC

/*=========================================================================*/

PROC main() HANDLE
	DEF stanley = NIL : PTR TO stanley
	    /* + + + screen made global + + + */
	oss_init()
	screen := LockPubScreen('OCTAMED') -> fall back to default screen
	/** 2.4 **/
	aslbase := OpenLibrary('asl.library', 38)
	IF aslbase = NIL THEN Raise("ASL")
	/** 2.4 **/
	NEW stanley.new()
	/* + + + */
	-> tags made NEW (for residentablity, but nsm isn't...), version moved
	easyguiA(stanley.g_title,
	/* + + + */
	        stanley.g_gui,
	        NEW [   EG_INFO,    stanley,
	                EG_GHVAR,   stanley + 4,    -> OFFSETOF stanley.gh
	                EG_CLOSE,   {a_button_close},
	                EG_SCRN,    screen,
	                NIL
	            ])
EXCEPT DO
	END stanley
	/** 2.4 **/
	IF aslbase THEN CloseLibrary(aslbase)
	/** 2.4 **/
	oss_cleanup()
	IF screen THEN UnlockPubScreen(NIL, screen)
	/* - - - */
	-> Error reporting!
	SELECT exception
	/** 2.4 **/
	CASE "ASL";  WriteF('*** Error: can''t open "asl.library" v38\n')
	/** 2.4 **/
	CASE "GT";   WriteF('*** Error: can''t open "gadtools.library" (out of memory?)\n')
	CASE "GUI";  WriteF('*** Error: can''t create gui (out of memory?)\n')
	CASE "bigg"; WriteF('*** Error: gui too big for screen (select smaller font)\n')
	DEFAULT;     printerror(exception, exceptioninfo)
	ENDSELECT
	/* - - - */
ENDPROC IF exception THEN 5 ELSE 0

/*--------------------------------------------------------------------------+
| END: cha_stanley.e                                                        |
+==========================================================================*/
