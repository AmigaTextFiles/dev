# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getppid {
    usage "getppid()" if @_ != 0;
    getppid;
}

1;
