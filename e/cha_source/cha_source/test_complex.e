/*==========================================================================+
| test_complex.e                                                            |
| test complex number functions                                             |
+--------------------------------------------------------------------------*/

MODULE '*complex'

/*-------------------------------------------------------------------------*/

PROC main()
	DEF a : complex, b : complex
	a.re := 1.0
	a.im := 1.0
	b.re := 0.0
	b.im := 0.0
	test_c_f('cabs2', {cabs2}, a)
	test_c_f('cabs',  {cabs},  a)
	test_c_f('carg',  {carg},  a)
	a.re := -1.0
	test_c_f('carg',  {carg},  a)
	a.im := -1.0
	test_c_f('carg',  {carg},  a)
	a.re := 1.0
	test_c_f('carg',  {carg},  a)
	a.im := 0.0
	test_cc_c('csqrt',{csqrt}, a, b)
	a.re := 4.0
	test_cc_c('csqrt',{csqrt}, a, b)
	a.re := 9.0
	test_cc_c('csqrt',{csqrt}, a, b)
	a.re := -4.0
	test_cc_c('csqrt',{csqrt}, a, b)
	a.re := -9.0
	test_cc_c('csqrt',{csqrt}, a, b)
	a.re := 0.0
	test_cc_c('csqrt',{csqrt}, a, b)
	a.im := 1.0
	test_cc_c('csqrt',{csqrt}, a, b)
	print_s('\n')
	a.re := 4.0
	a.im := 4.0
	test_cc_c('csqrt',{csqrt}, a, b)
	test_ccc_c('cmul',{cmul}, b, b, b)
	a.re := -4.0
	test_cc_c('csqrt',{csqrt}, a, b)
	test_ccc_c('cmul',{cmul}, b, b, b)
	a.im := -4.0
	test_cc_c('csqrt',{csqrt}, a, b)
	test_ccc_c('cmul',{cmul}, b, b, b)
	a.re := 4.0
	test_cc_c('csqrt',{csqrt}, a, b)
	test_ccc_c('cmul',{cmul}, b, b, b)
ENDPROC

/*-------------------------------------------------------------------------*/

PROC test_c_f(s,f,a)
	DEF x
	print_s(s)
	print_s('(')
	print_c(a)
	print_s(') -> ')
	x := f(a)
	print_f(x)
	print_s('\n')
ENDPROC

PROC test_cc_c(s,f,a,b)
	print_s(s)
	print_s('(')
	print_c(a)
	print_s(',')
	print_c(b)
	print_s(') -> ')
	f(a,b)
	print_c(b)
	print_s('\n')
ENDPROC

PROC test_ccc_c(s,f,a,b,c)
	print_s(s)
	print_s('(')
	print_c(a)
	print_s(',')
	print_c(b)
	print_s(',')
	print_c(c)
	print_s(') -> ')
	f(a,b,c)
	print_c(c)
	print_s('\n')
ENDPROC

PROC print_s(s)
	PutStr(s)
ENDPROC

PROC print_c(c : PTR TO complex)
	print_f(c.re)
	print_s('+')
	print_f(c.im)
	print_s('i')
ENDPROC

PROC print_f(f)
	DEF buffer[16] : STRING
	RealF(buffer, f, 4)
	print_s(buffer)
ENDPROC

/*--------------------------------------------------------------------------+
| END: test_complex.e                                                       |
+==========================================================================*/
