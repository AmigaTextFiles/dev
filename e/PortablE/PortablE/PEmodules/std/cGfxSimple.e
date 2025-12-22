/* cGfxSimple.e
*/

OPT NATIVE, INLINE
PUBLIC MODULE 'std/cGfx', 'std/cAppSimple'

/*****************************/

->TYPE BRIGHTNESS IS RANGE 0 TO 255

DEF gfx:OWNS PTR TO cGfxWindow

PROC new()
	gfx := CreateGfxWindow(NILA)
ENDPROC

PROC end()
	gfx := DestroyGfxWindow(gfx)
ENDPROC

/*****************************/

CONST RGB_WHITE =$FFFFFF, RGB_BLACK=$000000,  RGB_GRAY=$808080, RGB_GREY=RGB_GRAY, RGB_SILVER=$C0C0C0, 
      RGB_RED   =$FF0000, RGB_GREEN=$00FF00,  RGB_BLUE=$0000FF, 
      RGB_YELLOW=$FFFF00, RGB_MAGENTA=$FF00FF,RGB_CYAN=$00FFFF, 
      RGB_ORANGE=$FF8000, RGB_PURPLE=$800080, RGB_PINK=$FFCBDB, RGB_BROWN=$964B00

PRIVATE
DEF lastBitmap=NIL:PTR TO cGfxBitmap
PUBLIC

PROC LastBitmap() RETURNS bitmap:PTR TO cGfxBitmap
	bitmap := lastBitmap
	IF bitmap = NIL THEN Throw("ERR", 'cGfxBitmapsSimple; LastBitmap(); there was no last bitmap!')
ENDPROC 

PROC ChangeGfxWindow(title=NILA:ARRAY OF CHAR, hideMousePointer=FALSE:BOOL, enableAlphaChannel=FALSE:BOOL)
	IF gfx.infoIsOpen() THEN Throw("ERR", 'cGfxBitmapsSimple; ChangeGfxWindow(); cannot change the window while it is open')
	gfx := DestroyGfxWindow(gfx)
	gfx := CreateGfxWindow(title, hideMousePointer, enableAlphaChannel)
ENDPROC

/*****************************/	->cGfxWindow

PROC InfoScreenWidth() RETURNS width IS gfx.infoScreenWidth()

PROC InfoScreenHeight() RETURNS height IS gfx.infoScreenHeight()

PROC ChangeSize(width, height) IS gfx.changeSize(width, height)

PROC OpenWindow(width, height, resizable=FALSE:BOOL) IS gfx.openWindow(width, height, resizable)

PROC OpenFull() IS gfx.openFull()

PROC CloseWindow() IS gfx.close()

PROC CloseFull() IS gfx.close()

PROC GetPosition() RETURNS x, y IS gfx.getPosition()

PROC SetPosition(x, y) IS gfx.setPosition(x, y)

PROC InfoWidth() RETURNS width IS gfx.infoWidth()

PROC InfoHeight() RETURNS height IS gfx.infoHeight()

PROC SetFrameSkipping(frameSkipping:BOOL) IS gfx.setFrameSkipping(frameSkipping)

PROC SetAutoUpdate(autoUpdate:BOOL) IS gfx.setAutoUpdate(autoUpdate)

PROC UpdateAndWaitForScreenRefresh() RETURNS skippingNextFrame:BOOL IS gfx.updateAndWaitForScreenRefresh()

PROC WaitForScreenRefresh() IS gfx.waitForScreenRefresh() BUT EMPTY

PROC Clear(rgb) IS gfx.clear(rgb)

PROC SetColour(rgb) IS gfx.setColour(rgb)

PROC GetColour() RETURNS rgb IS gfx.getColour()

PROC SetColor(rgb) IS gfx.setColor(rgb)

PROC GetColor() RETURNS rgb IS gfx.getColor()

PROC ReadDot(x, y) RETURNS rgb IS gfx.readDot(x, y)

PROC DrawDot(x, y) IS gfx.drawDot(x, y)

PROC DrawLine(x1, y1, x2, y2, thickness=1) IS gfx.drawLine(x1, y1, x2, y2, thickness)

PROC DrawBox(x, y, width, height, unfilled=FALSE:BOOL) IS gfx.drawBox(x, y, width, height, unfilled)

PROC DrawCircle(x, y, radius, unfilled=FALSE:BOOL) IS gfx.drawCircle(x, y, radius, unfilled)

PROC SetFont(name:ARRAY OF CHAR, size, style0plain1underlined2bold4italic=0) RETURNS success:BOOL IS gfx.setFont(name, size, style0plain1underlined2bold4italic)

PROC GetFont() RETURNS name:ARRAY OF CHAR, size, style IS gfx.getFont()

PROC DrawText(x, y, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) IS gfx.drawText(x, y, fmtString, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

PROC DrawTextL(x, y, fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1) IS gfx.drawTextL(x, y, fmtString, args, backgroundColour)

PROC InfoSizeOfTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) RETURNS width, height IS gfx.infoSizeOfTextL(fmtString, args)

PROC ScrollBox(dx, dy, x, y, width, height) IS gfx.scrollBox(dx, dy, x, y, width, height)

PROC GetLastEvent() RETURNS type, subType, value, value2 IS gfx.getLastEvent()

->startTimer(periodInMicroSeconds)

->stopTimer()

PROC InfoScreenFPS() RETURNS fps IS gfx.infoScreenFPS()

PROC StoreBitmap(name:ARRAY OF CHAR, number, bitmap:PTR TO cGfxBitmap) RETURNS storedBitmap:PTR TO cGfxBitmap IS lastBitmap := gfx.storeBitmap(name, number, bitmap)

PROC UseBitmap(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS bitmap:PTR TO cGfxBitmap
	bitmap := gfx.useBitmap(name, number, allowReturnNIL)
	IF bitmap <> NIL THEN lastBitmap := bitmap
ENDPROC

PROC DestroyBitmap(bitmap:PTR TO cGfxBitmap) RETURNS nil:PTR TO cGfxBitmap
	IF bitmap = lastBitmap THEN lastBitmap := NIL
	gfx.destroyDrawable(bitmap)
ENDPROC

PROC LoadPicture(file:ARRAY OF CHAR, maskFile=NILA:ARRAY OF CHAR, maskColour=-1 /*, notDrawable=FALSE:BOOL*/) RETURNS pic:OWNS PTR TO cGfxBitmap
	pic := gfx.loadPicture(file, maskFile, maskColour /*, notDrawable*/)
	
	IF pic = NIL
		Print('ERROR: Failed to load the picture "\s".\n', file)
		Throw("ERR", 'Failed to load picture')
	ENDIF
	
	lastBitmap := pic
ENDPROC

PROC ExtractBitmap(x, y, width, height, notDrawable=FALSE:BOOL) RETURNS copy:OWNS PTR TO cGfxBitmap IS gfx.extractBitmap(x, y, width, height, notDrawable)

PROC MakeFractalBitmap(size, pen255colour, pen0colour, roughness=0, maskBelowPen=0, seed=0) RETURNS fractal:OWNS PTR TO cGfxBitmap IS lastBitmap := gfx.makeFractalBitmap(size, pen255colour, pen0colour, roughness, maskBelowPen, seed)
