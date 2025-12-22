# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub sleep {
    usage "sleep(seconds)" if @_ != 1;
    sleep($_[0]);
}

1;
