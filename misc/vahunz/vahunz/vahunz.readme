TITLE

  vahunz - Make source code un-/more legible.

VERSION 

  1.7

AUTHOR

  Thomas Aglassinger <agi@giga.or.at>

DESCRIPTION

  Vahunz is a CLI-based replace command that can replace many words
  across several files with only one invocation.

  Normally the target words will be created randomly, turning
  meaningful names into unlegible garbage. For example, a function
  name like read_input_file() could be replaced by g7B() or something
  as useless. Additionally, comments and indention can be removed.

  As an option, you can specify specific substitutes, so Vahunz can
  also be applied in a non-destructive manner. This can be used to
  replace inconsistent, too short or unlegible names by something more
  meaningful. Among programmers, this process is known as "The Great
  Renaming".

  An Amiga Installer script acting as frontend to the CLI command is
  included, so most tasks can be performed without having to deal with
  cryptic command line options.

FEATURES

  - Stores less/more legible copy in a different directory
  - Supports C, C++ and Java
  - Auto-detects programming language
  - New names since last run are easy to see
  - Names can easily be declared to be modified or left untouched;
    for example, it makes no sense to replace printf().
  - Words being part of comments or string constants are not replaced
  - Fast, as internally names are stored in an AVL-tree
  - Several options to back-trace problems in vahunzed code
  - Includes a set of standard dictionaries for various environments
  - Includes source code (vahunzed ANSI C)

NEW FEATURES

  - Fixed some bugs

SPECIAL REQUIREMENTS

  AmigaOS 2.04, 2MB of regular memory, 68020

AVAILABILITY

  - Every Aminet-mirror, file "dev/misc/vahunz.lha", for example:

    ftp://wuarchive.wustl.edu/pub/aminet/dev/misc/vahunz.lha

  - http://www.giga.or.at/~agi/vahunz/

PRICE

  Freeware.

DISTRIBUTABILITY

  Freely distributable as long the conditions described in the manual
  are met.

EXAMPLE

  For example, one might have a code excerpt like this:

    int main(void)
    {
        while (sepp_age < 83)
        {
            grow_older(sepp_name, &sepp_age);
            print_sepp();
        }
        printf("\n%s died.\n", sepp_name);
        exit(EXIT_SUCCESS);
    }

  After vahunzing, this is what it might look like:

    int main(void)
    {
    while (g8B < 83)
    {
    z3V(v6Z, &g8B);
    f4V();
    }
    printf("\n%s died.\n", v6Z);
    exit(EXIT_SUCCESS);
    }

  As you can see, the internal names have been garbled, but the
  symbols of the standard library are preserved.

