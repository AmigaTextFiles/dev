{
    $Id: ag386att.pas,v 1.1.1.1 1998/03/25 11:18:12 root Exp $
    Copyright (c) 1996-98 by the FPC development team

    This unit implements an asmoutput class for i386 AT&T syntax

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
unit ag386att;

    interface

    uses aasm,assemble;

    type
      pi386attasmlist=^ti386attasmlist;
      ti386attasmlist = object(tasmlist)
        procedure WriteTree(p:paasmoutput);virtual;
        procedure WriteAsmList;virtual;
      end;

  implementation

    uses
      dos,globals,systems,cobjects,i386,
      strings,files,verbose
{$ifdef GDB}
      ,gdb
{$endif GDB}
      ;

    const
      line_length = 70;
    var
      infile : pextfile;
      includecount,
      lastline : longint;


    function getreferencestring(const ref : treference) : string;
    var
      s : string;
    begin
      if ref.isintvalue then
       s:='$'+tostr(ref.offset)
      else
       begin
         with ref do
          begin
          { have we a segment prefix ? }
          { These are probably not correctly handled under GAS }
          { should be replaced by coding the segment override  }
          { directly! - DJGPP FAQ                              }
            if segment<>R_DEFAULT_SEG then
             s:=att_reg2str[segment]+':'
            else
             s:='';
            if assigned(symbol) then
             s:=s+symbol^;
            if offset<0 then
             s:=s+tostr(offset)
            else
             if (offset>0) then
              begin
                if assigned(symbol) then
                 s:=s+'+'+tostr(offset)
                else
                 s:=s+tostr(offset);
              end;
            if (index<>R_NO) and (base=R_NO) then
             Begin
               s:=s+'(,'+att_reg2str[index];
               if scalefactor<>0 then
                s:=s+','+tostr(scalefactor)+')'
               else
                s:=s+')';
             end
            else
             if (index=R_NO) and (base<>R_NO) then
              s:=s+'('+att_reg2str[base]+')'
             else
              if (index<>R_NO) and (base<>R_NO) then
               Begin
                 s:=s+'('+att_reg2str[base]+','+att_reg2str[index];
                 if scalefactor<>0 then
                  s:=s+','+tostr(scalefactor)+')'
                 else
                  s := s+')';
               end;
          end;
       end;
      getreferencestring:=s;
    end;

    function getopstr(t : byte;o : pointer) : string;
    var
      hs : string;
    begin
      case t of
        top_reg : getopstr:=att_reg2str[tregister(o)];
        top_ref : getopstr:=getreferencestring(preference(o)^);
      top_const : getopstr:='$'+tostr(longint(o));
     top_symbol : begin
                    hs[0]:=chr(strlen(pchar(pcsymbol(o)^.symbol)));
                    move(pchar(pcsymbol(o)^.symbol)^,hs[2],byte(hs[0]));
                    inc(byte(hs[0]));
                    hs[1]:='$';
                    if pcsymbol(o)^.offset>0 then
                     hs:=hs+'+'+tostr(pcsymbol(o)^.offset)
                    else
                     if pcsymbol(o)^.offset<0 then
                      hs:=hs+tostr(pcsymbol(o)^.offset);
                    getopstr:=hs;
                  end;
      else
       internalerror(10001);
      end;
    end;


    function getopstr_jmp(t : byte;o : pointer) : string;
    var
      hs : string;
    begin
      case t of
       top_reg : getopstr_jmp:=att_reg2str[tregister(o)];
       top_ref : getopstr_jmp:='*'+getreferencestring(preference(o)^);
     top_const : getopstr_jmp:=tostr(longint(o));
    top_symbol : begin
                    hs[0]:=chr(strlen(pchar(pcsymbol(o)^.symbol)));
                    move(pchar(pcsymbol(o)^.symbol)^,hs[1],byte(hs[0]));
                    if pcsymbol(o)^.offset>0 then
                     hs:=hs+'+'+tostr(pcsymbol(o)^.offset)
                    else
                     if pcsymbol(o)^.offset<0 then
                      hs:=hs+tostr(pcsymbol(o)^.offset);
                    getopstr_jmp:=hs;
                 end;
      else
       internalerror(10001);
      end;
    end;

    var
      MMXWarn : boolean;
    procedure MMXWarning;
    begin
      if not MMXWarn then
       begin
         Message(assem_w_mmxwarning_as_281);
         MMXWarn:=true;
       end;
    end;


{****************************************************************************
                            TI386ATTASMOUTPUT
 ****************************************************************************}

{$ifdef GDB}
    var
      n_line : byte;    { different types of source lines }
{$endif}

    const
      ait_const2str : array[ait_const_32bit..ait_const_8bit] of string[8]=
       (#9'.long'#9,'',#9'.short'#9,#9'.byte'#9);

{$ifdef MAKELIB}

     const
        nameindex : longint = 0;
     var
        path, filename : string;

     procedure getnextname(var filename : string);

       begin
          inc(nameindex);
          if nameindex>999999 then
            begin
               exterror:=strpnew(' too many assembler files ');
               fatalerror(user_defined);
            end;
          filename:='as'+tostr(nameindex);
       end;
{$endif MAKELIB}

    procedure ti386attasmlist.WriteTree(p:paasmoutput);
    type
      twowords=record
        word1,word2:word;
      end;
    var
      ch       : char;
      hp       : pai;
      consttyp : tait;
      s        : string;
      found    : boolean;
      i,pos,l  : longint;
{$ifdef GDB}
      funcname  : pchar;
      linecount : longint;
{$endif GDB}

    begin
{$ifdef GDB}
      funcname:=nil;
      linecount:=1;
{$endif GDB}
      hp:=pai(p^.first);
      while assigned(hp) do
       begin
       { write debugger informations }
{$ifdef GDB}
         if cs_debuginfo in aktswitches then
          begin
            if not (hp^.typ in  [ait_external,ait_stabn,ait_stabs,
{$ifdef MAKELIB}
                   ait_cut,
{$endif MAKELIB}
                   ait_stab_function_name]) then
             begin
               if assigned(hp^.infile) and (pextfile(hp^.infile)<>infile)  then
                begin
                  infile:=hp^.infile;
                  inc(includecount);
                  if (hp^.infile^.path^<>'') then
                   begin
                     AsmWriteLn(#9'.stabs "'+BsToSlash(FixPath(hp^.infile^.path^))+'",'+tostr(n_includefile)+
                                ',0,0,'+target_info.labelprefix+'text'+ToStr(IncludeCount));
                   end;
                  AsmWriteLn(#9'.stabs "'+FixFileName(hp^.infile^.name^+hp^.infile^.ext^)+'",'+tostr(n_includefile)+
                             ',0,0,'+target_info.labelprefix+'text'+ToStr(IncludeCount));
                  AsmWriteLn(target_info.labelprefix+'text'+ToStr(IncludeCount)+':');
                end;
              { file name must be there before line number ! }
               if (hp^.line<>lastline) and (hp^.line<>0) then
                begin
                  if (n_line = n_textline) and assigned(funcname) and
                     (target_info.use_function_relative_addresses) then
                   begin
                     AsmWriteLn(target_info.labelprefix+'l'+tostr(linecount)+':');
                     AsmWriteLn(#9'.stabn '+tostr(n_line)+',0,'+tostr(hp^.line)+','+
                                target_info.labelprefix+'l'+tostr(linecount)+' - '+StrPas(FuncName));
                     inc(linecount);
                   end
                  else
                   AsmWriteLn(#9'.stabd'#9+tostr(n_line)+',0,'+tostr(hp^.line));
                  lastline:=hp^.line;
                end;
             end;
          end;
{$endif GDB}

         case hp^.typ of
           ait_comment,    { we ignore comments because some GNU AS can't handle this }
           ait_external:
            ; { external is ignored }
           ait_align:
             begin
                { Fix Align bytes for Go32 which uses empty bits }
                l:=pai_align(hp)^.aligntype;
                if (target_info.target in [target_GO32V1,target_GO32V2]) then
                 begin
                   i:=0;
                   while l>1 do
                    begin
                      l:=l shr 1;
                      inc(i);
                    end;
                   l:=i;
                 end;
                { use correct align opcode }
                AsmWrite(#9'.align '+tostr(l));
                if pai_align(hp)^.op<>0 then
                 AsmWrite(','+tostr(pai_align(hp)^.op));
                AsmLn;
             end;
           ait_section:
             begin
                asmwrite(#9'.section '+pai_section(hp)^.name^);
                asmln;
             end;
     ait_datablock : begin
                       if pai_datablock(hp)^.is_global then
                        AsmWrite(#9'.comm'#9)
                       else
                        AsmWrite(#9'.lcomm'#9);
                       AsmWriteLn(StrPas(pai_datablock(hp)^.name)+','+tostr(pai_datablock(hp)^.size));
                     end;
   ait_const_32bit,
   ait_const_16bit,
    ait_const_8bit : begin
                       AsmWrite(ait_const2str[hp^.typ]+tostr(pai_const(hp)^.value));
                       consttyp:=hp^.typ;
                       l:=0;
                       repeat
                         found:=(not (Pai(hp^.next)=nil)) and (Pai(hp^.next)^.typ=consttyp);
                         if found then
                          begin
                            hp:=Pai(hp^.next);
                            s:=','+tostr(pai_const(hp)^.value);
                            AsmWrite(s);
                            inc(l,length(s));
                          end;
                       until (not found) or (l>line_length);
                       AsmLn;
                     end;
           ait_const_symbol:
             AsmWriteLn(#9'.long'#9+StrPas(pchar(pai_const(hp)^.value)));
           ait_const_rva:
             AsmWriteLn(#9'.rva'#9+StrPas(pchar(pai_const(hp)^.value)));
    ait_real_64bit : AsmWriteLn(#9'.double'#9+double2str(pai_double(hp)^.value));
    ait_real_32bit : AsmWriteLn(#9'.single'#9+double2str(pai_single(hp)^.value));
 ait_real_extended : AsmWriteLn(#9'.tfloat'#9+double2str(pai_extended(hp)^.value));
                     { comp type is difficult to write so use double }
          ait_comp : AsmWriteLn(#9'.double'#9+comp2str(pai_extended(hp)^.value));
        ait_direct : begin
                       AsmWritePChar(pai_direct(hp)^.str);
                       AsmLn;
{$IfDef GDB}
                       if strpos(pai_direct(hp)^.str,'.data')<>nil then
                         n_line:=n_dataline
                       else if strpos(pai_direct(hp)^.str,'.text')<>nil then
                         n_line:=n_textline
                       else if strpos(pai_direct(hp)^.str,'.bss')<>nil then
                         n_line:=n_bssline;
{$endif GDB}
                     end;
        ait_string : begin
                       pos:=0;
                       for i:=1 to pai_string(hp)^.len do
                        begin
                          if pos=0 then
                           begin
                             AsmWrite(#9'.ascii'#9'"');
                             pos:=20;
                           end;
                          ch:=pai_string(hp)^.str[i-1];
                          case ch of
                             #0, {This can't be done by range, because a bug in FPC}
                        #1..#31,
                     #128..#255 : s:='\'+tostr(ord(ch) shr 6)+tostr((ord(ch) and 63) shr 3)+tostr(ord(ch) and 7);
                            '"' : s:='\"';
                            '\' : s:='\\';
                          else
                           s:=ch;
                          end;
                          AsmWrite(s);
                          inc(pos,length(s));
                          if (pos>line_length) or (i=pai_string(hp)^.len) then
                           begin
                             AsmWriteLn('"');
                             pos:=0;
                           end;
                        end;
                     end;
         ait_label : begin
                       if (pai_label(hp)^.l^.is_used) then
                        AsmWriteLn(lab2str(pai_label(hp)^.l)+':');
                     end;
        ait_labeled_instruction : begin
                       if (pai_labeled(hp)^._operator>A_POPFD) then
                        MMXWarning;
                       AsmWriteLn(#9+att_op2str[pai_labeled(hp)^._operator]+#9+lab2str(pai_labeled(hp)^.lab));
                     end;
        ait_symbol : begin
                       if pai_symbol(hp)^.is_global then
                        AsmWriteLn('.globl '+StrPas(pai_symbol(hp)^.name));
                       if target_info.target=target_LINUX then
                        begin
                           AsmWrite(#9'.type'#9+StrPas(pai_symbol(hp)^.name));
                           if pai(hp^.next)^.typ in [ait_const_symbol,ait_const_32bit,
                              ait_const_16bit,ait_const_8bit,ait_datablock] then
                            AsmWriteLn(',@object')
                           else
                            AsmWriteLn(',@function');
                        end;
                       AsmWriteLn(StrPas(pai_symbol(hp)^.name)+':');
                     end;
   ait_instruction : begin { writes an instruction, highly table driven }
                       if (pai386(hp)^._operator>A_POPFD) then
                        MMXWarning;
                       if (pai386(hp)^._operator=A_PUSH) and
                          (pai386(hp)^.size=S_W) and
                          (pai386(hp)^.op1t=top_const) then
                        begin
{$ifdef EXTDEBUG}
                          AsmWriteLn('# GNU AS bug work around for pushw'#9+tostr(longint(pai386(hp)^.op1)));
{$endif}
                          AsmWriteLn(#9'.byte 0x66,0x68');
                          AsmWriteLn(#9'.word '+tostr(longint(pai386(hp)^.op1)));
                        end
                       else
                        begin
                          s:=#9+att_op2str[pai386(hp)^._operator]+att_opsize2str[pai386(hp)^.size];
                          if pai386(hp)^.op1t<>top_none then
                           begin
                           { call and jmp need an extra handling                          }
                           { this code is only callded if jmp isn't a labeled instruction }
                             if pai386(hp)^._operator in [A_CALL,A_JMP] then
                              s:=s+#9+getopstr_jmp(pai386(hp)^.op1t,pai386(hp)^.op1)
                             else
                              begin
                                s:=s+#9+getopstr(pai386(hp)^.op1t,pai386(hp)^.op1);
                                if pai386(hp)^.op3t<>top_none then
                                 begin
                                   if pai386(hp)^.op2t<>top_none then
                                    s:=s+','+getopstr(pai386(hp)^.op2t,
                                      pointer(longint(twowords(pai386(hp)^.op2).word1)));
                                    s:=s+','+getopstr(pai386(hp)^.op3t,
                                    pointer(longint(twowords(pai386(hp)^.op2).word2)));
                                 end
                                else
                                 if pai386(hp)^.op2t<>top_none then
                                  s:=s+','+getopstr(pai386(hp)^.op2t,pai386(hp)^.op2);
                              end;
                           end;
                          AsmWriteLn(s);
                        end;
                     end;
{$ifdef GDB}
         ait_stabs : begin
                       AsmWrite(#9'.stabs ');
                       AsmWritePChar(pai_stabs(hp)^.str);
                       AsmLn;
                     end;
         ait_stabn : begin
                       AsmWrite(#9'.stabn ');
                       AsmWritePChar(pai_stabn(hp)^.str);
                       AsmLn;
                     end;
         ait_stab_function_name:
           funcname:=pai_stab_function_name(hp)^.str;
{$endif GDB}
{$ifdef MAKELIB}
          { used to split unit into tiny assembler files }
             ait_cut :
               begin
                  outfile^.close;
                  writeln(asmres,asbin+' -D -o '+path+filename+
                    target_info.objext+' '+path+filename+target_info.asmext);
                  getnextname(filename);
                  outfile^.changename(path+filename+target_info.asmext);
                  outfile^.rewrite;
                  if p=codesegment then
                    AsmWriteLn('.text')
                  else
                    AsmWriteLn('.data');
                  { avoid empty files }
                  while assigned(hp^.next) and (pai(hp^.next)^.typ=ait_cut) do
                    hp:=pai(hp^.next);
               end;
{$endif MAKELIB}
              else internalerror(10000);
           end;
           { omit extra new lines }
           hp:=pai(hp^.next);
        end;
      end;


    procedure ti386attasmlist.WriteAsmList;
{$ifdef GDB}
    var
      p:dirstr;
      n:namestr;
      e:extstr;
{$endif}
{$ifdef MAKELIB}
     path : string;
{$endif MAKELIB}
    begin
{$ifdef EXTDEBUG}
      if assigned(current_module^.mainsource) then
       Comment(v_info,'Start writing att-styled assembler output for '+current_module^.mainsource^);
{$endif}

      infile:=nil;
      MMXWarn:=false;
      includecount:=0;
{$ifdef GDB}
      if assigned(current_module^.mainsource) then
       fsplit(current_module^.mainsource^,p,n,e)
      else
       begin
         p:=inputdir;
         n:=inputfile;
         e:=inputextension;
       end;
    { to get symify to work }
      AsmWriteLn(#9'.file "'+FixFileName(n+e)+'"');
    { stabs }
      n_line:=n_bssline;
      if (cs_debuginfo in aktswitches) then
       begin
         if (p<>'') then
          AsmWriteLn(#9'.stabs "'+BsToSlash(p)+'",'+tostr(n_sourcefile)+',0,0,Ltext0');
         AsmWriteLn(#9'.stabs "'+n+e+'",'+tostr(n_sourcefile)+',0,0,Ltext0');
         AsmWriteLn('Ltext0:');
       end;
      infile:=current_module^.sourcefiles.files;
    { main source file is last in list }
      while assigned(infile^._next) do
       infile:=infile^._next;
      lastline:=0;
{$endif GDB}
{$ifdef MAKELIB}
         path:=p+n+'.dir';
         mkdir(path);
         path:=path+'/';
         nameindex:=0;
         outfile^.close;
         getnextname(filename);
         outfile^.changename(path+filename+target_info.asmext);
         outfile^.rewrite;
{$endif MAKELIB}

      { there should be nothing but externals so we don't need to process
      WriteTree(externals); }
      WriteTree(debuglist);

    { code segment }
      AsmWriteln('.text');
{$ifdef GDB}
      n_line:=n_textline;
{$endif GDB}
      WriteTree(codesegment);

      AsmWriteLn('.data');
{$ifdef EXTDEBUG}
      AsmWriteLn(#9'.ascii'#9'"compiled by FPC '+version_string+'\0"');
      AsmWriteLn(#9'.ascii'#9'"target: '+target_info.target_name+'\0"');
{$endif EXTDEBUG}
{$ifdef GDB}
      n_line:=n_dataline;
{$endif GDB}
      DataSegment^.insert(new(pai_align,init(4)));
      WriteTree(datasegment);
      WriteTree(consts);

    { makes problems with old GNU ASes
      AsmWriteLn('.bss');
      bssSegment^.insert(new(pai_align,init(4))); }
{$ifdef GDB}
      n_line:=n_bssline;
{$endif GDB}
      WriteTree(bsssegment);

      AsmLn;
      if assigned(importssection) then
        begin
           writetree(importssection);
        end;
      if assigned(exportssection) then
        begin
           writetree(exportssection);
        end;
      if assigned(resourcesection) then
        begin
           writetree(resourcesection);
        end;
{$ifdef EXTDEBUG}
      if assigned(current_module^.mainsource) then
       comment(v_info,'Done writing att-styled assembler output for '+current_module^.mainsource^);
{$endif EXTDEBUG}
    end;


end.
{
  $Log: ag386att.pas,v $
  Revision 1.1.1.1  1998/03/25 11:18:12  root
  * Restored version

  Revision 1.3  1998/03/24 21:48:29  florian
    * just a couple of fixes applied:
         - problem with fixed16 solved
         - internalerror 10005 problem fixed
         - patch for assembler reading
         - small optimizer fix
         - mem is now supported

  Revision 1.2  1998/03/10 16:27:36  pierre
    * better line info in stabs debug
    * symtabletype and lexlevel separated into two fields of tsymtable
    + ifdef MAKELIB for direct library output, not complete
    + ifdef CHAINPROCSYMS for overloaded seach across units, not fully
      working
    + ifdef TESTFUNCRET for setting func result in underfunction, not
      working

  Revision 1.1  1998/03/10 01:26:09  peter
    + new uniform names

  Revision 1.30  1998/03/09 12:58:10  peter
    * FWait warning is only showed for Go32V2 and $E+
    * opcode tables moved to i386.pas/m68k.pas to reduce circular uses (and
      for m68k the same tables are removed)
    + $E for i386

  Revision 1.29  1998/03/02 01:48:06  peter
    * renamed target_DOS to target_GO32V1
    + new verbose system, merged old errors and verbose units into one new
      verbose.pas, so errors.pas is obsolete

  Revision 1.28  1998/03/01 22:46:00  florian
   + some win95 linking stuff
   * a couple of bugs fixed:
     bug0055,bug0058,bug0059,bug0064,bug0072,bug0093,bug0095,bug0098

  Revision 1.27  1998/02/28 00:20:21  florian
    * more changes to get import libs for Win32 working

  Revision 1.26  1998/02/27 22:27:51  florian
    + win_targ unit
    + support of sections
    + new asmlists: sections, exports and resource

  Revision 1.25  1998/02/26 11:57:02  daniel
  * New assembler optimizations commented out, because of bugs.
  * Use of dir-/name- and extstr.

  Revision 1.24  1998/02/23 02:58:24  carl
    * bugfix of compiling with extdebug defined

  Revision 1.23  1998/02/22 23:03:00  peter
    * renamed msource->mainsource and name->unitname
    * optimized filename handling, filename is not seperate anymore with
      path+name+ext, this saves stackspace and a lot of fsplit()'s
    * recompiling of some units in libraries fixed
    * shared libraries are working again
    + $LINKLIB <lib> to support automatic linking to libraries
    + libraries are saved/read from the ppufile, also allows more libraries
      per ppufile

  Revision 1.22  1998/02/15 21:15:59  peter
    * all assembler outputs supported by assemblerobject
    * cleanup with assembleroutputs, better .ascii generation
    * help_constructor/destructor are now added to the externals
    - generation of asmresponse is not outputformat depended

  Revision 1.21  1998/02/13 22:26:15  peter
    * fixed a few SigSegv's
    * INIT$$ was not written for linux!
    * assembling and linking works again for linux and dos
    + assembler object, only attasmi3 supported yet
    * restore pp.pas with AddPath etc.

  Revision 1.20  1998/02/13 10:34:35  daniel
   * Made Motorola version compilable.
   * Fixed optimizer

  Revision 1.19  1998/02/12 11:49:42  daniel
  Yes! Finally! After three retries, my patch!

  Changes:

  Complete rewrite of psub.pas.
  Added support for DLL's.
  Compiler requires less memory.
  Platform units for each platform.

  Revision 1.18  1998/02/08 15:13:34  florian
    * correct output of mmx register names

  Revision 1.17  1998/02/04 21:58:41  florian
    + MMX registers for output added

  Revision 1.16  1998/01/27 23:33:24  peter
    * a ' was placed wrong

  Revision 1.15  1998/01/26 18:52:56  peter
    * Align with go32 is in empty bits, not in bytes like linux

  Revision 1.14  1998/01/19 09:32:30  michael
  * Shared Lib and GDB/RHIDE Bufixes from Peter Vreman.

  Revision 1.13  1998/01/13 23:11:00  florian
    + class methods

  Revision 1.12  1998/01/12 01:08:21  michael
  * Small fix to make shared libs possible. (From Peter Vreman)

  Revision 1.11  1998/01/07 00:16:35  michael
  Restored released version (plus fixes) as current

  Revision 1.10  1997/12/15 14:09:17  florian
    * now no stabs are generated if debugging info is off

  Revision 1.9  1997/12/09 13:25:20  carl
  + added pai_align abstract instruction
  * probably some bugfixes (can't remember!)

  Revision 1.8  1997/12/05 14:43:57  carl
  * bugfix of compiler crash with ait_labeled_instr

  Revision 1.7  1997/12/04 12:20:44  pierre
    +* MMX instructions added to att output with a warning that
       GNU as version >= 2.81 is needed
       bug in reading of reals under att syntax corrected

  Revision 1.6  1997/12/01 17:42:50  pierre
     + added some more functionnality to the assembler parser

  Revision 1.4  1997/11/28 18:14:19  pierre
   working version with several bug fixes

  Revision 1.2  1997/11/27 17:36:44  carl
  * make it compile under BP (line too long errors)

  Revision 1.1.1.1  1997/11/27 08:32:50  michael
  FPC Compiler CVS start


  Pre-CVS log:

  CEC   Carl-Eric Codere
  FK    Florian Klaempfl
  PM    Pierre Muller
  +     feature added
  -     removed
  *     bug fixed or changed

  History:
      30th september 1996:
         + unit started (FK)
      15th october 1996:
         + ti386attasmoutput class started (FK)
      28th november 1996:
         ! debugging for simple programs (FK)
      26th february 1997:
         + op2str array completed with work of Daniel Manitone (FK)
      25th september 1997:
         * compiled by comment ifdef'ed (FK)
      13th november 1997:
         * added single and extended const (PM)
         + added support for scaling = 0 (CEC)
           (is this ok??? Tested under 2.8.1.)
      14th november 1997:
         + added POPFD
}
