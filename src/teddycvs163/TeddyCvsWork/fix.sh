#!/bin/sh
#
# This script can be used to convert sources
# back to unix format after editing in windows
# environment.
#
# Now it also skips data files and visual
# studio project and workspace files :)
#
# Timo Suoranta
perl -i -pe 's/\r\n?/\n/' `find . ! -name '*.opt' -and ! -name '*.dsp' -and ! -name '*.dsw' -and ! -name '*.gif' -and ! -name '*.jpg' -and ! -name '*.png' -and -type f`
