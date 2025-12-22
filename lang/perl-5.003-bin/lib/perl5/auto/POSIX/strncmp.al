# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strncmp {
    unimpl "strncmp() is C-specific, use eq instead";
}

1;
