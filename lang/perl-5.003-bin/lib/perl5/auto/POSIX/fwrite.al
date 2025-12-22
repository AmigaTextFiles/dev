# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fwrite {
    unimpl "fwrite() is C-specific--use print instead";
}

1;
