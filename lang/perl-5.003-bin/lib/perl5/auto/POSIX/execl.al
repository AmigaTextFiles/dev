# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub execl {
    unimpl "execl() is C-specific, stopped";
}

1;
