# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub gets {
    usage "gets()" if @_ != 0;
    scalar <STDIN>;
}

1;
