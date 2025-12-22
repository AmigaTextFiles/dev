
# Arduino test for Python Windows GUI or Python Windows Command Line.
# This is an experimental idea only to test the Arduino Diecimila
# development board under Python 2.6.x.
# (It is assumed that the Python26 install is in the default folders.)
# This idea is copyright, (C)2008, B.Walker, G0LCU.
# Copy this `Arduino-Windows.py` file into the `C:\Python26\Lib\` folder
# and you will be ready to roll... ;-)

# To run type:-
# >>> execfile("C:\\Python26\\Lib\\Arduino-Windows.py")<RETURN/ENTER>
# Press ~Ctrl C~ to QUIT.

# Do any imports as required.
import os

# The program proper.
def main():
	print
	print '       Arduino Diecimila Dev Board access demonsration Python 2.x.x code.'
	print '               Original idea copyright, (C)2008, B.Walker, G0LCU.'
	print '                             Press ~Ctrl C~ to QUIT.'
	print

	# This is set up for my COM(n) port on this old P IV machine.
	# You WILL have to change it to suit the COM port number generated
	# by your particular machine. For example just change my COM5: to
	# your COMx: number in the lines below using a simple text editor.
	os.system("MODE COM5: BAUD=1200 PARITY=N DATA=8 STOP=1 to=on")

	while 1:
		# Open up a channel for USB/Serial reading on the Arduino board.
		pointer = open('COM5:', 'rb', 2)

		# Transfer an 8 bit number into `mybyte`.
		mybyte = str(pointer.read(1))

		# Immediately close the channel.
		pointer.close()

		# Place a wire link between ANALOG IN 0 and Gnd.
		# Replace the wire link between ANALOG IN 0 and 3V3.
		# Replace the wire link between ANALOG IN 0 and 5V.
		# Watch the values change.

		# Print the decimal value on screen.
		print 'Decimal value at Arduino ADC Port0 is:-',ord(mybyte),'.    '
main()
# End of program...
