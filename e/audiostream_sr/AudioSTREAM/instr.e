 /*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0

      =================================================

      Source:     instr.e
      Description:    instrument related stuff
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT MODULE
OPT PREPROCESS


MODULE '*declarations','muimaster','libraries/mui','tools/boopsi','devices/inputevent','*global'
MODULE '*gui_declarations','*common','utility/hooks','tools/installhook','*adst:dsp/dummy'


#define CIP curinsp

OBJECT obj_instrdata
     linked:INT ->linked slot
     type:INT   ->0=sample

     transposable:INT
     mtype:INT  ->0=melodic 1=fixed rate
     rate
     transpose:INT
     finetune:INT
     phasediff:INT -> -50ms..50ms
     invertl:INT
     invertr:INT
     loopon:INT
     pingpong:INT
     reverse:INT
     offset
     loopstart
     looplen
     interpolation:INT
     killonzero:INT
     ktimeout:INT -> 0..100 in 1/10 sec

     -> params: 0=volume 1=panning 2=pitchL 3=pitchR
     paramg[4]:ARRAY OF obj_gendata
     parame[4]:ARRAY OF obj_envldata
     paraml[4]:ARRAY OF obj_lfodata
ENDOBJECT




OBJECT obj_instrument OF obj_base
      data:obj_instrdata

      interactive:INT
ENDOBJECT


EXPORT OBJECT obj_inslist OF obj_sss
ENDOBJECT

EXPORT DEF upd
EXPORT DEF changed
EXPORT DEF inl:PTR TO obj_inslist

      DEF curinsp:PTR TO obj_instrument

            EXPORT DEF _inst:PTR TO objw_instrument
            EXPORT DEF _pcki:PTR TO objw_pickinstrument
            EXPORT DEF _appl:PTR TO obj_application



->  inslist stuff

PROC renam(slot,name) OF obj_inslist
      SUPER self.renam(slot,name)
      domethod(_pcki.lv,[MUIM_List_Redraw,MUIV_List_Redraw_All])
      CHANGED
ENDPROC

PROC newone() OF obj_inslist
      DEF temp:PTR TO obj_instrument

      NEW temp.create()
ENDPROC temp

PROC freeone(entry:PTR TO obj_instrument) OF obj_inslist
      END entry
ENDPROC

PROC newentry(slot) OF obj_inslist
      -> assumes that the slot is EMPTY

      SUPER self.newentry(slot)
      refreshpickinstr()
      self.setactive(slot)

ENDPROC

PROC delentry(slot) OF obj_inslist

      SUPER self.delentry(slot)
      refreshpickinstr()
      self.setactive(slot)
ENDPROC

PROC delall() OF obj_inslist
DEF slot

    slot:=self.getactive()
      SUPER self.delall()
      refreshpickinstr()
      self.setactive(slot)
ENDPROC


PROC setactive(slot) OF obj_inslist
DEF i,pos,a

      IF slot=-1 THEN RETURN
      SUPER self.setactive(slot)
      CIP:=self.getp(slot)

      domethod(_inst.txslot,[MUIM_SetAsString,MUIA_Text_Contents,
      '%02.2lx',slot])

      IF CIP
            a:=self.findpos(slot)
            nset(_pcki.lv,MUIA_List_Active,a)
      ELSE
            nset(_pcki.lv,MUIA_List_Active,MUIV_List_Active_Off)
            self.resetgui()
      ENDIF
ENDPROC

PROC resetgui() OF obj_inslist

      nset(_inst.stname,MUIA_String_Contents,'Unused slot')
      nset(_inst.txlinked,MUIA_Text_Contents,'No used item')
      nset(_inst.cytype,MUIA_Cycle_Active,0)
      domethod(_inst.lvparams,[MUIM_List_Clear])
ENDPROC

-> ----------------------------------------------

PROC refreshpickinstr()
DEF tctp:PTR TO obj_instrument
DEF i,j,k,e
      get(_pcki.lv,MUIA_List_Active,{e})
      nset(_pcki.lv,MUIA_List_Quiet,MUI_TRUE)
      domethod(_pcki.lv,[MUIM_List_Clear])

      FOR i:=0 TO inl.max-1
            tctp:=inl.getp(i)
            IF tctp
                        j:=fslot(i)
                        k:=tctp.xb
                        MOVE.L k,A0
                        MOVE.L j,D0
                        MOVE.W D0,(A0)
                        MOVE.W #": ",2(A0)
                        domethod(_pcki.lv,[MUIM_List_InsertSingle,
                                    tctp.xb,MUIV_List_Insert_Bottom])
                        ENDIF
      ENDFOR
      nset(_pcki.lv,MUIA_List_Quiet,FALSE)
      nset(_pcki.lv,MUIA_List_Active,e)
ENDPROC
