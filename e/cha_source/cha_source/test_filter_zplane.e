/*==========================================================================+
| test_filter_zplane.e                                                      |
| test zplane filter design                                                 |
| NB: this program broken by later changes to filter_zplane.e               |
+--------------------------------------------------------------------------*/

OPT OSVERSION=37

MODULE '*filter_splane', '*filter_zplane', '*filter_plot', 'tools/easygui'

/*-------------------------------------------------------------------------*/

PROC main() HANDLE
/*
	DEF splane = NIL : PTR TO splane,
	    zplane = NIL : PTR TO zplane,
	    plot   = NIL : PTR TO drawplane

	splane := NIL

	NEW zplane.bandpass(0.2, 0.5)
	easyguiA('resonator bandpass frequency 0.2 qfactor 0.5', [PLUGIN,0,NEW plot.drawzplane(zplane)])
	END plot
	END zplane

	NEW zplane.bandpass(0.2, 2.0)
	easyguiA('resonator bandpass frequency 0.2 qfactor 2.0', [PLUGIN,0,NEW plot.drawzplane(zplane)])
	END plot
	END zplane

/*	NEW splane.butterworth(8)
	splane.lowpass(0.2)
	NEW zplane.bilinear(splane)
	easyguiA('bilinear butterworth order 8 lowpass 0.2', [PLUGIN,0,NEW plot.drawzplane(zplane)])
	END plot
	END zplane
	END splane

	NEW splane.chebyshev(8, -0.01)
	splane.bandpass(0.2, 0.6)
	NEW zplane.bilinear(splane)
	easyguiA('bilinear chebyshev order 8 ripple -0.01 bandpass 0.2 0.6', [PLUGIN,0,NEW plot.drawzplane(zplane)])
	END plot
	END zplane
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
*/
EXCEPT DO
/*
	-> cleanup
	END plot
	END zplane
	END splane

	-> report errors
*/
ENDPROC IF exception THEN 5 ELSE 0

/*--------------------------------------------------------------------------+
| END: test_filter_zplane.e                                                 |
+==========================================================================*/
