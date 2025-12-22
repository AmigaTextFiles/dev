# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub exit {
    usage "exit(status)" if @_ != 1;
    exit($_[0]);
}

1;
