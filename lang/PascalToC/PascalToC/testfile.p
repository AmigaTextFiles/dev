{ sort -- external sort of text lines, from Software Tools in Pascal, pg 121 }
procedure sort;
const
	MAXCHARS = 10000;	{ maximum # of text characters }
	MAXLINES = 300;		{ maximum # of lines }
	MERGEORDER = 5;
type
	charpos = 1..MAXCHARS;
	charbuf = array [1..MAXCHARS] of character;
	posbuf = array [1..MAXLINES] of charpos;
	pos = 0..MAXLINES;
	fdbuf = array [1..MERGEORDER] of filedesc;
var
	linebuf : charbuf;
	linepos : posbuf;
	nlines : pos;
	infile: fdbuf;
	outfile : filedesc;
	high, low, lim: integer;
	done : boolean;
	name : string;
begin
end
