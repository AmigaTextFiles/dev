# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub puts {
    unimpl "puts() is C-specific--use print instead";
}

1;
