   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

NB. Keith W. Smillie's J Version of E.E.McDonnell's Calendar algorithm
NB. As revised by E.E. McDonnell.  Copyright Iverson Software Inc.
NB. Some additional notes by Donald B. McIntyre

NB. Keith Smillie has since published the following article:
NB. "Making a Calendar in J", VECTOR Vol. 9#1 (July 1992) 85-91
NB. (I have not compared the VECTOR version with this one.  DBM)

NB. Utilities
pi=. >:@i.
div=. <.@%& 4 100 400
mod=. 4 100 400 & |
dayno=. 7&|

NB. Constants
DAYS=. ' Su Mo Tu We Th Fr Sa'
MONTHS=. 'JanFebMarAprMayJunJulAugSepOctNovDec'
LENGTHS=. 31 28 31 30 31 30 31 31 30 31 30 31

NB. Month name centered.
mn=. _12&{.@]@{&(_3]\MONTHS)

NB. Leap year test
ly=. 0&(~:/ .=)@mod

NB. Month lengths adjusted for leap year
LENGTHSadj=. LENGTHS&+@((LENGTHS=28)&(*. ly))

NB. Month length
ml=. {LENGTHSadj

NB. New Year's date
nydate=. >:@(365&*+-/@div)@(]@-&1601)

NB. Ordinal date
odate=. +/@({.LENGTHSadj)

NB. First day of month
mb=. -@dayno@(odate+nydate@])

NB. Month calendar without headings
mctable=. ,"_1@(6 7&$)@(mb |. (42&{.)@(3&":)@,.@pi@ml)

NB. Month calendar
mc=. (mn@[),(DAYS&,@mctable)

NB. Calendar for given number of months
cal=. (i.@[)mc"0]

NB. Calendar with 4 rows and 3 columns
calendar=. <"2@(4 3&cal)

NB.  calendar 1992
NB.  calendar"0 ]1991 1992 1993
NB. These took 3.96 and 11.76 seconds respectively on PS/2#70

NB. Keith W. Smillie's version is so slow you may think you
NB. are in an endless loop!
NB. calendar 1992                  Took  52.6 seconds on PS/2#70
NB. calendar"0 ]1991 1992 1993     Took 157.6 seconds on PS/2#70

NB.  The following illustrate how we can isolate individual verbs
NB.  for testing and study
NB.      1 2 cal 1992
NB.      1 2 mc"0 ]1992
NB.      1 2 mctable"0 ]1992
NB.      mn 1 2
NB.      1 2 mb"0 ]1992
NB.      1 2 odate"0 ]1992
NB.      2 odate 1992
NB.      2 ({.LENGTHSadj) 1992
NB.      2 {. (LENGTHSadj 1992)
NB.      2 ml 1992
NB.      2 ({LENGTHSadj) 1992
NB.      2 { (LENGTHSadj 1992)
