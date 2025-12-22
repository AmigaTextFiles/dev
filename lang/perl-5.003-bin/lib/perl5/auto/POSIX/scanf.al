# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub scanf {
    unimpl "scanf() is C-specific--use <> and regular expressions instead";
}

1;
