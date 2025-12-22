Although I always said, I'll never provide BLINK support for gnu-ld, I sort
of did now. This converter (hunk2gcc) allows you to
  o  convert object files in hunk form into a.out object files
  o  convert ALINK style (ie. concatenated) libraries into a collection of 
     a.out files, that you later can move into an archive with `ar'

Since I don't yet have a 3rd edition of the AmigaDOS manual (sigh, I wonder
whether our dear book stores manage to get a copy still this year;-() [they
didn't, it's now April'92 ;-((] I didn't have documentation for the new
hunk types dealing with base relative addressing.  I tried to implement
them based on how the non base relative types work, don't know if I did it
right. Ld does now support base relative symbols, but since I don't have
any hunk format object files containing base relative relocs, I can't
really verify that hunk2gcc translates them correctly (I doubt it does...).
If you find out what needs to be changed, please tell me, I'd like hunk2gcc
to be able to convert small data libraries just as well as it can now
convert large data libraries.

I wrote this converter mainly because I didn't like the idea of
disassembling and reassembling amiga.lib, and I really wanted to use those
commodities support functions;-) I tested the converter on amiga.lib, and
(besides generating huge disk traffic...) it seemed to work, at least those
programs I used the library with seem to work as they should.

However, I really don't have the necessary amount of object files and
libraries in this format to decide whether I missed one or two cases, so 
please tell me about bugs you find.

For the new HUNK_INDEX and HUNK_LIB types:  I asked a friend (that
amazingly got his copy of the 3rd edition somewhere from outer space I
guess;-)) just how I should skip them cleanly..  It turned out that those
hunks are not just additions to the existing hunks, they really replace the
old style hunks, and I just didn't see a reason why I should support this
ugly (IMHO) construction, overall librarians that generate such libraries
should be able to generate oldstyle ALINK libraries as well.


How to use this tool
--------------------
Best thing is, make a new directory where you want your converted object
files to go, cd into it, and enter

  hunk2gcc commo:amiga.lib [..further libs if you like..]

This generats an a.out object file for every program unit present in the
hunk file (in this case, from amiga.lib).

I first wanted to use the name of the program unit for the name of the
object file, but soon saw that those names are rarely to never useful, they
often aren't even set, and sometimes (hi SAS..) even contain `.c' names,
not right what you usually want as object file;-) Names that are used now
start with `obj.', followed by a serial number, followed by a pattern
built from the task address, such that the generated name is unique and
doesn't overwrite any existing file. 

As the final step convert all those files into an a.out style library by
issuing:

  ar qc libamiga.a obj.*
  ranlib libamiga.a

The ranlib run builds a symbol table in the archive, and makes accesses to
the library much faster.

If you just want to convert a single object file, you might give it a
nicer name after the conversion ;-)


So...  all you SAS users, switching to gcc was never easier!  You can still
use your libraries, just take the large-model/non-regpar libraries, convert
them with oml into oldstyle libraries or just extract all files and run
hunk2gcc over them with `hunk2gcc *'.  You can then start to use the new
driver that calls ld instead of ln (or blink, if you used the BuRP driver),
and got your proper gcc environment.


HAVE FUN!

Markus Wild

PS: Please read the header of hunk2gcc.c for copyright/disclaimer.
    You can reach me as <wild@nessie.cs.id.ethz.ch>.
