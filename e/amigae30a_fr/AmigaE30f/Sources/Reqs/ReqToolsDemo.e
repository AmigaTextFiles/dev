/* Encore une autre démo pour utiliser d'autres bibliothèques en E.
   Maintenant, on le fait avec la reqtools.library.                */

MODULE 'ReqTools'

CONST FILEREQ=0,REQINFO=1

DEF colour,num=10,buf[120]:STRING,req

PROC main()
  IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
    RtEZRequestA('Allons tester cette simple ReqTools library, OK ?',
      'Pourquoi?|Pas encore|Oui! Voyons ça!',0,0,0)
    IF (colour:=RtPaletteRequestA('Choisissez vos couleurs:',0,0))=-1
      RtEZRequestA('Difficile à choisir, hein ?','Ouaip.',0,0,0)     /* requête couleur */
    ELSE
      RtEZRequestA('Vous aimez vraiment la couleur \d ?','Que dalle|Voui!',0,[colour],0)
    ENDIF
    RtEZRequestA('Maintenant une entrée ...','Quoi?',0,0,0)
    RtGetLongA({num},'Entrez un nombre :',0,0)                   /* requête long */
    StrCopy(buf,'bla',ALL)
    RtGetStringA(buf,100,'Entrez n\aimporte quoi:',0,0)           /* requête chaine */
    RtEZRequestA('C\aest parti pour une chouette requête de fichier...',
      'Encore!encore!|Bof!',0,0,0)
    IF req:=RtAllocRequestA(FILEREQ,0)
      buf[0]:=0
      RtFileRequestA(req,buf,'Choisissez vos fichiers:',0)
      RtFreeRequest(req)
    ENDIF
    RtEZRequestA('C\aest çà.','Phew.',0,0,0)
    CloseLibrary(reqtoolsbase)
  ELSE
    WriteF('Ne peut ouvrir la reqtools.library!\n')
  ENDIF
ENDPROC
