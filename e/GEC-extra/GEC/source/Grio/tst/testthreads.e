MODULE 'grio/threads'
MODULE 'exec/nodes'

PROC main()
DEF ths:PTR TO threads
NEW ths
WriteF('Hey this is main process\n')
Delay(100)
WriteF('Starting first thread\n')
Delay(50)
ths.launch(ths.init({thproc},NIL),'argument for threads 1')
Delay(100)
WriteF('Starting second thread\n')
Delay(50)
ths.launch(ths.init({thproc},NIL),'argument for threads 2')
WHILE ths.islaunched() DO Delay(10)
END ths
WriteF('Main process again , goodby ...\n')
ENDPROC


PROC thproc(txt)
DEF ln:PTR TO ln
ln:=FindTask(NIL)
WriteF('Hello ! This thread "\s" ,argument "\s"!\n',ln.name,txt)
Delay(500)
WriteF('Here\as again thread "\s" i\am finishing work\n',ln.name)
ENDPROC

