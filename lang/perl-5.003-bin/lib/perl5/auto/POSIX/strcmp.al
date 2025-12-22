# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strcmp {
    unimpl "strcmp() is C-specific, use eq instead";
}

1;
