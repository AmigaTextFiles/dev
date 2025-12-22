# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getpwnam {
    usage "getpwnam(name)" if @_ != 1;
    getpwnam($_[0]);
}

1;
