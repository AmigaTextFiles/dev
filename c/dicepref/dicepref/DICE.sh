failat 21
mount null:
Echo "Mache Assigns für DICE..."
assign DCC: $DCC
assign DLIB: $DLIB
assign DINCLUDE: $DINCLUDE
assign DTMP: $DTMP
Echo "Gehe in das Source-Verzeichnis..."
cd dcc:src
Echo "Lade AmigaGuide..."
rxlib amigaguide.library 0 -30 0
;Echo "Lade die Cross-Referenzen für AmigaGuide..."
;rx "LoadXRef(autodoc.xref)"
Echo "Starte Turbotext..."
run Turbotext:TTX
Echo "Fertig!"
