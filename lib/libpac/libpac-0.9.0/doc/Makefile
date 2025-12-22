all:		libpac.info html

libpac.info:	*.texinfo
		makeinfo libpac.texinfo

html:		*.texinfo
		makeinfo libpac.texinfo --html -o html

clean:
		-rm -rf *.info html
