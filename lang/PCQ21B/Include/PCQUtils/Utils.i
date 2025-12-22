{
    Include:PCQUtils/Utils.i

    This are some miscutils to use with PCQ Pascal.

    Author:  Nils Sjoholm  (nils.sjoholm@mailbox.swipnet.se)

    This header may be changed later on.
}

{$I "Include:Exec/Types.i"}

{
    A simple wildcardmatch function. It can handle all amiga wildcards
    plus *.
    Usage : Match("MytestString","My*");
    This one will return true.
    Match is casesensitive so make the strings upcase if you don't
    need that.
}
FUNCTION Match(str1,str2:STRING): Boolean;
EXTERNAL;

{
    Returns true if the program was started from workbench.
}
FUNCTION FromWB(): Boolean;
EXTERNAL;

{
    Gives you the osversion of the system used.
}
FUNCTION OSVersion(): Integer;
EXTERNAL;

{
    Returns a datestring, this one use the international version
    month-day-year : 09-25-1997.
}
FUNCTION Date(): STRING;
EXTERNAL;

{
    Returns the time as a string. 15:35:49.
}
FUNCTION Time(): STRING;
EXTERNAL;

{
    A simple timer if you need one. Functions like the one in
    Amiga Basic.
    starttime := Timer;
    do your stuff ...
      ...
    endtime := (Timer - starttime);
}
FUNCTION Timer(): Real;
EXTERNAL;

{
    A simple timer for ticks. Use like Timer but you get
    ticks instaed of secs.
}
FUNCTION TimerTicks(): Integer;
EXTERNAL;

{
    An easy way to use a requester in PCQ.
}
FUNCTION EasyReqArgs(title,body,gad : STRING):INTEGER;
EXTERNAL;

{
    The same as EasyReqArgs but this one can handle
    variable number of args for bodytext and gadgets.
}
{$C+}
FUNCTION EasyReq(title,body,gad : STRING; ...):INTEGER;
EXTERNAL;

(*
    Use this one for easy use of taglists or use the
    internal varargs functions instead.
*)
FUNCTION TAGS(...) : Address;
EXTERNAL;
{$C-}













                   
                   
                                                      












