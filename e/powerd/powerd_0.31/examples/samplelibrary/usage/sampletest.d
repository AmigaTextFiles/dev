MODULE	'sample'

DEF	SampleBase

PROC main()
	IF SampleBase:=OpenLibrary('sample.library',0)
		PrintF('\d-\d=\d\n',100,40,Subtract(100,40))
		CloseLibrary(SampleBase)
	ELSE PrintF('no sample.library!\n')
ENDPROC
