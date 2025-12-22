# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub printf {
    usage "printf(pattern, args...)" if @_ < 1;
    printf STDOUT @_;
}

1;
