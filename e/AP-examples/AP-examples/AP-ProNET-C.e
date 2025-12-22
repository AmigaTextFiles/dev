
/* Example of using AWNPipe to create a reaction gui in E, by Dave Norris */

->MODULE none needed

DEF pipefile,small,instring[10]:LIST,mainpage,clientpage,close,startinfo,pipereaderror,
    in0[100]:STRING,in1[100]:STRING,in2[100]:STRING,in3[100]:STRING,in4[100]:STRING,
    in5[100]:STRING,in6[100]:STRING,in7[100]:STRING,in8[100]:STRING,in9[100]:STRING,
    str_spaces[10]:ARRAY OF INT,unitgadstr[200]:STRING,tbuffer[200]:STRING

     /*************  startup page  *************/

DEF ss0[80]:STRING,ss1[80]:STRING,ss2[80]:STRING,ss3[80]:STRING,ss4[80]:STRING,ss5[80]:STRING,
    messagestr[9]:LIST,mtstr,startuplist

     /*************  pipe strings  *************/

DEF layout,layoutv,layoutbj,labelunit,space,le

CONST DETATCH=0,ATTACH=1

PROC main()
  close:=FALSE   -> set to false in DEF's
  setdefaults()
  buildgui()
  WHILE close=FALSE
    getline()
->    PrintF('getline() got=\s.\s.\s.\s.\s\n',in0,in1,in2,in3,in4)
    IF StrCmp('iconify',in0)
      IF small=FALSE
        topipe('id 0 s 32\n')  -> iconify
        small:=TRUE
      ELSE
        topipe('id 0 s 64\n')  -> uniconify
        small:=FALSE
      ENDIF
    ELSEIF StrCmp('close',in0)
      close:=TRUE
    ENDIF
    topipe('con\n')       -> tell pipe there's no more modify commands, we want event
  ENDWHILE
  Close(pipefile)
  IF pipereaderror THEN PrintF('\n Sorry, had to close down the gui,'+
                               '\n received a read error from the pipe.\n')
ENDPROC

PROC startupmessage()            -> put intro message on startup page
  DEF x
  attachedlist(startuplist,mainpage,DETATCH)
  FOR x:=0 TO 7
    addnodebuffer(startuplist,messagestr[x])
  ENDFOR
  attachedlist(startuplist,mainpage,ATTACH)
ENDPROC

PROC addnodebuffer(id,text)                           -> add node to list
  StringF(tbuffer,'id \d addnode gt="\s"\n',id,text)
ENDPROC topipe(tbuffer)                               -> returns gadget id

PROC attachedlist(list,page,switch)
  StringF(tbuffer,'id \d page \d list=\d\n',list,page,switch)
  topipe(tbuffer)                       -> detach/attach list
ENDPROC


      /*********************************** GUI **********************************/


PROC buildgui()
DEF layoutmainpage[30]:STRING,layoutclientpage[30]:STRING

  pipefile:=Open('awnpipe:ProNET-C/xc',OLDFILE) ->wcon:300//200/200/PipeEvents
  topipe('" ProNET-Control 1.0" m defg ig it="ProNET-C" ii="ProNET-Control" a cs\n')
  mainpage:=topipe('clicktab ctl " Startup| Server| Client"\n')

      /************************  Start page  *********************/

  StringF(layoutmainpage,'layout b 0 so si page \d\n',mainpage) -> for tabs

  topipe(layoutmainpage)
    topipe(layoutv)
      startuplist:=topipe('listbrowser ro minh=120\n') ->minw 500 minh=140
      topipe('browsernode gt " "\n')            -> put in text after window opens
      topipe(space)
      topipe(layout)
        topipe(space)
        topipe('layout gt=" Startup Prefs " b 3 so si v\n')
          topipe(space)
          topipe(layout)
            topipe(space)
            topipe('chooser pu cl " Open Window | Iconfiy " s=0 weiw=0\n')
            topipe('button gt=" Snapshot Window " weih=0  weiw=0\n')
            topipe(space)
          topipe(le)
          topipe(space)
        topipe(le)
        topipe(space)
      topipe(le)
      topipe(space)
    topipe(le)
  topipe(le)

      /***********************  End Start page *******************/


      /************************  Server  *********************/

  topipe(layoutmainpage)
    topipe(layoutv)
      topipe('listbrowser lbl "  Click on a unit to activate it " minh 70 st\n') -> minw 550->350
      topipe('browsernode gt " .config file not yet loaded"\n')
      topipe('button gt=" Load units from Devs:ProNET/.config " weih 0 cj\n')
      topipe('listbrowser lbl "  Units activated " ro minh=70 multi st\n') -> minw 550 weiw
      topipe('browsernode gt " None"\n')
      topipe('button gt " Stop ProNET-Server on all units " weih 0 cj\n') -> weiw 1
    topipe(le)
  topipe(le)

      /**********************  End Server  *********************/


  StringF(tbuffer,'layout b 0 page \d\n',mainpage)

  topipe(tbuffer)
    clientpage:=topipe('clicktab ctl " Mount| Page |  Talk "\n')
  topipe(le)


      /************************  Client  *********************/

  StringF(layoutclientpage,'layout b 0 so si page \d\n',clientpage)

  topipe(layoutclientpage)
    topipe(layoutv)
      topipe('listbrowser lbl " Status | Local Name | Remote Name | Volume Name | Unique " st v\n') ->minw 500 minh=140
      topipe('browsernode gt "||||"\n')
      StringF(tbuffer,'string gt="\s" ro cj\n',startinfo)
      topipe(tbuffer)
      topipe('layout b 0 si so bj weih=0\n')
        topipe('button gt " Scan server " weih=0\n')
        topipe(space)
        topipe(labelunit)
        topipe(unitgadstr)
        topipe(space)
        topipe('label gt="Local Name:"\n')
        topipe('string cj minw=120 maxc=20 dis=1\n')
      topipe(le)
    topipe(le)
  topipe(le)

     /***********************  End Client  ********************/


      /************************  page  **************************/

  topipe(layoutclientpage)
    topipe(layoutv)
      topipe(space)
      topipe('layout gt=" Send message to server " b 3 so si v\n')
        topipe(space)
        topipe(layout)
          topipe(space)
          topipe(layoutv)
            topipe('label gt=" Message:"\n')
            topipe('string lj minw=324 maxc=70\n')
          topipe(le)
          topipe(space)
        topipe(le)
        topipe(space)
        topipe(layoutbj)
          topipe(space)
          topipe(labelunit)
          topipe(unitgadstr)
          topipe(space)
          topipe('button gt " Send message " weih 0 weiw 0\n')
          topipe(space)
        topipe(le)
        topipe(space)
      topipe(le)
      topipe(space)
    topipe(le)
  topipe(le)

     /***********************  End page  ************************/


     /************************  talk  **************************/

  topipe(layoutclientpage)
    topipe(space)
    topipe(layoutv)
    topipe(space)
    topipe('layout gt=" Chat with server " b 3 so si v\n')
      topipe(space)
      topipe(layoutbj)
        topipe(space)
        topipe('button gt " Start Pronet-talk on both machines " cj weih=0 weiw=0\n')
        topipe(space)
      topipe(le)
      topipe(layoutbj)
        topipe(space)
        topipe(labelunit)
        topipe(unitgadstr)
        topipe(space)
      topipe(le)
      topipe(space)
    topipe(le)
    topipe(space)
    topipe(le)
    topipe(space)
  topipe(le)


     /***********************  End talk  ************************/


  topipe('open\n')      -> open the window
  startupmessage()       -> put text in startup listbrowser
  topipe('con\n')       -> start listening to events from the pipe
ENDPROC

     /********************************** End GUI ********************************/


PROC setdefaults()    -> ******* put here to unclutter main() *******

  instring:=[in0,in1,in2,in3,in4,in5,in6,in7,in8,in9]:LONG
  startinfo:='Start the remote server before attempting to scan it'

  mtstr:=' '

  ss0:='  Example of using AWNPipe in E,'
  ss1:='  to produce a reaction gui.'
  ss2:='  As you can see from this programs size,'
  ss3:='  using AWNPipe can make your program code smaller.'
  ss4:='  It also lets you write the gui code faster,'
  ss5:='  leaving you to concentrate on the main code.'

  messagestr:=[ss0,ss1,mtstr,ss2,ss3,mtstr,ss4,ss5]:LONG

  layout:='layout b 0 so si\n'
  layoutv:='layout b 0 v so si\n'
  layoutbj:='layout b 0 so si bj\n'
  labelunit:='label gt="Unit:"\n'
  space:='space\n'
  le:='le\n'

  StringF(unitgadstr,'chooser pu cl " 0 | 1 | 2 " maxn=3 weiw=0\n')

ENDPROC

PROC getline()     -> loops until all data seperated by spaces is collected
  DEF input[1024]:STRING
  IF ReadStr(pipefile,input)<>-1     -> returns -1 if error or EOF encounted
->    PrintF('incomming=\s\n',input)
    cutup_str(input)
  ENDIF
ENDPROC

PROC cutup_str(input)
  DEF space,x,gap
  x:=0
  WHILE (space:=InStr(input,' '))<>-1
    StrCopy(instring[x],input,space)
    MidStr(input,input,space+1)
    gap:=StrLen(input)
    input:=TrimStr(input)
    INC x
    str_spaces[x]:=gap-StrLen(input)
  ENDWHILE
  StrCopy(instring[x],input)
ENDPROC

PROC topipe(data)
  DEF res,input[10]:STRING
  Fputs(pipefile,data)             -> used instead of VfPrintf()
->  PrintF('Data Sent=\s.',data)
  IF ReadStr(pipefile,input)<>-1     -> returns -1 if error or EOF encounted
->    PrintF('Data comming back=\s.\n\n',input)
    IF StrCmp(input,'ok',2)
      IF StrLen(input)>2 THEN res:=RightStr(input,input,(StrLen(input)-3))
    ENDIF
  ELSE
->    PrintF('Error or EOF from ReadStr(pipef,input)\n')
    pipereaderror:=TRUE
    close:=TRUE
  ENDIF
ENDPROC Val(res)
