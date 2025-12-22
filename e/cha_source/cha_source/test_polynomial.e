/*==========================================================================+
| test_polynomial.e                                                         |
| test complex polynomials                                                  |
| test passed                                                               |
+--------------------------------------------------------------------------*/

MODULE '*complex', '*polynomial'

/*-------------------------------------------------------------------------*/

PROC main() HANDLE
	DEF poly = NIL : PTR TO polynomial
	NEW poly.polynomial()
	printpolynomial(poly)
	poly.addzero([  1.0, 0.0 ] : complex)
	printpolynomial(poly)
	poly.addzero([ -1.0, 0.0 ] : complex)
	printpolynomial(poly)
	poly.addzero([  2.0, 0.0 ] : complex)
	printpolynomial(poly)
	poly.addzero([ -2.0, 0.0 ] : complex)
	printpolynomial(poly)
	poly.expand(4, [ 1.0, 0.0,
	                -1.0, 0.0,
	                 2.0, 0.0,
	                -2.0, 0.0 ] : complex)
	printpolynomial(poly)
EXCEPT DO
	-> cleanup
	END poly
	-> report errors
ENDPROC IF exception THEN 5 ELSE 0

PROC printpolynomial(poly : PTR TO polynomial)
	DEF i, z : complex
	FOR i := poly.power TO 1 STEP -1
		WriteF('(\d+\di) z^\d + ', ! poly.c[i].re !, ! poly.c[i].im !, i)
	ENDFOR
	WriteF('(\d+\di)\n', ! poly.c[0].re !, ! poly.c[0].im !)
	FOR i := -2 TO 2
		z.re := i !
		z.im := 0.0
		poly.evaluate(z, z)
		WriteF('p(\d) = \d+\di\n', i, ! z.re !, ! z.im !)
	ENDFOR
ENDPROC

/*--------------------------------------------------------------------------+
| END: test_polynomial.e                                                    |
+==========================================================================*/
