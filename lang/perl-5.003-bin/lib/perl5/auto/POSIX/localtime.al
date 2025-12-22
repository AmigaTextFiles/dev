# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub localtime {
    usage "localtime(time)" if @_ != 1;
    localtime($_[0]);
}

1;
