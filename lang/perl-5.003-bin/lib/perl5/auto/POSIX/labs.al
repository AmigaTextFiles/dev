# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub labs {
    unimpl "labs() is C-specific, use abs instead";
}

1;
