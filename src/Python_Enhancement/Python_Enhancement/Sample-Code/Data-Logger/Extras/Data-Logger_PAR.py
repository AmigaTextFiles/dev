
# A basic Data Logger using the Python command add-ons.
# This is classic AMIGA specific ONLY!!!
# Original idea copyright, (C)2007, B.Walker, G0LCU.

# Import necessary modules.
import sys
import os
import whrandom
import string
import time

# Completely quit the program and shut down Python if platform is NOT an AMIGA.
if sys.platform != 'amiga':sys.exit(0)

# -----------------------------------------------------------------------------
# Rely on the 'Python-Shell WINDOW' tool type for the correct window
# specifications. Set basic internal window parameters here.
os.system('Echo "*ec *e[4x *e[22y *ec"')
# Set the font to 'topaz 8'.
os.system('C:SetFont topaz SIZE 8')
# Set default foreground and background colours and clear the whole window.
os.system('PYTHON:Plugins/Color 1 0')
# Done setting up window initialisation.

# -----------------------------------------------------------------------------
# Allocate definate values to any required variables.
b = '\t\b\b\b\b\b\b                                        '
mystring = '0'
n = 0
mybyte = 0
pointer = 0
demo = 0

# -----------------------------------------------------------------------------
# Open up the parallel port for reading.
pointer = open('PAR:', 'rb', 1)
# Grab an 8 bit value.
mystring = str(pointer.read(1))
# Immediate close the parallel port again.
pointer.close()
# Convert to decimal.
mybyte = ord(mystring)
os.system('PYTHON:Plugins/Color 1 0')
os.system('PYTHON:Plugins/Locate 3 1')
if mybyte == 255:print 'Hardware NOT connected, DEMO mode only.'
if mybyte <= 254:print 'Hardware IS connected, REAL mode only.'
os.system('PYTHON:Plugins/Locate 1 1')
# Done setting up the parallel port.

# -----------------------------------------------------------------------------
# Setup the STATUS WINDOW for 'error' reports.
os.system('PYTHON:Plugins/Color 3 0')
os.system('PYTHON:Plugins/Locate 4 35')
print 'STATUS WINDOW.'
os.system('PYTHON:Plugins/Locate 1 1')
os.system('PYTHON:Plugins/DrawLine 4 54 636 54 2')
os.system('PYTHON:Plugins/Drawline 4 55 636 55 1')
# Done setting up the STATUS WINDOW.

# -----------------------------------------------------------------------------
# Setup the whole plotting window.
# Set colours to normal.
os.system('PYTHON:Plugins/Color 1 0')
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
	global pointer
	global mystring

	# Allocate definate startup values to the globals.
	a = '(C)2007, B.Walker, G0LCU.'
	b = '\t\b\b\b\b\b\b                                        '
	statusinfo = '        $VER: Data-Logger_PAR.py_Version_0.00.09_(C)2007_B.Walker_G0LCU.         '
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
	prompt = 0
	command = 'G0LCU'
	auto = 0
	mousex = 0
	mousey = 0
	continuing = 0
	pointer = 0
	mystring = '0'

	# Defines in this area. -----------------------------------------------
	#
	# The clear window routine.
	def clearwindow():
		global n

		# Set foreground and background colours to palette register 3.
		os.system('PYTHON:Plugins/Color 3 3')
		# Set the first print position.
		os.system('PYTHON:Plugins/Locate 6 1')
		n = 0
		# Print blank lines to clear the window.
		while n < 16:
			print b
			n = n + 1
		# Draw a basic graticule here.
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
		global pointer
		global mystring

		# Open up the parallel port for reading.
		pointer = open('PAR:', 'rb', 1)
		# Grab an 8 bit value.
		mystring = str(pointer.read(1))
		# Immediate close the parallel port again.
		pointer.close()
		# Convert to decimal.
		mybyte = ord(mystring)

	# Print status information inside the status window here.
	def status():
		global n

		# Reset colours to default.
		os.system('PYTHON:Plugins/Color 1 0')
		# Set print position to the status window.
		os.system('PYTHON:Plugins/Locate 1 1')
		n = 0
		# Print full length blank lines.
		while n < 3:
			print bl
			n = n + 1
		os.system('PYTHON:Plugins/Locate 3 1')
		print statusinfo
		# Set the print position to the status window.
		os.system('PYTHON:Plugins/Locate 1 1')

	# Check mouse position and left mouse buttom pressed.
	def checkmouse():
		global lmb
		global mousex
		global mousey
		global n

		# 'Hide' any AmigaDOS error reports.
		os.system('PYTHON:Plugins/Color 0 0')
		# Now obtain encoded mouse parameters.
		n = os.system('PYTHON:Plugins/Mouse')
		# Now do all of the calculations.
		lmb = int(n/16777216)
		mousex = int((n - (16777216*lmb))/4096)
		mousey = n - 16777216*lmb - 4096*mousex
		# Reset the colours back to default format.
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

	# This is the ~Command.~ button.
	def commandbutton():
		os.system('PYTHON:Plugins/Box 540 179 622 192 2')
		os.system('PYTHON:Plugins/Box 540 179 622 192 1')
		os.system('PYTHON:Plugins/Color 1 0')
		# Set print position to the status window.
		os.system('PYTHON:Plugins/Locate 1 1')

	#
	# End defines. --------------------------------------------------------

	# Program start. ======================================================
	paraport()
	if mybyte <= 254:demo = 0
	if demo == 0:statusinfo = 'Running in REAL mode.'
	if demo == 1:statusinfo = 'Running in DEMO mode.'
	whrandom.seed()
	status()
	clearwindow()
	while 1:
		checkmouse()
		if mousex >= 536 and mousex <= 618:mousex = 536
		if mousey >= 48 and mousey <= 61:mousey = 48
		if mousey >= 72 and mousey <= 85:mousey = 72
		if mousey >= 168 and mousey <= 181:mousey = 168
		if mousex == 536 and mousey == 168:
			if lmb == 1:
				commandbutton()
				statusinfo = 'Command mode, type HELP<ENTER> for online help.'
				start = 0
				prompt = 1
				status()
		while prompt == 1:
			os.system('PYTHON:Plugins/Color 1 0')
			os.system('PYTHON:Plugins/Locate 1 1')
			command = raw_input('COMMAND:- ')
			command = string.upper(command)
			if command == 'QUIT' or command == 'EXIT':cleanexit = 1
			if command == '':
				prompt = 0
				mousex = 536
				mousey = 48
				start = 0
				lmb = 1
				statusinfo = 'Press ~Run.~ to start plotting...'
				status()
			if command == 'AUTO':
				auto = 1
				statusinfo = 'Continuous mode.'
			if command == 'MANUAL':
				auto = 0
				statusinfo = 'Single shot mode.'
			if command == 'OFFSET':
				offset = (mybyte + 125 - 255)
				statusinfo = 'Offset calculated.'
			if command == 'RUN':
				start = 1
				plotx = 20
				prompt = 0
				mousex = 536
				mousey = 72
				continuing = 0
				statusinfo = 'Plotting...'
			if command == 'CONTINUE':
				start = 1
				prompt = 0
				mousex = 536
				mousey = 72
				continuing = 1
				statusinfo = 'Continue plotting...'
			if command == 'NORMAL':
				speed = 0
				start = 0
				statusinfo = 'Default speed, 1 second per plot.'
			if command == 'MEDIUM':
				speed = 9
				start = 0
				statusinfo = '10 seconds per plot.'
			if command == 'SLOW':
				speed = 99
				start = 0
				statusinfo = '100 seconds per plot.'
			if command == 'CLS':clearwindow()
			if cleanexit == 1:
				# Reset the parallel port back to its original state.
				os.system('PYTHON:Plugins/poke b 12575489 255')
				os.system('PYTHON:Plugins/poke b 12574977 255')
				# Quit without an error.
				sys.exit(0)
			status()
		# This routine enables to 'Stop.' button.
		if mousex == 536 and mousey == 48:
			if lmb == 1:
				stopbutton()
				statusinfo = 'Ready...'
				start = 0
				prompt = 0
				status()
		# This enables the 'Run.' button.
		if mousex == 536 and mousey == 72:
			if lmb == 1:
				runbutton()
				statusinfo = 'Plotting...'
				start = 1
				prompt = 0
				if continuing == 0:
					clearwindow()
					plotx = 20
				status()
		while start == 1:
			n = 0
			while n <= speed:
				os.system('PYTHON:Plugins/Color 0 0')
				os.system('PYTHON:Plugins/Locate 1 1')
				lmb = os.system('PYTHON:Plugins/peek 12574721')
				if lmb >= 128:lmb = lmb - 128
				if lmb <= 63:
					stopbutton()
					statusinfo = 'Plotting stopped.'
					lmb = 0
					start = 0
					prompt = 0
					status()
					break
				n = n + 1
			if demo == 0:paraport()
			if demo == 1:mybyte = int(whrandom.random() * 160)
			ploty = 255 - mybyte + offset
			if ploty <= 62:ploty = 62
			if ploty >= 189:ploty = 189
			xpos = str(plotx)
			ypos = str(ploty)
			os.system('PYTHON:Plugins/DrawPixel ' + xpos + ' ' + ypos + ' 2')	
			plotx = plotx + 1
			if auto == 1:
				os.system('PYTHON:Plugins/Color 1 0')
				os.system('PYTHON:Plugins/Locate 1 1')
				print 'Plot number',(plotx - 20),'\b.'
			if plotx >= 340:
				plotx = 20
				if auto == 1:
					clearwindow()
					start = 1
					prompt = 0
					statusinfo = 'Continuous plotting...'
				if auto == 0:
					start = 0
					prompt = 1
					statusinfo = 'Plotting halted...'
				status()
main()
# Reset the parallel port back to its original state.
os.system('PYTHON:Plugins/poke b 12575489 255')
os.system('PYTHON:Plugins/poke b 12574977 255')
# Program end. ================================================================
