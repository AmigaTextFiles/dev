# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strcpy {
    unimpl "strcpy() is C-specific, use = instead";
}

1;
