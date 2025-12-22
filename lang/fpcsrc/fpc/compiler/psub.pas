{
    $Id: psub.pas,v 1.3.2.4 1998/08/22 10:23:00 florian Exp $
    Copyright (c) 1998 by Florian Klaempfl, Daniel Mantoine

    Does the parsing of the procedures/functions

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
unit psub;
interface

uses cobjects;

procedure compile_proc_body(const proc_names:Tstringcontainer;
                            make_global,parent_has_class:boolean);
procedure _proc_head(options : word);
procedure proc_head;
procedure unter_dec;


implementation

uses
  globals,scanner,symtable,aasm,tree,pass_1,
  types,hcodegen,files,verbose,systems,strings,link,import
{$ifdef GDB}
  ,gdb
{$endif GDB}
  { parser specific stuff }
  ,pbase,ptconst,pdecl,pexpr,pstatmnt
  { processor specific stuff }
{$ifdef i386}
  ,i386,cgai386,tgeni386,cgi386,aopt386
{$endif}
{$ifdef m68k}
  ,m68k,cga68k,tgen68k,cg68k
{$endif}
  ;

procedure formal_parameter_list;

{ handle_procvar needs the same changes }

var sc:Pstringcontainer;
    s:string;
    p:Pdef;
    vs:Pvarsym;
    hs1,hs2:string;
    varspez:Tvarspez;

begin
    consume(LKLAMMER);
    inc(testcurobject);
    repeat
        if token=_VAR then
            begin
                consume(_VAR);
                varspez:=vs_var;
            end
        else
            if token=_CONST then
                begin
                    consume(_CONST);
                    varspez:=vs_const;
                end
            else
                varspez:=vs_value;
        sc:=idlist;
        if token=COLON then
            begin
                consume(COLON);
                { check for an open array }
                if token=_ARRAY then
                    begin
                        if (varspez<>vs_const) and (varspez<>vs_var) then
                            begin
                                varspez:=vs_const;
                                Message(parser_e_illegal_open_parameter);
                            end;
                        consume(_ARRAY);
                        consume(_OF);
                        { define range and type of range }
                        p:=new(Parraydef,init(0,-1,s32bitdef));
                        { define field type }
                        Parraydef(p)^.definition:=single_type(hs1);
                        hs1:='array_of_'+hs1;
                    end
                else
                    p:=single_type(hs1);
            end
        else
            begin
{$ifndef UseNiceNames}
                hs1:='$$$';
{$else UseNiceNames}
                hs1:='var';
{$endif UseNiceNames}
                p:=new(Pformaldef,init);
            end;
        s:=sc^.get;
        hs2:=aktprocsym^.definition^.mangledname;
        while s<>'' do
            begin
                aktprocsym^.definition^.concatdef(p,varspez);
{$ifndef UseNiceNames}
                hs2:=hs2+'$'+hs1;
{$else UseNiceNames}
                hs2:=hs2+tostr(length(hs1))+hs1;
{$endif UseNiceNames}
                vs:=new(Pvarsym,init(s,p));
                vs^.varspez:=varspez;
                { we have to add this
                  to avoid var param to be in registers !!!}
                if (varspez=vs_var) or (varspez=vs_const) and
                 dont_copy_const_param(p) then
                    vs^.regable:=false;
                aktprocsym^.definition^.parast^.insert(vs);
                s:=sc^.get;
            end;
        dispose(sc,done);
        aktprocsym^.definition^.setmangledname(hs2);
        if token=SEMICOLON then
            consume(SEMICOLON)
        else
            break;
    until false;
    dec(testcurobject);
    consume(RKLAMMER);
end;

{ contains the real name of a procedure as it's typed }
{ (the pattern isn't upper cased)                     }

var realname:stringid;

procedure _proc_head(options : word);

var sp:stringid;
    pd:Pprocdef;
    paramoffset:longint;
    hsymtab:Psymtable;
    sym:Psym;
    hs:string;
    overloaded_level:word;

begin
    if (options and pooperator) <> 0 then
        begin
            sp:=overloaded_names[optoken];
            realname:=sp;
        end
    else
        begin
            sp:=pattern;
            realname:=orgpattern;
            consume(ID);
        end;

    { method ? }
    if (token=POINT) and not(parse_only) then
        begin
            consume(POINT);
            getsym(sp,true);
            sym:=srsym;
            { qualifier is class name ? }
            if (sym^.typ<>typesym) or
             (ptypesym(sym)^.definition^.deftype<>objectdef) then
               Message(parser_e_class_id_expected);
            { used to allow private syms to be seen }
            aktobjectdef:=pobjectdef(ptypesym(sym)^.definition);
            sp:=pattern;
            realname:=orgpattern;
            consume(ID);
            procinfo._class:=pobjectdef(ptypesym(sym)^.definition);
            aktprocsym:=pprocsym(procinfo._class^.publicsyms^.search(sp));
            aktobjectdef:=nil;
            { we solve this below }
            if not(assigned(aktprocsym)) then
             Message(parser_e_methode_id_expected);
        end
    else
        begin
            if not(parse_only) and
             ((options and (poconstructor or podestructor))<>0) then
                Message(parser_e_constructors_always_objects);

            aktprocsym:=pprocsym(symtablestack^.search(sp));
            if lexlevel=1 then
{$ifdef UseNiceNames}
                hs:=procprefix+'_'+tostr(length(sp))+sp
{$else UseNiceNames}
                hs:=procprefix+'_'+sp
{$endif UseNiceNames}
            else
{$ifdef UseNiceNames}
                hs:=lowercase(procprefix)+'_'+tostr(length(sp))+sp;
{$else UseNiceNames}
                hs:=procprefix+'_$'+sp;
{$endif UseNiceNames}
            if not(parse_only) then
                begin
                    {The procedure we prepare for is in the implementation
                     part of the unit we compile. It is also possible that we
                     are compiling a program, which is also some kind of
                     implementaion part.

                     We need to find out if the procedure is global. If it is
                     global, it is in the global symtable.}
                    if not assigned(aktprocsym) then
                        begin
                            {Search the procedure in the global symtable.}
                            aktprocsym:=Pprocsym(search_a_symtable(sp,
                             globalsymtable));

                            if assigned(aktprocsym) then
                                begin
                                    {Check if it is a procedure.}
                                    if typeof(aktprocsym^)<>typeof(Tprocsym) then
                                     Message1(sym_e_duplicate_id,aktprocsym^.Name);

                                    {The procedure has been found. So it is
                                     a global one. Set the flags to mark
                                     this.}
                                    procinfo.flags:=procinfo.flags or
                                     pi_is_global;
                                end;
                        end;
                end;
        end;
    { problem with procedures inside methods }
{$ifndef UseNiceNames}
    if assigned(procinfo._class) and (pos('_$$_',procprefix)=0) then
        hs:=procprefix+'_$$_'+procinfo._class^.name^+'_'+sp;
{$else UseNiceNames}
    if assigned(procinfo._class) and (pos('_5Class_',procprefix)=0) then
        hs:=procprefix+'_5Class_'+procinfo._class^.name^+'_'+tostr(length(sp))+sp;
{$endif UseNiceNames}

    if not(assigned(aktprocsym)) then
        begin
            aktprocsym:=new(pprocsym,init(sp));
            symtablestack^.insert(aktprocsym);
        end
    else
        begin
            { why shouldn't we overload proctected subroutines ? (FK) }
            {
             if assigned(procinfo._class) and ((aktprocsym^.properties and sp_protected)<>0) then
                error(cant_overload_protected);
            }
            if (aktprocsym^.typ=procsym) and not(aktprocsym^.definition^.forwarddef) and
             (cs_tp_compatible in aktswitches) then
                Message(parser_e_procedure_overloading_is_off);
        end;

    if aktprocsym^.typ<>procsym then
     Message(parser_e_overloaded_no_procedure);

    pd:=new(pprocdef,init);
{$ifdef GDB}
    {this is just used for the name }
    pd^.sym := ptypesym(aktprocsym);
    if assigned(procinfo._class) then
        pd^._class := procinfo._class;
{$endif * GDB *}

    { set the options from the caller (podestructor or poconstructor) }
    pd^.options:=pd^.options or options;

    { calculate the offset of the parameters }
    paramoffset:=8;

    { calculate frame pointer offset }
    if lexlevel>1 then
        begin
            procinfo.framepointer_offset:=paramoffset;
            inc(paramoffset,4);
        end;


    if assigned (Procinfo._Class) and not(procinfo._class^.isclass) and
     (
      ((pd^.options and poconstructor)<>0) or
      ((pd^.options and podestructor)<>0)
     ) then
        inc(paramoffset,4);

    { self pointer offset                              }
    { self isn't pushed in nested procedure of methods }
    if assigned(procinfo._class) and (lexlevel=1) then
        begin
            procinfo.ESI_offset:=paramoffset;
            inc(paramoffset,4);
        end;

    procinfo.call_offset:=paramoffset;

    pd^.parast^.datasize:=0;

    if aktprocsym^.typ=procsym then
       pd^.nextoverloaded:=aktprocsym^.definition
    else
       pd^.nextoverloaded:=nil;
    aktprocsym^.definition:=pd;
    aktprocsym^.definition^.setmangledname(hs);
    if not(parse_only) then
        procprefix:=hs;
    if assigned(pd^.nextoverloaded) and (pd^.nextoverloaded^.owner=
     symtablestack) then
        begin
            { we need another procprefix !!! }
            overloaded_level:=1;
            { count, but only those in the same unit !!}
            while assigned(pd^.nextoverloaded) and
             (pd^.nextoverloaded^.owner=symtablestack) do
                begin
                   inc(overloaded_level);
                   pd:=pd^.nextoverloaded;
                end;
            procprefix:=hs+'$'+tostr(overloaded_level)+'$';
        end;
    if token=LKLAMMER then
        formal_parameter_list;
    if (options and pooperator) <> 0 then
        begin
            if overloaded_operators[optoken]=nil then
                overloaded_operators[optoken]:=aktprocsym;
        end
end;

procedure proc_head;

var hs:string;
    isclassmethod:boolean;

begin
    { read class method }
    if token=_CLASS then
        begin
            consume(_CLASS);
            isclassmethod:=true;
        end
    else
        isclassmethod:=false;

    if token=_FUNCTION then
        begin
            consume(_FUNCTION);
            _proc_head(0);
            if token<>COLON then
                begin
                   consume(COLON);
                   {while token<>SEMICOLON do
                     consume(token); }
                   consume_all_until(SEMICOLON);
                end
            else
                begin
                   consume(COLON);
                   aktprocsym^.definition^.retdef:=single_type(hs);
                end;
        end
    else
        if token=_PROCEDURE then
            begin
                consume(_PROCEDURE);
                _proc_head(0);
                aktprocsym^.definition^.retdef:=voiddef;
            end
        else
            if token=_CONSTRUCTOR then
                begin
                    consume(_CONSTRUCTOR);
                    _proc_head(poconstructor);

                    if (procinfo._class^.options and oois_class)<>0 then
                        begin
                            {CLASS constructors return the created instance }
                            aktprocsym^.definition^.retdef:=procinfo._class;
                        end
                    else
                        begin
                            {OBJECT constructors return a boolean }
{$IfDef GDB}
                            {GDB doesn't like unnamed types !}
                            aktprocsym^.definition^.retdef:=
                            globaldef('boolean');
{$Else * GDB *}
                            aktprocsym^.definition^.retdef:=
                             new(porddef,init(bool8bit,0,1));

{$Endif * GDB *}
                        end;
                end
        else
            if token=_DESTRUCTOR then
                begin
                    consume(_DESTRUCTOR);
                    _proc_head(podestructor);
                    aktprocsym^.definition^.retdef:=voiddef;
                end
            else
                if token=_OPERATOR then
                    begin
                        { internalerror(110); }
                        consume(_OPERATOR);
                        if not(token in [PLUS..last_overloaded]) then
                         Message(parser_e_overload_operator_failed);
                        optoken:=token;
                        consume(token);
                        procinfo.flags:=procinfo.flags or pi_operator;
                        _proc_head(pooperator);
                        if token<>ID then
                            consume(ID)
                        else
                            begin
                                opsym:=new(pvarsym,init(pattern,voiddef));
                                consume(ID);
                            end;
                        if token<>COLON then
                            begin
                               consume(COLON);
                               { while token<>SEMICOLON do
                                 consume(token); }
                               consume_all_until(SEMICOLON);
                            end
                        else
                            begin
                               consume(COLON);
                               aktprocsym^.definition^.retdef:=
                                single_type(hs);
                               if (optoken in [EQUAL,GT,LT,GTE,LTE]) and
                                ((aktprocsym^.definition^.retdef^.deftype<>
                                orddef) or (porddef(aktprocsym^.definition^.
                                retdef)^.typ<>bool8bit)) then
                                   Message(parser_e_comparative_operator_return_boolean);
                                if ret_in_param(aktprocsym^.definition^.
                                 retdef) then
                                    pprocdef(aktprocsym^.definition)^.
                                     parast^.insert(opsym)
                                else
                                    pprocdef(aktprocsym^.definition)^.
                                     localst^.insert(opsym);
                                opsym^.definition:=aktprocsym^.definition^.
                                 retdef;
                            end;
                    end;
    if isclassmethod then
       aktprocsym^.definition^.options:=aktprocsym^.definition^.options
        or poclassmethod;
    consume(SEMICOLON);
end;

{****************************************************************************

                        Procedure directive handlers:

****************************************************************************}

{$ifdef tp}
  {$F+}
{$endif}

procedure pd_far(const procnames:Tstringcontainer);

begin
  Message(parser_w_proc_far_ignored);
end;

procedure pd_near(const procnames:Tstringcontainer);

begin
  Message(parser_w_proc_far_ignored);
end;

procedure pd_export(const procnames:Tstringcontainer);

begin
    procnames.insert(realname);
    procinfo.exported:=true;
    if gendeffile then
        writeln(deffile,#9+aktprocsym^.definition^.mangledname);
    if assigned(procinfo._class) then
      Message(parser_e_methods_dont_be_export);
    if lexlevel<>1 then
      Message(parser_e_dont_nest_export);
end;

procedure pd_inline(const procnames:Tstringcontainer);

begin
    if not(support_inline) then
     Message(parser_e_proc_inline_not_supported);
end;

procedure pd_forward(const procnames:Tstringcontainer);

begin
    aktprocsym^.definition^.forwarddef:=true;
    aktprocsym^.properties:=aktprocsym^.properties or sp_forwarddef;
end;

procedure pd_alias(const procnames:Tstringcontainer);

begin
    consume(COLON);
    procnames.insert(pattern);
    if token=CCHAR then
        consume(CCHAR)
    else
        consume(CSTRING);
end;

procedure pd_intern(const procnames:Tstringcontainer);

begin
    consume(COLON);
    aktprocsym^.definition^.extnumber:=get_intconst;
end;

procedure pd_system(const procnames:Tstringcontainer);

begin
    aktprocsym^.definition^.options:=aktprocsym^.definition^.options or
     poclearstack;
    aktprocsym^.definition^.setmangledname(realname);
end;

procedure pd_c_import(const procnames:Tstringcontainer);

begin
    aktprocsym^.definition^.options:=
      aktprocsym^.definition^.options or poclearstack;
    aktprocsym^.definition^.setmangledname(target_info.Cprefix+realname);
end;

procedure pd_lefrig(const procnames:Tstringcontainer);
begin
  Message(parser_f_unsupported_feature);
end;

procedure pd_syscall(const procnames:Tstringcontainer);

  begin
     aktprocsym^.definition^.options:=
       aktprocsym^.definition^.options or poclearstack;
     aktprocsym^.definition^.extnumber:=get_intconst;
  end;

procedure pd_extern(const procnames:Tstringcontainer);

  var
     { If import_dll=nil the procedure is assumed to be in another
       object file. In that object file it should have the name to
       which import_name is pointing to. Otherwise, the procedure is
       assumed to be in the DLL to which import_dll is pointing to. In
       that case either import_nr<>0 or import_name<>nil is true, so
       the procedure is either imported by number or by name. (DM)}
     import_dll,import_name : string;
     import_nr : word;

begin
    aktprocsym^.definition^.forwarddef:=false;

    {If the procedure should be imported from a DLL, a constant string
     follows.}
    { This isn't really correct, an contant string expression follows (FK) }
    { so we check if an semicolon follows, else a string constant have to  }
    { follow (FK)                                                          }

    { The following implementation is TP syntax, Daniel !!!! }

    import_nr:=0;
    import_name:='';
    if not(token=SEMICOLON) and not((token=ID) and (pattern='NAME')) then
       begin
           import_dll:=get_stringconst;
           if (token=ID) and (pattern='NAME') then
               begin
                   consume(ID);
                   import_name:=get_stringconst;
               end;
           if (token=ID) and (pattern='INDEX') then
               begin
                   {After the word index follows the index number in the DLL.}
                   consume(ID);
                   import_nr:=get_intconst;
               end;
           if (import_nr=0) and (import_name='') then
             Message(unit_d_ppu_file_too_short);
           if not(current_module^.uses_imports) then
             begin
                current_module^.uses_imports:=true;
                importlib^.preparelib(current_module^.unitname^);
             end;
           importlib^.importprocedure(aktprocsym^.mangledname,import_dll,import_nr,import_name)
       end
    else
        begin
           if (token=ID) and (pattern='NAME') then
             begin
                consume(ID);
                aktprocsym^.definition^.setmangledname(get_stringconst);
             end
           else
             { external shouldn't override the cdecl/system name }
             if (aktprocsym^.definition^.options and poclearstack)=0 then
               aktprocsym^.definition^.setmangledname(aktprocsym^.name);
        end;
end;

{$ifdef tp}
  {$F-}
{$endif}

procedure parse_proc_direc(const naam:string;const proc_names:Tstringcontainer;
                           var body,make_global:boolean);

{Parse a procedure directive. The parsing of procedure directives has
 been removed from unter_dec, to improve sourcecode readability.}

type    pd_handler=procedure(const procnames:Tstringcontainer);
        proc_dir_rec=record
            naam:string[15];        {15 letters should be enough.}
            handler:pd_handler;     {Handler.}
            flag:longint;              {Procedure flag. May be zero.}
            body,                   {Parse a procedure body?}
            global:boolean;         {Must the procedure be global?}
            mut_excl:longint;          {List of mutually exclusive flags.}
        end;

const   {Should contain the number of procedure directives we support.}
        num_proc_directives=17;
        {Should contain the largest power of 2 lower than
         num_proc_directives, the int value of the 2-log of it. Cannot be
         calculated using an constant expression, as far as I know.}
        num_proc_directives_2log=8;

{$IFDEF TP}
        {Cool TP syntax...}
        proc_direcdata:array[1..num_proc_directives] of proc_dir_rec=
         ((naam:'ALIAS'     ;handler:pd_alias   ;flag:0            ;body:true ;global:false;
            mut_excl:poinline+poexternal),
          (naam:'ASSEMBLER' ;handler:nil        ;flag:poassembler  ;body:true;global:false;
            mut_excl:poinline+pointernproc+poexternal),
          {
          (naam:'C'         ;handler:pd_c_import;flag:poclearstack ;body:false;global:false;
            mut_excl:poleftright+poinline+poassembler+pointernproc),
          }
          (naam:'CDECL'         ;handler:pd_c_import;flag:poclearstack;body:true;global:false;
            mut_excl:poleftright+poinline+poassembler+pointernproc),
          (naam:'EXPORT'    ;handler:pd_export  ;flag:poexports    ;body:true ;global:true ;
            mut_excl:poexternal+poinline+pointernproc+pointerrupt),
          (naam:'EXTERNAL'  ;handler:pd_extern  ;flag:poexternal   ;body:false;global:false;
            mut_excl:poexports+poinline+pointernproc+pointerrupt+poassembler),
          (naam:'FAR'       ;handler:pd_far     ;flag:0            ;body:true ;global:false;
            mut_excl:pointernproc),
          (naam:'FORWARD'   ;handler:pd_forward ;flag:0            ;body:false;global:false;
            mut_excl:pointernproc),
          (naam:'INLINE'    ;handler:pd_inline  ;flag:poinline     ;body:true ;global:false;
            mut_excl:poexports+poexternal+pointernproc+pointerrupt+poassembler+poconstructor+podestructor+pooperator),
          (naam:'INTERNPROC';handler:pd_intern  ;flag:pointernproc ;body:false;global:false;
            mut_excl:poexports+poexternal+pointerrupt+poassembler+poclearstack+poleftright+poiocheck+
                     poconstructor+podestructor+pooperator),
          (naam:'INTERRUPT' ;handler:nil        ;flag:pointerrupt  ;body:true ;global:false;
            mut_excl:pointernproc+poclearstack+poleftright+poinline+poconstructor+podestructor+pooperator),
          (naam:'IOCHECK'   ;handler:nil        ;flag:poiocheck    ;body:true ;global:false;
            mut_excl:pointernproc+poexternal),
          (naam:'NEAR'      ;handler:pd_near    ;flag:0            ;body:true ;global:false;
            mut_excl:pointernproc),
          {Use "Pascal" calling conventions, parameters from left to right. Combine
           with 'EXTERNAL' when it is external, the procedure compiled
           assumes left/right pushes. Currently recognised but not supported!}
          (naam:'PASCAL'    ;handler:pd_lefrig  ;flag:poleftright  ;body:true ;global:false;mut_excl:pointernproc),
          {Equal to 'SYSTEM', but doesn't assume the procedure is external,
           so the compiled procedure assumes it doesn't need to clear the
           stack. Can also be combined with external, in that case it is completely
           equal to 'SYSTEM'.}
          (naam:'POPSTACK'  ;handler:nil        ;flag:poclearstack ;body:true ;global:false;
            mut_excl:poinline+pointernproc+poassembler),
          (naam:'PUBLIC'    ;handler:nil        ;flag:0            ;body:true ;global:true ;
            mut_excl:pointernproc+poinline),
          (naam:'SYSCALL'    ;handler:pd_syscall  ;flag:popalmossyscall;body:false;global:false;
            mut_excl:poexports+poinline+pointernproc+pointerrupt+poassembler),
          (naam:'SYSTEM'    ;handler:pd_system  ;flag:poclearstack ;body:false;global:false;
            mut_excl:poleftright+poinline+poassembler+pointernproc));
{$ELSE}
        proc_direcdata:array[1..num_proc_directives] of proc_dir_rec=
         ((naam:'ALIAS'     ;handler:@pd_alias   ;flag:0            ;body:true ;global:false;
            mut_excl:poinline+poexternal),
          (naam:'ASSEMBLER' ;handler:nil         ;flag:poassembler  ;body:true ;global:false;
            mut_excl:poinline+pointernproc+poexternal),
          {
          (naam:'C'         ;handler:@pd_c_import;flag:poclearstack ;body:false;global:false;
            mut_excl:poleftright+poinline+poassembler+pointernproc),
          }
          (naam:'CDECL'         ;handler:@pd_c_import;flag:poclearstack;body:true;global:false;
            mut_excl:poleftright+poinline+poassembler+pointernproc),
          (naam:'EXPORT'    ;handler:@pd_export  ;flag:poexports    ;body:true ;global:true ;
            mut_excl:poexternal+poinline+pointernproc+pointerrupt),
          (naam:'EXTERNAL'  ;handler:@pd_extern  ;flag:poexternal   ;body:false;global:false;
            mut_excl:poexports+poinline+pointernproc+pointerrupt+poassembler),
          (naam:'FAR'       ;handler:@pd_far     ;flag:0            ;body:true ;global:false;
            mut_excl:pointernproc),
          (naam:'FORWARD'   ;handler:@pd_forward ;flag:0            ;body:false;global:false;
            mut_excl:pointernproc),
          (naam:'INLINE'    ;handler:@pd_inline  ;flag:poinline     ;body:true ;global:false;
            mut_excl:poexports+poexternal+pointernproc+pointerrupt+poassembler+poconstructor+podestructor+pooperator),
          (naam:'INTERNPROC';handler:@pd_intern  ;flag:pointernproc ;body:false;global:false;
            mut_excl:poexports+poexternal+pointerrupt+poassembler+poclearstack+poleftright+poiocheck+
                     poconstructor+podestructor+pooperator),
          (naam:'INTERRUPT' ;handler:nil         ;flag:pointerrupt  ;body:true ;global:false;
            mut_excl:pointernproc+poclearstack+poleftright+poinline+poconstructor+podestructor+pooperator),
          (naam:'IOCHECK'   ;handler:nil        ;flag:poiocheck    ;body:true ;global:false;
            mut_excl:pointernproc+poexternal),
          (naam:'NEAR'      ;handler:@pd_near    ;flag:0            ;body:true ;global:false;
            mut_excl:pointernproc),
          {Use "Pascal" calling conventions, parameters from left to right. Combine
           with 'EXTERNAL' when it is external, the procedure compiled
           assumes left/right pushes. Currently recognised but not supported!}
          (naam:'PASCAL'    ;handler:@pd_lefrig  ;flag:poleftright  ;body:true ;global:false;
            mut_excl:pointernproc),
          {Equal to 'SYSTEM', but doesn't assume the procedure is external,
           so the compiled procedure assumes it doesn't need to clear the
           stack. Can also be combined with external, in that case it is completely
           equal to 'SYSTEM'.}
          (naam:'POPSTACK'  ;handler:nil         ;flag:poclearstack ;body:true ;global:false;
            mut_excl:poinline+pointernproc+poassembler),
          (naam:'PUBLIC'    ;handler:nil         ;flag:0            ;body:true ;global:true ;
            mut_excl:pointernproc+poinline),
          (naam:'SYSCALL'    ;handler:@pd_syscall  ;flag:popalmossyscall ;body:false;global:false;
            mut_excl:poexports+poinline+pointernproc+pointerrupt+poassembler),
          (naam:'SYSTEM'    ;handler:@pd_system  ;flag:poclearstack ;body:false;global:false;
            mut_excl:poleftright+poinline+poassembler+pointernproc));
{$ENDIF TP}

var p,w:word;
    s:boolean;

begin
    s:=aktprocsym^.definition^.options and poassembler<>0;
    {15 letters should be enough, but give protection if someone tries a
     longer one. Also check if the flag is already used.}
    if (length(naam)>15) then
        begin
          Message1(parser_w_unknown_proc_directive_ignored,naam);
          exit;
        end;

    {Search the procedure directive in the array. We shoot with a bazooka
     on a bug, that is, we release a binary search.}
    w:=num_proc_directives_2log;
    p:=1;
    while w<>0 do
        begin
            if proc_direcdata[p+w].naam<=naam then
                p:=p+w;
            w:=w shr 1;
        end;

    {Check if the procedure directive is known.}
    if naam<>proc_direcdata[p].naam then
     begin
       Message1(parser_w_unknown_proc_directive_ignored,naam);
       exit;
     end;

    {Check if the flag is alread used.}
    if aktprocsym^.definition^.options and (proc_direcdata[p].flag+
     proc_direcdata[p].mut_excl)<>0 then
        {The touch of perfection: Determine which error message is
         more usefull.}
        if s then
            consume(_ASM)
        else
            consume(_BEGIN);

    {Return the correct body and make_global parameters.}
    body:=proc_direcdata[p].body;
    make_global:=proc_direcdata[p].global;

    {Add the correct flag.}
    aktprocsym^.definition^.options:=aktprocsym^.definition^.options or
     proc_direcdata[p].flag;

    {Call the handler.}
{$IFDEF TP}
    if @proc_direcdata[p].handler<>nil then
        proc_direcdata[p].handler(proc_names);
{$ELSE}
    if pointer(proc_direcdata[p].handler)<>nil then
        proc_direcdata[p].handler(proc_names);
{$ENDIF TP}
end;

{***************************************************************************}

function check_identical:boolean;

{ Search for idendical definitions,
  if there is a forward, then kill this.

  Returns the result of the forward check.

  Removed from unter_dec to keep the source readable.}

const   {List of procedure options that affect the procedure type.}
        pt_params=poconstructor+podestructor+pooperator;

var hd,pd:Pprocdef;
    ad,fd:psym;

begin
    check_identical:=false;
    pd:=aktprocsym^.definition;
    while (assigned(pd)) and (assigned(pd^.nextoverloaded)) do
        begin
            if (cs_tp_compatible in aktswitches) or
             equal_paras(aktprocsym^.definition^.para1,
             pd^.nextoverloaded^.para1) then
                begin
                    if pd^.nextoverloaded^.forwarddef then
                        { remove the forward definition }
                        { but don't delete it,          }
                        { the symtable is the owner !!  }
                        begin
                            hd:=pd^.nextoverloaded;
                            {Check if the procedure type (constructor/
                             destructor/etc. and return type are correct.}
                            if ((hd^.options and pt_params)<>(aktprocsym^.
                             definition^.options and pt_params)) or
                             not(is_equal(hd^.retdef,aktprocsym^.
                             definition^.retdef)) then
                               Message1(parser_e_header_dont_match_forward,'');

                            { change the name }
                            { this should have been set already, no ? }
                            if (hd^.mangledname<>aktprocsym^.definition^.mangledname) then
                                begin
                                if (aktprocsym^.definition^.options and poexternal)=0 then
                                    Message(parser_n_interface_name_diff_implementation_name);
                                  hd^.setmangledname(aktprocsym^.definition^.mangledname);
                                end
                             else
                               begin
                                  { If mangled names are equal, therefore    }
                                  { they have the same number of parameters  }
                                  { Therefore we can check the name of these }
                                  { parameters...                            }
                                  ad:=hd^.parast^.wurzel;
                                  fd:=aktprocsym^.definition^.parast^.wurzel;
                                  if assigned(ad) and assigned(fd) then
                                  begin
                                    while assigned(ad) and assigned(fd) do
                                      begin
                                        if ad^.name<>fd^.name then
                                         begin
                                           Message1(parser_e_header_dont_match_forward,ad^.name);
                                           break;
                                         end;
                                         { it is impossible to have a nil pointer }
                                         { for only one parameter - since they    }
                                         { have the same number of parameters.    }
                                         { Left = next parameter.                 }
                                         ad:=ad^.left;
                                         fd:=fd^.left;
                                      end;
                                  end;
                               end;

                            { also the call_offset }
                            hd^.parast^.call_offset:=aktprocsym^.definition^.
                             parast^.call_offset;

                            { pd^.nextoverloaded aus der Liste an den Anfang }
                            { und aktprocsym^.definition aushaengen }
                            pd^.nextoverloaded:=pd^.nextoverloaded^.nextoverloaded;
                            hd^.nextoverloaded:=aktprocsym^.definition^.nextoverloaded;
                            {Alert! All fields of aktprocsym^.definition
                             that are modified by the procdir handlers
                             must be copied here!.}
                            hd^.forwarddef:=false;
                            if (hd^.options and pt_params)<>(aktprocsym^.
                             definition^.options and pt_params) then
                             Message(parser_e_syntax_error)
                            else
                                hd^.options:=hd^.options or aktprocsym^.definition^.options;
                            if aktprocsym^.definition^.extnumber=-1 then
                                aktprocsym^.definition^.extnumber:=hd^.extnumber
                            else
                                if hd^.extnumber=-1 then
                                    hd^.extnumber:=aktprocsym^.definition^.extnumber;
                            aktprocsym^.definition:=hd;
                            check_identical:=true;
                        end
                    else
                        { abstract methods aren't forward defined, but this }
                        { needs another error message                       }
                        if (pd^.nextoverloaded^.options and poabstractmethod)=0 then
                            Message(parser_e_overloaded_have_same_parameters)
                        else
                            Message(parser_e_abstract_no_definition);
                    break;
                end;
            pd:=pd^.nextoverloaded;
        end;
end;

procedure compile_proc_body(const proc_names:Tstringcontainer;
                            make_global,parent_has_class:boolean);

{Compile the body of a procedure.}

var oldexitlabel,oldexit2label,oldquickexitlabel:Plabel;
    _class:Pobjectdef;
    { switches can change inside the procedure }
    entryswitches, exitswitches : tcswitches;
    { code for the subroutine as tree }
    code:Ptree;
    { Gr”áe des lokalen Stackframes }
    stackframe:longint;
    { true wenn kein Stackframe erforderlich ist }
    nostackframe:boolean;
    { number of bytes which have to be cleared by RET }
    parasize:longint;
{$ifdef GDB}
    entrystack,exitstack, storestack:pinputfile;
    entryline, exitline, storeline:longint;
{$endif GDB}

begin
    oldexitlabel:=aktexitlabel;
    oldexit2label:=aktexit2label;
    oldquickexitlabel:=quickexitlabel;
    getlabel(aktexitlabel);
    getlabel(aktexit2label);

    { calculate the lexical level }
    inc(lexlevel);

    { enter allows only (?) 31 levels }
    { I think we don't need more      }
    if lexlevel>32 then
     Message(parser_e_too_much_lexlevel);

    { reset break and continue labels }
    in_except_block:=false;
    aktbreaklabel:=nil;
    aktcontinuelabel:=nil;

    { exit for fail in constructors }
    if (aktprocsym^.definition^.options and poconstructor)<>0 then
        getlabel(quickexitlabel);

    { insert symtables for the class, by only if it is no }
    { nested function                                     }
    if assigned(procinfo._class) and
     not(parent_has_class) then
        begin
            _class:=procinfo._class;
            while assigned(_class) do
                begin
                    _class^.publicsyms^.next:=symtablestack;
                    symtablestack:=_class^.publicsyms;
                    _class:=_class^.childof;
                end;
        end;

    { insert symbol tables }
    { and set the lexical level }
    { not for global }
    { if lexlevel>1 then }
      begin
         aktprocsym^.definition^.parast^.next:=symtablestack;
         symtablestack:=aktprocsym^.definition^.parast;
     {***RESTRUCT}
         symtablestack^.symtablelevel:=lexlevel;
         aktprocsym^.definition^.localst^.next:=symtablestack;
         symtablestack:=aktprocsym^.definition^.localst;
         symtablestack^.symtablelevel:=lexlevel;
      end;
{***}

    { constant symbols are inserted in this symboltable }
    constsymtable:=symtablestack;

    { reset the temporary memory }
    cleartempgen;

    { no registers are used }
    usedinproc:=0;
{$ifdef GDB}
    entrystack:=current_module^.current_inputfile;
    entryline:=current_module^.current_inputfile^.line_no;
{$endif * GDB *}

    entryswitches:=aktswitches;

    { parse the code ... }
    if (aktprocsym^.definition^.options and poassembler)<> 0 then
        code:=assembler_block
    else
        code:=block(false);
    exitswitches:=aktswitches;

    {When we are called to compile the body of a unit, aktprocsym should
     point to the unit initialization. If the unit has no initialization,
     aktprocsym=nil. But in that case code=nil. hus we should check for
     code=nil, when we use aktprocsym.}

    { set the framepointer to esp for assembler functions }
    { but only if the are no local variables NOR any      }
    { parameters!                                         }
    if assigned(code) and
     ((aktprocsym^.definition^.options and poassembler)<>0) and
     (aktprocsym^.definition^.parast^.datasize=0) and
     (aktprocsym^.definition^.localst^.datasize=0) then
        begin
{***IMPROVED}
{The stack_pointer constant is declared in the procecessor specific unit,
 such as i386.pas.}
            procinfo.framepointer:=stack_pointer;
{***}
            { set the right value for parameters }
            dec(aktprocsym^.definition^.parast^.call_offset,4);
            dec(procinfo.call_offset,4);
        end;
{$ifdef GDB}
    exitstack := current_module^.current_inputfile;
    exitline := current_module^.current_inputfile^.line_no;
    setfirsttemp(procinfo.firsttemp);
{$endif * GDB *}

    { ... and generate assembler }
    { but set the right switches for entry !! }
    aktswitches:=entryswitches;

    if assigned(code) then
        generatecode(code);

    { set switches to status at end of procedure }
    aktswitches:=exitswitches;

    if assigned(code) then
        begin
            { inline procedure ?? }
            if (aktprocsym^.definition^.options and poinline)=0 then
                { ...no, the code isn't needed }
                disposetree(code)
            else
                aktprocsym^.definition^.code:=code;
        end;

    { dec(lexlevel); moved to the end (PM) }
{$ifdef GDB}
    storeline := entrystack^.line_no;
    entrystack^.line_no := entryline;
    storestack := current_module^.current_inputfile;
    current_module^.current_inputfile := entrystack;
{$endif * GDB *}

    if assigned(code) then
        begin
            { the procedure is no defined }
            aktprocsym^.definition^.forwarddef:=false;
            aktprocsym^.definition^.usedregisters:=usedinproc;
        end;

    stackframe:=gettempsize;
{$ifdef GDB}
    { only now we can remove the temps }
    resettempgen;

    if assigned(code) then
        genentrycode(proc_names,make_global,stackframe,parasize,
         nostackframe);

    entrystack^.line_no := storeline;
    storeline := exitstack^.line_no;
    exitstack^.line_no := exitline;
    current_module^.current_inputfile := exitstack;
{$endif * GDB *}

    if assigned(code) then
        begin
            genexitcode(parasize,nostackframe);

            procinfo.aktproccode^.insertlist(procinfo.aktentrycode);
            procinfo.aktproccode^.concatlist(procinfo.aktexitcode);
{$ifdef i386}
            if (cs_optimize in aktswitches) and
            { no asm block allowed }
              ((procinfo.flags and pi_uses_asm)=0)  then
                peepholeopt(procinfo.aktproccode);
{$endif}
{$ifdef MAKELIB}
            { start a new file }
            { could be done at lexlevel 1 only }
            { but to separate underprocs will permit to }
            { discard unused ones }
            codesegment^.concat(new(pai_cut,init));
{$endif MAKELIB}
            codesegment^.concatlist(procinfo.aktproccode);
        end;

    { ... remove symbol tables }
    symtablestack:=symtablestack^.next^.next;

    { ... check for unused symbols      }
    { but only if there is no asm block }
    if assigned(code) and not((procinfo.flags and pi_uses_asm)<>0) then
        begin
            aktprocsym^.definition^.localst^.allsymbolsused;
            aktprocsym^.definition^.parast^.allsymbolsused;
        end;

    { the local symtables can be deleted, but the parast }
    { doesn't, (checking definitons when calling a       }
    { function                                           }
    if assigned(code) then
        begin
            dispose(aktprocsym^.definition^.localst,done);
            aktprocsym^.definition^.localst:=nil;
        end;

    { remove class member symbol tables }
    while symtablestack^.symtabletype=objectsymtable do
        symtablestack:=symtablestack^.next;

{$ifdef GDB}
    current_module^.current_inputfile := storestack;
    exitstack^.line_no := storeline;
{$endif GDB}
    dec(lexlevel);
    aktexitlabel:=oldexitlabel;
    aktexit2label:=oldexit2label;
    quickexitlabel:=oldquickexitlabel;
end;

procedure parse_proc_directives(Anames:Pstringcontainer;
                                var make_global,parse_body:boolean);

{Parse the procedure directives. Unlike the original code, it does not matter
 if procedure directives are written using ;procdir; or ['procdir'] syntax.
 I did this, because I do not see any logic in the separation.}

var naam:string;
    global,body:boolean;

begin
    while token in [ID,LECKKLAMMER] do
        begin
            if token=LECKKLAMMER then
                begin
                    consume(LECKKLAMMER);
                    repeat
                        naam:=pattern;
                        consume(ID);
                        parse_proc_direc(naam,Anames^,body,global);
                        if not body then
                            parse_body:=false;
                        if global then
                            make_global:=true;
                        if token=COMMA then
                            consume(COMMA)
                        else
                            break;
                    until false;
                    consume(RECKKLAMMER);
                end
            else
                begin
                    naam:=pattern;
                    consume(ID);
                    parse_proc_direc(naam,Anames^,body,make_global);
                    if not body then
                        parse_body:=false;
                end;
            {A procedure directive is always followed by a
             semicolon.}
            consume(SEMICOLON);
        end;
end;

procedure unter_dec;

{Parses the procedure directives, then parses the procedure body, then
 generates the code for it.}

{******This procedure has been dramatically rewritten by me (DM), because
 I found it more looking like spaghetti than code. I hope you like the
 new structure...}

var oldprocsym:Pprocsym;
    oldprocinfo:tprocinfo;

    oldconstsymtable:Psymtable;

    names:Pstringcontainer;

    {True if the procedure will be exported.}
    global:boolean;

    {True if the procedure is a forward declaration.}
    was_forward:boolean;

    {True if the procedure body should be parsed.}
    body:boolean;

    oldprefix:string;

begin
    oldprocsym:=aktprocsym;
    oldprefix:=procprefix;
    oldconstsymtable:=constsymtable;
    oldprocinfo:=procinfo;
    procinfo.parent:=@oldprocinfo;
    codegen_newprocedure;

    { clear flags }
    procinfo.flags:=0;

    { standard frame pointer }
{***IMPROVED}
    procinfo.framepointer:=frame_pointer;
{***}
{$ifdef GDB}
    procinfo.funcret_is_valid:=false;
{$endif GDB}
    { is this a nested function of a method ? }
    procinfo._class:=oldprocinfo._class;

    proc_head;

    { set return type }
    procinfo.retdef:=aktprocsym^.definition^.retdef;

    { pointer to the return value ? }
    if ret_in_param(procinfo.retdef) then
        begin
            procinfo.retoffset:=procinfo.call_offset;
            if (procinfo.flags and pooperator)<>0 then
                opsym^.address:=0;
            inc(procinfo.call_offset,4);
        end;

    { allows to access the parameters of main functions in nested functions }
    aktprocsym^.definition^.parast^.call_offset := procinfo.call_offset;

    { parse only a header ? }
    if not parse_only then
        begin
            { EXPORT needs this }
            new(names,init);
            names^.doubles:=false;
            global:=false;
            body:=true;
            procinfo.exported:=false;
            aktprocsym^.definition^.forwarddef:=false;

            parse_proc_directives(names,global,body);

            was_forward:=check_identical;

            {A method must be forward defined (in the object declaration).}
            if assigned(procinfo._class) and
              not(assigned(oldprocinfo._class)) and
             not(was_forward) then
                Message(parser_e_header_dont_match_any_member);

            if not(was_forward) and ((procinfo.flags and
             pi_is_global)<>0) then
              Message(parser_e_overloaded_must_be_all_global);

            { write some informations }
            Message3(parser_p_procedure_start,aktprocsym^.name,aktprocsym^.definition^.mangledname,
                     tostr(current_module^.current_inputfile^.line_no));

            {Not needed. I have added a popstack directive.
            if procinfo.exported then
                aktprocsym^.definition^.options:=aktprocsym^.definition^.
                 options or poclearstack;}

            if body then
                begin
                    names^.insert(aktprocsym^.definition^.mangledname);
                    compile_proc_body(names^,global,
                     assigned(oldprocinfo._class));
                    consume(SEMICOLON);
                end;
            names^.done;
        end
    else
     begin
        if (token=ID) and (pattern='FAR') then
        Begin
          Message(parser_w_proc_far_ignored);
          consume(ID);
          consume(SEMICOLON);
        end;
        aktprocsym^.properties:=aktprocsym^.properties or sp_forwarddef;
     end;
    constsymtable:=oldconstsymtable;
    aktprocsym:=oldprocsym;
    procprefix:=oldprefix;
    codegen_doneprocedure;
    procinfo:=oldprocinfo;
end;

end.

{
  $Log: psub.pas,v $
  Revision 1.3.2.4  1998/08/22 10:23:00  florian
    * quick fix of procedure(...);cdecl;export;, the label was
      written two times with the same name

  Revision 1.3.2.3  1998/08/13 17:41:26  florian
    + some stuff for the PalmOS added

  Revision 1.3.2.2  1998/08/05 14:07:35  pierre
    * changed assembler statement so that a stack frame is generated
      if there are arguments

  Revision 1.3.2.1  1998/07/10 12:26:35  carl
    * bugfix with crash on duplivate procedure

  Revision 1.3  1998/03/30 21:04:00  florian
    * new version 0.99.5
    + cdecl id

  Revision 1.2  1998/03/28 23:09:57  florian
    * secondin bugfix (m68k and i386)
    * overflow checking bugfix (m68k and i386) -- pretty useless in
      secondadd, since everything is done using 32-bit
    * loading pointer to routines hopefully fixed (m68k)
    * flags problem with calls to RTL internal routines fixed (still strcmp
      to fix) (m68k)
    * #ELSE was still incorrect (didn't take care of the previous level)
    * problem with filenames in the command line solved
    * problem with mangledname solved
    * linking name problem solved (was case insensitive)
    * double id problem and potential crash solved
    * stop after first error
    * and=>test problem removed
    * correct read for all float types
    * 2 sigsegv fixes and a cosmetic fix for Internal Error
    * push/pop is now correct optimized (=> mov (%esp),reg)

  Revision 1.1.1.1  1998/03/25 11:18:14  root
  * Restored version

  Revision 1.40  1998/03/18 22:50:11  florian
    + fstp/fld optimization
    * routines which contains asm aren't longer optimzed
    * wrong ifdef TEST_FUNCRET corrected
    * wrong data generation for array[0..n] of char = '01234'; fixed
    * bug0097 is fixed partial
    * bug0116 fixed (-Og doesn't use enter of the stack frame is greater than
      65535)

  Revision 1.39  1998/03/10 16:27:43  pierre
    * better line info in stabs debug
    * symtabletype and lexlevel separated into two fields of tsymtable
    + ifdef MAKELIB for direct library output, not complete
    + ifdef CHAINPROCSYMS for overloaded seach across units, not fully
      working
    + ifdef TESTFUNCRET for setting func result in underfunction, not
      working

  Revision 1.38  1998/03/10 13:23:00  florian
    * small win32 problems fixed

  Revision 1.37  1998/03/10 01:17:25  peter
    * all files have the same header
    * messages are fully implemented, EXTDEBUG uses Comment()
    + AG... files for the Assembler generation

  Revision 1.36  1998/03/09 16:15:31  michael
  * fixed small typo of daniel

  Revision 1.35  1998/03/09 16:00:35  daniel
  Fixed the ;external; procdir for external procedures in .o files.

  Revision 1.34  1998/03/09 10:40:25  peter
    * removed warnings for [C] procedures

  Revision 1.33  1998/03/06 00:52:48  peter
    * replaced all old messages from errore.msg, only ExtDebug and some
      Comment() calls are left
    * fixed options.pas

  Revision 1.32  1998/03/05 22:43:52  florian
    * some win32 support stuff added

  Revision 1.31  1998/03/04 01:35:10  peter
    * messages for unit-handling and assembler/linker
    * the compiler compiles without -dGDB, but doesn't work yet
    + -vh for Hint

  Revision 1.30  1998/03/02 13:38:50  peter
    + importlib object
    * doesn't crash on a systemunit anymore
    * updated makefile and depend

  Revision 1.28  1998/02/28 03:55:31  carl
    * bugfix #101 (parameter name checking for interface/implementation)

  Revision 1.26  1998/02/27 22:28:00  florian
    + win_targ unit
    + support of sections
    + new asmlists: sections, exports and resource

  Revision 1.25  1998/02/27 21:24:10  florian
    * dll support changed (dll name can be also a string contants)

  Revision 1.24  1998/02/27 09:26:04  daniel
  * Changed symtable handling so no junk symtable is put on the symtablestack.

  Revision 1.23  1998/02/22 23:03:31  peter
    * renamed msource->mainsource and name->unitname
    * optimized filename handling, filename is not seperate anymore with
      path+name+ext, this saves stackspace and a lot of fsplit()'s
    * recompiling of some units in libraries fixed
    * shared libraries are working again
    + $LINKLIB <lib> to support automatic linking to libraries
    + libraries are saved/read from the ppufile, also allows more libraries
      per ppufile

  Revision 1.22  1998/02/20 20:32:57  carl
    - removed a comment

  Revision 1.21  1998/02/16 12:51:40  michael
  + Implemented linker object

  Revision 1.20  1998/02/16 08:43:00  daniel
  Fixed internproc bug.

  Revision 1.19  1998/02/13 10:35:30  daniel
  * Made Motorola version compilable.
  * Fixed optimizer

  Revision 1.18  1998/02/12 11:50:31  daniel
  Yes! Finally! After three retries, my patch!

  Changes:

  Complete rewrite of psub.pas.
  Added support for DLL's.
  Compiler requires less memory.
  Platform units for each platform.

  Revision 1.17  1998/02/02 11:49:15  pierre
    + warning if function return not set

  Revision 1.16  1998/02/02 00:55:34  peter
    * defdatei -> deffile and some german comments to english
    * search() accepts : as seperater under linux
    * search for ppc.cfg doesn't open a file (and let it open)
    * reorganize the reading of parameters/file a bit
    * all the PPC_ environments are now for all platforms

  Revision 1.15  1998/02/01 22:41:12  florian
    * clean up
    + system.assigned([class])
    + system.assigned([class of xxxx])
    * first fixes of as and is-operator

  Revision 1.14  1998/01/30 11:14:31  michael
  * Fixed bug that crashed the compiler. (From peters fix)

  Revision 1.13  1998/01/27 22:02:33  florian
    * small bug fix to the compiler work, I forgot a not(...):(

  Revision 1.12  1998/01/25 22:29:03  florian
    * a lot bug fixes on the DOM

  Revision 1.11  1998/01/21 02:17:32  carl
    - moved omitting stack frame stuff for assembler routines to
      pstatmnt otherwise would cause much problems in assembler blocks
      with local variables.

  Revision 1.9  1998/01/16 18:03:18  florian
    * small bug fixes, some stuff of delphi styled constructores added

  Revision 1.8  1998/01/12 13:03:33  florian
    + parsing of class methods implemented

  Revision 1.7  1998/01/11 17:06:40  carl
    * bugfix #69 (not 100% compatible with TP) -- see bug bug0073.pp

  Revision 1.6  1998/01/11 10:54:25  florian
    + generic library support

  Revision 1.5  1998/01/11 04:26:49  carl
    + stackframe checking added for m68k
    * bugfix of floating point values returns in proc.

  Revision 1.4  1998/01/09 23:08:33  florian
    + C++/Delphi styled //-comments
    * some bugs in Delphi object model fixed
    + override directive

  Revision 1.3  1998/01/09 13:39:56  florian
    * public, protected and private aren't anymore key words
    + published is equal to public

  Revision 1.2  1998/01/09 09:10:03  michael
  + Initial implementation, second try

}
