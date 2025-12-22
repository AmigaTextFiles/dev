# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub time {
    usage "time()" if @_ != 0;
    time;
}

1;
