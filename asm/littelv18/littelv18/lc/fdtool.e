-> AUTHOR : Leif_Salomonsson@swipnet.se
-> STATUS : FREEWARE

-> this little proggy takes a fd file with
-> all the functions listed and turns it into
-> autodoc format.
-> added possibility to create LITTEL macro functions.
-> 000512 : removed afc/parser!
->000618 : started work on E library source genaration
->stopped work on E library source generation, there is already tools for that.
->000712 : adding blabla.library/--background-- in AD.
-> some bugs fixed.
-> adding experimental eeh libraryfunc file support...
-> 010123 : optimising EXT mode
-> now writing macros to ext-file.
-> removed macros to ext file.
-> now outputs comments to extfile.

-> bug : does not decrement offset for private funcs!
-> this is fixed in e:develop/fdtool (v1.1)

MODULE '*extractwords'
->MODULE 'afc/parser'

MODULE 'dos/dos'


   ->DEF p=NIL:PTR TO parser
   DEF ew=NIL:PTR TO extractwords
   DEF fh2=NIL

PROC main() HANDLE
   DEF fh=NIL
   DEF flen=NIL
   DEF buf[25000]:ARRAY OF CHAR
   DEF end
   DEF infile[100]:STRING
   DEF outfile[100]:STRING
   DEF mode[100]:STRING
   DEF name[100]:STRING

   ->NEW p.parser()
   ->IF p.parse('INFILE/A,NAME/A,OUTFILE/A,TARGET/A', arg)=NIL THEN Raise("ARG")
   NEW ew.new(4, 500)
   ew.setMode(EW_MODE2)
   ew.extract(arg)
   StrCopy(infile, ew.getWord(0))
   StrCopy(outfile, ew.getWord(1))
   StrCopy(mode, ew.getWord(2))
   StrCopy(name, ew.getWord(3))
   flen := FileLength(infile)
   IF flen < 1 THEN Raise("INFI")
   fh := Open(infile, MODE_OLDFILE)
   Read(fh, buf, flen)
   fh2 := Open(outfile, MODE_NEWFILE)
   end := buf + flen
   IF StrCmp(mode, 'AD') = TRUE
     bla1(buf, end, fh2, name)
     bla2(buf, end, fh2, name)
   ELSEIF StrCmp(mode, 'MF')=TRUE
     makeMacroFunctions(buf, end, fh2)
   ELSEIF StrCmp(mode, 'EXT')=TRUE   -> was : EEH
     makeextfile(buf, end, fh2)
   ELSEIF StrCmp(mode, 'E')=TRUE
     makeelibsrcheader(buf, outfile, end, fh2)->WriteF('TARGET not implemented yet!\n')
     makeelibsrcfuncs(buf, outfile, end, fh2)
   ELSE
     WriteF('TARGET unknown!\n')
   ENDIF
EXCEPT DO
   SELECT exception
   CASE "INFI" ; WriteF('Cant open INFILE!\n')
   CASE "ARG" ; WriteF('Please give me some/right arguments!')
   ENDSELECT
   IF fh THEN Close(fh)
   IF fh2 THEN Close(fh2)
ENDPROC
 
PROC bla1(buf, end, fh2, name)
   DEF str[100]:STRING
   DEF tstr[100]:STRING
   DEF private=FALSE
   write('TABLE OF CONTENTS\n\n')
   write(name)
   write('/--background--\n')
   WHILE buf < end
      ew.extract(buf)
      IF StrCmp(buf, '##', 2) = FALSE
      IF private = FALSE
      IF StrCmp(buf, '*', 1) = FALSE
        StrCopy(tstr, ew.getWord(0), InStr(ew.getWord(0), '('))
        StringF(str, '\s/\s\n', name, tstr)
        write(str)
      ENDIF
      ENDIF
      ELSE
         IF StrCmp(buf, '##private', 9) = TRUE THEN private := TRUE
         IF StrCmp(buf, '##public', 8) = TRUE THEN private := FALSE
      ENDIF
      buf := nextLine(buf)
   ENDWHILE
   write('\n\n')
ENDPROC

PROC bla2(buf, end, fh2, name)
   DEF str[100]:STRING
   DEF tstr[100]:STRING
   DEF private=FALSE
   StringF(str, '\c\s/--background--\n\n', 12, name)
         write(str)

   WHILE buf < end
      ew.extract(buf)
      IF StrCmp(buf, '##', 2) = FALSE
      IF private = FALSE
      IF StrCmp(buf, '*', 1) = FALSE
         StrCopy(tstr, ew.getWord(0), InStr(ew.getWord(0), '('))
         StringF(str, '\c\s/\s\n\n', 12, name, tstr)
         write(str)
         StringF(str, '        NAME\n           \s --\n', tstr)
         write(str)
         StringF(str, '        SYNOPSIS\n           \s\n', ew.getWord(0))
         write(str)
         write('        FUNCTION\n')
         write('        INPUTS\n')
         write('        RESULTS\n')
         write('        EXAMPLE\n')
         write('        NOTES\n')
         write('        BUGS\n')
         write('        SEE ALSO\n')
         write('\n')
      ENDIF
      ENDIF
      ELSE
         IF StrCmp(buf, '##private', 9) = TRUE THEN private := TRUE
         IF StrCmp(buf, '##public', 8) = TRUE THEN private := FALSE
      ENDIF
      buf := nextLine(buf)
   ENDWHILE
ENDPROC

/* 000813 */

PROC countchars(b, char)
   DEF count=NIL
   WHILE b[] <> NIL
      IF b[] = char THEN count++
      b++
   ENDWHILE
ENDPROC count

OBJECT block
   name[48]:ARRAY OF CHAR
   nrofparams:INT
   src[250]:ARRAY OF CHAR
ENDOBJECT

PROC makeextfile(buf, end, fh2)
   DEF str[200]:STRING
   DEF nstr[100]:STRING
   DEF rstr[100]:STRING
   DEF pstr[200]:STRING  -> 010228
   DEF private=FALSE
   DEF basestr[80]:STRING
   DEF nrofparams=NIL
   DEF bias=-30, r
   DEF tstr, len
   DEF typestr[100]:STRING
   DEF a

   write(';.ext file Created by fdtool in LITTEL package v18\n')
  -> ew.extract(buf)
   ->StrCopy(basestr, 'unknownbase')

   WriteF('base will be : ')
   ReadStr(stdin, basestr)

   WHILE buf < end
      ew.extract(buf)
      IF StrCmp(buf, '##bias', 6)
         bias := -Val(buf+6)
      ->ELSEIF StrCmp(buf, '##base', 6)
      ->   StrCopy(basestr, ew.getWord(1)+1, StrLen(ew.getWord(1)))
      ->   LowerStr(basestr)
      ELSEIF StrCmp(buf, '##private', 9)
         private := TRUE
      ELSEIF StrCmp(buf, '##public', 8)
         private := FALSE
      ELSEIF StrCmp(buf, '*', 1)
         -> comment
         write('->')
         FOR a := 0 TO ew.getNrOfWords()-1
            write(ew.getWord(a))
            write(' ')
         ENDFOR
      ELSEIF StrCmp(buf, '##', 2)
         -> skip it
      ELSEIF private = FALSE

         tstr := ew.getWord(0)

         len := InStr(tstr, '(')
         IF len > 0 THEN StrCopy(nstr, tstr, len) ELSE SetStr(nstr, 0)
         tstr := tstr + len + 1

         len := InStr(tstr, ')(')
         IF len > 0 THEN StrCopy(pstr, tstr, len) ELSE SetStr(pstr, 0)
         tstr := tstr + len + 2

         len := InStr(tstr, ')')
         IF len > 0 THEN StrCopy(rstr, tstr, len) ELSE SetStr(rstr, 0)

         ->SetStr(rstr, EstrLen(rstr)-1)

         nrofparams := countchars(rstr, "d") + countchars(rstr, "a")

         WriteF('parametertypes for \s(\s) : ', nstr, pstr)
         ReadStr(stdin, typestr)

         StringF(str, 'EXT \s \d (\s); \s\n', nstr, nrofparams, typestr, pstr)
         write(str)

         StringF(str, '   move.l GLOBAL_\s(a4), a6\n', basestr)
         write(str)

         IF InStr(rstr, '2') <> -1 -> nrofparams > 2
            write('   movem.l d2-d7/a2-a5, -(a7)\n')
            write('   add.l #40, a7\n')
         ENDIF

         IF nrofparams > 0
            r := rstr
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
            r := bla(r)
         ENDIF

         IF InStr(rstr, '2') <> -1 -> nrofparams > 2
            StringF(str, '   sub.l #\d, a7\n', 40+(nrofparams*4))
            write(str)
         ENDIF

         StringF(str, '   jsr \d(a6)\n', bias)
         write(str)

         IF InStr(rstr, '2') <> -1 -> nrofparams > 2
            write('   movem.l (a7)+, d2-d7/a2-a5\n')
         ENDIF

         write('ENDEXT\n')

         bias := bias - 6
      ENDIF
      buf := nextLine(buf)
   ENDWHILE
   write('EOF')
ENDPROC


PROC makeMacroFunctions(buf, end, fh2)
   DEF str[200]:STRING
   DEF nstr[100]:STRING
   DEF rstr[200]:STRING
   DEF private=FALSE
   DEF basestr[50]:STRING
   DEF r
   DEF bias
   write(';MacroFunctions Created by fdtool in LITTEL package v18\n')
  -> ew.extract(buf)
   StrCopy(basestr, 'unknownBase')

   WHILE buf < end
      ew.extract(buf)
      IF StrCmp(buf, '##bias', 6) = TRUE THEN bias := -Val(buf+6)
      IF StrCmp(buf, '##base', 6) = TRUE THEN StrCopy(basestr, ew.getWord(1))
    IF StrCmp(buf, '##', 2) = FALSE
     IF StrCmp(buf, '*', 1) = FALSE
      IF private = FALSE
      StrCopy(nstr, ew.getWord(0), InStr(ew.getWord(0), '('))
      StrCopy(rstr, ew.getWord(0) + InStr(ew.getWord(0), ')(') + 2)
      SetStr(rstr, EstrLen(rstr)-1)
      StringF(str, '   macro x\s\n', nstr)
      write(str)

      r := rstr
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)
      r := bla(r)

      StringF(str, '      move.l \s(a4), a6\n', basestr)
      write(str)
      StringF(str, '      jsr \d(a6)\n', bias, nstr)
      write(str)

      write('   endm\n')
      ENDIF
      bias := bias - 6
     ENDIF
    ELSE
       IF StrCmp(buf, '##private', 9) = TRUE THEN private := TRUE
       IF StrCmp(buf, '##public', 8) = TRUE THEN private := FALSE
    ENDIF
      buf := nextLine(buf)
   ENDWHILE
ENDPROC

PROC bla(rstr)
   DEF str[100]:STRING
   IF StrLen(rstr) > 1
      StringF(str, '   move.l (a7)+, \s[2]\n', rstr)
      write(str)
      rstr := IF StrLen(rstr) = 2 THEN rstr + 2 ELSE rstr + 3
   ENDIF
ENDPROC rstr

PROC makeelibsrcheader(buf, outfile, end, fh2)
   DEF str[100]:STRING
   DEF nstr[100]:STRING
   DEF rstr[100]:STRING
   StringF(str, 'LIBRARY '', ver, rev, '' IS\n')
   write(str)
   WHILE buf < end
      ew.extract(buf)
      IF StrCmp(ew.getWord(0), '##', 2) <> TRUE
         StrCopy(nstr, ew.getWord(0), InStr(ew.getWord(0), '('))
         StrCopy(rstr, ew.getWord(0) + InStr(ew.getWord(0), ')(') + 2)
         SetStr(rstr, EstrLen(rstr)-1)
         StringF(str, '\s(\s),\n', nstr, rstr)
         write(str)
      ENDIF
      buf := nextLine(buf)
   ENDWHILE
ENDPROC

PROC makeelibsrcfuncs(buf, outfile, end, fh2)
   DEF str[100]:STRING
   DEF nstr[100]:STRING
   DEF rstr[100]:STRING
   WHILE buf < end
      ew.extract(buf)
      IF StrCmp(ew.getWord(0), '##', 2) <> TRUE
         StrCopy(nstr, ew.getWord(0), InStr(ew.getWord(0), '('))
         StringF(str, 'PROC \s()\nENDPROC\n', nstr)
         write(str)
      ENDIF
      buf := nextLine(buf)
   ENDWHILE
ENDPROC

PROC write(str) IS Write(fh2, str, StrLen(str))

/* borrowing function frpm lc17.e */
PROC nextLine(str:PTR TO CHAR)
   WHILE str[] <> 10 DO str++
   ->linenum++
   str++
   WHILE str[] = 10
      str++
      ->linenum++
   ENDWHILE
ENDPROC str

CHAR '$VER: fdtool 0.9 (010229) LITTEL/YAEC tool by Leif 2000-2001', 0
