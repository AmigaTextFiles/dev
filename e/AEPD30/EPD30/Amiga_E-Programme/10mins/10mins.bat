.key TEXT/A,USER/A,PORT/A


; 10mins - © by Maik "Blizzer" Schreiber [FREEWARE]
; =================================================
;
; Dieses Script erzeugt eine Datei t:10mins_UserMessage.txt, die bspw.
; folgendes enthält:
;
; --- >>> ------------------------------------------------------------------
; Nachricht von User Blizzer (Port 1):
; Hallo Sysop ! Hast Du Lust zum Chat ?
; --- <<< ------------------------------------------------------------------
;
; Folgender Text wird dem User nach dem Start von 10mins angezeigt, worauf
; er normal weiterarbeiten kann:
;
; --- >>> ------------------------------------------------------------------
; Ihr Text wird gerade auf der WB angezeigt. Wenn sich der Sysop in 10 min
; noch nicht gemeldet hat, verschwindet die Mitteilung wieder. Sie sollten
; dann nochmals eine senden.
; --- <<< ------------------------------------------------------------------
;
;
; Adresse:
; --------
; Wenn Sie mich aus irgendeinem Grund kontakten wollen, schreiben an die
; folgenden Adressen:
;
; SnailMail: Maik Schreiber
;            Ruschvitzstraße 19
;            D-18528 Bergen
;            FR Germany
;
; EMail    : blizzer@freeway.shnet.org
;            blizzer@empire.insider.sub.de


Echo >t:10mins_UserMessage.txt "*e[1mNachricht von User *e[3m<user> *e[0;1m(Port <port>):*e[0m*n<text>"
Run 10mins t:10mins_UserMessage.txt
Echo "*ec*nIhr Text wird gerade auf der WB angezeigt. Wenn sich der Sysop in 10 min*nnoch nicht gemeldet hat, verschwindet die Mitteilung wieder. Sie sollten*ndann nochmals eine senden."

