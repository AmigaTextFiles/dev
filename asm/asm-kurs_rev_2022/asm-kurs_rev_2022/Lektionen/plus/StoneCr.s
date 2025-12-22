
=-=-=-=-=-=-=-=-=-=-=-=> StoneCracker v4.10.3 <=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Dieser Komprimierer kann ausführbare Dateien, Daten und sogar Nicht-
verschiebbare (reloctable) Programme komprimieren, dh die mit "ORG" und "LOAD"
an absoluten Adressen assembliert (fest) und mit dem WB (Write Binary)
statt dem WO gespeichert wurden.

Decruncher für ausführbare Dateien: die Hunks (dh die SECTION) werden dann 
am Anfang der Datei komprimiert, der Decruncher und der Relocator werden dann
"angehängt", was die hunks (data_C, queues, etc.) entpackt und es dem
richtigen Speicher zuweist. Sobald dies geschehen ist, wird der anfängliche
Abschnittscode (initial section code) gestartet.
Anmerkung: der Daten- und Anweisungs-Cache werden vor dem Verlassen gelöscht.
Anmerkung2: die komprimierte Datei ist autark, sie benötigt die stc.library
nicht.

Datendateien - die Datei wird komprimiert, was auch immer sie enthält, und 
es ist kein Decruncher angehangen.

Programme für absolut Adressen - Diese Art der Programmierung ist die
schlechtest mögliche in der Welt, machen Sie niemals solche Programme. Wie auch
immer, um eine dieser Dateien zu komprimieren, müssen Sie diese Daten eingeben:

Load - $xxxxx Adresse, wo die Datei entpackt werden soll, genauso wie beim
	   ORG & LOAD
Jump - $xxxxx von welcher Adresse aus die Ausführung gestartet werden soll,
	   normalerweise beginnt es von vorne, aber es hängt davon ab, wie Sie
	   Ihren Speicher organisiert haben

Es gibt 5 Arten von Packmodi, genannt Komprimierung. Das kraftvollste ist das
mit 16k, dann gibt es 8k, 4k, 2k, 1k. Verwenden Sie immer die 16k-Version,
außer in den Fällen, in denen die zu komprimierende Datei kleiner als 16k ist,
in diesem Fall kann es vorkommen, dass die Datei mit 8k- oder 4k-Komprimierung
kleiner ist. Diese Zahl ist der maximale Suchabstand gleicher Zeichenfolgen für
die Kompression.

DataID - ist das Suffix, das am Ende der komprimierten Datendateien hinzugefügt
      wird.

- Grundsätzlich kann die Verwendung dieses Komprimierers auf zwei Arten
 erfolgen:

1) Komprimieren Sie die ausführbare Datei, die mit "WO" von ASMONE gespeichert
   wurde, wenn diese Datei nicht "immens" ist. Das Problem ist, dass eine Datei
   die beispielsweise 250 KB lang und komprimiert 100 KB ist, um sie in den
   Speicher zu entpacken werden gut 100Kb + 250Kb benötigt, da die komprimierte
   Datei 100Kb lang in den Speicher geladen werden muss, und diese muss weitere
   250Kb finden, um die  entpackte Datei zu "kopieren".
   Soll die Datei auf einem Amiga mit 1MB entpackt werden, muss sie beibehalten
   werden. Ich berücksichtige die Tatsache, dass, wenn es 650 KB lang
   dekomprimiert und 400 KB komprimiert wäre, würde es 650 + 400 = 1050Kb
   benötigen, und normalerweise bleiben für eine Datei über 850-900 frei!! 
   Was AGA-Produktionen betrifft, ist es notwendig die 2-MB-Grenze anstelle von
   1 MB zu berücksichtigen. Die beste Wahl ist zu versuchen Sie, die
   ausführbare Datei mit StoneCracker zu komprimieren, und prüfen Sie, sie
   auf dem Basisrechner zu entpacken. Wenn dies nicht möglich ist, müssen Sie
   sich für den TitanCrunch entscheiden, der langsamer und weniger effizient
   ist, aber 5 KB auf einmal dekomprimiert, wodurch der Speicher allmählich
   freigegeben wird, und dies die Dekompression von irgendetwas ermöglicht.

2) Komprimieren Sie einige Daten, um sie in unser Programm zu laden und zu
   dekomprimieren. Zu diesem Zweck ist die Dekompressionsroutine vorhanden.
   Um es zu benutzen, nehmen Sie es einfach in unser Listing auf (include) 
   und führen Sie es aus, indem Sie ihm die Adresse in a1 eingeben wo das
   komprimierte Bild, die Musik oder irgendetwas anderes ist und die Adresse
   des gelöschten Puffers in a0, wo die dekomprimierten Daten hinkopiert
   werden müssen:

	LEA	DEST,A0					; DESTINATION ADDRESS
	LEA	CRUNC,A1				; CRUNCHED DATA
	BSR.W	DECRUNCH

Ich rate dringend davon ab, eine Dateikomprimierung mit absoluten Adressen zu
verwenden, weil sie keine Zukunft haben.


********* Originaldokumentation zum komprimierten Dateiformat   ***********

	Decrunch info header & decrunching

        Every file crunched with Stc4.02a or Stc4.10.3 has following header
        (16 bytes) at the beginning of the crunched data:

            "S404" or "S403"    ; cruncher version - string
            Security length     ; overlap size - longword (security)
            Original length     ; decrunched length - longword
            Crunched length     ; crunched length - longword
               .                ; crunched data starts
               .
               .

        Security length is always 16 + something.

        There are also two control words at the end of crunched data. For
        historical reasons it's quite wierd. I'll explain it with a 
        following picture:

        <<- Lower memory                           Higher memory ->>

                  +------------ Crunched length ------------+
                  |                                         |
        InfoHeader|......................LastWord|BitCounter|MaxBits
                            ^                 ^       ^         ^
                            |                 |       |         |
            Crunched data --+                 |       |         |
                                              |       |         |
                         Last crunched word --+       |         |
                                                      |         |
           How many used bits there are in LastWord --+         |
                                                                |
                         Efficiency (packmode - only in S404) --+

        If both crunched data and destination memory overlap there must
        be atleast 'Security length' distance between the start of the
        crunched data and the start of the destination memory:

        <<- Lower memory                               Higher memory ->>

                  <<<-------------- Decrunching direction --------------

        InfoHeader|......................LastWord|BitCounter|MaxBits
        ^
        |             |<------------ Destination memory starts here ....
        |             |
        +-- SecLen ---+
        |
        +---------------> Crunched data starts here..

