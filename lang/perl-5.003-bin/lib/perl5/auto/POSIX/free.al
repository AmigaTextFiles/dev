# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub free {
    unimpl "free() is C-specific, stopped";
}

1;
