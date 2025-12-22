pattern Translate(_inputString,_inputLength,_outputBuffer,_bufferSize) is
	push a6;
	safe a0:=_inputString; d0.l:=_inputLength; a1:=_outputBuffer; d1.l:=_bufferSize;;
	a6:=TranslatorBase; jsr [a6-30];
	pop a6;
endp;															# TRANSLATE

