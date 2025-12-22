# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub rewinddir {
    usage "rewinddir(dirhandle)" if @_ != 1;
    rewinddir($_[0]);
}

1;
