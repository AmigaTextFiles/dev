# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strrchr {
    unimpl "strrchr() is C-specific, use rindex() instead";
}

1;
