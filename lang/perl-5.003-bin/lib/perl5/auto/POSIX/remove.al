# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub remove {
    usage "remove(filename)" if @_ != 1;
    unlink($_[0]);
}

1;
