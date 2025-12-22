;
; Skript zum Erzeugen einer IndexDatei (Oberon:OHF) aus mehreren Verzeichnissen
; Vorher wird die alte Datei nach Oberon:OHF.old umbenannt und zum
; Schluß gelöscht.

ASK "Bist du bereit zum Erstellen einer neuen IndexDatei für OOL (y/N)?"

IF NOT WARN 
   ECHO "Na dann vielleicht nächstes Mal."
   QUIT
ENDIF

Rename Oberon:OHF Oberon:OHF.old; altes OHF File umbenennen

List  >T:MakeOHF.tmp Oberon:Interfaces/#?.mod LFORMAT "COOLFiles %s%s Oberon:OHF"
List >>T:MakeOHF.tmp Oberon:Module/#?.mod     LFORMAT "COOLFiles %s%s Oberon:OHF"
; hier könnte ihr noch weitere Verzeichnisse anfügen!

Resident Oberon:COOLFiles  ; COOLFiles resident machen damit's schneller geht
Execute T:MakeOHF.tmp 	   ; das könnte 'ne Weile dauern...
Delete T:MakeOHF.tmp
Resident COOLFiles REMOVE  ; und wieder entfernen
Delete Oberon:OHF.old      ; alte Datei löschen
