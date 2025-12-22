/* ListKick: List all the contents of the KickStart
   AMIGA E v3.2e:     20-05-96
   Author:   Marco Talamelli
   E-Mail:   marco_talamelli@amp.flashnet.it
*/

DEF string[3]:STRING

PROC main()

DEF 	romstart[3]:STRING,romend=$00FFFFFF,len=$00FFFFEC,c,start,j,count

romstart:=romend-^len+1

WriteF('\nROMstart:\h\nROMend  : \h\n',romstart,romend)
WriteF('Kickstart Version \d.\d\n\n',Int(romstart+$0c),Int(romstart+$0e))

FOR romstart:=romstart TO romend

IF romstart[0]=$4A AND romstart[1]=$FC
	c:=romstart
	romstart:=romstart+2
		IF c=^romstart
			WriteF('$\h ',c)
			romstart:=romstart+16
			start:=^romstart
			j:=^start
			string:={j}
			count:=0
			WriteF('\e[32m')
			WHILE (string[count]<>$0d)
					WriteF('\c',string[count])
			INC count
				IF count=4
					start:=start+4
					j:=^start
					string:={j}
					count:=0
				ENDIF
			ENDWHILE
				WriteF('\e[31m\n')
		ENDIF

ENDIF

ENDFOR

ENDPROC
