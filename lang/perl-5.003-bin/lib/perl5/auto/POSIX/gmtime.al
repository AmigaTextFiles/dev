# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub gmtime {
    usage "gmtime(time)" if @_ != 1;
    gmtime($_[0]);
}

1;
