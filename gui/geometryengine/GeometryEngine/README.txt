"Design beautiful Gadgets, Menus, Requesters.  Think simplicity and
elegance.  Always remember the fourth grader, the sophisticated user, and
the poor soul who is terrified of breaking the machine"

"Dare to be gorgeous and unique.  But don't ever be cryptic or otherwise
unfathomable.  Make it unforgetably great"

 -- -=RJ=-, from the Intuition Style Guide.

**************************************************************************

Warning:  This is only a demonstration of the Geometry Engine.  I accept no
liability for anything that might happen.  Additionaly, nothing is set in
stone, anything might (and probably will) change.  I make no claims as to
the completeness, usability or beauty of this package.  The only purpose
here is to let people see what this is, and get some hopefully constructive
criticism and ideas as a result.

All suggestions, encouragement, or death threats are welcome.  I will
entertain all opinions.

So lets get on with it.

What is the Geometry Engine?  It's a simple mechanism for creating
environment sensitive (fonts, colours, etc), resizable GUI's.  That's it.
It tries to be as flexible as possible, and allows user definable hooks for
rendering, layout, etc.

The documentation is sparse, with no tutorial, just the autodocs.  But this
is only a demo, not a development system.  You can go and use it with your
own programs, but I don't recomend it right now, since I may change things
if necessary.

Yes, it's crude, yes it's probably not as efficient as it could be, yes
GadTools is annoying and not particularly efficient itself, yes it's no
where near the level of many available GUI systems, yadda yadda.  Thffbbt!

In the future, I intend to release a more complete package, when I've decided
to commit to the API.  I'd like to get BOOPSI support going, but I'd also like
to create or adopt some other more efficient Object system (including possibly
a more advanced BOOPSI-like system) to use.  OO is good.

I will implement "panels"; switchable pages of gadgets, which could be used
like the click-tab things in many other GUI systems, or like the "pages" in
the PrinterPS preferences.  I dislike almost every click-tab implementation
I've seen, and mine would be completely flexible (I like the idea of click
tabs.  I'd like the tabs to be simple, visualy; intuitive, and fast.

I'll also probably do a Geometry Engine preferences thing, to set all kinds of
"gee-whiz" stuff like backrounds and button images etc.

And it will become a shared library as well as a linkable library, your
choice (and maybe the link library routines will be smart enough to
redirect to the library if it's there and newer).  I will support any
language anyone wants to use, and the library will be usable from ARexx
too.

Finaly, I'd like to make a graphical GUI builder that uses Geometry Engine.
I have not seen any GUI builder that even comes close to what I want to do.
The GUI builder is the eventual goal, as I think that, logicaly, a GUI
ought to be constructed with a GUI.

My vision is this:

A GUI is created visualy, almost like a DTP or structured drawing program.
Any language is supported, because the GUI definition can be loaded and
used with simple library calls.  You could prototype your program using
ARexx, which means no compiling; basicly, Visual ARexx.  You could then
redo it in C or whatever.  Even mixing languages.  "Visual Anything".  In
fact, to get real wild, this GUI editing envirionment should be a built in
feature.  Let the user not only tweek things like colours and image styles
etc, but even move gadgets around, etc.

It would be object oriented, using some kind of language independant object
mechanism (*maybe* BOOPSI, but I'm not real fond of it.  For reference, I
like the ideology of Objective C.  See "Object Oriented Programing, an
evolutionary approach" by Brad J.  Cox).  This system should be fast, and
flexible, and would allow objects to be shared across applications.

The object system would be very layered, and well thought out.  You only
load what you need, and that includes possibly not loading a parent class
if its functionality isn't asked for.  On the flip side, new functionality
could be inserted dynamicaly without the objects or applications needing to
specificaly know about it.

Above all, simple things should be simple and small and fast.

Aric Caley
greywire@quick.net
