10    print "Please enter your text"
20    line input text$
30    if text$="" then end
40    ph$=translate$(text$)
50    i%=narrate(ph$,a%())
60    goto 10
