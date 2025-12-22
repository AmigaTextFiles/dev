# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub chdir {
    usage "chdir(directory)" if @_ != 1;
    chdir($_[0]);
}

1;
