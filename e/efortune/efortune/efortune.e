/*
   E-Fortune 0.6, Copyright © 2003 Kalle Raisanen.

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
*/

OPT PREPROCESS
MODULE '*random'

#define TITLE 'E-Fortune 0.6.6, Copyright © 2003 Kalle Raisanen'
#define debug 0
DEF text=0

PROC countForts(fp)
   DEF proc, buff[512]:ARRAY
   proc := 0
   
   WHILE Fgets(fp, buff, 512)
      IF StrCmp(buff, '%', 1) THEN proc++
   ENDWHILE
   Seek(fp, 0, -1)
   RETURN proc
ENDPROC

PROC getFort(fp)
   DEF fort, buff[512]:ARRAY, curr=0, out=NIL, s, proc=0

   proc := countForts(fp)

   IF proc = 0 THEN RETURN 0
   fort := getRandRange(proc) + 1
   IF debug THEN WriteF('\d\n', fort)

   WHILE Fgets(fp, buff, 512) AND (curr <= fort)
      IF StrCmp(buff, '%', 1)
         curr++
      ELSEIF curr = fort
         IF out
            s := String(StrLen(out))
            StrCopy(s, out)
            out := String(StrLen(s) + StrLen(buff))
            StrCopy(out, s)
            StrAdd(out, buff)
         ELSE
            out := String(StrLen(buff))
            StrCopy(out, buff)
         ENDIF
      ENDIF
   ENDWHILE

   show_mess(out)

   RETURN 1
ENDPROC

PROC show_mess(mess)
   IF text
      WriteF('\s:\n\n\s\n', TITLE, mess)
   ELSE
      EasyRequestArgs(0,[20,0,TITLE,mess,'OK'],0,NIL)
   ENDIF
ENDPROC

ENUM HELPARGS, HELPCOPY, BADINI, BADFORT, BADARGS, NOFORT

PROC main() HANDLE
   DEF fp=NIL, myargs:PTR TO LONG, rdargs, s, buff[512]:ARRAY,
       last=NIL, first=NIL, files=0, filen=0, file, sl
   myargs := [0,0,0,0]

   seedRand()

   IF rdargs := ReadArgs('FILE,--text=-t/S,--help=-h/S,--copy=-c/S', myargs, NIL)
      text := myargs[1]
      IF myargs[2]
         Raise(HELPARGS)
      ELSEIF myargs[3]
         Raise(HELPCOPY)
      ELSEIF myargs[0] 
         IF (fp := Open(myargs[0], OLDFILE)) = NIL THEN Raise(BADINI)
         WHILE Fgets(fp, buff, 512)
            IF StrLen(buff) > 3
               IF (s := String(StrLen(buff))) = NIL THEN Raise("MEM")
               StrCopy(s, buff)
               IF last THEN Link(last, s) ELSE first := s
               last := s
               files++
            ENDIF
         ENDWHILE
         s := first
         Close(fp)
         filen := getRandRange(files)
         IF debug THEN WriteF('\d\n', filen)
         s := Forward(s, filen)
         sl := StrLen(s)
         IF InStr(s, '\n', 0) THEN sl--
         file := String(sl)
         StrCopy(file, s, sl)
         DisposeLink(first)
      ELSE
         file := String(StrLen('s:fortunes.txt'))
         StrCopy(file, 's:fortunes.txt', ALL)
      ENDIF
      IF debug THEN WriteF('\s\n', file)
      IF (fp := Open(file, OLDFILE)) = NIL THEN Raise(BADFORT)
      IF getFort(fp) = 0 THEN Raise(NOFORT)
      Close(fp)
      FreeArgs(rdargs)
   ELSE
      Raise(BADARGS)
   ENDIF
EXCEPT
   SELECT exception
      CASE BADINI
         show_mess('efortune: Unable to open resource file!\n')
      CASE BADFORT
         show_mess('efortune: Unable to open fortune file!\n')
      CASE NOFORT
         show_mess('efortune: No fortunes in fortune file!\n')
      CASE HELPARGS
         show_mess('efortune [inifile] [--text] [--help]\n\n'+
                '   inifile    A file listing the fortune files to use, one on each line.\n'+
                '              E-Fortune uses "S:fortunes.txt" as fortune file by default.\n'+
                '   --text     Output to stdout, rather than putting up a requester.\n'+
                '   --help     Display this text, and exit.\n'+
                '   --copy     Display copyright info, and exit.\n\n'+
                'Report any bugs to <xork@amiga.org>\n')
      CASE HELPCOPY
         show_mess('This program is free software; you can redistribute it and/or modify\n'+
                   'it under the terms of the GNU General Public License as published by\n'+
                   'the Free Software Foundation; either version 2 of the License, or\n'+
                   '(at your option) any later version.\n\n'+
                   'This program is distributed in the hope that it will be useful,\n'+
                   'but WITHOUT ANY WARRANTY; without even the implied warranty of\n'+
                   'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n'+
                   'GNU General Public License for more details.\n\n'+
                   'You should have received a copy of the GNU General Public License\n'+
                   'along with this program; if not, write to the Free Software\n'+
                   'Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.\n\n')
      CASE BADARGS
         show_mess('efortune: Invalid arguments.\nTry "efortune --help" for help.\n')
   ENDSELECT
   IF fp THEN Close(fp)
ENDPROC


