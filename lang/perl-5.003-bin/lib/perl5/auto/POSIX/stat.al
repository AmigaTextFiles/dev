# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub stat {
    usage "stat(filename)" if @_ != 1;
    stat($_[0]);
}

1;
