
/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     tracks.e
      Description:    track editor stuff
      Version:    1.0
 --------------------------------------------------------------------
*/




OPT MODULE,LARGE
OPT PREPROCESS


#define TRACKLIST mdata.tracklist
#define CURTRACK mdata.curtrack
#define SLOTID_MIN 0
#define SLOTID_MAX 255

#define CTP curtrackp
#define CCL curtrackp.curcl
#define CHANNELS curtrackp.data.channels
#define LAYERS curtrackp.data.layers
#define CHANNEL(x) curtrackp.channel[x]
#define DATA curtrackp.data

#define TEDTITLE 'Track Editor'

#define EDIT tracked.edit
#define SPC tracked.spc
#define SPACING tracked.spacing
#define OCTAVE tracked.octave
#define CHON(x) tracked.chstate[x]



#define EATEVENT eatflag2:=1




MODULE '*declarations','muimaster','libraries/mui','tools/boopsi','devices/inputevent','*global'
MODULE '*gui_declarations','*common','utility/hooks','tools/installhook','*adst:dsp/dummy'

EXPORT OBJECT obj_trackeditor
      edit
      spc
      spacing
      octave
      chstate[4]:ARRAY
ENDOBJECT


EXPORT OBJECT obj_trackdata
      tempoc:INT
      leftvol:INT
      rightvol:INT
      layers:CHAR
      dspflag:CHAR
      channels:CHAR
      exclude:CHAR
ENDOBJECT

OBJECT obj_channel -> this is some hack
      n:INT -> channel no.
      tempoc:INT
      lines:INT   -> int,but now only 256 is maximum
      unusew1:INT
      note[256]:ARRAY
      instr[256]:ARRAY
      clist[8]:ARRAY OF LONG   -> PTR TO COMMANDLIST(ARRAY OF command)
ENDOBJECT


EXPORT OBJECT obj_track OF obj_base
      data:obj_trackdata

      PRIVATE
      curcl:CHAR
      ndsp:CHAR
      dsp[16]:ARRAY OF obj_dspid
      channel[4]:ARRAY OF obj_channel
ENDOBJECT

OBJECT obj_command
      eff
      x1:INT
      x2:INT
      arg1:CHAR
      ext:CHAR
ENDOBJECT




EXPORT OBJECT obj_trlist OF obj_sss
ENDOBJECT


OBJECT obj_cbufitem
      pos:INT
      note:CHAR
      instr:CHAR
      eff[8]:ARRAY OF LONG
      x1[8]:ARRAY OF INT
      x2[8]:ARRAY OF INT
      arg1[8]:ARRAY OF CHAR
      reserved:INT
ENDOBJECT


            EXPORT DEF _tred:PTR TO objw_trackeditor
            EXPORT DEF _tran:PTR TO objw_transpose
            EXPORT DEF _pckt:PTR TO objw_picktrack
            EXPORT DEF _trop:PTR TO objw_trackoptions
            EXPORT DEF _sect:PTR TO objw_sectioneditor
            EXPORT DEF _appl:PTR TO obj_application
            EXPORT DEF _tdsp:PTR TO objw_trackdsp

EXPORT DEF upd

EXPORT DEF table:PTR TO CHAR   -> keyboard table,table range=0-40 ,[note,octoffs]

EXPORT DEF mdata:PTR TO obj_mdata
EXPORT DEF trl:PTR TO obj_trlist
EXPORT DEF tracked:PTR TO obj_trackeditor

EXPORT DEF changed

EXPORT DEF notetable:PTR TO LONG,eatflag2
       DEF tempoctable:PTR TO CHAR -> in x/16
       DEF lastcommand:PTR TO obj_command       
EXPORT DEF curtrackp:PTR TO obj_track
       DEF chf0:PTR TO LONG,chf1:PTR TO LONG,chf2:PTR TO LONG,chf3:PTR TO LONG-> pointers to array of pointers    
       DEF chx0:PTR TO CHAR,chx1:PTR TO CHAR,chx2:PTR TO CHAR,chx3:PTR TO CHAR -> text memory  area, lines*40     
       DEF s,sl ->main mask string and its len  
       DEF sx  -> string contents for str_ted_x
       DEF tedtitle:PTR TO CHAR


            EXPORT DEF sections -> sections present
            EXPORT DEF cursectp:PTR TO obj_section  
            EXPORT DEF cursect -> NUMBER of current section


/*  Copy buffer definition
*/


      DEF copy_buffer:PTR TO obj_cbufitem
      DEF copy_buffer_length,copy_buffer_pos
      DEF copy_buffer_clists

      DEF tcb:PTR TO obj_track -> track copy buffer

/*

NOTE DEFINITIONS:

UBYTE, $xy ,where y is the note and x octave

      Notes:      $x0   C
            $x1   C#
            $x2   D
            $x3   D#
            $x4   E
            $x5   F
            $x6   F#
            $x7   G
            $x8   G#
            $x9   A
            $xA   A#
            $xB   H
            $xC-F   unused

      Octaves:

            $1y   1
            $2y   2
            $3y   3
            $4y   4
            $5y   5
            $6y   6
                $7y     7

      Specials:   $00   EMPTY NOTE
                  $01     -I-
                  $02     ***

      Example     A#-3 is $3A

Channel data format:
(x-ample)
            5a: A-3 06 DSPC 55
            pos not inst eff arg
*/


-> track editor OBJECT stuff

EXPORT PROC create() OF obj_trackeditor
      DEF i

      FOR i:=0 TO 3 DO self.chstate[i]:=TRUE -> all chans on
      self.octave:=1
      self.spacing:=2
      self.spc:=FALSE
      self.edit:=FALSE
ENDPROC

PROC editon(x) OF obj_trackeditor
      self.edit:=x
      IF upd THEN nset(_tred.chedit,MUIA_Selected,x)
ENDPROC

PROC spcon(x) OF obj_trackeditor
      self.spc:=x
      IF upd THEN nset(_tred.chspc,MUIA_Selected,x)
ENDPROC

PROC onchannel(ch,x) OF obj_trackeditor
      DEF obj

      IF upd
            SELECT ch
                  CASE 0
                        obj:=_tred.chon0
                  CASE 1
                        obj:=_tred.chon1
                  CASE 2
                        obj:=_tred.chon2
                  CASE 3
                        obj:=_tred.chon3
            ENDSELECT
      ENDIF
      self.chstate[ch]:=x
      nset(obj,MUIA_Selected,self.chstate[ch])
ENDPROC

PROC octave(x) OF obj_trackeditor
      self.octave:=x
      IF upd THEN nset(_tred.cyoct,MUIA_Cycle_Active,x)
ENDPROC


-> track list stuff

EXPORT PROC create(size,ps) OF obj_trlist
      DEF i

      -> track stuff initialisation

      NEW tracked.create()
      notetable:=['C-','C#','D-','D#','E-','F-','F#','G-','G#','A-','A#','H-']

      tempoctable:=[4,8,16,32,64,0]:CHAR

      -> keyboard map FOR notes

      table:=[$FF,$FF ,$FD,$FF ,1,1 ,3,1 ,$FF,$FF, 6,1, 8,1, 10,1, $FF,$FF ,1,2, 3,2, $FF,$FF, 6,2, 8,2, $FF,$FF, $FF,$FF,
            0,1, 2,1, 4,1, 5,1, 7,1, 9,1, 11,1, 0,2, 2,2, 4,2, 5,2, 7,2, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF,
            $FE,$FF, 1,0, 3,0, $FF,$FF, 6,0, 8,0, 10,0, $FF,$FF, 1,1, 3,1, $FF,$FF, 6,1, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF,
            $FF,$FF, 0,0, 2,0, 4,0, 5,0, 7,0, 9,0, 11,0, 0,1, 2,1, 4,1, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF]:CHAR

      -> channel item template
      s:='\e0-- \e8--- \e0--\e8\ei    \e0  '

      sl:=StrLen(s)
      chf0:=NewR(1024)
      chf1:=NewR(1024)
      chf2:=NewR(1024)
      chf3:=NewR(1024)
      chx0:=NewR(8192)
      chx1:=NewR(8192)
      chx2:=NewR(8192)
      chx3:=NewR(8192)

      sx:=String(30)
      tedtitle:=String(64)
      StrCopy(tedtitle,TEDTITLE,ALL)
      set(_tred.base,MUIA_Window_Title,tedtitle)
      NEW lastcommand

      -> Copy buffer initialisation

      copy_buffer_length:=0
      tcb:=0

      SUPER self.create(size,ps)
ENDPROC

PROC end() OF obj_trlist
      SUPER self.end()
      END tracked
ENDPROC

PROC renam(slot,name) OF obj_trlist
      SUPER self.renam(slot,name)
      domethod(_pckt.lv,[MUIM_List_Redraw,MUIV_List_Redraw_All])
      domethod(_sect.lv3,[MUIM_List_Redraw,MUIV_List_Redraw_All])
      CHANGED
ENDPROC

PROC newone() OF obj_trlist
      DEF temp:PTR TO obj_track

      NEW temp.create()
ENDPROC temp

PROC freeone(entry:PTR TO obj_track) OF obj_trlist
      END entry
ENDPROC

PROC newentry(slot) OF obj_trlist
      -> assumes that the slot is EMPTY

      SUPER self.newentry(slot)
      refreshpicktrack()
      self.setactive(slot)
      
ENDPROC

PROC delentry(slot) OF obj_trlist
      -> !!! sections

      SUPER self.delentry(slot)
      refreshpicktrack()
      self.setactive(slot)
ENDPROC

PROC delall() OF obj_trlist
DEF slot
      -> sections!!!
      slot:=self.getactive()
      SUPER self.delall()
      refreshpicktrack()
      self.setactive(slot)
ENDPROC


PROC setactive(slot) OF obj_trlist
DEF i,pos,a,layer

      IF slot=-1 THEN RETURN
      layer:=0
      SUPER self.setactive(slot)
      CTP:=self.getp(slot)

      IF CTP THEN layer:=CTP.curcl

      IF upd
            domethod(_tred.txslot,[MUIM_SetAsString,MUIA_Text_Contents,
            '%02.2lx',slot])
      ENDIF



      IF CTP
            a:=self.findpos(slot)
            nset(_pckt.lv,MUIA_List_Active,a)
            nset(_sect.lv3,MUIA_List_Active,a)

            /*
            -> dsp update
            listq(_tdsp.lvdspsequence)
            domethod(_tdsp.lvdspsequence,[MUIM_List_Clear])
            FOR i:=0 TO CTP.ndsp-1
                  domethod(_tdsp.lvdspsequence,[MUIM_List_InsertSingle,
                 CTP.dsp[i],MUIV_List_Insert_Bottom])
            ENDFOR
            listnq(_tdsp.lvdspsequence)
            set(_tdsp.lvdspsequence,MUIA_List_Active,MUIV_List_Active_Top)
            */
      ELSE
            nset(_pckt.lv,MUIA_List_Active,MUIV_List_Active_Off)
            nset(_sect.lv3,MUIA_List_Active,MUIV_List_Active_Off)

            nset(_tred.stname,MUIA_String_Contents,'<Unused Slot>')
            nset(_tred.sttempo0,MUIA_Cycle_Active,2)
            nset(_tred.sttempo1,MUIA_Cycle_Active,2)
            nset(_tred.sttempo2,MUIA_Cycle_Active,2)
            nset(_tred.sttempo3,MUIA_Cycle_Active,2)
            nset(_tred.stlines0,MUIA_String_Contents,NIL)
            nset(_tred.stlines1,MUIA_String_Contents,NIL)
            nset(_tred.stlines2,MUIA_String_Contents,NIL)
            nset(_tred.stlines3,MUIA_String_Contents,NIL)
            nset(_tred.st0,MUIA_String_Contents,NIL)
            nset(_tred.st1,MUIA_String_Contents,NIL)
            nset(_tred.st2,MUIA_String_Contents,NIL)
            nset(_tred.st3,MUIA_String_Contents,NIL)
            domethod(_tred.lv0,[MUIM_List_Clear])
            domethod(_tred.lv1,[MUIM_List_Clear])
            domethod(_tred.lv2,[MUIM_List_Clear])
            domethod(_tred.lv3,[MUIM_List_Clear])
            domethod(_tred.cyted,[MUIM_NoNotifySet,MUIA_Cycle_Active,0])
            domethod(_tred.cycom,[MUIM_NoNotifySet,MUIA_Cycle_Active,0])

            domethod(_trop.slleft,[MUIM_NoNotifySet,MUIA_Numeric_Value,256])
            domethod(_trop.slright,[MUIM_NoNotifySet,MUIA_Numeric_Value,256])
            domethod(_trop.sltempoc,[MUIM_NoNotifySet,MUIA_Numeric_Value,100])
            nset(_trop.chusedsp,MUIA_Selected,FALSE)
            nset(_trop.chexclude,MUIA_Selected,FALSE)

            -> dsp reinit
            domethod(_tdsp.lvdspsequence,[MUIM_List_Clear])
      ENDIF
ENDPROC




-> channel OBJECT stuff

PROC setchparam(ch,pl:PTR TO LONG) OF obj_track
      DEF chan:PTR TO obj_channel
      DEF p,x,objt,objl

      chan:=self.channel[ch]
      p:=pl[0];x:=pl[1]
      SELECT ch
            CASE 0
                  objt:=_tred.sttempo0
                  objl:=_tred.sttempo0
            CASE 1
                  objt:=_tred.sttempo1
                  objl:=_tred.sttempo1
            CASE 2
                  objt:=_tred.sttempo2
                  objl:=_tred.sttempo2
            CASE 3
                  objt:=_tred.sttempo3
                  objl:=_tred.sttempo3
      ENDSELECT

      SELECT p
            CASE CHTEMPOC
                  chan.tempoc:=tempoctable[x]
                  IF upd THEN nset(objt,MUIA_Cycle_Active,gettempoctype(chan.tempoc))
                  CHANGED
            CASE CHLINES
                  chan.lines:=x
                  IF upd
                        nset(objl,MUIA_String_Integer,x)
                        self.activate()
                  ENDIF
                  CHANGED
      ENDSELECT
ENDPROC

PROC getchparam(ch,p) OF obj_track
DEF chan:PTR TO obj_channel
      chan:=self.channel[ch]
      SELECT p
            CASE CHTEMPOC
                  RETURN gettempoctype(chan.tempoc)
            CASE CHLINES
                  RETURN chan.lines
      ENDSELECT
ENDPROC


PROC preparechan(chan:PTR TO obj_channel,layer,chxx:PTR TO CHAR,chfx:PTR TO LONG) OF obj_track
DEF i,j,temp,temp2,comlist:PTR TO obj_command

      -> FILL CHANNEL \e0-- \e8--- \e0--\e8\ei    \e0

      j:=chxx
      FOR i:=0 TO chan.lines-1
            chfx[i]:=j
                  MOVE.L s,A0
                  MOVE.L j,A1
                  MOVE.L sl,D0
                  SUBQ #1,D0
                  lab1: MOVE.B (A0)+,(A1)+
                        DBRA D0,lab1
                  temp:=fslot(i)
                  MOVE.L temp,D0
                  MOVE.L j,A0
                  MOVE.W D0,2(A0)
            IF chan.note[i]>0
               IF chan.note[i]>15
                     temp:=chan.note[i]
                     MOVE.L temp,D0
                     ANDI.L #$0000000F,D0
                     MOVE.L D0,temp
                     temp:=notetable[temp]
                     MOVE.L temp,A0
                     MOVE.L j,A1
                     MOVE.W (A0),7(A1)
                     temp:=chan.note[i]
                     MOVE.L j,A0
                     MOVE.L temp,D0
                     LSR.B #4,D0
                     ADDI.B #$30,D0
                     MOVE.B D0,9(A0)
               ELSEIF chan.note[i]=1  -> -|-
                     MOVE.L j,A0
                     MOVE.B #"|",8(A0)
               ELSEIF chan.note[i]=2
                     MOVE.L j,A0
                     MOVE.W #"**",7(A0)
                     MOVE.B #"*",9(A0)
                ENDIF
                temp:=fslot(chan.instr[i])
                MOVE.L j,A0
                MOVE.L temp,D0
                MOVE.W D0,13(A0)
            ENDIF
              comlist:=chan.clist[layer]
              IF comlist[i].eff
                  temp:=comlist[i].eff
                  MOVE.L j,A0
                  MOVE.L temp,19(A0)
                  temp:=comlist[i].arg1
                  temp2:=fslot(temp)
                  MOVE.L j,A0
                  MOVE.L temp2,D0
                  MOVE.W D0,25(A0)
                    ENDIF

            j:=j+32
      ENDFOR
ENDPROC



-> track OBJECT stuff



EXPORT PROC end() OF obj_track
DEF i,j
DEF p:PTR TO obj_command
DEF b1:PTR TO obj_dspid,b2:PTR TO obj_dsp,h

      -> free all dsp handles
      /*FOR i:=0 TO self.ndsp-1
            b1:=self.dsp[i]
            b2:=mdata.dsplist[b1.linkedid]
            dummybase:=b2.base
            Dsp_freehandle(b1.handle)
      ENDFOR*/

      FOR i:=0 TO self.data.channels-1
                  FOR j:=0 TO self.data.layers-1
                        p:=self.channel[i].clist[j]
                        END p[256]
            ENDFOR
      ENDFOR

      SUPER self.end()
ENDPROC


PROC setname(x) OF obj_track
      SUPER self.setname(x)
      IF upd THEN nset(_tred.stname,MUIA_String_Contents,self.getname())
ENDPROC

PROC setparam(pl:PTR TO LONG) OF obj_track
      DEF p,x

      p:=pl[0];x:=pl[1]
      SELECT p
            CASE TRTEMPOC
                  self.data.tempoc:=x*256/100
                  IF upd THEN nset(_trop.sltempoc,MUIA_Numeric_Value,x)
                  CHANGED
            CASE TRLVOL
                  self.data.leftvol:=x
                  IF upd THEN nset(_trop.slleft,MUIA_Numeric_Value,x)
                  CHANGED
            CASE TRRVOL
                  self.data.rightvol:=x
                  IF upd THEN nset(_trop.slright,MUIA_Numeric_Value,x)
                  CHANGED
            CASE TRCOMLS
                  self.changeclayers(x+1) -> 0..7 is x
            CASE TRDSPFLG
                  self.data.dspflag:=x
                  IF upd THEN nset(_trop.chusedsp,MUIA_Selected,x)
                  CHANGED
            CASE TRCHANNELS
                  self.changechannels(x+1) -> 0=<x<=3
                  CHANGED
            CASE TREXCL
                  self.data.exclude:=x
                  IF upd THEN nset(_trop.chexclude,MUIA_Selected,x)
                  CHANGED
            CASE TRCURCL
                  IF x<self.data.layers
                        self.curcl:=x
                        IF upd THEN self.activate()
                  ENDIF
                  CHANGED
                  -> activation needed - command layer changed
      ENDSELECT
ENDPROC


PROC getparam(p) OF obj_track
      SELECT p
            CASE TRTEMPOC
                  RETURN self.data.tempoc*100/256
            CASE TRLVOL
                  RETURN self.data.leftvol
            CASE TRRVOL
                  RETURN self.data.rightvol
            CASE TRCOMLS
                  RETURN self.data.layers
            CASE TRCHANNELS
                  RETURN self.data.channels
            CASE TRDSPFLG
                  RETURN self.data.dspflag
            CASE TREXCL
                  RETURN self.data.exclude
            CASE TRCURCL
                  RETURN self.curcl
      ENDSELECT
ENDPROC

EXPORT PROC create() OF obj_track
DEF comlist:PTR TO obj_command
DEF i
      SUPER self.create()
      self.data.tempoc:=256
      self.data.leftvol:=256
      self.data.rightvol:=256
      self.data.channels:=1
      self.data.layers:=1
      self.curcl:=0
      NEW comlist[256]

      FOR i:=0 TO 3 DO self.channel[i].n:=i
      self.channel[0].tempoc:=16
      self.channel[0].lines:=64
      self.channel[0].clist[0]:=comlist
ENDPROC


PROC deactivate() OF obj_track
      SUPER self.deactivate()
      StrCopy(tedtitle,TEDTITLE,ALL)
      set(_tred.base,MUIA_Window_Title,tedtitle)
ENDPROC


PROC activate() OF obj_track
DEF t1,t2,t3,l1,l2,l3,i,temp,j
DEF chan:PTR TO obj_channel
DEF comlist:PTR TO obj_command
DEF temp2
DEF sss[30]:STRING

      SUPER self.activate()


      StringF(sss,': Command Layer \d of \d',self.curcl+1,self.data.layers)
      StrCopy(tedtitle,TEDTITLE,ALL)
      StrAdd(tedtitle,sss,ALL)
      set(_tred.base,MUIA_Window_Title,tedtitle)
      t1:=16;t2:=16;t3:=16;l1:=0;l2:=0;l3:=0

      IF self.data.channels>1
            t1:=self.channel[1].tempoc
            l1:=self.channel[1].lines
      ENDIF
      IF self.data.channels>2
            t2:=self.channel[2].tempoc
            l2:=self.channel[2].lines
      ENDIF
      IF self.data.channels>3
            t3:=self.channel[3].tempoc
            l3:=self.channel[3].lines
      ENDIF

      IF upd
            nset(_tred.stname,MUIA_String_Contents,self.getname())
            nset(_tred.sttempo0,MUIA_Cycle_Active,gettempoctype(self.channel[0].tempoc))
            nset(_tred.sttempo1,MUIA_Cycle_Active,gettempoctype(t1))
            nset(_tred.sttempo2,MUIA_Cycle_Active,gettempoctype(t2))
            nset(_tred.sttempo3,MUIA_Cycle_Active,gettempoctype(t3))

            nset(_tred.stlines0,MUIA_String_Integer,self.channel[0].lines)
            nset(_tred.stlines1,MUIA_String_Integer,l1)
            nset(_tred.stlines2,MUIA_String_Integer,l2)
            nset(_tred.stlines3,MUIA_String_Integer,l3)

            nset(_tred.cyted,MUIA_Cycle_Active,self.data.channels-1)
            nset(_tred.cycom,MUIA_Cycle_Active,self.data.layers-1)

            nset(_trop.slleft,MUIA_Numeric_Value,self.data.leftvol)
            nset(_trop.slright,MUIA_Numeric_Value,self.data.rightvol)
            nset(_trop.sltempoc,MUIA_Numeric_Value,self.data.tempoc*100/256)
            nset(_trop.chusedsp,MUIA_Selected,self.data.dspflag)
            nset(_trop.chexclude,MUIA_Selected,self.data.exclude)
      ENDIF

IF upd=FALSE THEN RETURN

-> ?????????????????????????????????   CHANNEL 0

      chan:=self.channel[0]
      self.preparechan(chan,self.curcl,chx0,chf0)
      get(_tred.lv0,MUIA_List_Entries,{temp})
      set(_tred.lv0,MUIA_List_Quiet,MUI_TRUE)
      IF temp=chan.lines
            domethod(_tred.lv0,[MUIM_List_Redraw,MUIV_List_Redraw_All])
         ELSE
            domethod(_tred.lv0,[MUIM_List_Clear])
            domethod(_tred.lv0,[MUIM_List_Insert,chf0,chan.lines,
                        MUIV_List_Insert_Bottom])

      ENDIF
      set(_tred.lv0,MUIA_List_Quiet,FALSE)

      -> ?????????????????????????????????   CHANNEL 1

IF self.data.channels>1

      chan:=self.channel[1]
      self.preparechan(chan,self.curcl,chx1,chf1)
      get(_tred.lv1,MUIA_List_Entries,{temp})
      set(_tred.lv1,MUIA_List_Quiet,MUI_TRUE)
      IF temp=chan.lines
            domethod(_tred.lv1,[MUIM_List_Redraw,MUIV_List_Redraw_All])
         ELSE
            domethod(_tred.lv1,[MUIM_List_Clear])
            domethod(_tred.lv1,[MUIM_List_Insert,chf1,chan.lines,
                        MUIV_List_Insert_Bottom])
      ENDIF
      set(_tred.lv1,MUIA_List_Quiet,FALSE)
ELSE
domethod(_tred.lv1,[MUIM_List_Clear])
ENDIF

-> ?????????????????????????????????   CHANNEL 2

IF self.data.channels>2

      chan:=self.channel[2]
      self.preparechan(chan,self.curcl,chx2,chf2)
      get(_tred.lv2,MUIA_List_Entries,{temp})
      set(_tred.lv2,MUIA_List_Quiet,MUI_TRUE)
      IF temp=chan.lines
            domethod(_tred.lv2,[MUIM_List_Redraw,MUIV_List_Redraw_All])
         ELSE
            domethod(_tred.lv2,[MUIM_List_Clear])
            domethod(_tred.lv2,[MUIM_List_Insert,chf2,chan.lines,
                        MUIV_List_Insert_Bottom])
      ENDIF
      set(_tred.lv2,MUIA_List_Quiet,FALSE)
ELSE
domethod(_tred.lv2,[MUIM_List_Clear])
ENDIF

-> ?????????????????????????????????   CHANNEL 3

IF self.data.channels>3

      chan:=self.channel[3]
      self.preparechan(chan,self.curcl,chx3,chf3)
      get(_tred.lv3,MUIA_List_Entries,{temp})
      set(_tred.lv3,MUIA_List_Quiet,MUI_TRUE)
      IF temp=chan.lines
            domethod(_tred.lv3,[MUIM_List_Redraw,MUIV_List_Redraw_All])
         ELSE
            domethod(_tred.lv3,[MUIM_List_Clear])
            domethod(_tred.lv3,[MUIM_List_Insert,chf3,chan.lines,
                        MUIV_List_Insert_Bottom])
      ENDIF
      set(_tred.lv3,MUIA_List_Quiet,FALSE)
ELSE
domethod(_tred.lv3,[MUIM_List_Clear])
ENDIF

ENDPROC



PROC changechannels(newc) OF obj_track
      DEF i,j
      DEF chan:PTR TO obj_channel
      DEF clist:PTR TO obj_command

IF newc<self.data.channels
      FOR i:=newc TO self.data.channels-1
            chan:=self.channel[i]
            self.setchparam(i,[CHTEMPOC,2])
            FOR j:=0 TO 255
                  chan.note[j]:=0
                  chan.instr[j]:=0
                  ENDFOR
            FOR j:=0 TO self.data.layers-1
                   clist:=chan.clist[j]
                   END clist[self.getchparam(i,CHLINES)]
                   chan.clist[j]:=0
                   ENDFOR
            self.setchparam(i,[CHLINES,0])
       ENDFOR
      self.data.channels:=newc
   ELSEIF newc>self.data.channels
      FOR i:=self.data.channels TO newc-1
                  chan:=self.channel[i]
                  self.setchparam(i,[CHTEMPOC,2])
                  self.setchparam(i,[CHLINES,64])
            FOR j:=0 TO 255
                  chan.note[j]:=0
                  chan.instr[j]:=0
                  ENDFOR
            FOR j:=0 TO self.data.layers-1
                  NEW clist[256]
                  chan.clist[j]:=clist
                  ENDFOR
      ENDFOR
      self.data.channels:=newc
ENDIF

IF upd THEN nset(_tred.cyted,MUIA_Cycle_Active,newc-1)
self.activate()
ENDPROC


PROC changeclayers(newl) OF obj_track
DEF i,j
DEF temp:PTR TO obj_command

IF newl<self.data.layers
      FOR i:=newl TO self.data.layers-1
            FOR j:=0 TO self.data.channels-1
                  temp:=self.channel[j].clist[i]
                  END temp[256]
                  self.channel[j].clist[i]:=NIL
                  ENDFOR
            ENDFOR
      self.data.layers:=newl
      IF self.curcl>(newl-1) THEN self.curcl:=newl-1
      self.activate()
      CHANGED
ELSEIF newl>self.data.layers
      FOR i:=self.data.layers TO newl-1
            FOR j:=0 TO self.data.channels-1
                  NEW temp[256]
                  self.channel[j].clist[i]:=temp
                  ENDFOR
            ENDFOR
      self.data.layers:=newl
      self.activate()
      CHANGED
ENDIF

IF upd THEN nset(_tred.cycom,MUIA_Cycle_Active,newl-1)
ENDPROC

/* ################################################### */


PROC gettempoctype(x)
      SELECT x
            CASE 4
            RETURN 0
            CASE 8
            RETURN 1
            CASE 16
            RETURN 2
            CASE 32
            RETURN 3
            CASE 64
            RETURN 4
      ENDSELECT
ENDPROC 5


PROC refreshpicktrack()
DEF tctp:PTR TO obj_track
DEF i,j,k,e
      get(_pckt.lv,MUIA_List_Active,{e})
      nset(_pckt.lv,MUIA_List_Quiet,MUI_TRUE)
      nset(_sect.lv3,MUIA_List_Quiet,MUI_TRUE)
      domethod(_pckt.lv,[MUIM_List_Clear])
      domethod(_sect.lv3,[MUIM_List_Clear])

      FOR i:=0 TO trl.max-1
            tctp:=trl.getp(i)
            IF tctp
                        j:=fslot(i)
                        k:=tctp.xb
                        MOVE.L k,A0
                        MOVE.L j,D0
                        MOVE.W D0,(A0)
                        MOVE.W #": ",2(A0)
                        domethod(_pckt.lv,[MUIM_List_InsertSingle,
                                    tctp.xb,MUIV_List_Insert_Bottom])
                        domethod(_sect.lv3,[MUIM_List_InsertSingle,
                                    tctp.xb,MUIV_List_Insert_Bottom])
                        ENDIF
      ENDFOR
      nset(_pckt.lv,MUIA_List_Quiet,FALSE)
      nset(_sect.lv3,MUIA_List_Quiet,FALSE)
      nset(_pckt.lv,MUIA_List_Active,e)
      domethod(_sect.lv2,[MUIM_List_Redraw,MUIV_List_Redraw_All])
ENDPROC
      


PROC jumptop(obj) -> jumps to the top OF a channel
DEF e

      get(obj,MUIA_List_Entries,{e})
      IF e>0 THEN set(obj,MUIA_List_Active,0)
ENDPROC




PROC jumpdiv(obj,a,b) -> jumps over a channel
DEF e

      get(obj,MUIA_List_Entries,{e})
      IF e>0 THEN set(obj,MUIA_List_Active,a*e/b)
ENDPROC


PROC jumpbot(obj) -> jumps to a bottom
DEF e
      get(obj,MUIA_List_Entries,{e})
      IF e>0 THEN set(obj,MUIA_List_Active,e-1)
ENDPROC


PROC nextchan(ch) -> activates next channel
      IF CHANNELS>0
            IF CHANNELS>(ch+1)
                  set(_tred.base,MUIA_Window_ActiveObject,setchannel(ch+1))
            ELSE
                  set(_tred.base,MUIA_Window_ActiveObject,_tred.lv0)
            ENDIF
      ENDIF
ENDPROC


PROC prevchan(ch) -> activates previous channel
      IF CHANNELS>0
            IF (ch-1)>=0
                  set(_tred.base,MUIA_Window_ActiveObject,setchannel(ch-1))
            ELSE
                  set(_tred.base,MUIA_Window_ActiveObject,setchannel(CHANNELS-1))
            ENDIF
            ENDIF
ENDPROC

PROC delnote(obj,ch)  -> deletes a note
DEF e

            get(obj,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  CTP.channel[ch].note[e]:=0
                        CHANGED
                        update_entry(obj,ch,e)
                        IF SPC
                              set(obj,MUIA_List_Active,e+SPACING)
                        ELSE
                              set(obj,MUIA_List_Active,MUIV_List_Active_Down)
                        ENDIF
                  ENDIF
ENDPROC


PROC putlastcom(ch)
DEF comlist:PTR TO obj_command
DEF e,obj

            obj:=setchannel(ch)
            get(obj,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  CHANGED
                  comlist:=CTP.channel[ch].clist[CCL]
                  comlist[e].eff:=lastcommand.eff
                  comlist[e].x1:=lastcommand.x1
                  comlist[e].x2:=lastcommand.x2
                  comlist[e].arg1:=lastcommand.arg1
                  comlist[e].ext:=0
                  update_entry(obj,ch,e)
                  update_related_string(e,ch)
                  EATEVENT
                  IF SPC
                        set(obj,MUIA_List_Active,e+SPACING)
                  ELSE
                        set(obj,MUIA_List_Active,MUIV_List_Active_Down)
                  ENDIF
            ENDIF
ENDPROC


PROC delnotes(obj,ch) -> backspace
DEF e,i,j,comlist:PTR TO obj_command,templ

            get(obj,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  CHANGED
                  templ:=CTP.channel[ch].lines
                  FOR i:=e TO templ
                        CTP.channel[ch].note[i]:=CTP.channel[ch].note[i+1]
                        FOR j:=0 TO LAYERS-1
                              comlist:=CTP.channel[ch].clist[j]
                              CopyMem(comlist[i+1],comlist[i],SIZEOF obj_command)
                        ENDFOR
                        update_entry(obj,ch,i)
                   ENDFOR
                   CTP.channel[ch].note[templ-1]:=0
                   update_entry(obj,ch,templ)
                   EATEVENT
            ENDIF
ENDPROC


PROC putnote(obj,ch,key)
DEF e,temp,note

      temp:=table[key*2]
      IF temp<>255
            get(obj,MUIA_List_Active,{e})
            IF e<>MUIV_List_Active_Off
                  IF temp=253
                        note:=2
                  ELSEIF temp=254
                        note:=1
                  ELSE
                        note:=table[Shl(key,1)]
                        note:=note+(Shl(table[Shl(key,1)+1],4)+Shl(OCTAVE,4))
                  ENDIF
                  CTP.channel[ch].note[e]:=note
                  CHANGED
                  update_entry(obj,ch,e)
                  IF SPC
                        set(obj,MUIA_List_Active,e+SPACING)
                  ELSE
                        set(obj,MUIA_List_Active,e+1)
                  ENDIF
            ENDIF
      ENDIF
ENDPROC


PROC delnotec(obj,ch) -> delete note AND command in current layer
DEF e,comlist:PTR TO obj_command

      get(obj,MUIA_List_Active,{e})
      IF e<>MUIV_List_Active_Off
            CTP.channel[ch].note[e]:=0
            comlist:=CTP.channel[ch].clist[CCL]
            comlist[e].eff:=0
            comlist[e].x1:=0
            comlist[e].x2:=0
            comlist[e].arg1:=0
            comlist[e].ext:=0
            CHANGED
            update_entry(obj,ch,e)
            update_related_string(e,ch)
            IF SPC
                  set(obj,MUIA_List_Active,e+SPACING)
            ELSE
                  set(obj,MUIA_List_Active,MUIV_List_Active_Down)
            ENDIF
       ENDIF
ENDPROC


PROC delnotesc(obj,ch) -> backspace, deletes notes AND command in all layers
DEF e,comlist:PTR TO obj_command,templ,i,j

      get(obj,MUIA_List_Active,{e})
      IF e<>MUIV_List_Active_Off
            CHANGED
            templ:=CTP.channel[ch].lines
            FOR i:=templ-2 TO e STEP -1
                  CTP.channel[ch].note[i+1]:=CTP.channel[ch].note[i]
                  FOR j:=0 TO LAYERS-1
                        comlist:=CTP.channel[ch].clist[j]
                        CopyMem(comlist[i],comlist[i+1],SIZEOF obj_command)
                  ENDFOR
                  update_entry(obj,ch,i+1)
            ENDFOR
            CTP.channel[ch].note[e]:=0
            FOR j:=0 TO LAYERS-1
                  comlist:=CTP.channel[ch].clist[j]
                  comlist[e].eff:=0
                  comlist[e].arg1:=0
                  comlist[e].x1:=0
                  comlist[e].x2:=0
                  comlist[e].ext:=0
            ENDFOR
            update_entry(obj,ch,e)
            EATEVENT
      ENDIF
ENDPROC


PROC unselectall(obj,ch)
      IF ch<CHANNELS THEN domethod(obj,[MUIM_List_Select,MUIV_List_Select_All,
                                    MUIV_List_Select_Off,NIL])
ENDPROC



-> misc small edit support procs

PROC setchannel(p)
DEF obj

SELECT p
      CASE 0
      obj:=_tred.lv0
      CASE 1
      obj:=_tred.lv1
      CASE 2
      obj:=_tred.lv2
      CASE 3
      obj:=_tred.lv3
ENDSELECT
ENDPROC obj
      

PROC getchannel(obj)
DEF ch
ch:=-1
SELECT obj
      CASE _tred.lv0
      ch:=0
      CASE _tred.lv1
      ch:=1
      CASE _tred.lv2
      ch:=2
      CASE _tred.lv3
      ch:=3
ENDSELECT
ENDPROC ch


PROC update_entry(obj,ch,entry)
DEF chan:PTR TO obj_channel
DEF comlist:PTR TO obj_command
DEF chx:PTR TO CHAR,chf:PTR TO LONG
DEF temp,temp2,j

SELECT ch
      CASE 0
      chx:=chx0
      chf:=chf0
      CASE 1
      chx:=chx1
      chf:=chf1
      CASE 2
      chx:=chx2
      chf:=chf2
      CASE 3
      chx:=chx3
      chf:=chf3
ENDSELECT
      

chan:=CTP.channel[ch]
comlist:=chan.clist[CCL]

      j:=chx+(32*entry)

                  MOVE.L s,A0
                  MOVE.L j,A1
                  MOVE.L sl,D0
                  SUBQ #1,D0
                  lab1e: MOVE.B (A0)+,(A1)+
                        DBRA D0,lab1e
                  temp:=fslot(entry)      
                  MOVE.L temp,D0
                  MOVE.L j,A0
                  MOVE.W D0,2(A0)
            IF chan.note[entry]>0
               IF chan.note[entry]>15
                     temp:=chan.note[entry]
                     MOVE.L temp,D0
                     ANDI.L #$0000000F,D0
                     MOVE.L D0,temp
                     temp:=notetable[temp]
                     MOVE.L temp,A0
                     MOVE.L j,A1
                     MOVE.W (A0),7(A1)
                     temp:=chan.note[entry]
                     MOVE.L j,A0
                     MOVE.L temp,D0
                     LSR.B #4,D0
                     ADDI.B #$30,D0             
                     MOVE.B D0,9(A0)
               ELSEIF chan.note[entry]=1  -> -|-
                     MOVE.L j,A0
                     MOVE.B #"|",8(A0)
               ELSEIF chan.note[entry]=2
                     MOVE.L j,A0
                     MOVE.W #"**",7(A0)
                     MOVE.B #"*",9(A0)
                ENDIF   
                temp:=fslot(chan.instr[entry])
                MOVE.L j,A0
                MOVE.L temp,D0
                MOVE.W D0,13(A0)                
            ENDIF
              comlist:=chan.clist[CCL]
              IF comlist[entry].eff
                  temp:=comlist[entry].eff
                  MOVE.L j,A0
                  MOVE.L temp,19(A0)
                  temp:=comlist[entry].arg1
                  temp2:=fslot(temp)
                  MOVE.L j,A0
                  MOVE.L temp2,D0
                  MOVE.W D0,25(A0)
                    ENDIF
            
domethod(obj,[MUIM_List_Redraw,entry])
ENDPROC           



                                          
      
PROC putcommandstring(ch,x) -> will update lastcommand AND put it into channel
      DEF obj,e,linkedlist,pos,temp,k:PTR TO LONG
      DEF comlist:PTR TO obj_command
      DEF s1[20]:STRING
      DEF s2[20]:STRING
      DEF s3[20]:STRING
      DEF s4[20]:STRING
      DEF ts[10]:STRING

      SELECT ch
            CASE 0
                  linkedlist:=_tred.lv0
                  obj:=_tred.st0
            CASE 1
                  linkedlist:=_tred.lv1
                  obj:=_tred.st1
            CASE 2
                  linkedlist:=_tred.lv2
                  obj:=_tred.st2
            CASE 3
                  linkedlist:=_tred.lv3
                  obj:=_tred.st3
      ENDSELECT

      IF CHANNELS>ch
            -> now we must parse the string to effect AND args
            pos:=0
            pos:=copynextword(pos,x,s1) -> EFFECT NAME
            pos:=copynextword(pos,x,s2) -> MAIN arg-HEX
            pos:=copynextword(pos,x,s3) -> arg 1
            pos:=copynextword(pos,x,s4) -> arg 2
            lastcommand.eff:=0
            lastcommand.arg1:=0
            lastcommand.x1:=0
            lastcommand.x2:=0
            IF s1
                  k:=s1
                  temp:=k[]
                  lastcommand.eff:=temp
                  IF s2
                        StrCopy(ts,'$',ALL)
                        StrAdd(ts,s2,ALL)
                        temp:=Val(ts)
                        lastcommand.arg1:=temp
                        IF s3
                              temp:=Val(s3)
                              lastcommand.x1:=temp
                              IF s4
                                    temp:=Val(s4)                       
                                    lastcommand.x2:=temp    
                              ENDIF
                        ENDIF
                  ENDIF
            ENDIF
            set(_tred.base,MUIA_Window_ActiveObject,obj)
            IF EDIT THEN putlastcom(ch)
      ENDIF
ENDPROC

PROC copynextword(pos,source:PTR TO CHAR,dest:PTR TO CHAR)
DEF i

      i:=0

      WHILE source[pos]=32 DO pos++ 
      WHILE (source[pos]<>32) AND (source[pos]) DO dest[i++]:=source[pos++]
      dest[i]:=0
      RETURN pos
ENDPROC

      
PROC update_related_string(e,ch)
      DEF linkedstring,temp
      DEF comlist:PTR TO obj_command


      
SELECT ch
            CASE 0
                  linkedstring:=_tred.st0
            CASE 1
                  linkedstring:=_tred.st1
            CASE 2
                  linkedstring:=_tred.st2
            CASE 3
                  linkedstring:=_tred.st3
      ENDSELECT
      
      IF e=MUIV_List_Active_Off
            set(linkedstring,MUIA_String_Contents,0)
      ELSE
            comlist:=CTP.channel[ch].clist[CCL]
            temp:=comlist[e].eff
            IF temp
                  StringF(sx,'\s[4] \z\h[2] \d \d',[temp],comlist[e].arg1,comlist[e].x1,comlist[e].x2)
            ELSE
                  sx[0]:=0    
            ENDIF
            set(linkedstring,MUIA_String_Contents,sx)
      ENDIF
ENDPROC


-> =========== EDIT FUNCTIONS

PROC selectchannel()

DEF objx,a

      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF a<CHANNELS THEN domethod(objx,[MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_On,
                        NIL])
ENDPROC


PROC copyrange()
DEF objx,a,pos,i,j
DEF comlist:PTR TO obj_command

      IF copy_buffer_length>0 THEN END copy_buffer[copy_buffer_length]
      copy_buffer_length:=0
      
      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF a<CHANNELS

            j:=0
            pos:=MUIV_List_NextSelected_Start
            domethod(objx,[MUIM_List_NextSelected,{pos}])
            copy_buffer_pos:=pos
            WHILE pos<>MUIV_List_NextSelected_End
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  j++
            ENDWHILE

            -> j is size

            NEW copy_buffer[j]
            pos:=MUIV_List_NextSelected_Start
            FOR i:=0 TO j-1
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  copy_buffer[i].pos:=pos
                  copy_buffer[i].note:=CTP.channel[a].note[pos]
                  copy_buffer[i].instr:=CTP.channel[a].instr[pos]
                  comlist:=CTP.channel[a].clist[CCL]
                  copy_buffer[i].eff[0]:=comlist[pos].eff
                  copy_buffer[i].x1[0]:=comlist[pos].x1
                  copy_buffer[i].x2[0]:=comlist[pos].x2
                  copy_buffer[i].arg1[0]:=comlist[pos].arg1             
            ENDFOR
            domethod(objx,[MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_Off,
                        NIL])
            copy_buffer_length:=j
            copy_buffer_clists:=-1
      ENDIF
      logit('Range copied (one layer).')

ENDPROC


EXPORT PROC copyrangealllayers()
DEF objx,a,pos,i,j,k
DEF comlist:PTR TO obj_command

      IF copy_buffer_length>0 THEN END copy_buffer[copy_buffer_length]
      copy_buffer_length:=0
      
      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF a<CHANNELS

            j:=0
            pos:=MUIV_List_NextSelected_Start
            domethod(objx,[MUIM_List_NextSelected,{pos}])
            copy_buffer_pos:=pos
            WHILE pos<>MUIV_List_NextSelected_End
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  j++
            ENDWHILE

            -> j is size

            NEW copy_buffer[j]
            pos:=MUIV_List_NextSelected_Start
            FOR i:=0 TO j-1
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  copy_buffer[i].pos:=pos
                  copy_buffer[i].note:=CTP.channel[a].note[pos]
                  copy_buffer[i].instr:=CTP.channel[a].instr[pos]
                  FOR k:=0 TO LAYERS-1
                        comlist:=CTP.channel[a].clist[k]
                        copy_buffer[i].eff[k]:=comlist[pos].eff
                        copy_buffer[i].x1[k]:=comlist[pos].x1
                        copy_buffer[i].x2[k]:=comlist[pos].x2
                        copy_buffer[i].arg1[k]:=comlist[pos].arg1
                  ENDFOR                  
            ENDFOR
            domethod(objx,[MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_Off,
                        NIL])
            copy_buffer_length:=j
            copy_buffer_clists:=LAYERS
      ENDIF
      logit('Range copied (all layers).')
ENDPROC

PROC cutrange() -> test EDIT before calling this
DEF objx,a,pos,i,j
DEF comlist:PTR TO obj_command

      IF copy_buffer_length>0 THEN END copy_buffer[copy_buffer_length]
      copy_buffer_length:=0
      
      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF a<CHANNELS

            j:=0
            pos:=MUIV_List_NextSelected_Start
            domethod(objx,[MUIM_List_NextSelected,{pos}])
            copy_buffer_pos:=pos
            WHILE pos<>MUIV_List_NextSelected_End
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  j++
            ENDWHILE

            -> j is size

            NEW copy_buffer[j]
            pos:=MUIV_List_NextSelected_Start
            FOR i:=0 TO j-1
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  copy_buffer[i].pos:=pos
                  copy_buffer[i].note:=CHANNEL(a).note[pos]
                  copy_buffer[i].instr:=CHANNEL(a).instr[pos]
                  comlist:=CHANNEL(a).clist[CCL]
                  copy_buffer[i].eff[0]:=comlist[pos].eff
                  copy_buffer[i].x1[0]:=comlist[pos].x1
                  copy_buffer[i].x2[0]:=comlist[pos].x2
                  copy_buffer[i].arg1[0]:=comlist[pos].arg1             
                  
                  CHANNEL(a).note[pos]:=0
                  CHANNEL(a).instr[pos]:=0
                  comlist:=CHANNEL(a).clist[CCL]
                  comlist[pos].eff:=0
                  comlist[pos].x1:=0
                  comlist[pos].x2:=0
                  comlist[pos].arg1:=0          
                  update_entry(objx,a,pos)
            ENDFOR
            domethod(objx,[MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_Off,
                        NIL])
            copy_buffer_length:=j
            copy_buffer_clists:=-1
      ENDIF
      CHANGED
      logit('Range cut (one layer).')

ENDPROC

EXPORT PROC cutrangealllayers() -> test EDIT before
DEF objx,a,pos,i,j,k
DEF comlist:PTR TO obj_command
DEF comlist2:PTR TO obj_command

      IF copy_buffer_length>0 THEN END copy_buffer[copy_buffer_length]
      copy_buffer_length:=0
      
      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF a<CHANNELS

            j:=0
            pos:=MUIV_List_NextSelected_Start
            domethod(objx,[MUIM_List_NextSelected,{pos}])
            copy_buffer_pos:=pos
            WHILE pos<>MUIV_List_NextSelected_End
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  j++
            ENDWHILE

            -> j is size

            NEW copy_buffer[j]
            pos:=MUIV_List_NextSelected_Start
            FOR i:=0 TO j-1
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  copy_buffer[i].pos:=pos
                  copy_buffer[i].note:=CHANNEL(a).note[pos]
                  copy_buffer[i].instr:=CHANNEL(a).instr[pos]
                  CHANNEL(a).note[pos]:=0
                  CHANNEL(a).instr[pos]:=0
                  FOR k:=0 TO LAYERS-1
                        comlist:=CHANNEL(a).clist[k]
                        copy_buffer[i].eff[k]:=comlist[pos].eff
                        comlist[pos].eff:=0
                        copy_buffer[i].x1[k]:=comlist[pos].x1
                        comlist[pos].x1:=0
                        copy_buffer[i].x2[k]:=comlist[pos].x2
                        comlist[pos].x2:=0
                        copy_buffer[i].arg1[k]:=comlist[pos].arg1
                        comlist[pos].arg1:=0
                  ENDFOR                  
                  update_entry(objx,a,pos)
            ENDFOR
            domethod(objx,[MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_Off,
                        NIL])
            copy_buffer_length:=j
            copy_buffer_clists:=LAYERS
      ENDIF
      logit('Range cut (all layers).')
      CHANGED

ENDPROC


PROC clearrange() -> test edit before !
DEF objx,a,pos,i,j
DEF comlist:PTR TO obj_command

      
      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF a<CHANNELS

            j:=0
            pos:=MUIV_List_NextSelected_Start
            domethod(objx,[MUIM_List_NextSelected,{pos}])
            WHILE pos<>MUIV_List_NextSelected_End
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  j++
            ENDWHILE

            -> j is size

            pos:=MUIV_List_NextSelected_Start
            FOR i:=0 TO j-1
                  domethod(objx,[MUIM_List_NextSelected,{pos}])
                  
                  CHANNEL(a).note[pos]:=0
                  CHANNEL(a).instr[pos]:=0
                  comlist:=CHANNEL(a).clist[CCL]
                  comlist[pos].eff:=0
                  comlist[pos].x1:=0
                  comlist[pos].x2:=0
                  comlist[pos].arg1:=0          
                  update_entry(objx,a,pos)
            ENDFOR
            domethod(objx,[MUIM_List_Select,MUIV_List_Select_All,MUIV_List_Select_Off,
                        NIL])
      ENDIF

ENDPROC


PROC pasterange()
DEF objx,a,pos,i,j,e,k
DEF comlist:PTR TO obj_command

      get(_tred.base,MUIA_Window_ActiveObject,{objx})
      a:=getchannel(objx)
      IF a=-1 THEN RETURN
      IF copy_buffer_length=0 
            error('Copy buffer is empty !')
            RETURN
      ENDIF

      IF a<CHANNELS
                  get(objx,MUIA_List_Active,{e})
                  IF e<>MUIV_List_Active_Off    
                  FOR i:=0 TO copy_buffer_length-1
                        pos:=copy_buffer[i].pos-copy_buffer_pos
                        IF (pos+e)<CHANNEL(a).lines

                        CHANNEL(a).note[pos+e]:=copy_buffer[i].note
                        CHANNEL(a).instr[pos+e]:=copy_buffer[i].instr

                        IF copy_buffer_clists=-1
                              comlist:=CHANNEL(a).clist[CCL]
                              comlist[pos+e].eff:=copy_buffer[i].eff[0]
                              comlist[pos+e].x1:=copy_buffer[i].x1[0]
                              comlist[pos+e].x2:=copy_buffer[i].x2[0]
                              comlist[pos+e].arg1:=copy_buffer[i].arg1[0]
                        ELSE
                              FOR k:=0 TO copy_buffer_clists-1
                              IF k<(LAYERS-1)
                                    comlist:=CHANNEL(a).clist[k]
                                    comlist[pos+e].eff:=copy_buffer[i].eff[k]
                                    comlist[pos+e].x1:=copy_buffer[i].x1[k]
                                    comlist[pos+e].x2:=copy_buffer[i].x2[k]
                                    comlist[pos+e].arg1:=copy_buffer[i].arg1[k]
                              ENDIF
                              ENDFOR
                        ENDIF
            
                        update_entry(objx,a,e+pos)
                        ENDIF
                  ENDFOR
                  CHANGED
                  ENDIF
      ENDIF


ENDPROC



PROC ec_is_a_fucked_laming_compiler(t1:PTR TO obj_section)
DEF t2:PTR TO obj_sectionline
DEF brk,j,k,l


FOR j:=0 TO t1.nline-1
      t2:=t1.lines[j]
      retry1:     brk:=FALSE
            FOR k:=0 TO t2.ntrack-1
            IF t2.tracks[k]=CURTRACK 
                  FOR l:=k+1 TO t2.ntrack-1 DO t2.tracks[l-1]:=t2.tracks[l]
                  t2.ntrack:=t2.ntrack-1
                  brk:=TRUE
            ENDIF
            EXIT brk    
            ENDFOR -> k
      IF brk THEN JUMP retry1
ENDFOR -> j

ENDPROC 




PROC deltrack() -> delete current track
DEF i,j,k,l
DEF t1:PTR TO obj_section
DEF t2:PTR TO obj_sectionline
DEF brk,flg
DEF b1:PTR TO obj_dspid,b2:PTR TO obj_dsp

/*   brg is a flag for EXIT command
     flg is a value from muirequest */


      IF CTP=NIL THEN RETURN


            /* now testing sections for track occurence */
            brk:=FALSE;flg:=2

            FOR i:=0 TO sections-1
            t1:=mdata.seclist[mdata.secl[i]]
            FOR j:=0 TO t1.nline-1
            t2:=t1.lines[j]
            FOR k:=0 TO t2.ntrack-1
            IF t2.tracks[k]=CURTRACK 
                  flg:=Mui_RequestA(_appl.app,NIL,NIL,'Request',
                  '*Yes|_No|_Cancel',
                  'WARNING: This track is still used in some sections.\n'+
                  'Should I correct them ?',
                  NIL)
                  brk:=TRUE
                  
            ENDIF
            EXIT brk
            ENDFOR -> k
            EXIT brk
            ENDFOR -> j
            EXIT brk
            ENDFOR -> i

            IF flg<>1 THEN JUMP trapas

            status('Correcting sections...')
            sleep()
            FOR i:=0 TO sections-1
            t1:=mdata.seclist[mdata.secl[i]]
            ec_is_a_fucked_laming_compiler(t1)
            ENDFOR -> i
      set(_sect.lv1,MUIA_List_Active,MUIV_List_Active_Top)
            awake()
            sidle()
      logit('Sections have been corrected.')

            
      trapas:     IF flg
                  trl.delentry(trl.getactive())
                  CHANGED
                  ENDIF
      

ENDPROC

PROC copytrack()

      DEF com:PTR TO obj_command
      DEF ch:PTR TO obj_channel
      DEF i,j

      IF CTP=NIL THEN RETURN
      IF tcb THEN END tcb

      NEW tcb
      CopyMem(CTP,tcb,SIZEOF obj_track)
      FOR i:=0 TO CHANNELS-1
            ch:=CHANNEL(i)
            FOR j:=0 TO LAYERS-1
                  NEW com[ch.lines]
                  tcb.channel[i].clist[j]:=com
                  CopyMem(ch.clist[j],com,ch.lines*SIZEOF obj_command)
            ENDFOR
      ENDFOR
      
            
logit('Track copied.')

ENDPROC     


PROC cuttrack()

      DEF com:PTR TO obj_command
      DEF ch:PTR TO obj_channel
      DEF i,j

      IF CTP=NIL THEN RETURN
      IF tcb THEN END tcb

      NEW tcb
      CopyMem(CTP,tcb,SIZEOF obj_track)


      FOR i:=0 TO CHANNELS-1
            ch:=CHANNEL(i)
            FOR j:=0 TO LAYERS-1
                  NEW com[ch.lines]
                  tcb.channel[i].clist[j]:=com
                  CopyMem(ch.clist[j],com,ch.lines*SIZEOF obj_command)
            ENDFOR
      ENDFOR

      deltrack()

logit('Track cut.')

ENDPROC     


PROC pastetrack()
      DEF com:PTR TO obj_command
      DEF ch:PTR TO obj_channel
      DEF i,j,ct,td
      DEF b1:PTR TO obj_dspid,b2:PTR TO obj_dsp,h

      IF tcb=NIL 
            error('Track copy buffer empty')
            RETURN
      ENDIF

      ct:=trl.getactive()
      IF CTP
            IF confirm('Current track will be lost !')
                  trl.delentry(trl.getactive())
            ELSE
                  RETURN
            ENDIF
      ENDIF
      
      trl.newentry(ct)
      CopyMem(tcb,CTP,SIZEOF obj_track)
      FOR i:=0 TO tcb.data.channels-1
            ch:=tcb.channel[i]
            FOR j:=0 TO tcb.data.layers-1
                  NEW com[ch.lines]
                  CHANNEL(i).clist[j]:=com
                  CopyMem(ch.clist[j],com,ch.lines*SIZEOF obj_command)
            ENDFOR
      ENDFOR
      /* alloc all dsp handles */
      /*FOR i:=0 TO CTP.ndsp-1
            b1:=CTP.dsp[i]
            b2:=mdata.dsplist[b1.linkedid]
            dummybase:=b2.base
            h:=Dsp_allochandle()
            EXIT h=-1   
            b1.handle:=h
      ENDFOR      
      IF h=-1 
            error('DSP: No more handles available')
            CTP.ndsp:=0
      ENDIF*/
      CHANGED
      refreshpicktrack()
      trl.setactive(ct)
ENDPROC     


/*

to tu nema co delat !!!


EXPORT PROC f_sect_doubleclick(hook,obj,msg)
DEF e,l,i
      get(_sect.lv3,MUIA_List_Active,{e})
      IF e=MUIV_List_Active_Off THEN RETURN

      l:=0
      FOR i:=0 TO 255 
                  IF fromslot(TRACKLIST,i)  
                        IF e=l 
                              curcom:=0
                              goto_track(i)
                        ENDIF
                        INC l
                  ENDIF
ENDFOR
ENDPROC

*/

-> --------------------------------
-> track editor keyboard hook entry
-> takes care OF a keyboard control
-> --------------------------------


EXPORT PROC ted_keyboard(hook,obj,msg)
DEF p:PTR TO LONG,c,q,ch

IF CTP=NIL THEN RETURN -> only works when track exists

p:=msg
c:=p[]
q:=p[1]
q:=q AND $00000dff  -> repeat not tested
ch:=getchannel(obj)

IF (q=0) -> no quALIFIER,repeat enabled
      SELECT c
      CASE $55    -> F6
            jumptop(obj)
            EATEVENT
      CASE $56    -> F7
            jumpdiv(obj,1,4)
            EATEVENT
      CASE $57    -> F8
            jumpdiv(obj,1,2)
            EATEVENT
      CASE $58    -> F9
            jumpdiv(obj,3,4)
            EATEVENT
      CASE $59    -> F10
            jumpbot(obj)
            EATEVENT
      CASE $4e    -> arrow right
            nextchan(ch)
            EATEVENT
      CASE $4f    -> arrow left
            prevchan(ch)
            EATEVENT
      CASE $46    ->    DEL
            IF EDIT THEN delnote(obj,ch)
            EATEVENT
      CASE $44    -> ENTER, set the NEW effect command
            IF EDIT THEN putlastcom(ch)
      CASE $41          -> backspace
            IF EDIT THEN delnotes(obj,ch)
      ENDSELECT
      -> process notes
      IF (c>=0) AND (c<64) AND EDIT THEN putnote(obj,ch,c)
ENDIF

IF (q=1) OR (q=2) -> qualifier: SHIFT
      SELECT c
      CASE $46    -> shift+delete
            IF EDIT THEN delnotec(obj,ch)
            EATEVENT
      CASE $41          -> backspace+shift
            IF EDIT THEN delnotesc(obj,ch)
      CASE $40          -> shift+space
            unselectall(obj,ch)
            EATEVENT
      ENDSELECT
ENDIF -> for shift testing

ENDPROC





-> ICI

EXPORT PROC icited(obj,ic,param:PTR TO LONG)
DEF chan:PTR TO obj_channel,ch,x,objp


      SELECT ic
            CASE IC_SETTPARAM
                  IF CTP THEN CTP.setparam(param)
            CASE IC_SETCHPARAM
                  IF CTP
                        chan:=CTP.channel[^param]
                        IF chan THEN CTP.setchparam(^param,param+4)
                  ENDIF
            CASE IC_SETCHPARAMISTR -> PRIVATE HACK ! DONT CODE LIKE THIS
                  IF CTP
                        x:=^param
                        chan:=CTP.channel[x]
                        SELECT x
                              CASE 0
                              objp:=_tred.stlines0
                              CASE 1
                              objp:=_tred.stlines1
                              CASE 2
                              objp:=_tred.stlines2
                              CASE 3
                              objp:=_tred.stlines3
                        ENDSELECT
                        get(objp,MUIA_String_Integer,{x})
                        IF x>256 THEN x:=256
                        IF x<0 THEN x:=0
                        IF chan THEN CTP.setchparam(^param,[CHLINES,x])
                  ENDIF
            CASE IC_JMPLINECH -> PRIVATE FOR gui
                  update_related_string(param[1],param[])
            CASE IC_ACTIVATECH -> PRIVATE FOR GUI
                  ch:=getchannel(obj)
                  IF ch<>-1 THEN set(_tred.base,MUIA_Window_ActiveObject,obj)
            CASE IC_GOPREV
                  trl.preventry()
            CASE IC_GONEXT
                  trl.nextentry()
            CASE IC_EDITON
                  tracked.editon(^param)
            CASE IC_SPCON
                  tracked.spcon(^param)
            CASE IC_CHON
                  tracked.onchannel(param[0],param[1])
            CASE IC_SETACTIVEUSED
                  trl.setactive(trl.slot(^param))
            CASE IC_GOFIRST
                  trl.setactive(trl.nextused(0))
            CASE IC_GOLAST
                  trl.setactive(trl.prevused(trl.max-1))
            CASE IC_GPUTCMD -> PRIVATE FOR GUI
                  IF CTP THEN putcommandstring(param[],param[1])
            CASE IC_OCTAVE
                  tracked.octave(^param+1)
            CASE IC_NEWT
                  IF CTP
                        IF confirm('Current track will be lost. Continue?')
                              trl.freeone(CTP)
                        ELSE
                              RETURN
                        ENDIF
                  ENDIF
                  trl.newentry(trl.getactive())
            CASE IC_DELT
                  deltrack()
            CASE IC_COPYT
                  copytrack()
            CASE IC_CUTT
                  cuttrack()
            CASE IC_PASTET
                  pastetrack()
            CASE IC_MCOPYRANGE
                  copyrange()
            CASE IC_MCOPYRANGEAL
                  copyrangealllayers()
            CASE IC_MCUTRANGE
                  cutrange()
            CASE IC_MCUTRANGEAL
                  cutrangealllayers()
            CASE IC_MPASTERANGE
                  pasterange()
            CASE IC_MSELCHANNEL
                  selectchannel()
            CASE IC_MCLEARRANGE
                  clearrange()
            CASE IC_RENAME
                  IF CTP THEN trl.renam(trl.getactive(),^param)
            CASE IC_OPNTRNRNGWIN
                  set(_tran.base,MUIA_Window_Open,MUI_TRUE)
                  set(_tran.base,MUIA_Window_Title,'Transpose Range')
      ENDSELECT
ENDPROC



