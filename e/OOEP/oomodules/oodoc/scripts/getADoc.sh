# Get autodoc information from E sources.
# Takes all *.e (recursively) from the current location.
#
# Second draft July 7 1996 Gregor Goldbach
#
#
# Usage: makedoc destination_directory
#


if $# = 0; abort; endif

set currentdir $_cwd
set adocpath "Work:Entwicklung/Werkzeuge/Autodoc/"
set tempdir $1


# note that the autodoc options are case sensitive
alias getADoc "%source%dest $adocpath\"\"Autodoc -t8 -I -C $source >$tempdir/$dest "

md $tempdir

# take all E sources recursively and extract autodocs.
#
# take this line to get all file names printed:
# foreach i ( .../*.e ) "strhead x \".\" $i; basename n $x; echo -n \"Get docs from \"$x; getADoc $i $n.doc; if @filelen( $tempdir/$n.doc ) = 20; del $tempdir/$n.doc; echo \" (purged)\"; else; echo \" (exists)\"; endif"

foreach i ( .../*.e ) "strhead x \".\" $i; basename n $x; getADoc $i $n.doc; if @filelen( $tempdir/$n.doc ) = 20; del $tempdir/$n.doc; else; echo  \"Get docs from \"$x; endif"

cd $currentdir

unset currentdir
unset adocpath
unset tempdir
