
#                              IMPORTANT!!!
#                              ------------

#   !!!!!DO NOT RUN THIS SW WITHOUT THE 'PAR_READ.lha' HW ATTACHED!!!!!
#   -------------------------------------------------------------------

# An analogue and digital multimeter using standard Python, Version 1.4...
# This WILL run on a stock A1200, NO FastRAM is needed, but it helps. :)
# This is (C)2006, B.Walker, G0LCU. PAR_READ.lha from AMINET IS required.
#
#              http://main.aminet.net/hard/hack/PAR_READ.lha
#
# BEST VIEWED IN 640x200 using standard TOPAZ 8 FONTS.
# Press 'Ctrl-C' to _STOP_ the program.

# Import the necessary components for either REAL or DEMO mode.
import sys
import os
import time
import whrandom

# Test for genuine classic AMIGA platform.
# If it doesn't exist then completely quit the program and Python.
if sys.platform != 'amiga':
	print '\f'
	print 'This program is AMIGA A1200, (and greater), specific ONLY.'
	print
	print 'Closing down...'
	print
	time.sleep(3)
	# Shut down the program and Python.
	# Not really an error, so exit with ~RC~ of 0.
	sys.exit(0)

# If the correct platform print the version number.
if sys.platform == 'amiga':
	print '\f'
	print '$VER: Python_Multimeter_Version_0.20.32_(C)14-05-2006_B.Walker.'
	print
	# Ask for a check on the -ACK hardware.
	hw = raw_input('Is the ~-ACK~ hardware connected?, (UPPER CASE ONLY)-[Y/N]:- ')
	# If NOT present don't allow program to run.
	# ONLY UPPERCASE ~Y~ IS ALLOWED!!!
	if hw != 'Y':
		print '\f'
		print 'The ~-ACK~ hardware MUST be connected or the system WILL hang.'
		print
		print 'Closing down...'
		print
		time.sleep(3)
		# Shut down the program and Python.
		# Not really an error, so exit with ~RC~ of 0.
		sys.exit(0)

# Established that the ~-ACK~ hardware from ~PAR_READ.lha~ IS connected.
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

# Set up variables as global.
global pointer
global mybyte

# Allocate definate values.
pointer = 0
mybyte = 0

# This is the main working program. It is AMIGA compliant ONLY.
# Wake up the parallel port for use under this program.
pointer = open('PAR:', 'rb', 1)
mybyte = str(pointer.read(1))
# Put back to sleep again ready for general use.
pointer.close()

# This is the main coded segment.
def main():
	# Set up variables as global.
	global pointer
	global mybyte
	global digital
	global analogue
	global n

	# Allocate definate values.
	pointer = 0
	mybyte = 0
	digital = 0
	analogue = 0
	n = 0

	# Check for any A-D Converter connected to the Parallel Port.
	# This uses PAR: as a VOLUME in READ mode only.
	# PAR_READ.lha IS required for this to work.
	# Open up a channel for PAR: to be read.
	pointer = open('PAR:', 'rb', 1)
	# Grab an 8 bit data byte.
	mybyte = str(pointer.read(1))
	# Once grabbed IMMEDIATELY close the channel.
	pointer.close()
	# Convert the data byte to a decimal value.
	mybyte = (ord(mybyte))
	# If mybyte = 255 then no A-D Converter connected run in DEMO mode.
	# If mybyte <= 254 then A-D Converter exists so run in REAL mode.
	if mybyte == 255:
		# DEMO MODE!!!
		print '\n','                                   DEMO MODE.','\v\v'
		while 1:
			# This is the DEMO routine.
			# Generate a random number from 0 to 255.
			mybyte = int(whrandom.random() * 256)
			time.sleep(1)
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
			n = 0
			while n <= analogue:
				print '\b|',
				n = n + 1
			# Clean up for the next ~GRAB~.
			print
			print
	if mybyte <= 254:
		# REAL MODE!!!
		print '\n','                                   REAL MODE.','\v\v'
		# Detect the range type here!!!!!
		while 1:
			# This is the Parallel Port access routine.
			# Open up a channel for PAR: to be read.
			pointer = open('PAR:', 'rb', 1)
			# Grab an 8 bit data byte.
			mybyte = str(pointer.read(1))
			# Once grabbed IMMEDIATELY close the channel.
			pointer.close()
			# Convert the data byte to a decimal value.
			mybyte = (ord(mybyte))
			time.sleep(0)
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
			n = 0
			while n <= analogue:
				print '\b|',
				n = n + 1
			# Clean up for the next ~GRAB~.
			print
			print
main()
# Program End.
