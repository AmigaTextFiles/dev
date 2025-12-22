# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub execlp {
    unimpl "execlp() is C-specific, stopped";
}

1;
