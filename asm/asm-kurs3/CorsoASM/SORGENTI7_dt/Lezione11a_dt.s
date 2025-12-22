
; Lezione11a.s		Ein paar privilegierte Anweisungen ausführen.

Inizio:
	move.l	4.w,a6			; ExecBase in a6
	lea	SuperCode(PC),a5	; Routine zur Ausführung im Supervisor
	jsr	-$1e(a6)			; LvoSupervisor - Führen Sie die Routine aus
					; (Speichern Sie die Register nicht! Seien Sie vorsichtig!)
	rts				; beenden, nachdem Sie die Routine
					; "SuperCode" in supervisor ausgeführt haben.

; Routine wird im Supervisor-Modus ausgeführt wird
;	  __
;	  \/
;	-    -
;	
;	 /  \
		
SuperCode:
	move.w	SR,d0		; priviligierte Anweisung
	move.w	d0,sr		; priviligierte Anweisung
	RTE	; Return From Exception: wie RTS, jedoch von Ausnahme.

	end

Indem Sie dieses Listing ausführen, nehmen Sie den Wert des Statusregisters zur
Zeit der Ausnahme, also am Ende der Ausführung. In d0 wird es einen Wert geben,
in der Regel $2000, was auch beweist, dass es im Ausnahmefall ausgeführt 
wurde, da das Bit 13 des SR, falls gesetzt, den Supervisor-Modus anzeigt.


 (((
oO Oo
 \"/
  ~		5432109876543210
	($2000=%0010000000000000)


HINWEIS: move.w SR,Ziel ist privilegiert nur ab 68010. Beim 68000 kann er 
auch im Usermode ausgeführt werden. In der Tat, wer es in alten Demos 
oder Spielen im Usermode verwendet hat, es funktioniert nur auf dem 
68000, mit dem Start von Flüchen und Unfällen für 68020+ Besitzer.