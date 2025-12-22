# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub cos {
    usage "cos(x)" if @_ != 1;
    cos($_[0]);
}

1;
