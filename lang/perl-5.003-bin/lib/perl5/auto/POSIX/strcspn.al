# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub strcspn {
    unimpl "strcspn() is C-specific, use regular expressions instead";
}

1;
