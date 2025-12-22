# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub toupper {
    usage "toupper(string)" if @_ != 1;
    uc($_[0]);
}

1;
