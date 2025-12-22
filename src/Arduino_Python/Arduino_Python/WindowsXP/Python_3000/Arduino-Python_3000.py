
# Arduino Diecimila Dev Board test for Python 3000 for Windows.

# original idea copyright, (C)2008, B.Walker, G0LCU.
# This simple code is public domain.
# NO PROFIT WILL BE MADE FROM IT, OR DERIVATIVES OF IT, BUT IT CAN BE USED
# FREELY IN ANY CODE OF YOUR OWN.
# (A SECONDARY LICENCE ISSUED UNDER GPL2 ALSO, AS PROTECTION.)
# Press ~Ctrl C~ to QUIT.

# Do any necessary imports.
import os

def main():
	print()
	print('        Arduino Diecimila Dev Board access demonsration Python 3000 code.')
	print('               Original idea copyright, (C)2008, B.Walker, G0LCU.')
	print('                             Press ~Ctrl C~ to QUIT.')
	print()

	# Set up the Arduino Board serial port.
	# Note: "COM5:" WILL need to be changed to your "COMx:" port number.
	os.system("MODE COM5: BAUD=1200 PARITY=N DATA=8 STOP=1 to=on")

	while 1:
		# Open up "COMx:" channel to read an 8 bit value from "Analog 0"
		# of the Arduino Diecimila Dev Board.
		pointer = open('COM5', 'rb', 2)

		# Convert to a decimal number for easy reading.
		mybyte = ord(pointer.read(1))

		# Immediately close the channel.
		pointer.close()

		# Place a wire link between ANALOG IN 0 and Gnd.
		# Replace the wire link between ANALOG IN 0 and 3V3.
		# Replace the wire link between ANALOG IN 0 and 5V.
		# Watch the values change.

		# Print the decimal value to the screen.
		print('Decimal value at Arduino ADC Port0 is:-',mybyte,'. ')
main()
# End of VERY simple Python 3000 DEMO code.
