# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strncat {
    unimpl "strncat() is C-specific, use .= instead";
}

1;
