# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub rewind {
    usage "rewind(filehandle)" if @_ != 1;
    seek($_[0],0,0);
}

1;
