// simpliest example ever.

OPT	DOSONLY	// open dos.library only.

PROC main()
	DEF	a=2:W,b=3:L
	PrintF('Hello World!\n')
	a+=b
	b:=print()
	PrintF('Hello World! (\d)\n',a)
	IF a<5
		a:=5
	ELSE
		SELECT b
		CASE 2;	PrintF('1\n')
		CASE 4;	PrintF('3\n')
		CASE 3
			PrintF('2\n')
		ENDSELECT
	ENDIF
ENDPROC

PROC print(a=3)(L)
	a++
	PrintF('Yeah!\n')

	DEF	x:PTR TO xxx,y:xxx
	x:=[1,2,3]:xxx
	y.a:=1
	y.b:=2
	y.c:=3

ENDPROC a

OBJECT	xxx
	a,b,c:W
