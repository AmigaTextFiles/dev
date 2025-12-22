# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub execv {
    unimpl "execv() is C-specific, stopped";
}

1;
