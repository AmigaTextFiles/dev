# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub memcmp {
    unimpl "memcmp() is C-specific, use eq instead";
}

1;
