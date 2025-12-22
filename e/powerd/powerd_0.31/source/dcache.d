// dcache.d - dmodule cache flushing and showing tool

MODULE	'exec/semaphores'

ENUM	FLUSH,SHOW

PROC main()
	DEF	ra,args=[0,0,0]:LONG,vers='$VER:DCache v1.0 by MarK (12.1.2000)\n'
	IF ra:=ReadArgs('F=FLUSH/S,S=SHOW/S',args,NIL)
		PrintF(vers+5)

		DEF	cache:PTR TO cache,module:PTR TO cachedmodule,cnt,len,old:PTR TO cachedmodule
		IF cache:=FindSemaphore('DModuleCache')
			ObtainSemaphore(cache)
			module:=cache.modlist
			cnt:=len:=0
			WHILE module
				cnt++
				len+=module.length+SIZEOF_cachedmodule
				old:=module
				IF args[SHOW]
					PrintF('\l\s[50]: \d[6] bytes, \s\n',module.name,module.length,IF module.binary THEN 'binary' ELSE 'ascii')
				ENDIF
				module:=.next
				IF args[FLUSH]
					FreeVec(old.file)
					FreeVec(old)
				ENDIF
			ENDWHILE
			IF args[FLUSH] THEN cache.modlist:=NIL
			IF cnt
				PrintF('Cached modules: \d, occupied memory: \d\n',cnt,len)
			ELSE
				PrintF('Cache is empty.\n')
			ENDIF
			ReleaseSemaphore(cache)
		ENDIF
		FreeArgs(ra)
	ENDIF
ENDPROC

OBJECT cache OF SignalSemaphore
	modlist:PTR TO cachedmodule

OBJECT cachedmodule
	next:PTR TO cachedmodule,
	name[80]:CHAR,					// relative name
	fullname[200]:CHAR,			// full file name
	file:PTR TO CHAR,
	length:LONG,
	binary:BOOL
