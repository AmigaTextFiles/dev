# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getgrgid {
    usage "getgrgid(gid)" if @_ != 1;
    getgrgid($_[0]);
}

1;
