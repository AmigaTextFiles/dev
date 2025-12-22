
# A DEMO analogue and digital readout using standard Python Version 3000.
# The code for actual Arduino Diecimila Dev Board access is commented out below!!!
# DO NOT TAKE THIS EXAMPLE TO SERIOUSLY... :-)

# This was an experiment to see if the idea worked for an MS-DOS window
# or screen from Windows 2000 to XP-SP2, and 'kind of' does! :oD
# (It might even work on Windows Vista in windowed Command Prompt Mode...)

# Original copyright, (C)2008, B.Walker, G0LCU.
# Intended usage for the Arduino Diecimila Dev Board project.
# "mybyte" is randomly generated but can be substituted with the "COMx:" reading
# inside this Python 3000 code by removing all the necessary comments.

# This simple code is public domain.
# NO PROFIT WILL BE MADE FROM IT, OR DERIVATIVES OF IT, BUT IT CAN BE USED
# FREELY IN ANY CODE OF YOUR OWN.
# (A SECONDARY LICENCE ISSUED UNDER GPL2 ALSO, AS PROTECTION.)

# Import necessary modules for this DEMO only.
# NOTE:- "random" and "time" are NOT needed when real time hardware access is used.
import random
import time
import os
import sys

# This is set up for my "COMx:" port on this old P IV machine.
# You WILL have to change it to suit the "COMx:" port number generated
# by your particular machine. For example just change my "COM5:" to
# your "COMx:" number in ANY lines below using a simple text editor.

# os.system("MODE COM5: BAUD=1200 PARITY=N DATA=8 STOP=1 to=on")

# Use the system's own clear screen command.
os.system("CLS")

# The main working code.
def main():
	# Set up variables as global irrespective of whether they are needed or not!
	global mybyte
	global digital
	global analogue
	global n
	global display

	# Allocate definate initial values.
	mybyte = 0
	digital = 0
	analogue = 0
	n = 0
	display = '              '

	while 1:
		# Generate a number as though taken from the USB/Serial port.
		# NOTE:- not needed when using proper hardware.
		mybyte = int(random.random() * 256)

		# THIS CODE BELOW IS FOR REAL HARDWARE CONNECTION!!!

		# Open up a channel for USB/Serial reading on the Arduino board.
		# pointer = open('COM5:', 'rb', 2)

		# Transfer an 8 bit number into `mybyte`.
		# mybyte = ord(pointer.read(1))

		# Immediately close the channel.
		# pointer.close()

		# END OF CODE FOR REAL HARDWARE ACCESS!!!

		# Convert to a value to look like 0 to 5V on the digital readout.
		digital = mybyte * 0.02

		# *** These notes below apply to the dedicated hardware only. ***
		# Place a wire link between ANALOG IN 0 and Gnd.
		# Replace the wire link between ANALOG IN 0 and 3V3.
		# Replace the wire link between ANALOG IN 0 and 5V.
		# !!!IMPORTANT!!! THE CALIBRATION ~WILL~ BE SLIGHTLY WRONG!!!
		# *** Watch the values change each time you connect up. ***

		# Clear the screen to set up a working display and for any re-run.
		os.system("CLS")

		print()
		print('               Original idea copyright, (C)2008, B.Walker, G0LCU.')
		print('          Analogue and digital DEMO readout for simple animation test.')
		print()
		print('                                   +--------+')
		print('                                     ',digital)
		print('                                   +--------+')
		print('                                     Volts.')

		# Convert to some sort of bar style analogue look.
		analogue = (mybyte/5)

		print()
		print('     Scale:-  0   0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0')
		print('              ++++++++++++++++++++++++++++++++++++++++++++++++++++')

		# Do the simple animation for the analogue bar meter effect.
		n = 0
		display = '              '
		while n <= analogue:
			display = display + '|'
			n = n + 1
		print(display)
		print('              +----+----+----+----+----+----+----+----+----+----+-')
		print()
		print('                             Press ~Ctrl C~ to QUIT.')

		# Hold for about 1 second to simulate the hardware timings.
		# NOTE:- not needed when using hardware access directly.
		time.sleep(2)
main()
# End of demo.
