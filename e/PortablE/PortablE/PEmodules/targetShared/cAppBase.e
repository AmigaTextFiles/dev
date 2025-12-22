/* cAppBase.e 27-08-2011
*/

/* Public procedures:
CreateApp(title=NILA:ARRAY OF CHAR) RETURNS app:PTR TO cApp
DestroyApp()
MinimiseApp(undo=FALSE:BOOL)
*/
/* Public methods of *cApp* class:
initVersion(    info:ARRAY OF CHAR) RETURNS self:PTR TO cApp
initCopyright(  info:ARRAY OF CHAR) RETURNS self:PTR TO cApp
initAuthor(     info:ARRAY OF CHAR) RETURNS self:PTR TO cApp
initDescription(info:ARRAY OF CHAR) RETURNS self:PTR TO cApp
initFullWindow()                    RETURNS self:PTR TO cApp
initFullScreen(width, height)       RETURNS self:PTR TO cApp
build()

infoTitle()       RETURNS info:ARRAY OF CHAR
infoVersion()     RETURNS info:ARRAY OF CHAR
infoCopyright()   RETURNS info:ARRAY OF CHAR
infoAuthor()      RETURNS info:ARRAY OF CHAR
infoDescription() RETURNS info:ARRAY OF CHAR
infoFullWindow()  RETURNS fullWindow:BOOL
infoFullScreen()  RETURNS fullScreen:BOOL, width, height

minimise(undo=FALSE:BOOL)
*/

OPT NATIVE

/*****************************/

CLASS cApp ABSTRACT PRIVATE
	head:PTR TO cAppClient
	tail:PTR TO cAppClient
	
	title      :ARRAY OF CHAR
	version    :ARRAY OF CHAR
	copyright  :ARRAY OF CHAR
	author     :ARRAY OF CHAR
	description:ARRAY OF CHAR
	
	fullWindow:BOOL		->automatically uses desktop's size, but with standard window borders
	fullScreen:BOOL
	screenWidth
	screenHeight
	
	built:BOOL
ENDCLASS

->PROTECTED

PROC new() OF cApp
	self.head := NIL
	
	self.title := NILA
	self.version := NILA
	self.copyright := NILA
	self.author := NILA
	self.description := NILA
	
	self.fullWindow := FALSE
	self.fullScreen := FALSE
	
	self.built := FALSE
ENDPROC

PROC reset() OF cApp
	DEF client:PTR TO cAppClient
	
	->reset everything except client list
	self.title := NILA
	self.version := NILA
	self.copyright := NILA
	self.author := NILA
	self.description := NILA
	
	self.fullWindow := FALSE
	self.fullScreen := FALSE
	
	self.built := FALSE
	
	->reset all clients
	client := self.head
	WHILE client
		client.reset()
		
		client := client.next
	ENDWHILE
ENDPROC

PROC registerClient(client:PTR TO cAppClient) OF cApp
	IF client = NIL THEN Throw("EMU", 'cApp.registerClient(); client=NIL')
	
	IF self.head = NIL
		self.head := client
		self.tail := client
	ELSE
		self.tail.next := client
		self.tail      := client
	ENDIF
ENDPROC

PROC initTitle(info:ARRAY OF CHAR) OF cApp
	self.title := info
ENDPROC self

PUBLIC

PROC initVersion(info:ARRAY OF CHAR) OF cApp
	self.version := info
ENDPROC self

PROC initCopyright(info:ARRAY OF CHAR) OF cApp
	self.copyright := info
ENDPROC self

PROC initAuthor(info:ARRAY OF CHAR) OF cApp
	self.author := info
ENDPROC self

PROC initDescription(info:ARRAY OF CHAR) OF cApp
	self.description := info
ENDPROC self

PROC initFullWindow() OF cApp
	IF self.fullScreen THEN Throw("EMU", 'cApp.initFullWindow(); already used initFullScreen()')
	self.fullWindow := TRUE
ENDPROC self

PROC initFullScreen(width, height) OF cApp
	IF self.fullWindow THEN Throw("EMU", 'cApp.initFullScreen(); already used initFullWindow()')
	self.fullScreen := TRUE
	self.screenWidth  := width
	self.screenHeight := height
ENDPROC self

PROC build() OF cApp
	DEF client:PTR TO cAppClient
	
	IF self.built THEN Throw("EMU", 'cApp.build(); already used build()')
	IF self.title = NILA THEN Throw("EMU", 'cApp.build(); initTitle() was not used')
	
	client := self.head
	WHILE client
		client.finishBuilding(self)
		
		client := client.next
	ENDWHILE
	
	client := self.head
	WHILE client
		client.appIsBuilt(self)
		
		client := client.next
	ENDWHILE
	
	self.built := TRUE
ENDPROC

PROC minimise(undo=FALSE:BOOL) OF cApp
	DEF client:PTR TO cAppClient
	
	IF self.built = FALSE THEN Throw("EMU", 'cApp.minimise(); app has not been built yet')
	
	client := self.head
	WHILE client
		client.minimise(self, undo)
		
		client := client.next
	ENDWHILE
ENDPROC

PROC infoTitle() OF cApp RETURNS info:ARRAY OF CHAR IS self.title

PROC infoVersion() OF cApp RETURNS info:ARRAY OF CHAR IS self.version

PROC infoCopyright() OF cApp RETURNS info:ARRAY OF CHAR IS self.copyright

PROC infoAuthor() OF cApp RETURNS info:ARRAY OF CHAR IS self.author

PROC infoDescription() OF cApp RETURNS info:ARRAY OF CHAR IS self.description

PROC infoFullWindow() OF cApp RETURNS fullWindow:BOOL IS self.fullWindow

PROC infoFullScreen() OF cApp RETURNS fullScreen:BOOL, width, height IS self.fullScreen, self.screenWidth, self.screenHeight

/*****************************/

CLASS cAppClient ABSTRACT PRIVATE
	next:PTR TO cAppClient
	
	head:OWNS PTR TO cAppResource	->straight list, NIL terminated
	tail:     PTR TO cAppResource
ENDCLASS

PROC finishBuilding(app:PTR TO cApp) OF cAppClient IS EMPTY

PROC appIsBuilt(app:PTR TO cApp) OF cAppClient IS EMPTY

PROC reset() OF cAppClient IS EMPTY

PROC minimise(app:PTR TO cApp, undo=FALSE:BOOL) OF cAppClient IS EMPTY


PROC end() OF cAppClient
	DEF node:OWNS PTR TO cAppResource, next:OWNS PTR TO cAppResource
	
	next := PASS self.head
	WHILE next
		node := PASS next
		next := PASS node.next
		
		END node
	ENDWHILE
	
	SUPER self.end()
ENDPROC

PROC add(res:OWNS PTR TO cAppResource) OF cAppClient
	IF res = NIL THEN Throw("EMU", 'cAppClient.add(); res=NIL')
	
	res.client := self
	
	IF self.head = NIL
		self.head := PASS res
		self.tail := self.head
	ELSE
		res.prev := self.tail
		self.tail.next := PASS res
		self.tail := self.tail.next
	ENDIF
ENDPROC

PROC rem(res:PTR TO cAppResource) OF cAppClient RETURNS ownedRes:OWNS PTR TO cAppResource
	IF self.head = self.tail
		IF self.head <> res THEN Throw("BUG", 'cAppClient.rem(); resource is not in the list')
		
		ownedRes := PASS self.head
		self.tail := NIL
		
	ELSE IF res = self.head
		ownedRes := PASS self.head
		self.head := PASS ownedRes.next
		self.head.prev := NIL
	ELSE
		IF res = self.tail THEN self.tail := res.prev
		
		ownedRes := PASS res.prev.next
		IF res.next THEN res.next.prev := res.prev
		res.prev.next := PASS res.next
	ENDIF
ENDPROC

PROC infoFirstResource() OF cAppClient RETURNS first:PTR TO cAppResource IS self.head

/*****************************/

CLASS cAppResource ABSTRACT
	next  :OWNS PTR TO cAppResource
	prev  :     PTR TO cAppResource
	client:     PTR TO cAppClient
ENDCLASS

/*
PROC end() OF cAppResource
	->  self.next
	->  self.prev
	->  self.client
	SUPER self.end()
ENDPROC
*/

/*****************************/

PROC CreateApp(title=NILA:ARRAY OF CHAR) RETURNS app:PTR TO cApp PROTOTYPE IS EMPTY

PROC DestroyApp() PROTOTYPE IS EMPTY

PROC MinimiseApp(undo=FALSE:BOOL) PROTOTYPE IS EMPTY

/*****************************/
