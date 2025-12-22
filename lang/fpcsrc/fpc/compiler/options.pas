{
    $Id: options.pas,v 1.3.2.2 1998/08/18 13:43:50 carl Exp $
    Copyright (c) 1993-98 by the FPC development team

    Reads command line options and config files

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
unit options;

interface

{$I optmsg.inc}
{$I optidx.inc}

type
  POption=^TOption;
  TOption=object
    NoPressEnter,
    Logowritten : boolean;
    Constructor Init;
    Destructor Done;
    procedure Comment(l:longint;t:toptionconst);
    procedure Comment1(l:longint;t:toptionconst;const s1:string);
    procedure WriteLogo;
    procedure WriteInfo;
    procedure WriteHelpPages;
    procedure IllegalPara(const opt:string);
    procedure Setbool(const opts:string;var b:boolean);
    procedure interpret_proc_specific_options(const opt:string);virtual;
    procedure interpret_option(const opt :string);
    procedure Interpret_file(const filename : string);
    procedure Read_Parameters;
  end;

  procedure get_exepath;
  procedure read_arguments;

implementation

uses
  cobjects,globals,systems,
  verbose,dos,scanner,link,verb_def,messages,os2_targ
{$ifdef i386}
  ,opts386
{$endif}
{$ifdef m68k}
  ,opts68k
{$endif}
  ;

const
  page_size = 24;
{$ifdef i386}
  ppccfg : string = 'pp68k.cfg';
{$else}
  ppccfg : string = 'pp68k.cfg';
{$endif}

var
  readfilename,             { read filename from the commandline ? }
  read_configfile,          { read config file, set when a cfgfile is found }
  target_is_set : boolean;  { do not allow contradictory target settings }
  msgfilename,
  param_file    : string;   { file to compile specified on the commandline }
  optionmsg     : pmessage;
  option        : poption;

{****************************************************************************
                                 Defines
****************************************************************************}

procedure def_symbol(const s : string);
begin
  if s='' then
   exit;
  commandlinedefines.concat(new(pstring_item,init(upper(s))));
end;


procedure undef_symbol(const s : string);
var
  item,next : pstring_item;
begin
  if s='' then
   exit;
  item:=pstring_item(commandlinedefines.first);
  while assigned(item) do
   begin
     if (item^.str^=s) then
      begin
        next:=pstring_item(item^.next);
        commandlinedefines.remove(item);
        item:=next;
      end
     else
      if item<>pstring_item(item^.next) then
       item:=pstring_item(item^.next)
      else
       break;
   end;
end;


function check_symbol(const s:string):boolean;
var
  hp : pstring_item;
begin
  hp:=pstring_item(commandlinedefines.first);
  while assigned(hp) do
   begin
     if (hp^.str^=s) then
      begin
        check_symbol:=true;
        exit;
      end;
     hp:=pstring_item(hp^.next);
   end;
  check_symbol:=false;
end;

{****************************************************************************
                                 Toption
****************************************************************************}


procedure Toption.Comment(l:longint;t:toptionconst);
begin
  if (Verbosity and l)<>0 then
   WriteLn(optionmsg^.Get(ord(t)));
end;


procedure Toption.Comment1(l:longint;t:toptionconst;const s1:string);
begin
  if (Verbosity and l)<>0 then
   WriteLn(optionmsg^.Get1(ord(t),s1));
end;


procedure Toption.WriteLogo;
var
  i : toptionconst;
begin
  if Logowritten then
   exit;
  for i:=logo_start to logo_end do
   Comment1(V_Default,i,target);
  Logowritten:=true;
end;


procedure Toption.WriteInfo;
var
  i : toptionconst;
begin
  for i:=info_start to info_end do
   Comment(V_Default,i);
  Stop;
end;


procedure Toption.WriteHelpPages;

  function PadEnd(s:string;i:longint):string;
  begin
    while (length(s)<i) do
     s:=s+' ';
    PadEnd:=s;
  end;

var
  lastident,
  i,j,
  outline,
  ident,
  lines : longint;
  show  : boolean;
  opt   : string[32];
  input,
  s     : string;
begin
  Write(paramstr(0));
  Comment(V_Default,usage);
  lastident:=0;
  if logowritten then
   lines:=3
  else
   lines:=1;
  for i:=1 to optionhelplines do
   begin
   { get a line and reset }
     s:=optionmsg^.Get(ord(endoptionconst)-1+i);
     ident:=0;
     show:=false;
   { parse options }
     case s[1] of
{$ifdef i386}
      '3',
{$endif}
{$ifdef m68k}
      '6',
{$endif}
      '*' : show:=true;
     end;
     if show then
      begin
        case s[2] of
{$ifdef linux}
         'L',
{$endif}
{$ifdef os2}
         'O',
{$endif}
         '*' : show:=true;
        else
         show:=false;
        end;
      end;
   { now we may show the message or not }
     if show then
      begin
        case s[3] of
         '0' : begin
                 ident:=0;
                 outline:=0;
               end;
         '1' : begin
                 ident:=2;
                 outline:=7;
               end;
         '2' : begin
                 ident:=11;
                 outline:=9;
               end;
         '3' : begin
                 ident:=21;
                 outline:=6;
               end;
        end;
        j:=pos('_',s);
        opt:=Copy(s,4,j-4);
        if opt='*' then
         opt:=''
        else
         opt:=PadEnd('-'+opt,outline);
        if (ident=0) and (lastident<>0) then
         begin
           Writeln;
           inc(Lines);
         end;
      { page full ? }
        if (lines>=page_size) then
         begin
           if not NoPressEnter then
            begin
              write('*** press enter ***');
              readln(input);
              if upper(input)='Q' then
               stop;
            end;
           lines:=0;
         end;
        WriteLn(PadEnd('',ident)+opt+Copy(s,j+1,255));
        LastIdent:=Ident;
        inc(Lines);
      end;
   end;
  stop;
end;


procedure Toption.IllegalPara(const opt:string);
begin
  Comment1(V_Default,illegal_para,opt);
  Comment(V_Default,help_pages_para);
  stop;
end;


procedure Toption.Setbool(const opts:string;var b:boolean);
var
  i : longint;
begin
  b:=true;
  for i:=3 to length(opts) do
   case opts[i] of
    '-' : b:=false;
    '+' : b:=true;
   else
    IllegalPara(opts);
   end;
end;


procedure TOption.interpret_proc_specific_options(const opt:string);
begin
end;


procedure TOption.interpret_option(const opt:string);
var
  code : word;
  c    : char;
  more : string;
  j    : longint;
begin
  if opt='' then
   exit;
  case opt[1] of
 '-' : begin
         more:=Copy(opt,3,255);
         case opt[2] of
              '?' : WriteHelpPages;
              'h' : begin
                      NoPressEnter:=true;
                      WriteHelpPages;
                    end;
              'a' : writeasmfile:=true;
{$ifdef tp}
              'b' : setbool(opt,use_big);
{$endif}
              'B' : if more='' then
                     do_build:=true
                    else
                     IllegalPara(opt);
              'C' : begin
                      for j:=1 to length(more) do
                       case more[j] of
                        'a','e' : ;
                            'h' : begin
                                    val(copy(more,j+1,length(more)-j),heapsize,code);
                                    if (code<>0) or (heapsize>=67107840) or (heapsize<1024) then
                                     IllegalPara(opt);
                                    break;
                                  end;
                            'i' : initswitches:=initswitches+[cs_iocheck];
                            'n' : initswitches:=initswitches+[cs_no_linking];
                            'o' : initswitches:=initswitches+[cs_check_overflow];
                            'r' : initswitches:=initswitches+[cs_rangechecking];
                            's' : begin
                                    val(copy(more,j+1,length(more)-j),stacksize,code);
                                    if (code<>0) or (stacksize>=67107840) or (stacksize<1024) then
                                     IllegalPara(opt);
                                    break;
                                  end;
                            { this is not a very good choice for that }
                            't' : initswitches:=initswitches+[cs_check_stack];
                            'D' : begin
                                    initswitches:=initswitches-[cs_link_static];
                                    initswitches:=initswitches+[cs_link_dynamic];
                                  end;
                            'S' : begin
                                    initswitches:=initswitches-[cs_link_dynamic];
                                    initswitches:=initswitches+[cs_link_static];
                                  end;
                       else IllegalPara(opt);
                       end;
                    end;
              'd' : def_symbol(more);
{$ifdef os2}
              'D' : begin
                      for j:=1 to length(more) do
                       case more[j] of
                        'd' : begin
                                description:=Copy(more,j+1,255);
                                break;
                              end;
                        'o' : begin
                                if target_info.target<>target_OS2 then
                                 Comment(v_warning,def_only_for_os2);
                                gendeffile:=true;
                              end;
                        'w' : genpm:=true;
                       else IllegalPara(opt);
                       end;
                    end;
{$endif}
              'E' : initswitches:=initswitches+[cs_no_linking];
              'F' : begin
                      c:=more[1];
                      Delete(more,1,1);
                      case c of
                       'e' : SetRedirectFile(More);
                       'r' : Msgfilename:=More;
                       'i' : AddPathToList(includesearchpath,More,false);
                       'l' : AddPathToList(Linker.librarysearchpath,More,false);
                       'u' : AddPathToList(unitsearchpath,More,false);
{$ifdef linux}
                       'g' : Linker.gcclibrarypath:=More;
                       'L' : if More<>'' then
                              Linker.DynamicLinker:=More
                             else
                              IllegalPara(opt);
{$endif}
                      else IllegalPara(opt);
                      end;
                    end;
              'g' : begin
                      initswitches:=initswitches+[cs_debuginfo];
                      for j:=1 to length(more) do
                       case more[j] of
{$ifdef UseBrowser}
                        'b' : use_browser:=true;
{$endif UseBrowser}
{$ifdef GDB}
                        'g' : use_gsym:=true;
                        'd' : use_dbx:=true;
                        'p' : initswitches:=initswitches+[cs_profile];
{$endif GDB}
                       else IllegalPara(opt);
                       end;
                    end;
              'i' : WriteInfo;
              'I' : AddPathToList(includesearchpath,More,false);
              'l' : if more='' then
                     WriteLogo
                    else
                     IllegalPara(opt);
              'k' : if more<>'' then
                     Linker.LinkOptions:=Linker.LinkOptions+' '+More
                    else
                     IllegalPara(opt);
              'L' : begin
                      if length(More)<>1 then
                       IllegalPara(opt);
                      case More[1] of
                       'E' : language:='E';
                       'D' : language:='D';
                      else IllegalPara(opt);
                      end
                    end;
              'n' : if More='' then
                     read_configfile:=false
                    else
                     IllegalPara(opt);
              'o' : if More<>'' then
                     Linker.SetFileName(More)
                    else
                     IllegalPara(opt);
              'p' :
{$ifdef Splitheap}
                  if length(opt)=2 then
                     testsplit:=true
                    else
{$endif Splitheap}
                   begin
                     case more[1] of
                      'g' : initswitches:=initswitches+[cs_profile];
                     else
                      IllegalPara(opt);
                     end;
                   end;
{$ifdef linux}
              'P' : use_pipe:=true;
{$endif}
              's' : begin
                      setbool(opt,externasm);
                      setbool(opt,externlink);
                    end;
              'S' : begin
                      for j:=1 to length(more) do
                       case more[j] of
                        'c' : c_like_operators:=true;
                        'd' : dispose_asm_lists:=true;
                        'e' : MaxErrorCount:=1;
                        'g' : initswitches:=initswitches+[cs_support_goto];
                        'i' : support_inline:=true;
                        'm' : begin
                              { init macro buffer }
                                if not(support_macros) then
                                 new(macrobuffer);
                                support_macros:=true;
                              end;
                        'o' : initswitches:=initswitches+[cs_tp_compatible];
                        't' : initswitches:=initswitches+[cs_static_keyword];
                        '2' : begin
                                 initswitches:=initswitches+[cs_delphi2_compatible];
                                 initswitches:=initswitches+[cs_load_objpas_unit]
                              end;
                        's' : initswitches:=initswitches+[cs_checkconsname];
                       else IllegalPara(opt);
                       end;
                    end;
              'T' : begin
                      more:=Upper(More);
                      if not target_is_set then
                       begin
                       { her we should undefine the default target }
                         undef_symbol(target_info.short_name);
                         if not(set_string_target(More)) then
                          IllegalPara(opt);
                         def_symbol(target_info.short_name);
                         target_is_set:=true;
                       end
                      else
                       if More<>target_info.short_name then
                        Comment1(V_Warning,target_is_already_set,target_info.short_name);
                    end;
              'u' : undef_symbol(upper(More));
              'U' : begin
                      for j:=1 to length(more) do
                       case more[j] of
                        'l' : begin
                                if j<length(opt) then
                                 case opt[j+1] of
                                  'd' : begin
                                          initswitches:=initswitches+[cs_unit_to_lib];
                                          if target_info.target in [target_GO32V1,target_GO32V2] then
                                           Comment(V_Warning,no_shared_lib_under_dos)
                                          else
                                           initswitches:=initswitches+[cs_shared_lib];
                                         end;
                                   's' : initswitches:=initswitches+[cs_unit_to_lib];
                                  else IllegalPara(opt);
                                  end
                                 else
                                  IllegalPara(opt);
                              end;
                        's' : initswitches:=initswitches+[cs_compilesystem];
                        'n' : initswitches:=initswitches+[cs_check_unit_name];
                        { 'o' : initswitches:=initswitches+[cs_load_objpas_unit]; }
                        'p' : begin
                                AddPathToList(unitsearchpath,Copy(More,j+1,255),false);
                                break;
                              end;
                       else IllegalPara(opt);
                       end;
                    end;
              'v' : if not setverbosity(More) then
                     IllegalPara(opt);
              'X' : begin
                      for j:=1 to length(More) do
                       case More[j] of
{$ifdef linux}
                        'c' : Linker.LinkToC:=true;
{$endif}
                        's' : Linker.Strip:=true;
                       else IllegalPara(opt);
                       end;
                    end;
       { give processor specific options a chance }
         else
          interpret_proc_specific_options(opt);
         end;
       end;
 '@' : begin
         Comment(V_Error,no_nested_response_file);
         Stop;
       end;
  else
   begin
     if readfilename then
      begin
        if (length(param_file)<>0) then
         Comment(v_error,only_one_source_support);
        param_file:=opt;
      end;
   end;
  end;
end;


procedure Toption.Interpret_file(const filename : string);

  procedure RemoveSep(var fn:string);
  var
    i : longint;
  begin
    i:=0;
    while (i<length(fn)) and (fn[i+1] in [',',' ',#9]) do
     inc(i);
    Delete(fn,1,i);
  end;

  function GetName(var fn:string):string;
  var
    i : longint;
  begin
    i:=0;
    while (i<length(fn)) and (fn[i+1] in ['A'..'Z','0'..'9','_','-']) do
     inc(i);
    GetName:=Copy(fn,1,i);
    Delete(fn,1,i);
  end;

const
  maxlevel=16;
var
  f     : text;
  s,
  opts  : string;
  skip  : array[0..maxlevel-1] of boolean;
  level : byte;
begin
  assign(f,filename);
  {$I-}
   reset(f);
  {$I+}
  if ioresult<>0 then
   begin
     Comment1(V_Error,unable_open_file,filename);
     exit;
   end;
  fillchar(skip,sizeof(skip),0);
  level:=0;
  while not eof(f) do
   begin
     readln(f,opts);
     RemoveSep(opts);
     if (opts<>'') then
      begin
        if opts[1]='#' then
         begin
           Delete(opts,1,1);
           s:=upper(GetName(opts));
           if (s='SECTION') then
            begin
              RemoveSep(opts);
              s:=upper(GetName(opts));
              if level=0 then
               skip[level]:=not (check_symbol(s) or (s='COMMON'));
            end
           else
            if (s='IFDEF') then
             begin
               RemoveSep(opts);
               if Level>=maxlevel then
                begin
                  Comment(V_Fatal,too_many_ifdef);
                  stop;
                end;
               inc(Level);
               skip[level]:=(skip[level-1] or (not check_symbol(upper(GetName(opts)))));
             end
           else
            if (s='IFNDEF') then
             begin
               RemoveSep(opts);
               if Level>=maxlevel then
                begin
                  Comment(V_Fatal,too_many_ifdef);
                  stop;
                end;
               inc(Level);
               skip[level]:=(skip[level-1] or (check_symbol(upper(GetName(opts)))));
             end
           else
            if (s='ELSE') then
             skip[level]:=skip[level-1] or (not skip[level])
           else
            if (s='ENDIF') then
             begin
               skip[level]:=false;
               if Level=0 then
                begin
                  Comment(V_Fatal,too_many_endif);
                  stop;
                end;
               dec(level);
             end
           else
            if (not skip[level]) then
             begin
               if (s='DEFINE') then
                begin
                  RemoveSep(opts);
                  def_symbol(upper(GetName(opts)));
                end
              else
               if (s='UNDEF') then
                begin
                  RemoveSep(opts);
                  undef_symbol(upper(GetName(opts)));
                end
              else
               if (s='WRITE') then
                begin
                  Delete(opts,1,1);
                  WriteLn(opts);
                end
              else
               if (s='INCLUDE') then
                begin
                  Delete(opts,1,1);
                  Interpret_file(opts);
                end;
            end;
         end
        else
         begin
           if (not skip[level]) and (opts[1]='-') then
            interpret_option(opts)
         end;
      end;
   end;
  if Level>0 then
   Comment(V_Warning,too_less_endif);
  Close(f);
end;


procedure toption.read_parameters;
var
  opts       : string;
  paramindex : longint;
begin
  paramindex:=0;
  while paramindex<paramcount do
   begin
     inc(paramindex);
     opts:=paramstr(paramindex);
     if opts[1]='@' then
      begin
        Delete(opts,1,1);
        Comment1(V_Info,reading_further_from,opts);
        interpret_file(opts);
      end
     else
      interpret_option(opts);
   end;
end;


constructor TOption.Init;
begin
  LogoWritten:=false;
  NoPressEnter:=false;
end;


destructor TOption.Done;
begin
end;


{****************************************************************************
                              Callable Routines
****************************************************************************}

procedure get_exepath;
var
  hs1 : namestr;
  hs2 : extstr;
begin
  exepath:=dos.getenv('PPC_EXEC_PATH');
  if exepath='' then
   fsplit(FixFileName(paramstr(0)),exepath,hs1,hs2);
{$ifdef linux}
  if exepath='' then
   fsearch(hs1,dos.getenv('PATH'));
   exepath:='/usr/bin/';
{$endif}
  exepath:=FixPath(exepath);
end;


procedure read_arguments;
var
  configpath : pathstr;
  option     : poption;
begin
{$ifdef i386}
  option:=new(poption386,Init);
{$else}
  {$ifdef m68k}
    option:=new(poption68k,Init);
  {$else}
    option:=new(poption,Init);
  {$endif}
{$endif}
{ Load messages }
  optionmsg:=new(pmessage,Init(@optiontxt,ord(endoptionconst)+optionhelplines));

  if paramcount=0 then
   Option^.WriteHelpPages;

{ default defines }
  def_symbol(target_info.short_name);
  def_symbol('FPK');
  def_symbol('FPC');
  def_symbol('VER'+version_nr);
  def_symbol('VER'+version_nr+'_'+release_nr);
  def_symbol('VER'+version_nr+'_'+release_nr+'_'+patch_nr);
  def_symbol('NEW_ERRORS'); { Temporary, until things settle down }
{ some stuff for TP compatibility }
{$ifdef i386}
  def_symbol('CPU86');
  def_symbol('CPU87');
  if (target_info.target in [target_GO32V1,target_GO32V2]) then
   def_symbol('DPMI'); { MSDOS is not defined in BP whewn target is DPMI }
{$endif}
{$ifdef m68k}
  def_symbol('CPU68');
{$endif}

  msgfilename:=dos.getenv('PPC_ERROR_FILE');
{$ifdef extern_msg}
  if msgfilename='' then
   msgfilename:=exepath+'errore.msg';
{$endif}

  { Order to read ppc386.cfg:
     1 - current dir
     2 - configpath
     3 - compiler path }
  configpath:=FixPath(dos.getenv('PPC_CONFIG_PATH'));
{$ifdef linux}
  if configpath='' then
   configpath:='/etc/';
{$endif}
  read_configfile:=true;
  if not FileExists(ppccfg) then
   begin
{$ifdef linux}
     if (dos.getenv('HOME')<>'') and FileExists(FixPath(dos.getenv('HOME'))+'.'+ppccfg) then
      ppccfg:=FixPath(dos.getenv('HOME'))+'.'+ppccfg
     else
{$endif}
      if FileExists(configpath+ppccfg) then
       ppccfg:=configpath+ppccfg
     else
      if FileExists(exepath+ppccfg) then
       ppccfg:=exepath+ppccfg
     else
      read_configfile:=false;
   end;

{ Read commandline and configfile }
  target_is_set:=false;
  param_file:='';
  readfilename:=true;

  option^.read_parameters;
  if read_configfile then
   begin
{$ifdef EXTDEBUG}
     comment(V_Error,'read config file  #'+ppccfg+'#');
{$endif EXTDEBUG}
     option^.interpret_file(ppccfg);
   { Reread parameters to overwrite the options }
     readfilename:=false;
     option^.read_parameters;
   end;
  commandline_output_format:=output_format;

{ Check file to compile }
  if param_file='' then
   begin
     option^.Comment(v_error,no_source_found);
     Stop;
   end;
{$ifndef linux}
  param_file:=FixFileName(param_file);
{$endif}
  fsplit(param_file,inputdir,inputfile,inputextension);
  if inputextension='' then
   begin
     if FileExists(inputdir+inputfile+target_info.sourceext) then
      inputextension:=target_info.sourceext
     else
      if FileExists(inputdir+inputfile+target_info.pasext) then
       inputextension:=target_info.pasext;
   end;

{ add unit environment and exepath to the unit search path }
  if inputdir<>'' then
   AddPathToList(Unitsearchpath,inputdir,true);
  AddPathToList(UnitSearchPath,dos.getenv(target_info.unit_env),false);
  AddPathToList(UnitSearchPath,ExePath,false);
{ Add Current Directory as the first path to search }
  AddPathToList(unitsearchpath,'.',true);
  AddPathToList(objectsearchpath,'.',true);
  AddPathToList(includesearchpath,'.',true);

  if msgfilename<>'' then
   LoadMsgFile(msgfilename);

  if gendeffile then
   write_def_file;

  dispose(optionmsg,Done);
  dispose(option,Done);
end;


end.
{
  $Log: options.pas,v $
  Revision 1.3.2.2  1998/08/18 13:43:50  carl
    + Added -Sd switch

  Revision 1.3.2.1  1998/04/08 12:31:32  peter
    + .ppc386.cfg and #INCLUDE support

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

  Revision 1.52  1998/03/22 12:43:32  florian
  *** empty log message ***

  Revision 1.51  1998/03/16 22:42:20  florian
    * some fixes of Peter applied:
      ofs problem, profiler support

  Revision 1.50  2036/02/07 09:26:56  florian
    * more fixes to get -Ox work

  Revision 1.49  1998/03/10 16:27:39  pierre
    * better line info in stabs debug
    * symtabletype and lexlevel separated into two fields of tsymtable
    + ifdef MAKELIB for direct library output, not complete
    + ifdef CHAINPROCSYMS for overloaded seach across units, not fully
      working
    + ifdef TESTFUNCRET for setting func result in underfunction, not
      working

  Revision 1.48  1998/03/10 12:55:08  peter
    + preprocessor for the configfile
    * fixed options helppage
    * -h shows the helppages without waiting

  Revision 1.47  1998/03/10 01:17:20  peter
    * all files have the same header
    * messages are fully implemented, EXTDEBUG uses Comment()
    + AG... files for the Assembler generation

  Revision 1.46  1998/03/09 16:47:56  jonas
    * the -Xs option works again

  Revision 1.45  1998/03/09 12:58:11  peter
    * FWait warning is only showed for Go32V2 and $E+
    * opcode tables moved to i386.pas/m68k.pas to reduce circular uses (and
      for m68k the same tables are removed)
    + $E for i386

  Revision 1.44  1998/03/06 01:08:59  peter
    * removed the conflicts that had occured

  Revision 1.43  1998/03/06 00:52:29  peter
    * replaced all old messages from errore.msg, only ExtDebug and some
      Comment() calls are left
    * fixed options.pas

  Revision 1.42  1998/03/05 22:41:29  florian
    + missing constructor to options object added

  Revision 1.41  1998/03/05 02:44:13  peter
    * options cleanup and use of .msg file

  Revision 1.40  1998/03/04 17:33:46  michael
  + Changed ifdef FPK to ifdef FPC

  Revision 1.39  1998/03/04 14:18:59  michael
  * modified messaging system

  Revision 1.38  1998/03/02 16:02:03  peter
    * new style messages for pp.pas
    * cleanup of pp.pas

  Revision 1.37  1998/03/02 01:48:45  peter
    * renamed target_DOS to target_GO32V1
    + new verbose system, merged old errors and verbose units into one new
      verbose.pas, so errors.pas is obsolete

  Revision 1.36  1998/03/01 22:46:13  florian
    + some win95 linking stuff
    * a couple of bugs fixed:
      bug0055,bug0058,bug0059,bug0064,bug0072,bug0093,bug0095,bug0098

  Revision 1.35  1998/02/22 23:56:21  peter
    * fixed some strange syntax errors

  Revision 1.34  1998/02/22 21:55:45  carl
    + added Ct switch display

  Revision 1.33  1998/02/18 08:56:26  michael
  * GccLibraryPath and Dynamiclinker are linux only

  Revision 1.32  1998/02/17 21:20:51  peter
    + Script unit
    + __EXIT is called again to exit a program
    - target_info.link/assembler calls
    * linking works again for dos
    * optimized a few filehandling functions
    * fixed stabs generation for procedures

  Revision 1.31  1998/02/16 13:46:41  michael
  + Further integration of linker object:
    - all options pertaining to linking go directly to linker object
    - removed redundant variables/procedures, especially in OS_TARG...

  Revision 1.30  1998/02/14 01:45:22  peter
    * more fixes
    - pmode target is removed
    - search_as_ld is removed, this is done in the link.pas/assemble.pas
    + findexe() to search for an executable (linker,assembler,binder)

  Revision 1.29  1998/02/13 10:35:11  daniel
  * Made Motorola version compilable.
  * Fixed optimizer

  Revision 1.28  1998/02/12 11:50:14  daniel
  Yes! Finally! After three retries, my patch!

  Changes:

  Complete rewrite of psub.pas.
  Added support for DLL's.
  Compiler requires less memory.
  Platform units for each platform.

  Revision 1.27  1998/02/08 01:59:33  peter
    + option -P to allow the use of pipe for assembly output

  Revision 1.26  1998/02/07 09:39:22  florian
    * correct handling of in_main
    + $D,$T,$X,$V like tp

  Revision 1.25  1998/02/02 00:55:33  peter
    * defdatei -> deffile and some german comments to english
    * search() accepts : as seperater under linux
    * search for ppc.cfg doesn't open a file (and let it open)
    * reorganize the reading of parameters/file a bit
    * all the PPC_ environments are now for all platforms

  Revision 1.24  1998/02/01 22:41:05  florian
    * clean up
    + system.assigned([class])
    + system.assigned([class of xxxx])
    * first fixes of as and is-operator

  Revision 1.23  1998/01/30 20:00:13  carl
    * Missing Target OS info

  Revision 1.22  1998/01/30 17:38:36  carl
    * Line too long errors under Borland Pascal

  Revision 1.21  1998/01/28 13:48:40  michael
  + Initial implementation for making libs from within FPC. Not tested, as compiler does not run

  Revision 1.20  1998/01/25 18:45:44  peter
    + Search for as and ld at startup
    + source_info works the same as target_info
    + externlink allows only external linking

  Revision 1.19  1998/01/23 22:19:18  michael
  + Implemented setting of dynamic linker name (linux only).
    Declared Make_library
    -Fd switch sets linker (linux only)
  * Reinstated -E option of Pierre

  Revision 1.18  1998/01/23 17:55:08  michael
  + Moved linking stage to it's own unit (link.pas)
    Incorporated Pierres changes, but removed -E switch
    switch for not linking is now -Cn instead of -E

  Revision 1.17  1998/01/23 17:12:13  pierre
    * added some improvements for as and ld :
      - doserror and dosexitcode treated separately
      - PATH searched if doserror=2
    + start of long and ansi string (far from complete)
      in conditionnal UseLongString and UseAnsiString
    * options.pas cleaned (some variables shifted to globals)gl

  Revision 1.16  1998/01/22 14:47:11  michael
  + Reinstated linker options as -k option. How did they dissapear ?

  Revision 1.15  1998/01/22 08:57:53  peter
    + added target_info.pasext and target_info.libext

  Revision 1.14  1998/01/19 10:49:09  michael
  * set library stuff only for i386, not m68k

  Revision 1.13  1998/01/17 22:07:40  florian
    * -Xs is also valid for DOS target

  Revision 1.12  1998/01/17 01:57:34  michael
  + Start of shared library support. First working version.

  Revision 1.11  1998/01/16 22:41:27  michael
  * restored lost changes by last commit

  Revision 1.10  1998/01/16 12:52:11  michael
  + Path treatment and file searching should now be more or less in their
    definite form:
    - Using now modified AddPathToList everywhere.
    - File Searching mechanism is uniform for all files.
    - Include path is working now !!
    All fixes by Peter Vreman. Tested with remake3 target.

  Revision 1.8  1998/01/13 17:13:07  michael
  * File time handling and file searching is now done in an OS-independent way,
    using the new file treating functions in globals.pas.

  Revision 1.7  1998/01/12 01:07:14  michael
  * config file is now read in correct order (By Peter Vreman)

  Revision 1.6  1998/01/11 03:41:59  carl
  + added OS for m68k target / changed config fname under m68k

  Revision 1.5  1998/01/08 17:01:14  carl
  * def_symbol(`MSDOS`) removed since in TP in DPMI mode this symbol is not
  defined.

  Revision 1.4  1998/01/07 00:16:52  michael
  Restored released version (plus fixes) as current

  Revision 1.3  1997/12/14 22:43:19  florian
    + command line switch -Xs for DOS (passes -s to the linker to strip symbols from
      executable)
    * some changes of Carl-Eric implemented

  Revision 1.2  1997/11/28 18:14:38  pierre
   working version with several bug fixes

  Revision 1.1.1.1  1997/11/27 08:32:57  michael
  FPC Compiler CVS start


  Pre-CVS log:

  CEC   Carl-Eric Codere
  FK    Florian Klaempfl
  PM    Pierre Muller
  +     feature added
  -     removed
  *     bug fixed or changed

  History:
      september 1997:
         * order of reading changed:
           first read command line args,
           read ppc386.cfg at last
           finally read command line again.
           this is necessary to read the right sections in ppc386.cfg (PM)
      22th september 1997:
         * changed switch -So to TP compatibilty
         + switch -S2 for Delphi compatibilty    (FK)
      15th october 1997:
         + added switch -St to allow static keyword in objects (PM)
      5th november 1997:
         + added -n to disable ppc386.cfg reading (PM)
      20th november 1997:
         + default symbols moved from parser.pas to here (PM)
}
