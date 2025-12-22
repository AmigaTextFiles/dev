# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fputc {
    unimpl "fputc() is C-specific--use print instead";
}

1;
