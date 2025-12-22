nd of gloss over this.  We needed an Integer object
of some kind, though, for the String object.

1.2. String
-----------

This object is still being developed, but it should handle
anything that needs to be handled with strings.

String has two attributes, 'item' and 'len'.  'len' refers
to the length of the string in 'item'.  We thought it might
be faster to do things this way, rather than always
performing a StrLen()... however, we may change our minds
later (for the sake of memory).

	size()

Returns 12, which is the length of an instance of String.
Do not get this confused with 'length()', which returns the
length of the string.

	name()

This returns a pointer to some text that says 'String'.

	init()

This will initialize the integer 'len' to zero.

	select()

This enables new() for String.  Basically, if you want to
initialize a string during a NEW, just do the following:

NEW string.new(["set",'string'])

	end()

This deallocates both the string in item (via 'END') and the
integer in len (same way).

	cmp()

The comparison is handled by comparing the two strings byte
by byte until a byte is different from the other, or the end
of a string is reached.

This method enables all the other Sort methods associated
with cmp().

	set()

This allows you to set the string to a particular value.  If
we could use operators, this command would be ':='.  The
incoming parameter should be a pointer to a string.

	length()

This returns the length of the string.

	write()
	get()

Both of these return a pointer to the string itself.


1.3. Ad