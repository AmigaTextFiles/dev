/* CSH/pAmigaOS4_patch.e 05-10-2012
	An easy system for patching AmigaOS4.


Copyright (c) 2010,2011,2012 Christopher Steven Handley ( http://cshandley.co.uk/email )
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
newPatches(size, verbose=FALSE:BOOL)
addPatch(index, interface:PTR, method:PTR, newMethod:PTR) RETURNS success:BOOL
remPatch(index, doNotWait=FALSE:BOOL) RETURNS success:BOOL
endPatches()

beginPatch(index)
methodIsPatched(index) RETURNS isPatched:BOOL
methodBeforePatch(index) RETURNS method:APTR
quittingPatch(index) RETURNS quitting:BOOL
finishPatch(index)

     PrintPatchException()
DebugPrintPatchException()
*/

OPT POINTER, INLINE
OPT NATIVE		->this uses some C magic, and so will only work with the C++ target
PUBLIC MODULE 'std/pCallback'
MODULE 'dos', 'exec', 'std/pSemaphores'

/*****************************/	->single patch abstraction (private)

PRIVATE

CONST DEBUG = FALSE

OBJECT amigaPatch PRIVATE
	oldMethod:APTR
	newMethod:APTR
	offsetOfMethod
	interface:PTR TO interface
	
	count
	semaphore:SEMAPHORE
	quit:BOOL
ENDOBJECT

PROC initSinglePatch(self:PTR TO amigaPatch)
	self.oldMethod := NILA
	self.count     := 0
	self.semaphore := NIL
ENDPROC

PROC addSinglePatch(self:PTR TO amigaPatch, interface:PTR, method:PTR, newMethod:PTR) RETURNS success:BOOL
	self.semaphore := NewSemaphore()
	
	self.quit := FALSE
	
	self.offsetOfMethod := NATIVE {(unsigned long)} method { - (unsigned long)} interface ENDNATIVE !!VALUE
	self.interface := interface !!PTR TO interface
	self.newMethod := newMethod !!APTR
	Forbid()	->this ensures that "oldMethod" holds a valid value before newMethod() could be called
	self.oldMethod := SetMethod(self.interface, self.offsetOfMethod, self.newMethod)
	Permit()
	
	success := (self.oldMethod <> NIL)
	IF DEBUG
		IF success = FALSE THEN Print('ERROR: method \d was protected from patching.\n', self.offsetOfMethod / SIZEOF LONG)
	ENDIF
ENDPROC

PROC remSinglePatch1(self:PTR TO amigaPatch, doNotWait=FALSE:BOOL) RETURNS success:BOOL
	DEF replMethod:APTR
	
	success := TRUE
	
	IF DEBUG THEN Print('RemovING patch for method \d...\n', self.offsetOfMethod / SIZEOF LONG)
	
	IF self.oldMethod
		Forbid()	->this ensures we can restore the patch, if removing it fails
		WHILE (replMethod := SetMethod(self.interface, self.offsetOfMethod, self.oldMethod)) <> self.newMethod
			->(Aaargh!  Someone patched on-top of us) so undo patch & try again a little while later
			SetMethod(self.interface, self.offsetOfMethod, replMethod)
			Permit()
			
			IF doNotWait = FALSE THEN Delay(50) ELSE success := FALSE
			Forbid()
		ENDWHILE IF doNotWait
		Permit()
	ENDIF
ENDPROC

PROC remSinglePatch2(self:PTR TO amigaPatch)
	->request that all pending Method() calls finish
	self.quit := TRUE
	
	->ensure newMethod() is unused before continuing
	IF self.semaphore
		SemLock(self.semaphore)
		WHILE self.count > 0
			SemUnlock(self.semaphore)
			
			Delay(50)
			SemLock(self.semaphore)
		ENDWHILE
		SemUnlock(self.semaphore)
		
		self.oldMethod := NILA
		self.semaphore := DisposeSemaphore(self.semaphore)
	ENDIF
	
	IF DEBUG THEN Print('RemovED  patch for method \d.\n', self.offsetOfMethod / SIZEOF LONG)
ENDPROC

PROC infoAddedSinglePatch(self:PTR TO amigaPatch) IS self.oldMethod <> NILA


PROC beginSinglePatch(self:PTR TO amigaPatch)
	SemLock(self.semaphore)
	self.count++
	SemUnlock(self.semaphore)
ENDPROC

PROC methodIsSinglePatched(self:PTR TO amigaPatch) RETURNS isPatched:BOOL IS self.oldMethod <> NILA

PROC methodBeforeSinglePatch(self:PTR TO amigaPatch) RETURNS method:APTR IS self.oldMethod

PROC quittingSinglePatch(self:PTR TO amigaPatch) RETURNS quitting:BOOL IS self.quit

PROC finishSinglePatch(self:PTR TO amigaPatch)
	SemLock(self.semaphore)
	self.count--
	SemUnlock(self.semaphore)
ENDPROC

PUBLIC

/*****************************/	->multi patch abstraction

PRIVATE
DEF multiPatches:ARRAY OF amigaPatch
DEF multiPatchSize
DEF multiPatchesVerbose:BOOL
PUBLIC

PROC newPatches(size, verbose=FALSE:BOOL)
	DEF index
	
	NEW multiPatches[size]
	multiPatchSize := size
	multiPatchesVerbose := verbose
	
	FOR index := 0 TO size-1 DO initSinglePatch(multiPatches[index])
ENDPROC

PROC addPatch(index, interface:PTR, method:PTR, newMethod:PTR) RETURNS success:BOOL
	IF (index < 0) OR (index >= multiPatchSize) THEN Throw("EPU", 'addPatch(); the supplied "index" parameter is out of range')
	
	success := addSinglePatch(multiPatches[index], interface, method, newMethod)
	
	IF multiPatchesVerbose
		IF success = FALSE
			Print('ERROR: addPatch() failed for index=\d (method was protected from patching)\n', index)
		ELSE
			Print('Added method patch for index=\d.\n', index)
		ENDIF
	ENDIF
ENDPROC

PROC remPatch(index, doNotWait=FALSE:BOOL) RETURNS success:BOOL
	IF infoAddedSinglePatch(multiPatches[index])
		IF multiPatchesVerbose
			Print('Removing method patch for index=\d...  ', index)
			PrintFlush()
		ENDIF
		
		IF success := remSinglePatch1(multiPatches[index], doNotWait)
			          remSinglePatch2(multiPatches[index])
		ENDIF
		
		IF multiPatchesVerbose THEN IF success THEN Print('done.\n') ELSE Print('FAILED.\n')
	ENDIF
ENDPROC

PROC endPatches()
	DEF index, removed:OWNS ARRAY OF BOOL, remainingCount
	
	IF multiPatches = NILA THEN RETURN	->newPatches() was never called
	
	->keep track of the removed patches
	NEW removed[multiPatchSize]
	FOR index := 0 TO multiPatchSize-1 DO removed[index] := FALSE
	remainingCount := multiPatchSize
	
	->remove all patches, without one problematic patch preventing the others being removed
	REPEAT
		FOR index := 0 TO multiPatchSize-1
			IF removed[index] = FALSE
				->(we have not yet removed this patch)
				IF multiPatchesVerbose THEN IF infoAddedSinglePatch(multiPatches[index]) THEN Print('RemovING method patch for index=\d...\n', index)
				
				IF remSinglePatch1(multiPatches[index], /*doNotWait*/ TRUE)
					->(the patch was removed)
					remainingCount--
					removed[index] := TRUE
				ENDIF
			ENDIF
		ENDFOR
		
		IF remainingCount > 0 THEN Delay(50)
	UNTIL remainingCount <= 0
	
	->wait for all patched calls to complete
	FOR index := 0 TO multiPatchSize-1
		remSinglePatch2(multiPatches[index])
		
		IF multiPatchesVerbose THEN IF infoAddedSinglePatch(multiPatches[index]) = FALSE THEN Print('RemovED  method patch for index=\d.\n', index)
	ENDFOR
	
	END multiPatches
FINALLY
	END removed
ENDPROC


PROC beginPatch(index) IS beginSinglePatch(multiPatches[index])

PROC methodIsPatched(index) RETURNS isPatched:BOOL IS methodIsSinglePatched(multiPatches[index])

PROC methodBeforePatch(index) RETURNS method:APTR IS methodBeforeSinglePatch(multiPatches[index])

PROC quittingPatch(index) RETURNS quitting:BOOL IS quittingSinglePatch(multiPatches[index])

PROC finishPatch(index) IS finishSinglePatch(multiPatches[index])

/*****************************/	->helper procedures

FUNC patchPrint(fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) IS Print(fmtString, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

->this is like PrintException() except that it also prints where the problem occured
PROC PrintPatchException(location:ARRAY OF CHAR, alternativePrint=NIL:PTR TO patchPrint)
	DEF task:PTR TO tc
	
	IF exception
		task := FindTask(NILA)
		IF alternativePrint = NIL THEN alternativePrint := patchPrint
		alternativePrint('EXCEPTION: "\s"; \s.\n', QuadToStr(exception), IF exceptionInfo THEN exceptionInfo ELSE '')
		alternativePrint('EXCEPTION: Occured in \s for task \s.\n', location, IF task THEN task.ln.name ELSE 'unknown')
	ENDIF
ENDPROC

FUNC patchDebugPrintF(fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) OF patchPrint IS DebugPrintF(fmtString, arg1, arg2, arg3, arg4, arg5, arg6, arg7 /*, arg8*/)

->this should be used if using PrintPatchException() inside of a patch causes a crash.
PROC DebugPrintPatchException(location:ARRAY OF CHAR) IS PrintPatchException(location, patchDebugPrintF)
