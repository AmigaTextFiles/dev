# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub memcpy {
    unimpl "memcpy() is C-specific, use = instead";
}

1;
