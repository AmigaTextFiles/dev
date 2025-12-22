# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getuid {
    usage "getuid()" if @_ != 0;
    $<;
}

1;
