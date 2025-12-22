# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub closedir {
    usage "closedir(dirhandle)" if @_ != 1;
    closedir($_[0]);
}

1;
