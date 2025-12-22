# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub abs {
    usage "abs(x)" if @_ != 1;
    abs($_[0]);
}

1;
