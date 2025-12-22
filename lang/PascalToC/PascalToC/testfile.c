/* sort -- external sort of text lines, from Software Tools in Pascal, pg 121 */
void sort()
/* CONST */
	MAXCHARS == 10000;	/* maximum # of text characters */
	MAXLINES == 300;		/* maximum # of lines */
	MERGEORDER == 5;

	 typedef 1/***# Expected ; ***/ charpos;/***# Expected = ***/typedef charbuf/***# Expected ; ***/ MAXCHARS; /***# Expected type identifier ***/ /***# Expected = ***/typedef 1/***# Expected ; ***/ ;/***# Expected = ***/typedef /***# Expected type ***//***# Expected ; ***/ MAXCHARS; /***# Expected = ***/typedef posbuf/***# Expected ; ***/ character; /***# Expected type identifier ***/ /***# Expected = ***/typedef 1/***# Expected ; ***/ ;/***# Expected = ***/typedef /***# Expected type ***//***# Expected ; ***/ MAXLINES; /***# Expected = ***/typedef pos/***# Expected ; ***/ charpos; /***# Expected = ***/typedef MAXLINES 0;
	 typedef filedesc fdbuf[MERGEORDER+1];

	charbuf linebuf ;
	posbuf linepos ;
	pos nlines ;
	fdbuf infile;
	filedesc outfile ;
	int high, low, lim;
	boolean done ;
	char/***# Expected [ or ( after STRING ***//***# Expected string length ***//***# Expected ] or ) after STRING[ ***/
/***# EOF ***/
