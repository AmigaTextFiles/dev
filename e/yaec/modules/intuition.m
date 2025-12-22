OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
->  Public functions OpenIntuition() and Intuition() are intentionally
->  not documented.
MACRO OpenIntuition() IS (A6:=intuitionbase) BUT ASM ' jsr -30(a6)'
MACRO Intuition(iEvent) IS (A0:=iEvent) BUT (A6:=intuitionbase) BUT ASM ' jsr -36(a6)'
MACRO AddGadget(window,gadget,position) IS Stores(intuitionbase,window,gadget,position) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -42(a6)'
MACRO ClearDMRequest(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -48(a6)'
MACRO ClearMenuStrip(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -54(a6)'
MACRO ClearPointer(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -60(a6)'
MACRO CloseScreen(screen) IS (A0:=screen) BUT (A6:=intuitionbase) BUT ASM ' jsr -66(a6)'
MACRO CloseWindow(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -72(a6)'
MACRO CloseWorkBench() IS (A6:=intuitionbase) BUT ASM ' jsr -78(a6)'
MACRO CurrentTime(seconds,micros) IS Stores(intuitionbase,seconds,micros) BUT Loads(A6,A0,A1) BUT ASM ' jsr -84(a6)'
MACRO DisplayAlert(alertNumber,string,height) IS Stores(intuitionbase,alertNumber,string,height) BUT Loads(A6,D0,A0,D1) BUT ASM ' jsr -90(a6)'
MACRO DisplayBeep(screen) IS (A0:=screen) BUT (A6:=intuitionbase) BUT ASM ' jsr -96(a6)'
MACRO DoubleClick(sSeconds,sMicros,cSeconds,cMicros) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,sSeconds,sMicros,cSeconds,cMicros) BUT Loads(A6,D0,D1,D2,D3) BUT ASM ' jsr -102(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO DrawBorder(rp,border,leftOffset,topOffset) IS Stores(intuitionbase,rp,border,leftOffset,topOffset) BUT Loads(A6,A0,A1,D0,D1) BUT ASM ' jsr -108(a6)'
MACRO DrawImage(rp,image,leftOffset,topOffset) IS Stores(intuitionbase,rp,image,leftOffset,topOffset) BUT Loads(A6,A0,A1,D0,D1) BUT ASM ' jsr -114(a6)'
MACRO EndRequest(requester,window) IS Stores(intuitionbase,requester,window) BUT Loads(A6,A0,A1) BUT ASM ' jsr -120(a6)'
MACRO GetDefPrefs(preferences,size) IS Stores(intuitionbase,preferences,size) BUT Loads(A6,A0,D0) BUT ASM ' jsr -126(a6)'
MACRO GetPrefs(preferences,size) IS Stores(intuitionbase,preferences,size) BUT Loads(A6,A0,D0) BUT ASM ' jsr -132(a6)'
MACRO InitRequester(requester) IS (A0:=requester) BUT (A6:=intuitionbase) BUT ASM ' jsr -138(a6)'
MACRO ItemAddress(menuStrip,menuNumber) IS Stores(intuitionbase,menuStrip,menuNumber) BUT Loads(A6,A0,D0) BUT ASM ' jsr -144(a6)'
MACRO ModifyIDCMP(window,flags) IS Stores(intuitionbase,window,flags) BUT Loads(A6,A0,D0) BUT ASM ' jsr -150(a6)'
MACRO ModifyProp(gadget,window,requester,flags,horizPot,vertPot,horizBody,vertBody) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(intuitionbase,gadget,window,requester,flags,horizPot,vertPot,horizBody,vertBody) BUT Loads(A6,A0,A1,A2,D0,D1,D2,D3,D4) BUT ASM ' jsr -156(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO MoveScreen(screen,dx,dy) IS Stores(intuitionbase,screen,dx,dy) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -162(a6)'
MACRO MoveWindow(window,dx,dy) IS Stores(intuitionbase,window,dx,dy) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -168(a6)'
MACRO OffGadget(gadget,window,requester) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadget,window,requester) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -174(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO OffMenu(window,menuNumber) IS Stores(intuitionbase,window,menuNumber) BUT Loads(A6,A0,D0) BUT ASM ' jsr -180(a6)'
MACRO OnGadget(gadget,window,requester) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadget,window,requester) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -186(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO OnMenu(window,menuNumber) IS Stores(intuitionbase,window,menuNumber) BUT Loads(A6,A0,D0) BUT ASM ' jsr -192(a6)'
MACRO OpenScreen(newScreen) IS (A0:=newScreen) BUT (A6:=intuitionbase) BUT ASM ' jsr -198(a6)'
MACRO OpenWindow(newWindow) IS (A0:=newWindow) BUT (A6:=intuitionbase) BUT ASM ' jsr -204(a6)'
MACRO OpenWorkBench() IS (A6:=intuitionbase) BUT ASM ' jsr -210(a6)'
MACRO PrintIText(rp,iText,left,top) IS Stores(intuitionbase,rp,iText,left,top) BUT Loads(A6,A0,A1,D0,D1) BUT ASM ' jsr -216(a6)'
MACRO RefreshGadgets(gadgets,window,requester) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadgets,window,requester) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -222(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RemoveGadget(window,gadget) IS Stores(intuitionbase,window,gadget) BUT Loads(A6,A0,A1) BUT ASM ' jsr -228(a6)'
->  The official calling sequence for ReportMouse is given below.
->  Note the register order.  For the complete story, read the ReportMouse
->  autodoc.
MACRO ReportMouse(flag,window) IS Stores(intuitionbase,flag,window) BUT Loads(A6,D0,A0) BUT ASM ' jsr -234(a6)'
MACRO Request(requester,window) IS Stores(intuitionbase,requester,window) BUT Loads(A6,A0,A1) BUT ASM ' jsr -240(a6)'
MACRO ScreenToBack(screen) IS (A0:=screen) BUT (A6:=intuitionbase) BUT ASM ' jsr -246(a6)'
MACRO ScreenToFront(screen) IS (A0:=screen) BUT (A6:=intuitionbase) BUT ASM ' jsr -252(a6)'
MACRO SetDMRequest(window,requester) IS Stores(intuitionbase,window,requester) BUT Loads(A6,A0,A1) BUT ASM ' jsr -258(a6)'
MACRO SetMenuStrip(window,menu) IS Stores(intuitionbase,window,menu) BUT Loads(A6,A0,A1) BUT ASM ' jsr -264(a6)'
MACRO SetPointer(window,pointer,height,width,xOffset,yOffset) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,pointer,height,width,xOffset,yOffset) BUT Loads(A6,A0,A1,D0,D1,D2,D3) BUT ASM ' jsr -270(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO SetWindowTitles(window,windowTitle,screenTitle) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,windowTitle,screenTitle) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -276(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO ShowTitle(screen,showIt) IS Stores(intuitionbase,screen,showIt) BUT Loads(A6,A0,D0) BUT ASM ' jsr -282(a6)'
MACRO SizeWindow(window,dx,dy) IS Stores(intuitionbase,window,dx,dy) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -288(a6)'
MACRO ViewAddress() IS (A6:=intuitionbase) BUT ASM ' jsr -294(a6)'
MACRO ViewPortAddress(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -300(a6)'
MACRO WindowToBack(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -306(a6)'
MACRO WindowToFront(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -312(a6)'
MACRO WindowLimits(window,widthMin,heightMin,widthMax,heightMax) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,widthMin,heightMin,widthMax,heightMax) BUT Loads(A6,A0,D0,D1,D2,D3) BUT ASM ' jsr -318(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> --- start of next generation of names -------------------------------------
MACRO SetPrefs(preferences,size,inform) IS Stores(intuitionbase,preferences,size,inform) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -324(a6)'
-> --- start of next next generation of names --------------------------------
MACRO IntuiTextLength(iText) IS (A0:=iText) BUT (A6:=intuitionbase) BUT ASM ' jsr -330(a6)'
MACRO WBenchToBack() IS (A6:=intuitionbase) BUT ASM ' jsr -336(a6)'
MACRO WBenchToFront() IS (A6:=intuitionbase) BUT ASM ' jsr -342(a6)'
-> --- start of next next next generation of names ---------------------------
MACRO AutoRequest(window,body,posText,negText,pFlag,nFlag,width,height) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,body,posText,negText,pFlag,nFlag,width,height) BUT Loads(A6,A0,A1,A2,A3,D0,D1,D2,D3) BUT ASM ' jsr -348(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO BeginRefresh(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -354(a6)'
MACRO BuildSysRequest(window,body,posText,negText,flags,width,height) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,body,posText,negText,flags,width,height) BUT Loads(A6,A0,A1,A2,A3,D0,D1,D2) BUT ASM ' jsr -360(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO EndRefresh(window,complete) IS Stores(intuitionbase,window,complete) BUT Loads(A6,A0,D0) BUT ASM ' jsr -366(a6)'
MACRO FreeSysRequest(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -372(a6)'
->  The return codes for MakeScreen(), RemakeDisplay(), and RethinkDisplay()
->  are only valid under V39 and greater.  Do not examine them when running
->  on pre-V39 systems!
MACRO MakeScreen(screen) IS (A0:=screen) BUT (A6:=intuitionbase) BUT ASM ' jsr -378(a6)'
MACRO RemakeDisplay() IS (A6:=intuitionbase) BUT ASM ' jsr -384(a6)'
MACRO RethinkDisplay() IS (A6:=intuitionbase) BUT ASM ' jsr -390(a6)'
-> --- start of next next next next generation of names ----------------------
MACRO AllocRemember(rememberKey,size,flags) IS Stores(intuitionbase,rememberKey,size,flags) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -396(a6)'
->  Public function AlohaWorkbench() is intentionally not documented
MACRO AlohaWorkbench(wbport) IS (A0:=wbport) BUT (A6:=intuitionbase) BUT ASM ' jsr -402(a6)'
MACRO FreeRemember(rememberKey,reallyForget) IS Stores(intuitionbase,rememberKey,reallyForget) BUT Loads(A6,A0,D0) BUT ASM ' jsr -408(a6)'
-> --- start of 15 Nov 85 names ------------------------
MACRO LockIBase(dontknow) IS (D0:=dontknow) BUT (A6:=intuitionbase) BUT ASM ' jsr -414(a6)'
MACRO UnlockIBase(ibLock) IS (A0:=ibLock) BUT (A6:=intuitionbase) BUT ASM ' jsr -420(a6)'
-> --- functions in V33 or higher (Release 1.2) ---
MACRO GetScreenData(buffer,size,type,screen) IS Stores(intuitionbase,buffer,size,type,screen) BUT Loads(A6,A0,D0,D1,A1) BUT ASM ' jsr -426(a6)'
MACRO RefreshGList(gadgets,window,requester,numGad) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadgets,window,requester,numGad) BUT Loads(A6,A0,A1,A2,D0) BUT ASM ' jsr -432(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO AddGList(window,gadget,position,numGad,requester) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,gadget,position,numGad,requester) BUT Loads(A6,A0,A1,D0,D1,A2) BUT ASM ' jsr -438(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO RemoveGList(remPtr,gadget,numGad) IS Stores(intuitionbase,remPtr,gadget,numGad) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -444(a6)'
MACRO ActivateWindow(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -450(a6)'
MACRO RefreshWindowFrame(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -456(a6)'
MACRO ActivateGadget(gadgets,window,requester) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadgets,window,requester) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -462(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO NewModifyProp(gadget,window,requester,flags,horizPot,vertPot,horizBody,vertBody,numGad) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(intuitionbase,gadget,window,requester,flags,horizPot,vertPot,horizBody,vertBody,numGad) BUT Loads(A6,A0,A1,A2,D0,D1,D2,D3,D4,D5) BUT ASM ' jsr -468(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
-> --- functions in V36 or higher (Release 2.0) ---
MACRO QueryOverscan(displayID,rect,oScanType) IS Stores(intuitionbase,displayID,rect,oScanType) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -474(a6)'
MACRO MoveWindowInFrontOf(window,behindWindow) IS Stores(intuitionbase,window,behindWindow) BUT Loads(A6,A0,A1) BUT ASM ' jsr -480(a6)'
MACRO ChangeWindowBox(window,left,top,width,height) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,left,top,width,height) BUT Loads(A6,A0,D0,D1,D2,D3) BUT ASM ' jsr -486(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO SetEditHook(hook) IS (A0:=hook) BUT (A6:=intuitionbase) BUT ASM ' jsr -492(a6)'
MACRO SetMouseQueue(window,queueLength) IS Stores(intuitionbase,window,queueLength) BUT Loads(A6,A0,D0) BUT ASM ' jsr -498(a6)'
MACRO ZipWindow(window) IS (A0:=window) BUT (A6:=intuitionbase) BUT ASM ' jsr -504(a6)'
-> --- public screens ---
MACRO LockPubScreen(name) IS (A0:=name) BUT (A6:=intuitionbase) BUT ASM ' jsr -510(a6)'
MACRO UnlockPubScreen(name,screen) IS Stores(intuitionbase,name,screen) BUT Loads(A6,A0,A1) BUT ASM ' jsr -516(a6)'
MACRO LockPubScreenList() IS (A6:=intuitionbase) BUT ASM ' jsr -522(a6)'
MACRO UnlockPubScreenList() IS (A6:=intuitionbase) BUT ASM ' jsr -528(a6)'
MACRO NextPubScreen(screen,namebuf) IS Stores(intuitionbase,screen,namebuf) BUT Loads(A6,A0,A1) BUT ASM ' jsr -534(a6)'
MACRO SetDefaultPubScreen(name) IS (A0:=name) BUT (A6:=intuitionbase) BUT ASM ' jsr -540(a6)'
MACRO SetPubScreenModes(modes) IS (D0:=modes) BUT (A6:=intuitionbase) BUT ASM ' jsr -546(a6)'
MACRO PubScreenStatus(screen,statusFlags) IS Stores(intuitionbase,screen,statusFlags) BUT Loads(A6,A0,D0) BUT ASM ' jsr -552(a6)'
-> 
MACRO ObtainGIRPort(gInfo) IS (A0:=gInfo) BUT (A6:=intuitionbase) BUT ASM ' jsr -558(a6)'
MACRO ReleaseGIRPort(rp) IS (A0:=rp) BUT (A6:=intuitionbase) BUT ASM ' jsr -564(a6)'
MACRO GadgetMouse(gadget,gInfo,mousePoint) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadget,gInfo,mousePoint) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -570(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO GetDefaultPubScreen(nameBuffer) IS (A0:=nameBuffer) BUT (A6:=intuitionbase) BUT ASM ' jsr -582(a6)'
MACRO EasyRequestArgs(window,easyStruct,idcmpPtr,args) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,easyStruct,idcmpPtr,args) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -588(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO BuildEasyRequestArgs(window,easyStruct,idcmp,args) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,window,easyStruct,idcmp,args) BUT Loads(A6,A0,A1,D0,A3) BUT ASM ' jsr -594(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO SysReqHandler(window,idcmpPtr,waitInput) IS Stores(intuitionbase,window,idcmpPtr,waitInput) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -600(a6)'
MACRO OpenWindowTagList(newWindow,tagList) IS Stores(intuitionbase,newWindow,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -606(a6)'
MACRO OpenScreenTagList(newScreen,tagList) IS Stores(intuitionbase,newScreen,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -612(a6)'
-> 
-> 	new Image functions
MACRO DrawImageState(rp,image,leftOffset,topOffset,state,drawInfo) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,rp,image,leftOffset,topOffset,state,drawInfo) BUT Loads(A6,A0,A1,D0,D1,D2,A2) BUT ASM ' jsr -618(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO PointInImage(point,image) IS Stores(intuitionbase,point,image) BUT Loads(A6,D0,A0) BUT ASM ' jsr -624(a6)'
MACRO EraseImage(rp,image,leftOffset,topOffset) IS Stores(intuitionbase,rp,image,leftOffset,topOffset) BUT Loads(A6,A0,A1,D0,D1) BUT ASM ' jsr -630(a6)'
-> 
MACRO NewObjectA(classPtr,classID,tagList) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,classPtr,classID,tagList) BUT Loads(A6,A0,A1,A2) BUT ASM ' jsr -636(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
MACRO DisposeObject(object) IS (A0:=object) BUT (A6:=intuitionbase) BUT ASM ' jsr -642(a6)'
MACRO SetAttrsA(object,tagList) IS Stores(intuitionbase,object,tagList) BUT Loads(A6,A0,A1) BUT ASM ' jsr -648(a6)'
-> 
MACRO GetAttr(attrID,object,storagePtr) IS Stores(intuitionbase,attrID,object,storagePtr) BUT Loads(A6,D0,A0,A1) BUT ASM ' jsr -654(a6)'
-> 
->  	special set attribute call for gadgets
MACRO SetGadgetAttrsA(gadget,window,requester,tagList) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gadget,window,requester,tagList) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -660(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
-> 
-> 	for class implementors only
MACRO NextObject(objectPtrPtr) IS (A0:=objectPtrPtr) BUT (A6:=intuitionbase) BUT ASM ' jsr -666(a6)'
MACRO MakeClass(classID,superClassID,superClassPtr,instanceSize,flags) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,classID,superClassID,superClassPtr,instanceSize,flags) BUT Loads(A6,A0,A1,A2,D0,D1) BUT ASM ' jsr -678(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO AddClass(classPtr) IS (A0:=classPtr) BUT (A6:=intuitionbase) BUT ASM ' jsr -684(a6)'
-> 
-> 
MACRO GetScreenDrawInfo(screen) IS (A0:=screen) BUT (A6:=intuitionbase) BUT ASM ' jsr -690(a6)'
MACRO FreeScreenDrawInfo(screen,drawInfo) IS Stores(intuitionbase,screen,drawInfo) BUT Loads(A6,A0,A1) BUT ASM ' jsr -696(a6)'
-> 
MACRO ResetMenuStrip(window,menu) IS Stores(intuitionbase,window,menu) BUT Loads(A6,A0,A1) BUT ASM ' jsr -702(a6)'
MACRO RemoveClass(classPtr) IS (A0:=classPtr) BUT (A6:=intuitionbase) BUT ASM ' jsr -708(a6)'
MACRO FreeClass(classPtr) IS (A0:=classPtr) BUT (A6:=intuitionbase) BUT ASM ' jsr -714(a6)'
-> --- functions in V39 or higher (Release 3) ---
MACRO AllocScreenBuffer(sc,bm,flags) IS Stores(intuitionbase,sc,bm,flags) BUT Loads(A6,A0,A1,D0) BUT ASM ' jsr -768(a6)'
MACRO FreeScreenBuffer(sc,sb) IS Stores(intuitionbase,sc,sb) BUT Loads(A6,A0,A1) BUT ASM ' jsr -774(a6)'
MACRO ChangeScreenBuffer(sc,sb) IS Stores(intuitionbase,sc,sb) BUT Loads(A6,A0,A1) BUT ASM ' jsr -780(a6)'
MACRO ScreenDepth(screen,flags,reserved) IS Stores(intuitionbase,screen,flags,reserved) BUT Loads(A6,A0,D0,A1) BUT ASM ' jsr -786(a6)'
MACRO ScreenPosition(screen,flags,x1,y1,x2,y2) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(intuitionbase,screen,flags,x1,y1,x2,y2) BUT Loads(A6,A0,D0,D1,D2,D3,D4) BUT ASM ' jsr -792(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO ScrollWindowRaster(win,dx,dy,xMin,yMin,xMax,yMax) IS ASM ' movem.l d2-d7/a2-a5,-(a7)' BUT Stores(intuitionbase,win,dx,dy,xMin,yMin,xMax,yMax) BUT Loads(A6,A1,D0,D1,D2,D3,D4,D5) BUT ASM ' jsr -798(a6)' BUT ASM ' movem.l (a7)+, d2-d7/a2-a5'
MACRO LendMenus(fromwindow,towindow) IS Stores(intuitionbase,fromwindow,towindow) BUT Loads(A6,A0,A1) BUT ASM ' jsr -804(a6)'
MACRO DoGadgetMethodA(gad,win,req,message) IS ASM ' movem.l d2-d3/a2-a3,-(a7)' BUT Stores(intuitionbase,gad,win,req,message) BUT Loads(A6,A0,A1,A2,A3) BUT ASM ' jsr -810(a6)' BUT ASM ' movem.l (a7)+, d2-d3/a2-a3'
MACRO SetWindowPointerA(win,taglist) IS Stores(intuitionbase,win,taglist) BUT Loads(A6,A0,A1) BUT ASM ' jsr -816(a6)'
MACRO TimedDisplayAlert(alertNumber,string,height,time) IS Stores(intuitionbase,alertNumber,string,height,time) BUT Loads(A6,D0,A0,D1,A1) BUT ASM ' jsr -822(a6)'
MACRO HelpControl(win,flags) IS Stores(intuitionbase,win,flags) BUT Loads(A6,A0,D0) BUT ASM ' jsr -828(a6)'
