# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub utime {
    usage "utime(filename, atime, mtime)" if @_ != 3;
    utime($_[1], $_[2], $_[0]);
}

1;
