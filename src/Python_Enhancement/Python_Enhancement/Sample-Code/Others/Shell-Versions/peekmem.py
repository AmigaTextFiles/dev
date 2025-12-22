
# PEEKB ONLY memory using an executable. This is very dangerous, so be
# VERY, VERY careful. The idea is to use the RETURN CODE of an executable
# to obtain a BYTE value from a hardware port of some kind. WORD and LONG
# WORD transfers also work so it would theoretically be possible to access
# say the AMIGA PCMCIA slot and obtain a 16 Bit value from it using PYTHON
# WITHOUT ANY special additions, JUST the basic interpreter and its
# standard 'libraries'.

# It IS possible to POKE values directly into memory or hardware registers,
# BUT I have NOT included this as it would be possible to crash the machine
# if you don't know what you are doing. 

# This LUNATIC idea belongs to copyright, (C)2006, B.Walker, G0LCU.

# A matching C source is issued which NEEDS to be compiled for this to work.
# It was intended for Classic AMIGA usage and compiled under Dice-C AND VBCC.
# You brain-bods out there COULD make it work on other platforms IF you so
# desired BUT I hold NO responsibility for ANY problems that may arise.

# Do any imports IF required.
import os

# Have it as an 'executeble' rather than an 'import'.
def main():
	# Set up any 'strings' or 'variables'.
	myaddress = '0'
	mybyte = 0
	# Use 'print' as a simple newline only.
	print
	# Input 'myaddress' as ASCII numerical characters. it does NOT
	# matter what is typed as the matching executable, after compiling
	# the attached C source code, takes care of any typos'.
	myaddress = raw_input('Input address in decimal:- ')
	# Do NOT allow a NULL string OR a RETURN/NEWLINE character!.
	if myaddress == '': myaddress = '0'
	if myaddress == chr(13): myaddress = '0'
	if myaddress == chr(10): myaddress = '0'
	if myaddress == chr(10) + chr(13): myaddress = '0'
	if myaddress == chr(13) + chr(10): myaddress = '0'
	# Ensure the AMIGADOS error is NOT SEEN!!!
	os.system('PYTHON:Plugins/Color 0 0')
	# 'mybyte' takes the RETURN CODE single byte returned from 'peek'
	# as being a READ memory location within the limits of the 'peek'
	# executable. ERRORS are taken care of inside 'peek' itself.
	mybyte = (os.system('PYTHON:Plugins/peek ' + myaddress))
	# Allow for newline when 'mybyte' is less than or equal to 9.
	if mybyte <= 9:print
	# Enable foreground and background colours again... :)
	os.system('PYTHON:Plugins/Color 1 0')
	# Display result(s) on a standard PYTHON command line interpreter,
	# running inside an AMIGADOS Shell.
	# IMPORTANT!!!, 'myaddress' is a string, NOT a number!. So ANYTHING
	# YOU type in WILL be displayed in the 'print' statement below as
	# gibberish, IF gibberish is what YOU have typed in, BUT, the C
	# executable WILL LIMIT ANY ERRORS to the NUMBERS 0 and 16777215
	# depending upon the error. In theory ALL errors are automatically
	# corrected, SO BEWARE!.
	# SEE the C source for more details.
	print 'Memory address in decimal is',myaddress,'and decimal byte value is',mybyte
	print
main()
# End of simple PYTHON 'executable'.
