{****************************************************************************

    $Id: dumpppu.pp,v 1.7 1998/08/12 12:17:07 carl Exp $

    Dumps the contents of a FPC unit file (PPU File)
    Copyright (c) 1995,97 by Florian Klaempfl and Michael Van Canneyt

    Members of the FPC Development Team

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

{
  possible compiler switches (* marks a currently required switch):
  -----------------------------------------------------------------
  BIG_ENDIAN    Target machine on which this machine will run is
                a BIG endian machine (such as the m68k)
}

{$ifdef TP}
{$N+,E+,G+}
{$endif}

program dumpppu;

  var
     f : file;
     version : longint;
     Filename : string;
     nrfile : longint;
     flags : byte;

    const
       ibloadunit = 1;
       iborddef = 2;
       ibpointerdef = 3;
       ibtypesym = 4;
       ibarraydef = 5;
       ibprocdef = 6;
       ibprocsym = 7;
       iblinkofile = 8;
       ibstringdef = 9;
       ibvarsym = 10;
       ibconstsym = 11;
       ibinitunit = 12;
       ibaufzaehlsym = 13;
       ibtypedconstsym = 14;
       ibrecorddef = 15;
       ibfiledef = 16;
       ibformaldef = 17;
       ibobjectdef = 18;
       ibenumdef = 19;
       ibsetdef = 20;
       ibprocvardef = 21;
       ibsourcefile = 22;
       ibdbxcount = 23;
       ibfloatdef = 24;
       ibref = 25;
       ibextsymref = 26;
       ibextdefref = 27;
       ibabsolutesym = 28;
       ibclassrefdef = 29;
       ibpropertysym = 30;
       iblibraries = 31;
       iblongstringdef = 32;
       ibansistringdef = 33;
       ibunitname      = 34;
       ibwidestringdef = 35;
       ibstaticlibs    = 36;
       ibend = 255;

       { unit flags }
       uf_init = 1;
       uf_uses_dbx = 2;
       uf_uses_browser = 4;
       uf_in_library = 8;
       uf_shared_library = 16;
       uf_big_endian = 32;
Type

  absolutetyp = (tovar,toasm,toaddr);

       tbasetype = (uauto,uvoid,uchar,
                    u8bit,u16bit,u32bit,
                    s8bit,s16bit,s32bit,
                    bool8bit,bool16bit,bool32bit);

       { don't change the order of these - used to determine processor }
       { taken from FPC v0.99.5 systems.pas                            }
       ttarget = (target_GO32V1,target_OS2,target_LINUX,
                  target_WIN32,target_GO32V2,
                  target_Amiga,target_Atari,target_Mac68k);


var abstyp : absolutetyp;
    utarget : ttarget;

    function upper(const s : string) : string;
      var
         i  : longint;
      begin
         for i:=1 to length(s) do
          if s[i] in ['a'..'z'] then
           upper[i]:=char(byte(s[i])-32)
          else
           upper[i]:=s[i];
         upper[0]:=s[0];
      end;

  function readlong : longint;

    var
       l : longint;
       w1, w2: word;

    begin
       blockread(f,l,4);
{$ifdef BIG_ENDIAN}
         w1:=l and $ffff;
         w2:=l shr 16;
         l:=swap(w2)+(longint(swap(w1)) shl 16);
{$endif}
       readlong:=l;
    end;

  function readword : word;

    var
       w : word;

    begin
       blockread(f,w,2);
{$IFDEF BIG_ENDIAN}
       w:=swap(w);
{$ENDIF}
       readword:=w;
    end;

  function readdouble : double;

    var
       d : double;

    begin
       blockread(f,d,8);
       readdouble:=d;
    end;

  function readbyte : byte;

    var
       b : byte;

    begin
       blockread(f,b,1);
       readbyte:=b;
    end;

  function readstring : string;

    var
       s : string;

    begin
       s[0]:=chr(readbyte);
       blockread(f,s[1],ord(s[0]));
       readstring:=s;
    end;

  var
     space : string;
     read_member : boolean;

  procedure readandwriteref;

    var
       w : word;

    begin
       w:=readword;
       if w=$ffff then
         begin
            w:=readword;
            if w=$ffff then
              writeln('nil')
            else writeln('Local Definition Nr. ',w)
         end
       else writeln('Unit ',w,'  Nr. ',readword)
    end;

  { reads the flags of a definition }
  procedure readflags;

    begin
       if version<13 then
         readword;
    end;

  var
     b : byte;
     unitnumber : word;

  type
     tsettyp = (normset);

  procedure readin;

    var
       oldread_member : boolean;
       counter : word;
       sourcename : string;


    procedure read_abstract_proc_def;

       var
          params : word;
          options : longint;

       begin
          write(space,'      Return type : ');
          readandwriteref;
          if Version<13 then
            options:=readword
          else
            options:=readlong;
          if options<>0 then
            begin
               write(space,'          Options : ');
               if (options and 1)<>0 then
               write('Exception handler ');
               if (options and 2)<>0 then
                 write('Virtual Method ');
               if (options and 4)<>0 then
                 write('Stack is not cleared, ');
               if (options and 8)<>0 then
                 write('Constructor ');
               if (options and $10)<>0 then
                 write('Destructor ');
               if (options and $20)<>0 then
                 write('Internal Procedure ');
               if (options and $40)<>0 then
                 write('Exported Procedure ');
               if (options and $80)<>0 then
                 write('I/O-Checking');
               if (options and $100)<>0 then
                 write('Abstract method');
               if (options and $200)<>0 then
                 write('Interrupt Handler');
               if (options and $400)<>0 then
                 write('Inline Procedure');
               if (options and $800)<>0 then
                 write('Assembler Procedure');
               if (options and $1000)<>0 then
                 write('Overloaded Operator');
               if (options and $2000)<>0 then
                 write('External Procedure');
               if (options and $4000)<>0 then
                 write('Expects parameters from left to right');
               if (options and $8000)<>0 then
                 write('Main Program');
               if (options and $10000)<>0 then
                 write('Static Method');
               if (options and $20000)<>0 then
                 write('Method with Override Direktive');
               if (options and $40000)<>0 then
                 write('Class Method');
               if (options and $80000)<>0 then
                 write('Unit Initialisation');
               if (options and $100000)<>0 then
                 write('Method Pointer (must be a procedure variable)');
               writeln
            end;
          params:=readword;
          writeln(space,'  Nr of parameters: ',params);
          if params>0 then
            writeln(space,'   Parameter defs : ');
          while params>0 do
            begin
               write(space,'    Type: ',readbyte,'  ');
               readandwriteref;
               dec(params);
            end;
       end;

     var
        params : word;
       IgnoreEnd : Longint;


    begin


       counter:=0;
       IgnoreEnd:=0;
       repeat
         b:=readbyte;

         if not (b in [ibend,ibloadunit,ibinitunit,iblinkofile,ibsourcefile,
                       iblibraries,ibunitname,ibstaticlibs]) then
           begin
              write(space,'Definition Nr. ',counter,' : ');
              inc(counter);
           end;
         case b of
            ibloadunit : begin
                            writeln('Uses unit (interface): ',readstring,' (',unitnumber,
                              ')  (Checksum: ',readlong,')');
                            inc(unitnumber);
                            { version 12 writes a ibend after this.}
                            if version>=12 then inc(ignoreend);
                         end;
            ibunitname : Writeln ('Unit name : ',readstring);
            ibsourcefile : begin
                           { Only version 12 and higher do this }
                           SourceName:=ReadString;
                           writeln ('Unit source file : ', SourceName);
                           { stupid situation :

                             }
                           if Upper(SourceNAme)='SYSTEM.INC' then
                             {Systemunit:=true;}
                             Inc(IgnoreEnd);
                           if IgnoreEnd<1 then Inc(IgnoreEnd);
                           end;
            iblibraries : Writeln ('Link with library : ', readstring);
            ibstaticlibs : Writeln ('Link static with library : ',readstring);
            ibpointerdef : begin
                              readflags;
                              write(space,'Pointerdefinition to : ');
                              readandwriteref;
                           end;

             iborddef : begin
                            readflags;
                            write(space,'Base type ');
                            case tbasetype(readbyte) of
                             uauto : writeln('uauto');
                             uvoid : writeln('uvoid');
                             uchar : writeln('uchar');
                             u8bit : writeln('u8bit');
                            u16bit : writeln('u16bit');
                            u32bit : writeln('s32bit');
                             s8bit : writeln('s8bit');
                            s16bit : writeln('s16bit');
                            s32bit : writeln('s32bit');
                          bool8bit : writeln('bool8bit');
                         bool16bit : writeln('bool16bit');
                         bool32bit : writeln('bool32bit');
                            end;
                            writeln(space,'  Range: ',readlong,' to ',readlong);
                         end;
            ibfloatdef : begin
                           readflags;
                           writeln (space,'Float definition');
                           writeln (space, '  Float type : ',readbyte);
                         end;

            ibarraydef : begin
                            readflags;
                            writeln(space,'Array definition');
                            write(space,'  Element type: ');
                            readandwriteref;
                            write(space,'  Range Type: ');
                            readandwriteref;
                            writeln(space,'  Range: ',readlong,' to ',readlong);
                         end;
            ibprocdef : begin
                           readflags;
                           writeln(space,'Procedure definition : ');
                           if version<8 then
                             begin
                                writeln(space,'  Used Register: ',readbyte);
                                write(space,  '   Return type : ');
                                readandwriteref;
                                write(space,'       Options : ',readword);
                                writeln(space,'  Mangled Name : ',readstring);
                                writeln(space,'        Number : ',readlong);
                                write(space,'            Next : ');
                                readandwriteref;
                                params:=readword;
                                writeln(space,'  Nr. of Parameters: ',params);
                                writeln(space,'  Parameter definitions: ');
                                while params>0 do
                                  begin
                                     write(space,'    Type: ',readbyte,'  ');
                                     readandwriteref;
                                     dec(params);
                                  end;
                             end
                           else
                             begin
                                read_abstract_proc_def;
                                { m68k targets use a word to save registers }
                                if utarget in [target_AMIGA..target_MAC68k] then
                                   writeln(space,'    Used Register : ',readword)
                                else
                                   writeln(space,'    Used Register : ',readbyte);
                                writeln(space,'     Mangled name : ',readstring);
                                writeln(space,'           Number : ',readlong);
                                write  (space,'             Next : ');
                                readandwriteref;
                                if version>11 then readlong;
                             end;
                        end;
            ibprocvardef : begin
                              readflags;
                              writeln(space,'Procedural type :');
                              read_abstract_proc_def;
                           end;
            ibstringdef:
              begin
                 readflags;
                 writeln(space,'String definition with length: ',readbyte);
              end;
            ibwidestringdef:
              begin
              readflags;
              writeln (space,'WideString definition with length: ',readlong);
              end;
            ibansistringdef:
              begin
              readflags;
              writeln (space,'AnsiString definition with length: ',readlong);
              end;
            iblongstringdef:
              begin
              readflags;
              writeln (space,'Longstring definition with length: ',readlong);
              end;
            ibrecorddef : begin
                             readflags;
                             writeln(space,'Record definition with size ',readlong);
                             oldread_member:=read_member;
                             read_member:=true;
                             space:=space+'    ';
                             readin;
                             dec(byte(space[0]),4);
                             read_member:=oldread_member;
                          end;
            ibobjectdef : begin
                            readflags;
                            writeln(space,'Class definition with size ',readlong);
                            writeln(space,'  Name of Class  : ',readstring);
                            write(space,  '  Ancestor Class : ');
                            readandwriteref;
                            if version>12 then
                             writeln (space,  '         Options : ',readlong)
                            else

                             writeln (space,  '         Options : ',readword);
                            oldread_member:=read_member;
                            read_member:=true;
                            space:=space+'    ';
                            readin;
                            dec(byte(space[0]),4);
                            read_member:=oldread_member;
                         end;
            ibfiledef : begin
                           readflags;
                           case readbyte of
                              0 : writeln(space,'Text file definition');
                              1 : begin
                                     write(space,'Typed file definition of Type : ');
                                     readandwriteref;
                                  end;
                              2 : writeln(space,'Untyped file definition');
                           end;
                        end;
            ibformaldef:
              begin
                 readflags;
                 writeln(space,'Generic Definition (void-typ)');
              end;
            ibenumdef:
              begin
                 readflags;
                 writeln(space,'Enumeration type definition');
                 writeln(space,'Largest element: ',readlong);
              end;
            ibclassrefdef:
              begin
                 readflags;
                 write(space,'Class reference definition to: ');
                 readandwriteref;
              end;
            ibinitunit : writeln('Needs Initialising: ',readstring);
            iblinkofile : writeln('Link with: ',readstring);
            ibsetdef : begin
                          readflags;
                          writeln(space,'Set definition');
                          write(space,'  Element type: ');
                          readandwriteref;
                          b:=readbyte;
                          case tsettyp(b) of
                             normset : writeln(space,'  Set with 256 Elements');
                             else
                               begin
                                  writeln('Invalid unit format : Invalid set type.');
                                  exit;
                               end;
                          end;
                       end;
            ibref : begin
                    writeln ('Error : Don''t know how to handle IBREF yet.');
                    exit;
                    end;
            ibextsymref : begin
                          writeln ('Error : Don''t know how to handle IBEXTSYMREF yet.');
                          exit;
                          end;
            ibextdefref : begin
                          writeln ('Error : Don''t know how to handle IBEXTDEFREF yet.');
                          exit;
                          end;
            ibend : begin
                    if (version<12) or (ignoreend<=0) then
                       break
                     else
                       dec(ignoreend);
                    end;
            else
              begin
                 writeln('Invalid unit format : Invalid definition type encountered : ',b);
                 exit;
              end;
         end;
       until false;
       repeat
         b:=readbyte;
         case b of
            ibtypesym : begin
                           writeln(space,'Type symbol ',readstring);
                           write(space,'  Definition: ');
                           readandwriteref;
                        end;
            ibprocsym : begin
                           writeln(space,'Procedure symbol ',readstring);
                           write(space,'  Definition: ');
                           readandwriteref;
                        end;
            ibconstsym : begin
                            if version<10 then
                              begin
                                 writeln(space,'Constant symbol ',readstring);
                                 write(space,'  Value: ');
                                 case readbyte of
                                    0 : writeln(readlong);
                                    1 : writeln('"'+readstring+'"');
                                    2 : writeln(''''+chr(readbyte)+'''');
                                    3 : writeln(readdouble);
                                    4 : if readbyte=0 then writeln('FALSE')
                                      else writeln('TRUE');
                                 end;
                              end
                            else if version<12 then
                              begin
                                 writeln(space,'Constant symbol ',readstring);
                                 write(space,'  Definition: ');
                                 b:=readbyte;
                                 readandwriteref;
                                 write(space,'  Value: ');
                                 case b of
                                    0 : writeln(readlong);
                                    1 : writeln('"'+readstring+'"');
                                    2 : writeln(readdouble);
                                 end;
                              end
                            else

                              begin
                                 writeln(space,'Constant symbol ',readstring);
                                 b:=readbyte;
                                 if b<>0 then
                                   write(space,'  Value: ');
                                 case b of
                                    0 : begin
                                        write (space,'  Definition : ');
                                        readandwriteref;
                                        writeln (space,'  Value : ',readlong)
                                        end;
                                    3 : if readlong<>0 then

                                          writeln ('True')

                                        else

                                          writeln ('False');
                                    4,5 : writeln(readlong);

                                    1 : writeln('"'+readstring+'"');
                                    2 : writeln(readdouble);
                                 end;
                              end;
                         end;
            ibvarsym : begin
                           write(space,'Variable symbol ',readstring);
                           write(' (Type: ',readbyte);
                           if read_member then
                             write(', Address: ',readlong);
                           writeln (')');
                           write(space,'  Definition: ');
                           readandwriteref;
                        end;
            ibaufzaehlsym : begin
                               writeln(space,'Enumeration symbol ',readstring);
                               write(space,'  Definition: ');
                               readandwriteref;
                               writeln(space,'  Value: ',readlong);
                            end;
            ibtypedconstsym : begin
                                 writeln(space,'Typed constant ',readstring);
                                 write(space,'  Definition');
                                 readandwriteref;
                                 writeln(space,'  Label: ',readstring);
                              end;
            ibabsolutesym : begin
                              write(space,'Absolute variable symbol ',readstring);
                              write(' (Type: ',readbyte);
                              if read_member then
                                write(', Address: ',readlong);
                              writeln (')');
                              write(space,'  Definition: ');
                              readandwriteref;
                              abstyp:=absolutetyp(readbyte);
                              Write (space,'  Relocated to ');
                              case abstyp of
                                tovar  : Writeln ('Name : ',readstring);
                                toasm  : Writeln ('Assembler name : ',readstring);
                                toaddr : Writeln ('Address : ',readlong);
                              else
                                Writeln ('Invalid unit format : Invalid absolute type encountered :',byte(abstyp));
                              end;

                            end;
            ibend : break;
            else
               begin
                  writeln('Invalid Unit format : Invalid symbol type encountered :', b);
                  exit;
               end;
         end;
       until false;
       if (version>11) and not read_member then
         begin
         { Check use of dbx }
         if (flags and uf_uses_dbx)<>0 then
           begin

           Writeln ('DBXcount : ',readbyte,',',readlong);
           if readbyte<>ibend then Writeln ('Illegal unit file.')
           end;
         { Read implementation units. }
         repeat
           b:=readbyte;
           case b of

            ibend : ;
       ibloadunit : begin
                      Write ('Uses unit (implementation) : ',readstring);
                      Writeln (' Checksum : ',readlong);
                    end;
           else

            begin
              writeln ('Invalid unit file : No used units part.');
              exit;
            end;
           end;

         until b=ibend;

         end;
    end;

  var
     hs : string;
     w : word;


procedure dofile (const s : string);

begin
  filename:=s;
  assign(f,filename);
  {$i-}
   reset(f,1);
  {$i+}
  if IOResult<>0 then
    begin
    writeln ('IO-Error when opening :',filename,', Skipping.');
    exit
    end
  else
    Writeln ('Reading file : ',filename);
  if (readbyte<>ord('P')) or
     (readbyte<>ord('P')) or
     (readbyte<>ord('U')) then
     begin
        writeln(Filename,' : Not a valid PPU file. Skipping');
     end
   else
     begin
     hs:=chr(readbyte)+chr(readbyte)+chr(readbyte);
     val(hs,version,w);
     writeln('PPU version             : ',version);
     writeln('Compiler version        : ',readbyte,'.',readbyte);
     write  ('Target operating system : ');
     utarget:=ttarget(readbyte);
     case utarget of
        target_GO32V1 : writeln('DOS');
        target_OS2   : writeln('OS/2');
        target_LINUX : writeln('Linux');
        target_WIN32 : writeln('Win32');
        target_AMIGA : writeln('Amiga');
        target_ATARI : writeln('Atari');
        target_Mac68k: writeln('Mac-68k');
     end;


     flags:=readbyte;
     write ('Unit flags              : ',flags,', ');
     if (flags and uf_init)<>0 then
      write('init ');
     if (flags and uf_uses_dbx)<>0 then
      write('uses_dbx ');
     if (flags and uf_uses_browser)<>0 then
      write('uses_browser ');
     if (flags and uf_in_library)<>0 then
      write('in_library ');
     if (flags and uf_shared_library)<>0 then
      write('shared_library ');
     if (flags and uf_big_endian)<>0 then
      write('big_endian');
     if (flags=0) then
      write('(none)');

     writeln;


     writeln ('Checksum                : ',readlong);
     readword;
     if version>=9 then
     writeln ('Object code start       : ',readlong);
     unitnumber:=1;
     space:='';
     read_member:=false;
     readin;
     end;
   close(f);
   writeln;
end;


  begin
     writeln('PPU-analyser Version 0.99');
     writeln('Copyright (c) 1995-98 by Florian Klaempfl and Michael Van Canneyt');
     writeln;
     filemode:=0;
     if paramcount<1 then
       begin
          writeln('dumpppu <filename1> <filename2>...');
          halt(1);
       end;
     for nrfile :=1 to paramcount do
       dofile (paramstr(nrfile));
  end.
{

  $Log: dumpppu.pp,v $
  Revision 1.7  1998/08/12 12:17:07  carl
    * Make it work with FPC 0.99.5
    + m68k targets support
    + BIG_ENDIAN machine support

  Revision 1.5  1998/06/12 14:46:07  peter
    * update tbasetype

  Revision 1.4  1998/05/07 08:48:12  michael
  + Some cosmetic changes for smart linking.

  Revision 1.3  1998/05/06 11:05:32  michael
  + Updated to ppu version 14. Added strings and unitname handlers

  Revision 1.2  1998/04/29 22:41:17  florian
    * better decoding of procedure options
    + support of PPU format 14
}
