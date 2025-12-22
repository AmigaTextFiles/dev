# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub freopen {
    unimpl "freopen() is C-specific--use open instead";
}

1;
