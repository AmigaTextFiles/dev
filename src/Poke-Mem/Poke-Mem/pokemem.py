
# CAUTION!!! ...YOU USE THIS SOFTWARE AT YOUR OWN RISK!!!...
# POKEB ONLY memory using an executable. This is VERY dangerous, so be
# VERY, VERY careful. The idea is to use an executable to write a byte
# value into a register or memory. WORD capability is added also and LONG
# WORD transfers also work so it would theoretically be possible to access
# say the AMIGA PCMCIA slot and write a 16 Bit value to it using PYTHON
# WITHOUT ANY special additions, JUST the basic interpreter and its
# standard 'libraries'.

# This LUNATIC idea belongs to copyright, (C)2007, B.Walker, G0LCU.

# A matching BASIC source is issued to make the whole AMIGA specific.
# You brain-bods out there COULD make it work on other platforms IF you so
# desired BUT I hold NO responsibility for ANY problems that may arise.
# I am NOT releasing the 'ANSI C' source for this controversial method of
# writing to memory you will have to write your own 'ANSI C' code.
# The ACE Basic code makes this purely classic AMIGA specific.
# $VER: pokemem.py_Version_0.10.00_(C)01-01-2007_B.Walker_G0LCU.

# VERY IMPORTANT!!! THIS DEMONSTRATION CODE DOES NOT TAKE INTO ACCOUNT
# ANY TYPO' ERRORS. IN THEORY, THE ACE BASIC COMPILED EXECUTABLE WILL
# FORCE SOME TYPO' ERRORS TO ADDRESS 0 AND BYTE VALUE OF 0. SO BE VERY
# AWARE OF THIS. NOTE, THIS _IS_ AN ENFORCER HIT SO TREAT IT AS SUCH!!!

# Do any imports IF required.
import os

# Have it as an 'executeble' rather than an 'import'.
def main():
	# Set up any 'strings' or 'variables'.
	pokeaddress = '0'
	pokebyte = '0'
	# Use 'print' as a simple newline only.
	print
	print 'Poking a single memory location only...'
	print
	# Input 'pokeaddress' as ASCII numerical characters.
	# Typo' errors are NOT catered for. BEWARE!!!.
	pokeaddress = raw_input('Input address in decimal:- ')
	print
	# Input 'pokebyte' as ASCII numerical characters.
	# Typo' errors are NOT catered for. BEWARE!!!.
	pokebyte = raw_input('Input byte value in decimal:- ')
	# Do NOT allow a NULL string OR a RETURN/NEWLINE character!.
	if pokeaddress == '': pokeaddress = '0'
	if pokeaddress == chr(13): pokeaddress = '0'
	if pokeaddress == chr(10): pokeaddress = '0'
	if pokeaddress == chr(10) + chr(13): pokeaddress = '0'
	if pokeaddress == chr(13) + chr(10): pokeaddress = '0'
	# Do NOT allow a NULL string OR a RETURN/NEWLINE character!.
	if pokebyte == '': pokebyte = '0'
	if pokebyte == chr(13): pokebyte = '0'
	if pokebyte == chr(10): pokebyte = '0'
	if pokebyte == chr(10) + chr(13): pokebyte = '0'
	if pokebyte == chr(13) + chr(10): pokebyte = '0'
	# Now poke a byte value into memory WITH EXTREME CARE!!!
	os.system('PYTHON:pokeb ' + pokeaddress + ' ' + pokebyte)
	print
	print 'Now peek the same memory location as a test...'
	# Call peekmem.py as a check to see if it has worked.
	execfile('PYTHON:Lib/peekmem.py')
main()
# End of simple PYTHON 'executable'.
