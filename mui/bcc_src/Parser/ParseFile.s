
; Storm C Compiler
; Twardziel:My/Sources/StormC/Parser/ParseFile.cpp
	mc68020

	XREF	_0dt__Prf__T
	XREF	Free__InsertFile__T
	XREF	_0ct__TextItem__TPcs
	XREF	_0dt__Family__T
	XREF	isValid__ValidFile__TPcPc
	XREF	_0dt__Replace__T
	XREF	_0dt__repdat__T
	XREF	_memcpy
	XREF	_strlen
	XREF	_strcmp
	XREF	_strcpy
	XREF	_fwrite
	XREF	_printf
	XREF	_fclose
	XREF	_fopen
	XREF	_fgets
	XREF	_std__in
	XREF	_std__out
	XREF	_std__err
	XREF	_ClassList
	XREF	_ins_every
	XREF	_ins_header
	XREF	_ins_code
	XREF	_ins_initcl
	XREF	_Prefs

	SECTION ":0",CODE


	XDEF	_INIT_8_ParseFile_cpp
_INIT_8_ParseFile_cpp
L49	EQU	0
	link	a5,#L49
L48
	move.l	a4,a0
;static const unsigned char ParseTab[ 130 ] = {
	lea	_ParseTab(a4),a0
	add.w	#$81,a0
	unlk	a5
	rts

;short ParseFile::Open( char *name, short force, short scanonly )
	XDEF	Open__ParseFile__TPcss
Open__ParseFile__TPcss
L80	EQU	-$20E
	link	a5,#L80
	movem.l	d2/d3/a2,-(a7)
	move.w	$12(a5),d2
	move.w	$10(a5),d3
L57
	move.l	a4,a0
;	created = 0;
	move.l	$8(a5),a0
	clr.w	$10(a0)
;	fh = fopen( name, "r" );
	move.l	#L50,-(a7)
	move.l	$C(a5),-(a7)
	jsr	_fopen
	addq.w	#$8,a7
	move.l	$8(a5),a1
	move.l	d0,(a1)
;	if( !fh ) 
	move.l	$8(a5),a0
	move.l	(a0),a0
	cmp.w	#0,a0
	bne.b	L59
L58
;	if( !fh ) printf( "Fail to open %s\n", name );
	move.l	$C(a5),-(a7)
	move.l	#L51,-(a7)
	jsr	_printf
	addq.w	#$8,a7
L59
;	if( fh ) 
	move.l	$8(a5),a0
	move.l	(a0),a0
	cmp.w	#0,a0
	beq	L79
L60
;	if( fh ) 
;		strcpy( fname, name );
	move.l	$C(a5),-(a7)
	move.l	$8(a5),a1
	lea	$16(a1),a0
	move.l	a0,-(a7)
	jsr	_strcpy
	addq.w	#$8,a7
;		strcpy( sfname, name );
	move.l	$C(a5),-(a7)
	move.l	$8(a5),a1
	lea	$52(a1),a0
	move.l	a0,-(a7)
	jsr	_strcpy
	addq.w	#$8,a7
;		for( p = sfname + strlen( sfname ) -1 ;
	move.l	$8(a5),a0
	lea	$52(a0),a2
	move.l	$8(a5),a1
	lea	$52(a1),a0
	move.l	a0,-(a7)
	jsr	_strlen
	addq.w	#4,a7
	add.l	d0,a2
	subq.w	#1,a2
	move.l	a2,a1
	bra.b	L62
L61
	move.l	a1,a0
	subq.w	#1,a1
L62
	move.l	$8(a5),a2
	lea	$52(a2),a0
	cmp.l	a0,a1
	blo.b	L64
L63
	move.b	(a1),d0
	cmp.b	#$2E,d0
	bne.b	L61
L64
;		if( p != sfname ) 
	move.l	$8(a5),a2
	lea	$52(a2),a0
	cmp.l	a0,a1
	beq.b	L66
L65
;		if( p != sfname ) *p = 0;
	clr.b	(a1)
L66
;		strcpy( ofname, sfname );
	move.l	$8(a5),a1
	lea	$52(a1),a0
	move.l	a0,-(a7)
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.l	a0,-(a7)
	jsr	_strcpy
	addq.w	#$8,a7
;		a = strlen( ofname );
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.l	a0,-(a7)
	jsr	_strlen
	addq.w	#4,a7
;		ofname[ a ] = '.';
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.w	d0,d1
	ext.l	d1
	add.l	d1,a0
	move.b	#$2E,(a0)
;		strcpy( ofname + a + 1, sfname + a + 2 );
	move.l	$8(a5),a1
	lea	$52(a1),a0
	move.w	d0,d1
	ext.l	d1
	add.l	d1,a0
	addq.w	#2,a0
	move.l	a0,-(a7)
	move.l	$8(a5),a1
	lea	$34(a1),a0
	ext.l	d0
	add.l	d0,a0
	addq.w	#1,a0
	move.l	a0,-(a7)
	jsr	_strcpy
	addq.w	#$8,a7
;		if( !Prefs.forcetrans && ((!force && vf.isValid( name, ofname ))
	lea	_Prefs(a4),a0
	move.w	$20(a0),d0
	bne.b	L73
L67
	tst.w	d3
	bne.b	L69
L68
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.l	a0,-(a7)
	move.l	$C(a5),-(a7)
	lea	-$20E(a5),a0
	move.l	a0,-(a7)
	jsr	isValid__ValidFile__TPcPc
	add.w	#$C,a7
	tst.w	d0
	bne.b	L70
L69
	tst.w	d2
	beq.b	L73
L70
;orce && vf.isVali
;			strcpy( ofname, "NIL:" );
	move.l	#L52,-(a7)
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.l	a0,-(a7)
	jsr	_strcpy
	addq.w	#$8,a7
;			if( Prefs.verbose ) 
	lea	_Prefs(a4),a0
	move.w	$1C(a0),d0
	beq.b	L76
L71
;			if( Prefs.verbose ) printf( "Scanning \"%s
	move.l	$C(a5),-(a7)
	move.l	#L53,-(a7)
	jsr	_printf
	addq.w	#$8,a7
L72
	bra.b	L76
L73
; else 
;			if( Prefs.verbose ) 
	lea	_Prefs(a4),a0
	move.w	$1C(a0),d0
	beq.b	L75
L74
;			if( Prefs.verbose ) printf( "Translating \
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.l	a0,-(a7)
	move.l	$C(a5),-(a7)
	move.l	#L54,-(a7)
	jsr	_printf
	add.w	#$C,a7
L75
;			created = 1;
	move.l	$8(a5),a0
	move.w	#1,$10(a0)
L76
;		if( !(ofh = fopen( ofname, "w" )) ) 
	move.l	#L55,-(a7)
	move.l	$8(a5),a1
	lea	$34(a1),a0
	move.l	a0,-(a7)
	jsr	_fopen
	addq.w	#$8,a7
	move.l	$8(a5),a1
	move.l	d0,$12(a1)
	bne.b	L78
L77
;		if( !(ofh = fopen( ofname, "
;			printf( "Can not open output file\n" );
	move.l	#L56,-(a7)
	jsr	_printf
	addq.w	#4,a7
;			Close();
	move.l	$8(a5),-(a7)
	jsr	Close__ParseFile__T
	addq.w	#4,a7
;			return 0;
	moveq	#0,d0
	movem.l	(a7)+,d2/d3/a2
	unlk	a5
	rts
L78
;		TokStart = TokLen = 0;
	move.l	$8(a5),a0
	clr.w	$D6(a0)
	move.l	$8(a5),a0
	clr.w	$D4(a0)
;		LineBuf[0] = 0;
	move.l	$8(a5),a1
	lea	$DA(a1),a0
	lea	(a0),a0
	clr.b	(a0)
;		LineN = 0;
	move.l	$8(a5),a0
	clr.l	4(a0)
;		SBracket = CBracket = MBracket = 0;
	move.l	$8(a5),a0
	clr.w	$4DC(a0)
	move.l	$8(a5),a0
	clr.w	$4DE(a0)
	move.l	$8(a5),a0
	clr.w	$4E0(a0)
;		comment = 0;
	move.l	$8(a5),a0
	clr.w	$C(a0)
;		ErrorBuf = 0;
	move.l	$8(a5),a0
	clr.w	$E(a0)
;		copy = 1;
	move.l	$8(a5),a0
	move.w	#1,$8(a0)
; startcopy = 0;
	move.l	$8(a5),a0
	clr.w	$A(a0)
;		return 1;
	moveq	#1,d0
	movem.l	(a7)+,d2/d3/a2
	unlk	a5
	rts
L79
;	return 0;
	moveq	#0,d0
	movem.l	(a7)+,d2/d3/a2
	unlk	a5
	rts

;void ParseFile::Close( void )
	XDEF	Close__ParseFile__T
Close__ParseFile__T
L86	EQU	0
	link	a5,#L86
	movem.l	a2,-(a7)
	move.l	$8(a5),a2
L81
	move.l	a4,a0
;	if( fh ) 
	move.l	a2,a0
	move.l	(a0),a0
	cmp.w	#0,a0
	beq.b	L83
L82
;	if( fh ) 
;		fclose( fh );
	move.l	a2,a0
	move.l	(a0),a0
	move.l	a0,-(a7)
	jsr	_fclose
	addq.w	#4,a7
;		fh = 0;
	clr.l	(a2)
L83
;	if( ofh ) 
	move.l	a2,a0
	move.l	$12(a0),a0
	cmp.w	#0,a0
	beq.b	L85
L84
;	if( ofh ) 
;		fclose( ofh );
	move.l	a2,a0
	move.l	$12(a0),a0
	move.l	a0,-(a7)
	jsr	_fclose
	addq.w	#4,a7
;		ofh = 0;
	clr.l	$12(a2)
L85
	movem.l	(a7)+,a2
	unlk	a5
	rts

;ParseFile::~ParseFile()
	XDEF	_0dt__ParseFile__T
_0dt__ParseFile__T
L88	EQU	0
	link	a5,#L88
	move.l	$8(a5),a1
L87
	move.l	a4,a0
;	Close();
	move.l	a1,-(a7)
	jsr	Close__ParseFile__T
	addq.w	#4,a7
	unlk	a5
	rts

;ParseFile::ParseFile( void )
	XDEF	_0ct__ParseFile__T
_0ct__ParseFile__T
L90	EQU	0
	link	a5,#L90
	move.l	$8(a5),a1
L89
	move.l	a4,a0
;	fh = ofh = 0;
	clr.l	$12(a1)
	clr.l	(a1)
	unlk	a5
	rts

;void ParseFile::GetToken( void )
	XDEF	GetToken__ParseFile__T
GetToken__ParseFile__T
L152	EQU	-$A
	link	a5,#L152
	movem.l	d2/a2,-(a7)
	move.l	$8(a5),a2
L92
	move.l	a4,a0
;	if( TokLen ) 
	move.l	a2,a0
	move.w	$D6(a0),d0
	beq.b	L94
L93
;	if( TokLen ) 
;		memcpy( PrevTok, Tok, TokLen );
	move.l	a2,a0
	move.w	$D6(a0),d0
	ext.l	d0
	move.l	d0,-(a7)
	lea	$DA(a2),a0
	move.l	a2,a1
	move.w	$D4(a1),d0
	ext.l	d0
	add.l	d0,a0
	move.l	a0,-(a7)
	lea	$70(a2),a0
	move.l	a0,-(a7)
	jsr	_memcpy
	add.w	#$C,a7
;		PrevTok[TokLen] = 0;
	lea	$70(a2),a0
	move.l	a2,a1
	move.w	$D6(a1),d0
	ext.l	d0
	add.l	d0,a0
	clr.b	(a0)
;		PrevType = TokType;
	move.l	a2,a0
	move.b	$D8(a0),d0
	move.b	d0,$D9(a2)
	bra.b	L96
L94
; else PrevTok[0] = 0;
	lea	$70(a2),a0
	lea	(a0),a0
	clr.b	(a0)
L95
L96
;	if( copy ) 
	move.l	a2,a0
	move.w	$8(a0),d0
	beq.b	L102
L97
;	if( copy ) 
;		if( TokLen ) 
	move.l	a2,a0
	move.w	$D6(a0),d0
	beq.b	L102
L98
;		if( TokLen ) 
;			if( fwrite( Tok, 1, TokLen, ofh ) != TokLen ) 
	move.l	a2,a0
	move.l	$12(a0),a0
	move.l	a0,-(a7)
	move.l	a2,a0
	move.w	$D6(a0),d0
	ext.l	d0
	move.l	d0,-(a7)
	pea	1.w
	lea	$DA(a2),a0
	move.l	a2,a1
	move.w	$D4(a1),d0
	ext.l	d0
	add.l	d0,a0
	move.l	a0,-(a7)
	jsr	_fwrite
	add.w	#$10,a7
	move.l	a2,a0
	move.w	$D6(a0),d1
	ext.l	d1
	cmp.l	d1,d0
	beq.b	L102
L99
;			if( fwrite( Tok,
;				printf( "IO Error\n" );
	move.l	#L91,-(a7)
	jsr	_printf
	addq.w	#4,a7
L100
L101
L102
;	if( startcopy ) 
	move.l	a2,a0
	move.w	$A(a0),d0
	beq.b	L104
L103
;	if( startcopy ) 
; copy = 1;
	move.w	#1,$8(a2)
; startcopy = 0;
	clr.w	$A(a2)
L104
;	TokStart += TokLen;
	move.l	a2,a0
	move.w	$D6(a0),d0
	move.w	$D4(a2),d1
	add.w	d0,d1
	move.w	d1,$D4(a2)
;	TokLen = 0;
	clr.w	$D6(a2)
;	if( !LineBuf[ TokStart ] ) 
	lea	$DA(a2),a0
	move.l	a2,a1
	move.w	$D4(a1),d0
	ext.l	d0
	add.l	d0,a0
	move.b	(a0),d0
	bne.b	L108
L105
;	if( !LineBuf[ TokStart ] ) 
;		if( !fgets( LineBuf, MAXLINE, fh ) ) 
	move.l	a2,a0
	move.l	(a0),a0
	move.l	a0,-(a7)
	pea	$400.w
	lea	$DA(a2),a0
	move.l	a0,-(a7)
	jsr	_fgets
	add.w	#$C,a7
	tst.l	d0
	bne.b	L107
L106
;		if( !fgets( LineBuf, MAXLIN
	movem.l	(a7)+,d2/a2
	unlk	a5
	rts
L107
;		LineN++;
	move.l	4(a2),d0
	addq.l	#1,d0
	move.l	d0,4(a2)
;		TokStart = 0;
	clr.w	$D4(a2)
L108
;	p = ps = LineBuf + TokStart;
	lea	$DA(a2),a0
	move.l	a2,a1
	move.w	$D4(a1),d0
	ext.l	d0
	add.l	d0,a0
	move.l	a0,-$8(a5)
	move.l	-$8(a5),a1
;	TokType = ParseTab[ *p ];
	lea	_ParseTab(a4),a0
	move.b	(a1),d0
	extb.l	d0
	add.l	d0,a0
	move.b	(a0),d0
	move.b	d0,$D8(a2)
;	char prevch = 0;
	moveq	#0,d2
;	if( *p == '"' && !comment ) 
	move.b	(a1),d0
	cmp.b	#$22,d0
	bne	L134
L109
	move.l	a2,a0
	move.w	$C(a0),d0
	bne	L134
L110
;	if( *p == '"' && !comment ) 
;		while( 1 ) 
L111
;		while( 1 ) 
;			p++;
	move.l	a1,a0
	addq.w	#1,a1
;			if( *p == '"' && *(p-1) != '\\' ) 
	move.b	(a1),d0
	cmp.b	#$22,d0
	bne.b	L114
L112
	lea	-1(a1),a0
	move.b	(a0),d0
	cmp.b	#$5C,d0
	beq.b	L114
L113
;			if( *p == '"' && *(p-1) != '
; p++;
	move.l	a1,a0
	addq.w	#1,a1
; 
	bra	L138
L114
;			if( !*p ) 
	move.b	(a1),d0
	bne.b	L111
L115
;			if( !*p ) 
	bra	L138
L116
L117
	bra.b	L111
L118
	bra	L138
L119
;	while( ParseTab[ *p ] == TokType && *p ) 
	bra	L134
L120
;	while( ParseTab[ *p ] == 
;		if( TokType == CNT ) 
	move.l	a2,a0
	move.b	$D8(a0),d0
	cmp.b	#$20,d0
	bne.b	L131
L121
;		if( TokType == CNT ) 
;			if( prevch == '/' ) 
	cmp.b	#$2F,d2
	bne.b	L127
L122
;			if( prevch == '/' ) 
;				if( *p == '*' ) 
	move.b	(a1),d0
	cmp.b	#$2A,d0
	bne.b	L124
L123
;				if( *p == '*' ) comment++;
	move.w	$C(a2),d0
	addq.w	#1,d0
	move.w	d0,$C(a2)
L124
;				if( *p == '/' ) 
	move.b	(a1),d0
	cmp.b	#$2F,d0
	bne.b	L127
L125
;				if( *p == '/' ) 
;					TokLen = 0;
	clr.w	$D6(a2)
;					TokStart = strlen( LineBuf );
	lea	$DA(a2),a0
	move.l	a0,-(a7)
	jsr	_strlen
	addq.w	#4,a7
	move.w	d0,$D4(a2)
;					goto 
	bra	L96
L126
L127
;			if( prevch == '*' && *p == '/' ) 
	cmp.b	#$2A,d2
	bne.b	L130
L128
	move.b	(a1),d0
	cmp.b	#$2F,d0
	bne.b	L130
L129
;			if( prevch == '*' && *p == '/
	move.w	$C(a2),d0
	subq.w	#1,d0
	move.w	d0,$C(a2)
L130
;			prevch = *p;
	move.b	(a1),d0
	move.b	d0,d2
L131
;		p++;
	move.l	a1,a0
	addq.w	#1,a1
;		if( ParseTab[ *p ] == BRC ) 
	lea	_ParseTab(a4),a0
	move.b	(a1),d0
	extb.l	d0
	add.l	d0,a0
	move.b	(a0),d0
	cmp.b	#4,d0
	bne.b	L134
L132
;		if( ParseTab[ *p ] == BRC ) 
	bra.b	L138
L133
L134
	lea	_ParseTab(a4),a0
	move.b	(a1),d0
	extb.l	d0
	add.l	d0,a0
	move.b	(a0),d0
	move.l	a2,a0
	move.b	$D8(a0),d1
	cmp.b	d1,d0
	bne.b	L138
L135
	move.b	(a1),d0
	bne	L120
L136
L137
L138
;	TokLen = (short)(p - ps);
	move.l	a1,d0
	sub.l	-$8(a5),d0
	move.w	d0,$D6(a2)
;	if( TokType == BRC && !comment) 
	move.l	a2,a0
	move.b	$D8(a0),d0
	cmp.b	#4,d0
	bne	L148
L139
	move.l	a2,a0
	move.w	$C(a0),d0
	bne	L148
L140
;	if( TokType == BRC && !comment) 
;		switch( *Tok )
	lea	$DA(a2),a0
	move.l	a2,a1
	move.w	$D4(a1),d0
	ext.l	d0
	add.l	d0,a0
	move.b	(a0),d0
	cmp.b	#$5D,d0
	beq	L146
	bgt.b	L153
	cmp.b	#$29,d0
	beq.b	L144
	bgt.b	L154
	cmp.b	#$28,d0
	beq.b	L143
	bra	L148
L154
	cmp.b	#$5B,d0
	beq	L145
	bra	L148
L153
	cmp.b	#$7B,d0
	beq.b	L141
	cmp.b	#$7D,d0
	beq.b	L142
	bra	L148
;		switch( *Tok ) 
;			
L141
;': MBracket++;
	move.w	$4DC(a2),d0
	addq.w	#1,d0
	move.w	d0,$4DC(a2)
; 
	bra.b	L148
L142
;': MBracket--;
	move.w	$4DC(a2),d0
	subq.w	#1,d0
	move.w	d0,$4DC(a2)
; 
	bra.b	L148
L143
;			case '(': CBracket++;
	move.w	$4DE(a2),d0
	addq.w	#1,d0
	move.w	d0,$4DE(a2)
; 
	bra.b	L148
L144
;			case ')': CBracket--;
	move.w	$4DE(a2),d0
	subq.w	#1,d0
	move.w	d0,$4DE(a2)
; 
	bra.b	L148
L145
;			case '[': SBracket++;
	move.w	$4E0(a2),d0
	addq.w	#1,d0
	move.w	d0,$4E0(a2)
; 
	bra.b	L148
L146
;			case ']': SBracket--;
	move.w	$4E0(a2),d0
	subq.w	#1,d0
	move.w	d0,$4E0(a2)
; 
L147
L148
;	if( TokType == SEP || comment ) 
	move.l	a2,a0
	move.b	$D8(a0),d0
	cmp.b	#1,d0
	beq	L96
L149
	move.l	a2,a0
	move.w	$C(a0),d0
	beq.b	L151
L150
;	if( TokType == SEP || comment ) go
	bra	L96
L151
	movem.l	(a7)+,d2/a2
	unlk	a5
	rts

;void ParseFile::StartCopy( void )
	XDEF	StartCopy__ParseFile__T
StartCopy__ParseFile__T
L156	EQU	0
	link	a5,#L156
	move.l	$8(a5),a1
L155
	move.l	a4,a0
;	startcopy = 1;
	move.w	#1,$A(a1)
	unlk	a5
	rts

;void ParseFile::StopCopy( void )
	XDEF	StopCopy__ParseFile__T
StopCopy__ParseFile__T
L158	EQU	0
	link	a5,#L158
	move.l	$8(a5),a1
L157
	move.l	a4,a0
;	copy = 0;
	clr.w	$8(a1)
	unlk	a5
	rts

L56
	dc.b	'Can not open output file',$A,0
L51
	dc.b	'Fail to open %s',$A,0
L91
	dc.b	'IO Error',$A,0
L52
	dc.b	'NIL:',0
L53
	dc.b	'Scanning "%s"',$A,0
L54
	dc.b	'Translating "%s" into "%s"',$A,0
L50
	dc.b	'r',0
L55
	dc.b	'w',0

	SECTION ":1",DATA

_ParseTab
	dc.b	0,0,0,0,0,0,0,0
	dc.b	0,1,1,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0
	dc.b	1,0,2,0,0,0,0,0
	dc.b	4,4,$20,$10,$10,$10,$10,$20
	dc.b	2,2,2,2,2,2,2,2
	dc.b	2,2,$10,$10,$10,$10,$10,0
	dc.b	0,2,2,2,2,2,2,2
	dc.b	2,2,2,2,2,2,2,2
	dc.b	2,2,2,2,2,2,2,2
	dc.b	2,2,2,4,0,4,0,2
	dc.b	0,2,2,2,2,2,2,2
	dc.b	2,2,2,2,2,2,2,2
	dc.b	2,2,2,2,2,2,2,2
	dc.b	2,2,2,4,0,4,2,0
	dc.b	0,0

	END
