#
# $Id: macros-prep.pl 1.3 2003/03/29 13:56:05 wepl Exp wepl $
#

print	"
	org	0
	output	RS:RS.macros
";

while (<>) {
	if (/^\tend\n/) {
		print "	include	macros.s\n"
	}
	print;
}

