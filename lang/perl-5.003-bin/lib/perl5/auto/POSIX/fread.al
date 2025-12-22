# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fread {
    unimpl "fread() is C-specific--use read instead";
}

1;
