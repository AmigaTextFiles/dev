# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getc {
    usage "getc(handle)" if @_ != 1;
    getc($_[0]);
}

1;
