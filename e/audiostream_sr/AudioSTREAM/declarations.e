/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     declarations.e
      Description:    declarations of music data structures
      Version:    1.1
 --------------------------------------------------------------------
*/


OPT MODULE
OPT EXPORT

MODULE '*global'

            PROC clrmem(addr,bytes)

                  MOVE.L addr,A0
                  MOVE.L bytes,D0   
            _clrloop:TST.L D0
                  BEQ _clrend
                  CLR.B (A0)+
                  SUBQ.L #1,D0
                  BRA _clrloop
            _clrend:
            ENDPROC


/*---------------- OO-music data storage system ---------------
                  standardised storage interface

ALL storage system IS done in this way:

Most of music object have 2 parts:
      OBJECT obj_something
            which is the interface and has some
            universal and private attributes
      OBJECT obj_somethingdata
            actual data structure, directly accessible
            with PLAYIN/RENDERING TASK ONLY !

obj_something has usualy a lot of methods, which are defined mainly
in related source (not here)

local storage systems like SLOTs AND LISTs are LOCKED during playing!
this means that you can't change the song OR MODULE structure during
playing/rendering!
at the play/render request are created special "shadow" list AND slot
structures used only FOR rendering.


very important are GLOBAL variables "upd" AND "lck"
upd: when TRUE, any change causes activate OBJECT TO update its gui
locked: when TRUE, user can't change music structures (i.e. delete track)
use UPDON macro TO permit gui updating and UPDOFF one TO forbit

There are also collection OF objects - we have SLOT  and GENERAL
storage system, and in addition SEQUENCE system FOR sequencing
objects.

there are some shortcuts used in comments:

      A = abstract only, must be completely overriden
      O = partial overriding needed
      MOB = must be overriden anyway

  ----------------------------------------------------------  */


/* base data storage object */      

      OBJECT obj_base
      -> public data for updating, misc stuff
            xx:PTR TO CHAR
            xa[4]:ARRAY
            xb[4]:ARRAY 
            name[32]:ARRAY
            activeflg
      ENDOBJECT

      PROC setname(x:PTR TO CHAR) OF obj_base IS AstrCopy(self.name,x,33)
      PROC getname() OF obj_base IS self.name
      PROC setparam(pl:PTR TO LONG) IS EMPTY -> abstract
      PROC getparam(p) IS EMPTY -> abstract
      PROC create() OF obj_base IS self.setname(' NameLess ') -> constructor
      PROC end() OF obj_base IS EMPTY -> abstract
      PROC activate() OF obj_base 
            self.activeflg:=TRUE
      ENDPROC TRUE      
      PROC deactivate() OF obj_base 
            self.activeflg:=FALSE
      ENDPROC


      OBJECT obj_baseid
            -> public data for updating, misc stuff
            xa[4]:ARRAY
            xb[4]:ARRAY
            xx:PTR TO CHAR
            linkedid:INT
            unused0:INT
      ENDOBJECT

      PROC activate() OF obj_baseid IS EMPTY -> abstract
      PROC deactivate() OF obj_baseid IS EMPTY -> absttract
      PROC lid() OF obj_baseid IS self.linkedid

/* slot storage system, for tracks, instruments, samples and waves */

      OBJECT obj_sss
            max   -> max entries, read only
            entries
            PRIVATE
            s:PTR TO LONG -> slot pointers
            t:PTR TO INT -> pos 2 slot compressed table
            l:PTR TO CHAR -> lockmap
            activeentry -> index OF active entry,-1 = no active entries
      ENDOBJECT

      PROC recalcposlist() OF obj_sss
            DEF i,e

            e:=0
            FOR i:=0 TO self.max-1
                  IF self.getp(i)
                        self.t[e]:=i
                        INC e
                  ENDIF
            ENDFOR
            self.entries:=e
      ENDPROC

      PROC slot(pos) OF obj_sss
            IF pos=-1 THEN RETURN -1
      ENDPROC self.t[pos]

      PROC findpos(slot) OF obj_sss
            DEF i,a

            IF self.entries=0 THEN RETURN -1
            FOR i:=0 TO self.entries-1 DO EXIT self.slot(i)=slot
            a:=-1
            IF self.slot(i)=slot THEN a:=i
      ENDPROC a

      PROC renam(slot,name) OF obj_sss
                DEF temp:PTR TO obj_base

                IF slot<>-1
                      temp:=self.getp(slot)
                      IF temp THEN temp.setname(name)
                ENDIF
          ENDPROC

      PROC getp(slot) OF obj_sss IS self.s[slot]
      PROC geta() OF obj_sss
            DEF tmp
            tmp:=self.getp(self.activeentry)
      ENDPROC tmp

      PROC setslot(slot,x) OF obj_sss
            self.s[slot]:=x
            self.recalcposlist()
      ENDPROC


      PROC newentry(slot) OF obj_sss
            self.setslot(slot,self.newone())
      ENDPROC

      PROC newone() OF obj_sss IS EMPTY -> abstract, called by newentry

      PROC freeone(entry) OF obj_sss IS EMPTY -> abstract,called by delentry() AND delall()

      PROC delentry(slot) OF obj_sss -> overriding (delete the OBJECT there)
            DEF p                   -> activeentry is not VALID

            p:=self.getp(slot)
            IF p
                  self.s[slot]:=NIL
                  self.freeone(p)
            ENDIF
            self.recalcposlist()
      ENDPROC

      PROC delall() OF obj_sss
            DEF i,p

            FOR i:=0 TO self.max-1
                   IF (p:=self.getp(i))
                         self.freeone(p)
                         self.s[i]:=NIL
                   ENDIF
            ENDFOR
            self.recalcposlist()
      ENDPROC

      PROC getactive() OF obj_sss IS self.activeentry
      PROC setactive(slot) OF obj_sss
            DEF tmp:PTR TO obj_base

            tmp:=self.geta()
            IF tmp THEN tmp.deactivate()
            self.activeentry:=slot
            tmp:=self.getp(slot)
            IF tmp THEN tmp.activate()
      ENDPROC self.activeentry

      PROC nextentry() OF obj_sss
            DEF pp

            pp:=self.getactive()
            IF pp<>-1
                  INC pp
                  IF pp>=self.max THEN pp:=0
                  self.setactive(pp)
            ENDIF
      ENDPROC

      PROC preventry() OF obj_sss
            DEF pp

            pp:=self.getactive()
            IF pp<>-1
                  IF pp>0
                        self.setactive(pp-1)
                  ELSE
                        self.setactive(self.max-1)
                  ENDIF
            ENDIF
      ENDPROC

      PROC nextused(slot) OF obj_sss
            DEF i,lpos

            lpos:=slot
            FOR i:=slot TO (self.max-1) DO EXIT self.getp(i)
            IF i<(self.max)
                  IF self.getp(i) THEN lpos:=i
            ENDIF
      ENDPROC lpos

      PROC prevused(slot) OF obj_sss
            DEF i,lpos

            lpos:=slot
            FOR i:=slot TO 0 STEP -1 DO EXIT self.getp(i)
            IF i>=0
                  IF self.getp(i) THEN lpos:=i
            ENDIF
      ENDPROC lpos

      PROC create(size,ps:PTR TO LONG) OF obj_sss
            DEF i,ts:PTR TO LONG,tt:PTR TO INT,ll:PTR TO CHAR

            self.max:=size
            NEW ts[self.max]
            self.s:=ts
            NEW tt[self.max]
            self.t:=tt
            NEW ll[self.max]
            self.l:=ll
            FOR i:=0 TO size-1
                  IF ps
                        self.s[i]:=ps[i]
                  ELSE
                        self.s[i]:=0
                  ENDIF
                  self.l[i]:=FALSE
            ENDFOR
            self.recalcposlist()
            self.setactive(0)
      ENDPROC

      PROC end() OF obj_sss
            self.delall()
            END self.s[self.max]
            END self.t[self.max]
            END self.l[self.max]
      ENDPROC

      PROC lock(slot) OF obj_sss
            self.l[slot]:=TRUE
      ENDPROC

      PROC unlock(slot) OF obj_sss
            self.l[slot]:=FALSE
      ENDPROC

      PROC islocked(slot) OF obj_sss IS self.l[slot]

/* general storage system,used FOR sections,dsp & whatever */


      OBJECT obj_gss
            max   -> how many members can HANDLE (usually 256), read only
            entries -> how many members are there, read only
            PRIVATE
            s:PTR TO LONG -> table, index=id 2 pointer
            l:PTR TO CHAR -> table, position 2 index=id

            activeentry  -> this IS an pos OF an active member, -1 = no active members
      ENDOBJECT

-> methods

      PROC renam(pos,name) OF obj_gss
                DEF temp:PTR TO obj_base

                IF pos<>-1
                      temp:=self.s[self.id(pos)]
                      IF temp THEN temp.setname(name)
                ENDIF
          ENDPROC

      PROC id(pos) OF obj_gss IS self.l[pos]
      PROC getp(pos) OF obj_gss IS self.s[self.id(pos)]
      PROC geta() OF obj_gss
            DEF tmp
            tmp:=NIL
            IF self.getactive()<>-1 THEN tmp:=self.getp(self.activeentry)
      ENDPROC tmp

      PROC add(what) OF obj_gss
            DEF i

            IF self.max=self.entries THEN RETURN FALSE -> no room
            FOR i:=0 TO self.max-1 DO EXIT self.s[i]=0 -> find free
            self.l[self.entries]:=i                    -> active entry is not valid!
            self.s[i]:=what
            self.entries:=self.entries+1
      ENDPROC what

      PROC newentry() OF obj_gss IS EMPTY -> abstract,use also add()!

      PROC freeone(entry) OF obj_gss IS EMPTY -> abstract,called by delentry() AND delall()

      PROC delentry(pos) OF obj_gss -> overriding (delete the OBJECT there)
            DEF i,p                   -> activeentry is not VALID

            p:=self.getp(pos)
            IF p
                  self.s[self.id(pos)]:=NIL
                  FOR i:=pos+1 TO self.entries-1 DO self.l[i-1]:=self.l[i]
                  self.entries:=self.entries-1
                  self.freeone(p)
            ENDIF
      ENDPROC

      PROC delall() OF obj_gss
            DEF i,p

            FOR i:=0 TO self.entries-1
                   IF (p:=self.getp(i)) THEN self.freeone(p)
            ENDFOR
            self.entries:=0
      ENDPROC

      PROC getactive() OF obj_gss IS self.activeentry
      PROC setactive(pos) OF obj_gss
            DEF tmp:PTR TO obj_base

            IF self.getactive()<>-1
                  tmp:=self.getp(self.getactive())
                  IF tmp THEN tmp.deactivate()
            ENDIF
            self.activeentry:=pos
            IF pos<>-1
                  tmp:=self.getp(pos)
                  tmp.activate()
            ENDIF
      ENDPROC self.activeentry

      PROC nextentry() OF obj_gss
            DEF pp

            pp:=self.getactive()
            IF pp<>-1
                  INC pp
                  IF pp<self.entries
                        self.setactive(pp)
                  ENDIF
            ENDIF
      ENDPROC

      PROC preventry() OF obj_gss
            DEF pp

            pp:=self.getactive()
            IF pp<>-1
                  IF pp>0
                        self.setactive(pp-1)
                  ENDIF
            ENDIF
      ENDPROC

      PROC create(size,ps:PTR TO LONG,pl:PTR TO CHAR) OF obj_gss
            DEF i,ts:PTR TO LONG,tl:PTR TO CHAR

            self.max:=size
            self.entries:=0
            NEW ts[self.max]
            self.s:=ts
            NEW tl[self.max]
            self.l:=tl
            IF ps
                  FOR i:=0 TO size-1
                        self.s[i]:=ps[i]
                        self.l[i]:=pl[i]
                  ENDFOR
            ENDIF
            self.activeentry:=-1
            self.setactive(-1)
      ENDPROC

      PROC end() OF obj_gss
            self.delall()
            END self.s[self.max]
            END self.l[self.max]
      ENDPROC


-> sequence system, FOR sequencing objects

      OBJECT obj_seq
            max   -> how many items can HANDLE, read only
            entries -> how many items are there, read only
            PRIVATE
            s:PTR TO LONG -> table, pointers TO the item
                          -> items are mostly obj_xxxxxid type
            activeentry  -> this IS an index OF an active member, -1 = no active members
      ENDOBJECT

-> methods
      PROC getpid(pos) OF obj_seq
            DEF tmp:PTR TO obj_baseid

            tmp:=self.getp(pos)
            IF tmp THEN tmp:=tmp.lid()
      ENDPROC tmp
      PROC getaid() OF obj_seq
            DEF tmp:PTR TO obj_baseid
            tmp:=NIL
            IF self.getactive()<>-1 THEN tmp:=self.getp(self.activeentry)
            IF tmp THEN tmp:=tmp.lid()
      ENDPROC tmp
      PROC getp(pos) OF obj_seq IS self.s[pos]
      PROC geta() OF obj_seq
            DEF tmp
            tmp:=NIL
            IF self.getactive()<>-1 THEN tmp:=self.getp(self.activeentry)
      ENDPROC tmp

      PROC add(what) OF obj_seq

            IF self.max=self.entries THEN RETURN FALSE -> no room
            self.s[self.entries]:=what
            self.entries:=self.entries+1
      ENDPROC what

      PROC newentry() OF obj_seq IS EMPTY -> abstract,use also add()!

      PROC freeone(entry) OF obj_seq IS EMPTY -> abstract,called by delentry() AND delall()

      PROC delentry(pos) OF obj_seq -> overriding - validate activeentry
            DEF i,p                   -> activeentry is not VALID

            p:=self.getp(pos)
            IF p
                  self.s[pos]:=NIL
                  FOR i:=pos+1 TO self.entries-1 DO self.s[i-1]:=self.s[i]
                  self.entries:=self.entries-1
                  self.freeone(p)
            ENDIF
      ENDPROC

      PROC delall() OF obj_seq
            DEF i,p

            FOR i:=0 TO self.entries-1
                   IF (p:=self.getp(i)) THEN self.freeone(p)
            ENDFOR
            self.entries:=0
      ENDPROC

      PROC getactive() OF obj_seq IS self.activeentry
      PROC setactive(pos) OF obj_seq
            DEF tmp:PTR TO obj_baseid

            IF self.getactive()<>-1
                  tmp:=self.getp(self.getactive())
                  IF tmp THEN tmp.deactivate()
            ENDIF
            self.activeentry:=pos
            IF pos<>-1
                  tmp:=self.getp(pos)
                  tmp.activate()
            ENDIF
      ENDPROC self.activeentry

      PROC nextentry() OF obj_seq
            DEF pp

            pp:=self.getactive()
            IF pp<>-1
                  INC pp
                  IF pp<self.entries
                        self.setactive(pp)
                  ENDIF
            ENDIF
      ENDPROC

      PROC preventry() OF obj_seq
            DEF pp

            pp:=self.getactive()
            IF pp<>-1
                  IF pp>0
                        self.setactive(pp-1)
                  ENDIF
            ENDIF
      ENDPROC

      PROC create(size,ps:PTR TO LONG) OF obj_seq
            DEF i,ts:PTR TO LONG

            self.max:=size
            self.entries:=0
            NEW ts[self.max]
            self.s:=ts
            IF ps
                  FOR i:=0 TO size-1
                        self.s[i]:=ps[i]
                  ENDFOR
            ENDIF
            self.activeentry:=-1
            self.setactive(-1)
      ENDPROC

      PROC end() OF obj_seq
            self.delall()
            END self.s[self.max]
      ENDPROC



-> ----------------------------------------------------------

OBJECT obj_lfodata
      depth:INT    -> 0..256
      period:INT   -> 1..1000 in 1/10 sec
      attack:INT   -> 0..1000 in 1/10 sec
      wavetype:INT -> 0=sine 1=triangle 2=sawtooth
      negative:INT
ENDOBJECT

OBJECT obj_envldata
      depth:INT        -> 0..256
      ilevel:INT       -> all levels 0..256
      alevel:INT       -> all times 0..100 in 1/10 sec
      atime:INT        -> types 0=linear 1=speedup 2=slowdown
      atype:INT
      dlevel:INT
      dtime:INT
      dtype:INT
      slevel:INT
      stime:INT
      stype:INT
      rlevel:INT
      rtime:INT
      rtype:INT
      shold:INT       -> boolean
      negative    -> boolean
ENDOBJECT

OBJECT obj_gendata
      static
      modulation
      negative
ENDOBJECT





-> ----------------------------------------------------
-> old stuff starts here


OBJECT obj_lfodataold
      period:INT
      type:CHAR    -> 0=sine 1=triangle 2=sawtooth
      bylines:CHAR
      unusedb:CHAR
ENDOBJECT




OBJECT obj_dspparam
      dummy:PTR TO CHAR
      tempof:CHAR
      lfof:CHAR
      envelf:CHAR
      unusedb1:CHAR

      offset:INT
      coef:INT
      
      lfo:obj_lfodataold
      envel
      unusedl1
ENDOBJECT

OBJECT obj_dspid
      dummy[4]:ARRAY
      dummy2[4]:ARRAY
      linkedid:CHAR
      cmdassign:CHAR  -> 255 = n/a
      handle:CHAR
      affects:CHAR
      params[8]:ARRAY OF obj_dspparam
ENDOBJECT

OBJECT obj_sectionid
      dummy:PTR TO CHAR   -> used for updating listview
      linkedid:CHAR
      repeat:CHAR
      transpose:INT
ENDOBJECT




OBJECT obj_sectionline
      repeat:CHAR
      ntrack:CHAR
      unusedw:INT
      flv:PTR TO CHAR  -> points to the contents of listview's line
                   -> pos:rep ,16 chars
      tracks[64]:ARRAY   -> arrays of trackid
ENDOBJECT

OBJECT obj_section
      name[32]:ARRAY
      nline:CHAR
      unusedb1:CHAR
      unusedl1
      lines[256]:ARRAY OF LONG   -> pointers to section lines
ENDOBJECT




OBJECT obj_idspid
      linkedid:CHAR
      init:CHAR   -> unused
      loop:CHAR   -> pingpong looping
      unusedb1:CHAR
      unusedl1
      inits[8]:ARRAY OF INT
      finals[4]:ARRAY OF INT
      times[4]:ARRAY OF INT
      types[4]:ARRAY
      menable[4]:ARRAY
      lenable[4]:ARRAY
ENDOBJECT   

/*OBJECT obj_sampleinfo  WHAT THE HELL IS THAT?
      rngstart
      rnglen
      cursor
      zoom:INT
ENDOBJECT*/



OBJECT obj_wave
      dummy[4]:ARRAY
      name[32]:ARRAY
      link
      len:INT
      unusedl1
ENDOBJECT

OBJECT obj_dsp    
      name[32]:ARRAY
      base
      info:PTR TO obj_dspinfo
      unusedl1,unusedl2
ENDOBJECT
      



            /* dsp plugin stuff */

OBJECT obj_dspinfo      -> returned by dsp_getinfo function
       info:PTR TO CHAR         -> points to an info text
       pnames:PTR TO LONG       -> points to an array of strings,0 terminated
       pformat:PTR TO LONG      ->        -II-        of fmt strings for sliders
       pminvals:PTR TO INT      -> array of minvalues
       pmaxvals:PTR TO INT      -> array of maxvalues
ENDOBJECT

OBJECT obj_dspstatus    -> returned by dsp_status function
       handles       -> number of opened handles
       reserved1
       reserved2
       reserved3
ENDOBJECT


-> -------------------------   methods



PROC end() OF obj_section     
DEF i
DEF p:PTR TO obj_sectionline

      FOR i:=0 TO self.nline-1
            p:=self.lines[i]
            END p
            self.lines[i]:=NIL
      ENDFOR

ENDPROC



