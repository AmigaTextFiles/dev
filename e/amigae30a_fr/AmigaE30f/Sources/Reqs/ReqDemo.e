/* Une autre démo pour savoir comment utiliser des bibliothèques en E.
   Une requête de la req.library.                                      */

MODULE 'Req'

PROC main()
  IF reqbase:=OpenLibrary('req.library',2)
    IF request('C'est une requête standard ...','Positif','Négatif')
      request('Je l\aavais deviné ...','Pour sûr!','Ben voyons!')
    ELSE
      request('Soyez plus positif!','J\aessaie','Pourquoi?')
    ENDIF
    CloseLibrary(reqbase)
  ELSE
    WriteF('Ne peut ouvrir la req.library!\n')
  ENDIF
ENDPROC

PROC request(messy,yes,no)
ENDPROC TextRequest([messy,0,0,0,yes,no,'Hein?',0,0,$2FFFF,0,0])
