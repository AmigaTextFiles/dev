# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strlen {
    unimpl "strlen() is C-specific, use length instead";
}

1;
