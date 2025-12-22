Dear Michael:

I think your utility CodeWatcher is one of those developer utilities that
was missing. Thanks for leting it available in the public domain, as I use
it very often to ensure consitency in my programs, concerning resource usage.

Since you mention that you're open to improvement suggestions, I'm going to
make mine:

- WB support would be very useful. If need any clues concerning WB support,
I guess you may take a look at another utility that launches applications
simulating WB launching procedure. It is available also in the public
domain and comes with source. It also comes with ToolManager, but if you
have dificulties to find it, I won't mind sending it to you by e-mail.

- Sometimes CodeWatcher notices some not freed memory that seems to be a
result of unusual memory usage by layers.library. It would be fine if
CodeWatcher could detect/filter/warn these cases. Take a look at mungwall
documentation to read about this odd usage of layers.library.

- It would be nice if you allow the user to save the resources report to
another file besides stdout. Using file requester to select the testing
program name and the report file name would also be fine.


No further suggestions or bugs.

Keep up the good work,
Manuel Lemos
