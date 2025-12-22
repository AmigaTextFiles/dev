# ---------------------------------------------------------------------------
# Accessing the parallel port to import 8 bit data, (C)2006, B.Walker, G0LCU.
# ---------------------------------------------------------------------------
# This is my very first attempt at Python programming to create a stand alone
# running program that will obtain a single byte of data from an AMIGA
# parallel port and display the value on screen in decimal.
# It took me a number of hours of getting to grips with the syntax but once
# I had grasped it then it was only a matter of time before the parallel port
# would be mine for the taking. :)
# ---------------------------------------------------------------------------
# The experts out there will probably pull this to pieces BUT it works and
# that is what is important.
# ---------------------------------------------------------------------------
# The Python version for my A1200 was only V1.4 but was more than adequate
# for this exercise as it shows how EXTREMELY powerful PAR: is when used as
# a VOLUME. I have the deepest respect for the HW and SW engineers who
# designed the MIGGY as it can still do things that modern platforms can't.
# ---------------------------------------------------------------------------
# PAR_READ.lha from the hard/hack drawer of AMINET IS REQUIRED for this to
# work because PAR: used as a VOLUME HAS to have the -ACK line, Pin 10 of
# the parallel port, toggled continuously.
# ---------------------------------------------------------------------------
# Standard A1200, OS3.0x and topaz.font 8 were used for this program.
# ---------------------------------------------------------------------------
# The following import(s) are NOT required, but are left in for good measure.
# import amiga
# import os
# import ospath
# import cmd
# import commands
# import amigapath
# import shutil
# import arexx
# import dos
# import string
# import time
# import errno
# import rexec
# ---------------------------------------------------------------------------

# Set up a version number recognised by the AMIGAs version command.
version = '$VER: ParOpen.py_V1.00.00_(C)15-01-2006_B.Walker_G0LCU.'

# Set up a basic screen, IMPORTANT NOTE, ~print '\f'~ is used as the CLS
# command BUT this does NOT work under MS Windows(TM)... :/
print '\f'
print '           ',version
print
print '           Parallel Port access on the AMIGA using PAR: as a VOLUME.'
print
print '                            Press Ctrl-C to stop.'
print
print '               The decimal value at the parallel port is:- 0 .'

# This is the start of the continuous loop to grab the data sitting on the
# parallel port. It does about 2 samples per second and there IS a flaw here.
def main():

	while 1:
		# -----------------------------------------------------------
		# Set a pointer to the PAR: device and OPEN it up.
		pointer = open('PAR:', 'rb', 1)
		# Once set, grab my byte and ~store~ it.
		mybyte = str(pointer.read(1))
		# As soon as my byte is grabbed CLOSE down PAR:.
		pointer.close()
		# ===========================================================
		# Over print the printed line AND convert mybyte to a decimal value.
		print '\v','               The decimal value at the parallel port is:-',ord(mybyte),'.    '
		# Ctrl-C is used for stopping the program.
		# -----------------------------------------------------------

main()
