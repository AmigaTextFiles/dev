
# 'Voltmeter-DEMO.py' for classic AMIGAs AND WinUAE...
# A DEMO version of the 'Voltmeter.py' in the HW drawer.
# Using standard Python, Version 1.4...
# This WILL run on a stock A1200, NO FastRAM is needed, but it helps. :)
# This is (C)2006, B.Walker, G0LCU.
#
# BEST VIEWED IN 640x200 using standard TOPAZ 8 FONTS.
# Press 'Ctrl-C' to _STOP_ the program.

# Import the necessary components for this simple DEMO.
import os
import whrandom

# So now set up a working display that looks OK(ish :).
print '\f'
print '          Analogue and digital multimeter readout for TestGear series.'
print
print '                                   +--------+'
print '                                   | 0.00 V |'
print '                                   +--------+'
print
print '  5-50-500V.  0   0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0'
print '  2-20-200V.  0   0.2  0.4  0.6  0.8  1.0  1.2  1.4  1.6  1.8  2.0'
print '  1-10-100V.  0   0.1  0.2  0.3  0.4  0.5  0.6  0.7  0.8  0.9  1.0'
print '             *++++++++++++++++++++++++++++++++++++++++++++++++++++*'
print '            (*|                                                   *)'
print '             *+----+----+----+----+----+----+----+----+----+----+-*'

# This is the main coded segment.
def main():
	# Set all variables as global.
	global mybyte
	global digital
	global analogue
	global n

	# Allocate definate values.
	mybyte = 0
	digital = 0
	analogue = 0
	n = 0

	print '\n','                                   DEMO MODE.','\v\v'
	while 1:
		# This is the DEMO routine.
		# Generate a random number from 0 to 255.
		# This simulates a parallel port data byte access.
		mybyte = int(whrandom.random() * 256)
		# Generate a 1 second time delay using the 'Wait' command.
		os.system('Wait 1')
		# Convert to a digital number look.
		digital = mybyte * 0.02
		# Print the value in the box.
		print '\v\v\v\v\v\v\v\v\v','                                   |',digital,'V '
		# Now convert to analogue.
		analogue = (mybyte/5)
		# Clear the meter reading.
		print '\n\n\n\n\n\n','            (*|                                                   *)'
		print '\v','            (*',
		# Plot the meter movement to 0.1V accuracy.
		# Reset 'n' to plot.
		n = 0
		while n <= analogue:
			print '\b|',
			n = n + 1
		# Clean up for the next ~GRAB~.
		print
		print

main()
# Program End.
