
# It is designed for a stock A1200 and Python 1.4x minimum.
# The idea is copyright, (C)2007, B.Walker, G0LCU.
# Written for kids to understand... :)

# DrawLine:-
# DrawLine <xstart> <ystart> <xfinish> <yfinish> <colour><RETURN/ENTER>
#
# Where:-
# 'xstart' is a value between 0 and 1280.
# 'xfinish' is a value between 0 and 1280.
# 'ystart' is a value between 0 and 1024.
# 'yfinish' is a value between 0 and 1024.
# 'colour' is a value between 0 and 7, (31).

# DrawPixel:-
# DrawPixel <x> <y> <colour><RETURN/ENTER>
#
# Where:-
# 'x' is a value from 0 to 1280.
# 'y' is a avlue from 0 to 1024.
# 'colour' is a value from 0 to 7, (31).

# Box:-
# Box <xstart> <ystart> <xfinish> <yfinish> <type><RETURN/ENTER>
#
# Where:-
# 'xstart' is a value between 0 and 1280.
# 'xfinish' is a value between 0 and 1280.
# 'ystart' is a value between 0 and 1024.
# 'yfinish' is a value between 0 and 1024.
# 'type' is a value between 1 and 3.

# Circle:-
# Circle <x> <y> <radius> <colour> <start> <finish> <aspect><RETURN/ENTER>
#
# Where:-
# 'x' is a value from 0 to 1280.
# 'y' is a value from 0 to 1024.
# 'radius' is a value from 1 to 1280.
# 'colour' is a value from 0 to 7, (31).
# 'start' is a value from 0 to 359.
# 'finish' is a value from 0 to 359.
# 'aspect' is a value from 0.1 to 10.

# Paint:-
# Paint <x> <y> <colour1> <colour2><RETURN/ENTER>
#
# Where:-
# 'x' is a value from 0 to 1280.
# 'y' is a value from 0 to 1024.
# 'colour1' is a value from 0 to 7, (31).
# 'colour2' is a value from 0 to 7, (31).

# The only import required.
import os

# Clear the screen, this MUST be Python RUN in an AMIGADOS Shell!!!
print "\f"

# Start of this demo, note the syntax!...
def main():
	# This needs NO explanation.
	os.system('PYTHON:Plugins/DrawLine 100 100 200 100 2')
	os.system('PYTHON:Plugins/DrawLine 200 101 200 150 1')
	os.system('PYTHON:Plugins/DrawLine 201 100 201 151 1')
	os.system('PYTHON:Plugins/DrawLine 200 151 100 151 1')
	os.system('PYTHON:Plugins/DrawLine 100 150 100 101 2')
	os.system('PYTHON:Plugins/DrawLine 99 151 99 100 2')
	os.system('PYTHON:Plugins/DrawPixel 80 80 2')
	os.system('PYTHON:Plugins/DrawPixel 81 81 2')
	os.system('PYTHON:Plugins/DrawPixel 82 82 2')
	os.system('PYTHON:Plugins/DrawPixel 83 83 2')
	os.system('PYTHON:Plugins/DrawPixel 84 84 1')
	os.system('PYTHON:Plugins/DrawPixel 85 85 1')
	os.system('PYTHON:Plugins/DrawPixel 86 86 1')
	os.system('PYTHON:Plugins/DrawPixel 87 87 1')
	os.system('PYTHON:Plugins/DrawPixel 88 88 2')
	os.system('PYTHON:Plugins/DrawPixel 89 89 2')
	os.system('PYTHON:Plugins/DrawPixel 90 90 2')
	os.system('PYTHON:Plugins/DrawPixel 91 91 2')
	os.system('PYTHON:Plugins/Box 350 50 450 100 3')
	os.system('PYTHON:Plugins/Circle 550 100 20 2 0 359 0.44')
	os.system('PYTHON:Plugins/Paint 550 100 3 2')
main()
# End of program.
