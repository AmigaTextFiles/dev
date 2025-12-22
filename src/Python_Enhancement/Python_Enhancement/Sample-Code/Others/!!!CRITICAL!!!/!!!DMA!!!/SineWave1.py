
#                !!!!!YOU RUN THIS SW AT YOUR ONW RISK!!!!!
#                ------------------------------------------

# Generating a SineWave using standard Python, Version 2.0x minimum...
# THIS IS NOT PROVEN AT ALL, BUT......

# ......IT SEEMS TO WORK on AF2005, WinUAE in '68040+ JIT mode and full
# sound enabled on a(n) HP Pavillion Notebook, model number dv2036ea,
# using Windows XP-SP2; also IT SEEMS TO WORK on a(n) A1200 with FastRam
# added and Python 1.4x but I DO NOT AND WILL NOT GUARANTEE IT!!!
# READ THE !!!DANGER!!! FILE THOROUGHLY...

# This IDEA ONLY is (C)01-01-2007, B.Walker, G0LCU.
# BEST VIEWED IN 640x200 using standard TOPAZ 8 FONTS.
# To RUN from the Python prompt type:-
# >>> execfile('PYTHON:<Drawer/>SineWave.py')<RETURN/ENTER>
# Where <Drawer/> is the location of 'SineWave.py'.
# Press Ctrl-C to __STOP__ the program.

# THIS IS A MUCH SIMPLIFIED VERSION OF 'SineWave.py'.

# IF IN DOUBT DO NOT RUN THIS CODE!!!

# Import any necessary module components.
import sys
import os

# Test for genuine classic AMIGA platform.
# If it doesn't exist then completely quit the program and Python.
if sys.platform != 'amiga':
	print '\f'
	print 'This program is BIG-BOX AMIGA, 68040+, specific ONLY.'
	print
	raw_input('Press <ENTER/RETURN> to close down:- ')
	# Shut down the program and Python.
	# Not really an error, so exit with ~RC~ of 0.
	sys.exit(0)

# This is the main coded segment.
def main():
	# Clear the screen.
	print '\f',

	# Before entering a control loop access and setup the audio hardware.
	# Make various variables global.
	global volume
	global frequency
	global period
	global pokevalue
	global enterselect
	global vers

	# Allocate definate values to the variables.
	# Note, deliberately set ChipMem to the 256KB boundary WITHOUT
	# allocating it, address 262144 decimal is the de-facto address!!!
	volume = 64
	frequency = 1000
	period = int(3563220/(8*frequency))
	pokevalue = '4'
	enterselect = '1'
	vers = '       $VER: SineWave.py_Version_0.50.00_(C)31-01-2007_B.Walker_G0LCU.'

	# Clear the screen and display version number.
	print '\f'
	print vers

	# Sine wave sample values, note negative numbers are NOT allowed!!!.
	# These are the NORMAL numbers, 0, 90, 127, 90, 0, -90, -128, -90.
	# These are the converted munbers, 0, 90, 127, 90, 0, 166, 128, 166.
	# These are the four word values, 90, 32602, 166, 32934.
	# Now 'poke' ChipMem with the correct values. 
	os.system('PYTHON:Plugins/poke w 262144 90')
	# Move up 2 bytes.
	os.system('PYTHON:Plugins/poke w 262146 32602')
	# Move up 2 bytes.
	os.system('PYTHON:Plugins/poke w 262148 166')
	# Move to last 2 bytes.
	os.system('PYTHON:Plugins/poke w 262150 32934')
	# ALL DONE!!! Now poke in the hardware registers as shown below.

	# Generate an audio tone using these values.
	# POKEW 14676118,15		'Switch off audio dma.
	# POKEL 14676128,262144		'Set address to chip ram.
	#                               'Done in two word chunks.
	# POKEW 14676132,4		'Number of words in data sample.
	# POKEW 14676134,period		'Period of sampling time.
	# POKEW 14676136,volume		'Volume max 64, min 0.
	# POKEW 14676126,255		'Disable any other modulation.
	# POKEW 14676118,33281		'Enable sound on CH1.
	# POKE 12574721,252		'Enable/Disable audio filter.

	# Poke to disable the audio DMA.
	os.system('PYTHON:Plugins/poke w 14676118 15')

	# Two word values to make the long word memory address pointer.
	# Long winded but it works... :)
	# Poke for the upper 16 bits here, set to chipmem address 262144.
	os.system('PYTHON:Plugins/poke w 14676128 4')
	# Poke for the lower 16 bits here.
	os.system('PYTHON:Plugins/poke w 14676130 0')

	# Number of words in data sample, FIXED for this example.
	os.system('PYTHON:Plugins/poke w 14676132 4')

	# Set up the period.
	os.system('PYTHON:Plugins/poke w 14676134 445')

	# Set up the volume level.
	os.system('PYTHON:Plugins/poke w 14676136 64')

	# Disable any other modulation modes.
	os.system('PYTHON:Plugins/poke w 14676126 255')

	# Start the tone.
	os.system('PYTHON:Plugins/poke w 14676118 33281')
	# ALL DONE!!! Now enter USER mode.

	while 1:
		# So this is a decent looking screen eh!
		print '\f'
		print vers
		print
		print '                       1) To change the frequency.'
		print '                       2) To set the volume level.'
		print '                       3) To QUIT completely.'
		print
		print '                  Frequency is',frequency,'\bHz, and volume is',volume,'\b.   '
		print
		print '             Press Ctrl-C<RETURN/ENTER> to stop this program.'
		print
		# Enter either 1, 2 or 3.
		enterselect = raw_input( '               Enter a menu number, then <RETURN/ENTER>:- ')
		if enterselect == '1':
			# Set up the period.
			print
			# IMPORTANT!!!
			# Only the numbers 0 to 9 can be used!!!
			# ANY OTHER ASCII character will cause a numeric
			# evaluation ERROR!!!
			frequency = input('Enter a new frequency, 300 to 3000 then <RETURN/ENTER>:- ')
			if frequency <= 300: frequency = 300
			if frequency >= 3000: frequency = 3000
			period = int(3563220/(8*frequency))
			pokevalue = str(period)
			os.system('PYTHON:Plugins/poke w 14676134 ' + pokevalue)

		if enterselect == '2':
			# Set up the volume level.
			print
			# IMPORTANT!!!
			# Only the numbers 0 to 9 can be used!!!
			# ANY OTHER ASCII character will cause a numeric
			# evaluation ERROR!!!
			volume = input('Enter a new volume level, 0 to 64 then <RETURN/ENTER>:- ')
			if volume <= 0: volume = 0
			if volume >= 64: volume = 64
			pokevalue = str(volume)
			os.system('PYTHON:Plugins/poke w 14676136 ' + pokevalue)

		if enterselect == '3':
			# Poke to disable the audio DMA.
			os.system('PYTHON:Plugins/poke w 14676118 15')
			sys.exit(0)

main()
# Program End.
