# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub execve {
    unimpl "execve() is C-specific, stopped";
}

1;
