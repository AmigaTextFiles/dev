# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub qsort {
    unimpl "qsort() is C-specific, use sort instead";
}

1;
