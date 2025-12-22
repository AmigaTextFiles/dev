/* cApp.e 27-08-2011
*/

OPT NATIVE
PUBLIC MODULE 'targetShared/cAppBase'
MODULE 'intuition/screens', 'std/pShell'

/*****************************/

CLASS cAppHost OF cApp PRIVATE
	screen:PTR TO screen
ENDCLASS

->PROTECTED

PROC new() OF cAppHost
	SUPER self.new()
	self.screen := NIL
ENDPROC

PROC reset() OF cAppHost
	SUPER self.reset()
	self.screen := NIL
ENDPROC

PROC initTitle(info:ARRAY OF CHAR) OF cAppHost IS SUPER self.initTitle(info)

PUBLIC

PROC setScreen(scr:PTR TO screen) OF cAppHost
	IF self.screen THEN Throw("EMU", 'cAppHost.setScreen(); the screen has already been set')
	self.screen := scr
ENDPROC

PROC getScreen() OF cAppHost RETURNS scr:PTR TO screen IS self.screen

/*****************************/

DEF appHost=NIL:OWNS PTR TO cAppHost

PROC new()
	NEW appHost.new()
ENDPROC

PROC end()
	END appHost
ENDPROC


PROC CreateApp(title=NILA:ARRAY OF CHAR) RETURNS app:PTR TO cApp REPLACEMENT
	appHost.initTitle(IF title THEN title ELSE ProgramName())
	app := appHost
ENDPROC

PROC DestroyApp() REPLACEMENT
	IF appHost = NIL THEN RETURN
	appHost.reset()
	
	/*->this doesn't work since clients can't automatically re-register
	END appHost
	NEW appHost.new()
	*/
ENDPROC

PROC MinimiseApp(undo=FALSE:BOOL) REPLACEMENT
	IF appHost = NIL THEN Throw("EMU", 'cApp; MinimiseApp(); app has not been created yet')
	appHost.minimise(undo)
ENDPROC


/*****************************/ ->------------------------------------------------


/*
PUBLIC MODULE 'CSH/cApp'

PRIVATE
DEF client:OWNS PTR TO cAppHostClientExample
PUBLIC
	
PROC new()
	NEW client.new()
	appHost.registerClient(client)
ENDPROC

PROC end()
	END client
ENDPROC

/*****************************/

PRIVATE

CLASS cAppHostClientExample OF cAppClient
ENDCLASS

PUBLIC

PROC new() OF cAppHostClientExample
ENDPROC

PROC reset() OF cAppHostClientExample
ENDPROC

PROC finishBuilding(app:PTR TO cApp) OF cAppHostClientExample
	DEF appHost:PTR TO cAppHost, screen:PTR TO screen
	
	appHost := app::cAppHost
	IF appHost.getScreen() THEN RETURN
	
	screen := NIL		->create screen based upon information stored in app by user
	IF screen THEN appHost.setScreen(screen)	->store the screen to use
ENDPROC

PROC appIsBuilt(app:PTR TO cApp) OF cAppHostClientExample
	DEF appHost:PTR TO cAppHost, screen:PTR TO screen
	
	appHost := app::cAppHost
	screen := appHost.getScreen()	->find the screen (if any) to use, as specified by one of the clients
ENDPROC
*/
