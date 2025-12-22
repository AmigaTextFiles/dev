/*

      AudioSTREAM Professional
      (c) 1997 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     samples.e
      Description:    samples and sample editor related stuff
      Contains:   sample editor, sample support functions, i/o
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT MODULE
OPT PREPROCESS


MODULE '*declarations','muimaster','libraries/mui','tools/boopsi'
MODULE '*gui_declarations','*common','exec/memory','amigalib/boopsi'
MODULE 'libraries/asl','*global','dos/dos','utility','utility/tagitem'
MODULE 'libraries/muip','mui/muicustomclass','intuition/intuition','mpega'
MODULE 'intuition/classes','intuition/classusr','intuition/screens'
MODULE 'graphics/rastport','*sampleio','devices/ahi','*rta','*stools'

-> SAMPLE I/O STUFF
-> sample types

ENUM STYPE_CANTOPEN=-1,STYPE_UNRECOGNIZED=0,STYPE_8SVX,STYPE_16SV,STYPE_AIFF,
      STYPE_MAUD,STYPE_WAVE,STYPE_MPEG,STYPE_RAW16,STYPE_RAW16b,STYPE_RAW

-> raw16 header=8bytes
-> raw16b header=4bytes



-> error codes

#define CSP csamplep

#define SCHANGED self.changed:=TRUE
#define CSCHANGED changechanged(TRUE)


EXPORT OBJECT obj_sampledata
      buffer  -> pointer to sample data, stereo samples interleaved
      frames -> length OF sample in FRAMES
      type:CHAR -> 0=8bit other=16bit
      stereo:CHAR -> 0=mono other=stereo
ENDOBJECT


EXPORT OBJECT obj_sample OF obj_base
      data:obj_sampledata
      rate       -> sample default freq
      rngstart
      rnglen
      offset
      cursor
      dispfrms -> frames displayed, 1..frames
      changed -> sample local change

ENDOBJECT

OBJECT obj_scopybufdesc
      frames
      rate
      len
      type:CHAR
      stereo:CHAR
ENDOBJECT



EXPORT OBJECT obj_smlist OF obj_sss
ENDOBJECT


            EXPORT DEF upd
            EXPORT DEF lck
            EXPORT DEF rxm  -> rexxmode
            EXPORT DEF rxr  -> rexxresult

            DEF lastlocked

            DEF siodata:PTR TO obj_siodata

            EXPORT DEF changed      -> bool
            EXPORT DEF ts:PTR TO CHAR

            EXPORT DEF _appm:PTR TO obj_appmenu
            EXPORT DEF _appl:PTR TO obj_application
            EXPORT DEF _main:PTR TO objw_maincontrol
            EXPORT DEF _smed:PTR TO objw_sampleeditor
            EXPORT DEF _smme:PTR TO obj_sampleedmenu
            EXPORT DEF _pcks:PTR TO objw_picksample
            EXPORT DEF _mpeg:PTR TO objw_mpegdecoder
            EXPORT DEF _cvol:PTR TO objw_changevolume

            EXPORT DEF csamplep:PTR TO obj_sample
            EXPORT DEF sml:PTR TO obj_smlist

            EXPORT DEF shiftflg

            EXPORT DEF samplereq:PTR TO filerequester

            DEF memflag,scopybuf,scopybufdesc:PTR TO obj_scopybufdesc



/*                SAMPLE EDITOR CUSTOM CLASS

                  It does have following attributes:

                  MUIA_SampleED_Sample  -> ptr to obj_sample
                                    -> does not make use of sampleinfo
                  MUIA_SampleED_LoopStart
                  MUIA_SampleED_LoopLen

                  And following methods:

                  MUIM_SampleED_Update()
*/

                  ENUM UPDATE_ALL,UPDATE_LOOP,UPDATE_RNG,UPDATE_CURSOR


                  CONST MUIA_SampleED_Sample= $E000
                  CONST MUIA_SampleED_Cursor= $E001
                  CONST MUIA_SampleED_LoopStart= $E004
                  CONST MUIA_SampleED_LoopLen= $E005
                  CONST MUIM_SampleED_Update= $E100
->                   this method will update the sample
->                   what will be updated depends on the parameter


OBJECT obj_sampleeddata
      sample:PTR TO obj_sample
      loopstart
      looplen
      cursor

      oldxs -> pos at window! not in sample,for range updating
      oldxe
      oldx -> old cursor pos, -1 = no cursor available

      sx -> for range selection
      xp
      ch -> for shift+ranging, 0=none, 1=start fixed, 2=end fixed

      allchange
      cursorchange
      rangechange
      loopchange
      offsetchange
ENDOBJECT



PROC sampleed_new(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opset)
DEF data:PTR TO obj_sampleeddata,
    tags:PTR TO tagitem,
    tag:PTR TO tagitem
DEF t
      IF (obj:=doSuperMethodA(cl,obj,msg))=NIL THEN RETURN 0

      data:=INST_DATA(cl,obj)

      /* parse initial taglist */
      tags:=msg.attrlist
      WHILE tag:=NextTagItem({tags})
            t:=tag.tag
            SELECT t
            CASE MUIA_SampleED_Sample
                        data.sample:=tag.data
            CASE MUIA_SampleED_Cursor
                        data.cursor:=tag.data
            CASE MUIA_SampleED_LoopStart
                        data.loopstart:=tag.data
            CASE MUIA_SampleED_LoopLen
                        data.looplen:=tag.data
            ENDSELECT
  ENDWHILE

ENDPROC obj


/* OM_NEW didnt allocates something, just DO nothing here... */

PROC sampleed_dispose(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg) IS
  doSuperMethodA(cl,obj,msg)

PROC sampleed_set(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opset)
DEF data:PTR TO obj_sampleeddata,
    tags:PTR TO tagitem,
    tag:PTR TO tagitem
DEF t
      data:=INST_DATA(cl,obj)
      tags:=msg.attrlist
      WHILE tag:=NextTagItem({tags})
      t:=tag.tag
      SELECT t
      CASE MUIA_SampleED_Sample
            data.sample:=tag.data
            data.allchange:=TRUE
            data.oldxs:=0
            data.oldxe:=0
            data.oldx:=-1
            Mui_Redraw(obj,MADF_DRAWUPDATE)
      CASE MUIA_SampleED_Cursor
            data.cursor:=tag.data
            data.cursorchange:=TRUE
            Mui_Redraw(obj,MADF_DRAWUPDATE)
      CASE MUIA_SampleED_LoopStart
            data.loopstart:=tag.data
            data.loopchange:=TRUE
            Mui_Redraw(obj,MADF_DRAWUPDATE)
      CASE MUIA_SampleED_LoopLen
            data.looplen:=tag.data
            data.loopchange:=TRUE
            Mui_Redraw(obj,MADF_DRAWUPDATE)
      ENDSELECT
      ENDWHILE

ENDPROC doSuperMethodA(cl,obj,msg)


PROC sampleed_get(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opget)
DEF data:PTR TO obj_sampleeddata,storage
DEF a

      data:=INST_DATA(cl,obj)
      storage:=msg.storage

      a:=msg.attrid
      SELECT a
            CASE MUIA_SampleED_Sample
                  ^storage:=data.sample
                  RETURN MUI_TRUE
            CASE MUIA_SampleED_Cursor
                  ^storage:=data.cursor
                  RETURN MUI_TRUE
            CASE MUIA_SampleED_LoopStart
                  ^storage:=data.loopstart
                  RETURN MUI_TRUE
            CASE MUIA_SampleED_LoopLen
                  ^storage:=data.looplen
                  RETURN MUI_TRUE
      ENDSELECT
ENDPROC doSuperMethodA(cl,obj,msg)


PROC sampleed_askminmax(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_askminmax)
  doSuperMethodA(cl,obj,msg)

  msg.minmaxinfo.minwidth := msg.minmaxinfo.minwidth + 500
  msg.minmaxinfo.defwidth := msg.minmaxinfo.defwidth + 600
  msg.minmaxinfo.maxwidth := msg.minmaxinfo.maxwidth + MUI_MAXMAX

  msg.minmaxinfo.minheight := msg.minmaxinfo.minheight + 60
  msg.minmaxinfo.defheight := msg.minmaxinfo.defheight + 150
  msg.minmaxinfo.maxheight := msg.minmaxinfo.maxheight + MUI_MAXMAX

ENDPROC 0



PROC sampleed_setup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleinput)

  IF doSuperMethodA(cl,obj,msg)=NIL THEN RETURN FALSE
  Mui_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS)
ENDPROC MUI_TRUE



PROC sampleed_cleanup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleinput)

  Mui_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS)
ENDPROC doSuperMethodA(cl,obj,msg)



PROC sampleed_handleinput(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleinput)
#define _between(a,x,b) (((x)>=(a)) AND ((x)<=(b)))
#define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) AND _between(_mtop(obj),(y),_bottom(obj)))

DEF data:PTR TO obj_sampleeddata,
    selectdummy

  data:=INST_DATA(cl,obj)
  IF data.sample=NIL THEN RETURN doSuperMethodA(cl,obj,msg)
  IF msg.imsg
    selectdummy:=msg.imsg.class
    SELECT selectdummy
      CASE IDCMP_MOUSEBUTTONS
        IF msg.imsg.code=SELECTDOWN -> leftbuttonpressed
          IF _isinobject(msg.imsg.mousex,msg.imsg.mousey)
                IF shiftflg
                  data.ch:=getchflg(data,msg.imsg.mousex,_mleft(obj),_mright(obj))
                  IF data.ch=0 THEN startmouserange(data,msg.imsg.mousex-_mleft(obj),_mleft(obj),_mright(obj))
                 ELSE
                  data.ch:=0
                  startmouserange(data,msg.imsg.mousex-_mleft(obj),_mleft(obj),_mright(obj))
                ENDIF
                Mui_RequestIDCMP(obj,IDCMP_MOUSEMOVE)
          ENDIF
        ELSE

          -> reject IDCMP_MOUSEMOVE because THEN lmb IS no longer pressed
          Mui_RejectIDCMP(obj,IDCMP_MOUSEMOVE)
        ENDIF
      CASE IDCMP_MOUSEMOVE
        IF _isinobject(msg.imsg.mousex,msg.imsg.mousey)
              IF data.ch>0
                  mouserange2(data,msg.imsg.mousex-_mleft(obj),_mleft(obj),_mright(obj))
            ELSE

              mouserange(data,msg.imsg.mousex-_mleft(obj),_mleft(obj),_mright(obj))
              ENDIF
        ENDIF
    ENDSELECT
  ENDIF

ENDPROC doSuperMethodA(cl,obj,msg)



PROC sampleed_draw(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_draw)
DEF data:PTR TO obj_sampleeddata,rp:PTR TO rastport

      data:=INST_DATA(cl,obj)
      doSuperMethodA(cl,obj,msg)
      rp:=_rp(obj)

      IF (msg.flags AND MADF_DRAWUPDATE)
            IF data.allchange
                  SetAPen(rp,_dri(obj).pens[0])
                  RectFill(rp,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                  IF data.sample
                        drawsample(data.sample,rp,obj,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                        drawrange(data.sample,rp,data,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                        drawcursor(data.sample,rp,data,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                  ENDIF
                  data.allchange:=FALSE;data.cursorchange:=FALSE
                  data.rangechange:=FALSE;data.loopchange:=FALSE
            ENDIF
            IF data.rangechange
                  IF data.sample
                        drawrange(data.sample,rp,data,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                        data.rangechange:=FALSE
                  ENDIF
            ENDIF
            IF data.cursorchange
                  IF data.sample
                        drawcursor(data.sample,rp,data,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                        data.cursorchange:=FALSE
                  ENDIF
            ENDIF


      ELSEIF (msg.flags AND MADF_DRAWOBJECT)
            SetAPen(rp,_dri(obj).pens[0])
            RectFill(rp,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
            data.oldxs:=0;data.oldxe:=0;data.oldx:=-1
            IF data.sample
                  drawsample(data.sample,rp,obj,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                  drawrange(data.sample,rp,data,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
                  drawcursor(data.sample,rp,data,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
            ENDIF

      ENDIF
      data.cursorchange:=FALSE
      data.rangechange:=FALSE;data.loopchange:=FALSE
      data.offsetchange:=FALSE
ENDPROC 0


PROC sampleed_update(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO LONG)
      DEF data:PTR TO obj_sampleeddata,update

      data:=INST_DATA(cl,obj)
      IF data.sample
            update:=msg[1]
            SELECT update
                  CASE UPDATE_RNG
                  data.rangechange:=TRUE
                  Mui_Redraw(obj,MADF_DRAWUPDATE)
                  CASE UPDATE_CURSOR
                  data.cursorchange:=TRUE
                  Mui_Redraw(obj,MADF_DRAWUPDATE)
            ENDSELECT
      ENDIF
ENDPROC



PROC sampleed_dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
DEF methodID
methodID:=msg.methodid

    SELECT methodID
        CASE OM_NEW; RETURN sampleed_new(cl,obj,msg)
        CASE OM_DISPOSE; RETURN sampleed_dispose(cl,obj,msg)
        CASE OM_SET; RETURN sampleed_set(cl,obj,msg)
        CASE OM_GET; RETURN sampleed_get(cl,obj,msg)
        CASE MUIM_AskMinMax; RETURN sampleed_askminmax(cl,obj,msg)
        CASE MUIM_Draw; RETURN sampleed_draw(cl,obj,msg)
        CASE MUIM_Setup; RETURN sampleed_setup(cl,obj,msg)
        CASE MUIM_Cleanup; RETURN sampleed_cleanup(cl,obj,msg)
        CASE MUIM_HandleInput; RETURN sampleed_handleinput(cl,obj,msg)
        CASE MUIM_SampleED_Update; RETURN sampleed_update(cl,obj,msg)
    ENDSELECT


    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC


EXPORT PROC init_sampleed()
DEF temp:PTR TO mui_customclass
temp:=eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF obj_sampleeddata,{sampleed_dispatcher})
IF temp THEN temp:=temp.mcc_class
ENDPROC temp



PROC drawsample(s:PTR TO obj_sample,rp:PTR TO rastport,obj:PTR TO object,xmin,ymin,xmax,ymax)
DEF xsiz,ysiz,stpx,ycoef,i,y,pos,buf,osa1,osa2,ofs,dispfrms,ycoef1,ii
DEF drawbuf[1600]:ARRAY OF INT
DEF drawbuf2[1600]:ARRAY OF INT

      xsiz:=xmax-xmin
      ysiz:=ymax-ymin
      buf:=s.data.buffer
      ofs:=s.offset
      dispfrms:=s.dispfrms

      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      SetAPen(rp,_dri(obj).pens[SHINEPEN])

      IF s.data.stereo
            osa1:=ymin+(ysiz/4)
            osa2:=ymin+(3*ysiz/4)
            FOR i:=0 TO (xsiz-1)
                  drawbuf[i]:=osa1
                  drawbuf2[i]:=osa2
            ENDFOR
            Move(rp,xmin,osa1)
            Draw(rp,xmax,osa1)
            Move(rp,xmin,osa2)
            Draw(rp,xmax,osa2)

            IF s.data.type
                  SetAPen(rp,_dri(obj).pens[SHADOWPEN])

                  MOVE.L drawbuf,A0 -> A0 = drawbuf
                  MOVE.L drawbuf2,A1
                  MOVEQ #0,D0    -> D0 = counter

      drsloop4:   MOVE.L stpx,D2
                  LONG $4c002002 ->MULU.L D0,D2
                  ASR.L #4,D2
                  ADD.L ofs,D2   -> frame pos in D2

                  -> 16bit extract
                  MOVE.L buf,A2
                  ADDA.L D2,A2
                  ADDA.L D2,A2
                  ADDA.L D2,A2
                  ADDA.L D2,A2
                  -> leftchannel
                  MOVE.W (A2)+,D2  ->word sample in D2
                  MOVE.L ysiz,D1
                  MULS.W D1,D2 -> D2=LONG after
                  ASR.L #8,D2
                  ASR.L #8,D2 -> vysledek v D2, LONG
                  ASR.L #1,D2
                  MOVE.L osa1,D1
                  SUB.L D2,D1
                  MOVE.W D1,(A0)+
                  -> rightchannel
                  MOVE.W (A2),D2  ->word sample in D2
                  MOVE.L ysiz,D1
                  MULS.W D1,D2 -> D2=LONG after
                  ASR.L #8,D2
                  ASR.L #8,D2 -> vysledek v D2, LONG
                  ASR.L #1,D2
                  MOVE.L osa2,D1
                  SUB.L D2,D1
                  MOVE.W D1,(A1)+

                  BTST #2,$dff016
                  BEQ drqloop4
                  ADDQ #1,D0
                  CMP.L xsiz,D0
                  BNE drsloop4

                  -> drawbuffer,leftchannel
       drqloop4:  MOVE.L D0,ii
                  Move(rp,xmin,osa1)

                  MOVEQ #0,D2
                  MOVE.L drawbuf,A2

       drdloop4:  MOVE.W (A2)+,D1
                  MOVE.L rp,A1
                  MOVE.L D2,D0
                  ADD.L xmin,D0
                  MOVE.L gfxbase,A6
                  JSR Draw(A6)
                  ADDQ #1,D2
                  CMP.L xsiz,D2
                  BNE drdloop4
                  -> drawbuffer,rightchannel
                  Move(rp,xmin,osa2)

                  MOVEQ #0,D2
                  MOVE.L drawbuf2,A2

       drrloop4:  MOVE.W (A2)+,D1
                  MOVE.L rp,A1
                  MOVE.L D2,D0
                  ADD.L xmin,D0
                  MOVE.L gfxbase,A6
                  JSR Draw(A6)
                  ADDQ #1,D2
                  CMP.L xsiz,D2
                  BNE drrloop4

                  IF ii<xsiz
                        SetAPen(rp,2);Move(rp,xmin+1,ymax-1);Text(rp,'REDRAW ABORTED',14)
                  ENDIF

            ELSE
                  SetAPen(rp,_dri(obj).pens[SHADOWPEN])

                  MOVE.L drawbuf,A0 -> A0 = drawbuf
                  MOVE.L drawbuf2,A1
                  MOVEQ #0,D0    -> D0 = counter

      drsloop3:   MOVE.L stpx,D2
                  LONG $4c002002 ->MULU.L D0,D2
                  ASR.L #4,D2
                  ADD.L ofs,D2   -> frame pos in D2

                  -> 8bit extract
                  MOVE.L buf,A2
                  ADDA.L D2,A2
                  ADDA.L D2,A2
                  -> left channel
                  MOVE.B (A2)+,D2  ->byte sample in D2
                  EXT.W D2        ->sample word in D2
                  MOVE.L ysiz,D1
                  MULS.W D1,D2 -> D2=LONG after
                  ASR.L #8,D2
                  ASR.L #1,D2 -> vysledek v D2, LONG
                  MOVE.L osa1,D1
                  SUB.L D2,D1
                  MOVE.W D1,(A0)+

                  MOVE.B (A2),D2  ->byte sample in D2
                  EXT.W D2        ->sample word in D2
                  MOVE.L ysiz,D1
                  MULS.W D1,D2 -> D2=LONG after
                  ASR.L #8,D2
                  ASR.L #1,D2 -> vysledek v D2, LONG
                  MOVE.L osa2,D1
                  SUB.L D2,D1
                  MOVE.W D1,(A1)+

                  BTST #2,$dff016
                  BEQ drqloop3
                  ADDQ #1,D0
                  CMP.L xsiz,D0
                  BNE drsloop3

       drqloop3:  MOVE.L D0,ii
                  Move(rp,xmin,osa1)

                  -> drawbuffer
                  MOVEQ #0,D2
                  MOVE.L drawbuf,A2

       drdloop3:  MOVE.W (A2)+,D1
                  MOVE.L rp,A1
                  MOVE.L D2,D0
                  ADD.L xmin,D0
                  MOVE.L gfxbase,A6
                  JSR Draw(A6)
                  ADDQ #1,D2
                  CMP.L xsiz,D2
                  BNE drdloop3

                  Move(rp,xmin,osa2)

                  MOVEQ #0,D2
                  MOVE.L drawbuf2,A2

       drrloop3:  MOVE.W (A2)+,D1
                  MOVE.L rp,A1
                  MOVE.L D2,D0
                  ADD.L xmin,D0
                  MOVE.L gfxbase,A6
                  JSR Draw(A6)
                  ADDQ #1,D2
                  CMP.L xsiz,D2
                  BNE drrloop3

                  IF ii<xsiz
                        SetAPen(rp,2);Move(rp,xmin+1,ymax-1);Text(rp,'REDRAW ABORTED',14)
                  ENDIF
            ENDIF
      ELSE
            osa1:=ymin+(ysiz/2)
            FOR i:=0 TO (xsiz-1) DO drawbuf[i]:=osa1
            Move(rp,xmin,osa1)
            Draw(rp,xmax,osa1)

            IF s.data.type
                  SetAPen(rp,_dri(obj).pens[SHADOWPEN])
                  Move(rp,xmin,osa1)

                  MOVE.L drawbuf,A0 -> A0 = drawbuf
                  MOVE.L buf,A1     -> A1 = samplebuf
                  MOVEQ #0,D0    -> D0 = counter

      drsloop2:   MOVE.L stpx,D2
                  LONG $4c002002 ->MULU.L D0,D2
                  ASR.L #4,D2
                  ADD.L ofs,D2   -> frame pos in D2

                  -> 16bit extract
                  MOVE.L A1,A2
                  ADDA.L D2,A2
                  ADDA.L D2,A2
                  MOVE.W (A2),D2  ->word sample in D2
                  MOVE.L ysiz,D1
                  MULS.W D1,D2 -> D2=LONG after
                  ASR.L #8,D2
                  ASR.L #8,D2 -> vysledek v D2, LONG
                  MOVE.L osa1,D1
                  SUB.L D2,D1
                  MOVE.W D1,(A0)+
                  BTST #2,$dff016
                  BEQ drqloop2
                  ADDQ #1,D0
                  CMP.L xsiz,D0
                  BNE drsloop2

                  -> drawbuffer
       drqloop2:  MOVE.L D0,ii
                  MOVEQ #0,D2
                  MOVE.L drawbuf,A2

       drdloop2:  MOVE.W (A2)+,D1
                  MOVE.L rp,A1
                  MOVE.L D2,D0
                  ADD.L xmin,D0
                  MOVE.L gfxbase,A6
                  JSR Draw(A6)
                  ADDQ #1,D2
                  CMP.L xsiz,D2
                  BNE drdloop2

                  IF ii<xsiz
                        SetAPen(rp,2);Move(rp,xmin+1,ymax-1);Text(rp,'REDRAW ABORTED',14)
                  ENDIF

            ELSE
                  SetAPen(rp,_dri(obj).pens[SHADOWPEN])
                  Move(rp,xmin,osa1)

                  MOVE.L drawbuf,A0 -> A0 = drawbuf
                  MOVE.L buf,A1     -> A1 = samplebuf
                  MOVEQ #0,D0    -> D0 = counter

      drsloop1:   MOVE.L stpx,D2
                  LONG $4c002002 ->MULU.L D0,D2
                  ASR.L #4,D2
                  ADD.L ofs,D2   -> frame pos in D2

                  -> 8bit extract
                  MOVE.L A1,A2
                  ADDA.L D2,A2
                  MOVE.B (A2),D2  ->byte sample in D2
                  EXT.W D2        ->sample word in D2
                  MOVE.L ysiz,D1
                  MULS.W D1,D2 -> D2=LONG after
                  ASR.L #8,D2 -> vysledek v D2, LONG
                  MOVE.L osa1,D1
                  SUB.L D2,D1
                  MOVE.W D1,(A0)+
                  BTST #2,$dff016
                  BEQ drqloop1
                  ADDQ #1,D0
                  CMP.L xsiz,D0
                  BNE drsloop1

                  -> drawbuffer
       drqloop1:  MOVE.L D0,ii
                  MOVEQ #0,D2
                  MOVE.L drawbuf,A2

       drdloop1:  MOVE.W (A2)+,D1
                  MOVE.L rp,A1
                  MOVE.L D2,D0
                  ADD.L xmin,D0
                  MOVE.L gfxbase,A6
                  JSR Draw(A6)
                  ADDQ #1,D2
                  CMP.L xsiz,D2
                  BNE drdloop1

                  IF ii<xsiz
                        SetAPen(rp,2);Move(rp,xmin+1,ymax-1);Text(rp,'REDRAW ABORTED',14)
                  ENDIF

            ENDIF



      ENDIF
      
ENDPROC


PROC drawrange(s:PTR TO obj_sample,rp:PTR TO rastport,data:PTR TO obj_sampleeddata,xmin,ymin,xmax,ymax)
DEF oldmode,newxs,newxe,xsiz,ysiz,ofs,dispfrms,stpx,rngs,rnge

      -> calculate newpos
      xsiz:=xmax-xmin
      ysiz:=ymax-ymin
      ofs:=s.offset
      dispfrms:=s.dispfrms
      rngs:=s.rngstart
      rnge:=rngs+s.rnglen
      IF s.rnglen>0
      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      -> calc newxs
      MOVE.L rngs,D0
      SUB.L ofs,D0
      ASL.L #4,D0
      MOVE.L stpx,D1
      LONG $4c410800 -> DIVS.L D1,D0
      ADD.L xmin,D0
      MOVE.L D0,newxs
      -> calc newxe
      MOVE.L rnge,D0
      SUB.L ofs,D0
      ASL.L #4,D0
      MOVE.L stpx,D1
      LONG $4c410800 -> DIVS.L D1,D0
      ADD.L xmin,D0
      MOVE.L D0,newxe
      IF newxs<xmin THEN newxs:=xmin
      IF newxe>xmax THEN newxe:=xmax

      ELSE
            newxe:=0
            newxs:=0
      ENDIF

      oldmode:=GetDrMd(rp)
      SetDrMd(rp,RP_COMPLEMENT)
      IF (data.oldxs=0) AND (data.oldxe=0)
            IF (s.rngstart+s.rnglen)<ofs THEN JUMP ppp
            IF s.rngstart>(ofs+dispfrms) THEN JUMP ppp
            IF s.rnglen>0 THEN RectFill(rp,newxs,ymin,newxe,ymax)
      ELSEIF s.rnglen=0
            IF (data.oldxs>0) AND (data.oldxe>0) THEN RectFill(rp,data.oldxs,ymin,data.oldxe,ymax)
      ELSE
            IF newxs=data.oldxs
                  IF newxe>data.oldxe
                        RectFill(rp,data.oldxe+1,ymin,newxe,ymax)
                  ELSEIF newxe<data.oldxe
                        RectFill(rp,newxe+1,ymin,data.oldxe,ymax)
                  ENDIF
            ELSEIF newxe=data.oldxe
                  IF newxs<data.oldxs
                        RectFill(rp,newxs,ymin,data.oldxs-1,ymax)
                  ELSEIF newxs>data.oldxs
                        RectFill(rp,data.oldxs,ymin,newxs-1,ymax)
                  ENDIF
            ELSE
                  RectFill(rp,data.oldxs,ymin,data.oldxe,ymax)
                  RectFill(rp,newxs,ymin,newxe,ymax)
            ENDIF
      ENDIF

data.oldxs:=newxs;data.oldxe:=newxe
ppp:SetDrMd(rp,oldmode)
ENDPROC


PROC drawcursor(s:PTR TO obj_sample,rp:PTR TO rastport,data:PTR TO obj_sampleeddata,xmin,ymin,xmax,ymax)
DEF oldmode,newx,xsiz,ysiz,ofs,dispfrms,stpx,cursor

      -> calculate newpos
      xsiz:=xmax-xmin
      ysiz:=ymax-ymin
      ofs:=s.offset
      dispfrms:=s.dispfrms
      cursor:=s.cursor  -> cursor position in frames

      IF cursor>-1
      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      -> calc newx
      MOVE.L cursor,D0
      SUB.L ofs,D0
      ASL.L #4,D0
      MOVE.L stpx,D1
      LONG $4c410800 -> DIVS.L D1,D0
      ADD.L xmin,D0
      MOVE.L D0,newx
      ELSE
      newx:=-1
      ENDIF

      IF newx<xmin THEN newx:=-1
      IF newx>xmax THEN newx:=-1


      oldmode:=GetDrMd(rp)
      SetDrMd(rp,RP_COMPLEMENT)

      IF data.oldx<>-1
                  Move(rp,data.oldx,ymin)
                  Draw(rp,data.oldx,ymax)
            ENDIF

      IF (newx<>-1) AND (cursor>=ofs) AND (cursor-ofs<dispfrms)
            Move(rp,newx,ymin)
            Draw(rp,newx,ymax)
            data.oldx:=newx
      ELSE
            data.oldx:=-1
      ENDIF

SetDrMd(rp,oldmode)
ENDPROC


PROC startmouserange(data:PTR TO obj_sampleeddata,x,xmin,xmax)
      DEF rsp,stpx,xsiz,ofs,dispfrms
      DEF s:PTR TO obj_sample

      data.sx:=x
      s:=data.sample
      xsiz:=xmax-xmin
      ofs:=s.offset
      dispfrms:=s.dispfrms

      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      MOVE.L x,D0
      MOVE.L stpx,D2
      LONG $4c002002 ->MULU.L D0,D2
      ASR.L #4,D2
      ADD.L ofs,D2
      MOVE.L D2,rsp

      s.setparam([SMRANGE,rsp,0])
ENDPROC


PROC getchflg(data:PTR TO obj_sampleeddata,x,xmin,xmax)
      DEF temp
      DEF rsp,stpx,xsiz,ofs,dispfrms,oldrnge
      DEF s:PTR TO obj_sample

      IF (data.oldxs=0) AND (data.oldxe=0) THEN RETURN 0
      IF Abs(x-data.oldxs)<Abs(x-data.oldxe)
            temp:=2
      ELSE
            temp:=1
      ENDIF

      x:=x-xmin
      s:=data.sample
      xsiz:=xmax-xmin
      ofs:=s.offset
      dispfrms:=s.dispfrms
      oldrnge:=s.rngstart+s.rnglen
      
      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      IF temp=1 THEN INC x

      MOVE.L x,D0
      MOVE.L stpx,D2
      LONG $4c002002 ->MULU.L D0,D2
      ASR.L #4,D2
      ADD.L ofs,D2
      MOVE.L D2,rsp

      IF temp=1
            s.setparam([SMRANGE,s.rngstart,rsp-s.rngstart])
            data.sx:=data.oldxs-xmin
            data.xp:=s.rngstart
      ELSE
            s.setparam([SMRANGE,rsp,oldrnge-rsp])
            data.sx:=data.oldxe-xmin
            data.xp:=oldrnge
      ENDIF
ENDPROC temp




PROC mouserange(data:PTR TO obj_sampleeddata,ex,xmin,xmax)
      DEF rs,re,rl  ->rangestart,rangeend
      DEF rsp,rlen -> pos in sample
      DEF stpx,xsiz,ofs,dispfrms
      DEF s:PTR TO obj_sample

      IF ex>data.sx
            rs:=data.sx
            re:=ex
      ELSE
            rs:=ex
            re:=data.sx
      ENDIF

      s:=data.sample
      xsiz:=xmax-xmin
      ofs:=s.offset
      dispfrms:=s.dispfrms
      rl:=re-rs+1

      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      MOVE.L rs,D0
      MOVE.L stpx,D2
      LONG $4c002002 ->MULU.L D0,D2
      ASR.L #4,D2
      ADD.L ofs,D2
      MOVE.L D2,rsp

      MOVE.L rl,D0
      MOVE.L stpx,D2
      LONG $4c002002 ->MULU.L D0,D2
      ASR.L #4,D2
      MOVE.L D2,rlen

      s.setparam([SMRANGE,rsp,rlen])

ENDPROC


PROC mouserange2(data:PTR TO obj_sampleeddata,ex,xmin,xmax)
      DEF temp
      DEF rsp,stpx,xsiz,ofs,dispfrms,oldrnge
      DEF s:PTR TO obj_sample

      temp:=data.ch


      s:=data.sample
      xsiz:=xmax-xmin
      ofs:=s.offset
      dispfrms:=s.dispfrms
      oldrnge:=s.rngstart+s.rnglen

      MOVE.L dispfrms,D0
      ASL.L #4,D0
      MOVE.L xsiz,D1
      LONG $4c410000 -> DIVU.L D1,D0
      MOVE.L D0,stpx

      IF temp=1 THEN INC ex
      MOVE.L ex,D0
      MOVE.L stpx,D2
      LONG $4c002002 ->MULU.L D0,D2
      ASR.L #4,D2
      ADD.L ofs,D2
      MOVE.L D2,rsp

      IF temp=1
            IF rsp<s.rngstart THEN rsp:=s.rngstart
            s.setparam([SMRANGE,s.rngstart,rsp-s.rngstart])
            data.sx:=data.oldxs-xmin
            data.xp:=s.rngstart
      ELSE
            IF rsp>oldrnge THEN rsp:=oldrnge
            s.setparam([SMRANGE,rsp,oldrnge-rsp])
            data.sx:=data.oldxe-xmin
            data.xp:=oldrnge
      ENDIF
ENDPROC temp
-> --------------------------------------------------------------------











-> --------------------  sample OBJECT stuff

PROC create2(name,buffer,frames,type=0,stereo=0,rate=8363) OF obj_sample
      UPDOFF
      self.setname(name)
      UPDON
      self.data.buffer:=buffer
      self.data.frames:=frames
      self.data.type:=type
      self.data.stereo:=stereo
      self.rate:=rate
      self.dispfrms:=frames
      self.cursor:=-1
ENDPROC

PROC end() OF obj_sample
      IF self.activeflg THEN self.deactivate()
      IF self.data.buffer THEN FreeVec(self.data.buffer)
      SUPER self.end()
ENDPROC

PROC setname(x) OF obj_sample
      SUPER self.setname(x)
      IF upd THEN nset(_smed.stname,MUIA_String_Contents,self.getname())
ENDPROC

PROC activate() OF obj_sample
      DEF s[20]:STRING

      SUPER self.activate()
      IF upd
            nset(_smed.stname,MUIA_String_Contents,self.getname())
            nset(_smed.stbuffer,MUIA_String_Integer,self.data.frames)
            nset(_smed.strngstart,MUIA_String_Integer,self.rngstart)
            nset(_smed.strnglen,MUIA_String_Integer,self.rnglen)
            nset(_smed.stpitch,MUIA_String_Integer,self.rate)
            nset(_smed.ch16bit,MUIA_Selected,self.data.type)
            nset(_smed.chstereo,MUIA_Selected,self.data.stereo)
            StringF(s,'\d',self.dispfrms)
            nset(_smed.txdispsize,MUIA_Text_Contents,s)

            nset(_smed.przoom,MUIA_Prop_Entries,self.data.frames)
            nset(_smed.przoom,MUIA_Prop_First,self.dispfrms-1)
            nset(_smed.proffset,MUIA_Prop_Entries,self.data.frames)
            nset(_smed.proffset,MUIA_Prop_Visible,self.dispfrms)
            nset(_smed.proffset,MUIA_Prop_First,self.offset)
            ->updatetitle()
            self.redraw()
      ENDIF
ENDPROC

PROC redraw() OF obj_sample
      set(_smed.editarea,MUIA_SampleED_Sample,self)

ENDPROC

PROC deactivate() OF obj_sample
      SUPER self.deactivate()
      ->updatetitle()
ENDPROC


PROC setparam(pl:PTR TO LONG) OF obj_sample
      DEF p,x,y

      p:=pl[0];x:=pl[1]
      SELECT p
            CASE SMFRAMES
                  IF x<1 THEN x:=1
                  IF x>268435456 THEN x:=268435456
                  self.changeframes(x)
                  SCHANGED
                  CHANGED
            CASE SMTYPE
                  IF x THEN self.incbits() ELSE self.decbits()
                  IF upd THEN nset(_smed.ch16bit,MUIA_Selected,x)
                  SCHANGED
                  CHANGED
            CASE SMSTEREO
                  IF x THEN self.mono2stereo() ELSE self.stereo2mono()
                  IF upd THEN nset(_smed.chstereo,MUIA_Selected,x)
                  SCHANGED
                  CHANGED
            CASE SMRATE
                  IF x<2000 THEN x:=2000
                  IF x>176400 THEN x:=176400
                  self.rate:=x
                  IF upd THEN nset(_smed.stpitch,MUIA_String_Integer,x)
                  CHANGED
            CASE SMRNGSTART
                  IF x<0 THEN x:=0
                  IF x>(self.data.frames-1) THEN x:=self.data.frames-1
                  IF (x+self.rnglen)>(self.data.frames) THEN self.setparam([SMRNGLEN,self.data.frames-x-1])
                  self.rngstart:=x
                  IF upd
                        nset(_smed.strngstart,MUIA_String_Integer,x)
                        domethod(_smed.editarea,[MUIM_SampleED_Update,UPDATE_RNG])
                  ENDIF
            CASE SMRNGLEN
                  IF x<0 THEN x:=0
                  IF (x+self.rngstart)>(self.data.frames) THEN x:=self.data.frames-self.rngstart-1
                  self.rnglen:=x
                  IF upd
                        nset(_smed.strnglen,MUIA_String_Integer,x)
                        domethod(_smed.editarea,[MUIM_SampleED_Update,UPDATE_RNG])
                  ENDIF
            CASE SMCURSOR
                  IF x<0 THEN x:=-1
                  IF (x>(self.data.frames-1)) THEN x:=(self.data.frames-1)
                  self.cursor:=x
                  IF upd THEN domethod(_smed.editarea,[MUIM_SampleED_Update,UPDATE_CURSOR])
            CASE SMRANGE
                  y:=pl[2]
                  IF x<0 THEN x:=0
                  IF y<0 THEN y:=0
                  IF x>(self.data.frames-1) THEN x:=self.data.frames-1
                  IF (x+y)>(self.data.frames) THEN y:=self.data.frames-x-1
                  self.rngstart:=x
                  self.rnglen:=y
                  IF upd
                        nset(_smed.strngstart,MUIA_String_Integer,x)
                        nset(_smed.strnglen,MUIA_String_Integer,y)
                        domethod(_smed.editarea,[MUIM_SampleED_Update,UPDATE_RNG])
                  ENDIF
            CASE SMOFFSET
                  self.offset:=x
                  IF upd
                        nset(_smed.proffset,MUIA_Prop_First,x)
                        self.redraw()
                  ENDIF
            CASE SMZOOM
                  self.setzoom(x+1)

      ENDSELECT
ENDPROC

PROC getparam(p) OF obj_sample
      SELECT p
            CASE SMFRAMES
                  RETURN self.data.frames
            CASE SMTYPE
                  RETURN self.data.type
            CASE SMSTEREO
                  RETURN self.data.stereo
            CASE SMRATE
                  RETURN self.rate
            CASE SMRNGSTART
                  RETURN self.rngstart
            CASE SMRNGLEN
                  RETURN self.rnglen
            CASE SMOFFSET
                  RETURN self.offset
            CASE SMZOOM
                  RETURN self.dispfrms-1
      ENDSELECT
ENDPROC

PROC frames2len(nf) OF obj_sample
      DEF len

      len:=0
      IF self.data.stereo
            IF self.data.type THEN len:=Shl(nf,2) ELSE len:=Shl(nf,1)
      ELSE
            IF self.data.type THEN len:=Shl(nf,1) ELSE len:=nf
      ENDIF
ENDPROC len


PROC changeframes(nf) OF obj_sample
      DEF temp,oldlen,newlen

      IF nf=self.data.frames THEN RETURN
      sleep()
      status('Changing sample size')
      oldlen:=self.frames2len(self.data.frames)
      newlen:=self.frames2len(nf)
      temp:=AllocVec(newlen,memflag OR MEMF_CLEAR)
      IF temp=NIL
            awake()
            sidle()
            errnomem()
      ENDIF

      IF newlen>oldlen
            copymemcache(self.data.buffer,temp,oldlen)
      ELSE
            copymemcache(self.data.buffer,temp,newlen)
      ENDIF

      FreeVec(self.data.buffer)
      self.data.buffer:=temp
      self.data.frames:=nf
      self.dispfrms:=nf
      IF self.rngstart>(self.data.frames-1)
            self.rngstart:=0
            self.rnglen:=0
      ENDIF
      IF (self.rngstart+self.rnglen)>(self.data.frames-1)
            self.rnglen:=self.data.frames-self.rngstart
      ENDIF
      awake()
      sidle()
      IF self.activeflg THEN self.activate()
ENDPROC


PROC mono2stereo() OF obj_sample
      DEF oldlen,newlen,newbuf,oldbuf,frm

      IF self.data.stereo THEN RETURN
      sleep()
      status('Recalculating sample')
      oldlen:=self.frames2len(self.data.frames)
      newlen:=Shl(oldlen,1)
      oldbuf:=self.data.buffer
      frm:=self.data.frames

      newbuf:=AllocVec(newlen,memflag)
      IF newbuf=NIL
            awake()
            sidle()
            IF self.activeflg AND upd
                  nset(_smed.ch16bit,MUIA_Selected,self.data.type)
                  nset(_smed.chstereo,MUIA_Selected,self.data.stereo)
            ENDIF
            errnomem()
            RETURN
      ENDIF

      IF self.data.type
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       msl1:
            MOVE.W (A0),(A1)+
            MOVE.W (A0)+,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE msl1
      ELSE
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       msl2:
            MOVE.B (A0),(A1)+
            MOVE.B (A0)+,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE msl2
      ENDIF

      FreeVec(oldbuf)
      self.data.buffer:=newbuf
      self.data.stereo:=MUI_TRUE
      awake()
      sidle()
      IF self.activeflg THEN self.activate()
ENDPROC


PROC stereo2mono() OF obj_sample
DEF oldlen,newlen,newbuf,oldbuf,frm

      IF self.data.stereo=FALSE THEN RETURN
      sleep()
      status('Recalculating sample')
      oldlen:=self.frames2len(self.data.frames)
      newlen:=Shr(oldlen,1)
      oldbuf:=self.data.buffer
      frm:=self.data.frames

      newbuf:=AllocVec(newlen,memflag)
      IF newbuf=NIL
            awake()
            sidle()
            IF self.activeflg AND upd
                  nset(_smed.ch16bit,MUIA_Selected,self.data.type)
                  nset(_smed.chstereo,MUIA_Selected,self.data.stereo)
            ENDIF
            errnomem()
            RETURN
      ENDIF

      IF self.data.type
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       sml1:
            MOVE.W (A0)+,D1
            MOVE.W (A0)+,D2
            ASR.W #1,D1
            ASR.W #1,D2
            ADD.W D1,D2
            MOVE.W D2,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE sml1
      ELSE
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       sml2:
            MOVE.B (A0)+,D1
            MOVE.B (A0)+,D2
            ASR.B #1,D1
            ASR.B #1,D2
            ADD.B D1,D2
            MOVE.B D2,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE sml2
      ENDIF

      FreeVec(oldbuf)
      self.data.buffer:=newbuf
      self.data.stereo:=FALSE
      awake()
      sidle()
      IF self.activeflg THEN self.activate()

ENDPROC


PROC incbits() OF obj_sample -> 8bit to 16bit
      DEF oldlen,newlen,newbuf,oldbuf,frm

      IF self.data.type THEN RETURN
      sleep()
      status('Recalculating sample')
      oldlen:=self.frames2len(self.data.frames)
      newlen:=Shl(oldlen,1)
      oldbuf:=self.data.buffer
      frm:=self.data.frames

      newbuf:=AllocVec(newlen,memflag)
      IF newbuf=NIL
            awake()
            sidle()
            IF self.activeflg AND upd
                  nset(_smed.ch16bit,MUIA_Selected,self.data.type)
                  nset(_smed.chstereo,MUIA_Selected,self.data.stereo)
            ENDIF
            errnomem()
            RETURN
      ENDIF

      IF self.data.stereo
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       ibl1:MOVE.B (A0)+,D1
            LSL.W #8,D1
            MOVE.W D1,(A1)+
            MOVE.B (A0)+,D1
            LSL.W #8,D1
            MOVE.W D1,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE ibl1
      ELSE
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       ibl2:
            MOVE.B (A0)+,D1
            LSL.W #8,D1
            MOVE.W D1,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE ibl2
      ENDIF

      FreeVec(oldbuf)
      self.data.buffer:=newbuf
      self.data.type:=MUI_TRUE
      awake()
      sidle()
      IF self.activeflg THEN self.activate()
ENDPROC

PROC decbits() OF obj_sample ->16bit to 8bit simple
      DEF oldlen,newlen,newbuf,oldbuf,frm

      IF self.data.type=FALSE THEN RETURN
      sleep()
      status('Recalculating sample')
      oldlen:=self.frames2len(self.data.frames)
      newlen:=Shr(oldlen,1)
      oldbuf:=self.data.buffer
      frm:=self.data.frames

      newbuf:=AllocVec(newlen,memflag)
      IF newbuf=NIL
            awake()
            sidle()
            IF self.activeflg AND upd
                  nset(_smed.ch16bit,MUIA_Selected,self.data.type)
                  nset(_smed.chstereo,MUIA_Selected,self.data.stereo)
            ENDIF
            errnomem()
            RETURN
      ENDIF

      IF self.data.stereo
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       dbl1:MOVE.W (A0)+,D1
            LSR.W #8,D1
            MOVE.B D1,(A1)+
            MOVE.W (A0)+,D1
            LSR.W #8,D1
            MOVE.B D1,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE dbl1
      ELSE
            MOVE.L oldbuf,A0
            MOVE.L newbuf,A1
            MOVEQ.L #0,D0
       dbl2:
            MOVE.W (A0)+,D1
            LSR.W #8,D1
            MOVE.B D1,(A1)+
            ADDQ.L #1,D0
            CMP.L frm,D0
            BNE dbl2
      ENDIF

      FreeVec(oldbuf)
      self.data.buffer:=newbuf
      self.data.type:=FALSE
      awake()
      sidle()
      IF self.activeflg THEN self.activate()
ENDPROC



PROC setzoom(nz) OF obj_sample
      DEF m

      ->IF upd THEN nset(_smed.przoom,MUIA_Prop_First,nz-1)
      m:=self.data.frames-nz
      IF self.offset>m THEN self.offset:=m
      self.dispfrms:=nz

      IF self.activeflg THEN self.activate()
ENDPROC


-> ---------------------------- obj_smlist stuff

PROC newone2(name,buffer,frames,type=0,stereo=0,rate=8363) OF obj_smlist
      DEF temp:PTR TO obj_sample

      NEW temp.create2(name,buffer,frames,type,stereo,rate)
ENDPROC temp

PROC freeone(entry:PTR TO obj_sample) OF obj_smlist
      END entry
ENDPROC

PROC renam(slot,name) OF obj_smlist
      SUPER self.renam(slot,name)
      domethod(_pcks.lv,[MUIM_List_Redraw,MUIV_List_Redraw_All])
      CHANGED
ENDPROC

PROC newentry2(slot,name,buffer,frames,type=0,stereo=0,rate=8363) OF obj_smlist
      -> assumes that the slot is EMPTY
      -> danger! this method does not call the SUPER method!
      self.setslot(slot,self.newone2(name,buffer,frames,type,stereo,rate))
      refreshpicksample()
      self.setactive(slot)

ENDPROC

PROC delentry(slot) OF obj_smlist

      SUPER self.delentry(slot)
      refreshpicksample()
      self.setactive(slot)
ENDPROC

PROC delall() OF obj_smlist
DEF slot
      slot:=self.getactive()
      SUPER self.delall()
      refreshpicksample()
      self.setactive(slot)
ENDPROC

PROC create(size,ps:PTR TO LONG) OF obj_smlist

      memflag:=MEMF_ANY
      mpeginit()
      lastlocked:=-2
      NEW siodata
      fucke(siodata)
      ->CDEBUG(SYSTEM: siodata \h,siodata)
ENDPROC SUPER self.create(size,ps)




PROC setactive(slot) OF obj_smlist
DEF i,pos,a

      IF slot=-1 THEN RETURN
      SUPER self.setactive(slot)
      CSP:=self.getp(slot)

      IF upd
            domethod(_smed.txslot,[MUIM_SetAsString,MUIA_Text_Contents,
            '%02.2lx',slot])
            domethod(_mpeg.txslot,[MUIM_SetAsString,MUIA_Text_Contents,
            '%02.2lx',slot])
            updatetitle()
      ENDIF

      IF CSP
            a:=self.findpos(slot)
            nset(_pcks.lv,MUIA_List_Active,a)
      ELSE
            IF upd
            nset(_pcks.lv,MUIA_List_Active,MUIV_List_Active_Off)
            nset(_smed.stname,MUIA_String_Contents,'<Unused Slot>')
            nset(_smed.stbuffer,MUIA_String_Contents,NIL)
            nset(_smed.strngstart,MUIA_String_Contents,NIL)
            nset(_smed.strnglen,MUIA_String_Contents,NIL)
            nset(_smed.stpitch,MUIA_String_Contents,NIL)
            nset(_smed.ch16bit,MUIA_Selected,FALSE)
            nset(_smed.chstereo,MUIA_Selected,FALSE)
            nset(_smed.txdispsize,MUIA_Text_Contents,NIL)
            set(_smed.editarea,MUIA_SampleED_Sample,NIL)

            nset(_smed.przoom,MUIA_Prop_Entries,1)
            nset(_smed.przoom,MUIA_Prop_First,0)
            nset(_smed.proffset,MUIA_Prop_Entries,1)
            nset(_smed.proffset,MUIA_Prop_Visible,1)
            nset(_smed.proffset,MUIA_Prop_First,0)
            
            ENDIF
      ENDIF
ENDPROC

-> -------------------------------------------------------------
PROC refreshpicksample()
DEF t:PTR TO obj_sample
DEF i,j,k,e
      get(_pcks.lv,MUIA_List_Active,{e})
      nset(_pcks.lv,MUIA_List_Quiet,MUI_TRUE)
      domethod(_pcks.lv,[MUIM_List_Clear])

      FOR i:=0 TO sml.max-1
            t:=sml.getp(i)
            IF t
                        j:=fslot(i)
                        k:=t.xb
                        MOVE.L k,A0
                        MOVE.L j,D0
                        MOVE.W D0,(A0)
                        MOVE.W #": ",2(A0)
                        domethod(_pcks.lv,[MUIM_List_InsertSingle,
                                    t.xb,MUIV_List_Insert_Bottom])
           ENDIF
      ENDFOR
      nset(_pcks.lv,MUIA_List_Quiet,FALSE)
      nset(_pcks.lv,MUIA_List_Active,e)
ENDPROC





-> ----------------------------------------------------------------
      /*    SAMPLE INPUT/OUTPUT ROUTINES */

-> -------------------------    sample i/o stuff


PROC requestsample(ppathname,psamplename)
DEF rcode
      rcode:=TRUE
      
      sleep()
      IF Mui_AslRequest(samplereq,NIL)
            StrCopy(ppathname,samplereq.drawer,ALL)
            AddPart(ppathname,samplereq.file,80)
            StrCopy(psamplename,samplereq.file,ALL)
            awake()
            rcode:=0
      ENDIF
      awake()
ENDPROC rcode




PROC recognize(filename) -> will recognize the sample type, input=filehandle
DEF len,buf,fh,hsiz,stype,t1,channels,res,frames

      len:=FileLength(filename)
      IF len=-1 THEN RETURN STYPE_CANTOPEN
      IF len<16 THEN RETURN STYPE_UNRECOGNIZED

      buf:=AllocVec(64,MEMF_PUBLIC OR MEMF_CLEAR OR MEMF_REVERSE)
      IF buf=NIL THEN RETURN STYPE_CANTOPEN
      fh:=Open(filename,OLDFILE)
      IF fh=0
            FreeVec(buf)
            Close(fh)
            RETURN STYPE_CANTOPEN
      ENDIF
      Seek(fh,0,OFFSET_BEGINNING)
      IF len<64 THEN hsiz:=len ELSE hsiz:=64
      Read(fh,buf,hsiz)
      -> detection follows
      stype:=STYPE_UNRECOGNIZED
      -> raw16
         IF Long(buf)="Raw1"
                  stype:=STYPE_RAW16b
                  IF Long(buf+4)="6Bit"
                        stype:=STYPE_RAW16
                  ENDIF
         ELSEIF Long(buf)="FORM"
                  IF Long(buf+8)="AIFF" THEN stype:=STYPE_AIFF
                  IF Long(buf+8)="MAUD" THEN stype:=STYPE_MAUD
                  IF Long(buf+8)="8SVX" THEN stype:=STYPE_8SVX
                  IF Long(buf+8)="16SV" THEN stype:=STYPE_16SV
         ELSEIF Long(buf)="RIFF"
                  IF Long(buf+8)="WAVE" THEN stype:=STYPE_WAVE
         ENDIF
      FreeVec(buf)
      Close(fh)
ENDPROC stype



PROC loadsamplegui(pname,sname)
DEF ppathname[256]:STRING,psamplename[32]:STRING
DEF cslot,stype,senc,flg,res

      cslot:=sml.getactive()
      IF CSP
      sml.delentry(cslot)
      ENDIF
      IF rxm
            StrCopy(ppathname,pname,ALL)
            StrCopy(psamplename,sname,ALL)
      ELSE
            IF requestsample(ppathname,psamplename)<>0 THEN RETURN
      ENDIF

      stype:=recognize(ppathname)
      CDEBUG(SIO: File recognition result \d,stype)
      IF stype=STYPE_CANTOPEN
            err(ERR_NOTFOUND)
            RETURN
      ENDIF
      IF stype=STYPE_UNRECOGNIZED
            IF rxm
                  err(ERR_UNRECOGNIZED)
                  RETURN
            ELSE
                  flg:=Mui_RequestA(_appl.app,NIL,NIL,'Request',
                  '*8bit mono|8bit stereo|16bit mono|16bit stereo|_Cancel',
                  'Sample file format unknown. You can try to load\n'+
                  'it as a RAW sample with selected encoding type.',
                  NIL)
                  IF flg=0 THEN RETURN -> Cancel pressed
                  stype:=STYPE_RAW
                  SELECT flg
                        CASE 1
                              senc:=SENC_PCM8
                        CASE 2
                              senc:=SENC_PCM8S
                        CASE 3
                              senc:=SENC_PCM16
                        CASE 4
                              senc:=SENC_PCM16S
                  ENDSELECT
            ENDIF
      ENDIF
      res:=loadsample(cslot,ppathname,psamplename,stype,senc)
            SELECT res
                  CASE SIO_OK
                        logit('Sample loaded OK')
                  CASE SIO_CANTOPEN
                        err(ERR_CANTOPEN)
                  CASE SIO_NOMEM
                        errnomem()
                  CASE SIO_READERROR
                        err(ERR_READ)
                  CASE SIO_FILEPROBLEM
                        err(ERR_FSTRUCT)

            ENDSELECT

ENDPROC






PROC loadsample(slot,pname,name,stype,senc)-> assumes that the slot is EMPTY
DEF fh,res,len                 -> sprop = stype+senc
                                  -> SENC_UNKNOWN AND STYPE_UNRECOGNIZED not allowed here!


      len:=FileLength(pname)
      fh:=Open(pname,OLDFILE)
      IF fh=0 THEN RETURN SIO_CANTOPEN
      sleep()
      res:=SIO_READERROR
      SELECT stype
            CASE STYPE_8SVX
                  res:=load8svx(slot,name,len,fh)
            CASE STYPE_AIFF
                  res:=loadaiff(slot,name,len,fh)
            CASE STYPE_MAUD
                  res:=loadmaud(slot,name,len,fh)
            CASE STYPE_MPEG
                  res:=loadmpeg(slot,name,len,fh)
            CASE STYPE_WAVE
                  res:=loadwave(slot,name,len,fh)
            CASE STYPE_16SV
                  res:=load16sv(slot,name,len,fh)
            CASE STYPE_RAW16
                  res:=loadraw(slot,name,len,fh,SENC_PCM16,8)
            CASE STYPE_RAW16b
                  res:=loadraw(slot,name,len,fh,SENC_PCM16,4)
            CASE STYPE_RAW
                  res:=loadraw(slot,name,len,fh,senc,0)
      ENDSELECT
      IF res=SIO_OK
            ->CDEBUG(SLOAD: sio rate \d,siodata.rate)
            sml.newentry2(siodata.slot,siodata.name,siodata.buf,siodata.frames,siodata.type,siodata.stereo,siodata.rate)
      ENDIF
      awake()
      Close(fh)
ENDPROC res

-> save sample

PROC savesamplegui(pname)
DEF ppathname[256]:STRING,psamplename[32]:STRING
DEF cslot,stype,s,flg,res

      cslot:=sml.getactive()
      IF CSP=NIL THEN RETURN
      IF rxm
            StrCopy(ppathname,pname,ALL)
      ELSE
            IF requestsample(ppathname,psamplename)<>0 THEN RETURN
      ENDIF

      get(_smed.cysavefmt,MUIA_Cycle_Active,{s})
      SELECT s
            CASE 0;stype:=STYPE_AIFF
            CASE 1;stype:=STYPE_WAVE
            CASE 2;stype:=STYPE_MAUD
            CASE 3;stype:=STYPE_8SVX
            CASE 4;stype:=STYPE_RAW
      ENDSELECT

      res:=savesample(cslot,ppathname,stype)
            SELECT res
                  CASE SIO_OK
                        logit('Sample saved OK')
                  CASE SIO_CANTOPEN
                        err(ERR_CANTOPEN)
                  CASE SIO_NOMEM
                        errnomem()
                  CASE SIO_WRITEERROR
                        err(ERR_WRITE)
                  CASE SIO_FILEPROBLEM
                        err(ERR_FSTRUCT)

            ENDSELECT

ENDPROC



PROC savesample(slot,pname,stype)
      DEF fh,res,c:PTR TO obj_sample

      fh:=Open(pname,NEWFILE)
      IF fh=0 THEN RETURN SIO_CANTOPEN
      sleep()
      res:=SIO_WRITEERROR
      c:=sml.getp(slot)
      siodata.slot:=slot;siodata.buf:=c.data.buffer
      siodata.frames:=c.data.frames;siodata.type:=c.data.type
      siodata.stereo:=c.data.stereo;siodata.rate:=c.rate
      siodata.length:=c.frames2len(siodata.frames)
      SELECT stype
            CASE STYPE_8SVX
                  res:=save8svx(slot,fh)
            CASE STYPE_AIFF
                  res:=saveaiff(slot,fh)
            CASE STYPE_MAUD
                  res:=savemaud(slot,fh)
            CASE STYPE_WAVE
                  res:=savewave(slot,fh)
            CASE STYPE_RAW
                  res:=saveraw(slot,fh)
      ENDSELECT
      awake()
      Close(fh)
ENDPROC res


-> sample edit stuff


PROC scopyrange()
      DEF srcpos,rnglen,result

      result:=TRUE
      IF scopybuf
            FreeVec(scopybuf)
            END scopybufdesc
      ENDIF

      IF CSP=NIL THEN RETURN
      IF CSP.rnglen=0 THEN RETURN

      srcpos:=CSP.frames2len(CSP.rngstart)
      rnglen:=CSP.frames2len(CSP.rnglen)

      scopybuf:=AllocVec(rnglen,memflag)
      NEW scopybufdesc -> risc

      IF scopybuf
            sleep();status('Copying range')
            copymemcache(CSP.data.buffer+srcpos,scopybuf,rnglen)
            sidle();awake()
            logit('Range copied.')
            scopybufdesc.len:=rnglen
            scopybufdesc.frames:=CSP.rnglen
            scopybufdesc.type:=CSP.data.type
            scopybufdesc.stereo:=CSP.data.stereo
            scopybufdesc.rate:=CSP.rate
      ELSE
                  errnomem()
      ENDIF

ENDPROC result


PROC spasterange()
      DEF destpos,oldlen,rnglen,temp,temp2

      IF scopybuf=NIL
            err(ERR_SCBE)
            RETURN
      ENDIF
      IF CSP
            IF (CSP.data.type<>scopybufdesc.type) OR (CSP.data.stereo<>scopybufdesc.stereo)
                  err(ERR_STDMEO)
                  RETURN
            ENDIF

            destpos:=CSP.frames2len(CSP.rngstart)
            oldlen:=CSP.frames2len(CSP.data.frames)
            rnglen:=scopybufdesc.len
            temp:=AllocVec(oldlen+rnglen,memflag)

            IF temp=NIL
                  errnomem()
                  RETURN
            ENDIF
            status('Pasting')
            sleep()
            temp2:=temp
            copymemcache(CSP.data.buffer,temp2,destpos)
            temp2:=temp2+destpos
            copymemcache(scopybuf,temp2,rnglen)
            temp2:=temp2+rnglen
            copymemcache(CSP.data.buffer+destpos,temp2,oldlen-destpos)
            awake()
            sidle()
            FreeVec(CSP.data.buffer)
            CSP.data.frames:=CSP.data.frames+scopybufdesc.frames
            CSP.data.buffer:=temp
            IF CSP.activeflg THEN CSP.activate()
      ELSE
            temp:=AllocVec(scopybufdesc.len,memflag)

            IF temp=NIL
                  errnomem()
                  RETURN
            ENDIF
            status('Pasting')
            sleep()
            copymemcache(scopybuf,temp,scopybufdesc.len)
            awake()
            sidle()
            sml.newentry2(sml.getactive(),'Copied',temp,scopybufdesc.frames,
            scopybufdesc.type,scopybufdesc.stereo,scopybufdesc.rate)
      ENDIF
      CHANGED
      CSCHANGED
ENDPROC



PROC sclearrange()
      DEF pos,end

      IF CSP=NIL THEN RETURN
      IF CSP.rnglen=0 THEN RETURN

      pos:=CSP.frames2len(CSP.rngstart)+CSP.data.buffer
      end:=CSP.frames2len(CSP.rnglen)+pos
      status('Clearing range')
      sleep()
                        MOVE.L pos,A0
                        MOVE.L end,D0
      sclearrange_loop1:CLR.B (A0)+
                        CMPA.L D0,A0
                        BNE sclearrange_loop1
      awake()
      sidle()
      IF CSP.activeflg THEN CSP.activate()
      CSCHANGED
ENDPROC

PROC seraserange()
      DEF pos,end,elen,newlen,oldlen,temp

      IF CSP=NIL THEN RETURN
      IF CSP.rnglen=0 THEN RETURN
      pos:=CSP.frames2len(CSP.rngstart)
      elen:=CSP.frames2len(CSP.rnglen)
      oldlen:=CSP.frames2len(CSP.data.frames)
      end:=elen+pos

      newlen:=oldlen-elen
      IF (CSP.data.frames-CSP.rnglen)<64
            sml.delentry(sml.getactive())
            CHANGED
            RETURN
      ENDIF
      temp:=AllocVec(newlen,memflag)
      IF temp=NIL
            errnomem()
            RETURN
      ENDIF
      status('Erasing range')
      sleep()
      copymemcache(CSP.data.buffer,temp,pos)
      copymemcache(CSP.data.buffer+end,temp+pos,oldlen-end)
      FreeVec(CSP.data.buffer)
      CSP.data.buffer:=temp
      CSP.data.frames:=CSP.data.frames-CSP.rnglen
      CSP.rngstart:=0;CSP.rnglen:=0
      IF CSP.dispfrms>CSP.data.frames THEN CSP.dispfrms:=CSP.data.frames
      IF (CSP.offset+CSP.dispfrms)>CSP.data.frames THEN CSP.offset:=CSP.data.frames-CSP.dispfrms
      awake();sidle()
      CHANGED
      CSCHANGED
      IF CSP.activeflg THEN CSP.activate()
ENDPROC


PROC splacerange()
      DEF destpos,oldlen,rnglen,clen,temp

      IF scopybuf=NIL
            err(ERR_SCBE)
            RETURN
      ENDIF
      IF CSP
            IF (CSP.data.type<>scopybufdesc.type) OR (CSP.data.stereo<>scopybufdesc.stereo)
                  err(ERR_STDMEO)
                  RETURN
            ENDIF

            destpos:=CSP.frames2len(CSP.rngstart)
            oldlen:=CSP.frames2len(CSP.data.frames)
            rnglen:=scopybufdesc.len
            clen:=rnglen
            IF (oldlen-destpos)<clen THEN clen:=oldlen-destpos
            status('Placing')
            sleep()
            copymemcache(scopybuf,CSP.data.buffer+destpos,clen)
            awake()
            sidle()
            IF CSP.activeflg THEN CSP.activate()
      ELSE
            temp:=AllocVec(scopybufdesc.len,memflag)

            IF temp=NIL
                  errnomem()
                  RETURN
            ENDIF
            status('Pasting')
            sleep()
            copymemcache(scopybuf,temp,scopybufdesc.len)
            awake()
            sidle()
            sml.newentry2(sml.getactive(),'Copied',temp,scopybufdesc.frames,
            scopybufdesc.type,scopybufdesc.stereo,scopybufdesc.rate)
      ENDIF
      CHANGED
      CSCHANGED
ENDPROC

PROC sreverserange()
      DEF pos,end,type

      IF CSP=NIL THEN RETURN
      IF CSP.rnglen=0 THEN RETURN

      pos:=CSP.frames2len(CSP.rngstart)+CSP.data.buffer
      end:=CSP.frames2len(CSP.rnglen)+pos
      IF CSP.data.type
            IF CSP.data.stereo THEN type:=4 ELSE type:=2
      ELSE
            IF CSP.data.stereo THEN type:=2 ELSE type:=1
      ENDIF

      status('Reversing range')
      sleep()
      SELECT type
            CASE 1
                        MOVE.L pos,A0
                        MOVE.L end,A1
      srevrange_loop1:  MOVE.B (A0),D0
                        MOVE.B -(A1),(A0)+
                        MOVE.B D0,(A1)
                        CMPA.L A0,A1
                        BCC srevrange_loop1
            CASE 2

                        MOVE.L pos,A0
                        MOVE.L end,A1
      srevrange_loop2:  MOVE.W (A0),D0
                        MOVE.W -(A1),(A0)+
                        MOVE.W D0,(A1)
                        CMPA.L A0,A1
                        BCC srevrange_loop2
            CASE 4
                        MOVE.L pos,A0
                        MOVE.L end,A1
      srevrange_loop4:  MOVE.L (A0),D0
                        MOVE.L -(A1),(A0)+
                        MOVE.L D0,(A1)
                        CMPA.L A0,A1
                        BCC srevrange_loop4
      ENDSELECT
      awake()
      sidle()
      IF CSP.activeflg THEN CSP.activate()
      CSCHANGED
ENDPROC



PROC sswapbyteorder()
      DEF b
      IF CSP=0 THEN RETURN

      IF CSP.data.type=FALSE
            err(ERR_16ONLY)
            RETURN
      ENDIF
      status('Swapping byte order')
      sleep()
      b:=CSP.data.buffer
      swapbyteorder(b,b+CSP.frames2len(CSP.data.frames),CSP.data.stereo)
      awake()
      sidle()
      IF CSP.activeflg THEN CSP.activate()
ENDPROC


PROC scentralize()
      DEF d1,d2,s1,s2,b,e,f,f2

      IF CSP=0 THEN RETURN
      status('Calculating deviation')
      sleep()
      b:=CSP.data.buffer;s1:=0;s2:=0;f:=CSP.data.frames
      IF CSP.data.type
            IF f>65535 THEN f2:=65535 ELSE f2:=f
            e:=b+CSP.frames2len(f2)
                  IF CSP.data.stereo
                        MOVE.L b,A0
                        MOVE.L e,A1
                        MOVEQ.L #0,D0
                        MOVEQ.L #0,D1
                        MOVEQ.L #0,D2
            centraliz1: MOVE.W (A0)+,D2
                        EXT.L D2
                        ADD.L D2,D0
                        MOVE.W (A0)+,D2
                        EXT.L D2
                        ADD.L D2,D1
                        CMPA.L A1,A0
                        BNE centraliz1
                        MOVE.L D0,s1
                        MOVE.L D1,s2
                        CDEBUG(CNTRLZ: Left channel sum: \d,s1)
                        CDEBUG(CNTRLZ: Right channel sum: \d,s2)
                        d1:=Div(s1,f2);d2:=Div(s2,f2)
                        CDEBUG(CNTRLZ: Left channel deviation: \d,d1)
                        CDEBUG(CNTRLZ: Right channel deviation: \d,d2)
                  ELSE
                        MOVE.L b,A0
                        MOVE.L e,A1
                        MOVEQ.L #0,D0
                        MOVEQ.L #0,D2
            centraliz2: MOVE.W (A0)+,D2
                        EXT.L D2
                        ADD.L D2,D0
                        CMPA.L A1,A0
                        BNE centraliz2
                        MOVE.L D0,s1
                        CDEBUG(CNTRLZ: Sum: \d,s1)
                        d1:=Div(s1,f2)
                        CDEBUG(CNTRLZ: Deviation: \d,d1)

                  ENDIF
      ELSE
            IF f>16777215 THEN f2:=16777215 ELSE f2:=f
            e:=b+CSP.frames2len(f2)
                  IF CSP.data.stereo
                        MOVE.L b,A0
                        MOVE.L e,A1
                        MOVEQ.L #0,D0
                        MOVEQ.L #0,D1
                        MOVEQ.L #0,D2
            centraliz3: MOVE.B (A0)+,D2
                        EXT.W D2
                        EXT.L D2
                        ADD.L D2,D0
                        MOVE.B (A0)+,D2
                        EXT.W D2
                        EXT.L D2
                        ADD.L D2,D1
                        CMPA.L A1,A0
                        BNE centraliz3
                        MOVE.L D0,s1
                        MOVE.L D1,s2
                        CDEBUG(CNTRLZ: Left channel sum: \d,s1)
                        CDEBUG(CNTRLZ: Right channel sum: \d,s2)
                        d1:=Div(s1,f2);d2:=Div(s2,f2)
                        CDEBUG(CNTRLZ: Left channel deviation: \d,d1)
                        CDEBUG(CNTRLZ: Right channel deviation: \d,d2)
                  ELSE
                        MOVE.L b,A0
                        MOVE.L e,A1
                        MOVEQ.L #0,D0
                        MOVEQ.L #0,D2
            centraliz4: MOVE.B (A0)+,D2
                        EXT.W D2
                        EXT.L D2
                        ADD.L D2,D0
                        CMPA.L A1,A0
                        BNE centraliz4
                        MOVE.L D0,s1
                        CDEBUG(CNTRLZ: Sum: \d,s1)
                        d1:=Div(s1,f2)
                        CDEBUG(CNTRLZ: Deviation: \d,d1)
                  ENDIF

      ENDIF

      status('Adjusting DC offset')
      e:=b+CSP.frames2len(f)

      IF CSP.data.type
            IF CSP.data.stereo
                        MOVE.L b,A0
                        MOVE.L e,A1
                  cnl1: MOVE.W (A0),D0
                        EXT.L D0
                        SUB.L d1,D0
                        CMP.L #$00007fff,D0
                        BLE cna1
                        MOVE.L #$00007fff,D0
                  cna1: CMP.L #$ffff8000,D0
                        BGE cnb1
                        MOVE.L #$ffff8000,D0
                  cnb1: MOVE.W D0,(A0)+
                        MOVE.W (A0),D0
                        EXT.L D0
                        SUB.L d2,D0
                        CMP.L #$00007fff,D0
                        BLE cnc1
                        MOVE.L #$00007fff,D0
                  cnc1: CMP.L #$ffff8000,D0
                        BGE cnd1
                        MOVE.L #$ffff8000,D0
                  cnd1: MOVE.W D0,(A0)+
                        CMPA.L A1,A0
                        BNE cnl1
            ELSE
                        MOVE.L b,A0
                        MOVE.L e,A1
                  cnl2: MOVE.W (A0),D0
                        EXT.L D0
                        SUB.L d1,D0
                        CMP.L #$00007fff,D0
                        BLE cna2
                        MOVE.L #$00007fff,D0
                  cna2: CMP.L #$ffff8000,D0
                        BGE cnb2
                        MOVE.L #$ffff8000,D0
                  cnb2: MOVE.W D0,(A0)+
                        CMPA.L A1,A0
                        BNE cnl2
           ENDIF
      ELSE
            IF CSP.data.stereo
                        MOVE.L b,A0
                        MOVE.L e,A1
                  cnl3: MOVE.B (A0),D0
                        EXT.W D0
                        EXT.L D0
                        SUB.L d1,D0
                        CMP.L #$0000007f,D0
                        BLE cna3
                        MOVE.L #$0000007f,D0
                  cna3: CMP.L #$ffffff80,D0
                        BGE cnb3
                        MOVE.L #$ffffff80,D0
                  cnb3: MOVE.B D0,(A0)+
                        MOVE.B (A0),D0
                        EXT.W D0
                        EXT.L D0
                        SUB.L d2,D0
                        CMP.L #$0000007f,D0
                        BLE cnc3
                        MOVE.L #$0000007f,D0
                  cnc3: CMP.L #$ffffff80,D0
                        BGE cnd3
                        MOVE.L #$ffffff80,D0
                  cnd3: MOVE.B D0,(A0)+
                        CMPA.L A1,A0
                        BNE cnl3
            ELSE
                        MOVE.L b,A0
                        MOVE.L e,A1
                  cnl4: MOVE.B (A0),D0
                        EXT.W D0
                        EXT.L D0
                        SUB.L d1,D0
                        CMP.L #$0000007f,D0
                        BLE cna4
                        MOVE.L #$0000007f,D0
                  cna4: CMP.L #$ffffff80,D0
                        BGE cnb4
                        MOVE.L #$ffffff80,D0
                  cnb4: MOVE.B D0,(A0)+
                        CMPA.L A1,A0
                        BNE cnl4
                  ENDIF

     ENDIF


      awake()
      sidle()
      IF CSP.activeflg THEN CSP.activate()
ENDPROC


PROC schangevol(volume)

      IF CSP=NIL THEN RETURN

            IF volume=-1 THEN get(_cvol.slvolume,MUIA_Numeric_Value,{volume})

            status('Changing sample volume');sleep()
            IF CSP.rnglen>0
                  sschangevol(CSP.data.buffer+CSP.frames2len(CSP.rngstart),
                  CSP.frames2len(CSP.rnglen),volume,CSP.data.type)
            ELSE
                  sschangevol(CSP.data.buffer,CSP.frames2len(CSP.data.frames),
                        volume,CSP.data.type)
            ENDIF
            awake();sidle()

      IF CSP.activeflg THEN CSP.activate()
ENDPROC


PROC schangevolmax()
      DEF maxval,buf,len,type,coef

      maxval:=0
      IF CSP=NIL THEN RETURN


      type:=CSP.data.type
      IF CSP.rnglen>0
            buf:=CSP.data.buffer+CSP.frames2len(CSP.rngstart)
            len:=CSP.frames2len(CSP.rnglen)
      ELSE
            buf:=CSP.data.buffer
            len:=CSP.frames2len(CSP.data.frames)
      ENDIF

      IF len=0 THEN RETURN
            status('Analyzing sample');sleep()
      IF type
                  MOVE.L buf,A0
                  MOVEQ.L #0,D1
                  MOVEQ.L #0,D2

           an1l:  MOVE.W (A0)+,D0
                  BPL ana1
                  NEG.W D0
           ana1:  CMP.W D1,D0
                  BLE ana2
                  MOVE.W D0,D1
           ana2:  ADDQ.L #2,D2
                  CMP.L len,D2
                  BNE an1l
                  MOVE.L D1,maxval

                  coef:=Div(8388352,maxval)
      ELSE
                  MOVE.L buf,A0
                  MOVEQ.L #0,D1
                  MOVEQ.L #0,D2

           an2l:  MOVE.B (A0)+,D0
                  BPL ana3
                  NEG.B D0
           ana3:  CMP.B D1,D0
                  BLE ana4
                  MOVE.B D0,D1
           ana4:  ADDQ.L #1,D2
                  CMP.L len,D2
                  BNE an2l
                  MOVE.L D1,maxval

                  coef:=32512/maxval
      ENDIF
      CDEBUG(CVOL: Maximum \d,maxval)
      CDEBUG(CVOL: Coeficient \d,coef)
      sidle();awake();schangevol(coef)

ENDPROC


PROC splay()
      DEF sampletype,res

      IF CSP=NIL THEN RETURN
      IF CSP.data.type
            IF CSP.data.stereo THEN sampletype:=AHIST_S16S ELSE sampletype:=AHIST_M16S
      ELSE
            IF CSP.data.stereo THEN sampletype:=AHIST_S8S ELSE sampletype:=AHIST_M8S
      ENDIF

      res:=start_playing(CSP.data.buffer+CSP.frames2len(CSP.offset),
            CSP.frames2len(CSP.dispfrms),CSP.rate,sampletype,CSP.data.buffer)
      
      IF res=0 THEN icc([CG_SED,IC_LOCK])

      IF res>0
            IF res=3 THEN erraud() ELSE err(ERR_PLAYER)
      ENDIF
ENDPROC

PROC splayrange()
      DEF sampletype,res

      IF CSP=NIL THEN RETURN
      IF CSP.rnglen=0 THEN RETURN
      IF CSP.data.type
            IF CSP.data.stereo THEN sampletype:=AHIST_S16S ELSE sampletype:=AHIST_M16S
      ELSE
            IF CSP.data.stereo THEN sampletype:=AHIST_S8S ELSE sampletype:=AHIST_M8S
      ENDIF

      res:=start_playing(CSP.data.buffer+CSP.frames2len(CSP.rngstart),
            CSP.frames2len(CSP.rnglen),CSP.rate,sampletype,CSP.data.buffer)

      IF res=0 THEN icc([CG_SED,IC_LOCK])

      IF res>0
            IF res=3 THEN erraud() ELSE err(ERR_PLAYER)
      ENDIF
ENDPROC


-> !!!!!!!!!!!!!!!!!!!

-> -------------------------------------------------------------

PROC lockcheck()
      DEF ll

      ll:=sml.islocked(sml.getactive()) -> checks if an active sample is locked
      IF ll
            logit('ERROR: Sample/slot locked')
            rxr:=ERR_LCK
      ENDIF

ENDPROC ll



PROC updatetitle()
      IF CSP

            IF CSP.changed
                  IF sml.islocked(sml.getactive())
                        set(_smed.base,MUIA_Window_Title,'Sample Editor (CHANGED,LOCKED)')
                  ELSE
                        set(_smed.base,MUIA_Window_Title,'Sample Editor (CHANGED)')
                  ENDIF

            ELSE
                  IF sml.islocked(sml.getactive())
                        set(_smed.base,MUIA_Window_Title,'Sample Editor (LOCKED)')
                  ELSE
                        set(_smed.base,MUIA_Window_Title,'Sample Editor')
                  ENDIF

            ENDIF
      ELSE
            IF sml.islocked(sml.getactive())
                  set(_smed.base,MUIA_Window_Title,'Sample Editor (LOCKED)')
            ELSE
                  set(_smed.base,MUIA_Window_Title,'Sample Editor')
            ENDIF
      ENDIF

ENDPROC


PROC changechanged(x)
      IF CSP=0 THEN RETURN
      CSP.changed:=x
      updatetitle()
ENDPROC





EXPORT PROC icised(obj,ic,param:PTR TO LONG)
DEF temp,temp2,temp3
DEF h:PTR TO obj_sample

      SELECT ic
            CASE IC_SETPARAM
                  IF CSP
                        IF (^param=SMTYPE) OR (^param=SMSTEREO)
                              IF lockcheck()
                                    IF upd
                                                nset(_smed.ch16bit,MUIA_Selected,CSP.data.type)
                                                nset(_smed.chstereo,MUIA_Selected,CSP.data.stereo)
                                          ENDIF
                                    RETURN
                              ENDIF

                              IF rxm=FALSE
                                    IF confirm('Are you sure ?')=FALSE
                                          IF upd
                                                nset(_smed.ch16bit,MUIA_Selected,CSP.data.type)
                                                nset(_smed.chstereo,MUIA_Selected,CSP.data.stereo)
                                          ENDIF
                                    RETURN
                                    ENDIF

                              ENDIF
                        ENDIF
                        CSP.setparam(param)
                  ENDIF
            CASE IC_PLAYCURSOR
                  IF lastlocked<0 THEN RETURN
                        h:=sml.getp(lastlocked)
                        IF h
                              IF h.data.type
                                    IF h.data.stereo
                                          temp:=Shr(^param,2)
                                    ELSE
                                          temp:=Shr(^param,1)
                                    ENDIF
                              ELSE
                                    IF h.data.stereo
                                          temp:=Shr(^param,1)
                                    ELSE
                                          temp:=^param
                                    ENDIF
                              ENDIF
                              IF ^param=-1 THEN temp:=-1
                              IF lastlocked=sml.getactive() THEN UPDON ELSE UPDOFF
                              h.setparam([SMCURSOR,temp])
                              UPDON
                        ENDIF

            CASE IC_GOPREV
                  sml.preventry()
            CASE IC_GONEXT
                  sml.nextentry()
            CASE IC_GOFIRST
                  sml.setactive(sml.nextused(0))
            CASE IC_GOLAST
                  sml.setactive(sml.prevused(sml.max-1))
            CASE IC_RENAME
                  IF CSP THEN sml.renam(sml.getactive(),^param)
            CASE IC_SHOWALL
                  IF CSP THEN CSP.setzoom(CSP.data.frames)
            CASE IC_SHOWRNG
                  IF CSP
                        IF CSP.rnglen>0
                              CSP.setzoom(CSP.rnglen)
                              CSP.setparam([SMOFFSET,CSP.rngstart])
                        ENDIF
                  ENDIF
            CASE IC_RNGALL
                  IF CSP
                        CSP.setparam([SMRANGE,0,CSP.data.frames])
                  ENDIF
            CASE IC_PLAY
                  splay()
            CASE IC_PLAYRNG
                  splayrange()
            CASE IC_LOCK
                  sml.lock(sml.getactive())
                  lastlocked:=sml.getactive()
                  updatetitle()
                  CDEBUG(SAMPLEED: Slot #\d locked,lastlocked)
            CASE IC_UNLOCK  -> for playing only
                  IF lastlocked>=0
                        sml.unlock(lastlocked)
                        CDEBUG(SAMPLEED: Slot #\d unlocked,lastlocked)
                        IF sml.getactive()=lastlocked THEN updatetitle()
                  ENDIF
                  lastlocked:=-2
                  
            CASE IC_COPYRNG
                  scopyrange()
            CASE IC_PASTERNG
                  IF lockcheck() THEN RETURN
                  spasterange()
            CASE IC_PLACERNG
                  splacerange()
            CASE IC_CLEARRNG
                  sclearrange()
            CASE IC_ERASERNG
                  IF lockcheck() THEN RETURN
                  seraserange()
            CASE IC_CUTRNG
                  IF lockcheck() THEN RETURN
                  IF scopyrange() THEN seraserange()
            CASE IC_REVRNG
                  sreverserange()
            CASE IC_SETACTIVEUSED
                  sml.setactive(sml.slot(^param))

            CASE IC_MPEGGETFILE
                  mpeggetfile(^param)
            CASE IC_MPEGPARAM
                  mpegparam(param[0],param[1])
            CASE IC_MPEGSTART
                  IF lockcheck() THEN RETURN
                  IF CSP THEN sml.delentry(sml.getactive())
                  mpegdecode(sml.getactive())
            CASE IC_GUIINPUT
                  IF CSP
                        temp:=^param
                        SELECT temp
                              CASE SMRNGSTART
                              get(_smed.strngstart,MUIA_String_Integer,{temp2})
                              CSP.setparam([temp,temp2])
                              CASE SMRNGLEN
                              get(_smed.strnglen,MUIA_String_Integer,{temp2})
                              CSP.setparam([temp,temp2])
                              CASE SMRATE
                              get(_smed.stpitch,MUIA_String_Integer,{temp2})
                              CSP.setparam([temp,temp2])
                              CASE SMFRAMES
                              IF lockcheck() THEN RETURN
                              get(_smed.stbuffer,MUIA_String_Integer,{temp2})
                              CSP.setparam([temp,temp2])
                        ENDSELECT
                  ENDIF
            CASE IC_LOADSAMPLE
                  IF lockcheck() THEN RETURN
                  loadsamplegui(^param,param[1])
                  CSCHANGED
                  CHANGED
            CASE IC_SAVESAMPLE
                  savesamplegui(^param)
                  csamplep.changed:=FALSE;updatetitle()
            CASE IC_DELSAMPLE
                  IF lockcheck() THEN RETURN
                  IF CSP
                        sml.delentry(sml.getactive())
                        CHANGED
            ENDIF
            CASE IC_SWPBYTEORDER
                  sswapbyteorder()
            CASE IC_CENTRALIZE
                  scentralize()
            CASE IC_ZIN
                  temp:=Shr(CSP.dispfrms,1)
                  IF CSP
                        IF temp>=1 THEN CSP.setzoom(temp)
                  ENDIF
            CASE IC_ZOUT
                  IF CSP
                        temp:=Shl(CSP.dispfrms,1)
                        IF temp>CSP.data.frames THEN temp:=CSP.data.frames
                        CSP.setzoom(temp)
                  ENDIF
            CASE IC_CVOL;schangevol(-1)
            CASE IC_CVOLDOUBLE;schangevol(512)
            CASE IC_CVOLHALVE;schangevol(128)
            CASE IC_CVOLMAX;schangevolmax()
            CASE ICP_FLUSH;mpegflushstuff()
            CASE ICP_ADDSAMPLE
                 sml.newentry2(param[6],param[0],param[1],param[2],param[3],param[4],param[5])
      ENDSELECT
ENDPROC

