#! @CFLOW_SHELL@

# cflow - print a function call hierarchy
# This script is contributed to the public domain by Andrew Moore
# of Talke Studio.

# exit on errors..

# this values can be overriden by devining them in the
# enviornment
F2C=${F2C:=f2c}
LEX=${LEX:=flex}
YACC={YACC:="bison -y"}
CC=${CC:=gcc}
CPP=${CPP:="$CC -E"}
PRCC=${PRCC:=@PRCC@}
PRCG=${PRCG:=@PRCG@}
TMPFILE=/tmp/cflow.$$


function prcc {
	if [ $verbose ]; then
		echo $PRCC $* >/dev/tty
	fi
		
	command $PRCC $*
}

function prcg {

	if [ $verbose ]; then
		echo $PRCG $* >/dev/tty
	fi
	command $PRCG $*
}

function echo {
	builtin echo -e "$*" 
}


# test for dos...
if [ X$OSMODE != X ]; then
	swap extend
	echo=echo
else
	echo="builtin echo -e"
	 trap 'remove_tmp_file ; remove_exclude_files; exit '  1 2 15
fi

progname=$0

function usage
{
	echo $progname [-AaginPXVvxh] [-d n] [-w n] [-r name] [cpp-opts] files
	echo "\t-a\tprint a seperate cal graph for each function"
	echo "\t-A\teliminate ansi keywords"
	echo "\t-P\teliminate posix keywords"
	echo "\t-d n\tprint call graph to depth n"
	echo "\t-g\teliminate gcc keywords"
	echo "\t-r name\\tstart tree at name"
	echo "\t-D and -I options "
	echo "\t-x\tprint each subgraph in full"
	echo "\t-i\tinverted index"
	echo "\t-s\tsave temporary files"
	echo "\t-n\tdon't run prcg (useful for debugging)"
	echo 
	echo "\t-v\tinclude variables"
	echo "\t-X\texclude files "
	echo "\t-V\tverbose"
	echo "\nAccepts the following from the environment"
	echo "\tCPP (default $CPP)"
	echo "\tCC  (default $CC)"
	echo "\tPRCG (default $PRCG)"	
	echo "\tPRCC (default $PRCC)"
	exit 1
}



invert=""
verbose=""
exclude_files=""
exclude_directory=/tmp/cflow.excludes
if [ -z "$OSMODE" ]; then
	exclude_directory="$exclude_directory".$$
fi

function do_mkdir 
{
	for i in $*
	do
		mkdir -p $i
		if [ $? -ne 0 ]; then
			echo "can't make $i; exiting"
			exit 1
		fi
	done
}

function remove_exclude_files
{
	if [ -d $exclude_directory ]; then
		rm -rf $exclude_directory
	fi
} 


function remove_tmp_file
{
	if [ "$save_temps" ] ; then
		echo temp file in  $TMPFILE
	else
		rm $TMPFILE
	fi
}

# call this once when we get are include files
# called only if we want to exclude files
function exclude 
{
	if [ "$exclude_files" ]; then
		do_mkdir $exclude_directory
	fi

	for i in $exclude_files
	do
		case $i in 
			*/* )
				echo "can't make subdirectory $i yet"
				continue
				;;
		esac
		>$exclude_directory/$i

	done		
}

#builtin -d echo 	# use gnu echo

#  echo command line is $* >& 2
while getopts aghsAPD:I:X:nU:d:ir:Vvw:x c; do
#	echo option is $c
#	echo OPTARG = $OPTARG
	case $c in
	D)
		CPP="$CPP -D$OPTARG"
		;;
	I)
		CPP="$CPP -I$OPTARG"
		;;
	U)
		CPP="$CPP -U$OPTARG"
		;;
	a)
		PRCG="$PRCG -a"
		;;
	n)
		no_prcg="true"
		;;
	V)
		verbose=1
		;;
	d)
		PRCG="$PRCG -d$OPTARG"
		;;
	g)	
		PRCC="$PRCC -g"
		;;
	P)
		PRCC="$PRCC -p"
		;;
	A)
		PRCC="$PRCC -a"
		;;
	i)
		PRCG="$PRCG -i"
		invert=1
		;;
	r)
		PRCG="$PRCG -r$OPTARG"
		;;
	v)
		PRCC="$PRCC -v"
		;;
	w)
		PRCG="$PRCG -w$OPTARG"
		;;
	x)
		PRCG="$PRCG -x"
		;;
	s)
		save_temps=1
		;;
	X)	
		exclude_files="$exclude_files $OPTARG"
		;;
	\? | h)
		usage >&2
		exit 2
		;;
	esac
done

if [ "$exclude_files" ]; then
	exclude
	CPP="$CPP -I$exclude_directory" 

fi




let count=$OPTIND-1
shift $count
unset count

if [ $# -eq 0 ]; then
	usage
fi

for c in $*
do
	case $c in
	*.c|*.cc|*.C)
		cname=$c
		;;
	*.f)
		cname=`basename $c .f`.c
		cat $c | $F2C >$cname
		;;
	*.F)
		cname=`basename $c .F`.C
		cat $c | $F2C >$cname
		;;
	*.l)
		cname=`basename $c .l`.c
		$LEX $c
		sed '/# line/d' lex.yy.c >$cname
		;;
	*.y)
		cname=`basename $c .y`.c
		$YACC $c
		sed '/# line/d' y.tab.c >$cname
		;;
	*.s)
		echo "cflow: assembler source not supported" >&2
		shift
		[ $# -le 0 ] && break
		c=$1
		continue
		;;
	*.h)
		shift
		[ $# -le 0 ] && break
		c=$1
		continue
		;;
	*)	
		usage >&2
		exit 2
		;;
	esac
	if [ $verbose ]; then
		echo $CPP $cname >& 2
	fi

	$CPP $cname  >>$TMPFILE
done

if [ "$no_prcg" ]; then
	PRCG=cat
fi


if [ X$invert = X ]; then
 prcc < $TMPFILE | prcg 
else
	prcc < $TMPFILE |
	sed 's/\(.*	\)\(.*	\)/\2\1/' |
	sort +0 -1 +2 |
	uniq |
	prcg	
fi

remove_tmp_file
remove_exclude_files
