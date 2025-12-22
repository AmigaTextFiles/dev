# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub ldiv {
    unimpl "ldiv() is C-specific, use / and int instead";
}

1;
