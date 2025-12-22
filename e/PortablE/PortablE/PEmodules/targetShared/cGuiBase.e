/* cGuiBase.e 03-02-2017
	An abstract set of classes which provide an easy & portable GUI system.

Copyright (c) 2010,2011,2012,2013,2014,2015,2016,2017 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
 CreateGuiWindow(title:ARRAY OF CHAR)   RETURNS win:PTR TO cGuiWindow
DestroyGuiWindow(win:PTR TO cGuiWindow) RETURNS nil:PTR TO cGuiWindow
 WaitForChangedGuiItem() RETURNS item:PTR TO cGuiItem, win:PTR TO cGuiWindow
CheckForChangedGuiItem(keepPreviousChangedItems=FALSE:BOOL) RETURNS item:PTR TO cGuiItem, win:PTR TO cGuiWindow
*/
/* Public methods of *cGuiWindow* class:
initAllowDropFiles()
infoAllowDropFiles() RETURNS allowDropFiles:BOOL
initSaveID(id)
infoSaveID() RETURNS id

beginGroupHorizontal(borderTitle=NILA:ARRAY OF CHAR, scrollable=FALSE:BOOL) RETURNS item:PTR TO cGuiGroupHorizontal
beginGroupVertical(  borderTitle=NILA:ARRAY OF CHAR, scrollable=FALSE:BOOL) RETURNS item:PTR TO cGuiGroupVertical
beginGroupGrid(width,borderTitle=NILA:ARRAY OF CHAR, scrollable=FALSE:BOOL) RETURNS item:PTR TO cGuiGroupGrid
beginGroupPage(      borderTitle=NILA:ARRAY OF CHAR, scrollable=FALSE:BOOL) RETURNS item:PTR TO cGuiGroupPage
endGroup()

addBreak()
addBar(    title=NILA:ARRAY OF CHAR)
addLabel(       label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiLabel
addText(        label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiText
addTextBox(     label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiTextBox
addButton(      label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiButton
addTick(        label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiTick
addString(      label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiString
addStringBox(   label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiStringBox
addPathString(  label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiPathString
addNumberString(label:ARRAY OF CHAR, min, max) RETURNS item:PTR TO cGuiNumberString
addSlider(      label:ARRAY OF CHAR, min, max) RETURNS item:PTR TO cGuiSlider
addCycleChoice( label:ARRAY OF CHAR, stringChoices:ARRAY OF ARRAY OF CHAR) RETURNS item:PTR TO cGuiCycleChoice
addRadioChoice( label:ARRAY OF CHAR, stringChoices:ARRAY OF ARRAY OF CHAR) RETURNS item:PTR TO cGuiRadioChoice
addNative(    newItem:OWNS PTR TO cGuiNativeItem) RETURNS item:PTR TO cGuiNativeItem
infoCurrentBuildGroup() RETURNS item:PTR TO cGuiGroupItem

beginFixedList(columns=1, borderTitle=NILA:ARRAY OF CHAR) RETURNS item:PTR TO cGuiFixedList
endFixedList()
addFixedListEntry(label:ARRAY OF CHAR) RETURNS item:PTR TO cGuiFixedListEntry

beginList(columns=1, borderTitle=NILA:ARRAY OF CHAR) RETURNS item:PTR TO cGuiList
endList()
addListEntry(label:ARRAY OF CHAR)

build(keepWindowClosed=FALSE:BOOL)
open()
close()
infoIsOpen()
infoTitle() RETURNS title:ARRAY OF CHAR

getLastChangedItem() RETURNS item:PTR TO cGuiItem
setLastChangedItem(item:PTR TO cGuiItem)
getCloseRequest(doNotClear=FALSE:BOOL) RETURNS closeRequest:BOOL
setCloseRequest(closeRequest:BOOL)
getQuitRequest(doNotClear=FALSE:BOOL) RETURNS quitRequest:BOOL
setQuitRequest(quitRequest:BOOL)
getFileDropped(doNotClear=FALSE:BOOL) RETURNS fileDropped:ARRAY OF CHAR
setFileDropped(fileDropped:ARRAY OF CHAR)

getBusy() RETURNS busy:BOOL
setBusy(busy:BOOL)
getPosition() RETURNS x, y
setPosition(x, y)
infoWidth()  RETURNS width
infoHeight() RETURNS height
changeSize(width, height)
queryExtra(specific:QUAD) RETURNS value, unknown:BOOL
*/

MODULE 'targetShared/cAppBase'
MODULE 'CSH/pGeneral', 'CSH/pString', 'CSH/cMegaList_class', 'CSH/cMiniList'

TYPE ARRAY_OF_CHAR IS ARRAY OF CHAR

/*****************************/

->PROTECTED

CLASS cGuiSharedBase ABSTRACT
	owner:PTR TO cGuiItem
ENDCLASS

PROC new(owner:PTR TO cGuiItem) OF cGuiSharedBase
	self.owner := owner
ENDPROC

PUBLIC

/*****************************/

CLASS cGuiItem ABSTRACT
	next  :OWNS PTR TO cGuiItem			->used by groups
	data								->user-defined data
	
	redirectEventTo:PTR TO cGuiItem		->allow events to appear to come from somewhere else (for composite items like FixedListEntry)
	
	shared:OWNS PTR TO cGuiSharedBase	->optionally used by the concrete sub-classes
	parent:     PTR TO cGuiGroupItem	->optionally used during the build process; NIL if there is no container class (other than a window)
	seqItem:    PTR TO cGuiItem			->optionally used during the build process, to link the tree of nodes in a simple sequential order
ENDCLASS

PROC end() OF cGuiItem
	->  self.next
	->  self.data
	
	->  self.redirectEventTo
	
	END self.shared
	->  self.parent
	->  self.seqItem
	
	SUPER self.end()
ENDPROC

->PROTECTED

PROC initShared() OF cGuiItem IS EMPTY

PROC shared(id, params=NILL:ILIST) OF cGuiItem RETURNS result IS EMPTY

PROC setRedirectEventTo(item:NULL PTR TO cGuiItem) OF cGuiItem
	self.redirectEventTo := item
ENDPROC

PROC getRedirectEventTo() OF cGuiItem RETURNS item:PTR TO cGuiItem IS self.redirectEventTo

->	eventRedirectedFrom:PTR TO cGuiItem	->when an even was redirected to us, this temporarily stores where it came from
->
->PROC setEventRedirectedFrom(item:PTR TO cGuiItem) OF cGuiItem
->	self.eventRedirectedFrom := item
->ENDPROC
->
->PROC getEventRedirectedFrom() OF cGuiItem RETURNS item:PTR TO cGuiItem IS self.eventRedirectedFrom

PUBLIC

PROC setData(data) OF cGuiItem
	self.data := data
ENDPROC self

PROC getData() OF cGuiItem RETURNS data IS self.data

PROC infoNextInGroup() OF cGuiItem RETURNS item:PTR TO cGuiItem IS self.next

PROC queryExtra(specific:QUAD) OF cGuiItem RETURNS value, unknown:BOOL IS 0, TRUE


->NOTE: This is for internal use only!
PROC internalShared() OF cGuiItem IS self.shared

->NOTE: This is for internal use only!
PROC internalInitParent(parent:PTR TO cGuiGroupItem) OF cGuiItem
	self.parent := parent
ENDPROC

->NOTE: This is for internal use only!
PROC internalParent() OF cGuiItem IS self.parent

->NOTE: This is for internal use only!
PROC internalGetSeqItem() OF cGuiItem IS self.seqItem

->NOTE: This is for internal use only!
PROC internalSetSeqItem(seqItem:PTR TO cGuiItem) OF cGuiItem
	self.seqItem := seqItem
ENDPROC

->this is not overridden by the cGuiFixedListEntry class
->NOTE: This is for internal use only!
PROC internalInfoNextInGroup() OF cGuiItem IS self.next

/*****************************/

FUNC funcGuiNotify(changedItem:PTR TO cGuiItem) IS EMPTY

/*****************************/

CLASS cGuiGroupItem ABSTRACT OF cGuiItem
	border:BOOL
	title :ARRAY OF CHAR
	scrollable:BOOL
	equalSizedItems:BOOL
	useLeastSpace:BOOL
	
	head:OWNS PTR TO cGuiItem
	tail:     PTR TO cGuiItem
	size
ENDCLASS

->PROTECTED
->NOTE: If borderTitle='' then the group is bordered without a title.
PROC new(borderTitle=NILA:ARRAY OF CHAR) OF cGuiGroupItem
	->self.internalInitParent(NIL)
	
	self.border := (borderTitle <> NILA)
	self.title  := IF borderTitle THEN (IF borderTitle[0] <> 0 THEN borderTitle ELSE NILA) ELSE NILA
	self.scrollable := FALSE
	self.equalSizedItems := FALSE
	self.useLeastSpace := FALSE
	
	self.head := NIL
	self.tail := NIL
	self.size := 0
	self.initShared()
ENDPROC
PUBLIC

PROC end() OF cGuiGroupItem
	DEF node:OWNS PTR TO cGuiItem, next:OWNS PTR TO cGuiItem
	
	next := PASS self.head
	WHILE next
		node := PASS next
		next := PASS node.next
		
		END node
	ENDWHILE
	
	SUPER self.end()
ENDPROC

->PROTECTED

PROC add(item:OWNS PTR TO cGuiItem) OF cGuiGroupItem
	IF item = NIL THEN Throw("EMU", 'cGuiGroupItem.add(); item=NIL')
	
	item.internalInitParent(self)
	
	IF self.head = NIL
		self.head := PASS item
		self.tail := self.head
	ELSE
		self.tail.next := PASS item
		self.tail := self.tail.next
	ENDIF
	self.size++
ENDPROC

->this is called when the group is closed with cGuiWindow.endGroup()
PROC groupWasClosed() OF cGuiGroupItem IS EMPTY

PUBLIC

PROC initScrollable() OF cGuiGroupItem
	self.scrollable := TRUE
ENDPROC self

PROC initEqualSizedItems() OF cGuiGroupItem
	self.equalSizedItems := TRUE
ENDPROC self

PROC initUseLeastSpace() OF cGuiGroupItem
	self.useLeastSpace := TRUE
ENDPROC self

PROC infoHasBorder() OF cGuiGroupItem RETURNS hasBorder:BOOL IS self.border

PROC infoTitle() OF cGuiGroupItem RETURNS title:ARRAY OF CHAR IS self.title

PROC infoSize() OF cGuiGroupItem RETURNS size IS self.size

PROC infoFirstItem() OF cGuiGroupItem RETURNS item:PTR TO cGuiItem IS self.head

PROC infoLastItem() OF cGuiGroupItem RETURNS item:PTR TO cGuiItem IS self.tail

PROC infoScrollable() OF cGuiGroupItem RETURNS scrollable:BOOL IS self.scrollable

PROC infoEqualSizedItems() OF cGuiGroupItem RETURNS equalSizedItems:BOOL IS self.equalSizedItems

PROC infoUseLeastSpace() OF cGuiGroupItem RETURNS useLeastSpace:BOOL IS self.useLeastSpace

PROC setGhosted(ghosted:BOOL) OF cGuiGroupItem		-># the method name could be improved
	DEF node:PTR TO cGuiItem
	
	node := self.head
	WHILE node
		IF node.IsOfClassType(TYPEOF cGuiInputItem)
			node::cGuiInputItem.setGhosted(ghosted)
			
		ELSE IF node.IsOfClassType(TYPEOF cGuiGroupItem)
			node::cGuiGroupItem.setGhosted(ghosted)
		ENDIF
		
		node := node.next
	ENDWHILE
ENDPROC self

/*****************************/

CLASS cGuiGroupHorizontal OF cGuiGroupItem
ENDCLASS

PROC setData(data) OF cGuiGroupHorizontal IS SUPER self.setData(data)::cGuiGroupHorizontal

PROC initScrollable() OF cGuiGroupHorizontal IS SUPER self.initScrollable()::cGuiGroupHorizontal

PROC initEqualSizedItems() OF cGuiGroupHorizontal IS SUPER self.initEqualSizedItems()::cGuiGroupHorizontal

PROC setGhosted(ghosted:BOOL) OF cGuiGroupHorizontal IS SUPER self.setGhosted(ghosted)::cGuiGroupHorizontal

/*****************************/

CLASS cGuiGroupVertical OF cGuiGroupItem
ENDCLASS

PROC setData(data) OF cGuiGroupVertical IS SUPER self.setData(data)::cGuiGroupVertical

PROC initScrollable() OF cGuiGroupVertical IS SUPER self.initScrollable()::cGuiGroupVertical

PROC initEqualSizedItems() OF cGuiGroupVertical IS SUPER self.initEqualSizedItems()::cGuiGroupVertical

PROC setGhosted(ghosted:BOOL) OF cGuiGroupVertical IS SUPER self.setGhosted(ghosted)::cGuiGroupVertical

/*****************************/

CLASS cGuiGroupGrid OF cGuiGroupItem
	width
ENDCLASS

->PROTECTED
PROC new(borderTitle=NILA:ARRAY OF CHAR, width=0) OF cGuiGroupGrid
	SUPER self.new(borderTitle)
	self.width := width
ENDPROC
PUBLIC

PROC setData(data) OF cGuiGroupGrid IS SUPER self.setData(data)::cGuiGroupGrid

PROC initScrollable() OF cGuiGroupGrid IS SUPER self.initScrollable()::cGuiGroupGrid

PROC initEqualSizedItems() OF cGuiGroupGrid IS SUPER self.initEqualSizedItems()::cGuiGroupGrid

PROC setGhosted(ghosted:BOOL) OF cGuiGroupGrid IS SUPER self.setGhosted(ghosted)::cGuiGroupGrid

PROC infoWidth() OF cGuiGroupGrid RETURNS width IS self.width

/*****************************/

CLASS cGuiGroupPage OF cGuiGroupItem
	page		->it is assumed that the user can't change the page without going through setState(), so this should always reflect the actual state
ENDCLASS

->PROTECTED
PROC new(borderTitle=NILA:ARRAY OF CHAR) OF cGuiGroupPage
	SUPER self.new(borderTitle)
	self.page := 0
ENDPROC
PUBLIC

PROC setData(data) OF cGuiGroupPage IS SUPER self.setData(data)::cGuiGroupPage

PROC setGhosted(ghosted:BOOL) OF cGuiGroupPage IS SUPER self.setGhosted(ghosted)::cGuiGroupPage

PROC getState() OF cGuiGroupPage RETURNS pageNumber IS self.page

PROC setState(pageNumber) OF cGuiGroupPage
	IF (pageNumber < 0) OR (pageNumber >= self.infoSize()) THEN Throw("EMU", 'cGuiGroupPage.setState(); the page number is outside the valid range')
	
	self.page := pageNumber
ENDPROC self

PROC getStateItem() OF cGuiGroupPage RETURNS pageItem:PTR TO cGuiItem IS EMPTY

PROC setStateItem(pageItem:PTR TO cGuiItem) OF cGuiGroupPage IS self

PROC infoMaxPageNum() OF cGuiGroupPage RETURNS pageNum IS self.infoSize() - 1

PROC infoPageNumOfPageItem(pageItem:PTR TO cGuiItem) OF cGuiGroupPage RETURNS pageNumber IS EMPTY

PROC infoPageItemOfPageNum(pageNumber) OF cGuiGroupPage RETURNS pageItem:PTR TO cGuiItem IS EMPTY

/*****************************/

CLASS cGuiBreak ABSTRACT OF cGuiItem
ENDCLASS

PRIVATE
PROC new() OF cGuiBreak
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiBreak IS SUPER self.setData(data)::cGuiBreak

/*****************************/

CLASS cGuiBar ABSTRACT OF cGuiItem
	title:ARRAY OF CHAR
ENDCLASS

PRIVATE
PROC new(title=NILA:ARRAY OF CHAR) OF cGuiBar
	self.title := title
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiBar IS SUPER self.setData(data)::cGuiBar

PROC infoTitle() OF cGuiBar RETURNS title:ARRAY OF CHAR IS self.title

/*****************************/

CLASS cGuiLabelledItem ABSTRACT OF cGuiItem
	label:OWNS STRING
	alignment:CHAR	->0, "L","C","R"
ENDCLASS

PROC end() OF cGuiLabelledItem
	END self.label
	SUPER self.end()
ENDPROC

->PROTECTED

PROC initLabel(label:ARRAY OF CHAR) OF cGuiLabelledItem
	self.label := StrJoin(label)
	self.alignment := 0
ENDPROC

PUBLIC

PROC infoLabel() OF cGuiLabelledItem RETURNS label:ARRAY OF CHAR IS self.label

/*****************************/

CLASS cGuiOutputItem ABSTRACT OF cGuiLabelledItem
	useLeastSpace:BOOL
	popupHint:OWNS STRING
ENDCLASS

PROC end() OF cGuiOutputItem
	END self.popupHint
	SUPER self.end()
ENDPROC

PROC initUseLeastSpace() OF cGuiOutputItem
	self.useLeastSpace := TRUE
ENDPROC self

PROC infoUseLeastSpace() OF cGuiOutputItem RETURNS useLeastSpace:BOOL IS self.useLeastSpace

PROC getPopupHint() OF cGuiOutputItem RETURNS popupHint:ARRAY OF CHAR IS self.popupHint

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiOutputItem
	END self.popupHint
	self.popupHint := IF popupHint THEN StrJoin(popupHint) ELSE NILS
ENDPROC self

/*****************************/

CLASS cGuiInputItem ABSTRACT OF cGuiOutputItem
	ghosted:BOOL
	func:PTR TO funcGuiNotify
ENDCLASS

->PROTECTED

PROC notifyStateHasChanged() OF cGuiInputItem
	IF self.func THEN self.func(self)
ENDPROC

PUBLIC

PROC getGhosted() OF cGuiInputItem RETURNS ghosted:BOOL IS self.ghosted

PROC setGhosted(ghosted:BOOL) OF cGuiInputItem
	self.ghosted := ghosted
ENDPROC self

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiInputItem
	self.func := func
ENDPROC self

PROC getNotifyFunction() OF cGuiInputItem RETURNS func:PTR TO funcGuiNotify IS self.func

/*****************************/

CONST GUI_STYLE_NONE = 0
SET   GUI_STYLE_ALTCOLOUR, GUI_STYLE_GHOSTEDCOLOUR, GUI_STYLE_BOLD,
      GUI_STYLE_ITALIC	-># undocumented!

CONST GUI_STYLE_ALTCOLOR     = GUI_STYLE_ALTCOLOUR
CONST GUI_STYLE_GHOSTEDCOLOR = GUI_STYLE_GHOSTEDCOLOUR


CLASS cGuiLabel ABSTRACT OF cGuiOutputItem
	style
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiLabel
	self.initLabel(label)
	self.style := GUI_STYLE_NONE
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiLabel IS SUPER self.setData(data)::cGuiLabel

PROC initAlignLeft()   OF cGuiLabel
	self.alignment := "L"
ENDPROC self

PROC initAlignCenter() OF cGuiLabel
	self.alignment := "C"
ENDPROC self

PROC initAlignRight()  OF cGuiLabel
	self.alignment := "R"
ENDPROC self

PROC infoAlignLeft()   OF cGuiLabel RETURNS isAlignedLeft:BOOL   IS self.alignment = "L"

PROC infoAlignCenter() OF cGuiLabel RETURNS isAlignedCenter:BOOL IS self.alignment = "C"

PROC infoAlignRight()  OF cGuiLabel RETURNS isAlignedRight:BOOL  IS self.alignment = "R"

PROC initUseLeastSpace() OF cGuiLabel IS SUPER self.initUseLeastSpace()::cGuiLabel

PROC initStyle(style) OF cGuiLabel
	self.style := style
ENDPROC self
->obsolete
PROC initAltColour() OF cGuiLabel IS self.initStyle(GUI_STYLE_ALTCOLOUR)

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiLabel IS SUPER self.setPopupHint(popupHint)::cGuiLabel

/*****************************/

CLASS cGuiText ABSTRACT OF cGuiOutputItem
	text:OWNS STRING
	fixedFont:BOOL
	textAlignment:CHAR
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiText
	self.initLabel(label)
	self.text          := NEW ''
	self.fixedFont     := FALSE
	self.textAlignment := "L"
	self.initShared()
ENDPROC
PUBLIC

PROC end() OF cGuiText
	END self.text
	SUPER self.end()
ENDPROC

PROC setData(data) OF cGuiText IS SUPER self.setData(data)::cGuiText

PROC getState() OF cGuiText RETURNS text:ARRAY OF CHAR IS EMPTY

PROC setState(text:ARRAY OF CHAR) OF cGuiText
	END self.text
	self.text := StrJoin(text)
ENDPROC self

PROC initFixedFont() OF cGuiText
	self.fixedFont := TRUE
ENDPROC self

PROC initAlignRight() OF cGuiText
	self.textAlignment := "R"
ENDPROC self

PROC initAlignCenter() OF cGuiText
	self.textAlignment := "C"
ENDPROC self

PROC infoFixedFont() OF cGuiText RETURNS fixedFont:BOOL IS self.fixedFont

PROC infoAlignRight()  OF cGuiText RETURNS isAlignedRight:BOOL  IS self.textAlignment = "R"

PROC infoAlignCenter() OF cGuiText RETURNS isAlignedCenter:BOOL IS self.textAlignment = "C"

PROC initUseLeastSpace() OF cGuiText IS SUPER self.initUseLeastSpace()::cGuiText

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiText IS SUPER self.setPopupHint(popupHint)::cGuiText

/*****************************/

CLASS cGuiTextBox ABSTRACT OF cGuiOutputItem
	text:OWNS STRING
	fixedFont:BOOL
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiTextBox
	self.initLabel(label)
	self.text      := NEW ''
	self.fixedFont := FALSE
	self.initShared()
ENDPROC
PUBLIC

PROC end() OF cGuiTextBox
	END self.text
	SUPER self.end()
ENDPROC

PROC setData(data) OF cGuiTextBox IS SUPER self.setData(data)::cGuiTextBox

PROC getState() OF cGuiTextBox RETURNS text:ARRAY OF CHAR IS EMPTY

PROC setState(text:ARRAY OF CHAR) OF cGuiTextBox
	END self.text
	self.text := StrJoin(text)
ENDPROC self

PROC initFixedFont() OF cGuiTextBox
	self.fixedFont := TRUE
ENDPROC self

PROC infoFixedFont() OF cGuiTextBox RETURNS fixedFont:BOOL IS self.fixedFont

PROC initUseLeastSpace() OF cGuiTextBox IS SUPER self.initUseLeastSpace()::cGuiTextBox

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiTextBox IS SUPER self.setPopupHint(popupHint)::cGuiTextBox

/*****************************/

CLASS cGuiButton ABSTRACT OF cGuiInputItem
	picPath:OWNS STRING
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiButton
	self.initLabel(label)
	self.picPath := NILS
	self.initShared()
ENDPROC
PUBLIC

PROC end() OF cGuiButton
	END self.picPath
	SUPER self.end()
ENDPROC

PROC setData(data) OF cGuiButton IS SUPER self.setData(data)::cGuiButton

PROC initPic(picPath:ARRAY OF CHAR) OF cGuiButton
	END self.picPath
	self.picPath := StrJoin(picPath) ; IF EstrLen(self.picPath) = 0 THEN END self.picPath
ENDPROC self

PROC infoPic() OF cGuiButton RETURNS picPath:ARRAY OF CHAR IS self.picPath

PROC initUseLeastSpace() OF cGuiButton IS SUPER self.initUseLeastSpace()::cGuiButton

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiButton IS SUPER self.setPopupHint(popupHint)::cGuiButton

PROC setGhosted(ghosted:BOOL) OF cGuiButton IS SUPER self.setGhosted(ghosted)::cGuiButton

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiButton IS SUPER self.setNotifyFunction(func)::cGuiButton

/*****************************/

CLASS cGuiTick ABSTRACT OF cGuiInputItem
	default:BOOL
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiTick
	self.initLabel(label)
	self.default := FALSE
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiTick IS SUPER self.setData(data)::cGuiTick

PROC getState() OF cGuiTick RETURNS ticked:BOOL IS EMPTY

PROC setState(ticked:BOOL) OF cGuiTick IS self

PROC initUseLeastSpace() OF cGuiTick IS SUPER self.initUseLeastSpace()::cGuiTick

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiTick IS SUPER self.setPopupHint(popupHint)::cGuiTick

PROC setGhosted(ghosted:BOOL) OF cGuiTick IS SUPER self.setGhosted(ghosted)::cGuiTick

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiTick IS SUPER self.setNotifyFunction(func)::cGuiTick

/*****************************/

CLASS cGuiStringItem ABSTRACT OF cGuiInputItem
	default:OWNS STRING
ENDCLASS

PROC end() OF cGuiStringItem
	END self.default
	SUPER self.end()
ENDPROC

PROC getState() OF cGuiStringItem RETURNS string:ARRAY OF CHAR IS EMPTY

PROC setState(string:ARRAY OF CHAR) OF cGuiStringItem
	DEF old:OWNS STRING
	old := PASS self.default
	self.default := StrJoin(string)
FINALLY
	END old
ENDPROC self

/*****************************/

CLASS cGuiString ABSTRACT OF cGuiStringItem
	maxLength
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiString
	self.initLabel(label)
	self.default := NEW ''
	self.maxLength := 256
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiString IS SUPER self.setData(data)::cGuiString

PROC initUseLeastSpace() OF cGuiString IS SUPER self.initUseLeastSpace()::cGuiString

PROC initMaxLength(maxLength) OF cGuiString
	self.maxLength := Max(maxLength,256)
ENDPROC self

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiString IS SUPER self.setPopupHint(popupHint)::cGuiString

PROC setGhosted(ghosted:BOOL) OF cGuiString IS SUPER self.setGhosted(ghosted)::cGuiString

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiString IS SUPER self.setNotifyFunction(func)::cGuiString

PROC setState(string:ARRAY OF CHAR) OF cGuiString IS SUPER self.setState(string)::cGuiString

/*****************************/

CLASS cGuiStringBox ABSTRACT OF cGuiStringItem
	fixedFont:BOOL
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiStringBox
	self.initLabel(label)
	self.default := NEW ''
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiStringBox IS SUPER self.setData(data)::cGuiStringBox

PROC initFixedFont() OF cGuiStringBox
	self.fixedFont := TRUE
ENDPROC self

PROC infoFixedFont() OF cGuiStringBox RETURNS fixedFont:BOOL IS self.fixedFont

PROC initUseLeastSpace() OF cGuiStringBox IS SUPER self.initUseLeastSpace()::cGuiStringBox

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiStringBox IS SUPER self.setPopupHint(popupHint)::cGuiStringBox

PROC setGhosted(ghosted:BOOL) OF cGuiStringBox IS SUPER self.setGhosted(ghosted)::cGuiStringBox

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiStringBox IS SUPER self.setNotifyFunction(func)::cGuiStringBox

PROC setState(string:ARRAY OF CHAR) OF cGuiStringBox IS SUPER self.setState(string)::cGuiStringBox

/*****************************/

CLASS cGuiPathString ABSTRACT OF cGuiStringItem
	->default:OWNS STRING
	
	onlyShowFolders:BOOL
	useSaveMode    :BOOL
	showSystemFiles:BOOL
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR) OF cGuiPathString
	self.initLabel(label)
	self.default := NEW ''
	
	self.onlyShowFolders := FALSE
	self.useSaveMode     := FALSE
	self.showSystemFiles := FALSE
	
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiPathString IS SUPER self.setData(data)::cGuiPathString

PROC initOnlyShowFolders() OF cGuiPathString
	self.onlyShowFolders := TRUE
ENDPROC self

PROC initUseSaveMode() OF cGuiPathString
	self.useSaveMode     := TRUE
ENDPROC self

PROC initShowSystemFiles() OF cGuiPathString
	self.showSystemFiles := TRUE
ENDPROC self

PROC infoOnlyShowFolders() OF cGuiPathString RETURNS onlyShowFolders:BOOL IS self.onlyShowFolders

PROC infoUseSaveMode() OF cGuiPathString RETURNS useSaveMode:BOOL IS self.useSaveMode

PROC infoShowSystemFiles() OF cGuiPathString RETURNS showSystemFiles:BOOL IS self.showSystemFiles

PROC initUseLeastSpace() OF cGuiPathString IS SUPER self.initUseLeastSpace()::cGuiPathString

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiPathString IS SUPER self.setPopupHint(popupHint)::cGuiPathString

PROC setGhosted(ghosted:BOOL) OF cGuiPathString IS SUPER self.setGhosted(ghosted)::cGuiPathString

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiPathString IS SUPER self.setNotifyFunction(func)::cGuiPathString

PROC setState(string:ARRAY OF CHAR) OF cGuiPathString IS SUPER self.setState(string)::cGuiPathString

/*****************************/

CLASS cGuiNumberItem ABSTRACT OF cGuiInputItem
	default
	min
	max
	unit:OWNS STRING
ENDCLASS

PROC end() OF cGuiNumberItem
	END self.unit
	SUPER self.end()
ENDPROC

PROC initUnit(unit:ARRAY OF CHAR) OF cGuiNumberItem
	END self.unit
	self.unit := StrJoin(unit) ; IF EstrLen(self.unit) = 0 THEN END self.unit
ENDPROC self

PROC infoUnit() OF cGuiNumberItem RETURNS unit:ARRAY OF CHAR IS self.unit

PROC getState() OF cGuiNumberItem RETURNS number IS EMPTY

PROC setState(number) OF cGuiNumberItem IS self

PROC infoMin() OF cGuiNumberItem RETURNS min IS self.min

PROC infoMax() OF cGuiNumberItem RETURNS max IS self.max

/*****************************/

CLASS cGuiNumberString ABSTRACT OF cGuiNumberItem
	->default
	->min
	->max
	->unit:OWNS STRING
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR, min, max) OF cGuiNumberString
	self.initLabel(label)
	self.default := 0
	self.min     := min
	self.max     := max
	self.unit    := NILS
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiNumberString IS SUPER self.setData(data)::cGuiNumberString

PROC initUseLeastSpace() OF cGuiNumberString IS SUPER self.initUseLeastSpace()::cGuiNumberString

PROC initUnit(unit:ARRAY OF CHAR) OF cGuiNumberString IS SUPER self.initUnit(unit)::cGuiNumberString

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiNumberString IS SUPER self.setPopupHint(popupHint)::cGuiNumberString

PROC setGhosted(ghosted:BOOL) OF cGuiNumberString IS SUPER self.setGhosted(ghosted)::cGuiNumberString

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiNumberString IS SUPER self.setNotifyFunction(func)::cGuiNumberString

PROC setState(number) OF cGuiNumberString IS self

/*****************************/

CLASS cGuiSlider ABSTRACT OF cGuiNumberItem
	->default
	->min
	->max
	->unit:OWNS STRING
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR, min, max) OF cGuiSlider
	self.initLabel(label)
	self.default := min
	self.min     := min
	self.max     := max
	self.unit    := NILS
	self.initShared()
ENDPROC
PUBLIC

PROC setData(data) OF cGuiSlider IS SUPER self.setData(data)::cGuiSlider

PROC initUseLeastSpace() OF cGuiSlider IS SUPER self.initUseLeastSpace()::cGuiSlider

PROC initUnit(unit:ARRAY OF CHAR) OF cGuiSlider IS SUPER self.initUnit(unit)::cGuiSlider

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiSlider IS SUPER self.setPopupHint(popupHint)::cGuiSlider

PROC setGhosted(ghosted:BOOL) OF cGuiSlider IS SUPER self.setGhosted(ghosted)::cGuiSlider

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiSlider IS SUPER self.setNotifyFunction(func)::cGuiSlider

PROC setState(number) OF cGuiSlider IS self

/*****************************/

CLASS cGuiChoiceItem ABSTRACT OF cGuiNumberItem
	->default
	->min
	->max
	choices:ARRAY OF ARRAY OF CHAR
ENDCLASS

PRIVATE
PROC new(label:ARRAY OF CHAR, stringChoices:ARRAY OF ARRAY OF CHAR) OF cGuiChoiceItem
	DEF i
	
	self.initLabel(label)
	self.default := 0
	self.min     := 0
	->self.max
	self.choices := stringChoices
	self.initShared()
	
	i := 0
	WHILE stringChoices[i] <> NILA DO i++
	self.max := i
ENDPROC
PUBLIC

PROC getState() OF cGuiChoiceItem RETURNS choice IS EMPTY

PROC setState(choice) OF cGuiChoiceItem IS self

PROC infoChoices() OF cGuiChoiceItem RETURNS choices:ARRAY OF ARRAY OF CHAR IS self.choices

/*****************************/

CLASS cGuiCycleChoice ABSTRACT OF cGuiChoiceItem
ENDCLASS

PROC setData(data) OF cGuiCycleChoice IS SUPER self.setData(data)::cGuiCycleChoice

PROC initUseLeastSpace() OF cGuiCycleChoice IS SUPER self.initUseLeastSpace()::cGuiCycleChoice

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiCycleChoice IS SUPER self.setPopupHint(popupHint)::cGuiCycleChoice

PROC setGhosted(ghosted:BOOL) OF cGuiCycleChoice IS SUPER self.setGhosted(ghosted)::cGuiCycleChoice

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiCycleChoice IS SUPER self.setNotifyFunction(func)::cGuiCycleChoice

PROC setState(choice) OF cGuiCycleChoice IS self

/*****************************/

CLASS cGuiRadioChoice ABSTRACT OF cGuiChoiceItem
ENDCLASS

PROC setData(data) OF cGuiRadioChoice IS SUPER self.setData(data)::cGuiRadioChoice

PROC initUseLeastSpace() OF cGuiRadioChoice IS SUPER self.initUseLeastSpace()::cGuiRadioChoice

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiRadioChoice IS SUPER self.setPopupHint(popupHint)::cGuiRadioChoice

PROC setGhosted(ghosted:BOOL) OF cGuiRadioChoice IS SUPER self.setGhosted(ghosted)::cGuiRadioChoice

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiRadioChoice IS SUPER self.setNotifyFunction(func)::cGuiRadioChoice

PROC setState(choice) OF cGuiRadioChoice IS self

/*****************************/

CLASS cGuiNativeItem ABSTRACT OF cGuiItem
ENDCLASS

/* ->obsolete
PROC queryExtra(specific:QUAD) OF cGuiNativeItem RETURNS value, unknown:BOOL IS EMPTY

PROC changeExtra(specific:QUAD, value) OF cGuiNativeItem RETURNS success:BOOL, unknown:BOOL IS EMPTY
*/

PROC setData(data) OF cGuiNativeItem IS SUPER self.setData(data)::cGuiNativeItem

/*****************************/

CLASS cGuiNativeSimple ABSTRACT OF cGuiNativeItem
ENDCLASS

->PROTECTED
PROC newL(params:ILIST) OF cGuiNativeSimple IS EMPTY
PUBLIC

PROC getState() OF cGuiNativeSimple RETURNS state IS EMPTY

PROC setState(state) OF cGuiNativeSimple IS EMPTY

/*****************************/

CLASS cGuiWindow ABSTRACT OF cAppResource
	root :OWNS PTR TO cGuiGroupItem
	group:     PTR TO cGuiGroupItem		->current group
	list :     PTR TO cGuiList			->current list (takes precedence over current group)
	listGroup: PTR TO cGuiGroupItem
	x, y, posSet:BOOL
	width, height
	allowDropFiles:BOOL
	saveID
	PRIVATE
	closeRequest:BOOL
	lastChangedItem:PTR TO cGuiItem
ENDCLASS

->PROTECTED

PROC new(title:ARRAY OF CHAR) OF cGuiWindow
	self.root  := NIL
	self.group := NIL
	self.list  := NIL
	self.posSet := FALSE
	self.width  := -1
	self.height := -1
	self.allowDropFiles := FALSE
	self.saveID := 0
	
	self.closeRequest := FALSE
	self.lastChangedItem := NIL
ENDPROC

PUBLIC

PROC end() OF cGuiWindow
	END self.root
	->  self.group
	->  self.list
	SUPER self.end()
ENDPROC

PROC initAllowDropFiles() OF cGuiWindow
	self.allowDropFiles := TRUE
ENDPROC self

PROC infoAllowDropFiles() OF cGuiWindow RETURNS allowDropFiles:BOOL IS self.allowDropFiles

->NOTE: "id" must NOT be 0.
PROC initSaveID(id) OF cGuiWindow
	IF id = 0 THEN Throw("EMU", 'cGuiWindow.initSaveID(); "id" cannot be 0')
	self.saveID := id
ENDPROC self

->returns 0 if no ID has been set
PROC infoSaveID() OF cGuiWindow RETURNS id IS self.saveID

PROC beginGroupHorizontal(borderTitle=NILA:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiGroupHorizontal
	DEF newGroup:OWNS PTR TO cGuiGroupHorizontal
	newGroup := self.makeGroupHorizontal()
	newGroup.new(borderTitle)
	item := newGroup
	self.beginGroup(PASS newGroup)
ENDPROC

PROC beginGroupVertical(borderTitle=NILA:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiGroupVertical
	DEF newGroup:OWNS PTR TO cGuiGroupVertical
	newGroup := self.makeGroupVertical()
	newGroup.new(borderTitle)
	item := newGroup
	self.beginGroup(PASS newGroup)
ENDPROC

PROC beginGroupGrid(width, borderTitle=NILA:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiGroupGrid
	DEF newGroup:OWNS PTR TO cGuiGroupGrid
	newGroup := self.makeGroupGrid()
	newGroup.new(borderTitle, width)
	item := newGroup
	self.beginGroup(PASS newGroup)
ENDPROC

PROC beginGroupPage(borderTitle=NILA:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiGroupPage
	DEF newGroup:OWNS PTR TO cGuiGroupPage
	newGroup := self.makeGroupPage()
	newGroup.new(borderTitle)
	item := newGroup
	self.beginGroup(PASS newGroup)
ENDPROC

PROC infoRootGroup() OF cGuiWindow RETURNS root:PTR TO cGuiGroupItem IS self.root

PRIVATE

PROC beginGroup(newGroup:OWNS PTR TO cGuiGroupItem) OF cGuiWindow
	DEF group:PTR TO cGuiGroupItem
	
	group := newGroup
	->IF (group.border = FALSE) AND (group.title <> NILA) THEN Throw("EMU", 'cGuiWindow.beginGroup(); a group title requires border=TRUE')
	
	IF self.root = NIL
		self.root := PASS newGroup
	ELSE
		IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.beginGroup(); a window can only have one root group')
		self.group.add(PASS newGroup)
	ENDIF
	self.group := group
ENDPROC

PUBLIC

PROC endGroup() OF cGuiWindow
	DEF node:PTR TO cGuiItem
	
	IF self.list        THEN Throw("EMU", 'cGuiWindow.endGroup(); must close the list first')
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.endGroup(); already closed all groups')
	self.group.groupWasClosed()
	
	IF self.group.useLeastSpace
		->tell all of group's (output/group) items to use least space
		node := self.group.head
		WHILE node
			IF node.IsOfClassType(TYPEOF cGuiOutputItem)
				node::cGuiOutputItem.initUseLeastSpace()
				
			ELSE IF node.IsOfClassType(TYPEOF cGuiGroupItem)
				node::cGuiGroupItem.initUseLeastSpace()
			ENDIF
			
			node := node.next
		ENDWHILE
	ENDIF
	
	self.group := self.group.internalParent()
ENDPROC

PROC addBreak() OF cGuiWindow ->RETURNS item:PTR TO cGuiBreak
	DEF newItem:OWNS PTR TO cGuiBreak
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addBreak(); must be done inside a group')
	
	newItem := self.makeBreak()
	newItem.new()
	->item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addBar(title=NILA:ARRAY OF CHAR) OF cGuiWindow ->RETURNS item:PTR TO cGuiBar
	DEF newItem:OWNS PTR TO cGuiBar
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addBar(); must be done inside a group')
	IF title
		IF self.group.IsOfClassType(TYPEOF cGuiGroupHorizontal) THEN Throw("EMU", 'cGuiWindow.addBar(); a title does not make sense in a horizontal group (for a vertical bar)')
	ENDIF
	
	newItem := self.makeBar()
	newItem.new(title)
	->item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addLabel(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiLabel
	DEF newItem:OWNS PTR TO cGuiLabel
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addLabel(); must be done inside a group')
	
	newItem := self.makeLabel()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addText(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiText
	DEF newItem:OWNS PTR TO cGuiText
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addText(); must be done inside a group')
	
	newItem := self.makeText()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addTextBox(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiTextBox
	DEF newItem:OWNS PTR TO cGuiTextBox
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addTextBox(); must be done inside a group')
	
	newItem := self.makeTextBox()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addButton(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiButton
	DEF newItem:OWNS PTR TO cGuiButton
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addButton(); must be done inside a group')
	
	newItem := self.makeButton()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addTick(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiTick
	DEF newItem:OWNS PTR TO cGuiTick
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addTick(); must be done inside a group')
	
	newItem := self.makeTick()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addString(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiString
	DEF newItem:OWNS PTR TO cGuiString
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addString(); must be done inside a group')
	
	newItem := self.makeString()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addStringBox(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiStringBox
	DEF newItem:OWNS PTR TO cGuiStringBox
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addStringBox(); must be done inside a group')
	
	newItem := self.makeStringBox()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addPathString(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiPathString
	DEF newItem:OWNS PTR TO cGuiPathString
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addPathString(); must be done inside a group')
	
	newItem := self.makePathString()
	newItem.new(label)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addNumberString(label:ARRAY OF CHAR, min, max) OF cGuiWindow RETURNS item:PTR TO cGuiNumberString
	DEF newItem:OWNS PTR TO cGuiNumberString
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addNumberString(); must be done inside a group')
	
	newItem := self.makeNumberString()
	newItem.new(label, min, max)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addSlider(label:ARRAY OF CHAR, min, max) OF cGuiWindow RETURNS item:PTR TO cGuiSlider
	DEF newItem:OWNS PTR TO cGuiSlider
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addSlider(); must be done inside a group')
	
	newItem := self.makeSlider()
	newItem.new(label, min, max)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addCycleChoice(label:ARRAY OF CHAR, stringChoices:ARRAY OF ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiCycleChoice
	DEF newItem:OWNS PTR TO cGuiCycleChoice
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addCycleChoice(); must be done inside a group')
	
	newItem := self.makeCycleChoice()
	newItem.new(label, stringChoices)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addRadioChoice(label:ARRAY OF CHAR, stringChoices:ARRAY OF ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiRadioChoice
	DEF newItem:OWNS PTR TO cGuiRadioChoice
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addRadioChoice(); must be done inside a group')
	
	newItem := self.makeRadioChoice()
	newItem.new(label, stringChoices)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addNative(newItem:OWNS PTR TO cGuiNativeItem) OF cGuiWindow RETURNS item:PTR TO cGuiNativeItem
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addNative(); must be done inside a group')
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC addNativeSimpleL(params:ILIST) OF cGuiWindow RETURNS item:PTR TO cGuiNativeSimple
	DEF newItem:OWNS PTR TO cGuiNativeSimple
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addNativeSimpleL(); must be done inside a group')
	
	newItem := self.makeNativeSimple()
	newItem.newL(params)
	item := newItem
	self.group.add(PASS newItem)
ENDPROC

PROC infoCurrentBuildGroup() OF cGuiWindow RETURNS item:PTR TO cGuiGroupItem IS self.group

->PROC infoCurrentBuildList() OF cGuiWindow RETURNS list:PTR TO cGuiList IS self.list

PROC build(keepWindowClosed=FALSE:BOOL) OF cGuiWindow IS EMPTY

PROC open() OF cGuiWindow
	self.setCloseRequest(FALSE)
ENDPROC

PROC close() OF cGuiWindow IS EMPTY

PROC infoIsOpen() OF cGuiWindow RETURNS isOpen:BOOL IS EMPTY

PROC infoTitle() OF cGuiWindow RETURNS title:ARRAY OF CHAR IS EMPTY

PROC getLastChangedItem() OF cGuiWindow RETURNS item:PTR TO cGuiItem IS self.lastChangedItem

PROC setLastChangedItem(item:PTR TO cGuiItem) OF cGuiWindow
	self.lastChangedItem := item
ENDPROC

PROC getCloseRequest(doNotClear=FALSE:BOOL) OF cGuiWindow RETURNS closeRequest:BOOL
	closeRequest := self.closeRequest
	IF doNotClear = FALSE THEN self.closeRequest := FALSE
ENDPROC

PROC setCloseRequest(closeRequest:BOOL) OF cGuiWindow
	self.closeRequest := closeRequest
ENDPROC

PROC getQuitRequest(doNotClear=FALSE:BOOL) OF cGuiWindow RETURNS quitRequest:BOOL IS EMPTY

PROC setQuitRequest(quitRequest:BOOL) OF cGuiWindow IS EMPTY

PROC getDroppedFile(doNotClear=FALSE:BOOL) OF cGuiWindow RETURNS fileDropped:ARRAY OF CHAR IS EMPTY

PROC setDroppedFile(fileDropped:ARRAY OF CHAR) OF cGuiWindow IS EMPTY

/*
PROC setGhosted(ghosted:BOOL) OF cGuiWindow
	IF self.root THEN self.root.setGhosted(ghosted)
ENDPROC
*/

PROC getBusy() OF cGuiWindow RETURNS busy:BOOL IS EMPTY

PROC setBusy(busy:BOOL) OF cGuiWindow IS EMPTY

PROC getPosition() OF cGuiWindow RETURNS x, y IS EMPTY

PROC setPosition(x, y) OF cGuiWindow
	self.x := x
	self.y := y
	self.posSet := TRUE
ENDPROC

PROC infoWidth()  OF cGuiWindow RETURNS width  IS EMPTY

PROC infoHeight() OF cGuiWindow RETURNS height IS EMPTY

PROC changeSize(width, height) OF cGuiWindow
	self.width  := width
	self.height := height
ENDPROC

PROC queryExtra(specific:QUAD) OF cGuiWindow RETURNS value, unknown:BOOL IS EMPTY

->PROTECTED

PROC makeGroupHorizontal() OF cGuiWindow RETURNS item:OWNS PTR TO cGuiGroupHorizontal IS EMPTY
PROC makeGroupVertical()   OF cGuiWindow RETURNS item:OWNS PTR TO cGuiGroupVertical   IS EMPTY
PROC makeGroupGrid()       OF cGuiWindow RETURNS item:OWNS PTR TO cGuiGroupGrid       IS EMPTY
PROC makeGroupPage()       OF cGuiWindow RETURNS item:OWNS PTR TO cGuiGroupPage       IS EMPTY
PROC makeBreak()        OF cGuiWindow RETURNS item:OWNS PTR TO cGuiBreak        IS EMPTY
PROC makeBar()          OF cGuiWindow RETURNS item:OWNS PTR TO cGuiBar          IS EMPTY
PROC makeLabel()        OF cGuiWindow RETURNS item:OWNS PTR TO cGuiLabel        IS EMPTY
PROC makeText()         OF cGuiWindow RETURNS item:OWNS PTR TO cGuiText         IS EMPTY
PROC makeTextBox()      OF cGuiWindow RETURNS item:OWNS PTR TO cGuiTextBox      IS EMPTY
PROC makeButton()       OF cGuiWindow RETURNS item:OWNS PTR TO cGuiButton       IS EMPTY
PROC makeTick()         OF cGuiWindow RETURNS item:OWNS PTR TO cGuiTick         IS EMPTY
PROC makeString()       OF cGuiWindow RETURNS item:OWNS PTR TO cGuiString       IS EMPTY
PROC makeStringBox()    OF cGuiWindow RETURNS item:OWNS PTR TO cGuiStringBox    IS EMPTY
PROC makePathString()   OF cGuiWindow RETURNS item:OWNS PTR TO cGuiPathString   IS EMPTY
PROC makeNumberString() OF cGuiWindow RETURNS item:OWNS PTR TO cGuiNumberString IS EMPTY
PROC makeSlider()       OF cGuiWindow RETURNS item:OWNS PTR TO cGuiSlider       IS EMPTY
PROC makeCycleChoice()  OF cGuiWindow RETURNS item:OWNS PTR TO cGuiCycleChoice  IS EMPTY
PROC makeRadioChoice()  OF cGuiWindow RETURNS item:OWNS PTR TO cGuiRadioChoice  IS EMPTY
PROC makeNativeSimple() OF cGuiWindow RETURNS item:OWNS PTR TO cGuiNativeSimple IS EMPTY
PROC makeList()         OF cGuiWindow RETURNS item:OWNS PTR TO cGuiList         IS EMPTY

PUBLIC

/*---------------------------*/

PROC beginFixedList(columns=1, borderTitle=NILA:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiFixedList
	DEF newList:OWNS PTR TO cGuiFixedList
	
	IF columns < 1 THEN Throw("EMU", 'cGuiFixedList.beginFixedList(); columns<1')
	
	NEW newList.new(self, columns, borderTitle)
	item := newList
	self.beginGroup(PASS newList)
ENDPROC

->NOTE: Returns item=NIL for non-selectable entries.
PROC addFixedListEntry(label:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiFixedListEntry
	DEF newItem:OWNS PTR TO cGuiFixedListEntry, list:PTR TO cGuiFixedList
	DEF column:OWNS STRING, pos, len, start, maxColumns, colNum, guiLabel:PTR TO cGuiLabel
	
	IF self.group = NIL THEN Throw("EMU", 'cGuiWindow.addFixedListEntry(); must be done inside a list')
	IF self.group.IsSameClassTypeAs(TYPEOF cGuiFixedList) = FALSE THEN Throw("EMU", 'cGuiWindow.addFixedListEntry(); must be done inside a list')
	
	list := self.group::cGuiFixedList
	
	->add titles if not done so already
	IF list.columnTitles
		column := PASS list.columnTitles
		list.columnTitlesBeingAdded := TRUE
		self.addFixedListEntry(column).initStyle(GUI_STYLE_ALTCOLOUR)
		list.columnTitlesBeingAdded := FALSE
		END column
	ENDIF
	
	->extract first column
	len := StrLen(label)
	
	start := 0
	pos := InStr(label, '\t', start)
	IF pos = -1 THEN pos := len
	NEW column[Max(1,pos-start)] ; StrCopy(column, label, pos-start, start)
	
	->add fixed list entry, which will contain the tick box (if any)
	NEW newItem.new(self, column, label, list)
	item := IF list.infoSelectableEntries() OR list.columnTitlesBeingAdded THEN newItem ELSE NIL
	self.group.add(PASS newItem)
	
	IF list.infoColumns() <> 1
		->(the cGuiFixedListEntry item contains this label when columns=1, so we don't need to add it in that case)
		guiLabel := self.addLabel(column)
		->guiLabel.initUseLeastSpace()
		SELECT list.columnAlignment[0]
		CASE "L" ; guiLabel.initAlignLeft()
		CASE "C" ; guiLabel.initAlignCenter()
		CASE "R" ; guiLabel.initAlignRight()
		ENDSELECT
	ENDIF
	
	->extract & add any remaining columns
	maxColumns := list.infoColumns()
	FOR colNum := 2 TO maxColumns
		IF pos < len
			start := pos+1
			pos := InStr(label, '\t', start)
			IF pos = -1 THEN pos := len
		ELSE
			start := pos
		ENDIF
		END column
		NEW column[Max(1,pos-start)] ; StrCopy(column, label, pos-start, start)
		
		guiLabel := self.addLabel(column)
		->guiLabel.initUseLeastSpace()
		SELECT list.columnAlignment[colNum-1]
		CASE "L" ; guiLabel.initAlignLeft()
		CASE "C" ; guiLabel.initAlignCenter()
		CASE "R" ; guiLabel.initAlignRight()
		ENDSELECT
	ENDFOR
FINALLY
	END newItem
	END column
ENDPROC

PROC endFixedList() OF cGuiWindow
	self.endGroup()
ENDPROC

/*---------------------------*/

PROC beginList(columns=1, title=NILA:ARRAY OF CHAR) OF cGuiWindow RETURNS item:PTR TO cGuiList
	DEF newList:OWNS PTR TO cGuiList
	
	IF self.group = NIL THEN Throw("EMU", 'cGuiList.beginList(); must be done inside a group')
	IF columns < 1 THEN Throw("EMU", 'cGuiList.beginList(); columns<1')
	
	newList := self.makeList()
	newList.new(self, columns, title)
	item := newList
	self.group.add(PASS newList)
	
	self.list := item
	self.listGroup := self.group
	self.group := NIL	->prevent any more items being added to the group, until the list is finished
ENDPROC

PROC addListEntry(label:ARRAY OF CHAR, style=GUI_STYLE_NONE, marked=FALSE:BOOL, data=0, dataBox=NIL:OWNS PTR TO class) OF cGuiWindow
	IF self.list = NIL THEN Throw("EMU", 'cGuiWindow.addListEntry(); there is no list being defined')
	self.list.addEntry(StrJoin(label), style, marked, data, PASS dataBox)
ENDPROC

PROC endList() OF cGuiWindow
	IF self.list = NIL THEN Throw("EMU", 'cGuiWindow.endList(); there is no list being defined')
	self.group := self.listGroup	->allow more items to be added to the current group
	self.listGroup := NIL
	self.list := NIL
ENDPROC

/*****************************/

PROC CreateGuiWindow(title:ARRAY OF CHAR) RETURNS win:PTR TO cGuiWindow PROTOTYPE IS EMPTY

PROC DestroyGuiWindow(win:PTR TO cGuiWindow) RETURNS nil:PTR TO cGuiWindow PROTOTYPE IS EMPTY

PROC CheckForChangedGuiItem(keepPreviousChangedItems=FALSE:BOOL) RETURNS item:PTR TO cGuiItem, win:PTR TO cGuiWindow PROTOTYPE IS EMPTY

->NOTE: Returns item=NIL if a window event (such a close request) has occured.
PROC WaitForChangedGuiItem() RETURNS item:PTR TO cGuiItem, win:PTR TO cGuiWindow PROTOTYPE IS EMPTY

/*****************************/

PRIVATE

->this class acts as a proxy for the contained group
CLASS cGuiContainerItem OF cGuiGroupItem	->this should inherit the same type it contains, so that it is always treated the same way
	group:OWNS PTR TO      cGuiGroupItem
ENDCLASS

PUBLIC

PROC end() OF cGuiContainerItem
	END self.group
	SUPER self.end()
ENDPROC

PROC initShared() OF cGuiContainerItem
	self.group.initShared()
ENDPROC

PROC shared(id, params=NILL:ILIST) OF cGuiContainerItem RETURNS result
	result := self.group.shared(id, params)
ENDPROC

->PROTECTED

PROC add(item:OWNS PTR TO cGuiItem) OF cGuiContainerItem IS self.group.add(PASS item)

PUBLIC

PROC internalShared() OF cGuiContainerItem IS self.group.internalShared()

PROC internalInitParent(parent:PTR TO cGuiGroupItem) OF cGuiContainerItem IS self.group.internalInitParent(parent)

PROC internalParent() OF cGuiContainerItem IS self.group.internalParent()

PROC internalGetSeqItem() OF cGuiContainerItem IS self.group.internalGetSeqItem()

PROC internalSetSeqItem(seqItem:PTR TO cGuiItem) OF cGuiContainerItem IS self.group.internalSetSeqItem(seqItem)

/*****************************/

CLASS cGuiContainerInputItem OF cGuiContainerItem
	ghosted:BOOL
	func:PTR TO funcGuiNotify
ENDCLASS

->PROTECTED

PROC notifyStateHasChanged() OF cGuiContainerInputItem
	IF self.func THEN self.func(self)
ENDPROC

PUBLIC

PROC getGhosted() OF cGuiContainerInputItem RETURNS ghosted:BOOL IS self.ghosted

PROC setGhosted(ghosted:BOOL) OF cGuiContainerInputItem
	self.ghosted := ghosted
	
	self.group.setGhosted(ghosted)
ENDPROC self

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiContainerInputItem
	self.func := func
ENDPROC self

PROC getNotifyFunction() OF cGuiContainerInputItem RETURNS func:PTR TO funcGuiNotify IS self.func

/*****************************/

CLASS cGuiFixedList UNGENERIC OF cGuiContainerItem
	columns
	columnAlignment:OWNS STRING
	columnTitles   :OWNS STRING
	columnTitlesBeingAdded:BOOL
	
	selectable :BOOL
	multiSelect:BOOL
	lastSelectedEntry:PTR TO cGuiFixedListEntry
	selectionCount
ENDCLASS

PRIVATE
PROC new(win:PTR TO cGuiWindow, columns=1, borderTitle=NILA:ARRAY OF CHAR) OF cGuiFixedList
	DEF i
	
	IF columns = 1
		self.group := win.makeGroupVertical()
		self.group.new(borderTitle)
	ELSE
		self.group := win.makeGroupGrid()
		self.group::cGuiGroupGrid.new(borderTitle, 1 + columns)
	ENDIF
	self.group.initScrollable()
	
	self.columns      := columns
	NEW self.columnAlignment[columns] ; SetStr(self.columnAlignment, columns) ; FOR i := 0 TO columns-1 DO self.columnAlignment[i] := "L"
	self.columnTitles := NILS
	self.columnTitlesBeingAdded := FALSE
	
	self.selectable  := FALSE
	self.multiSelect := FALSE
	self.lastSelectedEntry := NIL
	self.selectionCount    := 0
ENDPROC
PUBLIC

PROC end() OF cGuiFixedList
	END self.columnAlignment
	END self.columnTitles
	SUPER self.end()
ENDPROC

PROC initSelectableEntries(multiSelect=FALSE:BOOL) OF cGuiFixedList
	IF self.infoSize() > 0 THEN Throw("EMU", 'cGuiFixedList.initSelectableEntries(); this cannot be called after entries have been added')
	
	self.selectable  := TRUE
	self.multiSelect := multiSelect
ENDPROC self

PROC initColumnAlignment(alignment:ARRAY OF CHAR) OF cGuiFixedList
	DEF i, len, chara:CHAR
	
	IF self.infoSize() > 0 THEN Throw("EMU", 'cGuiFixedList.initColumnAlignment(); this cannot be called after entries have been added')
	
	len := Min(self.columns, StrLen(alignment))
	FOR i := 0 TO len-1
		chara := alignment[i]
		IF (chara = "L") OR (chara = "C") OR (chara = "R")
			self.columnAlignment[i] := chara
			
		ELSE IF (chara = "l") OR (chara = "c") OR (chara = "r")
			self.columnAlignment[i] := chara + "A" - "a"
		ENDIF
	ENDFOR
ENDPROC self

PROC initColumnTitles(titles:ARRAY OF CHAR) OF cGuiFixedList
	IF self.infoSize() > 0 THEN Throw("EMU", 'cGuiFixedList.initColumnTitles(); this cannot be called after entries have been added')
	
	END self.columnTitles
	self.columnTitles := StrJoin(titles)
ENDPROC self

PROC infoSelectableEntries() OF cGuiFixedList RETURNS selectable:BOOL, multiSelect:BOOL IS self.selectable, self.multiSelect

PROC infoColumnAlignment() OF cGuiFixedList RETURNS alignment:ARRAY OF CHAR IS self.columnAlignment

PROC infoColumnTitles() OF cGuiFixedList RETURNS titles:ARRAY OF CHAR IS self.columnTitles

PROC infoColumns() OF cGuiFixedList RETURNS columns IS self.columns

PROC infoSelectionCount() OF cGuiFixedList RETURNS selectionCount IS self.selectionCount

PROC infoSingleSelectionEntry() OF cGuiFixedList RETURNS item:PTR TO cGuiFixedListEntry
	IF self.selectable = FALSE THEN Throw("EMU", 'cGuiFixedList.infoSingleSelectionEntry(); this does not make sense, as entries are not selectable')
	IF self.multiSelect        THEN Throw("EMU", 'cGuiFixedList.infoSingleSelectionEntry(); this cannot be called when multiSelect=TRUE')
	item := self.lastSelectedEntry
ENDPROC

PROC getMultiSelect() OF cGuiFixedList RETURNS multiSelect:BOOL
	IF self.selectable = FALSE THEN Throw("EMU", 'cGuiFixedList.getMultiSelect(); this does not make sense, as entries are not selectable')
	multiSelect := self.multiSelect
ENDPROC

PROC setMultiSelect(multiSelect:BOOL) OF cGuiFixedList
	DEF item:PTR TO cGuiFixedListEntry
	
	IF self.selectable = FALSE THEN Throw("EMU", 'cGuiFixedList.setMultiSelect(); this does not make sense, as entries are not selectable')
	
	IF self.multiSelect AND NOT multiSelect
		->(multiSelect changing from TRUE to FALSE)
		self.lastSelectedEntry := NIL
		
		IF self.selectionCount > 1
			->(more than one entry is selected) so deselect all entries
			item := self.infoFirstItem()
			WHILE item
				IF item.getState() THEN item.setState(FALSE)
				
				item := item.infoNextInGroup()
			ENDWHILE
			
		ELSE IF self.selectionCount = 1
			->find single selected entry
			item := self.infoFirstItem()
			WHILE item
				IF item.getState() THEN self.lastSelectedEntry := item
				
				item := item.infoNextInGroup()
			ENDWHILE IF self.lastSelectedEntry
		ENDIF
	ENDIF
	
	self.multiSelect := multiSelect
ENDPROC


PROC infoHasBorder() OF cGuiFixedList RETURNS hasBorder:BOOL IS self.group.infoHasBorder()

PROC infoTitle() OF cGuiFixedList RETURNS title:ARRAY OF CHAR IS self.group.infoTitle()

PROC infoSize() OF cGuiFixedList RETURNS size IS self.group.infoSize()

PROC infoFirstItem() OF cGuiFixedList RETURNS item:PTR TO cGuiFixedListEntry IS self.group.infoFirstItem()::cGuiFixedListEntry

PROC infoLastItem() OF cGuiFixedList RETURNS item:PTR TO cGuiFixedListEntry IS self.group.infoLastItem()::cGuiFixedListEntry

PROC setGhosted(ghosted:BOOL) OF cGuiFixedList IS self.group.setGhosted(ghosted)


PROC setData(data) OF cGuiFixedList IS SUPER self.setData(data)::cGuiFixedList


PROC initScrollable() OF cGuiFixedList
	Throw("EMU", 'cGuiFixedList.initScrollable(); this method is not supported')
ENDPROC self

PROC initEqualSizedItems() OF cGuiFixedList
	Throw("EMU", 'cGuiFixedList.initEqualSizedItems(); this method is not supported')
ENDPROC self

PROC infoScrollable() OF cGuiFixedList RETURNS scrollable:BOOL IS TRUE

PROC infoEqualSizedItems() OF cGuiFixedList RETURNS equalSizedItems:BOOL
	Throw("EMU", 'cGuiFixedList.infoEqualSizedItems(); this method is not supported')
ENDPROC

/*****************************/

CLASS cGuiFixedListEntry UNGENERIC OF cGuiContainerInputItem
	list:PTR TO cGuiFixedList
	win :PTR TO cGuiWindow
	
	index
	tick :PTR TO cGuiTick
	label:OWNS STRING
ENDCLASS

PRIVATE
PROC new(win:PTR TO cGuiWindow, entry:ARRAY OF CHAR, wholeLabel:ARRAY OF CHAR, list:PTR TO cGuiFixedList) OF cGuiFixedListEntry
	DEF tick:OWNS PTR TO cGuiTick, label:OWNS PTR TO cGuiLabel
	
	self.group := win.makeGroupHorizontal()		->this must always be created, even when it only contains 1 item, so that this class behaves as a cGuiGroup that it's static inheritance implies
	self.group.new()
	
	self.list := list
	
	self.win  := win
	
	self.index := self.group.infoSize()
	
	IF list.selectable AND NOT list.columnTitlesBeingAdded
		tick := win.makeTick()
		tick.new('')
		tick.setRedirectEventTo(self)
		tick.infoUseLeastSpace()
		self.tick := tick
		self.group.add(PASS tick)
	ENDIF
	
	self.label := StrJoin(wholeLabel)
	
	IF self.list.columns = 1
		label := win.makeLabel()
		label.new(entry)
		->label.initUseLeastSpace()
		SELECT list.columnAlignment[0]
		CASE "L" ; label.initAlignLeft()
		CASE "C" ; label.initAlignCenter()
		CASE "R" ; label.initAlignRight()
		ENDSELECT
		self.group.add(PASS label)
	ENDIF
FINALLY
	END tick, label
ENDPROC
PUBLIC

PROC end() OF cGuiFixedListEntry
	END self.label
	SUPER self.end()
ENDPROC

PROC setData(data) OF cGuiFixedListEntry IS SUPER self.setData(data)::cGuiFixedListEntry

PROC infoNextInGroup() OF cGuiFixedListEntry RETURNS item:PTR TO cGuiFixedListEntry
	DEF temp:PTR TO cGuiItem, count
	
	IF self.list.columns = 1
		item := SUPER self.infoNextInGroup()::cGuiFixedListEntry
	ELSE
		temp := SUPER self.infoNextInGroup()
		
		count := self.list.columns
		WHILE count >= 1
			count--
			temp := temp.infoNextInGroup()
		ENDWHILE IF temp = NIL
		
		IF temp THEN IF temp.IsSameClassTypeAs(TYPEOF cGuiFixedListEntry) = FALSE THEN Throw("BUG", 'cGuiFixedListEntry.infoNextInGroup(); wrong class')
		item := temp::cGuiFixedListEntry
	ENDIF
ENDPROC


PROC infoLabel() OF cGuiFixedListEntry RETURNS label:ARRAY OF CHAR IS self.label

PROC initStyle(style) OF cGuiFixedListEntry
	DEF item:PTR TO cGuiItem, count
	
	IF self.list.columns = 1
		->only handle the first column, which is a horizontal group containing a tick (if any) and a label
		item := self.group.infoFirstItem()
		WHILE item
			IF item.IsOfClassType(TYPEOF cGuiLabel)
				item::cGuiLabel.initStyle(style)
			ENDIF
			
			item := item.infoNextInGroup()
		ENDWHILE
	ELSE
		->handle remaining columns; this mirrors the code in our infoNextInGroup() method
		item := SUPER self.infoNextInGroup()
		
		count := self.list.columns
		WHILE count >= 1
			IF item.IsOfClassType(TYPEOF cGuiLabel)
				item::cGuiLabel.initStyle(style)
			ENDIF
			
			count--
			item := item.infoNextInGroup()
		ENDWHILE IF item = NIL
	ENDIF
ENDPROC self
->obsolete
PROC initAltColour() OF cGuiFixedListEntry IS self.initStyle(GUI_STYLE_ALTCOLOUR)

PROC getState() OF cGuiFixedListEntry RETURNS ticked:BOOL
	ticked := IF self.tick THEN self.tick.getState() ELSE FALSE
ENDPROC

PROC setState(ticked:BOOL) OF cGuiFixedListEntry
	DEF beingBuilt:BOOL, stateChanged:BOOL
	
	IF self.tick = NIL THEN Throw("EMU", 'cGuiFixedListEntry.setState(); list entries are not selectable')
	
	IF beingBuilt := (self.win.group <> NIL) OR (self.win.list <> NIL)
		stateChanged := ticked <> self.tick.getState()
	ENDIF
	
	self.tick.setState(ticked)
	
	IF beingBuilt
		->(GUI is still being built, so no notifications will happen) so ensure no-multi-select mode is handled correctly
		IF stateChanged THEN self.handleSingleSelection()
	ENDIF
ENDPROC self

PROC infoIndex() OF cGuiFixedListEntry RETURNS index IS self.index


->PROTECTED

PROC notifyStateHasChanged() OF cGuiFixedListEntry
	self.handleSingleSelection()
	
	SUPER self.notifyStateHasChanged()
ENDPROC

PRIVATE

PROC handleSingleSelection() OF cGuiFixedListEntry
	DEF list:PTR TO cGuiFixedList, lastSelectedEntry:PTR TO cGuiFixedListEntry
	
	list := self.list
	
	IF self.getState() THEN list.selectionCount++ ELSE list.selectionCount--
	
	IF list.multiSelect = FALSE
		->(only one selection is allowed)
		IF self = list.lastSelectedEntry
			->(user unselected the last entry)
			IF self.getState() THEN Throw("BUG", 'cGuiFixedListEntry.handleSingleSelection(); entry should have been unselected')
			
			list.lastSelectedEntry := NIL
			
		ELSE IF self.getState()
			->(user selected a new entry)
			lastSelectedEntry := list.lastSelectedEntry
			
			list.lastSelectedEntry := self		->change this before setState() might cause us to be called a second time (before we finish our first time)
			
			IF lastSelectedEntry THEN /*old*/ lastSelectedEntry.setState(FALSE)		->automatically unselect the old entry
		ELSE
			->(we automatically unselected the old entry) so do nothing
		ENDIF
	ENDIF
ENDPROC

PUBLIC

/*****************************/

CLASS cGuiList ABSTRACT OF cGuiInputItem
	title:OWNS STRING
	
	columns
	columnTitles   :OWNS STRING
	columnAlignment:OWNS STRING
	columnSortType :OWNS STRING
	
	selectable  :BOOL
	multiSelect :BOOL
	autoUnselect:BOOL
	/*saveID*/
ENDCLASS

->PROTECTED
PROC new(win:PTR TO cGuiWindow, columns=1, title=NILA:ARRAY OF CHAR) OF cGuiList
	DEF i
	
	self.title := IF title THEN StrJoin(title) ELSE NILS
	
	self.columns      := columns
	self.columnTitles := NILS
	NEW self.columnAlignment[columns] ; SetStr(self.columnAlignment, columns) ; FOR i := 0 TO columns-1 DO self.columnAlignment[i] := "L"
	NEW self.columnSortType [columns] ; SetStr(self.columnSortType,  columns) ; FOR i := 0 TO columns-1 DO self.columnSortType [i] := "I"
	
	self.selectable   := FALSE
	self.multiSelect  := FALSE
	self.autoUnselect := FALSE
	/*self.saveID := 0*/
	
	self.initShared()
ENDPROC
PUBLIC

PROC end() OF cGuiList
	END self.title
	END self.columnTitles
	END self.columnAlignment
	END self.columnSortType
	SUPER self.end()
ENDPROC

PROC initSelectableEntries(multiSelect=FALSE:BOOL, autoUnselect=FALSE:BOOL) OF cGuiList
	self.selectable   := TRUE
	self.multiSelect  := multiSelect
	self.autoUnselect := autoUnselect
ENDPROC self

PROC initColumnTitles(titles:ARRAY OF CHAR) OF cGuiList
	END self.columnTitles
	self.columnTitles := StrJoin(titles)
ENDPROC self

PROC initColumnAlignment(alignment:ARRAY OF CHAR) OF cGuiList
	DEF i, len, chara:CHAR
	
	len := Min(self.columns, StrLen(alignment))
	FOR i := 0 TO len-1
		chara := alignment[i]
		IF (chara = "L") OR (chara = "C") OR (chara = "R")
			self.columnAlignment[i] := chara
			
		ELSE IF (chara = "l") OR (chara = "c") OR (chara = "r")
			self.columnAlignment[i] := chara + "A" - "a"
		ENDIF
	ENDFOR
ENDPROC self

PROC initColumnSortType(type:ARRAY OF CHAR) OF cGuiList
	DEF i, len, chara:CHAR
	
	len := Min(self.columns, StrLen(type))
	FOR i := 0 TO len-1
		chara := type[i]
		IF (chara = "I") OR (chara = "S") OR (chara = "N")
			self.columnSortType[i] := chara
			
		ELSE IF (chara = "i") OR (chara = "s") OR (chara = "n")
			self.columnSortType[i] := chara + "A" - "a"
		ENDIF
	ENDFOR
ENDPROC self

/*
->NOTE: "id" must NOT be 0.
PROC initSaveID(id) OF cGuiList
	IF id = 0 THEN Throw("EMU", 'cGuiList.initSaveID(); "id" cannot be 0')
	self.saveID := id
ENDPROC self
*/

PROC infoSelectableEntries() OF cGuiList RETURNS selectable:BOOL, multiSelect:BOOL, autoUnselect:BOOL IS self.selectable, self.multiSelect, self.autoUnselect

PROC infoColumnTitles() OF cGuiList RETURNS titles:ARRAY OF CHAR IS self.columnTitles

PROC infoColumnAlignment() OF cGuiList RETURNS alignment:ARRAY OF CHAR IS self.columnAlignment

PROC infoColumnSortType() OF cGuiList RETURNS type:ARRAY OF CHAR IS self.columnSortType

PROC infoColumns() OF cGuiList RETURNS columns IS self.columns

/*
->returns 0 if no ID has been set
PROC infoSaveID() OF cGuiList RETURNS id IS self.saveID
*/

PROC infoSelectionCount() OF cGuiList RETURNS selectionCount IS EMPTY

PROC infoSingleSelectionEntry() OF cGuiList RETURNS label:STRING IS EMPTY

PROC infoTitle() OF cGuiList RETURNS title:ARRAY OF CHAR IS self.title

PROC infoSize() OF cGuiList RETURNS size IS EMPTY

->adds an entry to the list
->NOTE: The position depends on the list's sorting mode, but it will add it to the bottom of an unsorted list.
->NOTE: "labels" may be a list of linked STRINGs.
->NOTE: This is the only method which can change the contents of the list before it is built.
PROC addEntry(labels:OWNS STRING, style=GUI_STYLE_NONE, marked=FALSE:BOOL, data=0, dataBox=NIL:OWNS PTR TO class, moveCursorToEntry=FALSE:BOOL) OF cGuiList IS EMPTY

FUNC fGuiListEntries() RETURNS label:OWNS STRING, style, marked:BOOL, data, dataBox:OWNS PTR TO class IS EMPTY

->adds to the list entries returned by the supplied function, until it returns labels=NILS
PROC addEntryF(func:PTR TO fGuiListEntries) OF cGuiList IS EMPTY

/* -># original (faster but hard to keep synced with updateF())
PROC update(labels:OWNS STRING) OF cGuiList
	DEF sortFunc:PTR TO fGuiListSort, isSorted:BOOL
	DEF restoreCursorPos, restoreCursorLabel:ARRAY OF CHAR, passedRestoreCursor:BOOL
	DEF oldLabel:ARRAY OF CHAR, newLabel:OWNS STRING, sign:RANGE -1 TO 1
	DEF newNext:OWNS STRING
	
	->check how list is sorted
	IF self.getSortByNone() THEN Throw("EMU", 'cGuiList.update(); list needs to be sorted')
	isSorted, sortFunc := self.getSortByFunction()		->this returns a sorting function even when it is SortByColumn or SortByUser rather than SortByFunction
	IF sortFunc = NIL THEN Throw("BUG", 'cGuiList.update(); unhandled list sort kind')
	
	->temporarily disable visual updates of the list (if supported)
	self.setAutoUpdate(FALSE)
	
	->remember where cursor should be restored to
	restoreCursorLabel := self.cursor_getLabel()
	restoreCursorPos   := self.cursor_walkToStart()
	
	->sort the supplied list, so it matches the sorting used by the current list
	labels := mergeSort(PASS labels, sortFunc)
	
	->compare the two lists, and update our list with the differences
	passedRestoreCursor := FALSE
	oldLabel := IF restoreCursorPos = -1 THEN NILA ELSE self.cursor_getLabel()
	newLabel := PASS labels
	WHILE (oldLabel <> NILA) AND (newLabel <> NILS)
		sign := sortFunc(oldLabel, newLabel)
		IF sign < 0
			->(oldLabel > newLabel, thus newLabel was created) so extract label from supplied list, add it to this list, and move to next one
			IF passedRestoreCursor = FALSE THEN restoreCursorPos++
			
			newNext := LinkReplace(newLabel, NILS)
			self.addEntry(PASS newLabel)
			newLabel := PASS newNext
			
		ELSE IF sign > 0
			->(oldLabel < newLabel, thus oldLabel was removed) so destroy label, and move to next one
			IF passedRestoreCursor = FALSE THEN restoreCursorPos--
			IF oldLabel = restoreCursorLabel THEN restoreCursorLabel  := NILS
			
			IF oldLabel = restoreCursorLabel THEN passedRestoreCursor := TRUE
			oldLabel := IF self.cursor_destroy(/*gotoPrev*/ FALSE) THEN self.cursor_getLabel() ELSE NILA
			
			IF restoreCursorLabel = NILS THEN restoreCursorLabel := oldLabel
		ELSE
			->(oldLabel = newLabel) so see if (non-sorted part of) label has been changed
			IF StrCmp(oldLabel, newLabel) = FALSE
				->(label has been changed) so update it
				self.cursor_setLabel(newLabel)
				IF oldLabel = restoreCursorLabel THEN restoreCursorLabel := self.cursor_getLabel()
			ENDIF
			
			->move to next labels
			IF oldLabel = restoreCursorLabel THEN passedRestoreCursor := TRUE
			oldLabel := IF self.cursor_gotoNext() <> 0 THEN self.cursor_getLabel() ELSE NILA
			
			newNext  := LinkReplace(newLabel, NILS)
			END newLabel
			newLabel := PASS newNext
		ENDIF
	ENDWHILE
	
	->restore cursor location
	self.cursor_gotoStart()
	IF restoreCursorLabel
		self.cursor_gotoNext(restoreCursorPos)	->now (hopefully?) at original cursor position
		IF self.cursor_getLabel() <> restoreCursorLabel THEN Throw("BUG", 'cGuiList.update(); failed to restore cursor location')
	/*
		WHILE sortFunc(restoreCursorLabel, self.cursor_getLabel()) = 0 ; ENDWHILE IF self.cursor_gotoPrev() = 0		->avoid the unlikely possibility of starting in the middle of a group of entries that match, since we would not know whether to go forwards or backwards to find a match
		
		sign := sortFunc(self.cursor_getLabel(), restoreCursorLabel)		->which direction to search (-1=backwards,+1=forwards)
		WHILE self.cursor_getLabel() <> restoreCursorLabel DO IF self.cursor_gotoNext(sign) = 0 THEN Throw("BUG", 'cGuiList.update(); failed to restore cursor location')
	*/
	ENDIF
	
	->re-enable visual updates of the list
	self.setAutoUpdate(TRUE)
FINALLY
	END labels
	END newNext
ENDPROC
*/

PRIVATE
CLASS fEntriesFromStringList OF fGuiListEntries
	labels:OWNS STRING
ENDCLASS
PROC end() OF fEntriesFromStringList
	END self.labels
	SUPER self.end()
ENDPROC
PROC init(labels:OWNS STRING) OF fEntriesFromStringList
	self.labels := PASS labels
ENDPROC
PROC call() OF fEntriesFromStringList RETURNS label:OWNS STRING, style, marked:BOOL, data, dataBox:OWNS PTR TO class
	label := PASS self.labels ; IF label THEN self.labels := LinkReplace(label, NILS)
	style     := GUI_STYLE_NONE
	marked    := FALSE
	data      := 0
	dataBox   := NIL
ENDPROC
PUBLIC

->this replaces the contents of the list with the supplied entries
->NOTE: This keeps any existing entries selected, and may look nicer since it only adds/removes entries that are new/missing.
->NOTE: It is REQUIRED that the list is sorted.
->NOTE: It is assumed that entries which are equal for sorting purposes, are actually the same entry, and thus the un-sorted parts of a label are updated with that given in the new labels.  You can use setSortByFunction() to ensure this makes sense, if setSortByColumn() isn't sufficient.  Use setSortByFunction(fGuiListSort) if the entire label defines a unique entry.
PROC update(labels:OWNS STRING) OF cGuiList
	DEF sortFunc:PTR TO fGuiListSort, isSorted:BOOL
	DEF func:OWNS PTR TO fEntriesFromStringList
	
	->check how list is sorted
	IF self.getSortByNone() THEN Throw("EMU", 'cGuiList.update(); list needs to be sorted')
	isSorted, sortFunc := self.getSortByFunction()		->this returns a sorting function even when it is SortByColumn or SortByUser rather than SortByFunction
	IF sortFunc = NIL THEN Throw("BUG", 'cGuiList.update(); unhandled list sort kind')
	
	->perform request
	NEW func.new()
	func.init(PASS labels)
	self.updateF(func)
FINALLY
	END labels
	END func
ENDPROC

/*->obsolete unoptimised version
PROC updateF(func:PTR TO fGuiListEntries) OF cGuiList
	DEF sortFunc:PTR TO fGuiListSort, isSorted:BOOL
	DEF list:OWNS PTR TO cMegaList_entry, unfinished:BOOL, entry:OWNS PTR TO entry, label:OWNS STRING, style, marked:BOOL, data, dataBox:OWNS PTR TO class
	DEF listSortFunc:OWNS PTR TO fGuiListSortWrapper
	DEF restoreCursorPos, restoreCursorLabel:ARRAY OF CHAR, updateRestoreCursorLabel:BOOL, passedRestoreCursor:BOOL
	DEF sign:RANGE -1 TO 1, oldLabel:ARRAY OF CHAR, newLabel:OWNS STRING, newEntry:PTR TO entry, newCursor:PTR TO cMegaCursor_entry
	
	->check how list is sorted
	IF self.getSortByNone() THEN Throw("EMU", 'cGuiList.updateF(); list needs to be sorted')
	isSorted, sortFunc := self.getSortByFunction()		->this returns a sorting function even when it is SortByColumn or SortByUser rather than SortByFunction
	IF sortFunc = NIL THEN Throw("BUG", 'cGuiList.updateF(); unhandled list sort kind')
	
	->temporarily disable visual updates of the list (if supported)
	self.setAutoUpdate(FALSE)
	
	->remember where cursor should be restored to
	restoreCursorLabel := IF self.infoSize() = 0 THEN NILA ELSE self.cursor_getLabel()
	restoreCursorPos   := IF self.infoSize() = 0 THEN   -1 ELSE self.cursor_walkToStart()
	
	->retrieve the entries from the supplied function & store them in a list
	NEW list.new()
	newCursor := list.infoPastEnd()
	REPEAT
		label, style, marked, data, dataBox := func()
		IF unfinished := label <> NILS
			NEW entry.new(PASS label, style, marked, data, PASS dataBox)
			newCursor.beforeInsert(list.makeNode(PASS entry))
		ENDIF
	UNTIL unfinished = FALSE
	
	->sort the list, so it matches the sorting used by the current list
	NEW listSortFunc.new()
	listSortFunc.init(sortFunc)
	list.sort(listSortFunc)
	
	->compare the two lists, and update our list with the differences
	passedRestoreCursor := (restoreCursorPos = -1)
	
	newCursor := list.infoStart()
	newEntry  := newCursor.read()
	newLabel := IF newEntry THEN PASS newEntry.label ELSE NILS
->Print('@0; restore cursor pos=\d, restore cursor label="\s"\n', restoreCursorPos, restoreCursorLabel)->###
	
	oldLabel := IF self.infoSize() = 0 THEN NILA ELSE self.cursor_getLabel()
	WHILE (oldLabel <> NILA) OR (newLabel <> NILA)
		sign := IF newLabel = NILA THEN 1 ELSE IF oldLabel = NILA THEN -1 ELSE sortFunc(oldLabel, newLabel)
		IF sign < 0
			->(oldLabel > newLabel, thus newLabel was created) so extract label from supplied list, add it to this list, and move to next one
->IF passedRestoreCursor = FALSE THEN Print('@1; cursor pos++, as oldLabel "\s" > newLabel "\s"\n', oldLabel, newLabel)
			IF passedRestoreCursor = FALSE THEN restoreCursorPos++
			
			self.addEntry(PASS newLabel, newEntry.style, newEntry.marked, newEntry.data, PASS newEntry.dataBox)
			
			newCursor.destroy()		->automatically moves to next node
			newEntry := newCursor.read()
			newLabel := IF newEntry THEN PASS newEntry.label ELSE NILS
			
		ELSE IF sign > 0
			->(oldLabel < newLabel, thus oldLabel was removed) so destroy label, and move to next one
->IF passedRestoreCursor = FALSE THEN Print('@2; cursor pos--, as oldLabel "\s" > newLabel "\s"\n', oldLabel, newLabel)
			updateRestoreCursorLabel := (oldLabel = restoreCursorLabel)
			
			IF oldLabel = restoreCursorLabel THEN passedRestoreCursor := TRUE
			IF passedRestoreCursor = FALSE THEN restoreCursorPos--
			oldLabel := IF self.cursor_destroy(/*gotoPrev*/ FALSE) THEN self.cursor_getLabel() ELSE NILA
			
			IF updateRestoreCursorLabel THEN restoreCursorLabel := oldLabel
->IF updateRestoreCursorLabel THEN Print('@2a; CHANGED restore cursor label TO "\s"\n', restoreCursorLabel)
		ELSE
			->(oldLabel = newLabel) so see if (non-sorted part of) label has been changed
			IF oldLabel = restoreCursorLabel THEN passedRestoreCursor := TRUE
			IF StrCmp(oldLabel, newLabel) = FALSE
				->(label has been changed) so update it
				self.cursor_setLabel(newLabel)
				
				IF oldLabel = restoreCursorLabel THEN restoreCursorLabel := self.cursor_getLabel()		-> ; oldLabel := restoreCursorLabel
			ENDIF
			->update all associated data, without checking
			self.cursor_setStyle(       newEntry.style)
			self.cursor_setMarked(      newEntry.marked)
			self.cursor_setData(        newEntry.data)
			self.cursor_setDataBox(PASS newEntry.dataBox)
			
			->move to next labels
			oldLabel := IF self.cursor_gotoNext() <> 0 THEN self.cursor_getLabel() ELSE NILA
			
			END newLabel
			newCursor.destroy()		->automatically moves to next node
			newEntry := newCursor.read()
			newLabel := IF newEntry THEN PASS newEntry.label ELSE NILS
		ENDIF
	ENDWHILE
	
	->restore cursor location
	self.cursor_gotoStart()
	IF restoreCursorLabel
		self.cursor_gotoNext(restoreCursorPos)	->now (hopefully?) at original cursor position
		IF self.cursor_getLabel() <> restoreCursorLabel
			->this probably only happens when the cursor is on an entry which has an identical (sorting) entry in the updated list, such as "Liberation\tFloppy,AGA" vs "Liberation\tClassic,CD32".
			
			->Print('# WARNING: cGuiList.updateF(); failed to restore cursor location\n# DEBUG: cursor label = "\s", restore cursor pos = \d, restore cursor label = "\s"\n', self.cursor_getLabel(), restoreCursorPos, restoreCursorLabel)
			
			WHILE sortFunc(restoreCursorLabel, self.cursor_getLabel()) = 0		->avoid the unlikely possibility of starting in the middle of a group of entries that match, since we would not know whether to go forwards or backwards to find a match
			ENDWHILE IF self.cursor_gotoPrev() = 0
			
			sign := sortFunc(self.cursor_getLabel(), restoreCursorLabel)		->which direction to search (-1=backwards,+1=forwards)
			WHILE self.cursor_getLabel() <> restoreCursorLabel DO IF self.cursor_gotoNext(sign) = 0 THEN Print('# WARNING: cGuiList.updateF(); failed to restore cursor location\n# DEBUG: sign = \d, restore cursor pos = \d, restore cursor label = "\s"\n', sign, restoreCursorPos, restoreCursorLabel)
			->Throw("BUG", 'cGuiList.updateF(); failed to restore cursor location')
		ENDIF
	ENDIF
	
	->re-enable visual updates of the list
	self.setAutoUpdate(TRUE)
FINALLY
	END list, entry, label, dataBox
	END listSortFunc
	END newLabel
ENDPROC
*/

PROC updateF(func:PTR TO fGuiListEntries) OF cGuiList
	DEF sortFunc:PTR TO fGuiListSort, isSorted:BOOL
	DEF list:OWNS PTR TO cMegaList_entry, unfinished:BOOL, entry:OWNS PTR TO entry, label:OWNS STRING, style, marked:BOOL, data, dataBox:OWNS PTR TO class
	DEF listSortFunc:OWNS PTR TO fGuiListSortWrapper
	DEF restoreCursorPos, restoreCursorLabel:ARRAY OF CHAR, restoreCursorData, restoreCursorDataBox:PTR, updateRestoreCursorLabel:BOOL, passedRestoreCursor:BOOL
	DEF sign:RANGE -1 TO 1, oldLabel:ARRAY OF CHAR, newLabel:OWNS STRING, newEntry:PTR TO entry, newCursor:PTR TO cMegaCursor_entry,
	    ownNewCursor:OWNS PTR TO cMegaCursor_entry, funcAdd:OWNS PTR TO fEntriesFromMegaList, abort:BOOL
	
	->check how list is sorted
	IF self.getSortByNone() THEN Throw("EMU", 'cGuiList.updateF(); list needs to be sorted')
	isSorted, sortFunc := self.getSortByFunction()		->this returns a sorting function even when it is SortByColumn or SortByUser rather than SortByFunction
	IF sortFunc = NIL THEN Throw("BUG", 'cGuiList.updateF(); unhandled list sort kind')
	
	->temporarily disable visual updates of the list (if supported)
	self.setAutoUpdate(FALSE)
	
	->remember where cursor should be restored to
	restoreCursorLabel   := IF self.infoSize() = 0 THEN NILA ELSE self.cursor_getLabel()
	restoreCursorData    := IF self.infoSize() = 0 THEN    0 ELSE self.cursor_getData()
	restoreCursorDataBox := IF self.infoSize() = 0 THEN  NIL ELSE self.cursor_getDataBox()
	restoreCursorPos     := IF self.infoSize() = 0 THEN   -1 ELSE self.cursor_walkToStart()		->this effectively performs self.cursor_gotoStart()
	
	->retrieve the entries from the supplied function & store them in a list
	NEW list.new()
	newCursor := list.infoPastEnd()
	REPEAT
		label, style, marked, data, dataBox := func()
		IF unfinished := label <> NILS
			NEW entry.new(PASS label, style, marked, data, PASS dataBox)
			newCursor.beforeInsert(list.makeNode(PASS entry))
		ENDIF
	UNTIL unfinished = FALSE
	
	->sort the list, so it matches the sorting used by the current list
	NEW listSortFunc.new()
	listSortFunc.init(sortFunc)
	list.sort(listSortFunc)
	
	->compare the two lists, and update our list with the differences
	passedRestoreCursor := (restoreCursorPos = -1)
	
	ownNewCursor := list.infoStart().clone(/*ifRemovedThen*/ MC_NEXT)
	newCursor := ownNewCursor
	-># newCursor := list.infoStart()
	newEntry  := newCursor.read()
	newLabel := IF newEntry THEN PASS newEntry.label ELSE NILS
->Print('@0; restore cursor pos=\d, restore cursor label="\s"\n', restoreCursorPos, restoreCursorLabel)->###
	
	oldLabel := IF self.infoSize() = 0 THEN NILA ELSE self.cursor_getLabel()
	WHILE (oldLabel <> NILA) OR (newLabel <> NILA)
		sign := IF newLabel = NILA THEN 1 ELSE IF oldLabel = NILA THEN -1 ELSE sortFunc(oldLabel, newLabel, self.cursor_getData(), newEntry.data, self.cursor_getDataBox(), newEntry.dataBox)
		IF sign < 0
			->(oldLabel > newLabel, thus newLabel was created) so extract label from supplied list, add it to this list, and move to next one
->IF passedRestoreCursor = FALSE THEN Print('@1; cursor pos++, as oldLabel "\s" > newLabel "\s"\n', oldLabel, newLabel)
			IF passedRestoreCursor = FALSE THEN restoreCursorPos++
			
			newEntry.label := PASS newLabel
			->replaced by above for optimisation: self.addEntry(PASS newLabel, newEntry.style, newEntry.marked, newEntry.data, PASS newEntry.dataBox)	->this works as all entries remaining in newList (after all comparisons are done) will be added to the existing list using the native addEntryF() method
			
			newCursor.next()
			->replaced by above for optimisation: newCursor.destroy()		->automatically moves to next node
			newEntry := newCursor.read()
			newLabel := IF newEntry THEN PASS newEntry.label ELSE NILS
			
		ELSE IF sign > 0
			->(oldLabel < newLabel, thus oldLabel was removed) so destroy label, and move to next one
->IF passedRestoreCursor = FALSE THEN Print('@2; cursor pos--, as oldLabel "\s" > newLabel "\s"\n', oldLabel, newLabel)
			updateRestoreCursorLabel := (oldLabel = restoreCursorLabel)
			
			IF oldLabel = restoreCursorLabel THEN passedRestoreCursor := TRUE
			IF passedRestoreCursor = FALSE THEN restoreCursorPos--
			oldLabel := IF self.cursor_destroy(/*gotoPrev*/ FALSE) THEN self.cursor_getLabel() ELSE NILA
			
			IF updateRestoreCursorLabel THEN restoreCursorLabel := oldLabel
->IF updateRestoreCursorLabel THEN Print('@2a; CHANGED restore cursor label TO "\s"\n', restoreCursorLabel)
		ELSE
			->(oldLabel = newLabel) so see if (non-sorted part of) label has been changed
			IF oldLabel = restoreCursorLabel THEN passedRestoreCursor := TRUE
			IF StrCmp(oldLabel, newLabel) = FALSE
				->(label has been changed) so update it
				self.cursor_setLabel(newLabel)
				
				IF oldLabel = restoreCursorLabel THEN restoreCursorLabel := self.cursor_getLabel()		-> ; oldLabel := restoreCursorLabel
			ENDIF
			->update all associated data, without checking
			self.cursor_setStyle(       newEntry.style)
			self.cursor_setMarked(      newEntry.marked)
			self.cursor_setData(        newEntry.data)
			self.cursor_setDataBox(PASS newEntry.dataBox)
			
			->move to next labels
			oldLabel := IF self.cursor_gotoNext() <> 0 THEN self.cursor_getLabel() ELSE NILA
			
			END newLabel
			newCursor.destroy()		->automatically moves to next node
			newEntry := newCursor.read()
			newLabel := IF newEntry THEN PASS newEntry.label ELSE NILS
		ENDIF
	ENDWHILE
	->(any entries remaining in the (mega)list should all be added to this list GUI) this is an optimisation
	IF list.infoIsEmpty() = FALSE
		newCursor.goto(list.infoStart())
		
		NEW funcAdd.new()
		funcAdd.init(newCursor)
		self.addEntryF(funcAdd)		->beware that this could change position of self.cursor
	ENDIF
	
	->restore cursor location
	self.cursor_gotoStart()
	IF restoreCursorLabel
		self.cursor_gotoNext(restoreCursorPos)	->now (hopefully?) at original cursor position
		IF self.cursor_getLabel() <> restoreCursorLabel
			->this probably only happens when the cursor is on an entry which has an identical (sorting) entry in the updated list, such as "Liberation\tFloppy,AGA" vs "Liberation\tClassic,CD32".
			
			IF self.infoSize() = 0 THEN Print('# WARNING: cGuiList.updateF(); infoSize()=0 now, cursor_getLabel()="\s"\n', self.cursor_getLabel())
			->Print('# WARNING: cGuiList.updateF(); failed to restore cursor location\n# DEBUG: cursor label = "\s", restore cursor pos = \d, restore cursor label = "\s"\n', self.cursor_getLabel(), restoreCursorPos, restoreCursorLabel)
			
			WHILE sortFunc(restoreCursorLabel, self.cursor_getLabel(), restoreCursorData, self.cursor_getData(), restoreCursorDataBox, self.cursor_getDataBox()) = 0		->avoid the possibility of starting in the middle of a group of entries that match, since we would not know whether to go forwards or backwards to find a match
			ENDWHILE IF self.cursor_gotoPrev() = 0
			
			abort := FALSE
			sign := sortFunc(self.cursor_getLabel(), restoreCursorLabel, self.cursor_getData(), restoreCursorData, self.cursor_getDataBox(), restoreCursorDataBox)		->which direction to search (-1=backwards,+1=forwards)
			IF sign = 0 THEN Print('# WARNING: cGuiList.updateF(); sign=0 (now fixed)\n')
			IF sign = 0 THEN sign := 1		->handle unlikely case where started in a group of entries that match AND which begin the list
			WHILE self.cursor_getLabel() <> restoreCursorLabel
				IF self.cursor_gotoNext(sign) = 0
					Print('# WARNING: cGuiList.updateF(); failed to restore cursor location\n# DEBUG: sign = \d, restore cursor pos = \d (infoSize=\d), restore cursor label = "\s"\n', sign, restoreCursorPos, self.infoSize(), restoreCursorLabel) ->BUT Throw("BUG", 'cGuiList.updateF(); failed to restore cursor location')
					abort := TRUE
				ENDIF
			ENDWHILE IF abort
			->failed with:
			-># DEBUG: sign = -1, restore cursor pos = 0
			-># DEBUG: sign = -1, restore cursor pos = 0 (infoSize=129)
			-># DEBUG: sign = -1, restore cursor pos = 19 (infoSize=28)
			-># DEBUG: sign = -1, restore cursor pos = 20 (infoSize=73)
			-># DEBUG: sign = -1, restore cursor pos = 2 (infoSize=16)
			-># DEBUG: sign = -1, restore cursor pos = 0 (infoSize=3)
			-># DEBUG: sign = -1, restore cursor pos = 2 (infoSize=241)
			-># DEBUG: sign = -1, restore cursor pos = 41 (infoSize=215)
		ENDIF
	ENDIF
	
	->re-enable visual updates of the list
	self.setAutoUpdate(TRUE)
FINALLY
	END list, entry, label, dataBox
	END listSortFunc
	END newLabel,
	    ownNewCursor, funcAdd
ENDPROC

PRIVATE
CLASS fEntriesFromMegaList OF fGuiListEntries
	cursor:PTR TO cMegaCursor_entry
ENDCLASS
PROC init(cursor:PTR TO cMegaCursor_entry) OF fEntriesFromMegaList
	self.cursor := cursor
ENDPROC
PROC call() OF fEntriesFromMegaList RETURNS label:OWNS STRING, style, marked:BOOL, data, dataBox:OWNS PTR TO class
	DEF entry:PTR TO entry
	
	IF entry := self.cursor.read()
		label   := PASS entry.label
		style   :=      entry.style
		marked  :=      entry.marked
		data    :=      entry.data
		dataBox := PASS entry.dataBox
		
		self.cursor.next()
	ELSE
		label := NILS
	ENDIF
ENDPROC
PUBLIC

PRIVATE
CLASS fGuiListSortWrapper OF fCompareMegaNodes
	func:PTR TO fGuiListSort
ENDCLASS
PUBLIC
PROC init(func:PTR TO fGuiListSort) OF fGuiListSortWrapper
	self.func := func
ENDPROC
PROC call(miniList:PTR TO cMiniListGeneric, left:PTR TO oMegaNode, right:PTR TO oMegaNode) OF fGuiListSortWrapper RETURNS sign:RANGE -1 TO 1
	DEF leftEntry:PTR TO entry, rightEntry:PTR TO entry
	
	 leftEntry := miniNode_read_class(miniList, left) ::entry
	rightEntry := miniNode_read_class(miniList, right)::entry
	sign := self.func(leftEntry.label, rightEntry.label, leftEntry.data, rightEntry.data, leftEntry.dataBox, rightEntry.dataBox)
ENDPROC

PRIVATE
CLASS entry
	label:OWNS STRING
	style
	marked:BOOL
	data
	dataBox:OWNS PTR TO class
ENDCLASS
PUBLIC
PROC new(label:OWNS STRING, style, marked:BOOL, data, dataBox:OWNS PTR TO class) OF entry
	self.label   := PASS label
	self.style   := style
	self.marked  := marked
	self.data    := data
	self.dataBox := PASS dataBox
ENDPROC
PROC end() OF entry
	END self.label
	END self.dataBox
	SUPER self.end()
ENDPROC

PRIVATE
CLASS cMegaList_entry UNGENERIC OF cMegaList_class
ENDCLASS
PUBLIC
PROC new(cursorNextIfDestroyNode=FALSE:BOOL, pastEndFloatingNode=NIL:MEGANODES) OF cMegaList_entry
	SUPER self.new(cursorNextIfDestroyNode, pastEndFloatingNode, /*autoDealloc*/ TRUE)
ENDPROC
PROC infoStart() OF cMegaList_entry IS SUPER self.infoStart()::cMegaCursor_entry
PROC infoPastEnd() OF cMegaList_entry IS SUPER self.infoPastEnd()::cMegaCursor_entry
->PROC makeNode(data:OWNS PTR TO entry) OF cMegaList_entry RETURNS floating:MEGANODES IS self.miniList::cMegaMiniList_class.makeNode(data)
PROC clone(noAutoDealloc=FALSE:BOOL) OF cMegaList_entry
	Throw("EMU", 'cMegaList_entry.clone(); this method is not supported')
ENDPROC SUPER self.clone()::cMegaList_entry
PROC mirror() OF cMegaList_entry IS SUPER self.mirror()::cMegaList_entry
PROC subset(start=NIL:PTR TO cMegaCursorGeneric, pastEnd=NIL:PTR TO cMegaCursorGeneric) OF cMegaList_entry IS SUPER self.subset(start, pastEnd)::cMegaList_entry
PROC isolateFromSharing() OF cMegaList_entry
	Throw("EMU", 'cMegaList_entry.isolateFromSharing(); this method is not supported')
	
	SUPER self.isolateFromSharing()
ENDPROC
->PROTECTED
PROC node_clone(clone:PTR TO oMegaNode, orig:PTR TO oMegaNode) OF cMegaList_entry
	Throw("BUG", 'cMegaList_entry.node_clone(); unsupported')
	
	->SUPER self.node_clone(clone, orig)
ENDPROC
->PROTECTED
PROC make() OF cMegaList_entry RETURNS list:OWNS PTR TO cMegaList_entry
	NEW list
ENDPROC
->PROTECTED
/*PROC make_node() OF cMegaList_entry RETURNS node:OWNS PTR TO oMegaNode_class
	NEW node
ENDPROC*/
->PROTECTED
PROC make_cursor() OF cMegaList_entry RETURNS cursor:OWNS PTR TO cMegaCursor_entry
	NEW cursor
ENDPROC

PRIVATE
CLASS cMegaCursor_entry OF cMegaCursor_class
ENDCLASS
PUBLIC
PROC read() OF cMegaCursor_entry RETURNS data:PTR TO entry IS SUPER self.read() !!PTR TO entry
->PROC write(data:OWNS PTR TO entry, returnOldData=FALSE:BOOL) OF cMegaCursor_entry RETURNS oldData:OWNS PTR TO entry IS SUPER self.write(data, returnOldData) !!OWNS PTR TO entry
PROC write(data:POSSIBLY OWNS PTR TO class, returnOldData=FALSE:BOOL) OF cMegaCursor_entry RETURNS oldData:OWNS PTR TO entry IS SUPER self.write(data, returnOldData) !!OWNS PTR TO entry
PROC getOwner() OF cMegaCursor_entry IS SUPER self.getOwner()::cMegaList_entry
PROC clone(ifRemovedThen=MC_STAY, followWhen=MC_NEVER) OF cMegaCursor_entry RETURNS clone:OWNS PTR TO cMegaCursor_entry IS SUPER self.clone(ifRemovedThen, followWhen)::cMegaCursor_entry
->no sorting overrides

->PROTECTED
->allows disabling/enabling updates of the visible list, if the underlying target supports it (so it may do nothing & should not be relied upon)
PROC setAutoUpdate(autoUpdate:BOOL) OF cGuiList IS EMPTY
PUBLIC


PROC markAll() OF cGuiList IS EMPTY


PROC getSortByNone() OF cGuiList RETURNS isSortByNone:BOOL IS EMPTY

PROC setSortByNone() OF cGuiList IS EMPTY

PROC getSortByColumn() OF cGuiList RETURNS isSortByColumn:BOOL, column, reverse:BOOL IS EMPTY

PROC setSortByColumn(column, reverse=FALSE:BOOL) OF cGuiList IS EMPTY

PROC getSortByUser() OF cGuiList RETURNS isSortByUser:BOOL, column, reverse:BOOL  IS EMPTY

PROC setSortByUser(initialColumn=0, initialReverse=FALSE:BOOL) OF cGuiList IS EMPTY

->conceptually returns the Sign() of "second - first", although the implementation is left up to the function
FUNC fGuiListSort(firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR, firstData, secondData, firstDataBox:PTR TO class, secondDataBox:PTR TO class) RETURNS order:RANGE -1 TO 1 IS OstrCmpNoCase(firstLabel, secondLabel)

->NOTE: Even though "isSortByFunction" will be FALSE for SortByColumn or SortByUser, it will still return a valid "sortFunc" function that you can use.
PROC getSortByFunction() OF cGuiList RETURNS isSortByFunction:BOOL, sortFunc:PTR TO fGuiListSort IS EMPTY

PROC setSortByFunction(sortFunc:PTR TO fGuiListSort) OF cGuiList IS EMPTY

PROC getEventSortedByUser(doNotClear=FALSE:BOOL) OF cGuiList RETURNS sortedByUser:BOOL, column, reverse:BOOL IS EMPTY

PROC setEventSortedByUser(sortedByUser:BOOL) OF cGuiList IS EMPTY

PROC getEventSelectionChanged(doNotClear=FALSE:BOOL) OF cGuiList RETURNS selectionChanged:BOOL IS EMPTY

PROC setEventSelectionChanged(selectionChanged:BOOL) OF cGuiList IS EMPTY

PROC getEventDoubleClickedEntry(moveCursorToEntry=FALSE:BOOL, doNotClear=FALSE:BOOL) OF cGuiList RETURNS label:ARRAY OF CHAR IS EMPTY

->sets the double-clicked entry as being the current cursor position
PROC setEventDoubleClickedEntry() OF cGuiList IS EMPTY


->this function emulates the sorting used for cGuiList.setSortByColumn()
CLASS fGuiListSortByColumn OF fGuiListSort
	column
	reverse:BOOL
	columnSortType:ARRAY OF CHAR
ENDCLASS

PROC init(column, reverse:BOOL, columnSortType:ARRAY OF CHAR) OF fGuiListSortByColumn
	self.column  := column
	self.reverse := reverse
	self.columnSortType := columnSortType
ENDPROC

PROC call(firstLabel:ARRAY OF CHAR, secondLabel:ARRAY OF CHAR, firstData=0, secondData=0, firstDataBox=NIL:OWNS PTR TO class, secondDataBox=NIL:OWNS PTR TO class) OF fGuiListSortByColumn RETURNS sign:RANGE -1 TO 1
	DEF firstColPos, secondColPos
	DEF firstColLen, secondColLen
	DEF firstVal,    secondVal
	DEF firstRead,   secondRead
	
	->find column we should be comparing
	 firstColPos,  firstColLen := findColumn( firstLabel, self.column)
	secondColPos, secondColLen := findColumn(secondLabel, self.column)
	
	SELECT self.columnSortType[self.column]
	CASE "I" ; sign := OstrCmpNoCase(firstLabel, secondLabel, Max(firstColLen, secondColLen), firstColPos, secondColPos)	->we are cheating slightly for the cases where the shorter label matches the beginning of the longer label (should use Min() instead of Max() plus some extra code in case sign=0) but this should work as the Tab character has a value less than normal characters
	CASE "S" ; sign := OstrCmp(      firstLabel, secondLabel, Max(firstColLen, secondColLen), firstColPos, secondColPos)
	CASE "N" ; 
		secondVal, secondRead := Val(secondLabel, NILA, secondColPos) ; IF secondRead > secondColLen THEN secondVal := Val('')
		 firstVal,  firstRead := Val( firstLabel, NILA,  firstColPos) ; IF  firstRead >  firstColLen THEN  firstVal := Val('')
		sign := Sign(secondVal - firstVal)
	ENDSELECT
	
	IF self.reverse THEN sign := -sign
ENDPROC

PRIVATE
PROC findColumn(label:ARRAY OF CHAR, column) RETURNS pos, len
	DEF pastEndPos
	
	pos := 0
	WHILE column-- > 0 DO pos := InStr(label, '\t', pos) + 1
	
	pastEndPos := InStr(label, '\t', pos)
	IF pastEndPos = -1 THEN pastEndPos := StrLen(label)
	len := pastEndPos - pos
ENDPROC
PUBLIC


->PROTECTED
->useful for keeping the cursor on the same entry, when the list is sorted
PROC saveCursorEntry() OF cGuiList RETURNS cursorLabel:ARRAY OF CHAR IS IF self.infoSize() = 0 THEN NILA ELSE self.cursor_getLabel()
PROC findCursorEntry(cursorLabel:ARRAY OF CHAR) OF cGuiList
	IF self.cursor_gotoStart() AND (cursorLabel <> NILA)
		WHILE self.cursor_getLabel() <> cursorLabel DO IF self.cursor_gotoNext() = 0 THEN Throw("BUG", 'cGuiList.findCursorEntry(); failed')
	ENDIF
ENDPROC
PUBLIC


PROC setData(data) OF cGuiList IS SUPER self.setData(data)::cGuiList

PROC initUseLeastSpace() OF cGuiList IS SUPER self.initUseLeastSpace()::cGuiList

PROC setPopupHint(popupHint:NULL ARRAY OF CHAR) OF cGuiList IS SUPER self.setPopupHint(popupHint)::cGuiList

PROC setGhosted(ghosted:BOOL) OF cGuiList IS SUPER self.setGhosted(ghosted)::cGuiList

PROC setNotifyFunction(func:NULL PTR TO funcGuiNotify) OF cGuiList IS SUPER self.setNotifyFunction(func)::cGuiList


PROC cursor_gotoStart() OF cGuiList RETURNS success:BOOL IS EMPTY

PROC cursor_gotoEnd() OF cGuiList RETURNS success:BOOL IS EMPTY

->NOTE: steps=0 is allowed, as are negative steps.
PROC cursor_gotoNext(steps=1) OF cGuiList RETURNS movedSteps IS EMPTY

PROC cursor_gotoPrev(steps=1) OF cGuiList RETURNS movedSteps IS EMPTY

PROC cursor_gotoFirstSelected() OF cGuiList RETURNS success:BOOL IS EMPTY

PROC cursor_gotoNextSelected() OF cGuiList RETURNS success:BOOL IS EMPTY

->NOTE: If "compareLength" is >0 then only the first "compareLength" characters of "label" & each entry are compared.
->NOTE: If "compareLength" is <0 then only the last  "compareLength" characters of "label" & each entry are compared.
PROC cursor_find(label:ARRAY OF CHAR, noCase=FALSE:BOOL, compareLength=0, continueFromLastMatch=FALSE:BOOL) OF cGuiList RETURNS success:BOOL
	DEF endOfList:BOOL, entry:ARRAY OF CHAR, labelPos
	
	IF compareLength < 0 THEN labelPos := Max(0,StrLen(label)-compareLength)
	
	IF continueFromLastMatch = FALSE
		endOfList := self.cursor_gotoStart() = FALSE
	ELSE
		endOfList := self.cursor_gotoNext() = 0
	ENDIF
	success := FALSE
	WHILE endOfList = FALSE
		entry := self.cursor_getLabel()
		
		IF      compareLength = 0  ; success := IF noCase THEN StrCmpNoCase(entry, label)                                                    ELSE StrCmp(entry, label)
		ELSE IF compareLength > 0  ; success := IF noCase THEN StrCmpNoCase(entry, label, compareLength)                                     ELSE StrCmp(entry, label, compareLength)
		ELSE /* compareLength < 0*/; success := IF noCase THEN StrCmpNoCase(entry, label, ALL, Max(0,StrLen(entry)-compareLength), labelPos) ELSE StrCmp(entry, label, ALL, Max(0,StrLen(entry)-compareLength), labelPos)
		ENDIF
		
		IF success = FALSE THEN IF self.cursor_gotoNext() = 0 THEN endOfList := TRUE
	ENDWHILE IF success
ENDPROC

->goes to the start entry, returning how many entries it passed through (and thus what it's original position was)
->NOTE: This can be slow, depending on how the target implements a list.
->NOTE: If the list is empty, then it returns -1.
PROC cursor_walkToStart() OF cGuiList RETURNS oldPosition
	DEF size
	size := self.infoSize()
	oldPosition := IF size = 0 THEN -1 ELSE self.cursor_gotoPrev(size)
ENDPROC

PROC cursor_isAtStart() OF cGuiList RETURNS isAtStart:BOOL IS EMPTY

PROC cursor_isAtEnd()   OF cGuiList RETURNS isAtEnd:BOOL IS EMPTY


PROC cursor_getLabel() OF cGuiList RETURNS label:ARRAY OF CHAR IS EMPTY

->NOTE: When done on a sorted list, the entry may be moved to a different location.
->      By default the cursor will follow the entry to it's new location, but you can use "goto0newSortedLocation1next2prev" to choose to go to the next/previous node of the old location.
PROC cursor_setLabel(label:ARRAY OF CHAR, goto0newSortedLocation1next2prev=0) OF cGuiList IS EMPTY

PROC cursor_getStyle() OF cGuiList RETURNS style IS EMPTY
->obsolete
PROC cursor_getAltColour() OF cGuiList RETURNS altColour:BOOL IS self.cursor_getStyle() AND GUI_STYLE_ALTCOLOUR <> 0

PROC cursor_setStyle(style) OF cGuiList IS EMPTY
->obsolete
PROC cursor_setAltColour(altColour=TRUE:BOOL) OF cGuiList IS self.cursor_setStyle(GUI_STYLE_ALTCOLOUR)

PROC cursor_getState() OF cGuiList RETURNS selected:BOOL IS EMPTY

PROC cursor_setState(selected:BOOL) OF cGuiList IS EMPTY

PROC cursor_getMarked() OF cGuiList RETURNS marked:BOOL IS EMPTY

PROC cursor_setMarked(marked:BOOL) OF cGuiList IS EMPTY

PROC cursor_getData() OF cGuiList RETURNS data IS EMPTY

PROC cursor_setData(data) OF cGuiList IS EMPTY

PROC cursor_getDataBox() OF cGuiList RETURNS data:PTR TO class IS EMPTY

PROC cursor_setDataBox(data:OWNS PTR TO class) OF cGuiList IS EMPTY


->NOTE: "labels" may be a list of linked STRINGs.
->NOTE: This may only be called on an unsorted list.
PROC cursor_beforeInsert(labels:OWNS STRING, style=GUI_STYLE_NONE, marked=FALSE:BOOL, data=0, dataBox=NIL:OWNS PTR TO class) OF cGuiList IS EMPTY

PROC cursor_afterInsert( labels:OWNS STRING, style=GUI_STYLE_NONE, marked=FALSE:BOOL, data=0, dataBox=NIL:OWNS PTR TO class) OF cGuiList IS EMPTY

->fall-back implementation (mutually-exclusive)
PROC cursor_destroy(gotoPrev=FALSE:BOOL) OF cGuiList RETURNS movedToExpectedEntry:BOOL
	DEF label:OWNS STRING
	label, movedToExpectedEntry := self.cursor_remove(gotoPrev)
	END label
ENDPROC

->fall-back implementation (mutually-exclusive)
PROC cursor_remove( gotoPrev=FALSE:BOOL) OF cGuiList RETURNS label:OWNS STRING, movedToExpectedEntry:BOOL
	label := StrJoin(self.cursor_getLabel())
	movedToExpectedEntry := self.cursor_destroy(gotoPrev)
ENDPROC

PROC marked_setStyle(style) OF cGuiList IS EMPTY
->obsolete
PROC marked_setAltColour(altColour=TRUE:BOOL) OF cGuiList IS self.marked_setStyle(GUI_STYLE_ALTCOLOUR)

PROC marked_setState(selected:BOOL) OF cGuiList IS EMPTY

PROC marked_unmark() OF cGuiList IS EMPTY

PROC marked_destroy(gotoPrevIfRemoved=FALSE:BOOL) OF cGuiList RETURNS entriesDestroyed IS EMPTY

->NOTE: When multiple entries are removed, "labels" will be a list of linked STRINGs.
PROC marked_remove( gotoPrevIfRemoved=FALSE:BOOL) OF cGuiList RETURNS labels:OWNS STRING IS EMPTY

->PROC () OF cGuiList IS EMPTY

/*****************************/
