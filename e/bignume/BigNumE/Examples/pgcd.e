/*
** PGCD - Find two BigNums GCD (Greatest Common Divisor)
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

#define	TEMPLATE 'Number1/A, Number2/A'
#define TXT 'Two Numbers !\n'
#define WARN 'Needs BigNum.library 37 !!\n'

PROC main()
	DEF tr:PTR TO timerequest, rdargs, opts:PTR TO LONG, aa:PTR TO timeval, bb:PTR TO timeval,
	x:PTR TO bignum, y:PTR TO bignum, z:PTR TO bignum

	IF bignumbase:=OpenLibrary('BigNum.library', 37)
		NEW tr, aa, bb
		IF OpenDevice('timer.device', UNIT_MICROHZ, tr, 0)=0
			timerbase:=tr.io.device
			opts:=[0, 0]
			IF rdargs:=ReadArgs(TEMPLATE, opts, 0)
				x:=BigNumInit()
				y:=BigNumInit()
				z:=BigNumInit()
				BigNumStrToBigNum(x, opts[0])
				BigNumStrToBigNum(y, opts[1])
				GetSysTime(aa)
				BigNumPgcd(x,y,z)
				GetSysTime(bb)
				SubTime(bb,aa)
				BigNumPrint(z)
				PrintF('\n(\d.\d[05] s)\n\n', bb.secs, bb.micro)
				BigNumFree(3)
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
