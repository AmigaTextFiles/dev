
# Generating buttons for PSEUDO-GUI usage.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
# This IS SSLLOOW but it works... :)
#
# $VER: Buttons.py_Version_0.00.10_(C)2007_B.Walker_G0LCU.

# Do necessary imports.
import os
import sys

# The section is very, VERY important!!!
# It sets the plot position for ALL text operations and is used to allow
# for strange system fonts that make the title bar look odd. If set to a
# horizontal of 4 pixels and a vertical of 22 pixels then a font height
# of up to 19 pixels will be catered for in the title bar.
# 'Echo' command clears the WHOLE of the window, sets the PRINT position,
# sets the foreground and background colours and clears the window again
# to 'lock it'.
# It MUST be the first command followed by an optional 'SetFont' command.
# Note:- 'SetFont' also clears the window...

# IMPORTANT LINE!!!
os.system('Echo "*ec *e[4x *e[22y *e[31m *e[40m *ec"')
# SECOND MOST INPORTANT LINE!!!
# Set MY TEST FONT to 'topaz font 8'.
os.system('C:SetFont topaz SIZE 8')

# Now set up the buttons.
# A simple usable button.
os.system('PYTHON:Plugins/Box 240 50 320 64 1')
os.system('PYTHON:Plugins/Locate 5 33')
print 'Hello.'
# A 'Stop.' button.
os.system('PYTHON:Plugins/Box 240 82 320 96 1')
os.system('PYTHON:Plugins/Locate 9 33')
print 'Stop.'
# A 'Quit.' button.
os.system('PYTHON:Plugins/Box 240 114 320 128 1')
os.system('PYTHON:Plugins/Locate 13 33')
print 'Quit.'

def main():
	# Set any variables as globals!
	global mousex
	global mousey
	global lmb
	global rc

	# Allocate definate values to the globals.
	mousex = 0
	mousey = 0
	lmb = 1
	rc = 0

	# Check mouse position and left mouse buttom pressed.
	def checkmouse():
		global lmb
		global mousex
		global mousey
		global rc

		# 'Hide' any AmigaDOS error reports.
		os.system('PYTHON:Plugins/Color 0 0')
		# Set print position to an unused area.
		os.system('PYTHON:Plugins/Locate 1 1')
		# Now obtain encoded mouse parameters.
		rc = os.system('PYTHON:Plugins/Mouse')
		# Hidden 'rc' printed here.
		# Now do all of the calculations.
		lmb = int(rc/16777216)
		mousex = int((rc - (16777216*lmb))/4096)
		mousey = rc - 16777216*lmb - 4096*mousex
		# Reset the colours back to default format.
		os.system('PYTHON:Plugins/Color 1 0')

	# This enables the ~Hello.~ button.
	# It takes around 1 second for a standard A1200 to respond!
	def button1():
		os.system('PYTHON:Plugins/Box 240 50 320 64 2')
		os.system('PYTHON:Plugins/Box 240 50 320 64 1')

	# This enables the ~Stop.~ button.
	# It takes around 1 second for a standard A1200 to respond!
	def button2():
		os.system('PYTHON:Plugins/Box 240 82 320 96 2')
		os.system('PYTHON:Plugins/Box 240 82 320 96 1')

	# This enables the ~Quit.~ button.
	# It takes around 1 second for a standard A1200 to respond!
	def button3():
		os.system('PYTHON:Plugins/Box 240 114 320 128 2')
		os.system('PYTHON:Plugins/Box 240 114 320 128 1')

	while 1:
		# Get the mouse parameters for PSEUDO-GUI usage.
		checkmouse()
		# Set the bounds for EACH button!
		if mousex >= 236 and mousex <= 316:mousex = 236
		if mousey >= 39 and mousey <= 53:mousey = 39
		if mousey >= 71 and mousey <= 85:mousey = 71
		if mousey >= 103 and mousey <= 117:mousey = 103

		# Respond to the correct button then check for LMB pressed.
		if mousex == 236 and mousey == 39:
			if lmb == 1:
				# When button1 pressed just print 'Hello World...'
				button1()
				os.system('PYTHON:Plugins/Locate 1 1')
				print 'Hello World...'
				lmb = 0

		if mousex == 236 and mousey == 71:
			if lmb == 1:
				# When button2 pressed 'Stop.'
				button2()
				os.system('PYTHON:Plugins/Locate 16 1')
				print 'Program stopped!'
				print
				lmb = 0
				break

		if mousex == 236 and mousey == 103:
			if lmb == 1:
				# When button3 pressed 'Quit.' and closedown.
				button3()
				sys.exit(0)

main()
# This is a method of generating buttons and using them.
# It is SSLLOOWW but it works... :) 
