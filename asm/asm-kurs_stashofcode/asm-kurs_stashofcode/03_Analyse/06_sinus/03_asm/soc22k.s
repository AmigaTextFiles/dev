
; soc22k.s
; Copperliste
; Schatten und Spiegeleffekt

>o1
 00014fb0: 008e 2c81            ;  DIWSTRT := 0x2c81
 00014fb4: 0090 2cc1            ;  DIWSTOP := 0x2cc1
 00014fb8: 0100 2200            ;  BPLCON0 := 0x2200			; 2 Bitebenen + Color	
 00014fbc: 0102 0020            ;  BPLCON1 := 0x0020
 00014fc0: 0104 0000            ;  BPLCON2 := 0x0000
 00014fc4: 0092 0038            ;  DDFSTRT := 0x0038
 00014fc8: 0094 00d0            ;  DDFSTOP := 0x00d0
 00014fcc: 0108 0000            ;  BPL1MOD := 0x0000
 00014fd0: 010a 0000            ;  BPL2MOD := 0x0000
 00014fd4: 00e2 77b0            ;  BPL1PTL := 0x77b0			; beide Bitplanepointer zeigen auf gleiche Daten
 00014fd8: 00e6 77b0            ;  BPL2PTL := 0x77b0
 00014fdc: 00e0 0002            ;  BPL1PTH := 0x0002
 00014fe0: 00e4 0002            ;  BPL2PTH := 0x0002
 00014fe4: 0180 0000            ;  COLOR00 := 0x0000			; 4 Farben
 00014fe8: 0182 0fff            ;  COLOR01 := 0x0fff
 00014fec: 0184 0777            ;  COLOR02 := 0x0777
 00014ff0: 0186 0fff            ;  COLOR03 := 0x0fff
 00014ff4: 01fc 0000            ;  FMODE := 0x0000
 00014ff8: 7b01 ff00            ;  Wait for vpos >= 0x7b, , ignore horizontal
                                ;  VP 7b, VE 7f; HP 00, HE 00; BFD 1
 00014ffc: 010a ffb0            ;  BPL2MOD := 0xffb0
>o
 00015000: 7c01 ff00 [0d1 01e]  ;  Wait for vpos >= 0x7c, , ignore horizontal
                                ;  VP 7c, VE 7f; HP 00, HE 00; BFD 1
 00015004: 010a 0000            ;  BPL2MOD := 0x0000
 00015008: 0102 0020            ;  BPLCON1 := 0x0020
 0001500c: dd01 ff00 [0d1 02e]  ;  Wait for vpos >= 0xdd, , ignore horizontal
                                ;  VP dd, VE 7f; HP 00, HE 00; BFD 1
*00015010: 0108 ffd8            ;  BPL1MOD := 0xffd8
 00015014: 010a 0028            ;  BPL2MOD := 0x0028
 00015018: de01 ff00 [0dd 010]  ;  Wait for vpos >= 0xde, , ignore horizontal
                                ;  VP de, VE 7f; HP 00, HE 00; BFD 1
 0001501c: 0102 0000            ;  BPLCON1 := 0x0000
 00015020: 0108 ffb0            ;  BPL1MOD := 0xffb0
 00015024: 010a ffb0            ;  BPL2MOD := 0xffb0
 00015028: 0180 000a            ;  COLOR00 := 0x000a
 0001502c: 0186 000f            ;  COLOR03 := 0x000f
 00015030: ffff fffe [0de 01c]  ;  Wait for vpos >= 0xff and hpos >= 0xfe
                                ;  VP ff, VE 7f; HP fe, HE fe; BFD 1

Zeile: $7b

BPL2MOD := 0xffb0
>?0-$ffffffb0
$00000050 = %00000000`00000000`00000000`01010000 = 80 = 80		; -80

In dem wir am Ende -80 Bytes zurückgehen werden die Daten für alle geraden Bitebenen
2 Zeilen später ausgegeben, d.h es werden 2 Zeilen übersprungen. Da wir am Ende der
Zeile eine Zeile tiefer sind, sind wir durch zwei weitere übersprungene Zeilen 
effektiv nun drei Zeilen tiefer. 

Zeile: $7c
Eine Zeile tiefer wird dieser BPL2MOD wieder zurückgenommen und die Daten werden nun
wieder "normal" ausgegeben, sodass das Bild intakt bleibt nur eben nach unten 
versetzt angezeigt wird.
Durch den Einsatz des BPLCON1 := 0x0020 werden hier die Bilddaten für die geraden
Bitebenen um zwei Pixel verzögert, d.h. nach rechts versetzt ausgeben. Dadurch
entsteht der Schatteneffekt.

Zeile: $dd
Zunächst wird mit BPL1MOD := 0xffd8 die letzte Zeile einfach wiederholt.
>?0-$ffffffd8
$00000028 = %00000000`00000000`00000000`00101000 = 40 = 40		; -40

BPL2MOD := 0x0028
>?$28
$00000028 = %00000000`00000000`00000000`00101000 = 40 = 40		; +40

Durch Setzen des BPL2MOD auf $28 wird das Einlesen der Bitplanedaten wieder 
gleichgezogen, da der Wert ja zuvor auf -80 Bytes einmal gesetzt wurde.
-80 Bytes+40 Bytes=-40 Bytes.

Zeile: $de
Der Hardwarescroll BPLCON1 := 0x0000 wird zurückgesetzt.
Die Farben werden geändert: COLOR00 := 0x000a und COLOR03 := 0x000f	--> blau.

BPL1MOD := 0xffb0 und BPL2MOD := 0xffb0
>?0-$fffffffb0
$00000050 = %00000000`00000000`00000000`01010000 = 80 = 80		; -80
>

Durch Setzen der BPLxMOD auf -80 Bytes wird nun mit jeder folgenden
Zeile nicht nur die vorhergehende Zeile erneut gelesen, sondern genau immer
eine zusätzliche Zeile früher, sodass dadurch ein Spiegeleffekt entsteht.
Es werden alle 2 Bitebenen gelesen um die richtige Farbe zu bekommen.





