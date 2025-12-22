# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fork {
    usage "fork()" if @_ != 0;
    fork;
}

1;
