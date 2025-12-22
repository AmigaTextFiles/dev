# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strcat {
    unimpl "strcat() is C-specific, use .= instead";
}

1;
