
# Generating basic, rising, ringing tones using the Sound command.
# This uses all four channels and produces a multi-bell effect.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
#
# Sound:-
# Sound <period> <length> <volume> <channel><RETURN/ENTER>
# Where:-
# 'period' is a value from 128 to 4999.
# 'length' is a value from 1 to 999.
# 'volume' is a value from 0 to 64.
# 'channel' is a value from 0 to 3.
#
# $VER: Sound.py_Version_0.00.04_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os

# This is the sound test.
def main():
	os.system('Run >NIL: PYTHON:Plugins/Sound 450 20 64 0')
	os.system('Run >NIL: PYTHON:Plugins/Sound 400 20 64 1')
	os.system('Run >NIL: PYTHON:Plugins/Sound 350 20 64 2')
	os.system('Run >NIL: PYTHON:Plugins/Sound 300 20 64 3')
main()
# And that's all there is to it.
