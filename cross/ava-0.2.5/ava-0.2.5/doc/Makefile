# AVA
# User's Manual
# Uros Platise (c) 1999
#
# Check directory before installation!
#
# To compile you need full tex distribution and latex2html converter.
#
# To compile type: make
# To install type: make install

	DOC_DIR	= /usr/doc/uTools/ava

all:	ava.ps

ava.dvi:	ava.tex
		latex ava.tex

ava.ps:	ava.dvi
		dvips ava.dvi -o

#html: 		ava.tex
#	export ICONSERVER=../../icons
#	latex2html -index_in_navigation -show_section_numbers -font_size 11pt -info "" -html_version 3.1 -split 3 ava

install:
	mkdir -r $(DOC_DIR)
	cp ava.ps $(DOC_DIR)
#	cp -r ava $(DOC_DIR)/html
