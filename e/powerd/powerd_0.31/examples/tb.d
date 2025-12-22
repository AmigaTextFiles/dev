DEF Note[16]=[24,23,19,17,19,7,21,22,10,20,8,18,17,8,20,12]:UBYTE
DEF NoteLength[16]=[1,1,1,1,1,1,1,1,2,1,1,1,2,1,1,1]:UBYTE
DEF Accent[16]=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]:UBYTE
DEF Slide[16]=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]:UBYTE
ENUM DEST


PROC main()(INT)

  DEF rda,args:PTR TO LONG,output
  DEF tot=0:INT,out=0:INT,notenum=0:INT
  DEFF vco2=0,vco=1.0,vcophase=0,vcofreq=1,lastvcofreq=0,vcoadd,vcofreq2=0
  DEFF hig=0,mid=0,low=0,freq=0,hig2=0,mid2=0,low2=0
  DEFF reso=0.05,feedbk,flevel=0.01,amp=0.0,inp,sq=0.0
  DEF emode=2:INT,filesize=32000:INT
  args:=[NIL]

  IF rda:=ReadArgs('DEST/A',args,NIL)
    IF output:=Open(args[DEST],NEWFILE)
      REPEAT // or 39147 ? or 90000 ?
        IF vco > 0
          vco2 := vco2 + (vco - vco2) * 0.95
        ELSE
          vco2 := vco2 + (vco - vco2) * 0.9
        ENDIF
        inp:=vco2
        IF Slide[notenum]
          vcofreq2 := vcofreq2 + (vcofreq - vcofreq2) * 0.002
        ELSE
          vcofreq2 := vcofreq
        ENDIF
        IFN vcofreq2 = lastvcofreq
          vcoadd := Pow(2.0, vcofreq2 - 0.37) // WAS: +0.35 ???
        ENDIF
        lastvcofreq := vcofreq2
        vcophase += vcoadd
        IF vcophase >= 256
          vcophase -= 256
          vco := -vco
        ENDIF
        IF (tot \ 2000) = 0
          vcofreq := Note[notenum] / 12.0
        ENDIF
        freq := 0.08 + 0.8 * amp
        // reso *= 0.99995 ???
        feedbk := reso * mid
        IF feedbk > flevel
          sq:=(feedbk-flevel)*2.0
          feedbk += sq*sq
        ELSEIF (feedbk < -flevel)
          sq:=(feedbk+flevel)*2.0
          feedbk -= sq*sq
        ENDIF
        hig := inp - feedbk - low
        mid += hig*freq
        low += mid*freq
        hig2 := low - 1 * mid2 - low2
        mid2 += hig2*freq
        low2 += mid2*freq
        IF (tot \ 2000) = 0
          IF NoteLength[notenum] = 1
            emode:=0
          ENDIF
        ENDIF
        IF (tot \ 2000) = 1100
          IFN (NoteLength[(notenum+1)] \ 16) = 2
            emode:=2
          ENDIF
        ENDIF
        SELECT emode
          CASE 0
            amp := amp*1.1 + 0.01
            IF amp >= 1.0
              amp:=1.0
              emode:=1
            ENDIF
          CASE 1
            amp := amp * 0.9998
          CASE 2
            amp := amp * 0.99
        ENDSELECT
        out := low * amp * 40
        IF out>127 THEN out:=127
        IF out<-128 THEN out:=-128
        Out(output,out)
//        Write(output,out,1)
        tot++
        IF (tot \ 2000) = 1999
          notenum++
          IF notenum >= 16
            notenum:=0
          ENDIF
        ENDIF
      UNTIL tot >= filesize
      Close(output)
    ELSE
      PrintF('Can''t open file!\n')
    ENDIF
  ELSE
    PrintF('I need a destination!\n')
    Exit(10)
  ENDIF
ENDPROC
