{
    $Id: globals.pas,v 1.6.2.7 1998/08/18 13:41:22 carl Exp $
    Copyright (C) 1993-98 by Florian Klaempfl

    This unit implements some support functions and global variables

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

{$ifdef tp}
  {$E+,N+}
{$endif}

unit globals;

  interface

    uses
      cobjects,objects,dos,strings
{$ifdef linux}
      ,linux
{$endif}
      ;

{$I version.inc}

    type
       { later moved to system unit }
       aword = longint;
{ for each processor define the best precision }
{$ifdef i386}
  {$ifdef ver_above0_9_8}
       bestreal = extended;
  {$else ver_above0_9_8}
       bestreal = double;
  {$endif ver_above0_9_8}
{$endif i386}
{$ifdef m68k}
       bestreal = real;
{$endif m68k}


    const
       { version string }
       version_nr = '0';
       release_nr = '99';
       patch_nr   = '5';
{$ifdef i386}
       target = 'i386';
{$endif}
{$ifdef m68k}
       target = 'M680x0';
{$endif}
{$ifdef alpha}
       target = 'Alpha';
{$endif}
       version_string = version_nr+'.'+release_nr+'.'+patch_nr+' for '+target;

{$ifdef Splitheap}
       testsplit : boolean = false;
{$endif Splitheap}

       { max. significant length of strings }
       maxidlen = 64;

    type
       { I had to change the order for overloading
         can this be a problem ? (PM)

         It will be no problem, if you change also the array to convert
         tokens to strings (in PARSER.PAS) (FK)
       }

{***IMPLIBGEN}
       ttoken = (PLUS,MINUS,STAR,SLASH,EQUAL,GT,LT,GTE,LTE,_IS,_AS,_IN,
                 SYMDIF,CARET,
                 ASSIGNMENT,UNEQUAL,LECKKLAMMER,RECKKLAMMER,
                 POINT,COMMA,LKLAMMER,RKLAMMER,COLON,SEMICOLON,
                 KLAMMERAFFE,POINTPOINT,
                 ID,REALNUMBER,_EOF,INTCONST,CSTRING,CCHAR,DOUBLEADDR,

{                _ABSOLUTE,}
                 _AND,_ARRAY,_ASM,_BEGIN,
                 _BREAK,_CASE,_CONST,_CONSTRUCTOR,_CONTINUE,
                 _DESTRUCTOR,_DISPOSE,_DIV,_DO,_DOWNTO,_ELSE,_END,
                 _EXIT,
{                _EXPORT,}
                 _EXTERNAL,_FAIL,_FALSE,
{                _FAR,}
                 _FILE,_FOR,
{                _FORWARD,}
                 _FUNCTION,_GOTO,_IF,_IMPLEMENTATION,
                 _INHERITED,
{                _INLINE,}
                 _INTERFACE,
{                _INTERRUPT,}
                 _LABEL,_MOD,
{                _NEAR,}
                 _NEW,_NIL,_NOT,_OBJECT,
                 _OF,_OTHERWISE,_OR,_PACKED,
                 _PROCEDURE,_PROGRAM,
                 _RECORD,_REPEAT,_SELF,
                 _SET,_SHL,_SHR,_STRING,_THEN,_TO,
                 _TRUE,_TYPE,_UNIT,_UNTIL,
                 _USES,_VAR,_WHILE,_WITH,_XOR,
                 { since Delphi 2 }
                 _CLASS,_EXCEPT,_TRY,_ON,
{                _ABSTRACT,}
                 _LIBRARY,_INITIALIZATION,_FINALLY,_EXPORTS,_PROPERTY,
                 _RAISE,
                 { for operator overloading }
                 _OPERATOR,

                 { C like operators }
                 _PLUSASN,_MINUSASN,_ANDASN,_ORASN,_STARASN,_SLASHASN,
                 _MODASN,_DIVASN,_NOTASN,_XORASN
                 );

       tcswitch = (cs_none,
         cs_check_overflow,cs_maxoptimieren,cs_uncertainopts,
         cs_omitstackframe,cs_littlesize,cs_optimize,cs_debuginfo,
         cs_compilesystem,cs_rangechecking,cs_support_goto,
         cs_check_unit_name,cs_iocheck,cs_checkconsname,
         cs_check_stack,cs_extsyntax,cs_typed_addresses,
         cs_delphi2_compatible,cs_tp_compatible,cs_static_keyword,
         cs_strict_var_strings,cs_fp_emulation,
{$ifdef SUPPORT_MMX}
         cs_mmx,cs_mmx_saturation,
{$endif SUPPORT_MMX}
         cs_profile,
         cs_link_dynamic,cs_link_static,cs_no_linking,cs_unit_to_lib,
         cs_shared_lib,cs_load_objpas_unit);

       tcswitches = set of tcswitch;

       pcswitches = ^tcswitches;

       stringid = string[maxidlen];

       pdouble = ^double;

       pbyte = ^byte;

       plongint = ^longint;

{$ifdef i386}
       tprocessors = (i386,i486,pentium,pentiumpro,pentium2);
{$endif}
{$ifdef m68k}
       tprocessors = (MC68000,MC68020);
{$endif}


{$ifdef i386}
       tof = (of_none,of_o,of_obj,of_masm,of_att,of_nasm,of_win32);
{$endif}
{$ifdef m68k}
       { the support will start with the following formats :
         of_o = amiga/atari/mac native object format
         of_gas = gas styled motorola assembler
         of_mot = motorola styled assembler
         of_mit = MIT syntax (old styled gas)
       }
       tof = (of_none,of_o,of_gas,of_mot,of_mit);
{$endif}

       tcompilerstate = record
          switches : tcswitches;
          exprlevel : byte;
       end;

       { this type will be sent from the compiler to the IDE to make up a }
       { status window                                                    }
       tcompilestatus = record
              { filename }
              currentsource : string;

              { current line number }
              currentline : longint;

              { will implement a percentage bar         }

              { the number of lines which are compiled  }
              totalcompiledlines : longint;

              { Note:                                   }
              { it's possible that totallines is zero,  }
              { this means the compiler didn't know the }
              { total lines                             }
              totallines : longint;
       end;

       { such a procedure is called from the compiler, }
       { to put some informations to the ide etc.      }
       { if the function returns true, the compiler    }
       { stops                                         }
       tcompilestatusproc = function(const status : tcompilestatus) : boolean;

{$ifdef i386}
       ti386asmmode = (I386_ATT,I386_INTEL,I386_DIRECT);

    const
       { the current mode which is in assembler blocks assumed }
       aktasmmode : ti386asmmode = I386_DIRECT;
{$endif}

    var
       compilestatusproc : tcompilestatusproc;

       inputdir       : dirstr;
       inputfile      : namestr;
       inputextension : extstr;
       { some flags for global compiler switches }
       use_pipe,
       do_build,do_make,writeasmfile,externasm,externlink : boolean;
       assem_need_external_list,not_unit_proc : boolean;
       { path for searching units, different paths can be seperated by ; }
       exepath            : dirstr;  { Path to ppc }
       unitsearchpath,
       objectsearchpath,
       includesearchpath,
       librarysearchpath  : string;

       initswitches  : tcswitches;
       { alignement of records }
       initpackrecords : word;

       { current state state }
       aktswitches    : Tcswitches;
       aktpackrecords : word;
       { this list contains the defines      }
       { from the command line, this defines }
       commandlinedefines : tlinkedlist;

       abslines : longint;         { number of lines which are compiled }
       in_args : boolean;          { arguments must be checked especially }
       parsing_para_level : longint; { parameter level, used to convert
                                     proc calls to proc loads in firstcalln }
       Must_be_valid : boolean;    { should the variable already have a value }

{$ifdef TP}
       use_big      : boolean;
{$ifndef dpmi}
       symbolstream : temsstream;  { stream which is used to store some     }
                                   { informtions to use not much DOS memory }
{$else}
       symbolstream: tmemorystream;
{$endif}
                                   { die Symbole abgelegt werden              }
{$endif}
       gendeffile  : boolean;      { true, when a DEF-file should be created }
       genpm : boolean;            { true, when in the DEF-file WINDOWAPI should be placed }
       description : string;       { description in the DEF-file }
       deffile : text;             { Textfile for the DEF-file }

       opt_processors : tprocessors;
       commandline_output_format : tof;
       output_format : tof;

       { true, if C styled macros should be allowed  }
       { boolean and not a set element, because it's }
       { asked _very_ often                          }
       support_macros : boolean;

       { true, if inline like in C++ should be supported }
       support_inline : boolean;

       { to test for call with ESP as stack frame }
       use_esp_stackframe : boolean;

       language : char;

       warnings : boolean;

       { to allow explicit executable filename }
{       exename : string;}

       { use operators like in C (/=,*=, etc. }
       c_like_operators : boolean;

       { contains the units which must be initilizied or linked }
       usedunits : tlinkedlist;
       dispose_asm_lists : boolean;

    function upper(const s : string) : string;
    procedure uppervar(var s : string);
    function tostr(i : longint) : string;
    function tostr_with_plus(i : longint) : string;
    procedure globalsinit;
    function ibm2ascii(const s : string) : string;
    function double2str(d : double) : string;
    function comp2str(d : bestreal) : string;
    procedure setstring(var p : pchar;const s : string);
    function bstoslash(const s : string) : string;
    function lowercase(const s : string) : string;

    function min(a,b : longint) : longint;
    function max(a,b : longint) : longint;

    { sucht Datei mit Namen f in den in path angegebenen Verzeichnissen }
    function  filetimestring( t : longint) : string;
    function path_absolute(const s : string) : boolean;
    Function FileExists ( Const F : String) : Boolean;
    Function GetFileTime ( Var F : File) : Longint;
    Function GetNamedFileTime ( Const F : String) : Longint;
    Function FixPath(s:string):string;
    function FixFileName(const s:string):string;
    procedure AddPathToList(var list:string;s:string;first:boolean);
    function search(const f : string;path : string;var b : boolean) : string;
    function FindExe(bin:string;var found:boolean):string;

{$Ifdef EXTDEBUG}
    const debugstop  : boolean = false;
{$EndIf EXTDEBUG}
{$ifdef debug}
    { if the pointer don't point to the heap then write an error }
    function assigned(p : pointer) : boolean;
{$endif}
    function ispowerof2(value : longint;var power : longint) : boolean;

    procedure valint(S : string;var V : longint;var code : word);

    { determines if s is a number }
    function is_number(const s : string) : boolean;

    { token position }
    function get_current_col : longint;

    const
       lastlinepointer : longint = 0;
       lasttokenpos : longint = 0;
       { used in symtable.pas and options.pas }
       use_gsym : boolean = false;
       use_dbx    : boolean   = false;

    const
    {$ifdef i386}
       heapsize : longint = 2621440;    { 25600K default heap  }
       stacksize : longint = 8192;      {     8K default stack }
    {$endif}
    {$ifdef m68k}
       heapsize : longint =  131072 ;   {   128K default heap  }
       stacksize : longint =  16384 ;   {    16K default stack }
    {$endif m68k}
       compile_level : word = 0;

  implementation

    uses
      systems;

    function is_number(const s : string) : boolean;

      var
         w : word;
         l : longint;

      begin
         valint(s,l,w);
         is_number:=w=0;
      end;

    function get_current_col : longint;
      begin
         if lastlinepointer<=lasttokenpos then
           get_current_col:=lasttokenpos-lastlinepointer+1
         else
           get_current_col:=0;
      end;

    procedure valint(S : string;var V : longint;var code : word);
{$ifndef FPC}
      var vs : longint;
          c : byte;
      begin
        if s[1]='%' then
          begin
             vs:=0;
             longint(v):=0;
             for c:=2 to length(s) do
               begin
                  if s[c]='0' then
                    vs:=vs*2
                  else
                  if s[c]='1' then
                    vs:=vs*2+1
                  else
                    begin
                      code:=c;
                      exit;
                    end;
               end;
             code:=0;
             longint(v):=vs;
          end
        else
         system.val(S,V,code);
      end;
{$else not FPC}
      begin
         system.val(S,V,code);
      end;
{$endif not FPC}

    function double2str(d : double) : string;

      var
         hs : string;
         p : byte;

      begin
         str(d,hs);
{$ifdef i386}
         { replace space with + }
         if (output_format in [of_att,of_o,of_win32]) then
           begin
              if hs[1]=' ' then
                hs[1]:='+';
              double2str:='0d'+hs
           end
         else if (output_format in [of_obj,of_nasm]) then
         { nasm expects a lowercase e }
           begin
              p:=pos('E',hs);
              if p>0 then hs[p]:='e';
              p:=pos('+',hs);
              if p>0 then
                delete(hs,p,1);
              double2str:=lowercase(hs);
{$endif}
{$ifdef m68k}
         { replace space with + }
         if (output_format=of_gas) then
           begin
              if hs[1]=' ' then
                hs[1]:='+';
              double2str:='0d'+hs
{$endif}
           end
         else
           double2str:=hs;
      end;


    function comp2str(d : bestreal) : string;
      type
        pdouble = ^double;
      var
{$ifdef m68k}
        c  : bestreal;
{$else}
        c  : comp;
{$endif}
        dd : pdouble;
      begin
         c:=d;{ this generates a warning but this is not important }
{$ifndef TP}
{$warning The following warning can be ignored}
{$endif TP}
         dd:=pdouble(@c); { this makes a bitwise copy of c into a double }
         comp2str:=double2str(dd^);
      end;

    function ispowerof2(value : longint;var power : longint) : boolean;

      var
         hl : longint;
         i : longint;

      begin
         hl:=1;
         ispowerof2:=true;
         for i:=0 to 31 do
           begin
              if hl=value then
                begin
                   power:=i;
                   exit;
                end;
              hl:=hl shl 1;
           end;
         ispowerof2:=false;
      end;

    function lowercase(const s : string) : string;
      var
         i : longint;
      begin
        for i := 1 to length (s) do
         lowercase[i]:=cobjects.lowercase(s[i]);
        lowercase[0]:=s[0];
      end;

    { used with the debugger option for the filename }
    { because AS doesnt like '\'                     }
    function bstoslash(const s : string) : string;
      var
         i : longint;
      begin
        for i:=1to length(s) do
         if s[i]='\' then
          bstoslash[i]:='/'
         else
          bstoslash[i]:=s[i];
        bstoslash[0]:=s[0];
      end;

  {$ifdef debug}

    function assigned(p : pointer) : boolean;

      var
         lp : longint;

      begin
  {$ifdef FPC}
         lp:=longint(p);
  {$else}
    {$ifdef DPMI}
         assigned:=(p<>nil);
         exit;
    {$else DPMI}
         if p=nil then
           lp:=0
         else
           lp:=longint(ptrrec(p).seg)*16+longint(ptrrec(p).ofs);
         if (lp<>0) and
            ((lp<longint(seg(heaporg^))*16+longint(ofs(heaporg^))) or
            (lp>longint(seg(heapptr^))*16+longint(ofs(heapptr^)))) then
           runerror(230);
    {$endif DPMI}
  {$endif FPC}
         assigned:=lp<>0;
      end;

  {$endif}

    function min(a,b : longint) : longint;

      begin
         if a>b then
           min:=b
         else min:=a;
      end;

    function max(a,b : longint) : longint;

      begin
         if a<b then
           max:=b
         else max:=a;
      end;

    function ibm2ascii(const s : string) : string;

      var
         i : integer;
         hs : string;
         b : byte;

      begin
         hs:='';
         for i:=1 to length(s) do
           if ((ord(s[i])>127) or (ord(s[i])<32)) or (s[i]='"') then
             begin
                b:=ord(s[i]);
                                hs:=hs+'\'+tostr(b shr 6);
                                b:=b mod 64;
                                hs:=hs+tostr(b shr 3);
                                b:=b mod 8;
                                hs:=hs+tostr(b);
                                if (i<length(s)) and
                                  (ord(s[i+1])>=48) and  (ord(s[i+1])<=57) then
                                  hs:=hs+'","';
                         end
                   else if s[i]='\' then
                         hs:=hs+'\\'
                   else hs:=hs+s[i];
                 ibm2ascii:=hs;
          end;

    function upper(const s : string) : string;

      var
         i : integer;
         hs : string;

      begin
         hs:='';
         for i:=1 to length(s) do
           hs:=hs+upcase(s[i]);
         upper:=hs;
      end;

    procedure uppervar(var s : string);

      var
         i : integer;

      begin
         for i:=1 to length(s) do
           s[i]:=upcase(s[i]);
      end;

   function tostr(i : longint) : string;

     var hs : string;

     begin
        str(i,hs);
        tostr:=hs;
     end;

   function tostr_with_plus(i : longint) : string;

     var hs : string;

     begin
        str(i,hs);
        if i>=0 then
                    tostr_with_plus:='+'+hs
                  else
                    tostr_with_plus:=hs;
         end;

   procedure setstring(var p : pchar;const s : string);

     begin
{$ifdef TP}
             if use_big then
               begin
             p:=pchar(symbolstream.getsize);
                  symbolstream.seek(longint(p));
                  symbolstream.writestr(@s);
          end
        else
{$endif TP}
             p:=strpnew(s);
     end;


 {****************************************************************************
                               File Handling
 ****************************************************************************}

   function  filetimestring( t : longint) : string;

       Function L0(l:longint):string;
       var
         s : string;
       begin
         Str(l,s);
         if l<10 then
          s:='0'+s;
         L0:=s;
       end;

     var
    {$ifndef linux}
       DT : DateTime;
     {$endif}
       Year,Month,Day,Hour,Min,Sec : Word;

     begin
     {$ifndef linux}
       unpacktime(t,DT);
       Year:=dT.year;month:=dt.month;day:=dt.day;
       Hour:=dt.hour;min:=dt.min;sec:=dt.sec;
     {$else}
       EpochToLocal (t,year,month,day,hour,min,sec);
     {$endif}
       filetimestring:=L0(Year)+'/'+L0(Month)+'/'+L0(Day)+' '+L0(Hour)+':'+L0(min)+':'+L0(sec);
     end;

   function path_absolute(const s : string) : boolean;

     begin
        path_absolute:=false;
{$ifdef linux}
        if (length(s)>0) and (s[1]='/') then
          path_absolute:=true;
{$else not linux }
  {$ifdef amiga}
        if ((length(s)>0) and ((s[1]='\') or (s[1]='/'))) or
           (Pos(':',s) = length(s)) then
             path_absolute:=true;
  {$else}
        if ((length(s)>0) and ((s[1]='\') or (s[1]='/'))) or
           ((length(s)>2) and (s[2]=':') and ((s[3]='\') or (s[3]='/'))) then
          path_absolute:=true;
  {$endif}
{$endif linux }

     end;

    Function FileExists ( Const F : String) : Boolean;

      Var
      {$ifdef linux}
         Info : Stat;
      {$else}
         Info : SearchRec;
      {$endif}

          begin
      {$ifdef linux}
           FileExists:=FStat(F,info);
      {$else}
           findfirst(F,anyfile,info);
           FileExists:=doserror=0 ;
      {$endif}
          end;

    Function FixPath(s:string):string;
      const
{$ifndef linux}
   {$ifdef amiga}
        DirSep = '/';
   {$else}
        DirSep = '\';
   {$endif}
{$else}
        DirSep = '/';
{$endif}
      var
        i : longint;
      begin
        for i:=1to length(s) do
         if s[i] in ['/','\'] then
          s[i]:=DirSep;
        if (length(s)>0) and (s[length(s)]<>DirSep) then
         s:=s+DirSep;
        if s='.'+DirSep then
         s:='';
        FixPath:=s;
      end;

   function FixFileName(const s:string):string;
     var
       i      : longint;
       NoPath : boolean;
     begin
       NoPath:=true;
       for i:=length(s) downto 1 do
        begin
          case s[i] of
      {$ifdef Linux}
       '/','\' : begin
                   FixFileName[i]:='/';
                   NoPath:=false; {Skip lowercasing path: 'X11'<>'x11' }
                 end;
      'A'..'Z' : if NoPath then
                  FixFileName[i]:=char(byte(s[i])+32)
                 else
                  FixFileName[i]:=s[i];
      {$else}
        {$ifdef amiga}
         '/','\' : FixFileName[i]:='/';
        'a'..'z' : FixFileName[i]:=char(byte(s[i])-32);
        {$else}
           '/' : FixFileName[i]:='\';
      'a'..'z' : FixFileName[i]:=char(byte(s[i])-32);
        {$endif amiga}
      {$endif}
          else
           FixFileName[i]:=s[i];
          end;
        end;
       FixFileName[0]:=s[0];
     end;

   procedure AddPathToList(var list:string;s:string;first:boolean);
      const
{$ifndef linux}
   {$ifdef amiga}
        DirSep = '/';
   {$else}
        DirSep = '\';
   {$endif}
{$else}
        DirSep = '/';
{$endif}
     var
       LastAdd,
       starti,i,j : longint;
       Found    : boolean;
       CurrentDir,
       CurrPath,
       AddList  : string;
     begin
       if s='' then
        exit;
     {Fix List}
       if (length(list)>0) and (list[length(list)]<>';') then
        begin
          inc(byte(list[0]));
          list[length(list)]:=';'
        end;
       GetDir(0,CurrentDir);
       CurrentDir:=FixPath(CurrentDir);
       AddList:='';
       LastAdd:=1;
       repeat
         j:=Pos(';',s);
         if j=0 then
          j:=255;
       {Get Pathname}
         CurrPath:=FixPath(Copy(s,1,j-1));
         if CurrPath='' then
          CurrPath:='.'+DirSep+';'
         else
          begin
            CurrPath:=FixPath(FExpand(CurrPath))+';';
            if (Copy(CurrPath,1,length(CurrentDir))=CurrentDir) then
             CurrPath:='.'+DirSep+Copy(CurrPath,length(CurrentDir)+1,255);
          end;
         Delete(s,1,j);
       {Check if already in path}
         found:=false;
         i:=0;
         starti:=1;
         while (not found) and (i<length(list)) do
          begin
            inc(i);
            if (list[i]=';') then
             begin
               found:=(CurrPath=Copy(List,starti,i-starti+1));
               if Found then
                begin
                  if First then
                   Delete(List,Starti,i-starti+1); {The new entry is placed first}
                end
               else
                starti:=i+1;
             end;
          end;
         if First then
          begin
            Insert(CurrPath,List,LastAdd);
            inc(LastAdd,Length(CurrPath));
          end
         else
          if not Found then
           List:=List+CurrPath
       until (s='');
     end;

   function search(const f : string;path : string;var b : boolean) : string;

      Var
        singlepathstring : string;
        i : longint;

     begin
     {$ifdef linux}
       for i:=1to length(path) do
        if path[i]=':' then
       path[i]:=';';
     {$endif}
       b:=false;
       search:='';
       repeat
         i:=pos(';',path);
         if i=0 then
           i:=255;
         singlepathstring:=FixPath(copy(path,1,i-1));
         delete(path,1,i);
         If FileExists (singlepathstring+f) then
           begin
             Search:=singlepathstring;
             b:=true;
             exit;
           end;
       until path='';
     end;

   Function GetFileTime ( Var F : File) : Longint;

   Var
{$ifdef linux}
      Info : Stat;
{$endif}
      L : longint;

   begin
     {$ifdef linux}
     FStat (F,Info);
     L:=Info.Mtime;
     {$else}
     GetFTime(f,l);
     {$endif}
     GetFileTime:=L;
   end;

   Function GetNamedFileTime (Const F : String) : Longint;

   var
     L : Longint;
   {$ifndef linux}
     info : SearchRec;
   {$else}
     info : stat;
   {$endif}

   begin
     l:=-1;
     {$ifdef linux}
     if FStat (F,Info) then L:=info.mtime;
     {$else}
     FindFirst (F,anyfile,info);
     if DosError=0 then l:=info.time;
     {$endif}
     GetNamedFileTime:=l;
   end;


   function FindExe(bin:string;var found:boolean):string;
   begin
     bin:=FixFileName(bin)+source_info.exeext;
     FindExe:=Search(bin,'.;'+exepath+';'+dos.getenv('PATH'),found)+bin;
   end;


 {****************************************************************************
                                    Init
 ****************************************************************************}

   procedure globalsinit;

     begin
        { set global (for any file) compiler switches }
{$ifdef i386}
        opt_processors:=i386;
{$endif}
{$ifdef m68k}
       opt_processors := MC68000;
{$endif}
        commandline_output_format:=of_o;
        output_format:=of_o;
        writeasmfile:=false;
        externasm:=false;
        externlink:=false;
        warnings:=true;
        do_build:=false;
        do_make:=true;
        language:='E';
        gendeffile:=false;
        genpm:=false;
        description:='compiled by Free Pascal Compiler';

        { set the local switches informations }
        initswitches:=[cs_check_unit_name,cs_extsyntax];
{$ifdef m68k}
        initswitches:=initswitches+[cs_fp_emulation];
{$endif}
        initpackrecords:=2;

        { statistic value }
        abslines:=1;
{$ifdef tp}
        use_big:=false;
{$endif tp}
        { init container for files to link }
        support_macros:=false;
        support_inline:=false;
        c_like_operators:=false;
        in_args:=false;
        must_be_valid:=true;
        assem_need_external_list:=false;
        not_unit_proc:=true;
     end;

end.
{
  $Log: globals.pas,v $
  Revision 1.6.2.7  1998/08/18 13:41:22  carl
    + 128K default heap for m68k
    + 16K heap for atari

  Revision 1.6.2.6  1998/08/13 13:32:24  carl
    + Amiga path support

  Revision 1.6.2.5  1998/07/29 12:28:49  carl
    * 64k heap for m68k targets

  Revision 1.6.2.4  1998/07/21 12:09:20  carl
    * comp2str now works on m68k targets

  Revision 1.6.2.3  1998/04/08 11:38:44  peter
    * nasm patches, pierres symtable patch

  Revision 1.6.2.2  1998/04/07 21:59:16  peter
    * fixed fixpath, addpath

  Revision 1.6.2.1  1998/04/06 16:21:09  peter
    * carl and mine bugfixes from the mainbranch applied

  Revision 1.6  1998/03/30 21:03:59  florian
    * new version 0.99.5
    + cdecl id

  Revision 1.5  1998/03/30 15:53:00  florian
    * last changes before release:
       - gdb fixed
       - ratti386 warning removed (about unset function result)

  Revision 1.4  1998/03/29 10:49:27  florian
    * small problem with unit search path solved

  Revision 1.3  1998/03/28 23:09:56  florian
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

  Revision 1.2  1998/03/26 11:18:30  florian
    - switch -Sa removed
    - support of a:=b:=0 removed

  Revision 1.1.1.1  1998/03/25 11:18:16  root
  * Restored version

  Revision 1.56  1998/03/22 12:43:31  florian
  *** empty log message ***

  Revision 1.55  1998/03/16 22:42:20  florian
    * some fixes of Peter applied:
      ofs problem, profiler support


  Revision 1.54  1998/03/16 08:49:14  michael
  * Anoither fix for Upper/lowercase paths.

  Revision 1.53  2036/02/07 09:29:32  florian
    * patch of Carl applied

  Revision 1.52  1998/03/10 23:48:36  florian
    * a couple of bug fixes to get the compiler with -OGaxz compiler, sadly
      enough, it doesn't run

  Revision 1.51  1998/03/10 01:17:19  peter
    * all files have the same header
    * messages are fully implemented, EXTDEBUG uses Comment()
    + AG... files for the Assembler generation

  Revision 1.50  1998/03/09 12:58:10  peter
    * FWait warning is only showed for Go32V2 and $E+
    * opcode tables moved to i386.pas/m68k.pas to reduce circular uses (and
      for m68k the same tables are removed)
    + $E for i386

  Revision 1.49  1998/03/05 22:43:46  florian
    * some win32 support stuff added

  Revision 1.48  1998/03/04 17:33:45  michael
  + Changed ifdef FPK to ifdef FPC

  Revision 1.47  1998/03/02 21:21:39  jonas
    + added support for uncertain optimizations

  Revision 1.46  1998/03/02 16:00:31  peter
    * -Ch works again

  Revision 1.45  1998/03/02 13:38:39  peter
    + importlib object
    * doesn't crash on a systemunit anymore
    * updated makefile and depend

  Revision 1.44  1998/03/02 01:48:36  peter
    * renamed target_DOS to target_GO32V1
    + new verbose system, merged old errors and verbose units into one new
      verbose.pas, so errors.pas is obsolete

  Revision 1.43  1998/02/21 03:33:16  carl
    + mit syntax support

  Revision 1.42  1998/02/17 21:20:49  peter
    + Script unit
    + __EXIT is called again to exit a program
    - target_info.link/assembler calls
    * linking works again for dos
    * optimized a few filehandling functions
    * fixed stabs generation for procedures

  Revision 1.41  1998/02/16 13:46:39  michael
  + Further integration of linker object:
    - all options pertaining to linking go directly to linker object
    - removed redundant variables/procedures, especially in OS_TARG...

  Revision 1.40  1998/02/16 12:51:30  michael
  + Implemented linker object

  Revision 1.39  1998/02/14 01:45:21  peter
    * more fixes
    - pmode target is removed
    - search_as_ld is removed, this is done in the link.pas/assemble.pas
    + findexe() to search for an executable (linker,assembler,binder)

  Revision 1.38  1998/02/13 10:35:02  daniel
  * Made Motorola version compilable.
  * Fixed optimizer

  Revision 1.37  1998/02/12 11:50:06  daniel
  Yes! Finally! After three retries, my patch!

  Changes:

  Complete rewrite of psub.pas.
  Added support for DLL's.
  Compiler requires less memory.
  Platform units for each platform.

  Revision 1.36  1998/02/08 01:59:33  peter
    + option -P to allow the use of pipe for assembly output

  Revision 1.35  1998/02/07 09:39:22  florian
    * correct handling of in_main
    + $D,$T,$X,$V like tp

  Revision 1.34  1998/02/06 09:11:19  peter
    * added source_info.exeext and of_none for output_format

  Revision 1.33  1998/02/05 22:27:05  florian
    * small problems fixed: remake3 should now work

  Revision 1.32  1998/02/02 23:41:01  florian
    * data is now dword aligned per default else the stack ajustements are useless

  Revision 1.31  1998/02/02 00:55:31  peter
    * defdatei -> deffile and some german comments to english
    * search() accepts : as seperater under linux
    * search for ppc.cfg doesn't open a file (and let it open)
    * reorganize the reading of parameters/file a bit
    * all the PPC_ environments are now for all platforms

  Revision 1.30  1998/01/28 13:48:38  michael
  + Initial implementation for making libs from within FPC. Not tested, as compiler does not run

  Revision 1.29  1998/01/26 18:51:16  peter
    * ForceSlash() changed to FixPath() which also removes a trailing './'

  Revision 1.28  1998/01/25 18:45:42  peter
    + Search for as and ld at startup
    + source_info works the same as target_info
    + externlink allows only external linking

  Revision 1.27  1998/01/23 22:19:19  michael
  + Implemented setting of dynamic linker name (linux only).
    Declared Make_library
    -Fd switch sets linker (linux only)
  * Reinstated -E option of Pierre

  Revision 1.26  1998/01/23 17:55:07  michael
  + Moved linking stage to it's own unit (link.pas)
    Incorporated Pierres changes, but removed -E switch
    switch for not linking is now -Cn instead of -E

  Revision 1.25  1998/01/23 17:12:12  pierre
    * added some improvements for as and ld :
      - doserror and dosexitcode treated separately
      - PATH searched if doserror=2
    + start of long and ansi string (far from complete)
      in conditionnal UseLongString and UseAnsiString
    * options.pas cleaned (some variables shifted to globals)gl

  Revision 1.24  1998/01/23 08:54:23  florian
  *** empty log message ***

  Revision 1.23  1998/01/22 14:47:10  michael
  + Reinstated linker options as -k option. How did they dissapear ?

  Revision 1.22  1998/01/20 00:21:41  peter
    * under some circumstanes a path was expanded wrong

  Revision 1.21  1998/01/19 16:18:42  peter
  * AddPathtoList supports now ';' seperate paths and optimizes pathnames

  Revision 1.20  1998/01/17 01:57:33  michael
  + Start of shared library support. First working version.

  Revision 1.19  1998/01/16 18:03:14  florian
    * small bug fixes, some stuff of delphi styled constructores added

  Revision 1.18  1998/01/16 12:52:08  michael
  + Path treatment and file searching should now be more or less in their
    definite form:
    - Using now modified AddPathToList everywhere.
    - File Searching mechanism is uniform for all files.
    - Include path is working now !!
    All fixes by Peter Vreman. Tested with remake3 target.

  Revision 1.17  1998/01/16 00:00:54  michael
  + Better and more modular searching and loading of units.
    - searching in tmodule.search_unit.
    - initial Loading in tmpodule.load_ppu.
    - tmodule.init now calls search_unit.
  * Case sensitivity problem of unix hopefully solved now forever.
    (All from Peter Vreman, checked with remake3)

  Revision 1.16  1998/01/15 13:01:45  michael
  + Some more changes to ease file handling (From Peter Vreman)

  Revision 1.15  1998/01/13 23:11:10  florian
    + class methods

  Revision 1.14  1998/01/13 17:10:49  michael
  + Implemented
    GetFileTime      (get opend file time)
    GetNamedFileTime (get file time starting from file name)
    FileExist        (File exists: True)
  * Changed Time2string (or so) To work also with linux times.
    Times returned are now linux times under linux, not DateTimes

  Revision 1.13  1998/01/11 04:15:00  carl
  + correct floating point support for m68k

  Revision 1.12  1998/01/09 18:01:15  florian
    * VIRTUAL isn't anymore a common keyword
    + DYNAMIC is equal to VIRTUAL

  Revision 1.11  1998/01/09 13:39:54  florian
    * public, protected and private aren't anymore key words
    + published is equal to public

  Revision 1.10  1998/01/07 00:16:51  michael
  Restored released version (plus fixes) as current

  Revision 1.8  1997/12/14 22:43:18  florian
    + command line switch -Xs for DOS (passes -s to the linker to strip symbols from
      executable)
    * some changes of Carl-Eric implemented

  Revision 1.7  1997/12/13 18:59:45  florian
  + I/O streams are now also declared as external, if neccessary
  * -Aobj generates now a correct obj file via nasm

  Revision 1.6  1997/12/12 13:28:25  florian
  + version 0.99.0
  * all WASM options changed into MASM
  + -O2 for Pentium II optimizations

  Revision 1.5  1997/12/09 13:38:41  carl
  - removed some ifdef cpu

  Revision 1.4  1997/11/28 18:14:33  pierre
   working version with several bug fixes

  Revision 1.3  1997/11/28 08:46:46  florian
  Small changes

  Revision 1.2  1997/11/27 17:51:03  carl
  + added aktasmmode variable from rasm386.pas

  Revision 1.1.1.1  1997/11/27 08:32:56  michael
  FPC Compiler CVS start


  Pre-CVS log:

  CEC   Carl-Eric Codere
  FK    Florian Klaempfl
  PM    Pierre Muller
  +     feature added
  -     removed
  *     bug fixed or changed

  History:
      6th september 1997:
        + Added support for Emulation of Floating point instructions
              (Motorola only) (CEC)
      3 octboer 1997:
        + Works for both intel and motorola target (CEC).
      4 october 1997:
        + changed processor type to motorola (in ifdef m68k)
          and object output type. (check ifdef to find all
          changes).
      15th october 1997:
         + added cs_static_keyword switch to allow static keyword in objects (PM)

}
