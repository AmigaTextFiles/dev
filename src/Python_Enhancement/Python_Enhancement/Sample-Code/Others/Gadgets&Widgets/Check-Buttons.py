
# SIMPLE check button generation for PSEUDO-GUI usage.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
# This IS SSLLOOWW but it works... :)
#
# $VER: Check-Buttons.py_Version_0.00.10_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os
import whrandom

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

# Set up three check buttons.
# Check button one shown as a 'default' ON.
os.system('PYTHON:Plugins/Locate 6 2')
print '[X]  First number is 1.'
print
# Check button two.
print ' [ ]  Second number is 1.'
print
# Check button three.
print ' [ ]  Third number is 1.'

def main():
	# Set random number seed.
	whrandom.seed()
	# Set any variables as globals!
	global mousex
	global mousey
	global lmb
	global rc
	global m
	global n
	global o
	global cbone
	global cbtwo
	global cbthree

	# Allocate definate values to the globals.
	mousex = 0
	mousey = 0
	lmb = 1
	rc = 0
	m = 1
	n = 1
	o = 1
	cbone = 0
	cbtwo = 1
	cbthree = 1

	# Check mouse position and left mouse buttom pressed.
	def checkmouse():
		global lmb
		global mousex
		global mousey
		global rc

		# 'Hide' any AmigaDOS error reports.
		os.system('PYTHON:Plugins/Color 0 0')
		# Set the print position to an unused area.
		os.system('PYTHON:Plugins/Locate 1 1')
		# Now obtain encoded mouse parameters.
		rc = os.system('PYTHON:Plugins/Mouse')
		# The 'rc' is printed BUT hidden here!!!
		# Now do all of the calculations.
		lmb = int(rc/16777216)
		mousex = int((rc - (16777216*lmb))/4096)
		mousey = rc - 16777216*lmb - 4096*mousex
		# Reset the colours back to default format.
		os.system('PYTHON:Plugins/Color 1 0')

	# This is check button one.
	# It takes around 1 second for a standard A1200 to respond!
	def checkbutton1():
		global cbone
		global lmb

		os.system('PYTHON:Plugins/Locate 6 3')
		if cbone == 0 and lmb == 1:
			print ' '
			cbone = 1
			lmb = 0
		if cbone == 1 and lmb == 1:
			print 'X'
			cbone = 0
			lmb = 0

	# This is check button two.
	# It takes around 1 second for a standard A1200 to respond!
	def checkbutton2():
		global cbtwo
		global lmb

		os.system('PYTHON:Plugins/Locate 8 3')
		if cbtwo == 0 and lmb == 1:
			print ' '
			cbtwo = 1
			lmb = 0
		if cbtwo == 1 and lmb == 1:
			print 'X'
			cbtwo = 0
			lmb = 0

	# This is check button three.
	# It takes around 1 second for a standard A1200 to respond!
	def checkbutton3():
		global cbthree
		global lmb

		os.system('PYTHON:Plugins/Locate 10 3')
		if cbthree == 0 and lmb == 1:
			print ' '
			cbthree = 1
			lmb = 0
		if cbthree == 1 and lmb == 1:
			print 'X'
			cbthree = 0
			lmb = 0

	while 1:
		# Press Ctrl-C to stop!
		# Get the mouse parameters for PSEUDO-GUI usage.
		checkmouse()
		# Set the bounds for EACH checkbutton!
		if mousex >= 10 and mousex <= 29:mousex = 10
		if mousey >= 51 and mousey <= 57:mousey = 51
		if mousey >= 67 and mousey <= 73:mousey = 67
		if mousey >= 83 and mousey <= 89:mousey = 83

		# Respond to the correct button then check for LMB pressed.
		if mousex == 10 and mousey == 51:
			if lmb == 1:
				checkbutton1()
		if mousex == 10 and mousey == 67:
			if lmb == 1:
				checkbutton2()
		if mousex == 10 and mousey == 83:
			if lmb == 1:
				checkbutton3()

		# Whichever check button is set generate a random number.
		# If any are NOT set then the number displayed will be the
		# last known number for that button!
		if cbone == 0:m = (1 + int(whrandom.random() * 100))
		if cbtwo == 0:n = (1 + int(whrandom.random() * 100))
		if cbthree == 0:o = (1 + int(whrandom.random() * 100))

		# Print any results to the window.
		os.system('PYTHON:Plugins/Locate 6 23')
		print m,'\b.     '
		os.system('PYTHON:Plugins/Locate 8 24')
		print n,'\b.     '
		os.system('PYTHON:Plugins/Locate 10 23')
		print o,'\b.     '

		# Print a calculation to the window also.
		print
		print 'Total value is',(n*m*o),'\b.    '
main()
# This is a method of generating buttons and using them.
# It is SSLLOOWW but it works... :)
