# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub longjmp {
    unimpl "longjmp() is C-specific: use die instead";
}

1;
