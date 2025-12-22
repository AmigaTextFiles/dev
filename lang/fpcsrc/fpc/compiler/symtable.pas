{
    $Id: symtable.pas,v 1.1.1.1.2.4 1998/08/13 17:41:28 florian Exp $
    Copyright (c) 1993-98 by Florian Klaempfl, Pierre Muller

    This unit handles the symbol tables

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}
unit symtable;

  interface

    uses
       objects,cobjects,verbose,systems,globals,strings,aasm,files,link
{$ifdef i386}
       ,i386
{$endif}
{$ifdef m68k}
       ,m68k
{$endif}
{$ifdef alpha}
       ,alpha
{$endif}
{$ifdef GDB}
       ,gdb
{$endif}
{$ifdef UseBrowser}
       ,browser
{$endif UseBrowser}
       ;

    const
{$ifdef FPC}
       ppubufsize=32768;
{$ELSE}
    {$IFDEF USEOVERLAY}
       ppubufsize=512;
    {$ELSE}
       ppubufsize=4096;
    {$ENDIF}
{$ENDIF}
       { possible types of symtables }
       { changed in two field
       one for the lexlevel
       and one for the symtabletype (PM)
       localsymtable = $8000;
       parasymtable = $4000;
       locallevel = $3fff;
       withsymtable = 1;
       staticsymtable = 2;
       globalsymtable = 3;
       unitsymtable = 4;
       objectsymtable = 5;
       recordsymtable = 6;
       macrosymtable = 7;
       localsymtable = 8;
       parasymtable = 9;}

    type
       tsymtabletype = (withsymtable,staticsymtable,
                        globalsymtable,unitsymtable,
                        objectsymtable,recordsymtable,
                        macrosymtable,localsymtable,
                        parasymtable);

    const
       { different options }
       sp_public = 0;
       sp_forwarddef = 1;
       sp_protected = 2;
       sp_private = 4;
       sp_static = 8;

    type
       symprop = byte;

    const
       poexceptions     = $1;       {????}
       povirtualmethod  = $2;       {Procedure is a virtual method.}
       poclearstack     = $4;       {Use IBM flat calling convention. (Used
                                     by GCC.)}
       poconstructor    = $8;       {Procedure is a constructor.}
       podestructor     = $10;      {Procedure is a constructor.}
       pointernproc     = $20;      {????}
       poexports        = $40;      {Procedure is exported.}
       poiocheck        = $80;      {IO checking should be done after
                                     a call to the procedure.}
       poabstractmethod = $100;     {Procedure is an abstract method.}
       pointerrupt      = $200;     {Procedure is an interrupt handler.}
       poinline         = $400;     {Procedure is an assembler macro.}
       poassembler      = $800;     {Procedure is written in assembler.}
       pooperator       = $1000;    {Procedure defines an operator.}
       poexternal       = $2000;    {Procedure is external. It is either in
                                     a separate object file, or it is stored
                                     in a dynamic link library. This is
                                     determined by the fields of Tprocsym.}
       poleftright      = $4000;    {Push parameters from left to right.
                                     Currently unsupported.}
       poproginit       = $8000;    {Program initialisation.}
       { cdecl is the same as poclearstack }
       pocdecl = poclearstack;
       postaticmethod   = $10000;
       pooverridingmethod=$20000;
       poclassmethod    = $40000;
       pounitinit       = $80000;    {unit initialisation.}
       popalmossyscall  = $100000;

       hasharraysize = 97;

       { last operator which can be overloaded }
       last_overloaded = ASSIGNMENT;

    const
       { options for objects and classes }
       oois_abstract = $1;
       oois_class = $2;
       oo_hasvirtual = $4;
       oo_hasprivate = $8;
       oo_hasprotected = $10;
       oo_isforward = $20;

       { options for properties }
       ppo_indexed = $1;
       ppo_defaultproperty = $2;

    type
       pword = ^word;

       { "forward" pointer }
       pformaldef = ^tformaldef;
       pfiledef = ^tfiledef;
       pobjectdef = ^tobjectdef;
       precdef = ^trecdef;
       parraydef = ^tarraydef;
       ppointerdef = ^tpointerdef;
       pstringdef = ^tstringdef;
       penumdef = ^tenumdef;
       porddef = ^torddef;
       pfloatdef = ^tfloatdef;
       pprocdef = ^tprocdef;
       perrordef = ^terrordef;
       psetdef = ^tsetdef;
       pclassrefdef = ^tclassrefdef;

       psymtable = ^tsymtable;
       punitsymtable = ^tunitsymtable;

       pdef = ^tdef;
       pprocvardef = ^tprocvardef;
       pabstractprocdef = ^tabstractprocdef;
       psym = ^tsym;
       plabelsym = ^tlabelsym;
       ppropertysym = ^tpropertysym;

       { base types }
       tbasetype = (uauto,u8bit,s32bit,uvoid,bool8bit,uchar,
                    s8bit,s16bit,u16bit,u32bit);

       { sextreal is dependant on the cpu, s64bit is also }
       { dependant on the size (tp = 80bit for both)      }
       { The EXTENDED format exists on the motorola FPU   }
       { but it uses 96 bits instead of 80, with some     }
       { unused bits within the number itself! Pretty     }
       { complicated to support, so no support for the    }
       { moment.                                          }
       { s64 bit is considered as a real because all      }
       { calculations are done by the fpu.                }
       tfloattype = (f32bit,s32real,s64real,s80real,s64bit,f16bit);

       { possible types for symtable entries }
       tsymtyp = (abstractsym,varsym,typesym,procsym,unitsym,programsym,
                  constsym,enumsym,typedconstsym,errorsym,syssym,
                  labelsym,absolutesym,propertysym,funcretsym);

       { added a new field for tdefcoll for firstcalln }
       { convertable is if is_convertable returns true
         equal is if is_equal returns true
         exact is if the def is the same excatly }

       targconvtyp = (act_convertable,act_equal,act_exact);

       tvarspez = (vs_value,vs_const,vs_var);

       pdefcoll = ^tdefcoll;

       tdefcoll = record
          data : pdef;
          next : pdefcoll;
          paratyp : tvarspez;
          argconvtyp : targconvtyp;
       end;

       { this object is the base for all symbol objects }
       tsym = object
          typ   : tsymtyp;
          _name : pchar;
          left  : psym;
          right : psym;
          speedvalue : longint;
          properties : symprop;
          owner : psymtable;
{$ifdef UseBrowser}
          lastref,defref,lastwritten : pref;
          refcount : longint;
          indexnb  : word; { this limit the number of symbols to
          65000 per unit, should not be a big problem !! }
{$endif UseBrowser}
{$ifdef GDB}
          isstabwritten : boolean;
{$endif GDB}
        {$ifdef tp}
          line_no : word;
        {$else}
          line_no : longint;
        {$endif}
          constructor init(const n : string);
          constructor load;
          destructor done;virtual;
          procedure write;virtual;
          procedure deref;virtual;
          function name : string;
          function mangledname : string;virtual;
          procedure setname(const s : string);
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
{$ifdef UseBrowser}
          procedure load_references; virtual;
          procedure write_references; virtual;
          procedure write_external_references;
          procedure write_ref_to_file(var f : text);
{$endif UseBrowser}
       end;

       tlabelsym = object(tsym)
          number : plabel;
          defined : boolean;
          constructor init(const n : string; l : plabel);
          destructor done;virtual;
          function mangledname : string;virtual;
          procedure write;virtual;
       end;

       punitsym = ^tunitsym;

       tunitsym = object(tsym)
          unitsymtable : punitsymtable;
          prevsym : punitsym;
          refs : longint;
          constructor init(const n : string;ref : punitsymtable);
          destructor done;virtual;
          procedure write;virtual;
{$ifdef GDB}
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       pmacrosym = ^tmacrosym;

       tmacrosym = object(tsym)
          defined : boolean;
          buftext : pchar;
          buflen : longint;
          { macros aren't written to PPU files ! }
          constructor init(const n : string);
          destructor done;virtual;
       end;

       perrorsym = ^terrorsym;

       terrorsym = object(tsym)
          constructor init;
       end;

       pprocsym = ^tprocsym;

       tprocsym = object(tsym)
          definition : pprocdef;
{$ifdef CHAINPROCSYMS}
          nextprocsym : pprocsym;
{$endif CHAINPROCSYMS}
{$ifdef GDB}
          is_global : boolean;{necessary for stab}
{$endif GDB}
          constructor init(const n : string);
          constructor load;
          destructor done;virtual;
          function mangledname : string;virtual;
          { tests, if all procedures definitions are defined and not }
          { only forward                                             }
          procedure check_forward;
          procedure write;virtual;
          procedure deref;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       ptypesym = ^ttypesym;

       ttypesym = object(tsym)
          definition : pdef;
          forwardpointer : ppointerdef;
{$ifdef GDB}
          isusedinstab : boolean;
{$endif GDB}
          constructor init(const n : string;d : pdef);
          constructor load;
          destructor done;virtual;
          procedure write;virtual;
          procedure deref;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       pvarsym = ^tvarsym;

       tvarsym = object(tsym)
          address : longint;
          definition : pdef;
          refs : longint;
          regable : boolean;

          { if reg<>R_NO, then the variable is an register variable }
          reg : tregister;

          { sets the type of access }
          varspez : tvarspez;
          is_valid : byte;
          constructor init(const n : string;p : pdef);
          constructor load;
          function mangledname : string;virtual;
          function getsize : longint;
          procedure write;virtual;
          procedure deref;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       tpropertysym = object(tsym)
          options : longint;
          proptype : pdef;
          { proppara : pdefcoll; }
          readaccesssym,writeaccesssym : psym;
          readaccessdef,writeaccessdef : pdef;
          index : longint;
          constructor init(const n : string);
          destructor done;virtual;
          constructor load;
          function getsize : longint;virtual;
          procedure write;virtual;
          procedure deref;virtual;
{$ifdef GDB}
          { I don't know how }
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

{$ifdef TEST_FUNCRET}
       pfuncretsym = ^tfuncretsym;

       tfuncretsym = object(tsym)
          funcretprocinfo : pprocinfo;
          funcretdef : pdef;
          address : longint;
          constructor init(const n : string;approcinfo : pprocinfo);
       end;
{$endif TEST_FUNCRET}

       pabsolutesym = ^tabsolutesym;

       absolutetyp = (tovar,toasm,toaddr);

       tabsolutesym = object(tvarsym)
          abstyp : absolutetyp;
          absseg : boolean;
          ref : psym;
          asmname : pstring;
          { this creates a problem in gen_vmt !!!!!
          because the pdef is not resolved yet !!
          we should fix this }
          constructor load;
          procedure deref;virtual;
          function mangledname : string;virtual;
          procedure write;virtual;
          {constructor init(const s : string;p : pdef;newref : psym);}
{$ifdef GDB}
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       ptypedconstsym = ^ttypedconstsym;

       ttypedconstsym = object(tsym)
          prefix : pstring;
          definition : pdef;
          constructor init(const n : string;p : pdef);
          constructor load;
          destructor done;virtual;
          function mangledname : string;virtual;
          procedure write;virtual;
          procedure deref;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
{$endif GDB}
       end;

       tconsttype = (constord,conststring,constreal,constbool,constint,
         constchar,constseta);

       pconstsym = ^tconstsym;

       tconstsym = object(tsym)
          definition : pdef;
          consttype : tconsttype;
          value : longint;
          constructor init(const n : string;t : tconsttype;v : longint;def : pdef);
          constructor load;
          function mangledname : string;virtual;
{$ifdef GDB}
          destructor done;virtual;
{$endif GDB}
          procedure deref;virtual;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       penumsym = ^tenumsym;

       tenumsym = object(tsym)
          value : longint;
          definition : penumdef;
          next : penumsym;
          constructor init(const n : string;def : penumdef;v : longint);
          constructor load;
          procedure write;virtual;
          procedure deref;virtual;
{$ifdef GDB}
          procedure order;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       pprogramsym = ^tprogramsym;

       tprogramsym = object(tsym)
          constructor init(const n : string);
       end;

       psyssym = ^tsyssym;

       tsyssym = object(tsym)
          number : longint;
          constructor init(const n : string;l : longint);
          procedure write;virtual;
{$ifdef GDB}
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       tcallback = procedure(p : psym);

       tsymtablehasharray = array[0..hasharraysize-1] of psym;

       psymtablehasharray = ^tsymtablehasharray;

       tsymtable = object
          name : pstring;
          datasize : longint;
          wurzel : psym;
          hasharray : psymtablehasharray;
          next : psymtable;

          defowner : pdef; { for records and objects }

          { only used for parameter symtable to determine the offset relative }
          { to the frame pointer                                              }
          call_offset : longint;

          { this saves all definition to allow a proper clean up }
          wurzeldef : pdef;
          symtabletype : tsymtabletype;
          { separate lexlevel from symtable type }
          symtablelevel : byte;

          { each symtable gets a number }
          unitid : word;

          constructor init(t : tsymtabletype);
          constructor load;
          constructor loadasstruct(typ : tsymtabletype);
          destructor done;virtual;
          procedure check_forwards;
          procedure insert(sym : psym);
          function search(const s : stringid) : psym;
          procedure clear;
          procedure registerdef(p : pdef);
          procedure foreach(proc2call : tcallback);
          procedure allsymbolsused;
          procedure allunitsused;
{$ifdef CHAINPROCSYMS}
          procedure chainprocsyms;
{$endif CHAINPROCSYMS}
          procedure write;
          procedure number_units;
          procedure number_defs;
          procedure writeasstruct;
          function getdefnr(l : word) : pdef;
{$ifdef UseBrowser}
          function getsymnr(l : word) : psym;
          procedure number_symbols;
          procedure write_external_references;
{$endif UseBrowser}
{$ifdef GDB}
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          function getnewtypecount : word; virtual;
       end;

       tunitsymtable = object(tsymtable)
          checksum,maschstart : longint;
          dbx_count : longint;
          is_stab_written : boolean;
          prev_dbx_counter : plongint;
          dbx_count_ok : boolean;
          unittypecount  : word;
          unitsym : punitsym;

          constructor init(t : tsymtabletype;const n : string);
          constructor load(const n : string);
          procedure writeasunit;
{$ifdef GDB}
          procedure orderdefs;
          procedure concattypestabto(asmlist : paasmoutput);
{$endif GDB}
          function getnewtypecount : word; virtual;
       end;

       { definition contains the informations about a type }
       tdeftype = (abstractdef,arraydef,recorddef,pointerdef,orddef,
                   stringdef,enumdef,procdef,objectdef,errordef,
                   filedef,formaldef,setdef,procvardef,floatdef,
                   classrefdef);

       tdef = object
          savesize : longint;
          owner : psymtable;
          { this allows to determine by which type the definition was generated }
          sym : ptypesym;
          next : pdef;
{$ifdef GDB}
          globalnb : word;
          nextglobal : pdef;
          {StabType : word;}
          isstabwritten : boolean;
{$endif GDB}
          number : word;
          deftype : tdeftype;

          function size : longint;virtual;
{$ifdef GDB}
          function NumberString : string;
{$endif GDB}
          constructor init;
{$ifdef GDB}
          constructor load;
          procedure set_globalnb;
{$endif GDB}
          destructor done;virtual;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          function allstabstring : pchar;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure deref;virtual;
       end;

       tfiletype = (ft_text,ft_typed,ft_untyped);

       tfiledef = object(tdef)
          public
             filetype : tfiletype;
             typed_as : pdef;
             constructor init(ft : tfiletype;tas : pdef);
             constructor load;
             procedure write;virtual;
{$ifdef GDB}
             function stabstring : pchar;virtual;
             procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
             procedure deref;virtual;
          {private}
             procedure setsize;
       end;

       tformaldef = object(tdef)
          constructor init;
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       terrordef = object(tdef)
          constructor init;
{$ifdef GDB}
          function stabstring : pchar;virtual;
{$endif GDB}
       end;

       { tpointerdef and tclassrefdef should get a common
         base class, but I derived tclassrefdef from tpointerdef
         to avoid problems with bugs (FK)
       }

       tpointerdef = object(tdef)
          definition : pdef;
          defsym : ptypesym;
          constructor init(def : pdef);
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure deref;virtual;
       end;

       tclassrefdef = object(tpointerdef)
          constructor init(def : pdef);
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       tarraydef = object(tdef)
          lowrange : longint;
          highrange : longint;
          rangenr : longint;
          definition : pdef;
          rangedef : pdef;
          function elesize : longint;
          constructor init(l,h : longint;rd : pdef);
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure deref;virtual;
          function size : longint;virtual;

          { generates the ranges needed by the asm instruction BOUND (i386)
            or CMP2 (Motorola) }
          procedure genrangecheck;
       end;

       trecdef = object(tdef)
          symtable : psymtable;
          constructor init(p : psymtable);
          constructor load;
          destructor done;virtual;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure deref;virtual;
       end;

       torddef = object(tdef)
          von : longint;
          bis : longint;
          rangenr : longint;
          typ : tbasetype;
          constructor init(t : tbasetype;v,b : longint);
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
{$endif GDB}
          procedure setsize;

          { generates the ranges needed by the asm instruction BOUND }
          { or CMP2 (Motorola)                                       }
          procedure genrangecheck;
       end;

       tfloatdef = object(tdef)
          typ : tfloattype;
          constructor init(t : tfloattype);
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
{$endif GDB}
          procedure setsize;
       end;

       tabstractprocdef = object(tdef)
          { saves a definition to the return type }
          retdef : pdef;
          { save the procedure options }
          options : longint;
          para1 : pdefcoll;
          constructor init;
          constructor load;
          destructor done;virtual;
          procedure concatdef(p : pdef;vsp : tvarspez);
          procedure deref;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure write;virtual;
       end;

       tprocvardef = object(tabstractprocdef)
          constructor init;
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput); virtual;
{$endif GDB}
       end;

       tprocdef = object(tabstractprocdef)
          extnumber : longint;
          nextoverloaded : pprocdef;
          { pointer to the local symbol table }
          localst : psymtable;
          { pointer to the parameter symbol table }
          parast : psymtable;

{$ifdef UseBrowser}
          lastref,defref,lastwritten : pref;
          refcount : longint;
{$endif UseBrowser}

          _class : pobjectdef;
          _mangledname : pchar;

          { it's a tree, but this not easy to handle }
          { with the interfaces of units             }
          code : pointer;

          { true, if the procedure is only declared }
          { (forward procedure) }
          forwarddef : boolean;

          { set which contains the modified registers }
{$ifdef i386}
          usedregisters : byte;
{$endif}
{$ifdef m68k}
          usedregisters : word;
{$endif}
{$ifdef alpha}
          usedregisters_int : longint;
          usedregisters_fpu : longint;
{$endif}
          constructor init;
          destructor done;virtual;
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function cplusplusmangledname : string;
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure deref;virtual;
          function mangledname : string;
          procedure setmangledname(const s : string);
{$ifdef UseBrowser}
          procedure load_references; virtual;
          procedure write_references; virtual;
          procedure write_external_references;
          procedure write_ref_to_file(var f : text);
{$endif UseBrowser}
       end;

       stringtype = (shortstring, longstring, ansistring);

       tstringdef = object(tdef)
          string_typ : stringtype;
          len : longint;
          constructor init(l : byte);
          constructor load;
{$ifdef UseLongString}
          constructor longinit(l : longint);
          constructor longload;
{$endif UseLongString}
{$ifdef UseAnsiString}
          constructor ansiinit(l : longint);
          constructor ansiload;
{$endif UseAnsiString}
          function size : longint;virtual;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
       end;

       tenumdef = object(tdef)
          max : longint;
          has_jumps : boolean;
          first : penumsym;
          constructor init;
          constructor load;
          destructor done;virtual;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
{$endif GDB}
       end;

       tobjectdef = object(tdef)
          childof : pobjectdef;
          name : pstring;
          { privatesyms : psymtable;
          protectedsyms : psymtable; }
          publicsyms : psymtable;
          options : longint;
          constructor init(const n : string;c : pobjectdef);
          destructor done;virtual;
          procedure check_forwards;
          function isrelated(d : pobjectdef) : boolean;
          function size : longint;virtual;
          constructor load;
          procedure write;virtual;
          function vmt_mangledname : string;
          function isclass : boolean;
{$ifdef GDB}
          function stabstring : pchar;virtual;
{$endif GDB}
          procedure deref;virtual;
       end;

       tsettype = (normset,smallset,varset);

       tsetdef = object(tdef)
          setof : pdef;
          settype : tsettype;
          constructor init(s : pdef;high : longint);
          constructor load;
          procedure write;virtual;
{$ifdef GDB}
          function stabstring : pchar;virtual;
          procedure concatstabto(asmlist : paasmoutput);virtual;
{$endif GDB}
          procedure deref;virtual;
       end;

    { inits the symbol table administration }
    procedure init_symtable;
    procedure done_symtable;
    procedure reset_gdb_info;

    { searches n in symtable of pd and all anchestors }
    function search_class_member(pd : pobjectdef;const n : string) : psym;

    { returns the default property of a class, searches also anchestors }
    function search_default_property(pd : pobjectdef) : ppropertysym;

    { get a global symbol }
    function search_a_symtable(const symbol:string;symtabletype:tsymtabletype):Psym;
    procedure getsym(const s : stringid;notfounderror : boolean);
    procedure getsymonlyin(p : psymtable;const s : stringid);

    { writes an unit with the given name }
    procedure writeunitas(const s : string;unit_symtable : punitsymtable);

    { deletes a symbol table from the symbol table stack }
    procedure dellexlevel;
{$ifdef DEBUG}
    procedure test_symtablestack;
{$endif DEBUG}
    { saves a forward pointer defintion .... }
    procedure save_forward(ppd : ppointerdef;typesym : ptypesym);

    { .... resolves this forward definitions }
    procedure resolve_forwards;

    var
       { for STAB debugging }
       globaltypecount : word;
       pglobaltypecount : pword;

       registerdef : boolean;      { true, wenn Definitionen           }
                                   { registriert werden sollen         }

       symtablestack : psymtable;  { Wurzel der verketteten Liste von  }
                                   { Symboltabellen                    }

       srsym : psym;               { enthÑlt das Ergebnis der letzten  }
       srsymtable : psymtable;     { Suche nach einem Symbol           }

       forwardsallowed : boolean;  { true, wenn Pointertypen "forward" }
                                   { eingefÅgt werden dÅrfen           }

       constsymtable : psymtable;  { Symboltabelle in die die          }
                                   { Konstanten von z.B. AufzÑhlungs-  }
                                   { typen eingefÅgt werden            }

       voiddef : porddef;          { Zeiger auf eine void-Definition   }
                                   { wird von quelltext initialisiert  }
                                   { (ist resulttype einer Procedure)  }
       voidpointerdef : ppointerdef;
                                   { Zeiger auf "void"-Pointerdef      }

       u32bitdef : porddef;        { Zeiger fÅr resulttype von         }
       s32bitdef : porddef;        { Zeiger fÅr resulttype von         }
                                   { intconstn                         }

       u8bitdef : porddef;         { Pointer auf 8-Bit unsigned        }
       u16bitdef : porddef;        { Pointer auf 16-Bit unsigned        }

       c64floatdef : pfloatdef;    { Zeiger fÅr resulttype von         }
                                   { realconstn                        }
       s80floatdef : pfloatdef;    { pointer to type of temp. floats   }

       s32fixeddef : pfloatdef;    { pointer to type of temp. fixed    }

       cstringdef : pstringdef;    { pointer to type of short string const   }

{$ifdef UseLongString}
       clongstringdef : pstringdef; { pointer to type of long string const   }
{$endif UseLongString}

{$ifdef UseAnsiString}
       cansistringdef : pstringdef;  { pointer to type of ansi string const  }
{$endif UseAnsiString}

       cchardef : porddef;       { Zeiger fÅr resulttype von         }
                                   { charconstn                        }

       cfiledef : pfiledef;       { get the same definition for all file }
                                  { uses for stabs }
       firstglobaldef, lastglobaldef : pdef;

       class_tobject : pobjectdef; { pointer to the anchestor of all   }
                                   { clases                            }

       booldef : porddef;        { pointer to boolean type           }

       aktprocsym : pprocsym;      { Zeiger auf den Symboltablellen-   }
                                   { eintrag der momentan geparseten   }
                                   { procedure                         }

       procprefix : string;        { eindeutige Namen bei geschachtel- }
                                   { ten Unterprogrammen erzeugen      }

       lexlevel : longint;         { level of code                     }
                                   { 1 for main procedure              }
                                   { 2 for normal function or proc     }
                                   { higher for locals                 }

       macros : psymtable;         { Zeiger auf die Symboltabelle mit  }
                                   { Makros                            }

       read_member : boolean;      { true, wenn Members aus einer PPU-  }
                                   { Datei gelesen werden, d.h. ein     }
                                   { varsym seine Adresse einlesen soll }

       generrorsym : psym;         { Jokersymbol, wenn das richtige    }
                                   { Symbol nicht gefunden wird        }

       generrordef : pdef;         { Jokersymbol fÅr eine fehlerhafte  }
                                   { Typdefinition                     }

       aktobjectdef : pobjectdef;  { used for private functions check !! }

       overloaded_operators : array[PLUS..last_overloaded] of pprocsym;
      { unequal is not equal}
    const
       overloaded_names : array [PLUS..last_overloaded] of string[16] =
         ('plus','minus','star','slash','equal',
          'greater','lower','greater_or_equal',
          'lower_or_equal','as','is','in','sym_diff',
          'caret','assign');

{$ifdef GDB}
    function typeglobalnumber(const s : string) : string;
{$endif GDB}

    function globaldef(const s : string) : pdef;

    procedure maybe_concat_external(symt : psymtable;const name : string);

       { pointer to the system unit, if the system unit is loaded }
   const systemunit : punitsymtable = nil;
         current_object_option : symprop = sp_public;
{$ifdef UseBrowser}
       use_browser  : boolean   = true;
{$endif UseBrowser}


implementation

{$ifdef TP}
  {$F+}
{$endif TP}

  var
       aktrecordsymtable : psymtable; { zeigt auf die Symboltabelle des }
                                      { Records, das momentan aus einer }
                                      { PPU-Datei gelesen wird          }


   {to dispose the global symtable of a unit }
const
    dispose_global: boolean =false;
    object_options : boolean = false;
    memsizeinc = 2048; { for long stabstrings }
    tagtypes : Set of tdeftype =
      [recorddef,enumdef,
      {$IfNDef GDBKnowsStrings}
      stringdef,
      {$EndIf not GDBKnowsStrings}
      {$IfNDef GDBKnowsFiles}
      filedef,
      {$EndIf not GDBKnowsFiles}
      objectdef];

    var
       { this is for a faster execution }
       ppufile : tbufferedfile;

    procedure writestring(s : string);

      begin
         ppufile.write_data(s,length(s)+1);
      end;

    procedure writeset(var s);      {You cannot pass an array[0..31]
                                     of byte!}
      begin
         ppufile.write_data(s,32);
      end;

    procedure writedefref(p : pdef);

      begin
         if p=nil then
       ppufile.write_long($ffffffff)
     else
       begin
          if (p^.owner^.symtabletype=recordsymtable) or
            (p^.owner^.symtabletype=objectsymtable) then
        ppufile.write_word($ffff)
          else ppufile.write_word(p^.owner^.unitid);
        ppufile.write_word(p^.number);
     end;
      end;

{$ifdef UseBrowser}
    procedure writesymref(p : psym);

      begin
         if p=nil then
           writelong($ffffffff)
         else
           begin
              if (p^.owner^.symtabletype=recordsymtable) or
                 (p^.owner^.symtabletype=objectsymtable) then
                writeword($ffff)
              else writeword(p^.owner^.unitid);
              writeword(p^.indexnb);
           end;
      end;
{$endif UseBrowser}

    procedure writeunitas(const s : string;unit_symtable : punitsymtable);

{$ifdef UseBrowser}
      var
         pus : punitsymtable;
{$endif UseBrowser}

      begin
         Message1(unit_u_ppu_write,s);

       { open en init ppufile }
         ppufile.init(s,ppubufsize);
         ppufile.change_endian:=source_info.endian<>target_info.endian;
         ppufile.rewrite;
         if ioresult<>0 then
          Message(unit_f_ppu_cannot_write);

       { create and write header }
         unitheader[8]:=char(byte(target_info.target));
         if use_dbx then
           current_module^.flags:= current_module^.flags or uf_uses_dbx;
{$ifdef UseBrowser}
         if use_browser then
           current_module^.flags:= current_module^.flags or uf_uses_browser;
{$endif UseBrowser}
         if target_info.endian=en_big_endian then
           current_module^.flags:=current_module^.flags or uf_big_endian;
         unitheader[9]:=char(current_module^.flags);
         ppufile.write_data(unitheader,sizeof(unitheader));

         ppufile.clear_crc;
         ppufile.do_crc:=true;
         unit_symtable^.writeasunit;
         ppufile.flush;
         ppufile.do_crc:=false;

{$ifdef UseBrowser}
         { write all new references to old unit elements }
         pus:=punitsymtable(unit_symtable^.next);
         if use_browser then
         while assigned(pus) do
           begin
              if pus^.symtabletype = unitsymtable then
                pus^.write_external_references;
              pus:=punitsymtable(pus^.next);
           end;
{$endif UseBrowser}

         { writes the checksum }
         ppufile.seek(10);
         current_module^.crc:=ppufile.getcrc;
         ppufile.write_data(current_module^.crc,4);
         ppufile.flush;

         ppufile.done;
      end;


    function readbyte : byte;

      var
         count : longint;
         b : byte;

      begin
         current_module^.ppufile^.read_data(b,sizeof(byte),count);
         readbyte:=b;
         if count<>1 then
           Message(unit_f_ppu_read_error);
      end;

    function readword : word;

      var
         count : longint;
         w : word;

      begin
         current_module^.ppufile^.read_data(w,sizeof(word),count);
{$IFDEF BIG_ENDIAN}
         w:=swap(w);
{$ENDIF}
         readword:=w;
         if count<>sizeof(word) then
           Message(unit_f_ppu_read_error);
      end;

    function readlong : longint;

      var
         count,l : longint;
         w1, w2  : word;

      begin
         current_module^.ppufile^.read_data(l,sizeof(longint),count);
{$ifdef BIG_ENDIAN}
         w1:=l and $ffff;
         w2:=l shr 16;
         l:=swap(w2)+(longint(swap(w1)) shl 16);
{$endif}
         readlong:=l;
         if count<>sizeof(longint) then
           Message(unit_f_ppu_read_error);
      end;

    function readdouble : double;

      var
         count : longint;
         d : double;

      begin
         current_module^.ppufile^.read_data(d,sizeof(double),count);
         readdouble:=d;
         if count<>sizeof(double) then
           Message(unit_f_ppu_read_error);
      end;

    function readstring : string;

      var
         s : string;
         count : longint;

      begin
         s[0]:=char(readbyte);
         current_module^.ppufile^.read_data(s[1],ord(s[0]),count);
         if count<>ord(s[0]) then
           Message(unit_f_ppu_read_error);
         readstring:=s;
      end;

{***SETCONST}
    procedure readset(var s);   {You cannot pass an array [0..31] of byte.}

    var count:longint;

      begin
         current_module^.ppufile^.read_data(s,32,count);
         if count<>32 then
           Message(unit_f_ppu_read_error);
      end;
{***}

    function readdefref : pdef;

      var
         hd : pdef;

      begin
         longint(hd):=readword;
         longint(hd):=longint(hd) or (longint(readword) shl 16);
         readdefref:=hd;
      end;

    procedure resolvedef(var d : pdef);

      begin
         if longint(d)=$ffffffff then
           d:=nil
         else
           begin
              if (longint(d) and $ffff)=$ffff then
                d:=aktrecordsymtable^.getdefnr(longint(d) shr 16)
              else
                d:=psymtable(current_module^.map^[longint(d) and $ffff])^.getdefnr(longint(d) shr 16);
           end;
      end;

{$ifdef UseBrowser}
    function readsymref : psym;

      var
         hd : psym;

      begin
         longint(hd):=readword;
         longint(hd):=longint(hd) or (longint(readword) shl 16);
         readsymref:=hd;
      end;

    procedure resolvesym(var d : psym);

      begin
         if longint(d)=$ffffffff then
           d:=nil
         else
           begin
              if (longint(d) and $ffff)=$ffff then
                d:=aktrecordsymtable^.getsymnr(longint(d) shr 16)
              else
                d:=psymtable(current_module^.map^[longint(d) and $ffff])^.getsymnr(longint(d) shr 16);
           end;
      end;
{$endif UseBrowser}

{$I+}
    procedure getsym(const s : stringid;notfounderror : boolean);

      begin
         srsymtable:=symtablestack;
         while assigned(srsymtable) do
           begin
              srsym:=srsymtable^.search(s);
              if assigned(srsym) then exit
              else srsymtable:=srsymtable^.next;
           end;
         if forwardsallowed then
           begin
              srsymtable:=symtablestack;
              srsym:=new(ptypesym,init(s,nil));
              srsym^.properties:=sp_forwarddef;
              srsymtable^.insert(srsym);
           end
         else if notfounderror then
           begin
              Message1(sym_e_id_not_found,s);
              srsym:=generrorsym;
           end
         else srsym:=nil;
      end;

    function search_a_symtable(const symbol:string;symtabletype:tsymtabletype):Psym;

    {Search for a symbol in a specified symbol table. Returns nil if
     the symtable is not found, and also if the symbol cannot be found
     in the desired symtable.}

    var hsymtab:Psymtable;
        res:Psym;

    begin
        res:=nil;
        hsymtab:=symtablestack;
        while (hsymtab<>nil) and (hsymtab^.symtabletype<>symtabletype) do
            hsymtab:=hsymtab^.next;
        if hsymtab<>nil then
            {We found the desired symtable. Now check if the symbol we
             search for is defined in it.}
            res:=hsymtab^.search(symbol);
        search_a_symtable:=res;
    end;

    procedure getsymonlyin(p : psymtable;const s : stringid);

      begin
         { the caller have to take care if srsym=nil (FK) }
         srsym:=nil;
         if assigned(p) then
           begin
              srsymtable:=p;
              srsym:=srsymtable^.search(s);
              if assigned(srsym) then
                exit
              else
               Message1(sym_e_id_not_found,s);
           end;
      end;

    procedure dellexlevel;

      var
         p : psymtable;

      begin
         p:=symtablestack;
         symtablestack:=p^.next;

         { symbol tables of unit interfaces are never disposed }
         { this is handle by the unit unitm                    }
         if ((p^.symtabletype<>unitsymtable) and
           (p^.symtabletype<>globalsymtable)) or
           dispose_global then
           dispose(p,done);
      end;

{$ifdef DEBUG}
    procedure test_symtablestack;
      var
         p : psymtable;
         i : longint;
      begin
         p:=symtablestack;
         i:=0;
         while assigned(p) do
           begin
              inc(i);
              p:=p^.next;
              if i>500 then
               Message(sym_f_internal_error_in_symtablestack);
           end;
      end;
{$endif DEBUG}

    constructor tprocsym.init(const n : string);

      begin
         tsym.init(n);
         typ:=procsym;
         definition:=nil;
         owner:=nil;
{$ifdef GDB}
         is_global := false;
{$endif GDB}
      end;

    constructor tprocsym.load;

      begin
         tsym.load;
         typ:=procsym;
         definition:=pprocdef(readdefref);
{$ifdef GDB}
         is_global := false;
{$endif GDB}
      end;

    destructor tprocsym.done;

      begin
         check_forward;
         tsym.done;
      end;

    function tprocsym.mangledname : string;

      begin
         mangledname:=definition^.mangledname;
      end;

    function demangledparas(s : string) : string;

      var
         r : string;
         l : longint;

      begin
         demangledparas:='';
         r:=',';
         { delete leading $$'s }
         l:=pos('$$',s);
         while l<>0 do
           begin
              delete(s,1,l+1);
              l:=pos('$$',s);
           end;
         l:=pos('$',s);
         if l=0 then
           exit;
         delete(s,1,l);
         l:=pos('$',s);
         if l=0 then
           l:=length(s)+1;
         while s<>'' do
           begin
              r:=r+copy(s,1,l-1)+',';
              delete(s,1,l);
           end;
         delete(r,1,1);
         delete(r,length(r),1);
         demangledparas:=r;
      end;

    procedure tprocsym.check_forward;

      var
         pd : pprocdef;

      begin
         pd:=definition;
         while assigned(pd) do
           begin
              if pd^.forwarddef then
                begin
{$ifdef GDB}
                   if assigned(pd^._class) then
                    Message1(sym_e_forward_not_resolved,pd^._class^.name^+'.'+name+'('+demangledparas(pd^.mangledname)+')')
                     else
{$endif GDB}
                    Message1(sym_e_forward_not_resolved,name+'('+demangledparas(pd^.mangledname)+')')
                end;
              pd:=pd^.nextoverloaded;
           end;
      end;

    procedure tprocsym.deref;
      var t : ttoken;

      begin
         resolvedef(pdef(definition));
         for t:=PLUS to last_overloaded do
           if (overloaded_operators[t]=nil) and
              (name=overloaded_names[t]) then
              overloaded_operators[t]:=@self;
      end;

    constructor tprogramsym.init(const n : string);

      begin
         tsym.init(n);
         typ:=programsym;
      end;

    constructor tsymtable.init(t : tsymtabletype);

      begin
         symtabletype:=t;
         symtablelevel:=0;
         wurzel:=nil;
         defowner:=nil;
         unitid:=0;
         next:=nil;
         name:=nil;
         call_offset:=0;
         if symtabletype=objectsymtable then
           datasize:=4
         else
           datasize:=0;
         wurzeldef:=nil;
         hasharray:=nil;
      end;

    constructor tunitsymtable.init(t : tsymtabletype; const n : string);

      var
         w : word;

      begin
         tsymtable.init(t);
         name:=stringdup(n);
         unitsym:=nil;
{$ifdef GDB}
         if t = globalsymtable then
           begin
              prev_dbx_counter := dbx_counter;
              dbx_counter := @dbx_count;
           end;
         dbx_count := 0;
         unitid:=0;
{$endif GDB}
         new(hasharray);
         for w:=0 to hasharraysize-1 do
           hasharray^[w]:=nil;
         is_stab_written:=false;
{$ifdef GDB}
        if use_dbx then
          begin
             if (symtabletype=globalsymtable) then
               pglobaltypecount := @unittypecount;
             debuglist^.concat(new(pai_stabs,init(strpnew('"'+name^+'",'
                  +tostr(N_BINCL)+',0,0,0'))));
             unitid:=current_module^.unitcount;
             inc(current_module^.unitcount);
             debuglist^.concat(new(pai_direct,init(strpnew('# Global '+name^+' has index '+
                  +tostr(unitid)))));
          end;
{$endif GDB}
      end;

    procedure derefsym(p : psym);

      begin
         p^.deref;
      end;

    procedure derefsymsdelayed(p : psym);

      begin
         if p^.typ in [absolutesym,propertysym] then
           p^.deref;
      end;

    constructor tsymtable.load;

      var
         hp : pdef;
         b : byte;
         counter : word;
         sym : psym;
         ofile : string;
         ii:longint;

      begin
         current_module^.map^[0]:=@self;

         symtabletype:=unitsymtable;
         symtablelevel:=0;

         { unused for units }
         call_offset:=0;

         { reset hash array }
         new(hasharray);
         for counter:=0 to hasharraysize-1 do
            hasharray^[counter]:=nil;

         datasize:=0;
         wurzel:=nil;
         next:=nil;
         wurzeldef:=nil;
         defowner:=nil;

         unitid:=0;
         defowner:=nil;

         { read the definitions }
         counter:=0;
         repeat
           b:=readbyte;
           case b of
              ibpointerdef : hp:=new(ppointerdef,load);
              ibarraydef : hp:=new(parraydef,load);
              iborddef : hp:=new(porddef,load);
              ibfloatdef : hp:=new(pfloatdef,load);
              ibprocdef : hp:=new(pprocdef,load);
              ibstringdef : hp:=new(pstringdef,load);
{$ifdef UseLongString}
              iblongstringdef : hp:=new(pstringdef,longload);
{$endif UseLongString}
{$ifdef UseAnsiString}
              ibansistringdef : hp:=new(pstringdef,ansiload);
{$endif UseAnsiString}
              ibrecorddef : hp:=new(precdef,load);
              ibobjectdef : begin
                               hp:=new(pobjectdef,load);
                               { defines the VMT external                }
                               { owner isn't set in the constructor load }
                               { externals^.concat(new(pai_external,init('VMT_'+name^+'$_'+pobjectdef(hp)^.name^))); }
                            end;
              ibfiledef : hp:=new(pfiledef,load);
              ibformaldef : hp:=new(pformaldef,load);
              ibenumdef : hp:=new(penumdef,load);
              ibclassrefdef : hp:=new(pclassrefdef,load);
              { ibinitunit : usedunits^.insert(readstring); }
              iblibraries : begin
                              ofile:=readstring;
                              Linker.AddLibraryFile(ofile);
                              current_module^.LinkLibFiles.Insert(ofile);
                            end;
              iblinkofile : begin
                               ofile:=readstring;
                               if (current_module^.ppufile^.path<>nil) and
                                 not path_absolute(ofile) then
                                 Linker.AddObjectFile(current_module^.ppufile^.path^+ofile)
                               else
                                 Linker.AddObjectFile(ofile);
                            end;
              ibsetdef : hp:=new(psetdef,load);
              ibprocvardef : hp:=new(pprocvardef,load);
              ibend : break;
              else Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;

           if not (b in [ibloadunit,ibinitunit,iblinkofile,iblibraries]) then
             begin
                { each definition get a number }
                hp^.number:=counter;
                inc(counter);

                hp^.next:=wurzeldef;
                wurzeldef:=hp;
             end;
         until false;

         { solve the references of the symbols }
         hp:=wurzeldef;

         { for each definition }
         while assigned(hp) do
           begin
              hp^.deref;

              { insert also the owner }
              hp^.owner:=@self;

              hp:=hp^.next;
           end;

         { read the symbols }
         repeat
           b:=readbyte;
           case b of
              ibtypesym : sym:=new(ptypesym,load);
              ibprocsym : sym:=new(pprocsym,load);
              ibconstsym : sym:=new(pconstsym,load);
              ibvarsym : sym:=new(pvarsym,load);
              ibabsolutesym : sym:=new(pabsolutesym,load);
              ibaufzaehlsym : sym:=new(penumsym,load);
              ibtypedconstsym : sym:=new(ptypedconstsym,load);
              ibpropertysym : sym:=new(ppropertysym,load);
              ibend : break;
              else Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;
           { don't deref absolute symbols there, because it's possible   }
           { that the var sym which the absolute sym refers, isn't       }
           { loaded                                                      }
           { but syms must be derefered to determine the definition      }
           { because must know the varsym size when inserting the symbol }
           if not(b in [ibabsolutesym,ibpropertysym]) then
             sym^.deref;
           insert(sym);
         until false;
{$ifdef tp}
         foreach(derefsymsdelayed);
{$else}
         foreach(@derefsymsdelayed);
{$endif}
         { symbol numbering for references }
{$ifdef UseBrowser}
         number_symbols;
{$endif UseBrowser}

      end;

    constructor tunitsymtable.load(const n : string);

      var storeGlobalTypeCount : pword;
          b : byte;
      begin
         name:=stringdup(n);
         unitsym:=nil;
         unitid:=0;
         dbx_count := 0;
         if (current_module^.flags and uf_uses_dbx)<>0 then
           begin
              storeGlobalTypeCount:=PGlobalTypeCount;
              PglobalTypeCount:=@UnitTypeCount;
           end;
         inherited load;
         if (current_module^.flags and uf_uses_dbx)<>0 then
           begin
              b := readbyte;
              if b <> ibdbxcount then
               Message(unit_f_ppu_dbx_count_problem)
              else
               dbx_count := readlong;
              dbx_count_ok := true;
              b := readbyte;
              if b <> ibend then
               Message1(unit_f_ppu_invalid_entry,tostr(b));
              PGlobalTypeCount:=storeGlobalTypeCount;
           end;
         is_stab_written:=false;
      end;

    constructor tsymtable.loadasstruct(typ : tsymtabletype);

      var
         hp : pdef;
         b : byte;
         counter : word;
         sym : psym;

      begin
         symtabletype:=typ;
         hasharray:=nil;
         aktrecordsymtable:=@self;
         name:=nil;
         if symtabletype=objectsymtable then
           datasize:=4
         else
           datasize:=0;
         { isn't used there }
         call_offset := 0;
         wurzel:=nil;
         next:=nil;
         wurzeldef:=nil;
         { also unused }
         unitid:=0;

         { read definitions }
         counter:=0;
         repeat
           b:=readbyte;
           case b of
              ibpointerdef : hp:=new(ppointerdef,load);
              ibarraydef : hp:=new(parraydef,load);
              iborddef : hp:=new(porddef,load);
              ibfloatdef : hp:=new(pfloatdef,load);
              ibprocdef : hp:=new(pprocdef,load);
              ibstringdef : hp:=new(pstringdef,load);
              ibrecorddef : hp:=new(precdef,load);
              ibobjectdef : hp:=new(pobjectdef,load);
              ibenumdef : hp:=new(penumdef,load);
              ibsetdef : hp:=new(psetdef,load);
              ibprocvardef : hp:=new(pprocvardef,load);
              ibfiledef : hp:=new(pfiledef,load);
              ibclassrefdef : hp:=new(pclassrefdef,load);
              ibformaldef : hp:=new(pformaldef,load);
              ibend : break;
              else Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;

           { each def gets a number }
           hp^.number:=counter;
           inc(counter);
           hp^.next:=wurzeldef;
           wurzeldef:=hp;
         until false;
         { the references are solve in trecdef^.deref }
         { now read the symbols                       }
         repeat
           b:=readbyte;
           case b of
              ibtypesym : sym:=new(ptypesym,load);
              ibprocsym : sym:=new(pprocsym,load);
              ibconstsym : sym:=new(pconstsym,load);
              ibvarsym : sym:=new(pvarsym,load);
              ibabsolutesym : sym:=new(pabsolutesym,load);
              ibaufzaehlsym : sym:=new(penumsym,load);
              ibtypedconstsym : sym:=new(ptypedconstsym,load);
              ibpropertysym : sym:=new(ppropertysym,load);
              ibend : break;
              else Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;
           insert(sym);
         until false;
      end;

    destructor tsymtable.done;

      var
         hp : pdef;
{$ifdef GDB}
         last : pdef;
{$endif GDB}
      begin
         { erst die EintrÑge loeschen, da procsym's noch ihre Definitionen }
         { auf unaufgelîste "forwards" ueberpruefen                        }
         clear;
{$ifdef GDB}
         stringdispose(name);
{$endif GDB}
         hp:=wurzeldef;
{$ifdef GDB}
         last := Nil;
{$endif GDB}
         while assigned(hp) do
           begin
{$ifdef GDB}
              if hp^.owner=@self then
                begin
                if assigned(last) then last^.next := hp^.next;
{$endif GDB}
              wurzeldef:=hp^.next;
              dispose(hp,done);
{$ifdef GDB}
                end else
                begin
                last := hp;
                wurzeldef:=hp^.next;
                end;
{$endif GDB}
              hp:=wurzeldef;
           end;

      end;

   function tsymtable.getnewtypecount : word;
      begin
         getnewtypecount:=pglobaltypecount^;
         inc(pglobaltypecount^);
      end;

   function tunitsymtable.getnewtypecount : word;

      begin
         if symtabletype = staticsymtable then
           getnewtypecount:=tsymtable.getnewtypecount
         else
           begin
              getnewtypecount:=unittypecount;
              inc(unittypecount);
           end;
      end;

    procedure check_procsym_forward(sym : psym);

      begin
         if sym^.typ=procsym then
           pprocsym(sym)^.check_forward
         { check also object method table             }
         { we needn't to test the def list            }
         { because each object has to have a type sym }
         else if (sym^.typ=typesym) and
           (ptypesym(sym)^.definition^.deftype=objectdef) then
           pobjectdef(ptypesym(sym)^.definition)^.check_forwards;
      end;

    { checks, if all procsyms }
    { and methods are defined }
    procedure tsymtable.check_forwards;

      begin
{$ifdef tp}
         foreach(check_procsym_forward);
{$else}
         foreach(@check_procsym_forward);
{$endif}
      end;

{$ifdef UseBrowser }
    procedure add_external_ref(sym : psym);

      begin
         sym^.write_external_references;
      end;

    { writes all references to elements in other units }
    procedure tsymtable.write_external_references;

      begin
{$ifdef tp}
         foreach(add_external_ref);
{$else}
         foreach(@add_external_ref);
{$endif}
      end;
{$endif UseBrowser }

    function tsymtable.getdefnr(l : word) : pdef;

      var
         hp : pdef;

      begin
         hp:=wurzeldef;
         while (assigned(hp)) and (hp^.number<>l) do
           hp:=hp^.next;
         getdefnr:=hp;
      end;

    procedure tsymtable.registerdef(p : pdef);

      begin
         p^.next:=wurzeldef;
         wurzeldef:=p;
         p^.owner:=@self;
      end;

    procedure tsymtable.clear;

      var
         w : integer;

      begin
         { remove no entry from a withsymtable as it is only a pointer to the
         recorddef  or objectdef symtable }
         if symtabletype=withsymtable then exit;
         { remove all entry from a symbol table }
         if assigned(wurzel) then
           dispose(wurzel,done);
         if assigned(hasharray) then
           begin
              for w:=0 to hasharraysize-1 do
                if assigned(hasharray^[w]) then
                  dispose(hasharray^[w],done);
              dispose(hasharray);
           end;
      end;

{$ifdef UseBrowser}
    function tsymtable.getsymnr(l : word) : psym;

      var
         hp : psym;
         i :word;

      begin
          getsymnr:=nil;
          if assigned(hasharray) then
            begin
               hp:=nil;
               for i:=0 to hasharraysize do
                 if hasharray^[i]^.indexnb>=l then
                   begin
                      hp:=hasharray^[i];
                      break;
                   end;
            end
          else
            hp:=wurzel;
          while assigned(hp) do
            begin
               if hp^.indexnb<l then
                 hp:=hp^.right
               else
               if hp^.indexnb>l then
                 hp:=hp^.left
               else
                 begin
                    getsymnr:=hp;
                    exit;
                 end;
            end;
      end;

      procedure tsymtable.number_symbols;
        var index,i : longint;

        procedure numbersym(var osym : psym);

          begin
             if osym=nil then exit;
             numbersym(osym^.left);
             osym^.indexnb:=index;
             inc(index);
             numbersym(osym^.right);
          end;

        begin
           index:=1;
           if assigned(hasharray) then
             for i:=0 to hasharraysize-1 do
             numbersym(hasharray^[i])
           else
             numbersym(wurzel);
        end;
{$endif UseBrowser}

{$ifdef CHAINPROCSYMS}
    procedure chainprocsym(p : psym);forward;
{$endif CHAINPROCSYMS}

    function getspeedvalue(const s : string) : longint;

      var
         l : longint;
         w : word;

      begin
         l:=0;
         for w:=1 to length(s) do
           l:=l+ord(s[w]);
         getspeedvalue:=l;
      end;

    procedure tsymtable.insert(sym : psym);
{$ifdef UseBrowser}
      var  ref : pref;
{$endif UseBrowser}

      procedure _insert(var osym : psym);

      {To prevent TP from allocating temp space for temp strings, we allocate
       some temp strings manually. We can use two temp strings, plus a third
       one that TP adds, where TP alone needs five temp strings!. Storing
       these on the heap saves even more, totally 1016 bytes per recursion!}

      var   s1,s2:^string;

        begin
           if osym=nil then
             osym:=sym
           { speedvalue is used, to allow a fast insert }
           else if osym^.speedvalue>sym^.speedvalue then _insert(osym^.right)
           else if osym^.speedvalue<sym^.speedvalue then _insert(osym^.left)
           else
             begin
                new(s1);
                new(s2);
                s1^:=osym^.name;
                s2^:=sym^.name;
                if s1^>s2^ then
                    begin
                        dispose(s1);
                        dispose(s2);
                        _insert(osym^.right)
                    end
                else if s1^<s2^ then
                    begin
                        dispose(s1);
                        dispose(s2);
                        _insert(osym^.left)
                    end
                else
                  begin
                     dispose(s2);
                     if (osym^.typ=typesym) and (osym^.properties=sp_forwarddef) then
                       begin
                          dispose(s1);
                          if (sym^.typ<>typesym) then
                           Message(sym_f_id_already_typed);
                          {
                          if (ptypesym(sym)^.definition^.deftype<>recorddef) and
                             (ptypesym(sym)^.definition^.deftype<>objectdef) then
                             Message(sym_f_type_must_be_rec_or_class);
                          }
                          ptypesym(osym)^.definition:=ptypesym(sym)^.definition;
                          osym^.properties:=sp_public;
                          { resolve the definition right now !! }
{$ifdef UseBrowser}
                          {forward types have two defref chained
                          the first corresponding to the location
                          of  the
                             ptype = ^ttype;
                          and the second
                          to the line
                             ttype = record }
                          new(ref,init(nil));
                          ref^.nextref:=osym^.defref;
                          osym^.defref:=ref;
{$endif UseBrowser}
                          ptypesym(osym)^.forwardpointer^.definition:=ptypesym(osym)^.definition;
{$ifndef GDB}
                          dispose(sym);
{$else GDB}
                          if ptypesym(osym)^.definition^.sym = ptypesym(sym) then
                            ptypesym(osym)^.definition^.sym := ptypesym(osym);
                         ptypesym(osym)^.isusedinstab := true;
                         if (cs_debuginfo in aktswitches) and assigned(debuglist) then
                            osym^.concatstabto(debuglist);
                          { don't do a done on sym
                          because it also disposes left and right !!}
                          dispose(sym);
{$endif GDB}
                       end
                     else
                       begin
                          dispose(s1);
                          Message1(sym_e_duplicate_id,sym^.name);
                       end;
                  end;
             end;
      end;

      var
         l : longint;
         hp : psymtable;
         hsym : psym;

      begin
         { bei Symbolen fÅr Variablen die Adresse eintragen, }
         { und Grî·e der Symboltabellendaten berechnen       }
{$ifdef GDB}
         sym^.owner:=@self;
{$endif GDB}
{$ifdef CHAINPROCSYMS}
         { set the nextprocsym field }
         if sym^.typ=procsym then
           chainprocsym(sym);
{$endif CHAINPROCSYMS}
         { handle static variables of objects especially }
         if read_member and (symtabletype=objectsymtable) and
            (sym^.typ=varsym) and
            ((pvarsym(sym)^.properties and sp_static)<>0) then
           begin
              { the data filed is generated in parser.pas
                with a tobject_FIELDNAME variable }
              { this symbol can't be loaded to a register }
              pvarsym(sym)^.regable:=false;
           end
         else if (sym^.typ=varsym) and not(read_member) then
           begin
              { made problems with parameters etc. ! (FK) }

              {  check for instance of an abstract object or class }
              {
              if (pvarsym(sym)^.definition^.deftype=objectdef) and
                ((pobjectdef(pvarsym(sym)^.definition)^.options and oois_abstract)<>0) then
                Message(sym_e_no_instance_of_abstract_object);
              }


              { bei einer lokalen Symboltabelle erst! erhîhen, da der }
              { Wert in codegen.secondload dann mit minus verwendet   }
              { wird                                                  }
              l:=pvarsym(sym)^.getsize;
              if symtabletype=localsymtable then
                begin
                   pvarsym(sym)^.is_valid := 0;
                   inc(datasize,l);
{$ifdef m68k}
                   { word alignment required for motorola }
                   if (l=1) then
                    inc(datasize,1)
                   else
{$endif}
                   if (l>=4) and ((datasize and 3)<>0) then
                     inc(datasize,4-(datasize and 3))
                   else if (l>=2) and ((datasize and 1)<>0) then
                     inc(datasize,2-(datasize and 1));

                   pvarsym(sym)^.address:=datasize;
                end
              else if symtabletype=staticsymtable then
                begin
{$ifdef MAKELIB}
                   bsssegment^.concat(new(pai_cut,init));
{$endif MAKELIB}
{$ifdef GDB}
                   if cs_debuginfo in aktswitches then
                     begin
                        sym^.concatstabto(bsssegment);
                     end;
{$endif GDB}
{$ifndef MAKELIB}
                   bsssegment^.concat(new(pai_datablock,init(sym^.mangledname,l)));
{$else MAKELIB}
  { we need to change this to a global symbol }
                   bsssegment^.concat(new(pai_datablock,init_global(sym^.mangledname,l)));
{$endif MAKELIB}
                   inc(datasize,l);

                   { this symbol can't be loaded to a register }
                   pvarsym(sym)^.regable:=false;
                end
              else if symtabletype=globalsymtable then
                begin
{$ifdef MAKELIB}
                   bsssegment^.concat(new(pai_cut,init));
{$endif MAKELIB}
{$ifdef GDB}
                   if cs_debuginfo in aktswitches then
                     begin
                        sym^.concatstabto(bsssegment);
                        { this has to be added so that the debugger knows where to find
                          the global variable
                          Doesn't work !!

                        bsssegment^.concat(new(pai_symbol,init('_'+sym^.name))); }
                     end;
{$endif GDB}
                   bsssegment^.concat(new(pai_datablock,init_global(
                     sym^.mangledname,l)));
                   inc(datasize,l);
{$ifdef MAKELIB}
                   bsssegment^.concat(new(pai_cut,init));
{$endif MAKELIB}

                   { this symbol can't be loaded to a register }
                   pvarsym(sym)^.regable:=false;
                end
              else if symtabletype in [recordsymtable,objectsymtable] then
        begin
           { align record and object fields }
           if aktpackrecords=2 then
             begin
            { align to word }
            if (l>=2) and ((datasize and 1)<>0) then
              inc(datasize);
                     end
                   else if aktpackrecords=4 then
                     begin
                        { align to dword }
                        if (l>=3) and ((datasize and 3)<>0) then
                          inc(datasize,4-(datasize and 3))
                        { or word }
                        else if (l=2) and ((datasize and 1)<>0) then
                          inc(datasize)
                     end;
                   pvarsym(sym)^.address:=datasize;
                   inc(datasize,l);

                   { this symbol can't be loaded to a register }
                   pvarsym(sym)^.regable:=false;
                end
              else if symtabletype=parasymtable then
                begin
                   pvarsym(sym)^.address:=datasize;

                   { intel processors don't know a byte push, }
                   { so is always a word pushed               }
                   if l=1 then
                     l:=2;
                   inc(datasize,l);
                end
              else
                begin
                   if (l>=4) and ((datasize and 3)<>0) then
                     inc(datasize,4-(datasize and 3))
                   else if (l>=2) and ((datasize and 1)<>0) then
                     inc(datasize,2-(datasize and 1));
                   pvarsym(sym)^.address:=datasize;
                   inc(datasize,l);
                end;
           end
         else if sym^.typ=typedconstsym then
             begin
{$ifdef MAKELIB}
                bsssegment^.concat(new(pai_cut,init));
{$endif MAKELIB}
                if symtabletype=globalsymtable then
                    begin
{$ifdef GDB}
                        if cs_debuginfo in aktswitches then
                            sym^.concatstabto(datasegment);
{$endif GDB}
                        datasegment^.concat(new(pai_symbol,init_global(sym^.mangledname)));
                    end
                else
                    if symtabletype<>unitsymtable then
                        begin
{$ifdef GDB}
                            if cs_debuginfo in aktswitches then
                                sym^.concatstabto(datasegment);
{$endif GDB}
{$ifndef MAKELIB}
                     datasegment^.concat(new(pai_symbol,init(sym^.mangledname)));
{$else MAKELIB}
  { we need to change this to a global symbol }
  { lets use almost the same prefix than for globals but with one $ more }
                     datasegment^.concat(new(pai_symbol,init_global(sym^.mangledname)));
{$endif MAKELIB}
                  end;
             end;
         if (symtabletype=staticsymtable) or
            (symtabletype=globalsymtable) then
           begin
              hp:=symtablestack;
              while assigned(hp) do
                begin
                   if hp^.symtabletype in
                    [staticsymtable,globalsymtable] then
                        begin
                           hsym:=hp^.search(sym^.name);
                           if (assigned(hsym)) and
                              (hsym^.properties and sp_forwarddef=0) then
                                 Message1(sym_e_duplicate_id,sym^.name);
                        end;
                      hp:=hp^.next;
                end;
           end;
         if sym^.typ = typesym then
           if assigned(ptypesym(sym)^.definition) then
             begin
             if not assigned(ptypesym(sym)^.definition^.owner) then
              registerdef(ptypesym(sym)^.definition);
{$ifdef GDB}
             if (cs_debuginfo in aktswitches) and assigned(debuglist)
                and (symtabletype <> unitsymtable) then
                   begin
                   ptypesym(sym)^.isusedinstab := true;
                   sym^.concatstabto(debuglist);
                   end;
{$endif GDB}
             end;
{$ifdef TEST_FUNCRET}
         if sym^.typ=funcretsym then
           begin
              { allocate space in local if ret in acc or in fpu }
              if ret_in_acc(procinfo.retdef) or (procinfo.retdef^.deftype=floatdef) then
                begin
                   l:=pfuncretsym(sym)^.funcretdef^.size;
                   inc(datasize,l);
{$ifdef m68k}
                   { word alignment required for motorola }
                   if (l=1) then
                    inc(datasize,1)
                   else
{$endif}
                   if (l>=4) and ((datasize and 3)<>0) then
                     inc(datasize,4-(datasize and 3))
                   else if (l>=2) and ((datasize and 1)<>0) then
                     inc(datasize,2-(datasize and 1));

                   pfuncretsym(sym)^.address:=datasize;
                end;
           end;
{$endif TEST_FUNCRET}
         sym^.speedvalue:=getspeedvalue(sym^.name);
         if assigned(hasharray) then
           _insert(hasharray^[sym^.speedvalue mod hasharraysize])
         else
           _insert(wurzel);
      end;

    procedure unitsymbolused(p : psym);

      begin
         if p^.typ=unitsym then
           if (punitsym(p)^.refs=0) then
             comment(V_info,'Unit '+p^.name+' is not used');
      end;

    procedure tsymtable.allunitsused;

      begin
{$ifdef tp}
         foreach(unitsymbolused);
{$else}
         foreach(@unitsymbolused);
{$endif}
      end;

    procedure varsymbolused(p : psym);

      begin
         if (p^.typ=varsym) and
            ((p^.owner^.symtabletype=parasymtable) or
            (p^.owner^.symtabletype=localsymtable) or
            (p^.owner^.symtabletype=staticsymtable))
            then
           { unused symbol should be reported only if no }
           { error is reported                           }
           { if the symbol is in a register it is used   }
           if (pvarsym(p)^.refs=0) and
              (errorcount=0) and
              (pvarsym(p)^.reg=R_NO) then
             begin
             {   if p^.owner^.symtabletype=parasymtable then
                  exterror:=strpnew(' arg '+p^.name
                    +' declared in line '+tostr(p^.line_no))
                else
                  exterror:=strpnew(' local '+p^.name
                    +' declared in line '+tostr(p^.line_no)); }
                Message2(sym_h_identifier_not_used,p^.name,tostr(p^.line_no));
             end;
      end;

    procedure tsymtable.allsymbolsused;

      begin
{$ifdef tp}
         foreach(varsymbolused);
{$else}
         foreach(@varsymbolused);
{$endif}
      end;

{$ifdef CHAINPROCSYMS}
    procedure chainprocsym(p : psym);

      var
         storesymtablestack : psymtable;
      begin
         if p^.typ=procsym then
           begin
              storesymtablestack:=symtablestack;
              symtablestack:=p^.owner^.next;
              while assigned(symtablestack) do
                begin
                  { search for same procsym in other units }
                  getsym(p^.name,false);
                  if assigned(srsym) and (srsym^.typ=procsym) then
                    begin
                       pprocsym(p)^.nextprocsym:=pprocsym(srsym);
                       symtablestack:=storesymtablestack;
                       exit;
                    end
                  else if srsym=nil then
                    symtablestack:=nil
                  else
                    symtablestack:=srsymtable^.next;
                end;
              symtablestack:=storesymtablestack;
           end;
      end;

    procedure tsymtable.chainprocsyms;

      begin
{$ifdef tp}
         foreach(chainprocsym);
{$else}
         foreach(@chainprocsym);
{$endif}
      end;
{$endif CHAINPROCSYMS}

{$ifdef GDB}

      var l : paasmoutput;

      procedure concatstab(p : psym);
      begin
      if p^.typ <> procsym then
        p^.concatstabto(l);
      end;

      procedure concattypestab(p : psym);
      begin
      if p^.typ = typesym then
        begin
        p^.isstabwritten:=false;
        p^.concatstabto(l);
        end;
      end;

      procedure tsymtable.concatstabto(asmlist : paasmoutput);
      begin
      l := asmlist;
{$ifdef tp}
      foreach(concatstab);
{$else}
      foreach(@concatstab);
{$endif}
      end;

      procedure tunitsymtable.concattypestabto(asmlist : paasmoutput);
        var prev_dbx_count : plongint;
        begin
           if is_stab_written then exit;
           if not assigned(name) then name := stringdup('Main_program');
           if symtabletype = unitsymtable then
             begin
                unitid:=current_module^.unitcount;
                inc(current_module^.unitcount);
             end;
           asmlist^.concat(new(pai_direct,init(strpnew('# Begin unit '+name^
                  +' has index '+tostr(unitid)))));
           if use_dbx then
             begin
                if dbx_count_ok then
                  begin
                     asmlist^.insert(new(pai_direct,init(strpnew('# "repeated" unit '+name^
                              +' has index '+tostr(unitid)))));
                     do_count_dbx:=true;
                     asmlist^.concat(new(pai_stabs,init(strpnew('"'+name^+'",'
                       +tostr(N_EXCL)+',0,0,'+tostr(dbx_count)))));
                     exit;
                  end;
                prev_dbx_count := dbx_counter;
                dbx_counter := nil;
                if symtabletype = unitsymtable then
                  asmlist^.concat(new(pai_stabs,init(strpnew('"'+name^+'",'
                    +tostr(N_BINCL)+',0,0,0'))));
                dbx_counter := @dbx_count;
             end;
           l:=asmlist;
{$ifdef tp}
           foreach(concattypestab);
{$else}
           foreach(@concattypestab);
{$endif}
           if use_dbx then
             begin
                dbx_counter := prev_dbx_count;
                do_count_dbx:=true;
                asmlist^.concat(new(pai_stabs,init(strpnew('"'+name^+'",'
                  +tostr(N_EINCL)+',0,0,0'))));
                dbx_count_ok := true;
             end;
           asmlist^.concat(new(pai_direct,init(strpnew('# End unit '+name^
                  +' has index '+tostr(unitid)))));
           is_stab_written:=true;
        end;

    procedure forcestabto(asmlist : paasmoutput; pd : pdef);
    begin
    if not pd^.isstabwritten then
      begin
      if assigned(pd^.sym) and (pd^.sym^.typ=typesym) then
        pd^.sym^.isusedinstab := true;
      pd^.concatstabto(asmlist);
      end;
    end;

{$endif GDB}

    function tsymtable.search(const s : stringid) : psym;

      var
         hp : psym;
         speedvalue : longint;

      begin
         speedvalue:=getspeedvalue(s);
         if assigned(hasharray) then
           hp:=hasharray^[speedvalue mod hasharraysize]
         else
           hp:=wurzel;
         while assigned(hp) do
           begin
              if speedvalue>hp^.speedvalue then hp:=hp^.left
              else if speedvalue<hp^.speedvalue then hp:=hp^.right
              else
                begin
                   if (hp^.name=s) then
                     begin
                        { reject non static members in static procedures }
                        if (symtabletype=objectsymtable) and
                           ((hp^.properties and sp_static)=0) and
                           assigned(aktprocsym) and
                           ((aktprocsym^.definition^.options and postaticmethod)<>0) then
                               Message(sym_e_only_static_in_static);
                        { should we allow use of private field in the whole
                        unit ? }
                        if (symtabletype=objectsymtable) and
                           (hp^.properties=sp_private) and
                           {defowner is the objectdef and the owner of the objectdef
                           is a unitsymtable, or golbalsymtable if we are compiling it !!}
                           (psymtable(defowner^.owner)^.symtabletype<>globalsymtable) and
                           (aktobjectdef<>pobjectdef(defowner)) and
                           ((aktprocsym^.definition=nil) or
                           (aktprocsym^.definition^._class<>pobjectdef(defowner))) then
                           begin
                              search:=nil;
                              exit;
                           end;
                        search:=hp;
                        if (symtabletype=unitsymtable) and
                           assigned(punitsymtable(@self)^.unitsym) then
                          inc(punitsymtable(@self)^.unitsym^.refs);
{$ifdef UseBrowser}
                        add_new_ref(hp^.lastref);
                        { for symbols that are in tables without
                        browser info }
                        if hp^.refcount=0 then
                          hp^.defref:=hp^.lastref;
                        inc(hp^.refcount);
{$endif UseBrowser}
                        exit;
                     end
                  else if s>hp^.name then hp:=hp^.left
                  else hp:=hp^.right;
                end;
           end;
         search:=nil;
      end;

    procedure tsymtable.foreach(proc2call : tcallback);

      procedure a(p : psym);

        { must be preorder, because it's used by reading in }
        { a PPU file                                        }
        begin
           proc2call(p);
           if assigned(p^.left) then a(p^.left);
           if assigned(p^.right) then a(p^.right);
        end;

      var
         i : integer;

      begin
         if hasharray<>nil then
           begin
              for i:=0 to hasharraysize-1 do
                if assigned(hasharray^[i]) then
                  a(hasharray^[i]);
           end
         else
           if assigned(wurzel) then
             a(wurzel);
      end;

    { write one symbol, is only used as call back procedure }
    procedure writesym(p : psym);

      begin
         p^.write;
      end;

    procedure tsymtable.number_units;

      var
         counter : word;
         p : psymtable;

     begin
         unitid:=0;

         { zuerst alle im Interface-Abschnitt aufgefÅhrten Units }
         { in die Datei schreiben und numerieren }
         p:=next;
         counter:=1;

         { im Implementationsteil aufgefuehrte Units ueberspringen }
         if symtabletype<>globalsymtable then
           begin
              while (p^.symtabletype<>globalsymtable) do
                p:=p^.next;
              p:=p^.next;
           end;
         while assigned(p) do
           begin
              if p^.symtabletype=unitsymtable then
                begin
                   p^.unitid:=counter;
                   inc(counter);
                end;
              p:=p^.next;
           end;

      end;

    procedure tsymtable.number_defs;

      var
         pd : pdef;
         counter : longint;

      begin
         counter:=0;
         pd:=wurzeldef;
         while assigned(pd) do
           begin
              pd^.number:=counter;
              inc(counter);
              pd:=pd^.next;
           end;
      end;

{$ifdef GDB }
    procedure tunitsymtable.orderdefs;
      var
         first, last, nonum, pd, cur, prev, lnext : pdef;

      begin
         pd:=wurzeldef;
         first:=nil;
         last:=nil;
         nonum:=nil;
         while assigned(pd) do
           begin
              lnext:=pd^.next;
              if pd^.globalnb > 0 then
                if first = nil then
                  begin
                     first:=pd;
                     last:=pd;
                     last^.next:=nil;
                  end
                else
                  begin
                     cur:=first;
                     prev:=nil;
                     while assigned(cur) and
                           (prev <> last) and
                           (cur^.globalnb>0) and
                           (cur^.globalnb<pd^.globalnb) do
                       begin
                          prev:=cur;
                          cur:=cur^.next;
                       end;
                     if cur = first then
                       begin
                          pd^.next:=first;
                          first:=pd;
                       end
                     else
                     if prev = last then
                       begin
                          pd^.next:=nil;
                          last^.next:=pd;
                          last:=pd;
                       end
                     else
                       begin
                          pd^.next:=cur;
                          prev^.next:=pd;
                       end;
                  end
                else  { without number }
                  begin
                     pd^.next:=nonum;
                     nonum:=pd;
                  end;
              pd:=lnext;
           end;
         if assigned(first) then
           begin
              wurzeldef:=first;
              last^.next:=nonum;
           end else
           wurzeldef:=nonum;
      end;
{$endif GDB }

    procedure tunitsymtable.writeasunit;

      var
         counter : word;
         hp : pused_unit;
         hp2 : pextfile;
         s : string;
         index : word;

      begin
         { second write the used source files }
         hp2:=current_module^.sourcefiles.files;
         index:=current_module^.sourcefiles.last_ref_index;
         while assigned(hp2) do
           begin
              ppufile.write_byte(ibsourcefile);

              { only name and extension }
              writestring(hp2^.name^+hp2^.ext^);
              { index in that order }
              hp2^.ref_index:=index;
              dec(index);
              hp2:=hp2^._next;
           end;

         ppufile.write_byte(ibend);

         unitid:=0;

         { each used unit gets a number }
         counter:=1;

         { ... and write interface units with their number and checksum }
         hp:=pused_unit(current_module^.used_units.first);
         while assigned(hp) do
           begin
              if hp^.in_interface then
                begin
                  psymtable(hp^.u^.symtable)^.unitid:=counter;
                  inc(counter);
                  ppufile.write_byte(ibloadunit);
                  writestring(psymtable(hp^.u^.symtable)^.name^);
                  ppufile.write_long(hp^.u^.crc);
                end;
              hp:=pused_unit(hp^.next);
           end;

         ppufile.write_byte(ibend);

         { writes the names of the units which should be init'ed
         s:=usedunits^.get;
         while s<>'' do
           begin
              writebyte(ibinitunit);
              writestring(s);
              s:=usedunits^.get;
           end;
         }

         { we should only write the objectfiles that come for this unit !! }
         while not current_module^.linkofiles.empty do
           begin
              ppufile.write_byte(iblinkofile);
              writestring(current_module^.linkofiles.get);
           end;


         { write any used libraries }
         while not current_module^.linklibfiles.empty do
           begin
              ppufile.write_byte(iblibraries);
              writestring(current_module^.linklibfiles.get);
           end;


         tsymtable.write;
         if use_dbx then
           begin
              ppufile.write_byte(ibdbxcount);
              ppufile.write_long(dbx_count);
{$IfDef EXTDEBUG}
              writeln('Writing dbx_count ',dbx_count,' in unit ',name^,'.ppu');
{$ENDIF EXTDEBUG}
              ppufile.write_byte(ibend);
           end;
         { ... and write implementation units with their number and checksum }
         hp:=pused_unit(current_module^.used_units.first);
         while assigned(hp) do
           begin
              if not hp^.in_interface then
                begin
                  psymtable(hp^.u^.symtable)^.unitid:=counter;
                  inc(counter);
                  ppufile.write_byte(ibloadunit);
                  writestring(psymtable(hp^.u^.symtable)^.name^);
                  {this remains a problem : the crc is not calculted yet ! }
                  ppufile.write_long(hp^.u^.crc);
                end;
              hp:=pused_unit(hp^.next);
           end;

         ppufile.write_byte(ibend);

      end;

    procedure tsymtable.writeasstruct;

      begin
         tsymtable.write;
      end;

    procedure tsymtable.write;

      var
         pd : pdef;

      begin
         { each definition get a number ... }
         number_defs;
         { ...now write the definition }
         pd:=wurzeldef;
         while assigned(pd) do
           begin
              pd^.write;
              pd:=pd^.next;
           end;

         { the next part are the symbols }
         ppufile.write_byte(ibend);

         { symbol numbering for references }
{$ifdef UseBrowser}
         number_symbols;
{$endif UseBrowser}
         { foreach is used to write all symbols }

{$ifdef tp}
         foreach(writesym);
{$else}
         foreach(@writesym);
{$endif}
         { end of symbols }
         ppufile.write_byte(ibend);
      end;

{**************************************
              "forward"-pointer
 **************************************}

    type
       presolvelist = ^tresolvelist;

       tresolvelist = record
          p : ppointerdef;
          typ : ptypesym;
          next : presolvelist;
       end;

    var
       swurzel : presolvelist;

{$ifdef GDB}
    procedure clear_forwards;

      var
         p : presolvelist;

      begin
         p:=swurzel;
         while assigned(p) do
         begin
              swurzel:=p^.next;
            dispose(p);
            p := swurzel;
         end;
      end;

{$endif GDB}
    procedure save_forward(ppd : ppointerdef;typesym : ptypesym);

      var
         p : presolvelist;

      begin
         new(p);
         p^.next:=swurzel;
         p^.p:=ppd;
         ppd^.defsym := typesym;
         p^.typ:=typesym;
         swurzel:=p;
      end;

    procedure resolve_forwards;

      var
         p : presolvelist;

      begin
         p:=swurzel;
         while p<>nil do
           begin
              swurzel:=swurzel^.next;
              p^.p^.definition:=p^.typ^.definition;
              dispose(p);
              p:=swurzel;
           end;
      end;

    constructor tsym.init(const n : string);

      begin
         left:=nil;
         right:=nil;
         setname(n);
         typ:=abstractsym;
         properties:=current_object_option;
{$ifdef GDB}
         isstabwritten := false;
         if assigned(current_module) and assigned(current_module^.current_inputfile) then
           line_no:=current_module^.current_inputfile^.line_no
         else
           line_no:=0;
{$endif GDB}
{$ifdef UseBrowser}
         defref:=nil;
         lastwritten:=nil;
         add_new_ref(defref);
         lastref:=defref;
         refcount:=1;
{$endif UseBrowser}
      end;

    constructor tsym.load;

      begin
         left:=nil;
         right:=nil;
         setname(readstring);
         typ:=abstractsym;
         if object_options then
           properties:=symprop(readbyte)
         else
           properties:=sp_public;
{$ifdef UseBrowser}
         lastref:=nil;
         defref:=nil;
         lastwritten:=nil;
         refcount:=0;
         if (current_module^.flags and uf_uses_browser)<>0 then
           { references do not change the ppu caracteristics      }
           { this only save the references to variables/functions }
           { defined in the unit what about the others            }
           load_references;
{$endif UseBrowser}
{$ifdef GDB}
         isstabwritten := false;
         line_no:=0;
{$endif GDB}
      end;

{$ifdef UseBrowser}
    procedure tsym.load_references;

      var fileindex : word;
          b : byte;
          l : longint;

      begin
         b:=readbyte;
         while b=ibref do
           begin
              fileindex:=readword;
              l:=readlong;
              inc(refcount);
              lastref:=new(pref,load(lastref,fileindex,l));
              if refcount=1 then defref:=lastref;
              b:=readbyte;
           end;
         lastwritten:=lastref;
         if b <> ibend then
          Message(unit_f_ppu_read_error);
      end;

    procedure load_external_references;

      var b : byte;
          sym : psym;
          prdef : pdef;
      begin
         b:=readbyte;
         while (b=ibextsymref) or (b=ibextdefref) do
           begin
              if b=ibextsymref then
                begin
                   sym:=readsymref;
                   resolvesym(sym);
                   sym^.load_references;
                   b:=readbyte;
                end
              else
              if b=ibextdefref then
                begin
                   prdef:=readdefref;
                   resolvedef(prdef);
                   if prdef^.deftype<>procdef then
                    Message(unit_f_ppu_read_error);
                   pprocdef(prdef)^.load_references;
                   b:=readbyte;
                end;
           end;
         if b <> ibend then
           Message(unit_f_ppu_read_error);
      end;

    procedure tsym.write_references;

      var ref : pref;

      begin
      { references do not change the ppu caracteristics      }
      { this only save the references to variables/functions }
      { defined in the unit what about the others            }
         ppufile.do_crc:=false;
         if assigned(lastwritten) then
           ref:=lastwritten
         else
           ref:=defref;
         while assigned(ref) do
           begin
              if assigned(ref^.inputfile) then
                begin
                   writebyte(ibref);
                   writeword(ref^.inputfile^.ref_index);
                   writelong(ref^.lineno);
                end;
              ref:=ref^.nextref;
           end;
         lastwritten:=lastref;
         writebyte(ibend);
         ppufile.do_crc:=true;
      end;

    procedure tsym.write_external_references;

      var ref : pref;
          prdef : pdef;
      begin
         ppufile.do_crc:=false;
         if lastwritten=lastref then exit;
         writebyte(ibextsymref);
         writesymref(@self);
         if assigned(lastwritten) then
           ref:=lastwritten
         else
           ref:=defref;
         while assigned(ref) do
           begin
              if assigned(ref^.inputfile) then
                begin
                   writebyte(ibref);
                   writeword(ref^.inputfile^.ref_index);
                   writelong(ref^.lineno);
                end;
              ref:=ref^.nextref;
           end;
         lastwritten:=lastref;
         writebyte(ibend);
         if typ=procsym then
           begin
              prdef:=pprocsym(@self)^.definition;
              while assigned(prdef) do
                begin
                   pprocdef(prdef)^.write_external_references;
                   prdef:=pprocdef(prdef)^.nextoverloaded;
                end;
           end;
         ppufile.do_crc:=true;
      end;

    procedure tsym.write_ref_to_file(var f : text);

      var ref : pref;

      begin
         ref:=defref;
         while assigned(ref) do
           begin
              writeln(f,ref^.get_file_line);
              ref:=ref^.nextref;
           end;
      end;
{$endif UseBrowser}

    destructor tsym.done;

      begin
{$ifdef tp}
         if not(use_big) then
{$endif tp}
           strdispose(_name);
         if assigned(left) then dispose(left,done);
         if assigned(right) then dispose(right,done);
      end;

    procedure tsym.write;

      begin
         writestring(name);
         if object_options then
           ppufile.write_byte(byte(properties));
{$ifdef UseBrowser}
         if (current_module^.flags and uf_uses_browser)<>0 then
           write_references;
{$endif UseBrowser}
      end;

    procedure tsym.deref;

      begin
      end;

    function tsym.name : string;

{$ifdef tp}
      var
         s : string;
         b : byte;

{$endif tp}
      begin
{$ifdef tp}
         if use_big then
           begin
              symbolstream.seek(longint(_name));
              symbolstream.read(b,1);
              symbolstream.read(s[1],b);
              s[0]:=chr(b);
              name:=s;
           end
         else
{$endif}
           begin
              name:=strpas(_name);
           end;
      end;

    function tsym.mangledname : string;

      begin
         mangledname:=name;
      end;

    procedure tsym.setname(const s : string);

      begin
         setstring(_name,s);
      end;

{$ifdef GDB}
    function tsym.stabstring : pchar;

      begin
         stabstring:=strpnew('"'+name+'",'+tostr(N_LSYM)+',0,'+tostr(line_no)+',0');
      end;

    procedure tsym.concatstabto(asmlist : paasmoutput);

    var stab_str : pchar;
      begin
         if not isstabwritten then
           begin
              stab_str := stabstring;
              if asmlist = debuglist then do_count_dbx := true;
              { count_dbx(stab_str); moved to GDB.PAS }
              asmlist^.concat(new(pai_stabs,init(stab_str)));
              isstabwritten:=true;
          end;
    end;
{$endif GDB}

{**************************************
               TLABELSYM
 **************************************}

    constructor tlabelsym.init(const n : string; l : plabel);

      begin
         inherited init(n);
         typ:=labelsym;
         number:=l;
         number^.is_used:=false;
         number^.is_set:=true;
         number^.refcount:=0;
         defined:=false;
      end;

    destructor tlabelsym.done;

      begin
         if not(defined) then
          Message1(sym_e_label_not_defined,name);
         inherited done;
      end;

    function tlabelsym.mangledname : string;

      begin
         { this also sets the is_used field }
         mangledname:=lab2str(number);
      end;

    procedure tlabelsym.write;

      begin
         Message(sym_e_ill_label_decl);
      end;

{**************************************
               TUNITSYM
 **************************************}

    constructor tunitsym.init(const n : string;ref : punitsymtable);

      begin
         tsym.init(n);
         typ:=unitsym;
         unitsymtable:=ref;
         prevsym:=ref^.unitsym;
         ref^.unitsym:=@self;
         refs:=0;
      end;

    destructor tunitsym.done;
      begin
         if assigned(unitsymtable) and (unitsymtable^.unitsym=@self) then
           unitsymtable^.unitsym:=prevsym;
         inherited done;
      end;
    procedure tunitsym.write;

      begin
      end;

{$ifdef GDB}
    procedure tunitsym.concatstabto(asmlist : paasmoutput);
      begin
      {Nothing to write to stabs !}
      end;

{$endif GDB}

{**************************************
               TERRORSYM
 **************************************}

    constructor terrorsym.init;

      begin
         tsym.init('');
         typ:=errorsym;
      end;

{**************************************
               TPROPERTYSYM
 **************************************}

    constructor tpropertysym.init(const n : string);

      begin
         inherited init(n);
         typ:=propertysym;
         options:=0;
         proptype:=nil;
         readaccessdef:=nil;
         writeaccessdef:=nil;
         readaccesssym:=nil;
         writeaccesssym:=nil;
         index:=$0;
      end;

    destructor tpropertysym.done;

      begin
         inherited done;
      end;

    constructor tpropertysym.load;

      begin
         inherited load;
         typ:=propertysym;
         proptype:=readdefref;
         options:=readlong;
         index:=readlong;
         { it's hack ... }
         readaccesssym:=psym(stringdup(readstring));
         writeaccesssym:=psym(stringdup(readstring));
         { now the defs: }
         readaccessdef:=readdefref;
         writeaccessdef:=readdefref;
      end;

    procedure tpropertysym.deref;

      begin
         resolvedef(proptype);
         resolvedef(readaccessdef);
         resolvedef(writeaccessdef);
         { solve the hack we did in load: }
         if pstring(readaccesssym)^<>'' then
           begin
              srsym:=search_class_member(pobjectdef(owner^.defowner),pstring(readaccesssym)^);
              if not(assigned(srsym)) then
                srsym:=generrorsym;
           end
         else
           srsym:=nil;
         stringdispose(pstring(readaccesssym));
         readaccesssym:=srsym;
         if pstring(writeaccesssym)^<>'' then
           begin
              srsym:=search_class_member(pobjectdef(owner^.defowner),pstring(writeaccesssym)^);
              if not(assigned(srsym)) then
                srsym:=generrorsym;
           end
         else
           srsym:=nil;
         stringdispose(pstring(writeaccesssym));
         writeaccesssym:=srsym;
      end;

    function tpropertysym.getsize : longint;

      begin
         getsize:=0;
      end;

    procedure tpropertysym.write;

      begin
         ppufile.write_byte(ibpropertysym);
         tsym.write;
         writedefref(proptype);
         ppufile.write_long(options);
         ppufile.write_long(index);
         writestring(readaccesssym^.name);
         writestring(writeaccesssym^.name);
         writedefref(readaccessdef);
         writedefref(writeaccessdef);
      end;

{$ifdef GDB}
    function tpropertysym.stabstring : pchar;

      begin
         { !!!! don't know how to handle }
         stabstring:=strpnew('');
      end;

    procedure tpropertysym.concatstabto(asmlist : paasmoutput);

      begin
         { !!!! don't know how to handle }
      end;
{$endif GDB}

{$ifdef TEST_FUNCRET}
{**************************************
               TFUNCRETSYM
 **************************************}
    constructor tfuncretsym.init(const n : string;approcinfo : pprocinfo);

      begin
         tsym.init(n);
         funcretprocinfo:=approcinfo;
         funcretdef:=approcinfo^.retdef;
         { address valid for ret in param only }
         { otherwise set by insert             }
         address:=approcinfo^.retoffset;
      end;
{$endif TEST_FUNCRET}

{**************************************
               TABSOLUTESYM
 **************************************}

{   constructor tabsolutesym.init(const s : string;p : pdef;newref : psym);
     begin
        inherited init(s,p);
        ref:=newref;
        typ:=absolutesym;
     end; }

    constructor tabsolutesym.load;

      begin
         tvarsym.load;
         typ:=absolutesym;
         ref:=nil;
         address:=0;
         asmname:=nil;
         abstyp:=absolutetyp(readbyte);
         absseg:=false;
         case abstyp of
            tovar:
              begin
                 asmname:=stringdup(readstring);
                 ref:=srsym;
              end;
            toasm:
              asmname:=stringdup(readstring);
            toaddr:
              address:=readlong;
         end;
      end;

    procedure tabsolutesym.write;

      begin
         ppufile.write_byte(ibabsolutesym);
         tsym.write;
         ppufile.write_byte(byte(varspez));
         if read_member then
           ppufile.write_long(address);
         writedefref(definition);
         ppufile.write_byte(byte(abstyp));
         case abstyp of
            tovar:
              writestring(ref^.name);
            toasm:
              writestring(asmname^);
            toaddr:
              ppufile.write_long(address);
         end;
      end;

    procedure tabsolutesym.deref;

      begin
         resolvedef(definition);
         if (abstyp=tovar) and (asmname<>nil) then
           begin
              { search previous loaded symtables }
              getsym(asmname^,false);
              if not(assigned(srsym)) then
                getsymonlyin(owner,asmname^);
              if not(assigned(srsym)) then
                srsym:=generrorsym;
              ref:=srsym;
              stringdispose(asmname);
           end;
      end;

    function tabsolutesym.mangledname : string;

      begin
         case abstyp of
           tovar:
             mangledname:=ref^.mangledname;
           toasm:
             mangledname:=asmname^;
           toaddr:
             mangledname:='$'+tostr(address);
         else
           internalerror(10002);
         end;
      end;

{$ifdef GDB}
    procedure tabsolutesym.concatstabto(asmlist : paasmoutput);

      begin
      { I don't know how to handle this !! }
      end;

{$endif GDB}
{**************************************
               TVARSYM
 **************************************}

    constructor tvarsym.init(const n : string;p : pdef);

      begin
         tsym.init(n);
         typ:=varsym;
         definition:=p;
         varspez:=vs_value;
         address:=0;
         refs:=0;
         is_valid := 1;
         { can we load the value into a register ? }
         case p^.deftype of
            pointerdef,enumdef,procvardef : regable:=true;
            orddef : case porddef(p)^.typ of
                          u8bit,s32bit,bool8bit,uchar,
                          s8bit,s16bit,u16bit,u32bit : regable:=true;
                          else regable:=false;
                       end;
            else regable:=false;
         end;
         reg:=R_NO;
      end;

    constructor tvarsym.load;

      begin
         tsym.load;
         typ:=varsym;
         varspez:=tvarspez(readbyte);
         if read_member then
           address:=readlong
         else address:=0;
         definition:=readdefref;
         refs := 0;
         is_valid := 1;
         { symbols which are load are never candidates for a register }
         regable:=false;
         reg:=R_NO;
      end;

    procedure tvarsym.deref;

      begin
         resolvedef(definition);
      end;

    procedure tvarsym.write;

      begin
         ppufile.write_byte(ibvarsym);
         tsym.write;
         ppufile.write_byte(byte(varspez));

         if read_member then
           ppufile.write_long(address);

         writedefref(definition);
      end;

    function tvarsym.mangledname : string;

      var prefix : string;
      begin
         case owner^.symtabletype of
{$ifndef MAKELIB}
           staticsymtable : prefix:='_';
{$else MAKELIB}
           staticsymtable : prefix:='_'+owner^.name^+'$$$_';
{$endif MAKELIB}
           unitsymtable,globalsymtable : prefix:='U_'+owner^.name^+'_';
           else
             begin
                { static data filed are converted in parser.pas to
                  a global variable }
                Message(sym_e_invalid_call_tvarsymmangledname);
             end;
           end;
         mangledname:=prefix+name;
      end;

{$ifdef GDB}
    function tvarsym.stabstring : pchar;

    var st : char;

    begin
       if (owner^.symtabletype = objectsymtable) and
          ((properties and sp_static)<>0) then
         begin
            if use_gsym then st := 'G' else st := 'S';
            stabstring := strpnew('"'+owner^.name^+'__'+name+':'+
                     +definition^.numberstring+'",'+
                     tostr(N_LCSYM)+',0,'+tostr(line_no)+','+mangledname);
         end
       else if (owner^.symtabletype = globalsymtable) or
          (owner^.symtabletype = unitsymtable) then
         begin
            { Here we used S instead of
              because with G GDB doesn't look at the address field
              but searches the same name or with a leading underscore
              but these names don't exist in pascal !}
            if use_gsym then st := 'G' else st := 'S';
            stabstring := strpnew('"'+name+':'+st
                     +definition^.numberstring+'",'+
                     tostr(N_LCSYM)+',0,'+tostr(line_no)+','+mangledname);
         end
       else if owner^.symtabletype = staticsymtable then
         begin
            stabstring := strpnew('"'+name+':S'
                  +definition^.numberstring+'",'+
                  tostr(N_LCSYM)+',0,'+tostr(line_no)+','+mangledname);
         end
       else if (owner^.symtabletype=parasymtable) then
         begin
            case varspez of
               vs_value : st := 'p';
               vs_var   : st := 'v';
               vs_const : st := 'v';{ should be 'i' but 'i' doesn't work }
              end;
            stabstring := strpnew('"'+name+':'+st
                  +definition^.numberstring+'",'+
                  tostr(N_PSYM)+',0,'+tostr(line_no)+','+tostr(address+owner^.call_offset))
                  {offset to ebp => will not work if the framepointer is esp
                  so some optimizing will make things harder to debug }
         end
       else if (owner^.symtabletype=localsymtable) then
   {$ifdef i386}
         if reg<>R_NO then
           begin
              { "eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi", "eip", "ps", "cs", "ss", "ds", "es", "fs", "gs", }
              { this is the register order for GDB }
              stabstring:=strpnew('"'+name+':r'
                        +definition^.numberstring+'",'+
                        tostr(N_RSYM)+',0,'+tostr(line_no)+','+tostr(GDB_i386index[reg]));
           end
         else
   {$endif i386}
           stabstring := strpnew('"'+name+':'
                  +definition^.numberstring+'",'+
                  tostr(N_LSYM)+',0,'+tostr(line_no)+',-'+tostr(address))
       else
         stabstring := inherited stabstring;
  end;

    procedure tvarsym.concatstabto(asmlist : paasmoutput);
      var stab_str : pchar;
      begin
         inherited concatstabto(asmlist);
{$ifdef i386}
      if (owner^.symtabletype=parasymtable) and
         (reg<>R_NO) then
           begin
           { "eax", "ecx", "edx", "ebx", "esp", "ebp", "esi", "edi", "eip", "ps", "cs", "ss", "ds", "es", "fs", "gs", }
           { this is the register order for GDB }
              stab_str:=strpnew('"'+name+':r'
                     +definition^.numberstring+'",'+
                     tostr(N_RSYM)+',0,'+tostr(line_no)+','+tostr(GDB_i386index[reg]));
              asmlist^.concat(new(pai_stabs,init(stab_str)));
           end;
{$endif i386}
      end;

{$endif GDB}
    function tvarsym.getsize : longint;

      begin
         { only if the definition is set, we could determine the   }
         { size, this is if an error occurs while reading the type }
         { also used for operator, this allows not to allocate the }
         { return size twice                                       }
         if assigned(definition) then
           begin
              case varspez of
                 vs_value : getsize:=definition^.size;
                 vs_var : getsize:=4;
                 vs_const : begin
                               if (definition^.deftype=stringdef) or
                                  (definition^.deftype=arraydef) or
                                  (definition^.deftype=recorddef) or
                                  (definition^.deftype=objectdef) or
                                  (definition^.deftype=setdef) then
                                  getsize:=4
                                else
                                  getsize:=definition^.size;
                            end;
              end;
           end
         else
           getsize:=0;
      end;

{**************************************
               TTYPEDCONSTSYM
 **************************************}

    constructor ttypedconstsym.init(const n : string;p : pdef);

      begin
         tsym.init(n);
         typ:=typedconstsym;
         definition:=p;
         prefix:=stringdup(procprefix);
      end;

    constructor ttypedconstsym.load;

      begin
         tsym.load;
         typ:=typedconstsym;
         definition:=readdefref;
         prefix:=stringdup(readstring);
      end;

    destructor ttypedconstsym.done;

      begin
         stringdispose(prefix);
         tsym.done;
      end;

    function ttypedconstsym.mangledname : string;

      begin
         mangledname:='TC_'+prefix^+'_'+name;
      end;

    procedure ttypedconstsym.deref;

      begin
         resolvedef(definition);
      end;

    procedure ttypedconstsym.write;

      begin
         ppufile.write_byte(ibtypedconstsym);
         tsym.write;
         writedefref(definition);
         writestring(prefix^);
      end;

{$ifdef GDB}
    function ttypedconstsym.stabstring : pchar;
    var st : char;
    begin
    if use_gsym and ((owner^.symtabletype = unitsymtable)
      or (owner^.symtabletype = globalsymtable)) then
       st := 'G' else st := 'S';
    stabstring := strpnew('"'+name+':'+st
            +definition^.numberstring+'",'+tostr(n_STSYM)+',0,'+tostr(line_no)+','+mangledname);
    end;
{$endif GDB}

{**************************************
               TCONSTSYM
 **************************************}

    constructor tconstsym.init(const n : string;t : tconsttype;v : longint;def : pdef);

      begin
         tsym.init(n);
         typ:=constsym;
         definition:=def;
         consttype:=t;
         value:=v;
      end;

    constructor tconstsym.load;

      var
         pd : pdouble;
         ps : pointer;  {***SETCONST}

      begin
         tsym.load;
         typ:=constsym;
         consttype:=tconsttype(readbyte);
         case consttype of
            constint,
            constbool,
            constchar : value:=readlong;
            constord : begin
                          definition:=readdefref;
                          value:=readlong;
                       end;
            conststring : value:=longint(stringdup(readstring));
            constreal : begin
                           new(pd);
                           pd^:=readdouble;
                           value:=longint(pd);
                        end;
{***SETCONST}
            constseta : begin
                           getmem(ps,32);
                           readset(ps^);
                           value:=longint(ps);
                       end;
{***}
         else Message1(unit_f_ppu_invalid_entry,tostr(ord(consttype)));
         end;
      end;

{$ifdef GDB}
    destructor tconstsym.done;
      begin
      if consttype = conststring then stringdispose(pstring(value));
      inherited done;
      end;
{$endif GDB}

    function tconstsym.mangledname : string;

      begin
         mangledname:=name;
      end;

    procedure tconstsym.deref;

      begin
         if consttype=constord then
           resolvedef(pdef(definition));
      end;

    procedure tconstsym.write;

      begin
         ppufile.write_byte(ibconstsym);
         tsym.write;
         ppufile.write_byte(byte(consttype));
         case consttype of
            constint,
            constbool,
            constchar : ppufile.write_long(value);
            constord : begin
                          writedefref(definition);
                          ppufile.write_long(value);
                       end;
            conststring : writestring(pstring(value)^);
            constreal : ppufile.write_double(pdouble(value)^);
{***SETCONST}
            constseta: writeset(pointer(value)^);
{***}
            else internalerror(13);
         end;
      end;

{$ifdef GDB}
    function tconstsym.stabstring : pchar;
    var st : string;
    begin
         {even GDB v4.16 only now 'i' 'r' and 'e' !!!}
         case consttype of
            conststring : begin
                          { I had to remove ibm2ascii !! }
                          st := pstring(value)^;
                          {st := ibm2ascii(pstring(value)^);}
                          st := 's'''+st+'''';
                          end;
            constbool, constint, constord, constchar : st := 'i'+tostr(value);
            constreal : begin
                        system.str(pdouble(value)^,st);
                        st := 'r'+st;
                        end;
         { if we don't know just put zero !! }
         else st:='i0';
            {***SETCONST}
            {constset:;}    {*** I don't know what to do with a set.}
         { sets are not recognized by GDB }
            {***}
        end;
    stabstring := strpnew('"'+name+':c='+st+'",'+tostr(N_function)+',0,'+tostr(line_no)+',0');
    end;

    procedure tconstsym.concatstabto(asmlist : paasmoutput);

      begin
          if consttype <> conststring then inherited concatstabto(asmlist);
      end;

{$endif GDB}

{**************************************
               tenumsym
 **************************************}

    constructor tenumsym.init(const n : string;def : penumdef;v : longint);
      begin
         tsym.init(n);
         typ:=enumsym;
         definition:=def;
         value:=v;
{$ifdef GDB}
         order;
{$endif GDB}
      end;

    constructor tenumsym.load;

      begin
         tsym.load;
         typ:=enumsym;
         definition:=penumdef(readdefref);
         value:=readlong;
{$ifdef GDB}
         next := Nil;
{$endif GDB}
      end;

    procedure tenumsym.deref;

      begin
         resolvedef(pdef(definition));
{$ifdef GDB}
         order;
{$endif}
      end;

{$ifdef GDB}
         procedure tenumsym.order;
         var sym : penumsym;
         begin
         sym := definition^.first;
         if sym = nil then
           begin
           definition^.first := @self;
           next := nil;
           exit;
           end;
         {reorder the symbols in increasing value }
         if value < sym^.value then
           begin
           next := sym;
           definition^.first := @self;
           end else
           begin
           while (sym^.value <= value) and assigned(sym^.next) do
             sym := sym^.next;
           next := sym^.next;
           sym^.next := @self;
           end;
         end;
{$endif GDB}

    procedure tenumsym.write;

      begin
         ppufile.write_byte(ibaufzaehlsym);
         tsym.write;
         writedefref(definition);
         ppufile.write_long(value);
      end;

{$ifdef GDB}
    procedure tenumsym.concatstabto(asmlist : paasmoutput);
    begin
    {enum elements have no stab !}
    end;
{$EndIf GDB}

{**************************************
               TTYPESYM
 **************************************}

    constructor ttypesym.init(const n : string;d : pdef);

      begin
         tsym.init(n);
         typ:=typesym;
         definition:=d;
         forwardpointer:=nil;
         { this allows to link definitions with the type with declares }
         { them                                                        }
         if assigned(definition) then
           if definition^.sym=nil then
             definition^.sym:=@self;
      end;

    constructor ttypesym.load;

      begin
         tsym.load;
         typ:=typesym;
         forwardpointer:=nil;
         definition:=readdefref;
      end;

    destructor ttypesym.done;

      begin
         if assigned(definition) then
           if definition^.sym=@self then
             definition^.sym:=nil;
         inherited done;
      end;

    procedure ttypesym.deref;

      begin
         resolvedef(definition);
         if assigned(definition) then
           if definition^.sym=nil then
             definition^.sym:=@self;
      end;

    procedure ttypesym.write;

      begin
         ppufile.write_byte(ibtypesym);
         tsym.write;
         writedefref(definition);
      end;

{$ifdef GDB}
    function ttypesym.stabstring : pchar;
    var stabchar : string[2];
        short : string;
    begin
      if definition^.deftype in tagtypes then
        stabchar := 'Tt'
        else stabchar := 't';
    short := '"'+name+':'+stabchar+definition^.numberstring
               +'",'+tostr(N_LSYM)+',0,'+tostr(line_no)+',0';
    stabstring := strpnew(short);
    end;

    procedure ttypesym.concatstabto(asmlist : paasmoutput);
      begin
      {not stabs for forward defs }
      if assigned(definition) then
        if (definition^.sym = @self) then
        definition^.concatstabto(asmlist)
        else
        begin
        inherited concatstabto(asmlist);
        end;
      end;

{$endif GDB}

{**************************************
               TPROCSYM
 **************************************}

    procedure tprocsym.write;

      begin
         ppufile.write_byte(ibprocsym);
         tsym.write;
         writedefref(pdef(definition));
      end;

{$ifdef GDB}
    function tprocsym.stabstring : pchar;
     Var RetType : Char;
         Obj,Info : String;
    begin
      obj := name;
      info := '';
      if is_global then
       RetType := 'F'
      else
       RetType := 'f';
     if assigned(owner) then
      begin
        if (owner^.symtabletype = objectsymtable) then
         obj := owner^.name^+'__'+name;
        if (owner^.symtabletype=localsymtable) and assigned(owner^.name) then
         info := ','+name+','+owner^.name^;
      end;
     stabstring :=strpnew('"'+obj+':'+RetType
           +definition^.retdef^.numberstring+info+'",'+tostr(n_function)
           +',0,'+tostr(current_module^.current_inputfile^.line_no)
           +','+definition^.mangledname);
    end;

    procedure tprocsym.concatstabto(asmlist : paasmoutput);
    begin
    if (definition^.options and pointernproc) <> 0 then exit;
    if not isstabwritten then
      asmlist^.concat(new(pai_stabs,init(stabstring)));
    isstabwritten := true;
    if assigned(definition^.parast) then
      definition^.parast^.concatstabto(asmlist);
    if assigned(definition^.localst) then
      definition^.localst^.concatstabto(asmlist);
    definition^.isstabwritten := true;
    end;

{$endif GDB}
{**************************************
               TSYSSYM
 **************************************}

    constructor tsyssym.init(const n : string;l : longint);

      begin
         inherited init(n);
         typ:=syssym;
         number:=l;
      end;

    procedure tsyssym.write;

      begin
      end;

{$ifdef GDB}
    procedure tsyssym.concatstabto(asmlist : paasmoutput);

      begin
      end;

{$endif GDB}
{**************************************
               TMACROSYM
 **************************************}

    constructor tmacrosym.init(const n : string);

      begin
         inherited init(n);
         defined:=true;
         buftext:=nil;
         buflen:=0;
      end;

    destructor tmacrosym.done;

      begin
         if assigned(buftext) then
           freemem(buftext,buflen);
         inherited done;
      end;

    procedure maybe_concat_external(symt : psymtable;const name : string);

      begin
         if (symt^.symtabletype=unitsymtable) or
            ((symt^.symtabletype=objectsymtable) and
            (symt^.defowner^.owner^.symtabletype=unitsymtable)) then
           concat_external(name,EXT_NEAR);
      end;

    function globaldef(const s : string) : pdef;

      var st : string;
          symt : psymtable;
      begin
         srsym := nil;
         if pos('.',s) > 0 then
           begin
           st := copy(s,1,pos('.',s)-1);
           getsym(st,false);
           st := copy(s,pos('.',s)+1,255);
           if assigned(srsym) then
             begin
             if srsym^.typ = unitsym then
               begin
               symt := punitsym(srsym)^.unitsymtable;
               srsym := symt^.search(st);
               end else srsym := nil;
             end;
           end else st := s;
         if srsym = nil then getsym(st,false);
         if srsym = nil then
           getsymonlyin(systemunit,st);
         if srsym^.typ<>typesym then
           begin
             Message(sym_e_type_id_expected);
             exit;
           end;
         globaldef := ptypesym(srsym)^.definition;
      end;

{$ifdef GDB}
    function typeglobalnumber(const s : string) : string;

      var st : string;
          symt : psymtable;
      begin
         typeglobalnumber := '0';
         srsym := nil;
         if pos('.',s) > 0 then
           begin
           st := copy(s,1,pos('.',s)-1);
           getsym(st,false);
           st := copy(s,pos('.',s)+1,255);
           if assigned(srsym) then
             begin
             if srsym^.typ = unitsym then
               begin
               symt := punitsym(srsym)^.unitsymtable;
               srsym := symt^.search(st);
               end else srsym := nil;
             end;
           end else st := s;
         if srsym = nil then getsym(st,true);
         if srsym^.typ<>typesym then
           begin
             Message(sym_e_type_id_expected);
             exit;
           end;
         typeglobalnumber := ptypesym(srsym)^.definition^.numberstring;
      end;
{$endif GDB}

{**************************************
                  TDEF
 **************************************}


{ base class for type definitions }

    constructor tdef.init;

      begin
         deftype:=abstractdef;
{$ifdef GDB}
         owner := nil;
         next := nil;
         number := 0;
         globalnb := 0;
{$endif GDB}
         if registerdef then symtablestack^.registerdef(@self);
{$ifdef GDB}
         isstabwritten := false;
         if assigned(lastglobaldef) then
           lastglobaldef^.nextglobal := @self
           else firstglobaldef := @self;
         lastglobaldef := @self;
         nextglobal := nil;
         sym := nil;
{$endif GDB}
      end;

{$ifdef GDB}
    constructor tdef.load;
      begin
         deftype:=abstractdef;
         isstabwritten := false;
         number := 0;
         if assigned(lastglobaldef) then
           lastglobaldef^.nextglobal := @self
           else firstglobaldef := @self;
         lastglobaldef := @self;
         nextglobal := nil;
         sym := nil;
         owner := nil;
         next := nil;
      end;

   procedure tdef.set_globalnb;
     begin
         globalnb :=PGlobalTypeCount^;
         inc(PglobalTypeCount^);
     end;
{$endif GDB}
    function tdef.size : longint;

      begin
         size:=savesize;
      end;

    procedure tdef.write;

      begin
{$ifdef GDB }
      if globalnb = 0 then
        begin
        if assigned(owner) then
          globalnb := owner^.getnewtypecount
        else
          begin
          globalnb := PGlobalTypeCount^;
          Inc(PGlobalTypeCount^);
          end;
        end;
{$endif GDB }
      end;

{$ifdef GDB}
    function tdef.stabstring : pchar;

      begin
      stabstring := strpnew('t'+numberstring+';');
      end;

    function tdef.numberstring : string;
      var table : psymtable;
      begin
      {formal def have no type !}
      if deftype = formaldef then
        begin
        numberstring := voiddef^.numberstring;
        exit;
        end;
      if not assigned(sym) or not(sym^.isusedinstab) then
        begin
           {set even if debuglist is not defined}
           if assigned(sym) and (sym^.typ=typesym) then
             sym^.isusedinstab := true;
           if assigned(debuglist) and not isstabwritten then
             concatstabto(debuglist);
        end;
      if not use_dbx then
        begin
           if globalnb = 0 then
             set_globalnb;
           numberstring := tostr(globalnb);
        end
      else
        begin
           if globalnb = 0 then
             begin
                if assigned(owner) then
                  globalnb := owner^.getnewtypecount
                else
                  begin
                     globalnb := PGlobalTypeCount^;
                     Inc(PGlobalTypeCount^);
                  end;
             end;
           if assigned(sym) then
             begin
                table := sym^.owner;
                if table^.unitid > 0 then
                  numberstring := '('+tostr(table^.unitid)+','+tostr(sym^.definition^.globalnb)+')'
                else
                  numberstring := tostr(globalnb);
                exit;
             end;
           numberstring := tostr(globalnb);
        end;
      end;

    function tdef.allstabstring : pchar;
    var stabchar : string[2];
        ss,st : pchar;
        name : string;
        sym_line_no : longint;
      begin
      ss := stabstring;
      getmem(st,strlen(ss)+512);
      stabchar := 't';
      if deftype in tagtypes then
        stabchar := 'Tt';
      if assigned(sym) then
        begin
           name := sym^.name;
           sym_line_no:=sym^.line_no;
        end
      else
        begin
           name := ' ';
           sym_line_no:=0;
        end;
      strpcopy(st,'"'+name+':'+stabchar+numberstring+'=');
      strpcopy(strecopy(strend(st),ss),'",'+tostr(N_LSYM)+',0,'+tostr(sym_line_no)+',0');
      allstabstring := strnew(st);
      freemem(st,strlen(ss)+512);
      strdispose(ss);
      end;


    procedure tdef.concatstabto(asmlist : paasmoutput);
     var stab_str : pchar;
    begin
    if ((sym = nil) or sym^.isusedinstab or use_dbx)
      and not isstabwritten then
      begin
      If use_dbx then
        begin
           { otherwise you get two of each def }
           If assigned(sym) then
             begin
                if sym^.typ=typesym then
                  sym^.isusedinstab:=true;
                if (sym^.owner = nil) or
                  ((sym^.owner^.symtabletype = unitsymtable) and
                 punitsymtable(sym^.owner)^.dbx_count_ok)  then
                begin
                   {with DBX we get the definition from the other objects }
                   isstabwritten := true;
                   exit;
                end;
             end;
        end;
      { to avoid infinite loops }
      isstabwritten := true;
      stab_str := allstabstring;
      if asmlist = debuglist then do_count_dbx := true;
      { count_dbx(stab_str); moved to GDB.PAS}
      asmlist^.concat(new(pai_stabs,init(stab_str)));
      end;
    end;

{$endif GDB}
    procedure tdef.deref;

      begin
      end;

    destructor tdef.done;
{$ifdef debug}
    var prev : pdef;
{$endif debug}

{$ifndef GDB}

{$else GDB}
      var pd : pdef;
      begin
      pd := firstglobaldef;
      if pd = @self then firstglobaldef := pd^.nextglobal
        else while assigned(pd) do
{$endif GDB}
      begin
{$ifdef GDB}
         if pd^.nextglobal = @Self then
           begin
              pd^.nextglobal := pd^.nextglobal^.nextglobal;
              if pd^.nextglobal = nil then
                lastglobaldef := pd;
              break;
           end;
{$ifdef debug}
         prev:=pd;
{$endif debug}
         pd := pd^.nextglobal;
      end;
{$endif GDB}
      end;

{**************************************
              TSTRINGDEF
 **************************************}

    constructor tstringdef.init(l : byte);

      begin
         tdef.init;
         string_typ:=shortstring;
         deftype:=stringdef;
         len:=l;
         savesize:=len+1;
      end;

    constructor tstringdef.load;

      begin
{$ifdef GDB}
         tdef.load;
         string_typ:=shortstring;
         set_globalnb;
{$endif GDB}
         deftype:=stringdef;
         len:=readbyte;
         savesize:=len+1;
      end;

{$ifdef UseLongString}
    constructor tstringdef.longinit(l : longint);

      begin
         tdef.init;
         string_typ:=longstring;
         deftype:=stringdef;
         len:=l;
         savesize:=len+5;
      end;

    constructor tstringdef.longload;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=stringdef;
         string_typ:=longstring;
         len:=readlong;
         savesize:=len+5;
      end;
{$endif UseLongString}

{$ifdef UseAnsiString}
    constructor tstringdef.ansiinit(l : longint);

      begin
         tdef.init;
         string_typ:=ansistring;
         deftype:=stringdef;
         len:=l;
         savesize:=len+13;
      end;

    constructor tstringdef.ansiload;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=stringdef;
         string_typ:=ansistring;
         len:=readlong;
         savesize:=len+13;
      end;
{$endif UseAnsiString}

    function tstringdef.size : longint;

      begin
           size:=len+1;
      end;

    procedure tstringdef.write;

      begin
         case string_typ of
           shortstring : ppufile.write_byte(ibstringdef);
{$ifdef UseLongString}
           longstring : ppufile.write_byte(iblongstringdef);
{$endif UseLongString}
{$ifdef UseAnsiString}
           ansistring : ppufile.write_byte(ibansistringdef);
{$endif UseAnsiString}
         end;
         tdef.write;
         if string_typ=shortstring then
           ppufile.write_byte(len)
         else
           ppufile.write_long(len);
      end;

{$ifdef GDB}
    function tstringdef.stabstring : pchar;

      var bytest,charst,longst : string;

      begin
         if string_typ=shortstring then
           begin
              charst := typeglobalnumber('char');
              { this is what I found in stabs.texinfo but
              gdb 4.12 for go32 doesn't understand that !! }
              {$IfDef GDBknowsstrings}
              stabstring := strpnew('n'+charst+';'+tostr(len));
              {$else}
              bytest := typeglobalnumber('byte');
              stabstring := strpnew('s'+tostr(len+1)+'length:'+bytest
                +',0,8;st:ar'+bytest
                +';1;'+tostr(len)+';'+charst+',8,'+tostr(len*8)+';;');
              {$EndIf}
           end
{$ifdef UseLongString}
         else if string_typ=longstring then
           begin
              charst := typeglobalnumber('char');
              { this is what I found in stabs.texinfo but
              gdb 4.12 for go32 doesn't understand that !! }
              {$IfDef GDBknowsstrings}
              stabstring := strpnew('n'+charst+';'+tostr(len));
              {$else}
              bytest := typeglobalnumber('byte');
              longst := typeglobalnumber('longint');
              stabstring := strpnew('s'+tostr(len+5)+'length:'+longst
                            +',0,32;dummy:'+bytest+',32,8;st:ar'+bytest
                            +';1;'+tostr(len)+';'+charst+',40,'+tostr(len*8)+';;');
              {$EndIf}
           end
{$endif UseLongString}
{$ifdef UseAnsiString}
         else if string_typ=ansistring then
           begin
              { an ansi string looks like a pchar easy !! }
              stabstring:=strpnew('*'+typeglobalnumber('char'));
           end
{$endif UseAnsiString}
    end;

    procedure tstringdef.concatstabto(asmlist : paasmoutput);
      begin
        inherited concatstabto(asmlist);
      end;
{$endif GDB}

{**************************************
             tenumdef
 **************************************}

    constructor tenumdef.init;

      begin
         tdef.init;
         deftype:=enumdef;
         max:=0;
         savesize:=4;
         has_jumps:=false;
{$ifdef GDB}
         first := Nil;
{$endif GDB}
      end;

    constructor tenumdef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=enumdef;
         max:=readlong;
         savesize:=4;
         has_jumps:=false;
         first := Nil;
      end;

    destructor tenumdef.done;
      begin
      inherited done;
      end;

    procedure tenumdef.write;

      begin
         ppufile.write_byte(ibenumdef);
         tdef.write;
         ppufile.write_long(max);
{$ifdef GDB}
      end;

    function tenumdef.stabstring : pchar;
      var st,st2 : pchar;
          p : penumsym;
          s : string;
          memsize : word;
      begin
      memsize := memsizeinc;
      getmem(st,memsize);
      strpcopy(st,'e');
      p := first;
      while assigned(p) do
        begin
        s :=p^.name+':'+tostr(p^.value)+',';
        { place for the ending ';' also }
        if (strlen(st)+length(s)+1<memsize) then
          strpcopy(strend(st),s)
          else
          begin
          getmem(st2,memsize+memsizeinc);
          strcopy(st2,st);
          freemem(st,memsize);
          st := st2;
          memsize := memsize+memsizeinc;
          strpcopy(strend(st),s);
          end;
        p := p^.next;
        end;
      strpcopy(strend(st),';');
      stabstring := strnew(st);
      freemem(st,memsize);
{$endif GDB}
      end;

{**************************************
               TORDDEF
 **************************************}

    constructor torddef.init(t : tbasetype;v,b : longint);

      begin
         tdef.init;
         deftype:=orddef;
         von:=v;
         bis:=b;
         typ:=t;
         setsize;
      end;

    constructor torddef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=orddef;
         typ:=tbasetype(readbyte);
         von:=readlong;
         bis:=readlong;
         rangenr:=0;
         setsize;
      end;

    procedure torddef.setsize;

      begin
         if typ=uauto then
           begin
              { generate a unsigned range if bis<0 and von>=0 }
              if (von>=0) and (bis<0) then
                begin
                   savesize:=4;
                   typ:=u32bit;
                end
              else if (von>=0) and (bis<=255) then
                begin
                   savesize:=1;
                   typ:=u8bit;
                end
              else if (von>=-128) and (bis<=127) then
                begin
                   savesize:=1;
                   typ:=s8bit;
                end
              else if (von>=0) and (bis<=65536) then
                begin
                   savesize:=2;
                   typ:=u16bit;
                end
              else if (von>=-32768) and (bis<=32767) then
                begin
                   savesize:=2;
                   typ:=s16bit;
                end
              else
                begin
                   savesize:=4;
                   typ:=s32bit;
                end;
           end
         else
           case typ of
              uchar,u8bit,bool8bit,s8bit : savesize:=1;
              u16bit,s16bit : savesize:=2;
              s32bit,u32bit : savesize:=4;
              else savesize:=0;
           end;

         { there are no entrys for range checking }
         rangenr:=0;
      end;

    procedure torddef.genrangecheck;

      var
         name : string;

      begin
         if rangenr=0 then
           begin
              { generate two constant for bounds }
              getlabelnr(rangenr);
{$ifndef MAKELIB}
              name:='R_'+tostr(rangenr);
{$else MAKELIB}
              name:='R_'+current_module^.mainsource^+tostr(rangenr);
{$endif MAKELIB}
              { if we are in the interface on a unit this must be global }
              { and the name must be unique }
{$ifndef MAKELIB}
              datasegment^.concat(new(pai_symbol,init(name)));
{$else MAKELIB}
              datasegment^.concat(new(pai_symbol,init_global(name)));
{$endif MAKELIB}
              if von<=bis then
                begin
                   datasegment^.concat(new(pai_const,init_32bit(von)));
                   datasegment^.concat(new(pai_const,init_32bit(bis)));
                end
              { for u32bit we need two bounds }
              else
                begin
                   datasegment^.concat(new(pai_const,init_32bit(von)));
                   datasegment^.concat(new(pai_const,init_32bit($7fffffff)));
                   inc(nextlabelnr);
{$ifndef MAKELIB}
                   name:='R_'+tostr(rangenr+1);
{$else MAKELIB}
                   name:='R_'+current_module^.unitname^+tostr(rangenr+1);
{$endif MAKELIB}
                   { if we are in the interface on a unit this must be global }
                   { and the name must be unique }
{$ifndef MAKELIB}
                   datasegment^.concat(new(pai_symbol,init(name)));
{$else MAKELIB}
                   datasegment^.concat(new(pai_symbol,init_global(name)));
{$endif MAKELIB}
                   datasegment^.concat(new(pai_const,init_32bit($80000000)));
                   datasegment^.concat(new(pai_const,init_32bit(bis)));
                end;
           end;
      end;

    procedure torddef.write;

      begin
         ppufile.write_byte(iborddef);
         tdef.write;
         ppufile.write_byte(byte(typ));
         ppufile.write_long(von);
         ppufile.write_long(bis);
      end;

{$ifdef GDB}
    function torddef.stabstring : pchar;

      begin
      case typ of
         uvoid : stabstring := strpnew(numberstring+';');
         {GDB 4.12 for go32 doesn't like boolean as range for 0 to 1 !!!}
         bool8bit : stabstring := strpnew('r'+numberstring+';0;255;');
         { u32bit : stabstring := strpnew('r'+
              s32bitdef^.numberstring+';0;-1;'); }
         else stabstring := strpnew('r'+s32bitdef^.numberstring+';'
                            +tostr(von)+';'+tostr(bis)+';');
         end;
      end;

{$endif GDB}

{**************************************
               TFLOATDEF
 **************************************}

    constructor tfloatdef.init(t : tfloattype);

      begin
         tdef.init;
         deftype:=floatdef;
         typ:=t;
         setsize;
      end;

    constructor tfloatdef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=floatdef;
         typ:=tfloattype(readbyte);
         setsize;
      end;

    procedure tfloatdef.setsize;

      begin
         case typ of
            f16bit:
              savesize:=2;
            f32bit,s32real:
              savesize:=4;
            s64real:
              savesize:=8;
            s64bit:
              savesize:=8;
            s80real:
              savesize:=extended_size;
            else savesize:=0;
         end;
      end;

    procedure tfloatdef.write;

      begin
         ppufile.write_byte(ibfloatdef);
         tdef.write;
         ppufile.write_byte(byte(typ));
      end;

{$ifdef GDB}
    function tfloatdef.stabstring : pchar;

      begin
         case typ of
            s32real,
            s64real : stabstring := strpnew('r'+
               s32bitdef^.numberstring+';'+tostr(savesize)+';0;');
            { for fixed real use longint instead to be able to }
            { debug something at least                         }
            f32bit:
              stabstring := s32bitdef^.stabstring;
            f16bit:
              stabstring := strpnew('r'+s32bitdef^.numberstring+';0;'+
                tostr($ffff)+';');
            { found this solution in stabsread.c from GDB v4.16 }
            s64bit : stabstring := strpnew('r'+
               s32bitdef^.numberstring+';-'+tostr(savesize)+';0;');
{$ifdef i386}
            { under dos at least you must give a size of twelve instead of 10 !! }
            { this is probably do to the fact that in gcc all is pushed in 4 bytes size }
            s80real : stabstring := strpnew('r'+
             s32bitdef^.numberstring+';12;0;');
{$endif i386}
            else
              internalerror(10005);
         end;
      end;

{$endif GDB}

{**************************************
               TFILEDEF
 **************************************}

    constructor tfiledef.init(ft : tfiletype;tas : pdef);

      begin
         inherited init;
         deftype:=filedef;
         filetype:=ft;
         typed_as:=tas;
         setsize;
      end;

    constructor tfiledef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=filedef;
         filetype:=tfiletype(readbyte);
         if filetype=ft_typed then
           typed_as:=readdefref
         else
           typed_as:=nil;
         setsize;
      end;

    procedure tfiledef.deref;

      begin
         if filetype=ft_typed then
           resolvedef(typed_as);
      end;

    procedure tfiledef.write;

      begin
         ppufile.write_byte(ibfiledef);
         tdef.write;
         ppufile.write_byte(byte(filetype));
         if filetype=ft_typed then
           writedefref(typed_as);
      end;

{$ifdef GDB}
    function tfiledef.stabstring : pchar;

      var namesize : longint;
      begin
      {$IfDef GDBknowsfiles}
      case filetyp of
        ft_typed : stabstring := strpnew('d'+typed_as^.numberstring{+';'});
        ft_untyped : stabstring := strpnew('d'+voiddef^.numberstring{+';'});
        ft_text : stabstring := strpnew('d'+cchardef^.numberstring{+';'});
        end;
      {$Else }
      {based on
       filerec = record
          handle : word;
          mode : word;
          recsize : word;
          _private : array[1..26] of byte;
          userdata : array[1..16] of byte;
          name : string[79 or 255 for linux]; }
      if target_info.target=target_LINUX then
        namesize:=255
      else
        namesize:=79;

      stabstring := strpnew('s'+tostr(savesize)+'HANDLE:'+typeglobalnumber('word')+',0,16;'+
                      'MODE:'+typeglobalnumber('word')+',16,16;'+
                      'RECSIZE:'+typeglobalnumber('word')+',32,16;'+
                      '_PRIVATE:ar'+typeglobalnumber('word')+';1;26;'+typeglobalnumber('byte')+',36,208;'+
                      'USERDATA:ar'+typeglobalnumber('word')+';1;16;'+typeglobalnumber('byte')+',256,128;'+
                      'NAME:s'+tostr(namesize+1)+
                        'length:'+typeglobalnumber('byte')+',0,8;'+
                        'st:ar'+typeglobalnumber('word')+';1;'
                        +tostr(namesize)+';'+typeglobalnumber('char')+',8,'+tostr(8*namesize)+';;'+
                      ',384,'+tostr(8*(namesize+1))+';;');
      {$EndIf}
      end;

    procedure tfiledef.concatstabto(asmlist : paasmoutput);

      begin
      { most file defs are unnamed !!! }
      if ((sym = nil) or sym^.isusedinstab or use_dbx) and not isstabwritten then
        begin
        if assigned(typed_as) then forcestabto(asmlist,typed_as);
        inherited concatstabto(asmlist);
        end;
      end;

{$endif GDB}
    procedure tfiledef.setsize;

      begin
         case target_info.target of
            target_LINUX:
           begin
              case filetype of
                 ft_text : savesize:=432;
                 ft_typed,ft_untyped : savesize:=304;
              end;
           end;
            target_Win32 , target_AMIGA, target_MAC68k:
              begin
                 case filetype of
                    ft_text : savesize:=434;
                    ft_typed,ft_untyped : savesize:=306;
                 end;
           end
         else
           begin { os/2, dos, atari tos }
              case filetype of
                 ft_text : savesize:=256;
                 ft_typed,ft_untyped : savesize:=128;
              end;
           end;
      end;
      end;

{**************************************
               TPOINTERDEF
 **************************************}

    constructor tpointerdef.init(def : pdef);

      begin
         inherited init;
         deftype:=pointerdef;
         definition:=def;
         savesize:=4;
      end;

    constructor tpointerdef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=pointerdef;
         { the real address in memory is calculated later (deref) }
         definition:=readdefref;
         savesize:=4;
      end;

    procedure tpointerdef.deref;

      begin
         resolvedef(definition);
      end;

    procedure tpointerdef.write;

      begin
         ppufile.write_byte(ibpointerdef);
         tdef.write;
         writedefref(definition);
      end;

{$ifdef GDB}
    function tpointerdef.stabstring : pchar;

      begin
      stabstring := strpnew('*'+definition^.numberstring);
      end;

    procedure tpointerdef.concatstabto(asmlist : paasmoutput);
      var st,nb : string;
          sym_line_no : longint;
      begin
      if ( (sym=nil) or sym^.isusedinstab or use_dbx) and not isstabwritten then
        begin
        if assigned(definition) then
          if definition^.deftype in [recorddef,objectdef] then
            begin
            isstabwritten := true;
            {to avoid infinite recursion in record with next-like fields }
            nb := definition^.numberstring;
            isstabwritten := false;
            if not definition^.isstabwritten then
              begin
              if assigned(definition^.sym) then
                begin
                if assigned(sym) then
                  begin
                     st := sym^.name;
                     sym_line_no:=sym^.line_no;
                  end
                else
                  begin
                     st := ' ';
                     sym_line_no:=0;
                  end;
                st := '"'+st+':t'+numberstring+'=*'+definition^.numberstring
                      +'=xs'+definition^.sym^.name+':",'+tostr(N_LSYM)+',0,'+tostr(sym_line_no)+',0';
                if asmlist = debuglist then do_count_dbx := true;
                asmlist^.concat(new(pai_stabs,init(strpnew(st))));
                end;
              end else inherited concatstabto(asmlist);
            isstabwritten := true;
            end else
            begin
            forcestabto(asmlist,definition);
            inherited concatstabto(asmlist);
            end;
        end;
      end;

{$endif GDB}

{**************************************
               TCLASSREFDEF
 **************************************}

    constructor tclassrefdef.init(def : pdef);

      begin
         inherited init(def);
         deftype:=classrefdef;
         definition:=def;
         savesize:=4;
      end;

    constructor tclassrefdef.load;

      begin
         inherited load;
         deftype:=classrefdef;
      end;

    procedure tclassrefdef.write;

      begin
         ppufile.write_byte(ibclassrefdef);
         tdef.write;
         writedefref(definition);
      end;

{$ifdef GDB}
    function tclassrefdef.stabstring : pchar;

      begin
         stabstring:=strpnew('');
      end;

    procedure tclassrefdef.concatstabto(asmlist : paasmoutput);

      begin
      end;

{$endif GDB}

{**************************************
               TSETDEF
 **************************************}

    constructor tsetdef.init(s : pdef;high : longint);

      begin
         inherited init;
         deftype:=setdef;
         setof:=s;
         if high<32 then
           begin
              settype:=smallset;
              savesize:=4;
           end
         else
         if high<256 then
           begin
              settype:=normset;
              savesize:=32;
           end
         else
{$ifdef testvarsets}
         if high<$10000 then
           begin
              settype:=varset;
              savesize:=4*((high+31) div 32);
           end
         else
{$endif testvarsets}
          Message(sym_e_ill_type_decl_set);
      end;

    constructor tsetdef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=setdef;
         setof:=readdefref;
         settype:=tsettype(readbyte);
         case settype of
            normset : savesize:=32;
            varset : savesize:=readlong;
            smallset : savesize:=4;
         end;
      end;

    procedure tsetdef.write;

      begin
         ppufile.write_byte(ibsetdef);
         tdef.write;
         writedefref(setof);
         ppufile.write_byte(byte(settype));
         if settype=varset then
           ppufile.write_long(savesize);
      end;

{$ifdef GDB}
    function tsetdef.stabstring : pchar;

      begin
         stabstring := strpnew('S'+setof^.numberstring);
      end;

    procedure tsetdef.concatstabto(asmlist : paasmoutput);

      begin
      if ( not assigned(sym) or sym^.isusedinstab or use_dbx)
 and not isstabwritten then
        begin
        if assigned(setof) then forcestabto(asmlist,setof);
        inherited concatstabto(asmlist);
        end;
      end;

{$endif GDB}
    procedure tsetdef.deref;

      begin
         resolvedef(setof);
      end;

{**************************************
               TFORMALDEF
 **************************************}

    constructor tformaldef.init;

      begin
         inherited init;
         deftype:=formaldef;
         savesize:=4;
      end;

    constructor tformaldef.load;

      begin
{$ifdef GDB}
         tdef.load;
{$endif GDB}
         deftype:=formaldef;
         savesize:=4;
      end;

    procedure tformaldef.write;

      begin
         ppufile.write_byte(ibformaldef);
         tdef.write;
      end;

{$ifdef GDB}
    function tformaldef.stabstring : pchar;

      begin
      stabstring := strpnew('formal'+numberstring+';');
      end;


    procedure tformaldef.concatstabto(asmlist : paasmoutput);

      begin
      { formaldef can't be stab'ed !}
      end;
{$endif GDB}

{**************************************
               TARRAYDEF
 **************************************}

    constructor tarraydef.init(l,h : longint;rd : pdef);

      begin
         tdef.init;
         deftype:=arraydef;
         lowrange:=l;
         highrange:=h;
         rangedef:=rd;
         rangenr:=0;
         definition:=nil;
      end;

    constructor tarraydef.load;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=arraydef;
         { die Adressen werden spÑter berechnet }
         definition:=readdefref;
         rangedef:=readdefref;
         lowrange:=readlong;
         highrange:=readlong;
         rangenr:=0;
      end;

    procedure tarraydef.genrangecheck;

      begin
         if rangenr=0 then
           begin
              { generates the data for range checking }
              getlabelnr(rangenr);
              datasegment^.concat(new(pai_symbol,init('R_'+tostr(rangenr))));
              datasegment^.concat(new(pai_const,init_32bit(lowrange)));
              datasegment^.concat(new(pai_const,init_32bit(highrange)));
           end;
      end;

    procedure tarraydef.deref;

      begin
         resolvedef(definition);
         resolvedef(rangedef);
      end;

    procedure tarraydef.write;

      begin
         ppufile.write_byte(ibarraydef);
         tdef.write;
         writedefref(definition);
         writedefref(rangedef);
         ppufile.write_long(lowrange);
         ppufile.write_long(highrange);
      end;

{$ifdef GDB}
    function tarraydef.stabstring : pchar;
      begin
      stabstring := strpnew('ar'+rangedef^.numberstring+';'
                    +tostr(lowrange)+';'+tostr(highrange)+';'+definition^.numberstring);
      end;

    procedure tarraydef.concatstabto(asmlist : paasmoutput);

      begin
      if (not assigned(sym) or sym^.isusedinstab or use_dbx)
        and not isstabwritten then
        begin
        {when array are inserted they have no definition yet !!}
        if assigned(definition) then
          inherited concatstabto(asmlist);
        end;
      end;

{$endif GDB}
    function tarraydef.elesize : longint;

      begin
         elesize:=definition^.size;
      end;

    function tarraydef.size : longint;

      begin
         size:=(highrange-lowrange+1)*elesize;
      end;

{**************************************
               TRECDEF
 **************************************}

    constructor trecdef.init(p : psymtable);

      begin
         tdef.init;
         deftype:=recorddef;
         symtable:=p;
         savesize:=symtable^.datasize;
         symtable^.defowner := @self;
      end;

    constructor trecdef.load;

      var
         oldread_member : boolean;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=recorddef;
         savesize:=readlong;
         oldread_member:=read_member;
         read_member:=true;
         symtable:=new(psymtable,loadasstruct(recordsymtable));
         read_member:=oldread_member;
         symtable^.defowner := @self;
      end;

    destructor trecdef.done;

      begin
{$ifndef GDB}
         dispose(symtable);
{$else GDB}
         if assigned(symtable) then dispose(symtable,done);
         inherited done;
{$endif GDB}
      end;

    procedure trecdef.deref;

      var
         hp : pdef;
         oldrecsyms : psymtable;

      begin
         oldrecsyms:=aktrecordsymtable;
         aktrecordsymtable:=symtable;
         { now dereference the definitions }
         hp:=symtable^.wurzeldef;
         while assigned(hp) do
           begin
              hp^.deref;

              { set owner }
              hp^.owner:=symtable;

              hp:=hp^.next;
           end;
{$ifdef tp}
         symtable^.foreach(derefsym);
{$else}
         symtable^.foreach(@derefsym);
{$endif}
         aktrecordsymtable:=oldrecsyms;
      end;

    procedure trecdef.write;

      var
         oldread_member : boolean;

      begin
         oldread_member:=read_member;
         read_member:=true;
         ppufile.write_byte(ibrecorddef);
         tdef.write;
         ppufile.write_long(savesize);
         self.symtable^.writeasstruct;
         read_member:=oldread_member;
      end;

{$ifdef GDB}

      Const StabRecString : pchar = Nil;
            StabRecSize : longint = 0;
          RecOffset : Longint = 0;

    procedure addname(p : psym);

      var news, newrec : pchar;
    begin
    { static variables from objects are like global objects }
    if ((p^.properties and sp_static)<>0) then
      exit;
    If p^.typ = varsym then
       begin
       newrec := strpnew(p^.name+':'+pvarsym(p)^.definition^.numberstring
                     +','+tostr(pvarsym(p)^.address*8)+','
                     +tostr(pvarsym(p)^.definition^.size*8)+';');
       if strlen(StabRecString) + strlen(newrec) >= StabRecSize-256 then
         begin
            getmem(news,stabrecsize+memsizeinc);
            strcopy(news,stabrecstring);
            freemem(stabrecstring,stabrecsize);
            stabrecsize:=stabrecsize+memsizeinc;
            stabrecstring:=news;
         end;
       strcat(StabRecstring,newrec);
       strdispose(newrec);
       {This should be used for case !!}
       RecOffset := RecOffset + pvarsym(p)^.definition^.size;
       end;
    end;

    function trecdef.stabstring : pchar;
      Var oldrec : pchar;
          oldsize : longint;


      begin
      oldrec := stabrecstring;
      oldsize:=stabrecsize;
      GetMem(stabrecstring,memsizeinc);
      stabrecsize:=memsizeinc;
      strpcopy(stabRecString,'s'+tostr(savesize));
      RecOffset := 0;
{$ifdef tp}
      symtable^.foreach(addname);
{$else}
      symtable^.foreach(@addname);
{$endif}
      { FPC doesn't want to convert a char to a pchar}
      { is this a bug ? }
      strpcopy(strend(StabRecString),';');
      stabstring := strnew(StabRecString);
      Freemem(stabrecstring,stabrecsize);
      stabrecstring := oldrec;
      stabrecsize:=oldsize;
      end;

    procedure trecdef.concatstabto(asmlist : paasmoutput);

      begin
      if ( not assigned(sym) or sym^.isusedinstab or use_dbx)
      and not isstabwritten then
        begin
        inherited concatstabto(asmlist);
        end;
      end;

{$endif GDB}

{**************************************
               TABSTRACTPROCDEF
 **************************************}

    constructor tabstractprocdef.init;

      begin
         inherited init;
         para1:=nil;
         options:=0;
         retdef:=voiddef;
         savesize:=4;
      end;

    destructor tabstractprocdef.done;

      var
         hp : pdefcoll;

      begin
         hp:=para1;
         while assigned(hp) do
           begin
              para1:=hp^.next;
              dispose(hp);
              hp:=para1;
           end;
         inherited done;
      end;

    procedure tabstractprocdef.concatdef(p : pdef;vsp : tvarspez);

      var
         hp : pdefcoll;

      begin
         new(hp);
         hp^.paratyp:=vsp;
         hp^.data:=p;
         hp^.next:=para1;
         para1:=hp;
      end;

    procedure tabstractprocdef.deref;

      var
         hp : pdefcoll;

      begin
         inherited deref;
         resolvedef(retdef);
         hp:=para1;
         while assigned(hp) do
           begin
              resolvedef(hp^.data);
              hp:=hp^.next;
           end;
      end;

    constructor tabstractprocdef.load;

      var
         last,hp : pdefcoll;
         count,i : word;

      begin
{$ifdef GDB}
         tdef.load;
{$endif GDB}
         retdef:=readdefref;
         options:=readlong;
         count:=readword;
         para1:=nil;
         savesize:=4;
         for i:=1 to count do
           begin
              new(hp);
              hp^.paratyp:=tvarspez(readbyte);
              hp^.data:=readdefref;
              hp^.next:=nil;
              if para1=nil then
                para1:=hp
              else
                last^.next:=hp;
              last:=hp;
           end;
      end;

    procedure tabstractprocdef.write;

      var
         count : word;
         hp : pdefcoll;

      begin
         tdef.write;
         writedefref(retdef);
         ppufile.write_long(options);
         hp:=para1;
         count:=0;
         while assigned(hp) do
           begin
              inc(count);
              hp:=hp^.next;
           end;
         ppufile.write_word(count);
         hp:=para1;
         while assigned(hp) do
           begin
              ppufile.write_byte(byte(hp^.paratyp));
              writedefref(hp^.data);
              hp:=hp^.next;
           end;
      end;

{$ifdef GDB}
    function tabstractprocdef.stabstring : pchar;
      begin
      stabstring := strpnew('abstractproc'+numberstring+';');
      end;

    procedure tabstractprocdef.concatstabto(asmlist : paasmoutput);

      begin
         if (not assigned(sym) or sym^.isusedinstab or use_dbx)
            and not isstabwritten then
           begin
              {if assigned(retdef) then forcestabto(asmlist,retdef);}
              inherited concatstabto(asmlist);
           end;
      end;

{$endif GDB}

{**************************************
               TPROCDEF
 **************************************}

    constructor tprocdef.init;

      begin
         inherited init;
         deftype:=procdef;
         _mangledname:=nil;
         nextoverloaded:=nil;
         extnumber:=-1;
{$ifndef GDB}
         parast:=new(psymtable,init(parasymtable));
{$endif * not GDB *}
         localst:=new(psymtable,init(localsymtable));
{$ifdef GDB}
         parast:=new(psymtable,init(parasymtable));
{$endif GDB}

{$ifdef UseBrowser}
         defref:=nil;
         add_new_ref(defref);
         lastref:=defref;
         lastwritten:=nil;
         refcount:=1;
{$endif UseBrowser}

         { first, we assume, that all registers are used }
{$ifdef i386}
         usedregisters:=$ff;
{$endif i386}
{$ifdef m68k}
         usedregisters:=$FFFF;
{$endif}
{$ifdef alpha}
         usedregisters_int:=$ffffffff;
         usedregisters_fpu:=$ffffffff;
{$endif alpha}
         forwarddef:=true;
         _class := nil;
      end;

    constructor tprocdef.load;

      var
         s : string;

      begin
         deftype:=procdef;
         inherited load;
{$ifdef i386}
         usedregisters:=readbyte;
{$endif i386}
{$ifdef m68k}
         usedregisters:=readword;
{$endif}
{$ifdef alpha}
         usedregisters_int:=readlong;
         usedregisters_fpu:=readlong;
{$endif alpha}

         s:=readstring;
         setstring(_mangledname,s);

         extnumber:=readlong;
         nextoverloaded:=pprocdef(readdefref);
{ this $ifdef GDB made the ppu files different !! }
         _class := pobjectdef(readdefref);

        if gendeffile and ((options and poexports)<>0) then
           writeln(deffile,#9+mangledname);

         parast:=nil;
         localst:=nil;
         forwarddef:=false;
{$ifdef UseBrowser}
         if (current_module^.flags and uf_uses_browser)<>0 then
           load_references
         else
           begin
              lastref:=nil;
              lastwritten:=nil;
              defref:=nil;
              refcount:=0;
           end;
{$endif UseBrowser}
      end;

{$ifdef UseBrowser}
    procedure tprocdef.load_references;

      var fileindex : word;
          b : byte;
          l : longint;

      begin
         b:=readbyte;
         refcount:=0;
         lastref:=nil;
         lastwritten:=nil;
         defref:=nil;
         while b=ibref do
           begin
              fileindex:=readword;
              l:=readlong;
              inc(refcount);
              lastref:=new(pref,load(lastref,fileindex,l));
              if refcount=1 then defref:=lastref;
              b:=readbyte;
           end;
         if b <> ibend then
          Message(unit_f_ppu_read);
      end;

    procedure tprocdef.write_references;

      var ref : pref;

      begin
      { references do not change the ppu caracteristics      }
      { this only save the references to variables/functions }
      { defined in the unit what about the others            }
         ppufile.do_crc:=false;
         if assigned(lastwritten) then
           ref:=lastwritten
         else
           ref:=defref;
         while assigned(ref) do
           begin
              writebyte(ibref);
              writeword(ref^.inputfile^.ref_index);
              writelong(ref^.lineno);
              ref:=ref^.nextref;
           end;
         lastwritten:=lastref;
         writebyte(ibend);
         ppufile.do_crc:=true;
      end;

    procedure tprocdef.write_external_references;

      var ref : pref;

      begin
         ppufile.do_crc:=false;
         if lastwritten=lastref then exit;
         writebyte(ibextdefref);
         writedefref(@self);
         if assigned(lastwritten) then
           ref:=lastwritten
         else
           ref:=defref;
         while assigned(ref) do
           begin
              writebyte(ibref);
              writeword(ref^.inputfile^.ref_index);
              writelong(ref^.lineno);
              ref:=ref^.nextref;
           end;
         lastwritten:=lastref;
         writebyte(ibend);
         ppufile.do_crc:=true;
      end;

    procedure tprocdef.write_ref_to_file(var f : text);

      var ref : pref;

      begin
         ref:=defref;
         while assigned(ref) do
           begin
              writeln(f,ref^.get_file_line);
              ref:=ref^.nextref;
           end;
      end;
{$endif UseBrowser}

    destructor tprocdef.done;

      begin
         if assigned(parast) then
           dispose(parast,done);
         if assigned(localst) then
           dispose(localst,done);
         if
{$ifdef tp}
         not(use_big) and
{$endif}
         assigned(_mangledname) then
           strdispose(_mangledname);
         inherited done;
      end;

    procedure tprocdef.write;

      begin
         ppufile.write_byte(ibprocdef);
         inherited write;
{$ifdef i386}
         ppufile.write_byte(usedregisters);
{$endif i386}
{$ifdef m68k}
         ppufile.write_word(usedregisters);
{$endif}

{$ifdef alpha}
         ppufile.write_long(usedregisters_int);
         ppufile.write_long(usedregisters_fpu);
{$endif alpha}

         writestring(mangledname);
         ppufile.write_long(extnumber);
         writedefref(nextoverloaded);
         writedefref(_class);
{$ifdef UseBrowser}
         if (current_module^.flags and uf_uses_browser)<>0 then
           write_references;
{$endif UseBrowser}
      end;

{$ifdef GDB}
    procedure addparaname(p : psym);
      var vs : char;

      begin
      if pvarsym(p)^.varspez = vs_value then vs := '1'
        else vs := '0';
      strpcopy(strend(StabRecString),p^.name+':'+pvarsym(p)^.definition^.numberstring+','+vs+';');
      end;

    function tprocdef.stabstring : pchar;
      var param : pdefcoll;
          i : word;
          vartyp : char;
          oldrec : pchar;
      begin
      oldrec := stabrecstring;
      getmem(StabRecString,1024);
      param := para1;
      i := 0;
      while assigned(param) do
        begin
           inc(i);
           param := param^.next;
        end;
      strpcopy(StabRecString,'f'+retdef^.numberstring);
      if i>0 then
        begin
        strpcopy(strend(StabRecString),','+tostr(i)+';');
        if assigned(parast) then
          {$IfDef TP}
          parast^.foreach(addparaname)
          {$Else}
          parast^.foreach(@addparaname)
          {$EndIf}
          else
          begin
          param := para1;
          i := 0;
          while assigned(param) do
            begin
            inc(i);
            if param^.paratyp = vs_value then vartyp := '1' else vartyp := '0';
            {Here we have lost the parameter names !!}
            {using lower case parameters }
            strpcopy(strend(stabrecstring),'p'+tostr(i)
               +':'+param^.data^.numberstring+','+vartyp+';');
            param := param^.next;
            end;
          end;
        {strpcopy(strend(StabRecString),';');}
        end;
      stabstring := strnew(stabrecstring);
      freemem(stabrecstring,1024);
      stabrecstring := oldrec;
      end;

    procedure tprocdef.concatstabto(asmlist : paasmoutput);

      begin
      end;
{$endif GDB}

    procedure tprocdef.deref;

      begin
         inherited deref;
         resolvedef(pdef(nextoverloaded));
         resolvedef(pdef(_class));
      end;

    function tprocdef.mangledname : string;

{$ifdef tp}
      var
         oldpos : longint;
         s : string;
         b : byte;
{$endif tp}

      begin
{$ifdef tp}
         if use_big then
           begin
              symbolstream.seek(longint(_mangledname));
              symbolstream.read(b,1);
              symbolstream.read(s[1],b);
              s[0]:=chr(b);
              mangledname:=s;
           end
         else
{$endif}
           begin
              mangledname:=strpas(_mangledname);
           end;
      end;

{$IfDef GDB}
    function tprocdef.cplusplusmangledname : string;

      var
         s,s2 : string;
         param : pdefcoll;

      begin
      s := sym^.name;
      if _class <> nil then
        begin
        s2 := _class^.name^;
        s := s+'__'+tostr(length(s2))+s2;
        end else s := s + '_';
      param := para1;
      while assigned(param) do
        begin
        s2 := param^.data^.sym^.name;
        s := s+tostr(length(s2))+s2;
        param := param^.next;
        end;
      cplusplusmangledname:=s;
      end;
{$EndIf GDB}

    procedure tprocdef.setmangledname(const s : string);

      begin
         if
{$ifdef tp}
         not(use_big) and
{$endif}
         (assigned(_mangledname)) then
           strdispose(_mangledname);
         setstring(_mangledname,s);
      end;

{**************************************
               TPROCVARDEF
 **************************************}

    constructor tprocvardef.init;

      begin
         inherited init;
         deftype:=procvardef;
      end;

    constructor tprocvardef.load;

      begin
{$ifndef GDB}
         deftype:=procvardef;
{$endif * not GDB *}
         inherited load;
{$ifdef GDB}
         deftype:=procvardef;
         set_globalnb;
{$endif GDB}
      end;

    procedure tprocvardef.write;

      begin
         ppufile.write_byte(ibprocvardef);
         inherited write;
      end;

{$ifdef GDB}
    function tprocvardef.stabstring : pchar;

      var
         nss : pchar;
         i : word;
         vartyp : char;
         pst : pchar;
         param : pdefcoll;

      begin
      i := 0;
      param := para1;
      while assigned(param) do
        begin
        inc(i);
        param := param^.next;
        end;
      getmem(nss,1024);
      strpcopy(nss,'f'+retdef^.numberstring+','+tostr(i)+';');
      param := para1;
      i := 0;
      while assigned(param) do
        begin
        inc(i);
        if param^.paratyp = vs_value then vartyp := '1' else vartyp := '0';
        {Here we have lost the parameter names !!}
        pst := strpnew('p'+tostr(i)+':'+param^.data^.numberstring+','+vartyp+';');
        strcat(nss,pst);
        strdispose(pst);
        param := param^.next;
        end;
      {strpcopy(strend(nss),';');}
      stabstring := strnew(nss);
      freemem(nss,1024);
      end;

    procedure tprocvardef.concatstabto(asmlist : paasmoutput);

      begin
         if ( not assigned(sym) or sym^.isusedinstab or use_dbx)
           and not isstabwritten then
           inherited concatstabto(asmlist);
         isstabwritten:=true;
      end;
{$endif GDB}

{**************************************
               TOBJECTDEF
 **************************************}

{$ifdef GDB}
    const
       vtabletype : word = 0;
       vtableassigned : boolean = false;

{$endif GDB}
   constructor tobjectdef.init(const n : string;c : pobjectdef);

     begin
        tdef.init;
        deftype:=objectdef;
        childof:=c;
        options:=0;
        { privatesyms:=new(psymtable,init(objectsymtable));
      protectedsyms:=new(psymtable,init(objectsymtable)); }
        publicsyms:=new(psymtable,init(objectsymtable));
        publicsyms^.name := stringdup(n);
        { add the data of the anchestor class }
        if assigned(childof) then
          begin
             publicsyms^.datasize:=
               publicsyms^.datasize-4+childof^.publicsyms^.datasize;
          end;
        name:=stringdup(n);
        savesize := publicsyms^.datasize;
        publicsyms^.defowner:=@self;
     end;

    constructor tobjectdef.load;

      var
         oldread_member : boolean;

      begin
{$ifdef GDB}
         tdef.load;
         set_globalnb;
{$endif GDB}
         deftype:=objectdef;
         savesize:=readlong;
         name:=stringdup(readstring);

         childof:=pobjectdef(readdefref);
         options:=readlong;
         oldread_member:=read_member;
         read_member:=true;
         if (options and (oo_hasprivate or oo_hasprotected))<>0 then
           object_options:=true;
         publicsyms:=new(psymtable,loadasstruct(objectsymtable));
         object_options:=false;
         publicsyms^.defowner:=@self;
         publicsyms^.datasize:=savesize;
{$ifdef GDB}
         publicsyms^.name := stringdup(name^);
{$endif GDB}
         read_member:=oldread_member;

         { handles the predefined class tobject  }
         { the last TOBJECT which is loaded gets }
         { it !                                  }
         if (name^='TOBJECT') and not(cs_compilesystem in aktswitches) and
           isclass and (childof=pointer($ffffffff)) then
           class_tobject:=@self;
      end;

   procedure tobjectdef.check_forwards;

     begin
        publicsyms^.check_forwards;
        if (options and oo_isforward)<>0 then
          begin
             { ok, in future, the forward can be resolved }
             Message1(sym_e_class_forward_not_resolved,name^);
             options:=options and not(oo_isforward);
          end;
     end;

   destructor tobjectdef.done;

     begin
{!!!!
        if assigned(privatesyms) then
          dispose(privatesyms,done);
        if assigned(protectedsyms) then
          dispose(protectedsyms,done); }
        if assigned(publicsyms) then
          dispose(publicsyms,done);
        if (options and oo_isforward)<>0 then
         Message1(sym_e_class_forward_not_resolved,name^);
        stringdispose(name);
        tdef.done;
     end;

   { true, if self inherits from d (or if they are equal) }
   function tobjectdef.isrelated(d : pobjectdef) : boolean;

     var
        hp : pobjectdef;

     begin
        hp:=@self;
        while assigned(hp) do
          begin
             if hp=d then
               begin
                  isrelated:=true;
                  exit;
               end;
             hp:=hp^.childof;
          end;
        isrelated:=false;
     end;

   function tobjectdef.size : longint;

     begin
        if (options and oois_class)<>0 then
          size:=4
        else
          size:=publicsyms^.datasize;
     end;

    procedure tobjectdef.deref;

      var
         hp : pdef;
         oldrecsyms : psymtable;

      begin
         resolvedef(pdef(childof));
         oldrecsyms:=aktrecordsymtable;
         aktrecordsymtable:=publicsyms;
         { nun die Definitionen dereferenzieren }
         hp:=publicsyms^.wurzeldef;
         while assigned(hp) do
           begin
              hp^.deref;

              {Besitzer setzen }
              hp^.owner:=publicsyms;

              hp:=hp^.next;
           end;
{$ifdef tp}
         publicsyms^.foreach(derefsym);
{$else}
         publicsyms^.foreach(@derefsym);
{$endif}
         aktrecordsymtable:=oldrecsyms;
      end;

    function tobjectdef.vmt_mangledname : string;

    {DM: I get a nil pointer on the owner name. I don't know if this
     mayhappen, and I have therefore fixed the problem by doing nil pointer
     checks.}

    var s1,s2:string;

    begin
        if owner^.name=nil then
            s1:=''
        else
            s1:=owner^.name^;
        if name=nil then
            s2:=''
        else
            s2:=name^;
        vmt_mangledname:='VMT_'+s1+'$_'+s2;
    end;

    function tobjectdef.isclass : boolean;

      begin
         isclass:=(options and oois_class)<>0;
      end;

    procedure tobjectdef.write;

      var
         oldread_member : boolean;

      begin
         oldread_member:=read_member;
         read_member:=true;
         ppufile.write_byte(ibobjectdef);
         tdef.write;
         ppufile.write_long(size);
         writestring(name^);
         writedefref(childof);
         ppufile.write_long(options);
         if (options and (oo_hasprivate or oo_hasprotected))<>0 then
           object_options:=true;
         publicsyms^.writeasstruct;
         object_options:=false;
         read_member:=oldread_member;
      end;

{$ifdef GDB}
    procedure addprocname(p :psym);
    var virtualind,argnames : string;
        news, newrec : pchar;
        pd,ipd : pprocdef;
        lindex : longint;
        para : pdefcoll;
        arglength : byte;
    begin
    If p^.typ = procsym then
       begin
                pd := pprocsym(p)^.definition;
                { this will be used for full implementation of object stabs
                not yet done }
                ipd := pd;
                while assigned(ipd^.nextoverloaded) do ipd := ipd^.nextoverloaded;
                if (pd^.options and povirtualmethod) <> 0 then
                   begin
                   lindex := pd^.extnumber;
                   {doesnt seem to be necessary
                   lindex := lindex or $80000000;}
                   virtualind := '*'+tostr(lindex)+';'+ipd^._class^.numberstring+';'
                   end else virtualind := '.';
                { arguments are not listed here }
                {we don't need another definition}
                 para := pd^.para1;
                 argnames := '';
                 while assigned(para) do
                   begin
                   if para^.data^.deftype = formaldef then
                     argnames := argnames+'3var'
                     else
                     begin
                     { if the arg definition is like (v: ^byte;..
                     there is no sym attached to data !!! }
                     if assigned(para^.data^.sym) then
                       begin
                          arglength := length(para^.data^.sym^.name);
                          argnames := argnames + tostr(arglength)+para^.data^.sym^.name;
                       end
                     else
                       begin
                          argnames:=argnames+'11unnamedtype';
                       end;
                     end;
                   para := para^.next;
                   end;
                ipd^.isstabwritten := true;
                { here 2A must be changed for private and protected }
                newrec := strpnew(p^.name+'::'+ipd^.numberstring
                     +'=##'+pd^.retdef^.numberstring+';:'+argnames+';2A'
                     +virtualind+';');
               { get spare place for a string at the end }
               if strlen(StabRecString) + strlen(newrec) >= StabRecSize-256 then
                 begin
                    getmem(news,stabrecsize+memsizeinc);
                    strcopy(news,stabrecstring);
                    freemem(stabrecstring,stabrecsize);
                    stabrecsize:=stabrecsize+memsizeinc;
                    stabrecstring:=news;
                 end;
               strcat(StabRecstring,newrec);
               {freemem(newrec,memsizeinc);    }
               strdispose(newrec);
               {This should be used for case !!}
               RecOffset := RecOffset + pd^.size;
       end;
    end;

    function tobjectdef.stabstring : pchar;
      var anc : pobjectdef;
          oldrec : pchar;
          oldrecsize : longint;
          str_end : string;
      begin
      oldrec := stabrecstring;
      oldrecsize:=stabrecsize;
      stabrecsize:=memsizeinc;
      GetMem(stabrecstring,stabrecsize);
      strpcopy(stabRecString,'s'+tostr(size));
      if assigned(childof) then
        {only one ancestor not virtual, public, at base offset 0 }
        {       !1           ,    0       2         0    ,       }
        strpcopy(strend(stabrecstring),'!1,020,'+childof^.numberstring+';');
      {virtual table to implement yet}
      RecOffset := 0;
{$ifdef tp}
         publicsyms^.foreach(addname);
{$else}
         publicsyms^.foreach(@addname);
{$endif tp}
      if (options and oo_hasvirtual) <> 0 then
        if not assigned(childof) or ((childof^.options and oo_hasvirtual) = 0) then
           begin
              str_end:='$vf'+numberstring+':'+typeglobalnumber('vtblarray')+',0;';
              strpcopy(strend(stabrecstring),'$vf'+numberstring+':'+typeglobalnumber('vtblarray')+',0;');
           end;
{$ifdef tp}
         publicsyms^.foreach(addprocname);
{$else}
         publicsyms^.foreach(@addprocname);
{$endif tp }
      if (options and oo_hasvirtual) <> 0  then
        begin
           anc := @self;
           while assigned(anc^.childof) and ((anc^.childof^.options and oo_hasvirtual) <> 0) do
             anc := anc^.childof;
           str_end:=';~%'+anc^.numberstring+';';
        end
      else
        str_end:=';';
      strpcopy(strend(stabrecstring),str_end);
      stabstring := strnew(StabRecString);
      freemem(stabrecstring,stabrecsize);
      stabrecstring := oldrec;
      stabrecsize:=oldrecsize;
      end;

{$endif GDB}

{**************************************
               TERRORDEF
 **************************************}

   constructor terrordef.init;

     begin
        tdef.init;
        deftype:=errordef;
     end;

{$ifdef GDB}
    function terrordef.stabstring : pchar;

      begin
         stabstring:=strpnew('error'+numberstring);
      end;

{$endif GDB}

    { type helper routines for objects }
    function search_class_member(pd : pobjectdef;const n : string) : psym;

      var
         sym : psym;

      begin
         sym:=nil;
         while assigned(pd) do
           begin
              sym:=pd^.publicsyms^.search(n);
              if assigned(sym) then
                break;
              pd:=pd^.childof;
           end;
         search_class_member:=sym;
      end;

   var
      _defaultprop : ppropertysym;

   procedure testfordefaultproperty(p : psym);

     begin
        if (p^.typ=propertysym) and ((ppropertysym(p)^.options and ppo_defaultproperty)<>0) then
          _defaultprop:=ppropertysym(p);
     end;

   function search_default_property(pd : pobjectdef) : ppropertysym;

     begin
        _defaultprop:=nil;
        while assigned(pd) do
          begin
{$ifdef tp}
             pd^.publicsyms^.foreach(testfordefaultproperty);
{$else}
             pd^.publicsyms^.foreach(@testfordefaultproperty);
{$endif}
             if assigned(_defaultprop) then
               break;
             pd:=pd^.childof;
          end;
        search_default_property:=_defaultprop;
     end;

   procedure init_symtable;

     begin
        registerdef:=false;
        read_member:=false;
        generrorsym:=new(perrorsym,init);
        swurzel:=nil;
        { readunit_lastloaded:=nil; }
{$ifdef GDB}
        firstglobaldef:=nil;
        lastglobaldef:=nil;
{$endif GDB}
        commandlinedefines.init;
        globaltypecount:=1;
        pglobaltypecount:=@globaltypecount;
     end;

   procedure reset_gdb_info;
     var def : pdef;
     begin
{$ifdef GDB }
        def:=firstglobaldef;
        GlobalTypeCount:=1;
        pglobaltypecount:=@globaltypecount;
        while assigned(def) do
          begin
              if assigned(def^.sym) then
                begin
                   { was a check

                   write('Type: ',longint(def^.deftype));
                   if def^.deftype=procdef then
                     write(' mangle name: ',pprocdef(def)^.mangledname);
                   }
                   if def^.sym^.typ=typesym then
                     def^.sym^.isusedinstab:=false;
                   {
                   writeln(' Name: ',def^.sym^.name);
                   }
                end;
              def^.isstabwritten:=false;
              def^.globalnb:=0;
              if (def^.deftype=orddef) then
                porddef(def)^.rangenr:=0;
              if (def^.deftype=arraydef) then
                parraydef(def)^.rangenr:=0;
              def:=def^.nextglobal;
          end;
{$endif GDB }
     end;

   procedure done_symtable;

      begin
        dispose(generrorsym,done);
        dispose_global:=true;
        while assigned(symtablestack) do dellexlevel;
{$ifndef GDB}
        dispose(generrordef,done);
        dispose(s32bitdef,done);
        dispose(u32bitdef,done);
        dispose(cstringdef,done);
     {$ifdef UseLongString}
        dispose(clongstringdef,done);
     {$endif UseLongString}
     {$ifdef UseAnsiString}
        dispose(cansistringdef,done);
     {$endif UseAnsiString}
        dispose(cchardef,done);
        {dispose(cs64realdef,done);}
        {dispose(voiddef,done); belongs to system !}
        dispose(u8bitdef,done);
        dispose(u16bitdef,done);
        dispose(booldef,done);
        dispose(voidpointerdef,done);
        dispose(cfiledef,done);
{$endif GDB}
        commandlinedefines.done;
     end;

var
  i : ttoken;
begin
   { no operator is overloaded }
   for i:=PLUS to last_overloaded do
     overloaded_operators[i]:=nil;
end.
{
  $Log: symtable.pas,v $
  Revision 1.1.1.1.2.4  1998/08/13 17:41:28  florian
    + some stuff for the PalmOS added

  Revision 1.1.1.1.2.3  1998/08/13 13:26:04  carl
    + support for Big endian reading of units

  Revision 1.1.1.1.2.2  1998/05/21 12:22:12  carl
    * bugfix of handle sizes for m68k systems

  Revision 1.1.1.1.2.1  1998/04/08 11:38:44  peter
    * nasm patches, pierres symtable patch

  Revision 1.1.1.1  1998/03/25 11:18:15  root
  * Restored version

  Revision 1.49  1998/03/24 21:48:36  florian
    * just a couple of fixes applied:
         - problem with fixed16 solved
         - internalerror 10005 problem fixed
         - patch for assembler reading
         - small optimizer fix
         - mem is now supported

  Revision 1.48  1998/03/21 23:59:39  florian
    * indexed properties fixed
    * ppu i/o of properties fixed
    * field can be also used for write access
    * overriding of properties

  Revision 1.47  1998/03/10 16:27:45  pierre
    * better line info in stabs debug
    * symtabletype and lexlevel separated into two fields of tsymtable
    + ifdef MAKELIB for direct library output, not complete
    + ifdef CHAINPROCSYMS for overloaded seach across units, not fully
      working
    + ifdef TESTFUNCRET for setting func result in underfunction, not
      working

  Revision 1.46  1998/03/10 01:17:28  peter
    * all files have the same header
    * messages are fully implemented, EXTDEBUG uses Comment()
    + AG... files for the Assembler generation

  Revision 1.45  1998/03/06 00:52:56  peter
    * replaced all old messages from errore.msg, only ExtDebug and some
      Comment() calls are left
    * fixed options.pas

  Revision 1.44  1998/03/04 17:34:09  michael
  + Changed ifdef FPK to ifdef FPC

  Revision 1.43  1998/03/04 01:35:12  peter
    * messages for unit-handling and assembler/linker
    * the compiler compiles without -dGDB, but doesn't work yet
    + -vh for Hint

  Revision 1.42  1998/03/03 23:18:49  florian
    * ret $8 problem with unit init/main program fixed

  Revision 1.41  1998/03/02 01:49:30  peter
    * renamed target_DOS to target_GO32V1
    + new verbose system, merged old errors and verbose units into one new
      verbose.pas, so errors.pas is obsolete

  Revision 1.40  1998/03/01 22:46:22  florian
    + some win95 linking stuff
    * a couple of bugs fixed:
      bug0055,bug0058,bug0059,bug0064,bug0072,bug0093,bug0095,bug0098

  Revision 1.39  1998/02/27 21:24:15  florian
    * dll support changed (dll name can be also a string contants)

  Revision 1.38  1998/02/27 09:26:10  daniel
  * Changed symtable handling so no junk symtable is put on the symtablestack.

  Revision 1.37  1998/02/24 15:36:27  daniel
  + Added owner:=nil to Tsym.init. Caused problems with TP compiling.

  Revision 1.36  1998/02/24 14:20:58  peter
    + tstringcontainer.empty
    * ld -T option restored for linux
    * libraries are placed before the objectfiles in a .PPU file
    * removed 'uses link' from files.pas

  Revision 1.35  1998/02/22 23:03:36  peter
    * renamed msource->mainsource and name->unitname
    * optimized filename handling, filename is not seperate anymore with
      path+name+ext, this saves stackspace and a lot of fsplit()'s
    * recompiling of some units in libraries fixed
    * shared libraries are working again
    + $LINKLIB <lib> to support automatic linking to libraries
    + libraries are saved/read from the ppufile, also allows more libraries
      per ppufile

  Revision 1.34  1998/02/17 21:21:01  peter
    + Script unit
    + __EXIT is called again to exit a program
    - target_info.link/assembler calls
    * linking works again for dos
    * optimized a few filehandling functions
    * fixed stabs generation for procedures

  Revision 1.33  1998/02/16 12:51:50  michael
  + Implemented linker object

  Revision 1.32  1998/02/14 01:45:32  peter
    * more fixes
    - pmode target is removed
    - search_as_ld is removed, this is done in the link.pas/assemble.pas
    + findexe() to search for an executable (linker,assembler,binder)

  Revision 1.31  1998/02/13 22:26:40  peter
    * fixed a few SigSegv's
    * INIT$$ was not written for linux!
    * assembling and linking works again for linux and dos
    + assembler object, only attasmi3 supported yet
    * restore pp.pas with AddPath etc.

  Revision 1.30  1998/02/13 10:35:47  daniel
  * Made Motorola version compilable.
  * Fixed optimizer

  Revision 1.29  1998/02/12 17:19:28  florian
    * fixed to get remake3 work, but needs additional fixes (output, I don't like
      also that aktswitches isn't a pointer)

  Revision 1.28  1998/02/12 11:50:47  daniel
  Yes! Finally! After three retries, my patch!

  Changes:

  Complete rewrite of psub.pas.
  Added support for DLL's.
  Compiler requires less memory.
  Platform units for each platform.

  Revision 1.27  1998/02/07 23:05:06  florian
    * once more MMX

  Revision 1.26  1998/02/07 06:49:14  carl
    * small fixes to make it compile with non-386 targets

  Revision 1.25  1998/02/06 23:08:34  florian
    + endian to targetinfo and sourceinfo added
    + endian independed writing of ppu file (reading missed), a PPU file
      is written with the target endian

  Revision 1.24  1998/02/06 10:34:29  florian
    * bug0082 and bug0084 fixed

  Revision 1.23  1998/02/03 22:13:36  florian
    * clean up

  Revision 1.22  1998/02/02 23:39:58  florian
    * forward classes are now allowed without resolving (see sysutils)

  Revision 1.21  1998/02/02 00:55:35  peter
    * defdatei -> deffile and some german comments to english
    * search() accepts : as seperater under linux
    * search for ppc.cfg doesn't open a file (and let it open)
    * reorganize the reading of parameters/file a bit
    * all the PPC_ environments are now for all platforms

  Revision 1.20  1998/02/01 15:03:01  florian
    * small improvement of tobjectdef.isrelated

  Revision 1.19  1998/01/30 17:31:27  pierre
    * bug of cyclic symtablestack fixed

  Revision 1.18  1998/01/27 22:02:35  florian
    * small bug fix to the compiler work, I forgot a not(...):(

  Revision 1.17  1998/01/25 22:29:05  florian
    * a lot bug fixes on the DOM

  Revision 1.16  1998/01/23 17:12:21  pierre
    * added some improvements for as and ld :
      - doserror and dosexitcode treated separately
      - PATH searched if doserror=2
    + start of long and ansi string (far from complete)
      in conditionnal UseLongString and UseAnsiString
    * options.pas cleaned (some variables shifted to globals)gl

  Revision 1.15  1998/01/21 21:29:57  florian
    * some fixes for Delphi classes

  Revision 1.14  1998/01/16 18:03:19  florian
    * small bug fixes, some stuff of delphi styled constructores added

  Revision 1.13  1998/01/16 11:24:28  florian
    + problem with absolute syms in unit files solved

  Revision 1.12  1998/01/16 10:33:18  florian
    * bug0077 fixed (problem when reading absolute syms from a unit file)

  Revision 1.11  1998/01/13 23:04:17  florian
    * the options member of procdefs, objectdefs and propertysyms is
      noew longint => unit format changed

  Revision 1.10  1998/01/13 17:13:10  michael
    * File time handling and file searching is now done in an OS-independent way,
      using the new file treating functions in globals.pas.

  Revision 1.9  1998/01/11 04:15:34  carl
    * alignment problem fix for m68k

  Revision 1.8  1998/01/10 11:10:42  florian
    + procedure flag poclassmethod for class methods

  Revision 1.7  1998/01/09 23:08:36  florian
    + C++/Delphi styled //-comments
    * some bugs in Delphi object model fixed
    + override directive

  Revision 1.6  1998/01/09 13:18:13  florian
    + "forward" class declarations   (type tclass = class; )

  Revision 1.5  1998/01/07 00:17:06  michael
  Restored released version (plus fixes) as current

  Revision 1.3  1997/12/09 14:10:52  carl
  + merged both m68k and intel float types

  Revision 1.2  1997/12/03 13:57:45  carl
  + writexxx and readxxx now use sizeof(xxxx)
  (except for sets).

  Revision 1.1.1.1  1997/11/27 08:33:02  michael
  FPC Compiler CVS start


  Pre-CVS log:


  CEC    Carl-Eric Codere
  FK     Florian Klaempfl
  PM     Pierre Muller
  +      feature added
  -      removed
  *      bug fixed or changed

  History (started with version 0.9.0):
       7th december 1996
         * the call offset is now saved in call_offset and not in name   (FK)
      26th december 1996
         + new PPU file handling   (FK)
      26th february 1997
         + fixed comma numbers   (FK)
      5th september 1997
         * fixed a little missing i386
           define for s64bit on line: 3609   (CEC)
         + works with m68k unit   (CEC)
     17th september 1997
         * type t=^b; b=byte;
           works now   (FK)
     25th september 1997:
         + getsize handles now open arrays (FK)
     1th october 1997
         + adding assignment to overloadable operators (PM)
     3rd october 1997:
         + created one tfloattype for m68k. Find all ifdef m68k and
           tfloatdef methods modified also (CEC)
      4th october 1997:
         + added has_jump in enumdef for use in in_succ_x and in_pred_x (PM)
      13th october 1997:
         + added static modifier for objects variable and methods (PM)
      25th october 1997:
         + small sets released (FK)
      19th november 1997:
         + tfiledef.setsize for win32 (FK)
      20th november 1997:
         + added  argconvtyp to tdefcoll (PM)
}

