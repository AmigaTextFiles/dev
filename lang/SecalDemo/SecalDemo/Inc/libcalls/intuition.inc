pattern OpenIntuition is
	push a6;
	a6:=IntuitionBase; jsr [a6-30];
	pop a6;
endp;															# OPENINTUITION

pattern Intuition(_iEvent) is
	push a6;
	a0:=_iEvent;
	a6:=IntuitionBase; jsr [a6-36];
	pop a6;
endp;															# INTUITION

pattern AddGadget(_window,_gadget,_position) is
	push a6;
	safe a0:=_window; a1:=_gadget; d0.l:=_position;;
	a6:=IntuitionBase; jsr [a6-42];
	pop a6;
endp;															# ADDGADGET

pattern ClearDMRequest(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-48];
	pop a6;
endp;															# CLEARDMREQUEST

pattern ClearMenuStrip(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-54];
	pop a6;
endp;															# CLEARMENUSTRIP

pattern ClearPointer(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-60];
	pop a6;
endp;															# CLEARPOINTER

pattern CloseScreen(_screen) is
	push a6;
	a0:=_screen;
	a6:=IntuitionBase; jsr [a6-66];
	pop a6;
endp;															# CLOSESCREEN

pattern CloseWindow(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-72];
	pop a6;
endp;															# CLOSEWINDOW

pattern CloseWorkBench is
	push a6;
	a6:=IntuitionBase; jsr [a6-78];
	pop a6;
endp;															# CLOSEWORKBENCH

pattern CurrentTime(_seconds,_micros) is
	push a6;
	safe a0:=_seconds; a1:=_micros;;
	a6:=IntuitionBase; jsr [a6-84];
	pop a6;
endp;															# CURRENTTIME

pattern DisplayAlert(_alertNumber,_string,_height) is
	push a6;
	safe d0.l:=_alertNumber; a0:=_string; d1.l:=_height;;
	a6:=IntuitionBase; jsr [a6-90];
	pop a6;
endp;															# DISPLAYALERT

pattern DisplayBeep(_screen) is
	push a6;
	a0:=_screen;
	a6:=IntuitionBase; jsr [a6-96];
	pop a6;
endp;															# DISPLAYBEEP

pattern DoubleClick(_sSeconds,_sMicros,_cSeconds,_cMicros) is
	push d2\d3\a6;
	safe d0.l:=_sSeconds; d1.l:=_sMicros; d2.l:=_cSeconds; d3.l:=_cMicros;;
	a6:=IntuitionBase; jsr [a6-102];
	pop d2\d3\a6;
endp;															# DOUBLECLICK

pattern DrawBorder(_rp,_border,_leftOffset,_topOffset) is
	push a6;
	safe a0:=_rp; a1:=_border; d0.l:=_leftOffset; d1.l:=_topOffset;;
	a6:=IntuitionBase; jsr [a6-108];
	pop a6;
endp;															# DRAWBORDER

pattern DrawImage(_rp,_image,_leftOffset,_topOffset) is
	push a6;
	safe a0:=_rp; a1:=_image; d0.l:=_leftOffset; d1.l:=_topOffset;;
	a6:=IntuitionBase; jsr [a6-114];
	pop a6;
endp;															# DRAWIMAGE

pattern EndRequest(_requester,_window) is
	push a6;
	safe a0:=_requester; a1:=_window;;
	a6:=IntuitionBase; jsr [a6-120];
	pop a6;
endp;															# ENDREQUEST

pattern GetDefPrefs(_preferences,_size) is
	push a6;
	safe a0:=_preferences; d0.l:=_size;;
	a6:=IntuitionBase; jsr [a6-126];
	pop a6;
endp;															# GETDEFPREFS

pattern GetPrefs(_preferences,_size) is
	push a6;
	safe a0:=_preferences; d0.l:=_size;;
	a6:=IntuitionBase; jsr [a6-132];
	pop a6;
endp;															# GETPREFS

pattern InitRequester(_requester) is
	push a6;
	a0:=_requester;
	a6:=IntuitionBase; jsr [a6-138];
	pop a6;
endp;															# INITREQUESTER

pattern ItemAddress(_menuStrip,_menuNumber) is
	push a6;
	safe a0:=_menuStrip; d0.l:=_menuNumber;;
	a6:=IntuitionBase; jsr [a6-144];
	pop a6;
endp;															# ITEMADDRESS

pattern ModifyIDCMP(_window,_flags) is
	push a6;
	safe a0:=_window; d0.l:=_flags;;
	a6:=IntuitionBase; jsr [a6-150];
	pop a6;
endp;															# MODIFYIDCMP

pattern ModifyProp(_gadget,_window,_requester,_flags,_horizPot,_vertPot,_horizBody,_vertBody) is
	push d2\d3\d4\a2\a6;
	safe a0:=_gadget; a1:=_window; a2:=_requester; d0.l:=_flags; d1.l:=_horizPot; d2.l:=_vertPot; d3.l:=_horizBody; d4.l:=_vertBody;;
	a6:=IntuitionBase; jsr [a6-156];
	pop d2\d3\d4\a2\a6;
endp;															# MODIFYPROP

pattern MoveScreen(_screen,_dx,_dy) is
	push a6;
	safe a0:=_screen; d0.l:=_dx; d1.l:=_dy;;
	a6:=IntuitionBase; jsr [a6-162];
	pop a6;
endp;															# MOVESCREEN

pattern MoveWindow(_window,_dx,_dy) is
	push a6;
	safe a0:=_window; d0.l:=_dx; d1.l:=_dy;;
	a6:=IntuitionBase; jsr [a6-168];
	pop a6;
endp;															# MOVEWINDOW

pattern OffGadget(_gadget,_window,_requester) is
	push a2\a6;
	safe a0:=_gadget; a1:=_window; a2:=_requester;;
	a6:=IntuitionBase; jsr [a6-174];
	pop a2\a6;
endp;															# OFFGADGET

pattern OffMenu(_window,_menuNumber) is
	push a6;
	safe a0:=_window; d0.l:=_menuNumber;;
	a6:=IntuitionBase; jsr [a6-180];
	pop a6;
endp;															# OFFMENU

pattern OnGadget(_gadget,_window,_requester) is
	push a2\a6;
	safe a0:=_gadget; a1:=_window; a2:=_requester;;
	a6:=IntuitionBase; jsr [a6-186];
	pop a2\a6;
endp;															# ONGADGET

pattern OnMenu(_window,_menuNumber) is
	push a6;
	safe a0:=_window; d0.l:=_menuNumber;;
	a6:=IntuitionBase; jsr [a6-192];
	pop a6;
endp;															# ONMENU

pattern OpenScreen(_newScreen) is
	push a6;
	a0:=_newScreen;
	a6:=IntuitionBase; jsr [a6-198];
	pop a6;
endp;															# OPENSCREEN

pattern OpenWindow(_newWindow) is
	push a6;
	a0:=_newWindow;
	a6:=IntuitionBase; jsr [a6-204];
	pop a6;
endp;															# OPENWINDOW

pattern OpenWorkBench is
	push a6;
	a6:=IntuitionBase; jsr [a6-210];
	pop a6;
endp;															# OPENWORKBENCH

pattern PrintIText(_rp,_iText,_left,_top) is
	push a6;
	safe a0:=_rp; a1:=_iText; d0.l:=_left; d1.l:=_top;;
	a6:=IntuitionBase; jsr [a6-216];
	pop a6;
endp;															# PRINTITEXT

pattern RefreshGadgets(_gadgets,_window,_requester) is
	push a2\a6;
	safe a0:=_gadgets; a1:=_window; a2:=_requester;;
	a6:=IntuitionBase; jsr [a6-222];
	pop a2\a6;
endp;															# REFRESHGADGETS

pattern RemoveGadget(_window,_gadget) is
	push a6;
	safe a0:=_window; a1:=_gadget;;
	a6:=IntuitionBase; jsr [a6-228];
	pop a6;
endp;															# REMOVEGADGET

pattern ReportMouse(_flag,_window) is
	push a6;
	safe d0.l:=_flag; a0:=_window;;
	a6:=IntuitionBase; jsr [a6-234];
	pop a6;
endp;															# REPORTMOUSE

pattern Request(_requester,_window) is
	push a6;
	safe a0:=_requester; a1:=_window;;
	a6:=IntuitionBase; jsr [a6-240];
	pop a6;
endp;															# REQUEST

pattern ScreenToBack(_screen) is
	push a6;
	a0:=_screen;
	a6:=IntuitionBase; jsr [a6-246];
	pop a6;
endp;															# SCREENTOBACK

pattern ScreenToFront(_screen) is
	push a6;
	a0:=_screen;
	a6:=IntuitionBase; jsr [a6-252];
	pop a6;
endp;															# SCREENTOFRONT

pattern SetDMRequest(_window,_requester) is
	push a6;
	safe a0:=_window; a1:=_requester;;
	a6:=IntuitionBase; jsr [a6-258];
	pop a6;
endp;															# SETDMREQUEST

pattern SetMenuStrip(_window,_menu) is
	push a6;
	safe a0:=_window; a1:=_menu;;
	a6:=IntuitionBase; jsr [a6-264];
	pop a6;
endp;															# SETMENUSTRIP

pattern SetPointer(_window,_pointer,_height,_width,_xOffset,_yOffset) is
	push d2\d3\a6;
	safe a0:=_window; a1:=_pointer; d0.l:=_height; d1.l:=_width; d2.l:=_xOffset; d3.l:=_yOffset;;
	a6:=IntuitionBase; jsr [a6-270];
	pop d2\d3\a6;
endp;															# SETPOINTER

pattern SetWindowTitles(_window,_windowTitle,_screenTitle) is
	push a2\a6;
	safe a0:=_window; a1:=_windowTitle; a2:=_screenTitle;;
	a6:=IntuitionBase; jsr [a6-276];
	pop a2\a6;
endp;															# SETWINDOWTITLES

pattern ShowTitle(_screen,_showIt) is
	push a6;
	safe a0:=_screen; d0.l:=_showIt;;
	a6:=IntuitionBase; jsr [a6-282];
	pop a6;
endp;															# SHOWTITLE

pattern SizeWindow(_window,_dx,_dy) is
	push a6;
	safe a0:=_window; d0.l:=_dx; d1.l:=_dy;;
	a6:=IntuitionBase; jsr [a6-288];
	pop a6;
endp;															# SIZEWINDOW

pattern ViewAddress is
	push a6;
	a6:=IntuitionBase; jsr [a6-294];
	pop a6;
endp;															# VIEWADDRESS

pattern ViewPortAddress(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-300];
	pop a6;
endp;															# VIEWPORTADDRESS

pattern WindowToBack(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-306];
	pop a6;
endp;															# WINDOWTOBACK

pattern WindowToFront(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-312];
	pop a6;
endp;															# WINDOWTOFRONT

pattern WindowLimits(_window,_widthMin,_heightMin,_widthMax,_heightMax) is
	push d2\d3\a6;
	safe a0:=_window; d0.l:=_widthMin; d1.l:=_heightMin; d2.l:=_widthMax; d3.l:=_heightMax;;
	a6:=IntuitionBase; jsr [a6-318];
	pop d2\d3\a6;
endp;															# WINDOWLIMITS

pattern SetPrefs(_preferences,_size,_inform) is
	push a6;
	safe a0:=_preferences; d0.l:=_size; d1.l:=_inform;;
	a6:=IntuitionBase; jsr [a6-324];
	pop a6;
endp;															# SETPREFS

pattern IntuiTextLength(_iText) is
	push a6;
	a0:=_iText;
	a6:=IntuitionBase; jsr [a6-330];
	pop a6;
endp;															# INTUITEXTLENGTH

pattern WBenchToBack is
	push a6;
	a6:=IntuitionBase; jsr [a6-336];
	pop a6;
endp;															# WBENCHTOBACK

pattern WBenchToFront is
	push a6;
	a6:=IntuitionBase; jsr [a6-342];
	pop a6;
endp;															# WBENCHTOFRONT

pattern AutoRequest(_window,_body,_posText,_negText,_pFlag,_nFlag,_width,_height) is
	push d2\d3\a2\a3\a6;
	safe a0:=_window; a1:=_body; a2:=_posText; a3:=_negText; d0.l:=_pFlag; d1.l:=_nFlag; d2.l:=_width; d3.l:=_height;;
	a6:=IntuitionBase; jsr [a6-348];
	pop d2\d3\a2\a3\a6;
endp;															# AUTOREQUEST

pattern BeginRefresh(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-354];
	pop a6;
endp;															# BEGINREFRESH

pattern BuildSysRequest(_window,_body,_posText,_negText,_flags,_width,_height) is
	push d2\a2\a3\a6;
	safe a0:=_window; a1:=_body; a2:=_posText; a3:=_negText; d0.l:=_flags; d1.l:=_width; d2.l:=_height;;
	a6:=IntuitionBase; jsr [a6-360];
	pop d2\a2\a3\a6;
endp;															# BUILDSYSREQUEST

pattern EndRefresh(_window,_complete) is
	push a6;
	safe a0:=_window; d0.l:=_complete;;
	a6:=IntuitionBase; jsr [a6-366];
	pop a6;
endp;															# ENDREFRESH

pattern FreeSysRequest(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-372];
	pop a6;
endp;															# FREESYSREQUEST

pattern MakeScreen(_screen) is
	push a6;
	a0:=_screen;
	a6:=IntuitionBase; jsr [a6-378];
	pop a6;
endp;															# MAKESCREEN

pattern RemakeDisplay is
	push a6;
	a6:=IntuitionBase; jsr [a6-384];
	pop a6;
endp;															# REMAKEDISPLAY

pattern RethinkDisplay is
	push a6;
	a6:=IntuitionBase; jsr [a6-390];
	pop a6;
endp;															# RETHINKDISPLAY

pattern AllocRemember(_rememberKey,_size,_flags) is
	push a6;
	safe a0:=_rememberKey; d0.l:=_size; d1.l:=_flags;;
	a6:=IntuitionBase; jsr [a6-396];
	pop a6;
endp;															# ALLOCREMEMBER

pattern AlohaWorkbench(_wbport) is
	push a6;
	a0:=_wbport;
	a6:=IntuitionBase; jsr [a6-402];
	pop a6;
endp;															# ALOHAWORKBENCH

pattern FreeRemember(_rememberKey,_reallyForget) is
	push a6;
	safe a0:=_rememberKey; d0.l:=_reallyForget;;
	a6:=IntuitionBase; jsr [a6-408];
	pop a6;
endp;															# FREEREMEMBER

pattern LockIBase(_dontknow) is
	push a6;
	d0.l:=_dontknow;
	a6:=IntuitionBase; jsr [a6-414];
	pop a6;
endp;															# LOCKIBASE

pattern UnlockIBase(_ibLock) is
	push a6;
	a0:=_ibLock;
	a6:=IntuitionBase; jsr [a6-420];
	pop a6;
endp;															# UNLOCKIBASE

pattern GetScreenData(_buffer,_size,_type,_screen) is
	push a6;
	safe a0:=_buffer; d0.l:=_size; d1.l:=_type; a1:=_screen;;
	a6:=IntuitionBase; jsr [a6-426];
	pop a6;
endp;															# GETSCREENDATA

pattern RefreshGList(_gadgets,_window,_requester,_numGad) is
	push a2\a6;
	safe a0:=_gadgets; a1:=_window; a2:=_requester; d0.l:=_numGad;;
	a6:=IntuitionBase; jsr [a6-432];
	pop a2\a6;
endp;															# REFRESHGLIST

pattern AddGList(_window,_gadget,_position,_numGad,_requester) is
	push a2\a6;
	safe a0:=_window; a1:=_gadget; d0.l:=_position; d1.l:=_numGad; a2:=_requester;;
	a6:=IntuitionBase; jsr [a6-438];
	pop a2\a6;
endp;															# ADDGLIST

pattern RemoveGList(_remPtr,_gadget,_numGad) is
	push a6;
	safe a0:=_remPtr; a1:=_gadget; d0.l:=_numGad;;
	a6:=IntuitionBase; jsr [a6-444];
	pop a6;
endp;															# REMOVEGLIST

pattern ActivateWindow(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-450];
	pop a6;
endp;															# ACTIVATEWINDOW

pattern RefreshWindowFrame(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-456];
	pop a6;
endp;															# REFRESHWINDOWFRAME

pattern ActivateGadget(_gadgets,_window,_requester) is
	push a2\a6;
	safe a0:=_gadgets; a1:=_window; a2:=_requester;;
	a6:=IntuitionBase; jsr [a6-462];
	pop a2\a6;
endp;															# ACTIVATEGADGET

pattern NewModifyProp(_gadget,_window,_requester,_flags,_horizPot,_vertPot,_horizBody,_vertBody,_numGad) is
	push d2\d3\d4\d5\a2\a6;
	safe a0:=_gadget; a1:=_window; a2:=_requester; d0.l:=_flags; d1.l:=_horizPot; d2.l:=_vertPot; d3.l:=_horizBody; d4.l:=_vertBody; d5.l:=_numGad;;
	a6:=IntuitionBase; jsr [a6-468];
	pop d2\d3\d4\d5\a2\a6;
endp;															# NEWMODIFYPROP

pattern QueryOverscan(_displayID,_rect,_oScanType) is
	push a6;
	safe a0:=_displayID; a1:=_rect; d0.l:=_oScanType;;
	a6:=IntuitionBase; jsr [a6-474];
	pop a6;
endp;															# QUERYOVERSCAN

pattern MoveWindowInFrontOf(_window,_behindWindow) is
	push a6;
	safe a0:=_window; a1:=_behindWindow;;
	a6:=IntuitionBase; jsr [a6-480];
	pop a6;
endp;															# MOVEWINDOWINFRONTOF

pattern ChangeWindowBox(_window,_left,_top,_width,_height) is
	push d2\d3\a6;
	safe a0:=_window; d0.l:=_left; d1.l:=_top; d2.l:=_width; d3.l:=_height;;
	a6:=IntuitionBase; jsr [a6-486];
	pop d2\d3\a6;
endp;															# CHANGEWINDOWBOX

pattern SetEditHook(_hook) is
	push a6;
	a0:=_hook;
	a6:=IntuitionBase; jsr [a6-492];
	pop a6;
endp;															# SETEDITHOOK

pattern SetMouseQueue(_window,_queueLength) is
	push a6;
	safe a0:=_window; d0.l:=_queueLength;;
	a6:=IntuitionBase; jsr [a6-498];
	pop a6;
endp;															# SETMOUSEQUEUE

pattern ZipWindow(_window) is
	push a6;
	a0:=_window;
	a6:=IntuitionBase; jsr [a6-504];
	pop a6;
endp;															# ZIPWINDOW

pattern LockPubScreen(_name) is
	push a6;
	a0:=_name;
	a6:=IntuitionBase; jsr [a6-510];
	pop a6;
endp;															# LOCKPUBSCREEN

pattern UnlockPubScreen(_name,_screen) is
	push a6;
	safe a0:=_name; a1:=_screen;;
	a6:=IntuitionBase; jsr [a6-516];
	pop a6;
endp;															# UNLOCKPUBSCREEN

pattern LockPubScreenList is
	push a6;
	a6:=IntuitionBase; jsr [a6-522];
	pop a6;
endp;															# LOCKPUBSCREENLIST

pattern UnlockPubScreenList is
	push a6;
	a6:=IntuitionBase; jsr [a6-528];
	pop a6;
endp;															# UNLOCKPUBSCREENLIST

pattern NextPubScreen(_screen,_namebuf) is
	push a6;
	safe a0:=_screen; a1:=_namebuf;;
	a6:=IntuitionBase; jsr [a6-534];
	pop a6;
endp;															# NEXTPUBSCREEN

pattern SetDefaultPubScreen(_name) is
	push a6;
	a0:=_name;
	a6:=IntuitionBase; jsr [a6-540];
	pop a6;
endp;															# SETDEFAULTPUBSCREEN

pattern SetPubScreenModes(_modes) is
	push a6;
	d0.l:=_modes;
	a6:=IntuitionBase; jsr [a6-546];
	pop a6;
endp;															# SETPUBSCREENMODES

pattern PubScreenStatus(_screen,_statusFlags) is
	push a6;
	safe a0:=_screen; d0.l:=_statusFlags;;
	a6:=IntuitionBase; jsr [a6-552];
	pop a6;
endp;															# PUBSCREENSTATUS

pattern ObtainGIRPort(_gInfo) is
	push a6;
	a0:=_gInfo;
	a6:=IntuitionBase; jsr [a6-558];
	pop a6;
endp;															# OBTAINGIRPORT

pattern ReleaseGIRPort(_rp) is
	push a6;
	a0:=_rp;
	a6:=IntuitionBase; jsr [a6-564];
	pop a6;
endp;															# RELEASEGIRPORT

pattern GadgetMouse(_gadget,_gInfo,_mousePoint) is
	push a2\a6;
	safe a0:=_gadget; a1:=_gInfo; a2:=_mousePoint;;
	a6:=IntuitionBase; jsr [a6-570];
	pop a2\a6;
endp;															# GADGETMOUSE

pattern intuitionPrivate1 is
	push a6;
	a6:=IntuitionBase; jsr [a6-576];
	pop a6;
endp;															# INTUITIONPRIVATE1

pattern GetDefaultPubScreen(_nameBuffer) is
	push a6;
	a0:=_nameBuffer;
	a6:=IntuitionBase; jsr [a6-582];
	pop a6;
endp;															# GETDEFAULTPUBSCREEN

pattern EasyRequestArgs(_window,_easyStruct,_idcmpPtr,_args) is
	push a2\a3\a6;
	safe a0:=_window; a1:=_easyStruct; a2:=_idcmpPtr; a3:=_args;;
	a6:=IntuitionBase; jsr [a6-588];
	pop a2\a3\a6;
endp;															# EASYREQUESTARGS

pattern BuildEasyRequestArgs(_window,_easyStruct,_idcmp,_args) is
	push a3\a6;
	safe a0:=_window; a1:=_easyStruct; d0.l:=_idcmp; a3:=_args;;
	a6:=IntuitionBase; jsr [a6-594];
	pop a3\a6;
endp;															# BUILDEASYREQUESTARGS

pattern SysReqHandler(_window,_idcmpPtr,_waitInput) is
	push a6;
	safe a0:=_window; a1:=_idcmpPtr; d0.l:=_waitInput;;
	a6:=IntuitionBase; jsr [a6-600];
	pop a6;
endp;															# SYSREQHANDLER

pattern OpenWindowTagList(_newWindow,_tagList) is
	push a6;
	safe a0:=_newWindow; a1:=_tagList;;
	a6:=IntuitionBase; jsr [a6-606];
	pop a6;
endp;															# OPENWINDOWTAGLIST

pattern OpenScreenTagList(_newScreen,_tagList) is
	push a6;
	safe a0:=_newScreen; a1:=_tagList;;
	a6:=IntuitionBase; jsr [a6-612];
	pop a6;
endp;															# OPENSCREENTAGLIST

pattern DrawImageState(_rp,_image,_leftOffset,_topOffset,_state,_drawInfo) is
	push d2\a2\a6;
	safe a0:=_rp; a1:=_image; d0.l:=_leftOffset; d1.l:=_topOffset; d2.l:=_state; a2:=_drawInfo;;
	a6:=IntuitionBase; jsr [a6-618];
	pop d2\a2\a6;
endp;															# DRAWIMAGESTATE

pattern PointInImage(_point,_image) is
	push a6;
	safe d0.l:=_point; a0:=_image;;
	a6:=IntuitionBase; jsr [a6-624];
	pop a6;
endp;															# POINTINIMAGE

pattern EraseImage(_rp,_image,_leftOffset,_topOffset) is
	push a6;
	safe a0:=_rp; a1:=_image; d0.l:=_leftOffset; d1.l:=_topOffset;;
	a6:=IntuitionBase; jsr [a6-630];
	pop a6;
endp;															# ERASEIMAGE

pattern NewObjectA(_classPtr,_classID,_tagList) is
	push a2\a6;
	safe a0:=_classPtr; a1:=_classID; a2:=_tagList;;
	a6:=IntuitionBase; jsr [a6-636];
	pop a2\a6;
endp;															# NEWOBJECTA

pattern DisposeObject(_object) is
	push a6;
	a0:=_object;
	a6:=IntuitionBase; jsr [a6-642];
	pop a6;
endp;															# DISPOSEOBJECT

pattern SetAttrsA(_object,_tagList) is
	push a6;
	safe a0:=_object; a1:=_tagList;;
	a6:=IntuitionBase; jsr [a6-648];
	pop a6;
endp;															# SETATTRSA

pattern GetAttr(_attrID,_object,_storagePtr) is
	push a6;
	safe d0.l:=_attrID; a0:=_object; a1:=_storagePtr;;
	a6:=IntuitionBase; jsr [a6-654];
	pop a6;
endp;															# GETATTR

pattern SetGadgetAttrsA(_gadget,_window,_requester,_tagList) is
	push a2\a3\a6;
	safe a0:=_gadget; a1:=_window; a2:=_requester; a3:=_tagList;;
	a6:=IntuitionBase; jsr [a6-660];
	pop a2\a3\a6;
endp;															# SETGADGETATTRSA

pattern NextObject(_objectPtrPtr) is
	push a6;
	a0:=_objectPtrPtr;
	a6:=IntuitionBase; jsr [a6-666];
	pop a6;
endp;															# NEXTOBJECT

pattern intuitionPrivate2 is
	push a6;
	a6:=IntuitionBase; jsr [a6-672];
	pop a6;
endp;															# INTUITIONPRIVATE2

pattern MakeClass(_classID,_superClassID,_superClassPtr,_instanceSize,_flags) is
	push a2\a6;
	safe a0:=_classID; a1:=_superClassID; a2:=_superClassPtr; d0.l:=_instanceSize; d1.l:=_flags;;
	a6:=IntuitionBase; jsr [a6-678];
	pop a2\a6;
endp;															# MAKECLASS

pattern AddClass(_classPtr) is
	push a6;
	a0:=_classPtr;
	a6:=IntuitionBase; jsr [a6-684];
	pop a6;
endp;															# ADDCLASS

pattern GetScreenDrawInfo(_screen) is
	push a6;
	a0:=_screen;
	a6:=IntuitionBase; jsr [a6-690];
	pop a6;
endp;															# GETSCREENDRAWINFO

pattern FreeScreenDrawInfo(_screen,_drawInfo) is
	push a6;
	safe a0:=_screen; a1:=_drawInfo;;
	a6:=IntuitionBase; jsr [a6-696];
	pop a6;
endp;															# FREESCREENDRAWINFO

pattern ResetMenuStrip(_window,_menu) is
	push a6;
	safe a0:=_window; a1:=_menu;;
	a6:=IntuitionBase; jsr [a6-702];
	pop a6;
endp;															# RESETMENUSTRIP

pattern RemoveClass(_classPtr) is
	push a6;
	a0:=_classPtr;
	a6:=IntuitionBase; jsr [a6-708];
	pop a6;
endp;															# REMOVECLASS

pattern FreeClass(_classPtr) is
	push a6;
	a0:=_classPtr;
	a6:=IntuitionBase; jsr [a6-714];
	pop a6;
endp;															# FREECLASS

pattern intuitionPrivate3 is
	push a6;
	a6:=IntuitionBase; jsr [a6-720];
	pop a6;
endp;															# INTUITIONPRIVATE3

pattern intuitionPrivate4 is
	push a6;
	a6:=IntuitionBase; jsr [a6-726];
	pop a6;
endp;															# INTUITIONPRIVATE4

pattern AllocScreenBuffer(_sc,_bm,_flags) is
	push a6;
	safe a0:=_sc; a1:=_bm; d0.l:=_flags;;
	a6:=IntuitionBase; jsr [a6-768];
	pop a6;
endp;															# ALLOCSCREENBUFFER

pattern FreeScreenBuffer(_sc,_sb) is
	push a6;
	safe a0:=_sc; a1:=_sb;;
	a6:=IntuitionBase; jsr [a6-774];
	pop a6;
endp;															# FREESCREENBUFFER

pattern ChangeScreenBuffer(_sc,_sb) is
	push a6;
	safe a0:=_sc; a1:=_sb;;
	a6:=IntuitionBase; jsr [a6-780];
	pop a6;
endp;															# CHANGESCREENBUFFER

pattern ScreenDepth(_screen,_flags,_reserved) is
	push a6;
	safe a0:=_screen; d0.l:=_flags; a1:=_reserved;;
	a6:=IntuitionBase; jsr [a6-786];
	pop a6;
endp;															# SCREENDEPTH

pattern ScreenPosition(_screen,_flags,_x1,_y1,_x2,_y2) is
	push d2\d3\d4\a6;
	safe a0:=_screen; d0.l:=_flags; d1.l:=_x1; d2.l:=_y1; d3.l:=_x2; d4.l:=_y2;;
	a6:=IntuitionBase; jsr [a6-792];
	pop d2\d3\d4\a6;
endp;															# SCREENPOSITION

pattern ScrollWindowRaster(_win,_dx,_dy,_xMin,_yMin,_xMax,_yMax) is
	push d2\d3\d4\d5\a6;
	safe a1:=_win; d0.l:=_dx; d1.l:=_dy; d2.l:=_xMin; d3.l:=_yMin; d4.l:=_xMax; d5.l:=_yMax;;
	a6:=IntuitionBase; jsr [a6-798];
	pop d2\d3\d4\d5\a6;
endp;															# SCROLLWINDOWRASTER

pattern LendMenus(_fromwindow,_towindow) is
	push a6;
	safe a0:=_fromwindow; a1:=_towindow;;
	a6:=IntuitionBase; jsr [a6-804];
	pop a6;
endp;															# LENDMENUS

pattern DoGadgetMethodA(_gad,_win,_req,_message) is
	push a2\a3\a6;
	safe a0:=_gad; a1:=_win; a2:=_req; a3:=_message;;
	a6:=IntuitionBase; jsr [a6-810];
	pop a2\a3\a6;
endp;															# DOGADGETMETHODA

pattern SetWindowPointerA(_win,_taglist) is
	push a6;
	safe a0:=_win; a1:=_taglist;;
	a6:=IntuitionBase; jsr [a6-816];
	pop a6;
endp;															# SETWINDOWPOINTERA

pattern TimedDisplayAlert(_alertNumber,_string,_height,_time) is
	push a6;
	safe d0.l:=_alertNumber; a0:=_string; d1.l:=_height; a1:=_time;;
	a6:=IntuitionBase; jsr [a6-822];
	pop a6;
endp;															# TIMEDDISPLAYALERT

pattern HelpControl(_win,_flags) is
	push a6;
	safe a0:=_win; d0.l:=_flags;;
	a6:=IntuitionBase; jsr [a6-828];
	pop a6;
endp;															# HELPCONTROL

