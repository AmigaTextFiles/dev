# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fprintf {
    unimpl "fprintf() is C-specific--use printf instead";
}

1;
