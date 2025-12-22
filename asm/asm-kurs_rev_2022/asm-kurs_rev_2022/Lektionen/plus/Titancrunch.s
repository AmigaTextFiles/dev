
Der Titancrunch ist langsamer und weniger kompakt als der StoneCracker.
Aber er hat einen Vorteil: Er erlaubt es Ihnen, sehr große ausführbare Dateien
zu komprimieren.
Das Problem mit großen ausführbaren Dateien ist folgendes: Angenommen, wir
haben 800k freien Speicher und wollen eine Demo laden, die mit einem normalen
Komprimierer wie dem PowerPacker oder dem StoneCracker komprimiert 300k lang
ist: Diese Datei muss in RAM geladen werden und im Moment ihrer Ausführung
werden dort 500k bleiben... nun das Problem ist, dass die entpackte Datei dann
(vielleicht) 550k lang ist, die es nicht gibt !!!! Also können wir diese
komprimierte Demo nicht ausführen! Der einzige Weg ist, sie komprimiert auf
die Diskette zu geben, damit sie jeder sehen kann.
Ansonsten können wir es mit dem TitanCrunch komprimieren!
Tatsächlich teilt es die Datei in viele 5k-Stücke und komprimiert sie separat.
Das Schöne ist, dass sie automatisch einzeln geladen und entpackt werden!
Das heißt, die vorherige Datei, die komprimiert wurde, war 300 KB, wenn wir
sie komprimieren. Beim Titan sind es vielleicht 320k, aber wenn wir versuchen,
sie zu laden, ist das was passiert: die ersten 5k hochladen und entpacken, dann
5 weitere hochladen und entpacken, und so weiter: Auf diese Weise reicht es
aus, 5k mehr als die Länge zu haben letzte (final) Demo !!! ....
Unter anderem können Sie damit während des Ladens eine Nachricht schreiben.
Lo potete cambiare, e' nel riquadro in basso ("Titanics decrunc...").
Es gibt also 3 Fälle, in denen Sie den Titan anstelle des StoneCracker
verwenden müssen: Wenn die demo für a500 ist (und 512k reicht), aber die Datei
250k überschreitet, oder wenn die demo noch für a500 ist, aber mindestens 1MB
und die Datei 500k überschreitet.
Wenn die Demo für A1200 ist, wenn die Datei 1 MB überschreitet.
Diese Regel ist jedoch nur indikativ! Versuchen Sie einfach die ausführbare
Datei mit dem StoneCracker zu komprimieren, und versuchen Sie dann zu sehen, ob
sie entpackt wird in einem einfachen Computer (a500 base oder a1200 base, ohne
RAM-Erweiterungen!).
Wenn es nicht entpackt .... benutze den TitanCrunch!

