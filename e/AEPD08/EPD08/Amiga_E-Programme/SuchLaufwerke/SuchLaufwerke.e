MODULE 'dos/dos', 'dos/dosextens'

/* das folgende kleine Programm durchsucht die DosListe nach Laufwerken */

PROC main()
DEF diedosliste, listeneintrag:PTR TO doslist

  diedosliste := LockDosList(LDF_ALL OR LDF_READ)
  IF diedosliste /* konnte gesperrt werden */
	listeneintrag := FindDosEntry(diedosliste, 'DF0',LDF_ALL OR LDF_READ)
	IF listeneintrag THEN WriteF('DF0 vorhanden!\n') ELSE WriteF('kein DF0\n')

	listeneintrag := FindDosEntry(diedosliste, 'DF1',LDF_ALL OR LDF_READ)
	IF listeneintrag THEN WriteF('DF1 vorhanden!\n') ELSE WriteF('kein DF1\n')

	listeneintrag := FindDosEntry(diedosliste, 'DF2',LDF_ALL OR LDF_READ)
	IF listeneintrag THEN WriteF('DF2 vorhanden!\n') ELSE WriteF('kein DF2\n')

	listeneintrag := FindDosEntry(diedosliste, 'DF3',LDF_ALL OR LDF_READ)
	IF listeneintrag THEN WriteF('DF3 vorhanden!\n') ELSE WriteF('kein DF3\n')

	UnLockDosList(LDF_ALL OR LDF_READ)
  ENDIF
  
ENDPROC
