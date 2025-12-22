# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub sscanf {
    unimpl "sscanf() is C-specific--use regular expressions instead";
}

1;
