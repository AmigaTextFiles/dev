# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub memset {
    unimpl "memset() is C-specific, use x instead";
}

1;
