# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getgrnam {
    usage "getgrnam(name)" if @_ != 1;
    getgrnam($_[0]);
}

1;
