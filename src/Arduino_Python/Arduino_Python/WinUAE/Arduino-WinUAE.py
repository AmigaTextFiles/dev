
# Arduino test for Python 1.4.x under WinUAE only, NOT classic AMIGAs.
# This is an experimental idea only to test the Arduino Diecimila
# development board under Python 1.4.x and WinUAE.
# (It is assumed that the Python 1.4.x install is in the default drawers.)
# NOTE:- This code also works to Python 2.0.x inside WinUAE.
# This idea is copyright, (C)2008, B.Walker, G0LCU.
# Copy this `Arduino-Windows.py` file into the 'PYTHON:Lib/' drawer
# and you will be ready to roll... ;-)
# Press ~Ctrl C~ to QUIT.

# To run type:-
# >>> execfile("PYTHON:Lib/Arduino-WinUAE.py")<RETURN/ENTER>

# Do any imports as required.
import os

# The program proper.
def main():
	print
	print '      Arduino Diecimila Dev Board access demonsration Python 1.4.x code.'
	print '             Original idea copyright, (C)2008, B.Walker, G0LCU.'
	print '                           Press ~Ctrl C~ to QUIT.'
	print

	while 1:
		# Open up a channel for USB/Serial reading on the Arduino board.
		# Place a wire link between ANALOG IN 0 and Gnd.
		# Replace the wire link between ANALOG IN 0 and 3V3.
		# Replace the wire link between ANALOG IN 0 and 5V.
		# Watch the values change.
		pointer = open('SER:', 'rb', 2)

		# Transfer an 8 bit number into `mybyte`.
		mybyte = str(pointer.read(1))

		# Immediately close the channel.
		pointer.close()

		# Print the decimal value on screen.
		print 'Decimal value at Arduino ADC Port0 is:-',ord(mybyte),'.    '
main()
# End of program...
