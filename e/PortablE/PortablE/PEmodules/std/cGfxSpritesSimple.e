/* cGfxSpritesSimple.e
*/

OPT NATIVE, INLINE
PUBLIC MODULE 'std/cGfxSprites', 'std/cGfxSimple'

/*****************************/

DEF gfxStack:PTR TO cGfxStack, gfxLayer:PTR TO cGfxLayer

PROC new()
	gfxStack := CreateGfxStack(gfx)
	gfxLayer := gfxStack.infoTopLayer()
ENDPROC

PROC end()
	gfxStack := DestroyGfxStack(gfxStack)
	gfxLayer := NIL
ENDPROC

/*****************************/

PRIVATE
DEF lastSprite=NIL:PTR TO cGfxSprite
PUBLIC

PROC LastSprite() RETURNS sprite:PTR TO cGfxSprite
	sprite := lastSprite
	IF sprite = NIL THEN Throw("ERR", 'cGfxSpritesSimple; LastSprite(); there was no last sprite!')
ENDPROC 

/*****************************/	->cGfxStack

PROC DestroySprite(sprite:PTR TO cGfxSprite) RETURNS nil:PTR TO cGfxSprite
	IF sprite = NIL THEN RETURN NIL
	IF sprite = lastSprite THEN lastSprite := NIL
	nil := gfxStack.destroySprite(sprite)
ENDPROC

PROC FindSpriteAt(x, y, lastMatch=NIL:PTR TO cGfxSprite) RETURNS match:PTR TO cGfxSprite IS lastSprite := gfxStack.findSpriteAt(x, y, lastMatch)

PROC FindSpriteOverlapping(sprite:PTR TO cGfxSprite, lastMatch=NIL:PTR TO cGfxSprite) RETURNS match:PTR TO cGfxSprite IS lastSprite := gfxStack.findSpriteOverlapping(sprite, lastMatch)

PROC StoreSprite(name:ARRAY OF CHAR, number, sprite:PTR TO cGfxSprite) RETURNS storedSprite:PTR TO cGfxSprite IS lastSprite := gfxStack.storeSprite(name, number, sprite)

PROC UseSprite(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS sprite:PTR TO cGfxSprite
	sprite := gfxStack.useSprite(name, number, allowReturnNIL)
	IF sprite <> NIL THEN lastSprite := sprite
ENDPROC

PROC SetBackgroundColour(rgb) IS gfxStack.setBackgroundColour(rgb)

PROC SetBackgroundDrawable(drawable=NIL:PTR TO cGfxDrawable, x=0, y=0, noWrapX=FALSE:BOOL, noWrapY=FALSE:BOOL, noScrollX=FALSE:BOOL, noScrollY=FALSE:BOOL) IS gfxStack.setBackgroundDrawable(drawable, x, y, noWrapX, noWrapY, noScrollX, noScrollY)

PROC ScrollAllSprites(dx, dy) IS gfxStack.scrollAllSprites(dx, dy)

PROC ScrollAllLayers(dx, dy) IS gfxStack.scrollAllLayers(dx, dy)

->PROC SetAutoRedrawSprites(autoRedraw:BOOL) IS gfxStack.setAutoRedraw(autoRedraw)

->PROC RedrawSprites(forceFull=FALSE:BOOL) IS gfxStack.redraw(forceFull=FALSE:BOOL)
PROC FullyRedrawSprites() IS gfxStack.redraw(TRUE)

/*****************************/	->cGfxLayer

PROC ScrollSprites(dx, dy) IS gfxLayer.scrollSprites(dx, dy)

PROC ScrollLayer(dx, dy) IS gfxLayer.scrollLayer(dx, dy)

PROC SetOrigin(x, y) IS gfxLayer.setOrigin(x, y)

PROC GetOrigin() RETURNS x, y IS gfxLayer.getOrigin()

PROC CreateSprite(x, y, drawable:PTR TO cGfxDrawable, hidden=FALSE:BOOL) RETURNS sprite:PTR TO cGfxSprite IS lastSprite := gfxLayer.createSprite(x, y, drawable, hidden)

/*****************************/	->cGfxWindow patches

PROC SetAutoUpdate(autoUpdate:BOOL) REPLACEMENT
	gfxStack.setAutoRedraw(autoUpdate)
	SUPER SetAutoUpdate(autoUpdate)
ENDPROC

PROC UpdateAndWaitForScreenRefresh() RETURNS skippingNextFrame:BOOL REPLACEMENT
	IF gfxStack.getAutoRedraw() = FALSE THEN gfxStack.redraw()
	skippingNextFrame := SUPER UpdateAndWaitForScreenRefresh()
ENDPROC

PROC DestroyGfxWindow(win:PTR TO cGfxWindow) RETURNS nil:PTR TO cGfxWindow REPLACEMENT
	gfxStack := DestroyGfxStack(gfxStack)
	nil := SUPER DestroyGfxWindow(win)
	gfx := nil
ENDPROC

PROC CreateGfxWindow(title:ARRAY OF CHAR, hideMousePointer=FALSE:BOOL, enableAlphaChannel=FALSE:BOOL) RETURNS win:PTR TO cGfxWindow REPLACEMENT
	win := SUPER CreateGfxWindow(title, hideMousePointer, enableAlphaChannel)
	gfx := win
	gfxStack := CreateGfxStack(gfx)
	gfxLayer := gfxStack.infoTopLayer()
ENDPROC

/*****************************/	->cGfxSimple patches

PROC ChangeGfxWindow(title=NILA:ARRAY OF CHAR, hideMousePointer=FALSE:BOOL, enableAlphaChannel=FALSE:BOOL) REPLACEMENT
	SUPER ChangeGfxWindow(title, hideMousePointer, enableAlphaChannel)
	gfxStack := CreateGfxStack(gfx)
	gfxLayer := gfxStack.infoTopLayer()
ENDPROC
