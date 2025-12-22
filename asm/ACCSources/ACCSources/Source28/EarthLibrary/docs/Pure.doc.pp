
PURITY
~~~~~~

This document is for assembler programmers only.
If you program in 'C' you can skip this file.

A "PURE" program is a program which is (a) re-executable, and (b)
re-entrant. Re-executable means that the code can be executed over
and over again, (in series), while re-entrant means that the code
can be executed by multiple processes simultaneously (in parallel).

A pure program has many advantages over an impure program. It can
be made resident, which saves memory, and reduces disc access time.

It is easy to make a program pure. Basically, all you have to do is
allocate your memory at run-time instead of using DATA and BSS
directives, set a register to point at the allocated memory, and
refer to all of your variables using relative addressing.

(Actually, EarthSoft have come up with a technique called "EarthMagic"
which actually allows you to use DATA and BSS directives while still
remaining pure. EarthMagic makes writing pure code REALLY EASY, so
get hold of Amiga Coders Club disc 25, or write to EarthSoft, for all
the necessary bits and pieces).

Anyway - there are a few examples of assembler code scattered
throughout this documentation. These examples all assume that you will
be writing pure code - either with or without EarthMagic. If you're
NOT writing pure code (and there's really no excuse for not doing so
these days (unless you're taking over the whole machine) - particularly
since techniques such as EarthMagic do all of the hard work for you)
then you will probably need to modify the examples.

The examples therefore make the following assumptions:

    (1) All variables are referenced relative to an address
	register. We don't care which one. The examples
	refer to this register as "_data". This is a
	register equate, which can (should) be assigned
	using the EarthSoft macro SETDATA, which is
	defined in "earth/earth.i".

    (2)	The base of "earth.library" is stored in a variable
	called "_EarthBase". Since this is also a base-relative
	variable, we refer to it as "_EarthBase(_data)".

    (3)	Functions in "earth.library" are called using the
	macro BSREARTH, which is defined in "earth/earth.i".
	(Similarly, functions in "dos.library" are called
	using BSRDOS, and so on).

