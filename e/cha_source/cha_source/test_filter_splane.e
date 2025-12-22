/*==========================================================================+
| test_filter_splane.e                                                      |
| test splane filter design                                                 |
| NB: this program broken by later changes to filter_splane.e               |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37, PREPROCESS

MODULE '*filter_splane'/*, '*filter_plot'*/, '*complex'/*, 'tools/easygui'*/

#define PI  3.14159265

/*-------------------------------------------------------------------------*/

PROC main() HANDLE
	DEF i
	FOR i := 0 TO 20 DO testblt(i ! / 20.0)

/*
	DEF splane = NIL : PTR TO splane, plot = NIL : PTR TO drawplane

	NEW splane.butterworth(8)
	easyguiA('butterworth order 8', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	splane.lowpass(0.2)
	easyguiA('butterworth order 8 lowpass', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane

	NEW splane.butterworth(8)
	splane.highpass(0.2)
	easyguiA('butterworth order 8 highpass', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane

	NEW splane.butterworth(8)
	splane.bandpass(0.2, 0.3)
	easyguiA('butterworth order 8 bandpass', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane

	NEW splane.butterworth(8)
	splane.bandstop(0.2, 0.3)
	easyguiA('butterworth order 8 bandstop', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane


	NEW splane.chebyshev(8, -5.0)
	easyguiA('chebyshev order 8 ripple -5.0', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	splane.lowpass(0.2)
	easyguiA('chebyshev order 8 ripple -5.0 lowpass', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane

	NEW splane.chebyshev(8, -5.0)
	splane.highpass(0.2)
	easyguiA('chebyshev order 8 ripple -5.0 highpass', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane

	NEW splane.chebyshev(8, -5.0)
	splane.bandpass(0.2, 0.3)
	easyguiA('chebyshev order 8 ripple -5.0 bandpass', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane

	NEW splane.chebyshev(8, -5.0)
	splane.bandstop(0.2, 0.3)
	easyguiA('chebyshev order 8 ripple -5.0 bandstop', [PLUGIN,0,NEW plot.drawsplane(splane)])
	END plot
	END splane
*/
EXCEPT DO
/*
	-> cleanup
	END plot
	END splane

	-> report errors
*/
ENDPROC IF exception THEN 5 ELSE 0

PROC testblt(x)
	DEF y, z, buf1[16] : STRING, buf2[16] : STRING, buf3[16] : STRING,
	    w : complex
	y := prebilinear(x, 2.0)
	w.re := 0.0
	w.im := y
	blt(w, w)
	z := ! 0.5 * carg(w) / PI
	WriteF('\s[16] -> \s[16] -> \s[16]\n',
	    RealF(buf1, x, 8),
	    RealF(buf2, y, 8),
	    RealF(buf3, z, 8))
ENDPROC

PROC blt(pz : PTR TO complex, to : PTR TO complex)
	DEF t1 : complex, t2 : complex
ENDPROC cdiv(cadd([2.0,0.0]:complex,pz,t1),csub([2.0,0.0]:complex,pz,t2),to)


/*--------------------------------------------------------------------------+
| END: test_filter_splane.e                                                 |
+==========================================================================*/
