/*
** LUCAS - Perform a Lucas Lehmer test.
**
** Author:        Allebrand Brice
** E translation: Maciej Plewa
*/

OPT PREPROCESS

MODULE	'exec/memory',
		'exec/io',
		'bignum',
		'libraries/bignum',
		'timer',
		'devices/timer'

#define	TEMPLATE 'Lucas exposant/A'
#define TXT 'I need an exposant !\n'
#define WARN 'Needs BigNum.library 37 !!\n'

PROC main()
	DEF tr:PTR TO timerequest, rdargs, opts:PTR TO LONG, aa:PTR TO timeval, bb:PTR TO timeval,
	ret

	IF bignumbase:=OpenLibrary('BigNum.library', 37)
		NEW tr, aa, bb
		IF OpenDevice('timer.device', UNIT_MICROHZ, tr, 0)=0
			timerbase:=tr.io.device
			opts:=[0]
			IF rdargs:=ReadArgs(TEMPLATE, opts, 0)
				GetSysTime(aa)
				ret:=BigNumLucasLehmer(Val(opts[0]))
				GetSysTime(bb)
				SubTime(bb,aa)
				PrintF('\n(\d.\d[05] s)\n\n', bb.secs, bb.micro)
				IF ret
					PrintF('Prime\n')
				ELSE
					PrintF('Not Prime\n')
				ENDIF
				FreeArgs(rdargs)
			ELSE
				PrintF(TXT)
			ENDIF
			CloseDevice(tr)
		ENDIF
		CloseLibrary(bignumbase)
	ELSE
		PrintF(WARN)
	ENDIF
ENDPROC
