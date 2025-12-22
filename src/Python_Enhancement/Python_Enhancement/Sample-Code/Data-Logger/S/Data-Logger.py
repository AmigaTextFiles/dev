
# A basic Data Logger using Python and the Python 'command' add-ons.
# This is classic AMIGA specific ONLY!!!
# Original idea copyright, (C)2007, B.Walker, G0LCU.
#
#                            VERY IMPORTANT!!!
#                            -----------------
#
# This hits the HDD a great deal in READ mode only, NOT in write mode AT ALL.
# It's no worse than MS Windows ??, (TM), which hammers a(n) HDD in both
# modes of access.

# -----------------------------------------------------------------------------
# Import ANY necessary modules.
import sys
import os
import whrandom
import string
import time
# IMPORTANT!!! There is a major problem with the 'time' module when used in
# WinUAE/AF2005. So therefore DO NOT try this out under WinUAE/AF2005 as a
# serious lock-up WILL result. ALSO assuming it would work at all then ONLY
# the DEMO mode would be available!!!

# Completely quit the program and shut down Python if platform is NOT an AMIGA.
if sys.platform != 'amiga':sys.exit(0)

# -----------------------------------------------------------------------------
# Rely on the 'Python-Shell WINDOW' tool type for the correct window
# specifications. Set basic internal window parameters here. 'Echo' clears
# the screen, sets the OVERALL horizontal and vertical top left hand corner
# print position, sets the default foreground and background colours, clears
# the screen again and 'locks' the whole for program usage.
# VERY IMPORTANT!!! This also ALLOWS for ANY SYSTEM font size of up to 19
# pixels height in the TITLE BAR!!!
os.system('Echo "*ec *e[4x *e[22y *e[31m *e[40m *ec"')
# Set the font to 'topaz 8', this FIXES the programs OWN font to allow for
# any strange fonts that YOUR system uses!!!
# IMPORTANT!!! This does NOT affect your system fonts AT ALL, ONLY the fonts
# inside this Python program...
os.system('C:SetFont topaz SIZE 8')
# Done setting up window initialisation.

# -----------------------------------------------------------------------------
# Allocate definate values to any required startup variables.
b = '\t\b\b\b\b\b\b                                        '
n = 0
mybyte = 0

# -----------------------------------------------------------------------------
# Open up the parallel port for direct reading.
os.system('PYTHON:Plugins/poke b 12575489 0')
# 'Hide' any AMIGADOS error reports as they are NOT ERRORS using 'Color'.
os.system('PYTHON:Plugins/Color 0 0')
# Read a value from the port and check for ADC connection.
mybyte = os.system('PYTHON:Plugins/peek 12574977')
# Double check the hardware.
mybyte = os.system('PYTHON:Plugins/peek 12574977')
os.system('PYTHON:Plugins/Color 1 0')
os.system('PYTHON:Plugins/Locate 3 1')
if mybyte == 255:print ' Hardware NOT connected, DEMO mode only.'
if mybyte <= 254:print ' Hardware IS connected, REAL mode only.'
os.system('PYTHON:Plugins/Locate 1 1')
# Done setting up the parallel port.

# -----------------------------------------------------------------------------
# Setup the STATUS WINDOW for 'error' reports.
os.system('PYTHON:Plugins/Color 3 0')
os.system('PYTHON:Plugins/Locate 4 35')
print 'STATUS WINDOW.'
# Reset colours back to normal.
os.system('PYTHON:Plugins/Color 1 0')
os.system('PYTHON:Plugins/Locate 1 1')
os.system('PYTHON:Plugins/DrawLine 4 54 636 54 2')
os.system('PYTHON:Plugins/Drawline 4 55 636 55 1')
# Done setting up the STATUS WINDOW.

# -----------------------------------------------------------------------------
# Setup the whole plotting window.
# Draw the box.
os.system('PYTHON:Plugins/Box 16 60 343 191 3')
# Set foreground and background colours to palette register 3.
os.system('PYTHON:Plugins/Color 3 3')
# Set the first print position.
os.system('PYTHON:Plugins/Locate 6 1')
n = 0
# Print blank lines to clear the window.
while n < 16:
	print b
	n = n + 1
os.system('PYTHON:Plugins/Color 3 0')
# Print the range characters.
os.system('PYTHON:Plugins/Locate 7 1')
print '+\n\n\n\n\n\n\n0\n\n\n\n\n\n-'
os.system('PYTHON:Plugins/Color 1 0')
os.system('PYTHON:Plugins/Locate 7 44')
print '+50    DATA-LOGGER.'
os.system('PYTHON:Plugins/Locate 14 44')
print '0  (C)2007, B.Walker.'
os.system('PYTHON:Plugins/Locate 20 44')
print '-50       G0LCU.'
# Done setting up the plotting window.

# -----------------------------------------------------------------------------
# Setup the buttons.
# This is a typical button setup.
os.system('PYTHON:Plugins/Box 540 59 622 72 2')
# Change the colour of the text to denote the setting.
os.system('PYTHON:Plugins/Color 2 0')
os.system('PYTHON:Plugins/Locate 6 71')
print 'Stop.'
os.system('PYTHON:Plugins/Box 540 83 622 96 1')
# Change the colour of the text back again.
os.system('PYTHON:Plugins/Color 1 0')
os.system('PYTHON:Plugins/Locate 9 71')
print 'Run.'
os.system('PYTHON:Plugins/Box 540 107 622 120 2')
# Change the colour of the text to denote the setting.
os.system('PYTHON:Plugins/Color 2 0')
os.system('PYTHON:Plugins/Locate 12 72')
print '1S.'
os.system('PYTHON:Plugins/Box 540 131 622 144 1')
# Change the colour of the text back again.
os.system('PYTHON:Plugins/Color 1 0')
os.system('PYTHON:Plugins/Locate 15 71')
print '10S.'
os.system('PYTHON:Plugins/Box 540 155 622 168 1')
os.system('PYTHON:Plugins/Locate 18 71')
print 'Slow.'
os.system('PYTHON:Plugins/Box 540 179 622 192 1')
os.system('PYTHON:Plugins/Locate 21 69')
print 'Command.'
# Set print position to the status window.
os.system('PYTHON:Plugins/Locate 1 1')
# Done setting up the buttons.

# -----------------------------------------------------------------------------
# This is the main running program.
def main():
	# Make ALL variables to be global.
	# IMPORTANT NOTE:- ~a~ is a string variable and ~n~ is an integer
	# variable - BOTH are purely for ~grabage~ usage ONLY and are
	# discarded after each call.
	# ALL variables are utilised as 'static typed' ONLY.
	global a
	global b
	global statusinfo
	global bl
	global n
	global mybyte
	global demo
	global speed
	global cleanexit
	global plotx
	global ploty
	global xpos
	global ypos
	global offset
	global lmb
	global start
	global prompt
	global command
	global auto
	global mousex
	global mousey
	global continuing
	global marker
	global trigmode
	global trigset
	global path
	global autosave
	global savename
	global filename

	# Allocate definate startup values to the globals.
	a = '(C)2007, B.Walker, G0LCU.'
	b = '\t\b\b\b\b\b\b                                        '
	statusinfo = '          $VER: Data-Logger.py_Version_0.10.00_(C)2007_B.Walker_G0LCU.         '
	bl = '                                                                               '
	n = 0
	mybyte = 77
	demo = 1
	speed = 0
	cleanexit = 0
	plotx = 20
	ploty = 125
	xpos = '20'
	ypos = '125'
	offset = -53
	lmb = 0
	start = 0
	prompt = 1
	command = 'G0LCU'
	auto = 0
	mousex = 0
	mousey = 0
	continuing = 0
	marker = 'ON'
	trigmode = 'OFF'
	trigset = 125
	path = 'RAM:'
	savename = path + '0000000000.DAT'
	autosave = 'OFF'
	filename = '<(C)2007_B.Walker_G0LCU.>'

	# Defines in this area. -----------------------------------------------

	# The clear window routine.
	def clearwindow():
		global n
		global b
		global marker

		# Set foreground and background colours to palette register 3.
		os.system('PYTHON:Plugins/Color 3 3')
		# Set the first print position.
		os.system('PYTHON:Plugins/Locate 6 1')
		n = 0
		# Print blank lines to clear the window.
		while n < 16:
			print b
			n = n + 1
		# Draw a basic marker lines here.
		if marker == 'ON':
			os.system('PYTHON:Plugins/DrawLine 20 75 339 75 1')
			os.system('PYTHON:Plugins/DrawLine 20 125 339 125 0')
			os.system('PYTHON:Plugins/DrawLine 20 175 339 175 1')
		# Reset colours to normal.
		os.system('PYTHON:Plugins/Color 1 0')
		# Set print position to the status window.
		os.system('PYTHON:Plugins/Locate 1 1')

	# Read the parallel port.
	def paraport():
		global mybyte

		# 'Hide' any AMIGADOS error reports.
		os.system('PYTHON:Plugins/Color 0 0')
		# Read a value from the port and check for ADC connection.
		mybyte = os.system('PYTHON:Plugins/peek 12574977')
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# Print status information inside the status window here.
	def status():
		global n
		global bl
		global statusinfo

		# Reset colours to default.
		os.system('PYTHON:Plugins/Color 1 0')
		# Set print position to the status window.
		os.system('PYTHON:Plugins/Locate 1 1')
		n = 0
		# Print full length blank lines.
		while n < 3:
			print bl
			n = n + 1
		# Set the 'status' print position and then print it.
		os.system('PYTHON:Plugins/Locate 3 1')
		print statusinfo
		# Ensure the 'STATUS WINDOW.' sign remains intact.
		os.system('PYTHON:Plugins/Color 3 0')
		os.system('PYTHON:Plugins/Locate 4 35')
		print 'STATUS WINDOW.'
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	def savefile():
		global savename
		global n
		global path

		n = time.time()
		n = int(n)
		savename = (path + str(n) + '.DAT')

	# Check mouse position and left mouse buttom pressed.
	def checkmouse():
		global lmb
		global mousex
		global mousey
		global n

		# 'Hide' any AmigaDOS error reports.
		os.system('PYTHON:Plugins/Color 0 0')
		# Obtain the encoded mouse parameters.
		n = os.system('PYTHON:Plugins/Mouse')
		# Now do all of the calculations.
		lmb = int(n/16777216)
		mousex = int((n - (16777216*lmb))/4096)
		mousey = n - 16777216*lmb - 4096*mousex
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# This enables the ~Stop.~ button and disables the ~Run.~ button.
	def stopbutton():
		os.system('PYTHON:Plugins/Box 540 59 622 72 2')
		# Change the colour of the text.
		os.system('PYTHON:Plugins/Color 2 0')
		os.system('PYTHON:Plugins/Locate 6 71')
		print 'Stop.'
		os.system('PYTHON:Plugins/Box 540 83 622 96 1')
		# Change the colour of the text.
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 9 71')
		print 'Run.'
		os.system('PYTHON:Plugins/Locate 1 1')

	# This enables the ~Run.~ button and disables the ~Stop.~ button.
	def runbutton():
		os.system('PYTHON:Plugins/Box 540 59 622 72 1')
		# Change the colour of the text.
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 6 71')
		print 'Stop.'
		os.system('PYTHON:Plugins/Box 540 83 622 96 2')
		# Change the colour of the text.
		os.system('PYTHON:Plugins/Color 2 0')
		os.system('PYTHON:Plugins/Locate 9 71')
		print 'Run.'
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# This clears ALL of the speed buttons.
	def clearspeed():
		os.system('PYTHON:Plugins/Box 540 107 622 120 1')
		# Change the colour of the text to default.
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 12 72')
		print '1S.'
		os.system('PYTHON:Plugins/Box 540 131 622 144 1')
		os.system('PYTHON:Plugins/Locate 15 71')
		print '10S.'
		os.system('PYTHON:Plugins/Box 540 155 622 168 1')
		os.system('PYTHON:Plugins/Locate 18 71')
		print 'Slow.'
		os.system('PYTHON:Plugins/Locate 1 1')

	# This sets the 1 Second/Pixel range button.
	def normalspeed():
		os.system('PYTHON:Plugins/Box 540 107 622 120 2')
		# Change the colour to highlight the range button.
		os.system('PYTHON:Plugins/Color 2 0')
		os.system('PYTHON:Plugins/Locate 12 72')
		print '1S.'
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# This sets the 10 Second/Pixel range button.
	def mediumspeed():
		os.system('PYTHON:Plugins/Box 540 131 622 144 2')
		# Change the colour to highlight the range button.
		os.system('PYTHON:Plugins/Color 2 0')
		os.system('PYTHON:Plugins/Locate 15 71')
		print '10S.'
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# This sets the Slow range button.
	def slowspeed():
		os.system('PYTHON:Plugins/Box 540 155 622 168 2')
		# Change the colour to highlight the range button.
		os.system('PYTHON:Plugins/Color 2 0')
		os.system('PYTHON:Plugins/Locate 18 71')
		print 'Slow.'
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# This is the ~Command.~ button.
	def commandbutton():
		os.system('PYTHON:Plugins/Box 540 179 622 192 2')
		os.system('PYTHON:Plugins/Box 540 179 622 192 1')
		os.system('PYTHON:Plugins/Color 1 0')
		os.system('PYTHON:Plugins/Locate 1 1')

	# End defines. --------------------------------------------------------

	# Program start. ======================================================
	# Double check whether the parallel port is available or not.
	paraport()
	if mybyte <= 254:demo = 0
	if demo == 0:statusinfo = ' REAL mode, press <RETURN/ENTER> to start plotting.'
	if demo == 1:statusinfo = ' DEMO mode, press <RETURN/ENTER> to start plotting.'
	# Set a random number seed IF running in demo mode!
	whrandom.seed()
	# Print the status at start up.
	status()
	# Clear the plotting window.
	clearwindow()

	# This is the main program loop.
	while 1:
		# Check the mouse parameters for each loop.
		checkmouse()

		# These are the ONLY 'mousex' horizontal limits required.
		if mousex >= 536 and mousex <= 618:mousex = 536

		# These are the 'mousey' vertical limits PER button.
		# The 'Run.' button.
		if mousey >= 48 and mousey <= 61:mousey = 48
		# The 'Stop.' button.
		if mousey >= 72 and mousey <= 85:mousey = 72
		# The '1S.' button.
		if mousey >= 96 and mousey <= 109:mousey = 96
		# The '10S.' button.
		if mousey >= 120 and mousey <= 133:mousey = 120
		# The 'Slow.' button.
		if mousey >= 144 and mousey <= 157:mousey = 144
		# The 'Command.' button.
		if mousey >= 168 and mousey <= 181:mousey = 168

		# These are the two values for the 'Command.' button.
		# NOTE:- This is FIRST in line, ONLY, to catch the 'COMMAND'
		# mode below it...
		if mousex == 536 and mousey == 168:
			# Check whether the LMB is pressed or not.
			if lmb == 1:
				commandbutton()
				statusinfo = ' Command mode, type HELP<RETURN/ENTER> for online help.'
				start = 0
				prompt = 1
				lmb = 0
				status()

		# If the 'Command.' button is pressed then enter COMMAND mode.
		while prompt == 1:
			os.system('PYTHON:Plugins/Color 1 0')
			os.system('PYTHON:Plugins/Locate 1 1')
			# ALL of the commands are NOT case sensitive!!!
			command = raw_input(' COMMAND:- ')
			command = string.upper(command)
			if command == 'QUIT' or command == 'EXIT':cleanexit = 1
			if command == 'STOP':
				print '\f User break, program halted!!!'
				print
				break
			if command == '':command = 'RUN'
			if command == 'HELP':
				statusinfo = ' HELP window, press <RETURN/ENTER> to continue.'
				status()
				os.system('PYTHON:Plugins/Locate 6 1')
				print '\t\b\b\b\b\b\b           COMMANDS AVAILABLE.          '
				print '\t\b\b\b\b\b\b           -------------------          '
				print '\t\b\b\b\b\b\b QUIT ................ Quit the program.'
				print '\t\b\b\b\b\b\b EXIT ................ Quit the program.'
				print '\t\b\b\b\b\b\b HELP .................. This HELP file.'
				print '\t\b\b\b\b\b\b AUTO ..... Set to Continuous Scan mode.'
				print '\t\b\b\b\b\b\b MANUAL ....... Set to Single Scan mode.'
				print '\t\b\b\b\b\b\b OFFSET ... Calibrate the A-D Converter.'
				print '\t\b\b\b\b\b\b RUN ........ Same as the ~Run.~ button.'
				print '\t\b\b\b\b\b\b CONTINUE ...... Continue with the scan.'
				print '\t\b\b\b\b\b\b NORMAL ...... Same as the ~1S.~ button.'
				print '\t\b\b\b\b\b\b MEDIUM ..... Same as the ~10S.~ button.'
				print '\t\b\b\b\b\b\b SLOW ...... Same as the ~Slow.~ button.'
				print '\t\b\b\b\b\b\b MARKERON ....... Enable 3 marker lines.'
				print '\t\b\b\b\b\b\b MARKEROFF ..... Disable 3 marker lines.'
				print '\t\b\b\b\b\b\b',
				raw_input(' Press <RETURN/ENTER> to continue.....  \b')
				os.system('PYTHON:Plugins/Locate 8 1')
				print '\t\b\b\b\b\b\b STOP ................ Stop the program.'
				print '\t\b\b\b\b\b\b CLS .. Clears the scanning window only.'
				print '\t\b\b\b\b\b\b <RETURN/ENTER> ONLY ...... Same as RUN.'
				print '\t\b\b\b\b\b\b TRIGOFF ........... Disable triggering.'
				print '\t\b\b\b\b\b\b TRIGPOS ....... Trigger positive going.'
				print '\t\b\b\b\b\b\b TRIGNEG ....... Trigger negative going.'
				print '\t\b\b\b\b\b\b TRIGEQU ........ Trigger exactly equal.'
				print '\t\b\b\b\b\b\b TRIGSET ..... Set trigger offset point.'
				print '\t\b\b\b\b\b\b SAVEOFF ........ Switch autosaving off.'
				print '\t\b\b\b\b\b\b SAVEON .......... Switch autosaving on.'
				os.system('PYTHON:Plugins/Locate 21 1')
				print '\t\b\b\b\b\b\b',
				raw_input(' Press <RETURN/ENTER> to continue.....  \b')
				command = 'CLS'
			if command == 'AUTO':
				auto = 1
				statusinfo = ' Continuous scanning mode.'
			if command == 'MANUAL':
				auto = 0
				statusinfo = ' Single scan mode.'
			if command == 'OFFSET':
				offset = (mybyte + 125 - 255)
				statusinfo = ' Offset calculated.'
			if command == 'RUN':
				start = 1
				plotx = 20
				prompt = 0
				mousex = 536
				mousey = 72
				lmb = 1
				continuing = 0
				statusinfo = ' Plotting...'
			if command == 'CONTINUE':
				start = 1
				prompt = 0
				mousex = 536
				mousey = 72
				lmb = 1
				continuing = 1
				statusinfo = ' Continue plotting...'
			if command == 'NORMAL':
				speed = 0
				start = 0
				prompt = 0
				mousex = 536
				mousey = 96
				lmb = 1
				statusinfo = ' Default speed, 1 second per plot.'
			if command == 'MEDIUM':
				speed = 9
				start = 0
				prompt = 0
				mousex = 536
				mousey = 120
				lmb = 1
				statusinfo = ' 10 seconds per plot.'
			if command == 'SLOW':
				speed = 99
				start = 0
				prompt = 0
				mousex = 536
				mousey = 144
				lmb = 1
				statusinfo = ' 100 seconds per plot.'
			if command == 'CLS':
				statusinfo = ' Clear the scanning window ONLY.'
				status()
				clearwindow()
				statusinfo = ' Command mode, type HELP<RETURN/ENTER> for online help.'
			if command == 'MARKERON':
				marker = 'ON'
				statusinfo = ' Marker lines ' + marker + '.'
			if command == 'MARKEROFF':
				marker = 'OFF'
				statusinfo = ' Marker lines ' + marker + '.'
			if command == 'TRIGOFF':
				trigmode = 'OFF'
				statusinfo = ' Trigger set to ' + trigmode + '.'
			if command == 'TRIGPOS':
				trigmode = 'POS'
				statusinfo = ' Trigger set to ' + trigmode + 'ITIVE going.'
			if command == 'TRIGNEG':
				trigmode = 'NEG'
				statusinfo = ' Trigger set to ' + trigmode + 'ATIVE going.'
			if command == 'TRIGEQU':
				trigmode = 'EQU'
				statusinfo = ' Trigger set to exactly ' + trigmode + 'AL.'
			if command == 'TRIGSET':
				statusinfo = ' Set the trigger point from -50 to +50.'
				status()
				os.system('PYTHON:Plugins/Color 1 0')
				os.system('PYTHON:Plugins/Locate 1 1')
				a = raw_input(' Characters MUST BE ~+~, ~-~ AND NUMBERS ONLY:- ')
				# Hide AMIGADOS RC 'ERROR'.
				os.system('PYTHON:Plugins/Color 0 0')
				# Ensure ALWAYS a string to integer conversion!!!
				n = os.system('PYTHON:Plugins/Val ' + a)
				# Ensure that '-1' is catered for!!!
				if a == '-1':n = string.atoi(a)
				# Finally, ensure whole numbers ONLY.
				n = int(n)
				# Set the limits from -50 to +50.
				if n <= -50:n = -50
				if n >= 50:n = 50
				trigset = 125 - n
				statusinfo = ' Trigger start point set at ' + str(n) + '.'
			if command == 'SAVEOFF':
				autosave = 'OFF'
				savefile()
				statusinfo = ' Autosave ' + autosave + '.'
			if command == 'SAVEON':
				autosave = 'ON'
				savefile()
				statusinfo = ' Filename to save is ~' + savename + '~.'
			if cleanexit == 1:
				# Reset the parallel port back to its original
				# state, output mode.
				os.system('PYTHON:Plugins/poke b 12575489 255')
				os.system('PYTHON:Plugins/poke b 12574977 255')
				# Quit without an error.
				sys.exit(0)
			status()
		if command == 'STOP':break

		# These are the two values for the 'Stop.' button.
		if mousex == 536 and mousey == 48:
			# Check whether the LMB is pressed or not.
			if lmb == 1:
				stopbutton()
				statusinfo = ' Ready...'
				start = 0
				prompt = 0
				continuing = 0
				lmb = 0
				status()

		# These are the two values for the 'Run.' button.
		if mousex == 536 and mousey == 72:
			# Check whether the LMB is pressed or not.
			if lmb == 1:
				runbutton()
				statusinfo = ' Plotting...'
				start = 1
				prompt = 0
				# This determines whether a continuous plot
				# OR a fresh start of plotting occurs.
				if continuing == 0:
					clearwindow()
					plotx = 20
				lmb = 0
				status()

		# These are the two values for the '1S.' button.
		if mousex == 536 and mousey == 96:
			# Check whether the LMB is pressed or not.
			if lmb == 1:
				clearspeed()
				normalspeed()
				statusinfo = ' Scanning speed 1S/Pixel.'
				speed = 0
				status()

		# These are the two values for the '10S.' button.
		if mousex == 536 and mousey == 120:
			# Check whether the LMB is pressed or not.
			if lmb == 1:
				clearspeed()
				mediumspeed()
				statusinfo = ' Scanning speed 10S/Pixel.'
				speed = 9
				status()

		# These are the two values for the 'Slow.' button.
		if mousex == 536 and mousey == 144:
			# Check whether the LMB is pressed or not.
			if lmb == 1:
				clearspeed()
				slowspeed()
				statusinfo = ' Scanning speed 100S/Pixel.'
				speed = 99
				status()

		# This is the TRIGGER loop.
		while start == 1:
			# Detect disable triggering first.
			if trigmode == 'OFF':break
			# Enable some form of get out.
			# Set the ~RC~ to the status window and HIDE it.
			os.system('PYTHON:Plugins/Color 0 0')
			os.system('PYTHON:Plugins/Locate 1 1')
			# Detect whether LMB is pressed or not.
			# This looks directly at the hardware...
			lmb = os.system('PYTHON:Plugins/peek 12574721')
			if lmb >= 128:lmb = lmb - 128
			if lmb <= 63:break
			# Obtain 'mybyte' in either mode and compare against
			# the trigger value.
			if demo == 0:paraport()
			if demo == 1:mybyte = int(whrandom.random() * 160)
			ploty = 255 - mybyte + offset
			if trigmode == 'EQU':
				if ploty == trigset:break
			if trigmode == 'NEG':
				if ploty <= trigset:break
			if trigmode == 'POS':
				if ploty >= trigset:break

		# Reset the trigger mode to free running.
		trigmode = 'OFF'
		# This is the main plotting loop.
		while start == 1:
			# This section checks the LMB ONLY, about once a
			# second, irrespective of the scan rate selected.
			n = 0
			while n <= speed:
				os.system('PYTHON:Plugins/Color 0 0')
				os.system('PYTHON:Plugins/Locate 1 1')
				# It looks directly at the hardware...
				lmb = os.system('PYTHON:Plugins/peek 12574721')
				if lmb >= 128:lmb = lmb - 128
				if lmb <= 63:
					# This PAUSES the scan ONLY, pressing
					# the 'Run.' button CONTINUE(s) from
					# where the scan was PAUSED!!!
					stopbutton()
					statusinfo = ' Plotting paused...'
					lmb = 0
					start = 0
					prompt = 0
					continuing = 1
					status()
					break
				n = n + 1

			# Simple decision of parallel port OR demo mode.
			if demo == 0:paraport()
			if demo == 1:mybyte = int(whrandom.random() * 160)

			# Do correction for viewing on screen relative to
			# the graphics layout of the machine.
			ploty = 255 - mybyte + offset

			# Ensure NO OVERSCAN errors occur.
			if ploty <= 62:ploty = 62
			if ploty >= 189:ploty = 189

			# Convert numbers to a string.
			xpos = str(plotx)
			ypos = str(ploty)

			# Now call the plotting command.
			os.system('PYTHON:Plugins/DrawPixel ' + xpos + ' ' + ypos + ' 2')	

			# Move along one horizontal pixel.
			plotx = plotx + 1

			# This section may OR may not be left in!!!
			# It prints the number of the plot in progress
			# inside the status window.
			if auto == 1:
				os.system('PYTHON:Plugins/Color 1 0')
				os.system('PYTHON:Plugins/Locate 3 1')
				print ' Plot number',(plotx - 20),'\b.                  '

			# This is called when 'autosave' is set to 'ON'.
			# IMPORTANT NOTE:- This is saved in MS (R) Excel
			# format ~.CSV~ although it is saved to disk as ~.DAT~
			# format. Just change the extension from .DAT to .CSV
			# and open in Excel as normal. Also the DIRECT value
			# from the parallel port is saved WITHOUT any
			# correction(s) done on it.
			if autosave == 'ON':
				a = str(mybyte)
				filename = open(savename, 'ab', -1)
				filename.write(a + chr(13) + chr(10))
				filename.close()

			# This resets the plot position to the start.
			# If autosaving is ~ON~ then a new filename is
			# automatically generated for the next scan when
			# used in 'Continuous mode'.
			if plotx >= 340:
				plotx = 20
				savefile()
				# This is called in 'Continuous Mode' after
				# 320 horizontal plots have been made.
				if auto == 1:
					clearwindow()
					start = 1
					prompt = 0
					statusinfo = ' Continuous plotting...'

				# This is called in 'Single Scan' mode after
				# 320 horizontal plots have been made.
				# Autosaving mode is disabled; and this will
				# place the program into ~COMMAND:- ~ mode.
				if auto == 0:
					stopbutton()
					start = 0
					prompt = 1
					continuing = 0
					lmb = 0
					autosave = 'OFF'
					statusinfo = ' Command mode, type HELP<RETURN/ENTER> for online help.'
				status()

	# This point is reached ONLY when 'STOP' has been inputted in
	# 'COMMAND:-' mode above. This will RESET the parallel port back
	# to its original state, SEE BELOW, and place you into the
	# 'Python command' mode......
	# >>> _
main()
# If the program is stopped normally then RESET the parallel port.
os.system('PYTHON:Plugins/poke b 12575489 255')
os.system('PYTHON:Plugins/poke b 12574977 255')
# Program end. ================================================================
