# Turn autodoc files to amigagiude databases.
#
# Second draft July 7 1996 Gregor Goldbach
#
# Usage: makedoc source_dir destination_dir [-buildref]
#
# -buildref builds autodoc.xref, otherwise the one in
# source_dir is used


if $# < 2; abort; endif

set currentdir $_cwd

set ad2agpath "Work:Entwicklung/Werkzeuge/AD2AG/"

set tempdir $1
set destdir $2
md $destdir


strcmp $3 "-buildref"

if @strcmp( $3 "-buildref" ) = 0; $ad2agpath""AD2AG >NIL: FILES $tempdir TO $tempdir XREF; endif


$ad2agpath""AD2AG >NIL: FILES $tempdir TO $tempdir XREFFILE $tempdir/autodocs.xref

cd $tempdir
# del *.doc <>NIL:
cp -m ~(*.doc) $destdir <>NIL:

# cd /
# del $tempdir <>NIL:


cd $currentdir

unset currentdir
unset ad2agpath
unset destdir
unset tempdir
