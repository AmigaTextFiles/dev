pattern ConvertHSBToRGB(_hsb,_rgb) is
	push a6;
	safe a0:=_hsb; a1:=_rgb;;
	a6:=ColorWheelBase; jsr [a6-30];
	pop a6;
endp;															# CONVERTHSBTORGB

pattern ConvertRGBToHSB(_rgb,_hsb) is
	push a6;
	safe a0:=_rgb; a1:=_hsb;;
	a6:=ColorWheelBase; jsr [a6-36];
	pop a6;
endp;															# CONVERTRGBTOHSB

