# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub rmdir {
    usage "rmdir(directoryname)" if @_ != 1;
    rmdir($_[0]);
}

1;
