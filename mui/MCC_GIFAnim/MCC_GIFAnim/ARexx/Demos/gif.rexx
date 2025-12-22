/**/

signal on halt
signal on break_c

l="rmh.library"; if ~show("L",l) then; if ~AddLib(l,0,-30) then exit
if AddLibrary("rxmui.library")~=0 then exit

if ~ReadArgs("FILE/A,NTA=NTANIM/S,P1=PLAYONCE/S") then do
    call PrintFault()
    exit
end

call CreateApp(parm.0.value,parm.1.flag,parm.2.flag)
call HandleApp

/* never reached */
/***********************************************************************/
HandleApp: procedure
    ctrl_c=2**12
    do forever
        call NewHandle("app","h",ctrl_c)
        if and(h.signals,ctrl_c)>0 then exit
        select
            when h.event="QUIT" then exit
            otherwise interpret h.event
        end
    end
    /* never reached */
/***********************************************************************/
CreateApp: procedure
parse arg f,nta,p1

    app.Title="GIFAnimExample"
    app.Version="$VER: GIFAnimExample 3.0 (2.8.2002)"
    app.Copyright="Copyright 2002 Alfonso Ranieri"
    app.Author="Alfonso Ranieri"
    app.Description="GIFAnimExample"
    app.Base="RXMUIEXAMPLE"
    app.SubWindow="win"

     win.ID="MAIN"
     win.Title="GIFAnim Example"
     win.Contents="mgroup"

      mgroup.0="sg"
       sg.Class="Scrollgroup"
       sg.VirtgroupContents="g"

        g.0="vg"
         vg.Class="Group"
         vg.Frame="Virtual"
         vg.Background="GroupBack"
          vg.0=VSpace()
          vg.1="hg"
           hg.Class="Group"
           hg.Horiz=1
            hg.0=HSpace()
            hg.1="gif"
             gif.Class="GIFAnim"
             gif.File=f
             gif.Anim=~nta | p1
            hg.2=HSpace()
          vg.2=VSpace()

        mgroup.1="bg"
         bg.Class="Group"
         bg.Horiz=1
           pause.Disabled=1
          bg.0=Button("pause","_Pause")
           play1.Disabled=1
          bg.1=Button("play1","Play_1")
           start.Disabled=1
          bg.2=Button("start","_Start")
           first.Disabled=1
          bg.3=Button("first","_First")
           last.Disabled=1
          bg.4=Button("last","_Last")
           next.Disabled=1
          bg.5=Button("next","_Next")
           pred.Disabled=1
          bg.6=Button("pred","P_red")

        mgroup.2="ig"
         ig.Class="Group"
         ig.horiz=1
          ig.0=Label("Decoding")
          ig.1="status"; status.Class="Lamp"; status.Color=1
          ig.2=HWSpace(5)
          ig.3=Label("Play")
          ig.4="pstatus"; pstatus.Class="Lamp"; pstatus.Color=~nta | p1
          ig.5=HWSpace(5)
          ig.6=Label("Frames:")
          ig.7="curr"; curr.class="Text"; curr.FixWidthTxt="XXXXX"; curr.Contents="0"
          ig.8=Label("Current:")
           frame.Disabled=1
          ig.9=MakeObj("frame","slider")

        mgroup.3="vvg"
         vvg.Class="Group"
         vvg.Horiz=1
          vvg.0=Button("vtop","Top")
          vvg.1=Button("vbottom","Bottom")

    if NewObj("Application","app")>0 then exit

    call Notify("win","CloseRequest",1,"app","ReturnID","quit")

    call Notify("gif","Anim","Everytime","pstatus","set","Color","Triggervalue")
    call Notify("gif","Decoded","Everytime","app","Return","call DecodedFun(h.Decoded)","Triggerattr")
    call Notify("gif","Decoded","Everytime","status","set","Color","NotTriggervalue")
    call Notify("gif","Current","Everytime","frame","Set","Value","Triggervalue")

    call Notify("pause","Pressed",0,"app","return","call PauseFun")
    call Notify("play1","Pressed",0,"gif","Play","Rewind Once")
    call Notify("start","Pressed",0,"gif","Play")
    call Notify("first","Pressed",0,"gif","First")
    call Notify("last","Pressed",0,"gif","Last")
    call Notify("next","Timer","Everytime","gif","Next")
    call Notify("pred","Timer","Everytime","gif","Pred")

    call Notify("frame","value","Everytime","gif","Set","Current","Triggervalue")

    call Notify("vtop","Pressed",0,"g","set","VIRTGROUPTOP",0)
    call Notify("vbottom","Pressed",0,"g","set","VIRTGROUPTOP",1000)

    call set("win","Open",1)

    if p1 then call DoMethod("gif","Play","Rewind Once")

    return
/***********************************************************************/
halt:
break_c:
    exit
/**************************************************************************/
PauseFun: procedure
    if xget("gif","anim") then call DoMethod("gif","Play","Off")
    else call DoMethod("gif","Play","On")
    return
/**************************************************************************/
DecodedFun: procedure
parse arg d
    call get("gif","pics","p")
    if d then do
        if p>1 then do
            call set("frame","max",p-1)
            call set("frame","disabled",0)
        end
        call set("curr","Integer",p)
    end
    else do
        call set("curr","Integer",0)
    end

    d=~d | (p<=1)

    set.0="pause"; set.0.attr="Disabled"; set.0.value=d
    set.1="play1"; set.1.attr="Disabled"; set.1.value=d
    set.2="start"; set.2.attr="Disabled"; set.2.value=d
    set.3="first"; set.3.attr="Disabled"; set.3.value=d
    set.4="last";  set.4.attr="Disabled"; set.4.value=d
    set.5="next";  set.5.attr="Disabled"; set.5.value=d
    set.6="pred";  set.6.attr="Disabled"; set.6.value=d
    set.7="frame"; set.7.attr="Disabled"; set.7.value=d

    call MultiSetAttr("set")

    return
/**************************************************************************/
