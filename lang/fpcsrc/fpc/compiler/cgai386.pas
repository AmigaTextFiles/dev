{
    $Id: cgai386.pas,v 1.4.2.1 1998/04/09 23:29:23 peter Exp $
    Copyright (c) 1993-98 by Florian Klaempfl

    This unit generates i386 (or better) assembler from the parse tree

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

 ****************************************************************************}

unit cgai386;

  interface

    uses
       objects,cobjects,systems,globals,tree,symtable,types,strings,
       pass_1,hcodegen,aasm,i386,tgeni386,files,verbose
{$ifdef GDB}
       ,gdb
{$endif GDB}
       ;

    procedure emitl(op : tasmop;var l : plabel);
    procedure emit_reg_reg(i : tasmop;s : topsize;reg1,reg2 : tregister);
    procedure emitcall(const routine:string;add_to_externals : boolean);
     procedure emitloadord2reg(location:Tlocation;orddef:Porddef;
                              destreg:Tregister;delloc:boolean);
    { produces jumps to true respectively false labels using boolean expressions }
    procedure maketojumpbool(p : ptree);
    procedure emitoverflowcheck(p:ptree);
    procedure push_int(l : longint);
    function maybe_push(needed : byte;p : ptree) : boolean;
    procedure restore(p : ptree);
    procedure emit_push_mem(const ref : treference);
    procedure emitpushreferenceaddr(const ref : treference);
     procedure swaptree(p:Ptree);
    procedure copystring(const dref,sref : treference;len : byte);
    procedure loadstring(p:ptree);
    procedure concatcopy(source,dest : treference;size : longint;delsource : boolean);
    { see implementation }
    procedure maybe_loadesi;

    procedure floatload(t : tfloattype;const ref : treference);
    procedure floatstore(t : tfloattype;const ref : treference);
    procedure floatloadops(t : tfloattype;var op : tasmop;var s : topsize);
    procedure floatstoreops(t : tfloattype;var op : tasmop;var s : topsize);

    procedure firstcomplex(p : ptree);
    procedure secondfuncret(var p : ptree);

    { initialize respectively terminates the code generator }
    { for a new module or procedure                         }
    procedure codegen_doneprocedure;
    procedure codegen_donemodule;
    procedure codegen_newmodule;
    procedure codegen_newprocedure;

    { generate entry code for a procedure.}
    procedure genentrycode(const proc_names:Tstringcontainer;make_global:boolean;
                           stackframe:longint;
                           var parasize:longint;var nostackframe:boolean);
    { generate the exit code for a procedure. }
    procedure genexitcode(parasize:longint;nostackframe:boolean);

  implementation

    {
    procedure genconstadd(size : topsize;l : longint;const str : string);

      begin
         if l=0 then
         else if l=1 then
           exprasmlist^.concat(new(pai386,op_A_INC,size,str)
         else if l=-1 then
           exprasmlist^.concat(new(pai386,op_A_INC,size,str)
         else
           exprasmlist^.concat(new(pai386,op_ADD,size,'$'+tostr(l)+','+str);
      end;
    }

    procedure copystring(const dref,sref : treference;len : byte);

      var
         pushed : tpushed;

      begin
         emitpushreferenceaddr(dref);
         emitpushreferenceaddr(sref);
         push_int(len);
         emitcall('STRCOPY',true);
         maybe_loadesi;
      end;

    procedure loadstring(p:ptree);
      begin
        case p^.right^.resulttype^.deftype of
         stringdef : begin
                       if (p^.right^.treetype=stringconstn) and
                          (p^.right^.values^='') then
                        exprasmlist^.concat(new(pai386,op_const_ref(
                           A_MOV,S_B,0,newreference(p^.left^.location.reference))))
                       else
                        copystring(p^.left^.location.reference,p^.right^.location.reference,
                           min(pstringdef(p^.right^.resulttype)^.len,pstringdef(p^.left^.resulttype)^.len));
                     end;
            orddef : begin
                       if p^.right^.treetype=ordconstn then
                         exprasmlist^.concat(new(pai386,op_const_ref(
                            A_MOV,S_W,p^.right^.value*256+1,newreference(p^.left^.location.reference))))
                       else
                         begin
                            { not so elegant (goes better with extra register }
                            if (p^.right^.location.loc in [LOC_REGISTER,LOC_CREGISTER]) then
                              begin
                                 exprasmlist^.concat(new(pai386,op_reg_reg(
                                    A_MOV,S_L,reg8toreg32(p^.right^.location.register),R_EDI)));
                                 ungetregister32(reg8toreg32(p^.right^.location.register));
                              end
                            else
                              begin
                                 exprasmlist^.concat(new(pai386,op_ref_reg(
                                    A_MOV,S_L,newreference(p^.right^.location.reference),R_EDI)));
                                 del_reference(p^.right^.location.reference);
                              end;
                            exprasmlist^.concat(new(pai386,op_const_reg(A_SHL,S_L,8,R_EDI)));
                            exprasmlist^.concat(new(pai386,op_const_reg(A_OR,S_L,1,R_EDI)));
                            exprasmlist^.concat(new(pai386,op_reg_ref(
                               A_MOV,S_W,R_DI,newreference(p^.left^.location.reference))));
                         end;
                     end;
        else
         Message(sym_e_type_mismatch);
        end;
      end;


    procedure restore(p : ptree);

      var
         hregister :  tregister;

      begin
         hregister:=getregister32;
         exprasmlist^.concat(new(pai386,op_reg(A_POP,S_L,hregister)));
         if (p^.location.loc in [LOC_REGISTER,LOC_CREGISTER]) then
          p^.location.register:=hregister
         else
           begin
              reset_reference(p^.location.reference);
              p^.location.reference.index:=hregister;
              set_location(p^.left^.location,p^.location);
           end;
      end;

    function maybe_push(needed : byte;p : ptree) : boolean;

      var
         pushed : boolean;
         {hregister : tregister; }

      begin
         if needed>usablereg32 then
           begin
              if (p^.location.loc in [LOC_REGISTER,LOC_CREGISTER]) then
                begin
                   pushed:=true;
                   exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,p^.location.register)));
                   ungetregister32(p^.location.register);
                end
              else if (p^.location.loc in [LOC_MEM,LOC_REFERENCE]) and
                      ((p^.location.reference.base<>R_NO) or
                       (p^.location.reference.index<>R_NO)
                      ) then
                  begin
                     del_reference(p^.location.reference);
                     exprasmlist^.concat(new(pai386,op_ref_reg(A_LEA,S_L,newreference(p^.location.reference),
                       R_EDI)));
                     exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,R_EDI)));
                     pushed:=true;
                  end
              else pushed:=false;
           end
         else pushed:=false;
         maybe_push:=pushed;
      end;

    procedure emitl(op : tasmop;var l : plabel);

      begin
         if op=A_LABEL then
           exprasmlist^.concat(new(pai_label,init(l)))
         else
           exprasmlist^.concat(new(pai_labeled,init(op,l)))
      end;

    procedure emit_reg_reg(i : tasmop;s : topsize;reg1,reg2 : tregister);

      begin
         if (reg1<>reg2) or (i<>A_MOV) then
           exprasmlist^.concat(new(pai386,op_reg_reg(i,s,reg1,reg2)));
      end;

    procedure emitcall(const routine:string;add_to_externals : boolean);

     begin
        exprasmlist^.concat(new(pai386,op_csymbol(A_CALL,S_NO,newcsymbol(routine,0))));
        if assem_need_external_list and add_to_externals and
           not (cs_compilesystem in aktswitches) then
          concat_external(routine,EXT_NEAR);
     end;

    procedure maketojumpbool(p : ptree);

      begin
         if p^.error then
           exit;
         if (p^.resulttype^.deftype=orddef) and
            (porddef(p^.resulttype)^.typ=bool8bit) then
           begin
              if is_constboolnode(p) then
                begin
                   if p^.value<>0 then
                     emitl(A_JMP,truelabel)
                   else emitl(A_JMP,falselabel);
                end
              else
                begin
                   case p^.location.loc of
                      LOC_CREGISTER,LOC_REGISTER : begin
                                        exprasmlist^.concat(new(pai386,op_reg_reg(A_OR,S_B,p^.location.register,
                                          p^.location.register)));
                                        ungetregister32(reg8toreg32(p^.location.register));
                                        emitl(A_JNZ,truelabel);
                                        emitl(A_JMP,falselabel);
                                     end;
                      LOC_MEM,LOC_REFERENCE : begin
                                        exprasmlist^.concat(new(pai386,op_const_ref(
                                          A_CMP,S_B,0,newreference(p^.location.reference))));
                                        del_reference(p^.location.reference);
                                        emitl(A_JNZ,truelabel);
                                        emitl(A_JMP,falselabel);
                                     end;
                      LOC_FLAGS : begin
                                     emitl(flag_2_jmp[p^.location.resflags],truelabel);
                                     emitl(A_JMP,falselabel);
                                  end;
                   end;
                end;
           end
         else
           Message(sym_e_type_mismatch);
      end;

    procedure emitoverflowcheck(p:ptree);

      var
         hl : plabel;

      begin
         if cs_check_overflow in aktswitches  then
           begin
              getlabel(hl);
              if not ((p^.resulttype^.deftype=pointerdef) or
                     ((p^.resulttype^.deftype=orddef) and
                (porddef(p^.resulttype)^.typ in [u16bit,u32bit,u8bit,uchar,bool8bit]))) then
                emitl(A_JNO,hl)
              else
                emitl(A_JNB,hl);
              emitcall('RE_OVERFLOW',true);
              emitl(A_LABEL,hl);
           end;
      end;

    procedure push_int(l : longint);

      begin
         if (opt_processors<>globals.i386) and not(cs_littlesize in aktswitches) then
           begin
              if l=0 then
                begin
                   exprasmlist^.concat(new(pai386,op_reg_reg(
                     A_XOR,S_L,R_EDI,R_EDI)));
                   exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,R_EDI)));
                end
              else
                exprasmlist^.concat(new(pai386,op_const(A_PUSH,S_L,l)));
           end
         else
            exprasmlist^.concat(new(pai386,op_const(A_PUSH,S_L,l)));
      end;

    procedure emit_push_mem(const ref : treference);

      begin
         if ref.isintvalue then
           push_int(ref.offset)
         else
           begin
              if (opt_processors<>globals.i386) and not(cs_littlesize in aktswitches) then
                begin
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,newreference(ref),R_EDI)));
                   exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,R_EDI)));
                end
              else exprasmlist^.concat(new(pai386,op_ref(A_PUSH,S_L,newreference(ref))));
           end;
      end;

    procedure emitpushreferenceaddr(const ref : treference);

      var href : treference;
      begin
         { this will fail for references to other segments !!! }
         if ref.isintvalue then
         { is this right ? }
           begin
              { push_int(ref.offset)}
              gettempofsizereference(4,href);
              exprasmlist^.concat(new(pai386,op_const_ref(A_MOV,S_L,ref.offset,newreference(href))));
              emitpushreferenceaddr(href);
              del_reference(href);
              {internalerror(11111); for test }
              { this temp will be lost ?! }
           end
         else
           begin
              if ref.segment<>R_DEFAULT_SEG then
                Message(cg_e_cant_use_far_pointer_there);
              if (ref.base=R_NO) and (ref.index=R_NO) then
                exprasmlist^.concat(new(pai386,op_csymbol(A_PUSH,S_L,newcsymbol(ref.symbol^,ref.offset))))
              else if (ref.base=R_NO) and (ref.index<>R_NO) and
                 (ref.offset=0) and (ref.scalefactor=0) and (ref.symbol=nil) then
                exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,ref.index)))
              else if (ref.base<>R_NO) and (ref.index=R_NO) and
                 (ref.offset=0) and (ref.symbol=nil) then
                exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,ref.base)))
              else
                begin
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_LEA,S_L,newreference(ref),R_EDI)));
                   exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,R_EDI)));
                end;
           end;
        end;

    procedure swaptree(p:Ptree);

    var swapp:Ptree;

    begin
        swapp:=p^.right;
        p^.right:=p^.left;
        p^.left:=swapp;
        p^.swaped:=not(p^.swaped);
    end;

    procedure concatcopy(source,dest : treference;size : longint;delsource : boolean);

      const
         isizes : array[0..3] of topsize=(S_L,S_B,S_W,S_B);
         ishr : array[0..3] of byte=(2,0,1,0);

      var
         ecxpushed : boolean;
         helpsize : longint;
         i : byte;
         reg8,reg32 : tregister;
         swap : boolean;

      begin
         if delsource then
           del_reference(source);

         if (size<=8) or (not(cs_littlesize in aktswitches ) and (size<=12)) then
           begin
              helpsize:=size shr 2;
              for i:=1 to helpsize do
                begin
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,newreference(source),R_EDI)));
                   exprasmlist^.concat(new(pai386,op_reg_ref(A_MOV,S_L,R_EDI,newreference(dest))));
                   inc(source.offset,4);
                   inc(dest.offset,4);
                   dec(size,4);
                end;
              if size>1 then
                begin
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_W,newreference(source),R_DI)));
                   exprasmlist^.concat(new(pai386,op_reg_ref(A_MOV,S_W,R_DI,newreference(dest))));
                   inc(source.offset,2);
                   inc(dest.offset,2);
                   dec(size,2);
                end;
              if size>0 then
                begin

                   { and now look for an 8 bit register }
                   swap:=false;
                   if R_EAX in unused then reg8:=R_AL
                   else if R_EBX in unused then reg8:=R_BL
                   else if R_ECX in unused then reg8:=R_CL
                   else if R_EDX in unused then reg8:=R_DL
                   else
                      begin
                         swap:=true;

                         { we need only to check 3 registers, because }
                         { one is always not index or base            }
                         if (dest.base<>R_EAX) and (dest.index<>R_EAX) then
                           begin
                              reg8:=R_AL;
                              reg32:=R_EAX;
                           end
                         else if (dest.base<>R_EBX) and (dest.index<>R_EBX) then
                           begin
                              reg8:=R_BL;
                              reg32:=R_EBX;
                           end
                         else if (dest.base<>R_ECX) and (dest.index<>R_ECX) then
                           begin
                              reg8:=R_CL;
                              reg32:=R_ECX;
                           end;
                      end;
                   if swap then
                     { was earlier XCHG, of course nonsense }
                     emit_reg_reg(A_MOV,S_L,reg32,R_EDI);
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_B,newreference(source),reg8)));
                   exprasmlist^.concat(new(pai386,op_reg_ref(A_MOV,S_B,reg8,newreference(dest))));
                   if swap then
                     emit_reg_reg(A_MOV,S_L,R_EDI,reg32);
                end;
           end
         else
           begin
              exprasmlist^.concat(new(pai386,op_ref_reg(A_LEA,S_L,newreference(dest),R_EDI)));
              exprasmlist^.concat(new(pai386,op_ref_reg(A_LEA,S_L,newreference(source),R_ESI)));
              if not(R_ECX in unused) then
                begin
                   exprasmlist^.concat(new(pai386,op_reg(A_PUSH,S_L,R_ECX)));
                   ecxpushed:=true;
                end
              else ecxpushed:=false;
              exprasmlist^.concat(new(pai386,op_none(A_CLD,S_NO)));
              if cs_littlesize in aktswitches  then
                begin
                   exprasmlist^.concat(new(pai386,op_const_reg(A_MOV,S_L,size shr ishr[size and 3],R_ECX)));
                   exprasmlist^.concat(new(pai386,op_none(A_REP,S_NO)));
                   exprasmlist^.concat(new(pai386,op_none(A_MOVS,isizes[size and 3])));
                end
              else
                begin
                   helpsize:=size-size and 3;
                   size:=size and 3;
                   exprasmlist^.concat(new(pai386,op_const_reg(A_MOV,S_L,helpsize shr 2,R_ECX)));
                   exprasmlist^.concat(new(pai386,op_none(A_REP,S_NO)));
                   exprasmlist^.concat(new(pai386,op_none(A_MOVS,S_L)));
                   if size>1 then
                     begin
                        dec(size,2);
                        exprasmlist^.concat(new(pai386,op_none(A_MOVS,S_W)));
                     end;
                   if size=1 then
                     exprasmlist^.concat(new(pai386,op_none(A_MOVS,S_B)));
                end;
              if ecxpushed then
                exprasmlist^.concat(new(pai386,op_reg(A_POP,S_L,R_ECX)));

              { loading SELF-reference again }
              maybe_loadesi;

              if delsource then
                ungetiftemp(source);
           end;
      end;


    procedure emitloadord2reg(location:Tlocation;orddef:Porddef;
                              destreg:Tregister;delloc:boolean);

    {A lot smaller and less bug sensitive than the original unfolded loads.}

    var tai:Pai386;
        r:Preference;

    begin
        case location.loc of
            LOC_REGISTER,LOC_CREGISTER:
                begin
                    case orddef^.typ of
                        u8bit:
                            tai:=new(pai386,op_reg_reg(A_MOVZX,S_BL,location.register,destreg));
                        s8bit:
                            tai:=new(pai386,op_reg_reg(A_MOVSX,S_BL,location.register,destreg));
                        u16bit:
                            tai:=new(pai386,op_reg_reg(A_MOVZX,S_WL,location.register,destreg));
                        s16bit:
                            tai:=new(pai386,op_reg_reg(A_MOVSX,S_WL,location.register,destreg));
                        u32bit:
                            tai:=new(pai386,op_reg_reg(A_MOV,S_L,location.register,destreg));
                        s32bit:
                            tai:=new(pai386,op_reg_reg(A_MOV,S_L,location.register,destreg));
                    end;
                    if delloc then
                        ungetregister(location.register);
                end;
            LOC_REFERENCE:
                begin
                    r:=newreference(location.reference);
                    case orddef^.typ of
                        u8bit:
                            tai:=new(pai386,op_ref_reg(A_MOVZX,S_BL,r,destreg));
                        s8bit:
                            tai:=new(pai386,op_ref_reg(A_MOVSX,S_BL,r,destreg));
                        u16bit:
                            tai:=new(pai386,op_ref_reg(A_MOVZX,S_WL,r,destreg));
                        s16bit:
                            tai:=new(pai386,op_ref_reg(A_MOVSX,S_WL,r,destreg));
                        u32bit:
                            tai:=new(pai386,op_ref_reg(A_MOV,S_L,r,destreg));
                        s32bit:
                            tai:=new(pai386,op_ref_reg(A_MOV,S_L,r,destreg));
                    end;
                    if delloc then
                        del_reference(location.reference);
                end
            else
                internalerror(6);
        end;
        exprasmlist^.concat(tai);
    end;

    { if necessary ESI is reloaded after a call}
    procedure maybe_loadesi;

      var
         hp : preference;
         p : pprocinfo;
         i : longint;

      begin
         if assigned(procinfo._class) then
           begin
              if lexlevel>2 then
                begin
                   new(hp);
                   reset_reference(hp^);
                   hp^.offset:=procinfo.framepointer_offset;
                   hp^.base:=procinfo.framepointer;
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hp,R_ESI)));
                   p:=procinfo.parent;
                   for i:=3 to lexlevel-1 do
                     begin
                        new(hp);
                        reset_reference(hp^);
                        hp^.offset:=p^.framepointer_offset;
                        hp^.base:=R_ESI;
                        exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hp,R_ESI)));
                        p:=p^.parent;
                     end;
                   new(hp);
                   reset_reference(hp^);
                   hp^.offset:=p^.ESI_offset;
                   hp^.base:=R_ESI;
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hp,R_ESI)));
                end
              else
                begin
                   new(hp);
                   reset_reference(hp^);
                   hp^.offset:=procinfo.ESI_offset;
                   hp^.base:=procinfo.framepointer;
                   exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hp,R_ESI)));
                end;
           end;
      end;

    procedure floatloadops(t : tfloattype;var op : tasmop;var s : topsize);

      begin
         case t of
            s32real : begin
                         op:=A_FLD;
                         s:=S_S;
                      end;
            s64real : begin
                         op:=A_FLD;
                         { ???? }
                         s:=S_L;
                      end;
            s80real : begin
                         op:=A_FLD;
                         { this made a problem }
                         { s:=S_Q;}
                         s:=S_X;
                      end;
            s64bit : begin
                         op:=A_FILD;
                         s:=S_Q;
                      end;
            else internalerror(17);
         end;
      end;

    procedure floatload(t : tfloattype;const ref : treference);

      var
         op : tasmop;
         s : topsize;

      begin
         floatloadops(t,op,s);
         exprasmlist^.concat(new(pai386,op_ref(op,s,
           newreference(ref))));
      end;

    procedure floatstoreops(t : tfloattype;var op : tasmop;var s : topsize);

      begin
         case t of
            s32real : begin
                         op:=A_FSTP;
                         s:=S_S;
                      end;
            s64real : begin
                         op:=A_FSTP;
                         s:=S_L;
                      end;
            s80real : begin
                         op:=A_FSTP;
                         { this made a problem }
                         { s:=S_Q;}
                          s:=S_X;
                      end;
            s64bit : begin
                         op:=A_FISTP;
                         s:=S_Q;
                      end;
            else internalerror(17);
         end;
      end;

    procedure floatstore(t : tfloattype;const ref : treference);

      var
         op : tasmop;
         s : topsize;

      begin
         floatstoreops(t,op,s);
         exprasmlist^.concat(new(pai386,op_ref(op,s,
           newreference(ref))));
      end;

    procedure firstcomplex(p : ptree);

      var
         hp : ptree;

      begin
         { always calculate boolean AND and OR from left to right }
         if ((p^.treetype=orn) or (p^.treetype=andn)) and
           (p^.left^.resulttype^.deftype=orddef) and
           (porddef(p^.left^.resulttype)^.typ=bool8bit) then
           p^.swaped:=false
         else if (p^.left^.registers32<p^.right^.registers32)

           { the following check is appropriate, because all }
           { 4 registers are rarely used and it is thereby   }
           { achieved that the extra code is being dropped   }
           { by exchanging not commutative operators         }
           and (p^.right^.registers32<=4) then
           begin
              hp:=p^.left;
              p^.left:=p^.right;
              p^.right:=hp;
              p^.swaped:=true;
           end
         else p^.swaped:=false;
      end;

    procedure secondfuncret(var p : ptree);

      var
         hregister : tregister;

      begin
         clear_reference(p^.location.reference);
{$ifndef TEST_FUNCRET}
         p^.location.reference.base:=procinfo.framepointer;
         p^.location.reference.offset:=procinfo.retoffset;
         if ret_in_param(procinfo.retdef) then
{$else TEST_FUNCRET}
         if @procinfo<>pprocinfo(p^.funcretprocinfo) then
           begin
              { walk up the stack frame }
              { not done yet !! }
           end
         else
           p^.location.reference.base:=pprocinfo(p^.funcretprocinfo)^.framepointer;
         p^.location.reference.offset:=pprocinfo(p^.funcretprocinfo)^.retoffset;
         if ret_in_param(p^.retdef) then
{$endif TEST_FUNCRET}
           begin
              hregister:=getregister32;
              exprasmlist^.concat(new(pai386,op_ref_reg(A_MOV,S_L,newreference(p^.location.reference),hregister)));
              p^.location.reference.base:=hregister;
              p^.location.reference.offset:=0;
           end;
      end;

    procedure codegen_newprocedure;

      begin
         aktbreaklabel:=nil;
         aktcontinuelabel:=nil;
         { aktexitlabel:=0; is store in oldaktexitlabel
           so it must not be reset to zero before this storage !}

         { the type of this lists isn't important }
         { because the code of this lists is      }
         { copied to the code segment             }
         procinfo.aktentrycode:=new(paasmoutput,init);
         procinfo.aktexitcode:=new(paasmoutput,init);
         procinfo.aktproccode:=new(paasmoutput,init);
      end;

    procedure codegen_doneprocedure;

      begin
         dispose(procinfo.aktentrycode,done);
         dispose(procinfo.aktexitcode,done);
         dispose(procinfo.aktproccode,done);
      end;

    procedure codegen_newmodule;

      begin
         exprasmlist:=new(paasmoutput,init);
      end;

    procedure codegen_donemodule;

      begin
         dispose(exprasmlist,done);
         dispose(codesegment,done);
         dispose(bsssegment,done);
         dispose(datasegment,done);
         dispose(debuglist,done);
         dispose(externals,done);
         dispose(consts,done);
      end;


  procedure genprofilecode;
    var
      pl : plabel;
    begin
      case target_info.target of
         target_linux:
           begin
              getlabel(pl);
              procinfo.aktentrycode^.insert(new(pai386,op_csymbol
                 (A_CALL,S_NO,newcsymbol('mcount',0))));
              procinfo.aktentrycode^.insert(new(pai386,op_csymbol_reg
                 (A_MOV,S_L,newcsymbol(lab2str(pl),0),R_EDX)));
              procinfo.aktentrycode^.insert(new(pai_direct,init(
                 strpnew('.text'))));
              procinfo.aktentrycode^.insert(new(pai_const,init_32bit(0)));
              procinfo.aktentrycode^.insert(new(pai_label,init(pl)));
              procinfo.aktentrycode^.insert(new(pai_align,init(4)));
              procinfo.aktentrycode^.insert(new(pai_direct,init(
                 strpnew('.data'))));
              concat_external('mcount',EXT_NEAR);
           end;
         target_go32v2:
           begin
              procinfo.aktentrycode^.insert(new(pai386,op_csymbol
                 (A_CALL,S_NO,newcsymbol('MCOUNT',0))));
              concat_external('MCOUNT',EXT_NEAR);
           end;
      end;
    end;                


  procedure genentrycode(const proc_names:Tstringcontainer;make_global:boolean;
                         stackframe:longint;
                         var parasize:longint;var nostackframe:boolean);

  {Generates the entry code for a procedure.}

  var hs:string;
      hp:Pused_unit;
      unitinits:taasmoutput;
  {$ifdef GDB}
      {oldaktprocname : string;}
      stab_function_name:Pai_stab_function_name;
  {$endif GDB}


  begin
      if (aktprocsym^.definition^.options and poproginit)<>0 then
          begin
              {Init the stack checking.}
              if (cs_check_stack in aktswitches) and
               (target_info.target=target_linux) then
                  begin
                      procinfo.aktentrycode^.insert(new(pai386,
                       op_csymbol(A_CALL,S_NO,newcsymbol('INIT_STACK_CHECK',0))));
                  end;

              unitinits.init;

              {Call the unit init procedures.}
              hp:=pused_unit(usedunits.first);
              while assigned(hp) do
                begin
                   { call the unit init code and make it external }
                   if (hp^.u^.flags and uf_init)<>0 then
                     begin
                        unitinits.concat(new(pai386,op_csymbol(A_CALL,S_NO,newcsymbol('INIT$$'+hp^.u^.unitname^,0))));
                        externals^.concat(new(pai_external,init('INIT$$'+hp^.u^.unitname^,EXT_NEAR)));
                     end;
                    hp:=Pused_unit(hp^.next);
                end;
              procinfo.aktentrycode^.insertlist(@unitinits);
              unitinits.done;
          end;

          { a constructor needs a help procedure }
          if (aktprocsym^.definition^.options and poconstructor)<>0 then
            begin
              if procinfo._class^.isclass then
                begin
                  procinfo.aktentrycode^.insert(new(pai_labeled,init(A_JZ,quickexitlabel)));
                  procinfo.aktentrycode^.insert(new(pai386,op_csymbol(A_CALL,S_NO,
                    newcsymbol('NEW_CLASS',0))));
                  concat_external('NEW_CLASS',EXT_NEAR);
                end
              else
                begin
                  procinfo.aktentrycode^.insert(new(pai_labeled,init(A_JZ,quickexitlabel)));
                  procinfo.aktentrycode^.insert(new(pai386,op_csymbol(A_CALL,S_NO,
                    newcsymbol('HELP_CONSTRUCTOR',0))));
                  concat_external('HELP_CONSTRUCTOR',EXT_NEAR);
                end;
            end;

      { don't load ESI, does the caller }

      { omit stack frame ? }
      if procinfo.framepointer=stack_pointer then
          begin
              Message(cg_d_stackframe_omited);
              nostackframe:=true;
              if (aktprocsym^.definition^.options and (pounitinit or poproginit)<>0) then
                parasize:=0
              else
                parasize:=aktprocsym^.definition^.parast^.datasize+procinfo.call_offset;
          end
      else
          begin
              if (aktprocsym^.definition^.options and (pounitinit or poproginit)<>0) then
                parasize:=0
              else
                parasize:=aktprocsym^.definition^.parast^.datasize+procinfo.call_offset-8;
              nostackframe:=false;
              if stackframe<>0 then
                  begin
                      if (cs_littlesize in aktswitches) and (stackframe<=65535) then
                          begin
                              if (cs_check_stack in aktswitches) and
                               (target_info.target<>target_linux) then
                                  begin
                                      procinfo.aktentrycode^.insert(new(pai386,
                                       op_csymbol(A_CALL,S_NO,newcsymbol('STACKCHECK',0))));
                                      procinfo.aktentrycode^.insert(new(pai386,op_const(A_PUSH,S_L,stackframe)));
                                  end;
                              if cs_profile in aktswitches then
                               genprofilecode;

                              if (target_info.target=target_linux) and
                               ((aktprocsym^.definition^.options and poexports)<>0) then
                                  procinfo.aktentrycode^.insert(new(Pai386,op_reg(A_PUSH,S_L,R_EDI)));

                              procinfo.aktentrycode^.insert(new(pai386,op_const_const(A_ENTER,S_NO,stackframe,0)))
                          end
                      else
                          begin
                              procinfo.aktentrycode^.insert(new(pai386,op_const_reg(A_SUB,S_L,stackframe,R_ESP)));
                              if (cs_check_stack in aktswitches) and (target_info.target<>target_linux) then
                                begin
                                   procinfo.aktentrycode^.insert(new(pai386,
                                     op_csymbol(A_CALL,S_NO,newcsymbol('STACKCHECK',0))));
                                   procinfo.aktentrycode^.insert(new(pai386,op_const(A_PUSH,S_L,stackframe)));
                                   concat_external('STACKCHECK',EXT_NEAR);
                                end;
                              if cs_profile in aktswitches then
                               genprofilecode;
                              procinfo.aktentrycode^.insert(new(pai386,op_reg_reg(A_MOV,S_L,R_ESP,R_EBP)));
                              procinfo.aktentrycode^.insert(new(pai386,op_reg(A_PUSH,S_L,R_EBP)));
                          end;
                  end { endif stackframe <> 0 }
              else
                 begin
                   if cs_profile in aktswitches then
                     genprofilecode;
                   procinfo.aktentrycode^.insert(new(pai386,op_reg_reg(A_MOV,S_L,R_ESP,R_EBP)));
                   procinfo.aktentrycode^.insert(new(pai386,op_reg(A_PUSH,S_L,R_EBP)));
                 end;
          end;

{              if cs_profile in aktswitches then
                  procinfo.aktentrycode^.insert(new(pai386,op_csymbol(A_CALL,S_NO,newcsymbol('MCOUNT',0))));
              if (target_info.target=target_linux) and
               ((aktprocsym^.definition^.options and poexports)<>0) then
                  procinfo.aktentrycode^.insert(new(Pai386,op_reg(A_PUSH,S_L,R_EDI))); !!!}

      if (aktprocsym^.definition^.options and pointerrupt)<>0 then
          generate_interrupt_stackframe_entry;

      if (cs_profile in aktswitches) or
         (aktprocsym^.definition^.owner^.symtabletype=globalsymtable) or
         ((procinfo._class<>nil) and (procinfo._class^.owner^.symtabletype=globalsymtable)) then
           make_global:=true;
      hs:=proc_names.get;

  {$IfDef GDB}
      if (cs_debuginfo in aktswitches) and
       target_info.use_function_relative_addresses then
          stab_function_name := new(pai_stab_function_name,init(strpnew(hs)));
      { oldaktprocname:=aktprocsym^.name;}
  {$EndIf GDB}

      while hs<>'' do
          begin
              if make_global then
                procinfo.aktentrycode^.insert(new(pai_symbol,init_global(hs)))
              else
                procinfo.aktentrycode^.insert(new(pai_symbol,init(hs)));

  {$ifdef GDB}
              if (cs_debuginfo in aktswitches) then
               begin
                 if target_info.use_function_relative_addresses then
                  procinfo.aktentrycode^.insert(new(pai_stab_function_name,init(strpnew(hs))));

              { This is not a nice solution to save the name, change it and restore when done }
              { not only not nice but also completely wrong !!! (PM) }
              {   aktprocsym^.setname(hs);
                 procinfo.aktentrycode^.insert(new(pai_stabs,init(aktprocsym^.stabstring))); }
               end;
  {$endif GDB}

              hs:=proc_names.get;
          end;

  {$ifdef GDB}
      {aktprocsym^.setname(oldaktprocname);}

      if (cs_debuginfo in aktswitches) then
          begin
              if target_info.use_function_relative_addresses then
                  procinfo.aktentrycode^.insert(stab_function_name);
              if make_global or ((procinfo.flags and pi_is_global) <> 0) then
                  aktprocsym^.is_global := True;
              {This is dead code! Because lexlevel is increased at the
               start of this procedure it can never be zero.}
  {           if (lexlevel > 1) and (oldprocsym^.definition^.localst^.name = nil) then
                  if oldprocsym^.owner^.symtabletype = objectsymtable then
                      oldprocsym^.definition^.localst^.name := stringdup(oldprocsym^.owner^.name^+'_'+oldprocsym^.name)
                  else
                      oldprocsym^.definition^.localst^.name := stringdup(oldprocsym^.name);}
              procinfo.aktentrycode^.insert(new(pai_stabs,init(aktprocsym^.stabstring)));
              aktprocsym^.isstabwritten:=true;
          end;
      { !!!!!! }
      { gprof uses 16 byte granularity !! }
      { space is filled with NOP 0x90     }
      if not(cs_littlesize in aktswitches) then
       begin
         if (cs_profile in aktswitches) then
          procinfo.aktentrycode^.insert(new(pai_align,init_op(16,$90)))
         else
          procinfo.aktentrycode^.insert(new(pai_align,init(4)));
       end;     
  {$endif GDB}
  {$ifdef EXTDEBUG}
    procinfo.aktentrycode^.insert(new(pai_direct,init(strpnew(target_info.newline))));
  {$endif EXTDEBUG}
  end;

  procedure genexitcode(parasize:longint;nostackframe:boolean);

  var hr:Preference;          {This is for function results.}
      op:Tasmop;
      s:Topsize;


  begin
      { !!!! insert there automatic destructors }
      procinfo.aktexitcode^.insert(new(pai_label,init(aktexitlabel)));

      { call the destructor help procedure }
      if (aktprocsym^.definition^.options and podestructor)<>0 then
        begin
          if procinfo._class^.isclass then
            begin
              procinfo.aktexitcode^.insert(new(pai386,op_csymbol(A_CALL,S_NO,
                newcsymbol('DISPOSE_CLASS',0))));
              concat_external('DISPOSE_CLASS',EXT_NEAR);
            end
          else
            begin
              procinfo.aktexitcode^.insert(new(pai386,op_csymbol(A_CALL,S_NO,
                newcsymbol('HELP_DESTRUCTOR',0))));
              concat_external('HELP_DESTRUCTOR',EXT_NEAR);
            end;
        end;

      { call __EXIT for main program }
      if (aktprocsym^.definition^.options and poproginit)<>0 then
       begin
         procinfo.aktexitcode^.concat(new(pai386,op_csymbol(A_CALL,S_NO,newcsymbol('__EXIT',0))));
         externals^.concat(new(pai_external,init('__EXIT',EXT_NEAR)));
       end;

      { handle return value }
      if (aktprocsym^.definition^.options and poassembler)=0 then
          if (aktprocsym^.definition^.options and poconstructor)=0 then
              begin
                  if procinfo.retdef<>pdef(voiddef) then
                      begin
                          if not(procinfo.funcret_is_valid) and
                            ((procinfo.flags and pi_uses_asm)=0) then
                           Message(sym_w_function_result_not_set);
                          new(hr);
                          reset_reference(hr^);
                          hr^.offset:=procinfo.retoffset;
                          hr^.base:=procinfo.framepointer;
                          if (procinfo.retdef^.deftype=orddef) then
                              begin
                                  case porddef(procinfo.retdef)^.typ of
                                      s32bit,u32bit :
                                          procinfo.aktexitcode^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hr,R_EAX)));
                                      u8bit,s8bit,uchar,bool8bit :
                                          procinfo.aktexitcode^.concat(new(pai386,op_ref_reg(A_MOV,S_B,hr,R_AL)));
                                      s16bit,u16bit :
                                          procinfo.aktexitcode^.concat(new(pai386,op_ref_reg(A_MOV,S_W,hr,R_AX)));
                                  end;
                              end
                          else
                              if (procinfo.retdef^.deftype in [pointerdef,enumdef,procvardef]) or
                               ((procinfo.retdef^.deftype=setdef) and
                               (psetdef(procinfo.retdef)^.settype=smallset)) then
                                  procinfo.aktexitcode^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hr,R_EAX)))
                              else
                                  if (procinfo.retdef^.deftype=floatdef) then
                                      begin
                                          if pfloatdef(procinfo.retdef)^.typ=f32bit then
                                              begin
                                                  { Isnt this missing ? }
                                                  procinfo.aktexitcode^.concat(new(pai386,op_ref_reg(A_MOV,S_L,hr,R_EAX)));
                                              end
                                          else
                                              begin
                                                  floatloadops(pfloatdef(procinfo.retdef)^.typ,op,s);
                                                  procinfo.aktexitcode^.concat(new(pai386,op_ref(op,s,hr)))
                                              end
                                      end
                                  else
                                      dispose(hr);
                      end
              end
          else
              begin
                  { successful constructor deletes the zero flag }
                  { and returns self in eax                      }
                  procinfo.aktexitcode^.concat(new(pai_label,init(quickexitlabel)));
                  { eax must be set to zero if the allocation failed !!! }
                  procinfo.aktexitcode^.concat(new(pai386,op_reg_reg(A_MOV,S_L,R_ESI,R_EAX)));
                  procinfo.aktexitcode^.concat(new(pai386,op_reg_reg(A_OR,S_L,R_EAX,R_EAX)));
              end;
      procinfo.aktexitcode^.concat(new(pai_label,init(aktexit2label)));
      if (target_info.target=target_linux) and
       ((aktprocsym^.definition^.options and poexports)<>0) then
          procinfo.aktentrycode^.insert(new(Pai386,op_reg(A_POP,S_L,R_EDI)));
      if not(nostackframe) then
          procinfo.aktexitcode^.concat(new(pai386,op_none(A_LEAVE,S_NO)));
      { parameters are limited to 65535 bytes because }
      { ret allows only imm16                         }
      if parasize>65535 then
       Message(cg_e_parasize_too_big);

      { at last, the return is generated }

      if (aktprocsym^.definition^.options and pointerrupt)<>0 then
          generate_interrupt_stackframe_exit
      else
       begin
       {Routines with the poclearstack flag set use only a ret.}
       { also routines with parasize=0           }
         if (parasize=0) or (aktprocsym^.definition^.options and poclearstack<>0) then
          procinfo.aktexitcode^.concat(new(pai386,op_none(A_RET,S_NO)))
         else
          procinfo.aktexitcode^.concat(new(pai386,op_const(A_RET,S_NO,parasize)));
       end;

  {$ifdef GDB}
      if cs_debuginfo in aktswitches  then
          begin
              aktprocsym^.concatstabto(procinfo.aktexitcode);
              if assigned(procinfo._class) then
                  procinfo.aktexitcode^.concat(new(pai_stabs,init(strpnew(
                   '"$t:v'+procinfo._class^.numberstring+'",'+
                   tostr(N_PSYM)+',0,0,'+tostr(procinfo.esi_offset)))));

              if (porddef(aktprocsym^.definition^.retdef) <> voiddef) then
                  procinfo.aktexitcode^.concat(new(pai_stabs,init(strpnew(
                   '"'+aktprocsym^.name+':X'+aktprocsym^.definition^.retdef^.numberstring+'",'+
                   tostr(N_PSYM)+',0,0,'+tostr(procinfo.retoffset)))));

              procinfo.aktexitcode^.concat(new(pai_stabn,init(strpnew('192,0,0,'
               +aktprocsym^.definition^.mangledname))));

              procinfo.aktexitcode^.concat(new(pai_stabn,init(strpnew('224,0,0,'
               +lab2str(aktexit2label)))));
          end;
  {$endif GDB}
  end;
  end.
{
  $Log: cgai386.pas,v $
  Revision 1.4.2.1  1998/04/09 23:29:23  peter
    * fixed profiling

  Revision 1.4  1998/03/30 15:53:00  florian
    * last changes before release:
       - gdb fixed
       - ratti386 warning removed (about unset function result)

  Revision 1.3  1998/03/28 23:09:55  florian
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

  Revision 1.2  1998/03/26 11:18:29  florian
    - switch -Sa removed
    - support of a:=b:=0 removed

  Revision 1.1.1.1  1998/03/25 11:18:16  root
  * Restored version

  Revision 1.23  1998/03/18 22:50:11  florian
    + fstp/fld optimization
    * routines which contains asm aren't longer optimzed
    * wrong ifdef TEST_FUNCRET corrected
    * wrong data generation for array[0..n] of char = '01234'; fixed
    * bug0097 is fixed partial
    * bug0116 fixed (-Og doesn't use enter of the stack frame is greater than
      65535)

  Revision 1.22  1998/03/16 22:42:18  florian
    * some fixes of Peter applied:
      ofs problem, profiler support

  Revision 1.21  1998/03/11 22:22:51  florian
    * Fixed circular unit uses, when the units are not in the current dir (from Peter)
    * -i shows correct info, not <lf> anymore (from Peter)
    * linking with shared libs works again (from Peter)

  Revision 1.20  1998/03/10 23:48:35  florian
    * a couple of bug fixes to get the compiler with -OGaxz compiler, sadly
      enough, it doesn't run

  Revision 1.19  1998/03/10 16:27:37  pierre
    * better line info in stabs debug
    * symtabletype and lexlevel separated into two fields of tsymtable
    + ifdef MAKELIB for direct library output, not complete
    + ifdef CHAINPROCSYMS for overloaded seach across units, not fully
      working
    + ifdef TESTFUNCRET for setting func result in underfunction, not
      working

  Revision 1.18  1998/03/10 01:17:16  peter
    * all files have the same header
    * messages are fully implemented, EXTDEBUG uses Comment()
    + AG... files for the Assembler generation

  Revision 1.17  1998/03/09 10:44:35  peter
    + string='', string<>'', string:='', string:=char optimizes (the first 2
      were already in cg68k2)

  Revision 1.16  1998/03/06 00:52:04  peter
    * replaced all old messages from errore.msg, only ExtDebug and some
      Comment() calls are left
    * fixed options.pas

  Revision 1.15  1998/03/04 01:34:51  peter
    * messages for unit-handling and assembler/linker
    * the compiler compiles without -dGDB, but doesn't work yet
    + -vh for Hint

  Revision 1.14  1998/03/03 23:18:44  florian
    * ret $8 problem with unit init/main program fixed

  Revision 1.13  1998/03/02 23:08:40  florian
    * the concatcopy bug removed (solves problems when compilg sysatari!)

  Revision 1.12  1998/03/02 01:48:18  peter
    * renamed target_DOS to target_GO32V1
    + new verbose system, merged old errors and verbose units into one new
      verbose.pas, so errors.pas is obsolete

  Revision 1.11  1998/03/01 22:46:01  florian
    + some win95 linking stuff
    * a couple of bugs fixed:
      bug0055,bug0058,bug0059,bug0064,bug0072,bug0093,bug0095,bug0098

  Revision 1.10  1998/02/13 10:34:46  daniel
  * Made Motorola version compilable.
  * Fixed optimizer

  Revision 1.9  1998/02/12 17:18:53  florian
    * fixed to get remake3 work, but needs additional fixes (output, I don't like
      also that aktswitches isn't a pointer)

  Revision 1.8  1998/02/12 11:49:51  daniel
  Yes! Finally! After three retries, my patch!

  Changes:

  Complete rewrite of psub.pas.
  Added support for DLL's.
  Compiler requires less memory.
  Platform units for each platform.

  Revision 1.7  1998/02/11 21:56:28  florian
    * bugfixes: bug0093, bug0053, bug0088, bug0087, bug0089

  Revision 1.6  1998/02/07 09:39:20  florian
    * correct handling of in_main
    + $D,$T,$X,$V like tp

  Revision 1.5  1998/01/07 00:16:41  michael
  Restored released version (plus fixes) as current

  Revision 1.4  1997/12/13 18:59:40  florian
  + I/O streams are now also declared as external, if neccessary
  * -Aobj generates now a correct obj file via nasm

  Revision 1.3  1997/12/09 13:30:51  carl
  + renamed some stuff

  Revision 1.2  1997/11/28 18:14:23  pierre
   working version with several bug fixes

  Revision 1.1.1.1  1997/11/27 08:32:54  michael
  FPC Compiler CVS start


  Pre-CVS log:


    6th november 1997:
     * replaced S_Q by S_T for s80real fld and fst (PM)

}
