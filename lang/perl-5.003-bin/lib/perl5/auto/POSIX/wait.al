# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub wait {
    usage "wait()" if @_ != 0;
    wait();
}

1;
