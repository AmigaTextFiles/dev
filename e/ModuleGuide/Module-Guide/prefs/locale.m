@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "prefs/locale.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT localeprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   countryname[32]:ARRAY OF CHAR
@{fg shine}(  48)@{fg text}   preferredlanguages[300]:ARRAY OF CHAR
@{fg shine}( 348)@{fg text}   gmtoffset:LONG
@{fg shine}( 352)@{fg text}   flags:LONG
@{fg shine}( 356)@{fg text}   countrydata:countryprefs @{fg shine}(or ARRAY OF countryprefs)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=862 */

@{fg shine}(----)@{fg text} OBJECT countryprefs
@{fg shine}(   0)@{fg text}   reserved[4]:ARRAY OF LONG
@{fg shine}(  16)@{fg text}   countrycode:LONG
@{fg shine}(  20)@{fg text}   telephonecode:LONG
@{fg shine}(  24)@{fg text}   measuringsystem:CHAR
@{fg shine}(  25)@{fg text}   datetimeformat[80]:ARRAY OF CHAR
@{fg shine}( 105)@{fg text}   dateformat[40]:ARRAY OF CHAR
@{fg shine}( 145)@{fg text}   timeformat[40]:ARRAY OF CHAR
@{fg shine}( 185)@{fg text}   shortdatetimeformat[80]:ARRAY OF CHAR
@{fg shine}( 265)@{fg text}   shortdateformat[40]:ARRAY OF CHAR
@{fg shine}( 305)@{fg text}   shorttimeformat[40]:ARRAY OF CHAR
@{fg shine}( 345)@{fg text}   decimalpoint[10]:ARRAY OF CHAR
@{fg shine}( 355)@{fg text}   groupseparator[10]:ARRAY OF CHAR
@{fg shine}( 365)@{fg text}   fracgroupseparator[10]:ARRAY OF CHAR
@{fg shine}( 375)@{fg text}   grouping[10]:ARRAY OF CHAR
@{fg shine}( 385)@{fg text}   fracgrouping[10]:ARRAY OF CHAR
@{fg shine}( 395)@{fg text}   mondecimalpoint[10]:ARRAY OF CHAR
@{fg shine}( 405)@{fg text}   mongroupseparator[10]:ARRAY OF CHAR
@{fg shine}( 415)@{fg text}   monfracgroupseparator[10]:ARRAY OF CHAR
@{fg shine}( 425)@{fg text}   mongrouping[10]:ARRAY OF CHAR
@{fg shine}( 435)@{fg text}   monfracgrouping[10]:ARRAY OF CHAR
@{fg shine}( 445)@{fg text}   monfracdigits:CHAR
@{fg shine}( 446)@{fg text}   monintfracdigits:CHAR
@{fg shine}( 447)@{fg text}   moncs[10]:ARRAY OF CHAR
@{fg shine}( 457)@{fg text}   monsmallcs[10]:ARRAY OF CHAR
@{fg shine}( 467)@{fg text}   monintcs[10]:ARRAY OF CHAR
@{fg shine}( 477)@{fg text}   monpositivesign[10]:ARRAY OF CHAR
@{fg shine}( 487)@{fg text}   monpositivespacesep:CHAR
@{fg shine}( 488)@{fg text}   monpositivesignpos:CHAR
@{fg shine}( 489)@{fg text}   monpositivecspos:CHAR
@{fg shine}( 490)@{fg text}   monnegativesign[10]:ARRAY OF CHAR
@{fg shine}( 500)@{fg text}   monnegativespacesep:CHAR
@{fg shine}( 501)@{fg text}   monnegativesignpos:CHAR
@{fg shine}( 502)@{fg text}   monnegativecspos:CHAR
@{fg shine}( 503)@{fg text}   calendartype:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=504 */

CONST ID_LCLE=$4C434C45,
      ID_CTRY=$43545259
@endnode
