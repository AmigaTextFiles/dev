
# D-L-C-F stands for DrawLine, Locate, Coloured-Text and Font... :)

# This sample code will draw a raised '3D' type box along with inverse
# highlighted text inside of it using a Python Shell under AMIGADOS.
# It also places the cursor at the required positions and resets the
# cursor back to the top left hand corner when done.
# Enjoy... :)

# It is designed for a stock A1200 and Python 1.4x minimum.
# The idea is copyright, (C)2007, B.Walker, G0LCU.
# Written for kids to understand... :)

# DrawLine:-
# DrawLine <xstart> <ystart> <xfinish> <yfinish> <colour><RETURN/ENTER>

# Where:-
# 'xstart' is a value between 0 and 1280.
# 'xfinish' is a value between 0 and 1280.
# 'ystart' is a value between 0 and 1024.
# 'yfinish' is a value between 0 and 1024.
# 'colour' is a value between 0 and 7, (31).

# Locate:-
# Locate <line> <column><RETURN/ENTER>

# Where:-
# 'line' is a value between 1 and 60.
# 'column' is a value between 1 and 160.

# The only import required.
import os

# Clear the screen, this MUST be Python RUN in an AMIGADOS Shell!!!
print "\f"

# Start of this demo, note the syntax!...
def main():
	# This needs NO explanation.
	os.system('C:SetFont topaz SIZE 8')
	os.system('PYTHON:Plugins/DrawLine 100 100 200 100 2')
	os.system('PYTHON:Plugins/DrawLine 200 101 200 150 1')
	os.system('PYTHON:Plugins/DrawLine 201 100 201 151 1')
	os.system('PYTHON:Plugins/DrawLine 200 151 100 151 1')
	os.system('PYTHON:Plugins/DrawLine 100 150 100 101 2')
	os.system('PYTHON:Plugins/DrawLine 99 151 99 100 2')
        os.system('Echo "*e[32m *e[41m"')
	os.system('PYTHON:Plugins/Locate 15 16')
	print "Hello!!"
	os.system('Echo "*e[31m *e[40m"')
	print "\v "
	os.system('PYTHON:Plugins/Locate 1 1')
main()
# End of program.
