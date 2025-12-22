
# DO NOT TAKE THIS EXAMPLE TO SERIOUSLY... :)

# This was an experiment to see if the idea worked for an MS-DOS winodw
# or screen from Windows ME to XP-SP2, and with the 'Clr' import, it
# 'kind of' does, (badly)!

# A demo analogue and digital readout using standard Python Version 1.4+
# for a classic AMIGA or Version 2.4x for Windows ME to XP-SP2.

# This uses an experimental module that clears the screen on platforms
# AMIGA and an MS-DOS window or screen using MS Windows ME to XP-SP2.
# Original copyright, (C)2006, B.Walker, G0LCU.

# Import necessary modules for this demo.
import whrandom
import time
import Clr

# Use this experimental clear screen module.
Clr.cls()

# The main working code.
def main():
	# Set up variables as global.
	global mybyte
	global digital
	global analogue
	global n

	# Allocate definate values.
	mybyte = 0
	digital = 0
	analogue = 0
	n = 0

	while 1:
		# Generate a number as though taken from a parallel port.
		mybyte = int(whrandom.random() * 256)
		# Convert to a value to look like a 5V on the digital readout.
		digital = mybyte * 0.02
		# Set up a working display.
		print
		print '          Analogue and digital demo readout for simple animation test.'
		print
		print '                                   +--------+'
		print '                                     ',digital
		print '                                   +--------+'
		print
		# Convert to some sort of analogue look.
		analogue = (mybyte/5)
		print
		print '    Scale.    0   0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0'
		print '              ++++++++++++++++++++++++++++++++++++++++++++++++++++'
		print '              ',
		# Do the simple animation for the analogue look.
		n = 0
		while n <= analogue:
			print '\b|',
			n = n + 1
		print
		print '              +----+----+----+----+----+----+----+----+----+----+-'
		# Hold for about 1 second.
		time.sleep(2)
		# Clear the screen for a re-run.
		Clr.cls()
main()
# End of demo.
