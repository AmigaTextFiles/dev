# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub sprintf {
    usage "sprintf(pattern,args)" if @_ == 0;
    sprintf(shift,@_);
}

1;
