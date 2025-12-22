
CLI UTILITY ROUTINES
~~~~~~~~~~~~~~~~~~~~

"earth.library" provides two functions which concern themselves
with processing multiple files and arguments. These are very useful
when writing CLI utilities. The functions are ForEachArgument() and
ForEachWildCard().

PROCESSING MULTIPLE ARGUMENTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you process standard command line arguments (either using the ARP
function GADS() or the release 2 "dos.library" function ReadArgs())
and you have a "multiple argument" template item ("/..." under ARP,
or "/M" under DOS) then the arp/dos library will initialise for you
an array of pointers to strings, terminated by a NULL longword.

This is where ForEachArgument() comes in. If you call:

	failcode = ForEachArgument( array, userfunction, userdata );

then the array of pointers to strings will be scanned. For each
string in the array the specified userfunction will be called. If
these strings represent filenames then your userfunction can
subsequently call ForEachWildCard() to allow multiple wildcard patterns.

PROCESSING WILDCARDS
~~~~~~~~~~~~~~~~~~~~

The syntax of this is similar to that of ForEachArgument(), namely:

	failcode = ForEachWildCard( pattern, userfunction, userdata );

This will call the specified userfunction once for each file which
matches the specified wildcard pattern. This makes it extremely easy
to write CLI utilities which process wildcards. If you use this
routine in conjuction with ForEachArgument() then you can easily
write utilities to process multiple wildcards.
