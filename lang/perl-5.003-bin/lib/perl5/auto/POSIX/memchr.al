# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub memchr {
    unimpl "memchr() is C-specific, use index() instead";
}

1;
