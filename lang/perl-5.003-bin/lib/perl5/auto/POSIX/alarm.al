# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub alarm {
    usage "alarm(seconds)" if @_ != 1;
    alarm($_[0]);
}

1;
