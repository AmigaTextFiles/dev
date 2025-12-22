
/* Example of using AWNPipe to create a reaction gui in E, by Dave Norris */

-> MODULE  none needed

DEF pipefile,instring[10]:LIST,
    menulist,edmenugad,newgad,deletegad,insertgad,close,strtotal,
    menugad,subgad,bargad,akeygad,notegad,
    hotkeygad,comlist,edcomgad,stackgad,addgad,deletegad2,insertgad2,wbcligad,
    savegad,filereqgad,cancelgad,menu1,menu2,
    in0[100]:STRING,in1[100]:STRING,in2[100]:STRING,in3[100]:STRING,in4[100]:STRING,
    in5[100]:STRING,in6[100]:STRING,in7[100]:STRING,in8[100]:STRING,in9[100]:STRING,
    str_spaces[10]:ARRAY OF INT

PROC main()
  close:=FALSE
  setdefaults()
  buildgui()
  WHILE close=FALSE
    getline()
    IF StrCmp('app',in0)
      PrintF('You dropped this icon on me!\n \s\n\n',in1)
    ELSEIF StrCmp('gadget',in0)
      dogad()
    ELSEIF StrCmp('menu',in0)
      PrintF('You picked a menu item!\n\n')
    ELSEIF StrCmp('close',in0)
      close:=TRUE
    ENDIF
  ENDWHILE
  Close(pipefile)
  PrintF('file closed,\nsee you later.\n')
ENDPROC

PROC dogad()
  DEF x
  x:=Val(in1)
  SELECT x
    CASE menulist;      PrintF('just clicked on menulist!\n\n')
    CASE edmenugad;     printstring()        -> check string gads for spaces
    CASE newgad;        PrintF('just pressed new!\n\n')
    CASE deletegad;     PrintF('just pressed delete!\n\n')
    CASE insertgad;     PrintF('just pressed insert!\n\n')
    CASE menugad;       PrintF('just checked menu!\n\n')
    CASE subgad;        PrintF('just checked sub!\n\n')
    CASE bargad;        PrintF('just pressed bar!\n\n')
    CASE akeygad;       printstring()
    CASE notegad;       printstring()
    CASE hotkeygad;     printstring()
    CASE comlist;       PrintF('just clicked on command list!\n\n')
    CASE edcomgad;      printstring()
    CASE stackgad;      printstring()
    CASE addgad;        PrintF('just pressed add!\n\n')
    CASE deletegad2;    PrintF('just pressed delete button 2!\n\n')
    CASE insertgad2;    PrintF('just pressed insert button 2!\n\n')
    CASE wbcligad;      PrintF('just pressed chooser gadget!\n\n')
    CASE savegad;       PrintF('just pressed save!\n\n')
    CASE filereqgad;    PrintF('file selected=\s\n\n',in3)
    CASE cancelgad;     PrintF('just pressed cancel!\n\n')
    DEFAULT;            PrintF('You have not put me in yet!!!\n\n')
  ENDSELECT
ENDPROC

PROC printstring()
  joinstr(); PrintF('just pressed return \q\s\q!\n\n',in2)
ENDPROC

PROC joinstr()  -> glues string back together with spaces
  DEF x,y
  FOR x:=3 TO strtotal
    FOR y:=0 TO str_spaces[x] DO StrAdd(in2,' ')
    StrAdd(in2,instring[x])
  ENDFOR
ENDPROC

PROC buildgui()
  pipefile:=Open('awnpipe:test1/xc',OLDFILE)  ->wcon:300//200/200/PipeEvents
  topipe(pipefile,' " Workbench Menu Prefs 1.0 " cg dg db si so a cs app\n')

  topipe(pipefile,' layout v\n')
    topipe(pipefile,' layout b 0 si\n')  ->so
      topipe(pipefile,' layout b 0 so si v\n')
        topipe(pipefile,' layout gt "Menu Items" b 3 so si v\n') -> 3 4 5 7 8 9
          menulist:=topipe(pipefile,'listbrowser minw 180  minh 110\n')
          edmenugad:=topipe(pipefile,'string lj\n')
          topipe(pipefile,' layout b 0 si even\n')
            newgad:=topipe(pipefile,'button gt _New\n')
            deletegad:=topipe(pipefile,'button gt Delete\n')
            insertgad:=topipe(pipefile,'button gt Insert\n')
          topipe(pipefile,' le\n')
        topipe(pipefile,' le\n')
      topipe(pipefile,' le\n')
      topipe(pipefile,' layout b 0 so si v\n')
        topipe(pipefile,'space\n')
        menugad:=topipe(pipefile,'checkbox gt _Menu\n')
        subgad:=topipe(pipefile,'checkbox gt _Sub\n')
        bargad:=topipe(pipefile,'button gt Bar\n')
        topipe(pipefile,'space\n')
        topipe(pipefile,' layout gt AmiKey b 0 so si v\n')
          akeygad:=topipe(pipefile,'string minc=0 maxc=2 lj\n')
        topipe(pipefile,' le\n')
        topipe(pipefile,' layout gt Comment b 0 so si v\n')
          notegad:=topipe(pipefile,'string minc=0 maxc=15 lj\n')
        topipe(pipefile,' le\n')
        topipe(pipefile,'space\n')
        topipe(pipefile,'space\n')
      topipe(pipefile,' le\n')
      topipe(pipefile,' layout b 0 so si v\n')
        topipe(pipefile,' layout gt "Hot Key" b 3 so si v\n')
          hotkeygad:=topipe(pipefile,'string lj\n')
        topipe(pipefile,' le\n')
        topipe(pipefile,' layout gt Commands b=3 so si v\n')
          comlist:=topipe(pipefile,'listbrowser minw 180  minh=70\n')
          topipe(pipefile,' layout b 0 si\n')
            edcomgad:=topipe(pipefile,'string lj\n')
            stackgad:=topipe(pipefile,'integer maxc=6 defn 4096\n')
          topipe(pipefile,' le\n')
          topipe(pipefile,' layout b 0 si even\n')
            addgad:=topipe(pipefile,'button gt _Add\n')
            deletegad2:=topipe(pipefile,'button gt Delete\n')
            insertgad2:=topipe(pipefile,'button gt Insert\n')
            wbcligad:=topipe(pipefile,'chooser pu cl " WB|CLI"\n')
          topipe(pipefile,' le\n')
        topipe(pipefile,' le\n')
      topipe(pipefile,' le\n')
    topipe(pipefile,' le\n')
    topipe(pipefile,' layout b 0 si so\n')
      savegad:=topipe(pipefile,'button gt Save\n')
      topipe(pipefile,'space\n')
      topipe(pipefile,'space\n')
      topipe(pipefile,'space\n')
      topipe(pipefile,'space\n')
      cancelgad:=topipe(pipefile,'button gt Cancel c\n')
    topipe(pipefile,' le\n')
  topipe(pipefile,' le\n')

  menu1:=topipe(pipefile,' menu gt "Project |About|$! E with AWNpipe |$! By Dave Norris"\n')
  menu2:=topipe(pipefile,' menu gt "Data|@AShow all data|Show part|$@GGood|$@LLuck"\n')
  topipe(pipefile,'open\n')
ENDPROC

PROC topipe(pipef,data)
  DEF res,input[10]:STRING
  Fputs(pipef,data)
  IF ReadStr(pipef,input)<>-1     -> returns -1 if error or EOF encounted
    IF StrCmp(input,'ok',2)
      IF StrLen(input)>2 THEN res:=RightStr(input,input,(StrLen(input)-3))
    ELSE  -> ^ only return res if gadget or menu, not needed for layout ^
      PrintF('Error from \s\n',data)
    ENDIF
  ELSE
    PrintF('Error from ReadStr(pipef,input)\n')
    close:=TRUE
  ENDIF
ENDPROC Val(res)

PROC setdefaults()    -> put here to unclutter main()
  instring:=[in0,in1,in2,in3,in4,in5,in6,in7,in8,in9]:LONG
ENDPROC

PROC getline()     -> loops until all data seperated by spaces is collected
  DEF space,input[1024]:STRING,x,gap
  x:=0
  IF ReadStr(pipefile,input)<>-1     -> returns -1 if error or EOF encounted
->    PrintF('input=\s,\n',input)
    WHILE (space:=InStr(input,' '))<>-1
      StrCopy(instring[x],input,space)
->      PrintF('instring[\d]=\s,\n',x,instring[x])
      MidStr(input,input,space+1)
      gap:=StrLen(input)
      input:=TrimStr(input)
      x:=x+1
      str_spaces[x]:=gap-StrLen(input)
    ENDWHILE
    strtotal:=x
    StrCopy(instring[x],input)
->    PrintF('instring[\d]=\s,\n',x,instring[x])
  ENDIF
ENDPROC

