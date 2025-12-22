# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub realloc {
    unimpl "realloc() is C-specific, stopped";
}

1;
