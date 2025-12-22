# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub malloc {
    unimpl "malloc() is C-specific, stopped";
}

1;
