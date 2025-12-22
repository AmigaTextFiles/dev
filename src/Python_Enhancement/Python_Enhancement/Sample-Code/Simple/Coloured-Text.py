
# A simple method of adding 4, (to 8), basic colours to the Python
# Programming Environment.
# This includes basic typefaces as well.
# The idea is copyright, (C)2007, B.Walker, G0LCU.
# It uses a standard AMIGADOS Shell and running Python IN that shell.
# It will only work RELIABLY this way.
# It NEEDS 'Echo' to be available in the AMIGAs PATH.
# It uses SOME of the ~Escape Codes~ available to 'Echo' to produce these
# results. In the code below are colour changes only, but any mixture
# of ForeGround, BackGround and TypeFaces can be added using this method.
# Written so that kids can understand it... :)

# This is the only import required for this DEMO.
import os

def main():
	# Ensure STANDARD ForeGround and BackGround colours.
	os.system('Echo "*e[31m *e[40m"')
	print "\f"
	print "We are going to use the AMIGA Shell to change text colours"
	print "and styles in a Python environment..."
	print
	print "This will SET Colour 2 ForeGround on Colour 0 BackGround."
	os.system('Echo "*e[32m *e[40m"')
	print "SET Colour 2 ForeGround on Colour 0 BackGround."
	os.system('Echo "*e[31m *e[40m"')
	print "This will SET Colour 3 ForeGround on Colour 2 BackGround."
	os.system('Echo "*e[33m *e[42m"')
	print "SET Colour 3 ForeGround on Colour 2 BackGround."
	os.system('Echo "*e[31m *e[40m"')
	print "\v "
	print "Now SET back to normal... :)"
	print	
main()
# Self explanatory but 'DEAD SIMPLE', Eh!
