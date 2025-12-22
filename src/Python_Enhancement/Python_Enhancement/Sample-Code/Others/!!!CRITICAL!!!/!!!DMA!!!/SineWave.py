
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
	global chipmemaddress
	global address
	global volume
	global frequency
	global period
	global pokeaddress
	global hwaddress
	global pokevalue
	global enterselect
	global vers

	# Allocate definate values to the variables.
	# Note, deliberately set ChipMem to the 256KB boundary WITHOUT
	# allocating it, 'chipmemaddress' is the de-facto address!!!
	chipmemaddress = 262144
	address = chipmemaddress
	volume = 64
	frequency = 1000
	period = int(3563220/(8*frequency))
	pokeaddress = '262144'
	hwaddress = '14676118'
	pokevalue = '90'
	enterselect = '1'
	vers = '       $VER: SineWave.py_Version_0.50.00_(C)31-01-2007_B.Walker_G0LCU.'

	# Clear the screen and display version number.
	print '\f'
	print vers

	# Sine wave sample values, note negative numbers are NOT allowed!!!.
	# These are the NORMAL numbers, 0, 90, 127, 90, 0, -90, -128, -90.
	# These are the converted munbers, 0, 90, 127, 90, 0, 166, 128, 166.
	# These are the four word values, 90, 32602, 166, 32934.
	# 'pokevalue' for the first poke is already set above.
	pokeaddress = (str(address))
	os.system('PYTHON:Plugins/poke w ' + pokeaddress + ' ' + pokevalue)

	# Move up 2 bytes.
	address = (address + 2)
	pokeaddress = (str(address))
	pokevalue = '32602'
	os.system('PYTHON:Plugins/poke w ' + pokeaddress + ' ' + pokevalue)

	# Move up 2 bytes.
	address = (address + 2)
	pokeaddress = (str(address))
	pokevalue = '166'
	os.system('PYTHON:Plugins/poke w ' + pokeaddress + ' ' + pokevalue)

	# Move to last 2 bytes.
	address = (address + 2)
	pokeaddress = (str(address))
	pokevalue = '32934'
	os.system('PYTHON:Plugins/poke w ' + pokeaddress + ' ' + pokevalue)
	# ALL DONE!!! Now poke in the hardware registers as shown below.

	# Generate an audio tone.
	# POKEW 14676118,15		'Switch off audio dma.
	# POKEL 14676128,chipmemaddress	'Set address to chip ram.
	#                               'Done in two word chunks.
	# POKEW 14676132,4		'Number of words in data sample.
	# POKEW 14676134,period		'Period of sampling time.
	# POKEW 14676136,volume		'Volume max 64, min 0.
	# POKEW 14676126,255		'Disable any other modulation.
	# POKEW 14676118,33281		'Enable sound on CH1.
	# POKE 12574721,252		'Enable/Disable audio filter.

	# Poke to disable the audio DMA.
	pokevalue = '15'
	hwaddress = '14676118'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

	# Two word values to make the long word memory address pointer.
	# Long winded but it works... :)
	# Poke for the upper 16 bits here.
	address = int(chipmemaddress/65536)
	pokevalue = (str(address))
	hwaddress = '14676128'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)
	# Poke for the lower 16 bits here.
	address = (chipmemaddress-(address*65536))
	pokevalue = (str(address))
	hwaddress = '14676130'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

	# Number of words in data sample, FIXED for this example.
	pokevalue = '4'
	hwaddress = '14676132'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

	# Set up the period.
	period = int(3563220/(8*frequency))
	pokevalue = str(period)
	hwaddress = '14676134'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

	# Set up the volume level.
	pokevalue = str(volume)
	hwaddress = '14676136'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

	# Disable any other modulation modes.
	pokevalue = '255'
	hwaddress = '14676126'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

	# Start the tone.
	pokevalue = '33281'
	hwaddress = '14676118'
	os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)
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
			hwaddress = '14676134'
			os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

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
			hwaddress = '14676136'
			os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)

		if enterselect == '3':
			# Poke to disable the audio DMA.
			print
			print '...BYE...'
			print
			pokevalue = '15'
			hwaddress = '14676118'
			os.system('PYTHON:Plugins/poke w ' + hwaddress + ' ' + pokevalue)
			sys.exit(0)

main()
# Program End.
