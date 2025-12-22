
                                 CXRef.doc

	Free   software.   But  if  you  use  it,  please  send  an  e-mail.
Redistribute  is  allowed,  but only with the full source. Read the licence.
The  GNU  General  Public  Licence  is  valid for all files in this archive.
----------------------------------------------------------------------------

	This  is  a  utility for programmers, for give help for a keystroke,
like  the  'Function  reference'  function of GoldED. If your editor support
Rexx,  then  you can easily connect it with CXRef. The program is commodity,
just for unburden the removing.
----------------------------------------------------------------------------

1)  You have to create the reference file, before use the main program. This
is simple:

	mref -q c.xref Autodoc: ADE:include ADE:os-include

This line make the xref file for gcc. Format of mref:

	mref [options] databasefilename dir1 [dir2 ... dirN]

Options:
	-q	Quiet mode (do not echo any warnings)
	-g	GoldED mode (default: CED mode)
		There some difference with the line numbering of some
		editors. For example the GoldED count the non-printable
		chars like a full line, but the CED includes some
		non-printable character in the next line.
	-u	Unique keys only
		When use this option, the duplicated keys will deleted both,
		without this option, one of the duplicated keys remain in
		the database.
	-s	Add structures into the database

	The option abbreviation (-qgu) is not implemented.
----------------------------------------------------------------------------

2)  You have to write a simple ARexx script for the editor. (I wrote one for
CED)

ARexx commands for CXRef:

	QUIT	Quiting
	SEARCH	WORD function
		Find the function (case sensitive) in the database, and give
		you the full filename and line number in the result. For
		example:
		SEARCH WORD OpenLibrary
		result=="Autodoc:exec.doc 3428"
	SEARCH	STEM res. WORD function
		This is the same, but you get the result into the supplied
		variable instead in result.
		SEARCH STEM ret. WORD OpenLibrary
		ret.filename=="Autodoc:exec.doc"
		ret.linenumber=="3428"
----------------------------------------------------------------------------

3)  Set  the  tooltype  'XREFFILE'  according  to the place and name of your
database file. (XREFFILE=DH0:Programming/full.xref)
----------------------------------------------------------------------------

4) Install the script into your editor.
----------------------------------------------------------------------------

Used programs:

	gcc
	libnix
	ARexxBox
	make
	flex
	CatComp
	ver		(included) utility for update the version string
