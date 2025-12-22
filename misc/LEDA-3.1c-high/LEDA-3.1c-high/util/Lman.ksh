# Lman Korn Shell Script (by Ulrich Lauther)
#
# Set Variables 
# "man_dir" to the path name of the LEDA manual directory
# "awk_cmd" to your awk command (must be compatible with GNU gawk)


#man_dir=/usr/local/leda/man
#awk_cmd=awk
man_dir=/KM/usr/naeher/leda/man
awk_cmd=gawk


[ ! -d $man_dir ] && {
  print    ""
  print -n "Cannot find LEDA manual directory,"
  print    " change variable 'man_dir' in '$0' \!"
  print    ""
  exit 1
}

if [ "$1" = "-l" ]
then
  less=0
  shift
else
  less=1
  if [ "$1" = "-t" ]
  then
    textedit=1
    shift
  else
    textedit=0
  fi
fi


[ "$1" = "" ] && {
clear
print "Lman - print LEDA manual pages"
print " "
print "Syntax: "
print " "
print "    lman   T   [op]"
print " "
print "Arguments: "
print " "
print "    T   :  name of a LEDA data type"
print " "
print "    op  :  name of an operation of data type T or one of the section names"
print "           definition, declaration, creation, operations, or implementation"
print " "
print "Usage: "
print " "
print "    lman  T        prints the manual page for data type T (piped through less)."
print " "
print "    lman  T  op    prints the manual entry for operation T::op or section"
print "                   op of the manual page for T (if op is a section name)."
print " "
print " "
exit 1
}

tex_file=$man_dir/$1.tex
awk_script=$man_dir/AWK


if [ -f $tex_file ]
then
  if [ "$2" != "" ]
  then
    while [ "$2" != "" ]
    do
      $awk_cmd -f $awk_script $tex_file $2 
      shift
    done
  else
   if [ "$less" = 1 ]
   then
    #$awk_cmd -f $awk_script $tex_file | less -+M -+m -e -n -P"LEDA Manual ($1)"
    $awk_cmd -f $awk_script $tex_file | less -P"<LEDA Manual ($1)>"
   else
    if [ "$textedit" = 1 ]
    then
     $awk_cmd -f $awk_script $tex_file | sed s/_//g > /tmp/lman$$
     textedit -read_only /tmp/lman$$
     rm -f /tmp/lman$$
    else
     $awk_cmd -f $awk_script $tex_file
    fi
   fi
  fi
else
   print "$0": LEDA data type \"$1\" not found
   exit 1
fi

exit 0

#----------------------------------------------------------------------------
#Siemens ZFE BT SE 14    Internet: lauther@ztivax.zfe.siemens.de
#                        from ems: lauther@ztivax:tcp-636-18:Mch P Siemens AG
#----------------------------------------------------------------------------

