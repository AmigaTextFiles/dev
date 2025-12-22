MODULE 'tempest1', 'user','exec/ports','amigalib/ports','exec/nodes'

DEF send:mymessage, systemdata:PTR TO systemdata, user:PTR TO user,
    nodedata:PTR TO nodedata, today:PTR TO todayx, msg:PTR TO mymessage,
    myport:PTR TO mp, tempestport:PTR TO mp

PROC main()
   IF doorstart(arg) = FALSE THEN CleanUp(20)

   pl('Hello world. ;)')

   closestuff()
ENDPROC
