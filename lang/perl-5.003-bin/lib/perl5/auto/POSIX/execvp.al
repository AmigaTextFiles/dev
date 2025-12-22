# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub execvp {
    unimpl "execvp() is C-specific, stopped";
}

1;
