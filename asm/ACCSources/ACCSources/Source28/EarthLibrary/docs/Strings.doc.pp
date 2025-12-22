
C STRING FUNCTIONS
~~~~~~~~~~~~~~~~~~

"earth.library" provides a number of standard C string handling
functions. These are unlikely to be of use to C programmers, since
most C compilers will have equivalent functions built in as
standard. Some early non-ANSI public domain C compilers may have a
few of these missing, so one or two may be useful to some C
programmers.

To avoid name conflicts, the "earth.library" functions have names in
mixed case, and prefixed by an underscore character.

The functions provided are:

	_StrLen()
	_StrCmp()
	_StrNCmp()
	_StrICmp()
	_StrNICmp()
	_StrCpy()
	_StrNCpy()
	_StrCat()
	_StrNCat()
	_StrMove()
	_StrMoveUpper()

For the benefit of assembler programmers, these routines preserve
ALL registers, including the scratch registers (except when a return
value is returned, in which case d0 will contain the return value.
In such cases all other registers are preserved).

The string comparison functions _StrCmp(), _StrNCmp(), _StrICmp() and
_StrNICmp() all preserve all registers if called from machine code.
The result of the comparison is returned directly in the condition
codes register, so you can branch on the comparison result immediately.
C programmers will get a return value as normal.

Note that some of these functions do not behave EXACTLY like their
ANSI counterparts, so see the docs for individual function
descriptions.

FOR C PROGRAMMERS
~~~~~~~~~~~~~~~~~

If you have a non-ANSI C compiler which misses out some of these
functions then you can use "earth.library" functions to replace them.
In this case, you may wish to create an include file of your own
with a few #defines in it. For instance:

#define	strnicmp	_StrNICmp

CHARACTER TEST MACROS
~~~~~~~~~~~~~~~~~~~~~

These are for assembler programmers only. They are defined in the
assembler include file "earth/earthbase.i".

Each macro comes in two varieties: one which is prefixed by an
underscore, and one which isn't. The difference is that if you have
the base address of "earth.library" in register a6 you can use the
underscored version (which is quicker), otherwise you must use the
non-underscored version.

These macros are all extremely FAST. Probably in fact the fastest
way you can test a character.

The available macros are:
	_ISALNUM	ISALNUM
	_ISALPHA	ISALPHA
	_ISCNTRL	ISCNTRL
	_ISDIGIT	ISDIGIT
	_ISGRAPH	ISGRAPH
	_ISHEX		ISHEX
	_ISLOWER	ISLOWER
	_ISPRINT	ISPRINT
	_ISPUNCT	ISPUNCT
	_ISSPACE	ISSPACE
	_ISUPPER	ISUPPER

Each of these macros takes a single parameter, which is the register
to be tested. This must be either a WORD or a LONG, never a BYTE
(in other words, bits 15 to 8 are significant, and must be zero).

The result of the test is in all cases placed in the zero register,
which will be reset if the test was true, or set if the test was false.

These macros are very clever. The non-underscored variety need to
move the library base address into register a6 before performing the
test. They can do this successfully even in a PURE program in which
the library base address is stored as an offset from an address
register (- to make this work, use the SETDATA macro. See "Pure.doc"
and also "earth/earth.i"). They can decide to either preserve or
corrupt a6, depending on your preferences (- to make this work, use
the SETA6 macro. See "earth/earth.i").

CHARACTER CONVERSION MACROS
~~~~~~~~~~~~~~~~~~~~~~~~~~~

These are for assembler programmers only. They are defined in the
assembler include file "earth/earthbase.i".

Each macro comes in two varieties: one which is prefixed by an
underscore, and one which isn't. The difference is that if you have
the base address of "earth.library" in register a6 you can use the
underscored version (which is quicker), otherwise you must use the
non-underscored version.

These macros are all extremely FAST. Probably in fact the fastest
way you can convert a character.

The available macros are:
	_TOUPPER	TOUPPER
	_TOLOWER	TOLOWER

Each of these macros takes a single parameter, which is the register
to be converted. This must be either a WORD or a LONG, never a BYTE
(in other words, bits 15 to 8 are significant, and must be zero).
Furthermore, this must be a data register, not an address register.

The result of the conversion is in all cases placed back in the
specified register.

These macros are very clever. The non-underscored variety need to
move the library base address into register a6 before performing the
test. They can do this successfully even in a PURE program in which
the library base address is stored as an offset from an address
register (- to make this work, use the SETDATA macro. See "Pure.doc"
and also "earth/earth.i"). They can decide to either preserve or
corrupt a6, depending on your preferences (- to make this work, use
the SETA6 macro. See "earth/earth.i").

