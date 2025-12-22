/* cGfxBase.e
	An abstract set of classes which provide an easy interface for graphics.


Copyright (c) 2009,2010,2011,2012,2013,2014 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* Public procedures:
 CreateGfxWindow(title:ARRAY OF CHAR, hideMousePointer=FALSE:BOOL, enableAlphaChannel=FALSE:BOOL) RETURNS win:PTR TO cGfxWindow
DestroyGfxWindow(win:PTR TO cGfxWindow) RETURNS nil:PTR TO cGfxWindow
MakeRGB(red, green, blue) RETURNS rgb
Pause(delayInTenthsOfSecond)
 WaitForGfxWindowEvent() RETURNS win:PTR TO cGfxWindow, type, subType, value, value2
CheckForGfxWindowEvent(keepPreviousEvents=FALSE:BOOL) RETURNS win:PTR TO cGfxWindow, type, subType, value, value2
*/
/* Public methods of *cGfxWindow* class:
infoScreenWidth() RETURNS width
infoScreenHeight() RETURNS height
openWindow(width, height, resizable=FALSE:BOOL)
openFull()
close()
infoIsOpen() RETURNS isOpen:BOOL
infoTitle()  RETURNS title:ARRAY OF CHAR
infoAlphaChannel() RETURNS alphaChannelEnabled:BOOL
getPosition() RETURNS x, y
setPosition(x, y)
infoWidth()  RETURNS width
infoHeight() RETURNS height
changeSize(width, height)
getFrameSkipping() RETURNS frameSkipping:BOOL
setFrameSkipping(frameSkipping:BOOL)
getAutoUpdate() RETURNS autoUpdate:BOOL
setAutoUpdate(autoUpdate:BOOL)
updateAndWaitForScreenRefresh() RETURNS skippingNextFrame:BOOL
infoSkippingNextFrame() RETURNS skippingNextFrame:BOOL
waitForScreenRefresh()
clear(rgb)
setColour(rgb)
getColour() RETURNS rgb
setColor(rgb)
getColor()
readDot(x, y) RETURNS rgb
drawDot(x, y)
drawLine(x1, y1, x2, y2, thickness=1)
drawBox(x, y, width, height, unfilled=FALSE:BOOL)
drawCircle(x, y, radius,     unfilled=FALSE:BOOL)
setFont(name:ARRAY OF CHAR, size, style0plain1underlined2bold4italic=0) RETURNS success:BOOL
getFont() RETURNS name:ARRAY OF CHAR, size, style
drawText(x, y, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0)
drawTextL(x, y, fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1)
setDrawableRegion(x=0, y=0, width=-1, height=-1)
getDrawableRegion() RETURNS x, y, width, height
scrollBox(dx, dy, x, y, width, height)
setLastEvent(type, subType, value=0, value2=0)
getLastEvent() RETURNS type, subType, value, value2
startTimer(periodInMilliSeconds)
stopTimer()
infoPeriodOfTimer() RETURNS periodInMilliSeconds
infoScreenFPS() RETURNS fps
storeBitmap(name:ARRAY OF CHAR, number, bitmap:PTR TO cGfxBitmap) RETURNS storedBitmap:PTR TO cGfxBitmap
useBitmap(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) RETURNS bitmap:PTR TO cGfxBitmap
destroyDrawable(drawable:PTR TO cGfxDrawable) RETURNS nil:PTR TO cGfxDrawable
makeText(fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) RETURNS text:PTR TO cGfxDrawable
makeTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1) RETURNS text:PTR TO cGfxDrawable
makeBitmapTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1, notDrawable=FALSE:BOOL) RETURNS text:PTR TO cGfxBitmap
infoSizeOfTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) RETURNS width, height
loadPicture(file:ARRAY OF CHAR, maskFile=NILA:ARRAY OF CHAR, maskColour=-1, notDrawable=FALSE:BOOL) RETURNS pic:PTR TO cGfxBitmap
extract(x, y, width, height, notDrawable=FALSE:BOOL) RETURNS copy:PTR TO cGfxBitmap
makeFractalBitmap(size, pen255colour, pen0colour, roughness=0, maskBelowPen=0, seed=0) RETURNS fractal:PTR TO cGfxBitmap
queryExtra(specific:QUAD) RETURNS value, unknown:BOOL
registerForResizes(  client:PTR TO cGfxNotifyOfWindowResize)
unregisterForResizes(client:PTR TO cGfxNotifyOfWindowResize)
*/
/* Public methods of *cGfxDrawable* class:
infoWidth()  RETURNS width
infoHeight() RETURNS height
infoWindow() RETURNS win:PTR TO cGfxWindow
infoIsTransparent() RETURNS isTransparent:BOOL
draw(x, y)
drawTiled(x, y, tileX:BOOL, tileY:BOOL)
hitCheck(insideX, insideY) RETURNS hit:BOOL
overlaps(drawable:PTR TO cGfxDrawable, insideX, insideY) RETURNS overlaps:BOOL
changeUseCount(increaseBy)
infoUseCount() RETURNS useCount
changeVisibleCount(increaseBy)
infoVisibleCount() RETURNS visibleCount
registerForChanges(  client:PTR TO cGfxNotifyOfDrawableChanges)
unregisterForChanges(client:PTR TO cGfxNotifyOfDrawableChanges)
*/
/* Public methods of *cGfxBitmap* class:
(inherits cGfxDrawable)
clone(changeIsDrawable=FALSE:BOOL, isDrawable=FALSE:BOOL) RETURNS clone:PTR TO cGfxBitmap
extract(x, y, width, height, changeIsDrawable=FALSE:BOOL, isDrawable=FALSE:BOOL) RETURNS copy:PTR TO cGfxBitmap
setIsDrawable(isDrawable:BOOL)
getIsDrawable() RETURNS isDrawable:BOOL
flip(horizontally:BOOL, vertically:BOOL)
rotate(degrees)
scaleTo(newWidth, newHeight)
scaleBy(multiplier, divider)
makeScaledTo(newWidth, newHeight) RETURNS scaledBitmap:PTR TO cGfxBitmap
makeScaledBy(multiplier, divider) RETURNS scaledBitmap:PTR TO cGfxBitmap
savePicture(file:ARRAY OF CHAR, ignoreMask=FALSE:BOOL) RETURNS success:BOOL
*/

OPT PREPROCESS
MODULE 'targetShared/cAppBase', 'CSH/cStaticStringNumberPairSpace'

/*****************************/

CLASS cGfxNotifyOfWindowResize PRIVATE
	node:OWNS PTR TO windowNotifyNode
ENDCLASS

PROC end() OF cGfxNotifyOfWindowResize
	IF self.node THEN self.node.window.unregisterForResizes(self)
	SUPER self.end()
ENDPROC

->PROTECTED
PROC windowHasResized(oldWidth, oldHeight) OF cGfxNotifyOfWindowResize IS EMPTY
->PUBLIC


PRIVATE
CLASS windowNotifyNode PRIVATE
	client:PTR TO cGfxNotifyOfWindowResize
	window:PTR TO cGfxWindow
	prev  :PTR TO windowNotifyNode	->straight list
	next  :PTR TO windowNotifyNode
ENDCLASS

PROC new(client:PTR TO cGfxNotifyOfWindowResize, window:PTR TO cGfxWindow) OF windowNotifyNode
	self.client := client
	self.window := window
	self.prev   := NIL
	self.next   := NIL
ENDPROC
PUBLIC

/*****************************/

CLASS cGfxWindow ABSTRACT OF cAppResource
	x, y, posSet:BOOL
	resources:OWNS PTR TO cGfxResource	->list of resources (e.g. bitmaps) which should be auto-deallocated upon destroying this object; so the user MUST deallocate such resources before this object is deallocated
	storeBitmaps:OWNS PTR TO cStaticStringNumberPairSpace
	PRIVATE
	head:PTR TO windowNotifyNode	->straight list
	lastEvent_type
	lastEvent_subType
	lastEvent_value
	lastEvent_value2
	drawablesToDestroy:PTR TO drawableNotifyNode	->straight list (reusing objects that were intended for a different purpose)
ENDCLASS

PROC end() OF cGfxWindow
	DEF rNode:PTR TO cGfxResource, rNext:PTR TO cGfxResource
	DEF wNode:PTR TO windowNotifyNode, wNext:PTR TO windowNotifyNode
	
	->handle any outstanding destruction requests
	self.handleDestroyDrawableRequests()
	
	->destroy notification list (without using recursion)
	wNext := self.head
	WHILE wNext
		wNode := wNext
		wNext := wNode.next
		
		END wNode.client.node
	ENDWHILE
	
	->must deallocate stored bitmaps before resources
	END self.storeBitmaps
	
	->auto-deallocate any remaining resources (bitmaps), to prevent (video) memory leak
	rNext := self.resources.next
	WHILE rNext <> self.resources
		rNode := rNext
		rNext := rNode.next
		END rNode
	ENDWHILE
	END self.resources
	
	SUPER self.end()
ENDPROC

->PROTECTED
PROC handleDestroyDrawableRequests() OF cGfxWindow
	DEF node:OWNS PTR TO drawableNotifyNode, next:OWNS PTR TO drawableNotifyNode
	
	next := PASS self.drawablesToDestroy
	WHILE next
		node := PASS next
		next := PASS node.next
		
		END node.drawable
		END node
	ENDWHILE
ENDPROC
PUBLIC

PROC infoScreenWidth() OF cGfxWindow RETURNS width IS EMPTY

PROC infoScreenHeight() OF cGfxWindow RETURNS height IS EMPTY

PROC openWindow(width, height, resizable=FALSE:BOOL) OF cGfxWindow IS EMPTY

PROC openFull() OF cGfxWindow IS EMPTY

PROC close() OF cGfxWindow IS EMPTY

PROC infoIsOpen() OF cGfxWindow RETURNS isOpen:BOOL IS EMPTY

PROC infoTitle() OF cGfxWindow RETURNS title:ARRAY OF CHAR IS EMPTY

PROC infoAlphaChannel() OF cGfxWindow RETURNS alphaChannelEnabled:BOOL IS EMPTY

PROC getPosition() OF cGfxWindow RETURNS x, y IS EMPTY

PROC setPosition(x, y) OF cGfxWindow
	self.x := x
	self.y := y
	self.posSet := TRUE
ENDPROC

PROC infoWidth() OF cGfxWindow RETURNS width IS EMPTY

PROC infoHeight() OF cGfxWindow RETURNS height IS EMPTY

PROC changeSize(width, height) OF cGfxWindow IS EMPTY

PROC getFrameSkipping() OF cGfxWindow RETURNS frameSkipping:BOOL IS EMPTY

PROC setFrameSkipping(frameSkipping:BOOL) OF cGfxWindow IS EMPTY

PROC getAutoUpdate() OF cGfxWindow RETURNS autoUpdate:BOOL IS EMPTY

PROC setAutoUpdate(autoUpdate:BOOL) OF cGfxWindow IS EMPTY

PROC updateAndWaitForScreenRefresh() OF cGfxWindow RETURNS skippingNextFrame:BOOL IS EMPTY

PROC infoSkippingNextFrame() OF cGfxWindow RETURNS skippingNextFrame:BOOL IS EMPTY

PROC waitForScreenRefresh() OF cGfxWindow IS EMPTY
/*
#ifdef WATCHVBLANK_ENABLED
PROC checkForScreenRefresh() OF cGfxWindow RETURNS refreshCount IS EMPTY
#endif

PROC waitForScreenRefresh() OF cGfxWindow RETURNS refreshCount IS EMPTY
*/

PROC clear(rgb) OF cGfxWindow
	DEF oldRGB
	oldRGB := self.getColour()
	self.setColour(rgb)
	self.drawBox(0,0, self.infoWidth(), self.infoHeight())
	self.setColour(oldRGB)
ENDPROC

PROC setColour(rgb) OF cGfxWindow IS EMPTY

PROC getColour() OF cGfxWindow RETURNS rgb IS EMPTY

PROC setColor(rgb) OF cGfxWindow IS self.setColour(rgb)

PROC getColor()    OF cGfxWindow RETURNS rgb IS self.getColour()

PROC readDot(x, y) OF cGfxWindow RETURNS rgb IS EMPTY

PROC drawDot(x, y) OF cGfxWindow IS EMPTY

->a fall-back implementation for drawing a thick line (using thin lines)
PROC drawLine(x1, y1, x2, y2, thickness=1) OF cGfxWindow
	DEF fxThickness:FLOAT, fyThickness:FLOAT, fLength:FLOAT
	DEF i, boxWidth, boxHeight, xThickness, yThickness, xDir, yDir
	DEF endLen, correction, degrees45:BOOL
	
	IF thickness < 0 THEN Throw("EPU", 'drawLine(); thickness<0')
	
	->optimisations
	IF thickness = 0 THEN RETURN
	IF thickness = 1
		->IF DEBUG = FALSE
			self.drawThinLine(x1,y1, x2,y2)
			RETURN
		->ENDIF
	ENDIF
	
	/*IF DEBUG
		IF thickness >= 4
			self.setColour($FF00FF)
			self.drawCircle(x1,y1,thickness/2, TRUE)
			self.drawCircle(x2,y2,thickness/2, TRUE)
		ENDIF
	ENDIF*/
	
	->calc floating-point thickness
	boxWidth  := x2 - x1
	boxHeight := y2 - y1
	degrees45 := (Abs(boxWidth) = Abs(boxHeight))
	fLength := Fsqrt((boxWidth*boxWidth) + (boxHeight*boxHeight))
	fxThickness := thickness * Abs(boxHeight) / fLength
	fyThickness := thickness * Abs(boxWidth ) / fLength
	
	IF (fLength <= fxThickness) OR (fLength <= fyThickness) THEN RETURN		->too short to draw correctly
	
	->calc best integer thickness approximation
	xThickness := Ffloor(fxThickness + 0.5)!!VALUE
	yThickness := Ffloor(fyThickness + 0.5 + fxThickness - xThickness)!!VALUE	->extra code prevents rounding 0.5 up to 1.0 for X & Y, as that would make the line 1 extra pixel wide
	
	->IF DEBUG THEN PrintL('\n#1; x1=\d, x2=\d, y1=\d, y2=\d, thickness=\d, boxWidth=\d, boxHeight=\d, fLength=\d, fxThickness=\d, fyThickness=\d, xThickness=\d, yThickness=\d\n', [x1, x2, y1, y2, thickness, boxWidth, boxHeight, Ffloor(fLength)!!VALUE, fxThickness!!VALUE, fyThickness!!VALUE, xThickness, yThickness])
	
	->modify coordinates to accomodate thickness, to prevent it going outside the line's original bounding box (x1,y1 to x2,y2)
	xDir := IF boxWidth  >= 0 THEN 1 ELSE -1
	yDir := IF boxHeight >= 0 THEN 1 ELSE -1
	boxWidth  := boxWidth  - (Max(0,xThickness-1) * xDir)
	boxHeight := boxHeight - (Max(0,yThickness-1) * yDir)
	xThickness := xThickness * xDir
	yThickness := yThickness * yDir
	x2 := x1 + boxWidth
	y2 := y1 + boxHeight
	
	->IF DEBUG THEN PrintL('#2; xDir=\d, yDir=\d, boxWidth=\d, boxHeight=\d, x2=\d, y2=\d, xThickness=\d, yThickness=\d, x2=\d, y2=\d\n', [xDir, yDir, boxWidth, boxHeight, x2, y2, xThickness, yThickness, x2, y2])
	
	->modify coordinates to accomodate thickness, to keep it centered (should still stay within bounding box)
	IF degrees45 = FALSE	->avoid the edge case, where it should have zero effect, but might not quite (if fxThickness & fyThickness are not rounded identically)
		endLen := Abs(xThickness) + Abs(yThickness)
		IF Abs(xThickness) > Abs(yThickness)
			->(vertical-ish line) so center horizontally
			correction := Abs(xThickness) - (endLen / 2) * xDir
			x1 := x1 - correction
			x2 := x2 + correction
		ELSE
			->(horizontal-ish line) so center vertically
			correction := Abs(yThickness) - (endLen / 2) * yDir
			y1 := y1 - correction
			y2 := y2 + correction
		ENDIF
		
		->IF DEBUG THEN Print('#3; endLen=\d, correction=\d, x1=\d, y1=\d, x2=\d, y2=\d\n', endLen, correction, x1, y1, x2, y2)
	ENDIF
	
	->draw parallel lines for required thickness
	->IF DEBUG THEN self.setColour($0000FF)	->Blue
	/*IF thickness <> 0 THEN*/
	self.drawThinLine(x1,y1, x2,y2)
	
	IF Abs(xThickness) > 1
		->IF DEBUG THEN self.setColour($00FF00)	->Green
		FOR i := xDir TO xThickness-xDir STEP xDir
			self.drawThinLine(x1+i,y1, x2+i,y2)
		ENDFOR
	ENDIF
	
	IF Abs(yThickness) > 1
		->IF DEBUG THEN self.setColour($FF0000)	->Red
		FOR i := yDir TO yThickness-yDir STEP yDir
			self.drawThinLine(x1,y1+i, x2,y2+i)
		ENDFOR
	ENDIF
	
	->fix end of the thick line
	->IF DEBUG THEN self.setColour($0000FF)
	->IF DEBUG THEN self.drawThinLine(x1,y1, x2,y2)
	x2 := x2 + IF xThickness<0 THEN xThickness-xDir ELSE 0
	y2 := y2 + IF yThickness<0 THEN yThickness-yDir ELSE 0
	self.drawBox(x2,y2, Abs(xThickness),Abs(yThickness))		->this overlaps the existing lines by 1 pixel on both edges of the box, to avoid complicating the maths
ENDPROC

->PROTECTED
PROC drawThinLine(x1,y1, x2,y2) OF cGfxWindow IS EMPTY

->a fall-back implementation for drawing a box (also using thin lines)
PROC drawBox(x, y, width, height, unfilled=FALSE:BOOL) OF cGfxWindow
	DEF xMin, yMin, xMax, yMax
	
	IF  width < 0 THEN Throw("EMU", 'cGfxWindow.drawBox(); width<0')
	IF height < 0 THEN Throw("EMU", 'cGfxWindow.drawBox(); height<0')
	
	->get 'ordered' coordinates
	xMin := x					->Min(x, x + width  - 1)
	xMax := x + width - 1		->Max(x, x + width  - 1)
	yMin := y					->Min(y, y + height - 1)
	yMax := y + height - 1		->Max(y, y + height - 1)
	
	->draw the box using lines
	IF unfilled
		self.drawThinLine(xMin, yMin, xMax, yMin)
		self.drawThinLine(xMax, yMax, xMax, yMin)
		self.drawThinLine(xMax, yMax, xMin, yMax)
		self.drawThinLine(xMin, yMin, xMin, yMax)
	ELSE
		IF width < height
			FOR x := xMin TO xMax DO self.drawThinLine(x, yMin, x, yMax)
		ELSE
			FOR y := yMin TO yMax DO self.drawThinLine(xMin, y, xMax, y)
		ENDIF
	ENDIF
ENDPROC

/* 
source wikipedia: http://en.wikipedia.org/wiki/Midpoint_circle_algorithm
19-10-2011 - PortablE code by mrdarek 
21-10-2011 - Cleaned-up by Chris Handley
*/
->a fall-back implementation for drawing a circle
PROC drawCircle(x, y, radius, unfilled=FALSE:BOOL) OF cGfxWindow
	DEF  f, ddF_x, ddF_y, xPos, yPos
	
	IF radius < 0 THEN Throw("EMU", 'cGfxWindow.drawCircle(); radius<0')
	
	f := 1 - radius
	ddF_x := 1
	ddF_y := -2 * radius
	xPos := 0
	yPos := radius
	
	IF unfilled
		self.drawDot(x, y + radius)
		self.drawDot(x, y - radius)
		self.drawDot(x + radius, y)
		self.drawDot(x - radius, y)
	ELSE
		self.drawLine(x, y + radius, x, y - radius)
		self.drawLine(x + radius, y, x - radius, y)
	ENDIF
	
	WHILE xPos < yPos
		/*
		ddF_x == 2 * xPos + 1;
		ddF_y == -2 * yPos;
		f == xPos*xPos + yPos*yPos - radius*radius + 2*xPos - yPos + 1;
		*/
		IF (f >= 0) 
			yPos--
			ddF_y := ddF_y+2
			f := f + ddF_y
		ENDIF
		xPos++
		ddF_x := ddF_x+2
		f := f+ddF_x
		
		IF unfilled
			self.drawDot(x + xPos, y + yPos)
			self.drawDot(x - xPos, y + yPos)
			self.drawDot(x + xPos, y - yPos)
			self.drawDot(x - xPos, y - yPos)
			self.drawDot(x + yPos, y + xPos)
			self.drawDot(x - yPos, y + xPos)
			self.drawDot(x + yPos, y - xPos)
			self.drawDot(x - yPos, y - xPos)
		ELSE
			self.drawLine(x + xPos, y + yPos, x - xPos, y + yPos)
			self.drawLine(x + xPos, y - yPos, x - xPos, y - yPos)
			self.drawLine(x + yPos, y + xPos, x - yPos, y + xPos)
			self.drawLine(x + yPos, y - xPos, x - yPos, y - xPos)
		ENDIF
	ENDWHILE
ENDPROC

PROC setFont(name:ARRAY OF CHAR, size, style0plain1underlined2bold4italic=0) OF cGfxWindow RETURNS success:BOOL IS EMPTY

PROC getFont() OF cGfxWindow RETURNS name:ARRAY OF CHAR, size, style IS EMPTY

PROC drawText(x, y, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) OF cGfxWindow
	DEF text:OWNS PTR TO cGfxBitmap
	
	IF self.infoIsOpen() = FALSE THEN Throw("EMU", 'cGfxWindow.drawText(); window not open')
	
	text := self.makeBitmapTextL(fmtString, [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8])
	text.draw(x, y)
FINALLY
	END text
ENDPROC

PROC drawTextL(x, y, fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1) OF cGfxWindow IS EMPTY

PROC setDrawableRegion(x=0, y=0, width=-1, height=-1) OF cGfxWindow IS EMPTY

PROC getDrawableRegion() OF cGfxWindow RETURNS x, y, width, height IS EMPTY

PROC scrollBox(dx, dy, x, y, width, height) OF cGfxWindow IS EMPTY

PROC setLastEvent(type, subType, value=0, value2=0) OF cGfxWindow
	self.lastEvent_type    := type
	self.lastEvent_subType := subType
	self.lastEvent_value   := value
	self.lastEvent_value2  := value2
ENDPROC

PROC getLastEvent() OF cGfxWindow RETURNS type, subType, value, value2 IS self.lastEvent_type, self.lastEvent_subType, self.lastEvent_value, self.lastEvent_value2

/*
PROC checkForEvent() OF cGfxWindow RETURNS type, subType, value, value2 IS EMPTY

PROC waitForEvent() OF cGfxWindow RETURNS type, subType, value, value2 IS EMPTY
*/

PROC startTimer(periodInMilliSeconds) OF cGfxWindow IS EMPTY

PROC stopTimer() OF cGfxWindow IS EMPTY

PROC infoPeriodOfTimer() OF cGfxWindow RETURNS periodInMilliSeconds IS EMPTY

PROC infoScreenFPS() OF cGfxWindow RETURNS fps IS EMPTY

PROC storeBitmap(name:ARRAY OF CHAR, number, bitmap:PTR TO cGfxBitmap) OF cGfxWindow RETURNS storedBitmap:PTR TO cGfxBitmap
	DEF temp
	
	IF bitmap
		temp := self.storeBitmaps.set(name, number, bitmap)
	ELSE
		temp := self.storeBitmaps.get(name, number, TRUE)	->quiet=TRUE
		->Throw("EMU", 'cGfxWindow.storeBitmap(); you tried to store bitmap=NIL (probably from a failed creation or load)')
	ENDIF
	
	IF temp
		Print('ERROR: There was already a bitmap with name=\'\s\' & number=\d\n', name, number)
		Throw("EMU", 'cGfxWindow.storeBitmap(); you have already stored a bitmap with that name/number')
	ENDIF
	storedBitmap := bitmap
ENDPROC

PROC useBitmap(name:ARRAY OF CHAR, number, allowReturnNIL=FALSE:BOOL) OF cGfxWindow RETURNS bitmap:PTR TO cGfxBitmap
	bitmap := self.storeBitmaps.get(name, number, allowReturnNIL)::cGfxBitmap		->quiet=allowReturnNIL
	IF allowReturnNIL = FALSE
		IF bitmap = NIL THEN Throw("EMU", 'cGfxWindow.useBitmap(); there was no bitmap matching that name/number')
	ENDIF
ENDPROC

PROC destroyDrawable(drawable:PTR TO cGfxDrawable, force=FALSE:BOOL) OF cGfxWindow RETURNS nil:PTR TO cGfxDrawable
	nil := NIL
	
	self.handleDestroyDrawableRequests()
	
	IF force
		END drawable
		
	ELSE IF drawable
		IF drawable.useCount <= 0
			END drawable	->(no sprites/etc depend on the drawable) so it can be safely destroyed
		ELSE
			IF drawable.destructionRequested THEN Throw("EMU", 'cGfxWindow.destroyDrawable(); drawable has already been destroyed (pending)')
			drawable.destructionRequested := self	->remember this bitmap should be destroyed, once it is no-longer depended upon by a sprite/etc
			self.storeBitmaps.remove(drawable)
		ENDIF
	ENDIF
ENDPROC

PROC makeText(fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) OF cGfxWindow RETURNS text:PTR TO cGfxDrawable
	IF self.infoIsOpen() = FALSE THEN Throw("EMU", 'cGfxWindow.makeText(); window not open')
	
	text := self.makeBitmapTextL(fmtString, [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8], -1)
ENDPROC

PROC makeTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1) OF cGfxWindow RETURNS text:PTR TO cGfxDrawable IS EMPTY

PROC makeBitmapTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST, backgroundColour=-1, notDrawable=FALSE:BOOL) OF cGfxWindow RETURNS text:PTR TO cGfxBitmap IS EMPTY

PROC infoSizeOfTextL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) OF cGfxWindow RETURNS width, height IS EMPTY

PROC loadPicture(file:ARRAY OF CHAR, maskFile=NILA:ARRAY OF CHAR, maskColour=-1, notDrawable=FALSE:BOOL) OF cGfxWindow RETURNS pic:PTR TO cGfxBitmap IS EMPTY

PROC extractBitmap(x, y, width, height, notDrawable=FALSE:BOOL) OF cGfxWindow RETURNS copy:PTR TO cGfxBitmap IS EMPTY

PROC makeFractalBitmap(size, pen255colour, pen0colour, roughness=0, maskBelowPen=0, seed=0) OF cGfxWindow RETURNS fractal:PTR TO cGfxBitmap IS EMPTY

PROC queryExtra(specific:QUAD) OF cGfxWindow RETURNS value, unknown:BOOL IS EMPTY

PROC registerForResizes(client:PTR TO cGfxNotifyOfWindowResize) OF cGfxWindow
	DEF node:PTR TO windowNotifyNode
	
	IF client.node <> NIL THEN Throw("EMU", 'cGfxWindow.registerForResizes(); a client can only be registered with one window')
	
	NEW client.node.new(client, self)
	node := client.node
	
	IF self.head = NIL
		self.head := node
	ELSE
		node.next := self.head
		self.head.prev := node
		self.head := node
	ENDIF
ENDPROC

PROC unregisterForResizes(client:PTR TO cGfxNotifyOfWindowResize) OF cGfxWindow
	DEF node:PTR TO windowNotifyNode
	
	node := client.node
	IF node = NIL THEN Throw("EMU", 'cGfxWindow.unregisterForResizes(); was already unregistered')
	
	IF self.head = node
		->(node is head)
		IF node.prev <> NIL THEN Throw("BUG", 'cGfxWindow.unregisterForResizes(); node.prev<>NIL')
		self.head := node.next
		IF self.head THEN self.head.prev := NIL
		
	ELSE IF node.next = NIL
		->(node is tail)
		IF node.prev = NIL THEN Throw("BUG", 'cGfxWindow.unregisterForResizes(); node.prev=NIL (1)')
		node.prev.next := NIL
	ELSE
		IF node.prev = NIL THEN Throw("BUG", 'cGfxWindow.unregisterForResizes(); node.prev=NIL (2)')
		IF node.next = NIL THEN Throw("BUG", 'cGfxWindow.unregisterForResizes(); node.next=NIL')
		node.prev.next := node.next
		node.next.prev := node.prev
	ENDIF
	
	END client.node		->let client know it has been unregistered, so it doesn't try to do so automatically
ENDPROC

->PROTECTED
PROC notifyClientsOfResize(oldWidth, oldHeight) OF cGfxWindow
	DEF node:PTR TO windowNotifyNode
	
	node := self.head
	WHILE node
		node.client.windowHasResized(oldWidth, oldHeight)
		
		node := node.next
	ENDWHILE
ENDPROC
->PUBLIC

/*****************************/

PRIVATE
CLASS cGfxResource /*ABSTRACT*/ PRIVATE
	prev:PTR TO cGfxResource	->circular list
	next:PTR TO cGfxResource
ENDCLASS
PUBLIC

PROC newHead() OF cGfxResource
	self.prev := self
	self.next := self
ENDPROC

PROC addToGfx(gfx:PTR TO cGfxWindow) OF cGfxResource
	DEF head:PTR TO cGfxResource
	
	head := gfx.resources
	
	self.prev := head
	self.next := head.next
	
	head.next.prev := self
	head.next      := self
ENDPROC

PROC end() OF cGfxResource
	->remove self from resource list (handling NIL incase object is never added to the resource list)
	IF self.prev THEN self.prev.next := self.next
	IF self.next THEN self.next.prev := self.prev
	
	SUPER self.end()
ENDPROC

/*****************************/

CLASS cGfxNotifyOfDrawableChanges PRIVATE	->client, e.g. cGfxSprite
	node:OWNS PTR TO drawableNotifyNode
ENDCLASS

PROC end() OF cGfxNotifyOfDrawableChanges
	IF self.node THEN self.node.drawable.unregisterForChanges(self)
	SUPER self.end()
ENDPROC

->PROTECTED
PROC drawableHasChanged(oldWidth, oldHeight, drawable:PTR TO cGfxDrawable) OF cGfxNotifyOfDrawableChanges IS EMPTY
->PUBLIC


PRIVATE
CLASS drawableNotifyNode PRIVATE
	client  :PTR TO cGfxNotifyOfDrawableChanges
	drawable:PTR TO cGfxDrawable
	prev    :PTR TO drawableNotifyNode	->straight list (stored inside the DRAWABLE rather than the client)
	next    :PTR TO drawableNotifyNode
ENDCLASS

PROC new(client:PTR TO cGfxNotifyOfDrawableChanges, drawable:PTR TO cGfxDrawable) OF drawableNotifyNode
	self.client   := client
	self.drawable := drawable
	self.prev     := NIL
	self.next     := NIL
ENDPROC
PUBLIC

/*****************************/

CLASS cGfxDrawable ABSTRACT OF cGfxResource
	gfx:PTR TO cGfxWindow
	visibleCount
	useCount
	destructionRequested:PTR TO cGfxWindow	->indicates that window.destroyDrawable() was used on this drawable, but it was depended upon by a sprite/etc, so have to wait until it is no-longer used before asking the window to destroy us
	PRIVATE
	head:PTR TO drawableNotifyNode	->straight list
ENDCLASS

PROC end() OF cGfxDrawable
	DEF node:PTR TO drawableNotifyNode, next:PTR TO drawableNotifyNode
	
	->destroy notification list (without using recursion), and let client know it has been unregistered
	next := self.head
	WHILE next
		node := next
		next := node.next
		
		END node.client.node	->equivalent to:  node.client.node:=NIL ; END node
	ENDWHILE
	
	SUPER self.end()
ENDPROC

PROC addToGfx(gfx:PTR TO cGfxWindow) OF cGfxDrawable
	IF self.gfx THEN Throw("EMU", 'cGfxDrawable.addToGfx(); has already been called once')
	self.gfx := gfx
	SUPER self.addToGfx(gfx)
ENDPROC


PROC infoWidth() OF cGfxDrawable RETURNS width IS EMPTY

PROC infoHeight() OF cGfxDrawable RETURNS height IS EMPTY

PROC infoWindow() OF cGfxDrawable RETURNS win:PTR TO cGfxWindow IS self.gfx


PROC infoIsTransparent() OF cGfxDrawable RETURNS isTransparent:BOOL IS FALSE

PROC draw(x, y) OF cGfxDrawable IS EMPTY

PRIVATE
PROC NegativeFastMod(a,b) IS FastMod(a,b) - IF a > 0 THEN b ELSE 0
PUBLIC

PROC drawTiled(x, y, tileX:BOOL, tileY:BOOL) OF cGfxDrawable
	DEF width, height
	DEF fromX, fromY, toX, toY
	DEF drawX, drawY, drawW, drawH
	
	IF tileX OR tileY = FALSE
		->optimised common case
		self.draw(x, y)
	ELSE
		width  := self.infoWidth()
		height := self.infoHeight()
		drawX, drawY, drawW, drawH := self.gfx.getDrawableRegion()
		
		IF tileX = FALSE
			fromX := toX := x
		ELSE
			fromX := NegativeFastMod(x, width) + (drawX - FastMod(drawX, width))
			toX   := drawX + drawW - 1
		ENDIF
		
		IF tileY = FALSE
			fromY := toY := y
		ELSE
			fromY := NegativeFastMod(y, height) + (drawY - FastMod(drawY, height))
			toY   := drawY + drawH - 1
		ENDIF
		
		FOR y := fromY TO toY STEP height
			FOR x := fromX TO toX STEP width
				self.draw(x, y)
			ENDFOR
		ENDFOR
	ENDIF
ENDPROC

PROC hitCheck(insideX, insideY) OF cGfxDrawable RETURNS hit:BOOL
	IF (insideX >= 0) AND (insideY >= 0)
		hit := (insideX < self.infoWidth()) AND (insideY < self.infoHeight())
	ELSE
		hit := FALSE
	ENDIF
ENDPROC

PROC overlaps(drawable:PTR TO cGfxDrawable, insideX, insideY) OF cGfxDrawable RETURNS overlaps:BOOL
	IF drawable.IsOfClassType(TYPEOF cGfxBitmap) AND NOT self.IsOfClassType(TYPEOF cGfxBitmap)
		->allow cGfxBitmap to implement mask-aware overlap checks (and still use this method)
		overlaps := drawable.overlaps(self, -insideX, -insideY)
	ELSE
		->check that their bounding boxes overlap
		IF      insideX >= self.infoWidth()
			overlaps := FALSE
			
		ELSE IF insideY >= self.infoHeight()
			overlaps := FALSE
			
		ELSE IF insideX + drawable.infoWidth()  <= 0
			overlaps := FALSE
			
		ELSE IF insideY + drawable.infoHeight() <= 0
			overlaps := FALSE
		ELSE
			overlaps := TRUE
		ENDIF
	ENDIF
ENDPROC

PROC changeUseCount(increaseBy) OF cGfxDrawable
	DEF win:PTR TO cGfxWindow, node:OWNS PTR TO drawableNotifyNode
	
	self.useCount := self.useCount + increaseBy
	
	IF self.destructionRequested
		->(user had previously tried to destroy us, while we were still depended upon...)
		IF self.useCount <= 0
			->(... but this is no-longer the case) so now ask window to destroy us
			win := self.destructionRequested
			self.destructionRequested := NIL
			
			->add us to list of drawables that window should destroy
			NEW node.new(NIL, self)
			node.next := win.drawablesToDestroy
			win.drawablesToDestroy := PASS node
		ENDIF
	ENDIF
ENDPROC

PROC infoUseCount() OF cGfxDrawable RETURNS useCount IS self.useCount

PROC changeVisibleCount(increaseBy) OF cGfxDrawable
	self.visibleCount := self.visibleCount + increaseBy
ENDPROC

PROC infoVisibleCount() OF cGfxDrawable RETURNS visibleCount IS self.visibleCount

PROC registerForChanges(client:PTR TO cGfxNotifyOfDrawableChanges) OF cGfxDrawable
	DEF node:PTR TO drawableNotifyNode
	
	IF client.node <> NIL THEN Throw("EMU", 'cGfxDrawable.registerForChanges(); a client can only be registered with one drawable')
	
	NEW client.node.new(client, self)
	node := client.node
	
	IF self.head = NIL
		self.head := node
	ELSE
		node.next := self.head
		self.head.prev := node
		self.head := node
	ENDIF
ENDPROC

PROC unregisterForChanges(client:PTR TO cGfxNotifyOfDrawableChanges) OF cGfxDrawable
	DEF node:PTR TO drawableNotifyNode
	
	node := client.node
	IF node = NIL THEN Throw("EMU", 'cGfxDrawable.unregisterForChanges(); was already unregistered')
	
	IF self.head = node
		->(node is head)
		IF node.prev <> NIL THEN Throw("BUG", 'cGfxDrawable.unregisterForChanges(); node.prev<>NIL')
		self.head := node.next
		IF self.head THEN self.head.prev := NIL
		
	ELSE IF node.next = NIL
		->(node is tail)
		IF node.prev = NIL THEN Throw("BUG", 'cGfxDrawable.unregisterForChanges(); node.prev=NIL (1)')
		node.prev.next := NIL
	ELSE
		IF node.prev = NIL THEN Throw("BUG", 'cGfxDrawable.unregisterForChanges(); node.prev=NIL (2)')
		IF node.next = NIL THEN Throw("BUG", 'cGfxDrawable.unregisterForChanges(); node.next=NIL')
		node.prev.next := node.next
		node.next.prev := node.prev
	ENDIF
	
	END client.node		->let client know it has been unregistered, so it doesn't try to do so automatically
ENDPROC

->PROTECTED
PROC notifyClientsOfChange(oldWidth, oldHeight) OF cGfxDrawable
	DEF node:PTR TO drawableNotifyNode
	
	node := self.head
	WHILE node
		node.client.drawableHasChanged(oldWidth, oldHeight, self)
		
		node := node.next
	ENDWHILE
ENDPROC
->PUBLIC

/*****************************/

CLASS cGfxBitmap ABSTRACT OF cGfxDrawable
	
ENDCLASS

PROC end() OF cGfxBitmap
	IF self.gfx.storeBitmaps THEN self.gfx.storeBitmaps.remove(self)
	SUPER self.end()
ENDPROC

PROC clone(changeIsDrawable=FALSE:BOOL, isDrawable=FALSE:BOOL) OF cGfxBitmap RETURNS clone:PTR TO cGfxBitmap IS EMPTY

PROC extract(x, y, width, height, changeIsDrawable=FALSE:BOOL, isDrawable=FALSE:BOOL) OF cGfxBitmap RETURNS copy:PTR TO cGfxBitmap IS EMPTY

PROC setIsDrawable(isDrawable:BOOL) OF cGfxBitmap IS EMPTY

PROC getIsDrawable() OF cGfxBitmap RETURNS isDrawable:BOOL IS EMPTY

PROC draw(x, y) OF cGfxBitmap IS EMPTY

PROC flip(horizontally:BOOL, vertically:BOOL) OF cGfxBitmap IS EMPTY

PROC rotate(degrees) OF cGfxBitmap IS EMPTY

PROC scaleTo(newWidth, newHeight) OF cGfxBitmap IS EMPTY

PROC scaleBy(multiplier, divider) OF cGfxBitmap IS EMPTY

PROC makeScaledTo(newWidth, newHeight) OF cGfxBitmap RETURNS scaledBitmap:PTR TO cGfxBitmap IS EMPTY

PROC makeScaledBy(multiplier, divider) OF cGfxBitmap RETURNS scaledBitmap:PTR TO cGfxBitmap IS EMPTY

PROC savePicture(file:ARRAY OF CHAR, ignoreMask=FALSE:BOOL) OF cGfxBitmap RETURNS success:BOOL IS EMPTY

/*****************************/

SET EVENT_MOUSE, EVENT_KEY, EVENT_WINDOW, EVENT_TIMER, EVENT_UNKNOWN

ENUM EVENT_MOUSE_MOVE, EVENT_MOUSE_SCROLL, EVENT_MOUSE_DOUBLECLICK, EVENT_MOUSE_LEFT, EVENT_MOUSE_LEFTUP, EVENT_MOUSE_RIGHT, EVENT_MOUSE_RIGHTUP, EVENT_MOUSE_MIDDLE, EVENT_MOUSE_MIDDLEUP
ENUM EVENT_KEY_ASCII, EVENT_KEY_ASCIIUP, EVENT_KEY_SPECIAL, EVENT_KEY_SPECIALUP
ENUM EVENT_WINDOW_CLOSE, EVENT_WINDOW_ACTIVE, EVENT_WINDOW_INACTIVE, EVENT_WINDOW_RESIZED
ENUM EVENT_TIMER_EXPIRED
ENUM EVENT_UNKNOWN_DONOTUSE
->ENUM EVENT_SCREEN_REFRESH

ENUM EVENT_KEY_SPECIAL_ENTER, EVENT_KEY_SPECIAL_ESCAPE, EVENT_KEY_SPECIAL_TAB, EVENT_KEY_SPECIAL_BACKSPACE,
     EVENT_KEY_SPECIAL_INSERT, EVENT_KEY_SPECIAL_DELETE, EVENT_KEY_SPECIAL_HOME, EVENT_KEY_SPECIAL_END, EVENT_KEY_SPECIAL_PAGEUP, EVENT_KEY_SPECIAL_PAGEDOWN,
     EVENT_KEY_SPECIAL_UP, EVENT_KEY_SPECIAL_DOWN, EVENT_KEY_SPECIAL_LEFT, EVENT_KEY_SPECIAL_RIGHT, EVENT_KEY_SPECIAL_LSHIFT, EVENT_KEY_SPECIAL_RSHIFT, EVENT_KEY_SPECIAL_LCTRL, EVENT_KEY_SPECIAL_RCTRL, EVENT_KEY_SPECIAL_LALT, EVENT_KEY_SPECIAL_RALT, EVENT_KEY_SPECIAL_LCOMMAND, EVENT_KEY_SPECIAL_RCOMMAND,
     EVENT_KEY_SPECIAL_F1, EVENT_KEY_SPECIAL_F2, EVENT_KEY_SPECIAL_F3, EVENT_KEY_SPECIAL_F4, EVENT_KEY_SPECIAL_F5, EVENT_KEY_SPECIAL_F6, EVENT_KEY_SPECIAL_F7, EVENT_KEY_SPECIAL_F8, EVENT_KEY_SPECIAL_F9, EVENT_KEY_SPECIAL_F10

CONST EVENT_NONE = 0
CONST EVENT_ALL = (EVENT_MOUSE OR EVENT_KEY OR EVENT_WINDOW) OR EVENT_TIMER OR EVENT_UNKNOWN


/* ->obsolete:
CLASS event
	type
	subType
	value, value2
ENDCLASS

PROC new(type, subType, value=0, value2=0) OF event
	self.type    := type
	self.subType := subType
	self.value   := value
	self.value2  := value2
ENDPROC

PROC infoType() OF event RETURNS type, subType IS self.type, self.subType

PROC infoSubType() OF event RETURNS subType IS self.subType

PROC infoValue() OF event RETURNS value, value2 IS self.value, self.value2
*/

/*****************************/

PROC CreateGfxWindow(title:ARRAY OF CHAR, hideMousePointer=FALSE:BOOL, enableAlphaChannel=FALSE:BOOL) RETURNS win:PTR TO cGfxWindow PROTOTYPE IS EMPTY

PROC DestroyGfxWindow(win:PTR TO cGfxWindow) RETURNS nil:PTR TO cGfxWindow PROTOTYPE IS EMPTY

PROC MakeRGB(red/*:RANGE 0 TO 255*/, green/*:RANGE 0 TO 255*/, blue/*:RANGE 0 TO 255*/) RETURNS rgb
	IF (  red < 0) OR (  red > 255) THEN Throw("EPU",'cGfx; MakeRGB(); red outside of RANGE 0 TO 255')
	IF (green < 0) OR (green > 255) THEN Throw("EPU",'cGfx; MakeRGB(); green outside of RANGE 0 TO 255')
	IF ( blue < 0) OR ( blue > 255) THEN Throw("EPU",'cGfx; MakeRGB(); blue outside of RANGE 0 TO 255')
	
	rgb := red SHL 8 OR green SHL 8 OR blue
ENDPROC

PROC Pause(delayInTenthsOfSecond) PROTOTYPE IS EMPTY

PROC CheckForGfxWindowEvent(keepPreviousEvents=FALSE:BOOL) RETURNS win:PTR TO cGfxWindow, type, subType, value, value2 PROTOTYPE IS EMPTY

PROC WaitForGfxWindowEvent() RETURNS win:PTR TO cGfxWindow, type, subType, value, value2 PROTOTYPE IS EMPTY

/*****************************/
