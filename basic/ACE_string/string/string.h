' External subprogram declaration for the library module string.o, 
' which provides extended string functions for ACE.
' (C) 2014  Lorence Lombardo.  6-May-2014

DECLARE SUB Replace$(src$, find$, rep$) EXTERNAL
DECLARE SUB StripLead$(a$, char%) EXTERNAL
DECLARE SUB StripTrail$(a$, char%) EXTERNAL
DECLARE SUB LSet$(a$, chars%) EXTERNAL
DECLARE SUB RSet$(a$, chars%) EXTERNAL
DECLARE SUB Center$(a$, chars%) EXTERNAL
DECLARE SUB Rrem$(a$, chars%) EXTERNAL
DECLARE SUB Lrem$(a$, chars%) EXTERNAL
DECLARE SUB nstr$(num&) EXTERNAL
DECLARE SUB flip$(a$) EXTERNAL
DECLARE SUB SHORTINT InstrNC(src$, find$, p%) EXTERNAL
DECLARE SUB srepNC$(src$, find$, rep$) EXTERNAL
