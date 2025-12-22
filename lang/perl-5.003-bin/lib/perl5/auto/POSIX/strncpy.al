# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strncpy {
    unimpl "strncpy() is C-specific, use = instead";
}

1;
