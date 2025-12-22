Multi-platform TOK64
====================

This is modification of the original [tok64 source code][tok64] to
"genericise" it enough to compile on Linux, and hopefully other
platforms. (The original had things like backslashes in paths given to
`#include`.) A `Makefile` is now provided, and it's tested on Debian 9.

`GETLINE.C` has also been modified to drop `\r\n` at the end of an
input line, as well as just `\n`. This allows you to use the converter
on POSIX systems to convert `.txt` files using DOS newline format.
(Previously the `\n` would be include in the `.prg` output and
generate a syntax error in BASIC, at least on the C64.)

The original (ASCII) [README] file has been left untouched; a shorter
usage summary with additional information about using this on non-DOS
platforms is below.

The changes are designed to be minimal, so I have left the source
filenames in upper case (though I generate a lower-case output file),
left them with DOS CR-NL end-of-line convention, etc. The commit
history of this repository gives the details of what changes were
made.


Usage Summary
-------------

Only a single input filename may be specified; the output filename
will be the input filename with everything after the _first_ `.`
removed and replaced with `.prg` or `.txt`. The input filename may
have any extension, but if the filename does not contain a `.`, `.prg`
or .`txt` will be appended. Options start with slashes; e.g. `/list`
will list all command line options.

If an existing file would be overwritten, a confirmation will be
required unless the `/stomp` option is given. The usual commands are:

    tok64 /stomp /toprg foo.prg
    tok64 /stomp /totxt foo.txt

Keywords may be upper or lower case on input; on output they will be
upper case unless `/lower` is given. Strings and comments preserve
their case with PETSCII conversion, i.e., lower/upper case letters
will be upper-case/graphics in [unshifted] mode and lower/upper-case
in shifted mode.

Informational options include the ones below. The ones marked `(M)`
print out multiple 24-line screens of information, requiring a RETURN
between each screen.

    /help       (M) Extensive help information
    /list           List command line options
    /keywords   (M) List BASIC keywords
    /ext        (M) List extension keywords for Final Cart 3, Graphics52

Additional options support line continuations, multiple programs per
`.txt` listing and adding Final Cartridge 3 and Graphics52 extensions.



<!-------------------------------------------------------------------->
[README]: README
[tok64]: https://github.com/thezerobit/tok64
[unshifted]: https://en.wikipedia.org/wiki/PETSCII
