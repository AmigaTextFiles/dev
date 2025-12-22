-----------------------------------------------
Keyfilemaker v1.0 [990619]
By Nikolaos Theologou (wizbone@hem.passagen.se)
-----------------------------------------------

With Keyfilemaker you can make your own keyfiles to use in your own AMOS programs.
The kit consists of three programs:

(1) Keyfilemaker.AMOS

 Generates a keyfile. Inputs are 'Name' and 'ID'.
 If someone cracks the keyfile and change the name in it, you are able to see
 the ID of the file. In that way you can determine from where the keyfile came.
 
 Checksums are used in the key. One for the Name and one for the ID.

(2) Keycheck.AMOS

 Use this procedure in your own program to check the keyfile

(3) Keyread.AMOS

 Reads the keyfile and displays the data in it (Name, ID, Checksums)


WARNING!

All the keyfiles are generated with the same algorithm, so you have to
modify the code to get your own unique keyfile.
But if no one knows that your program uses this alogithm, you got nothing to
fear (exept if they test your keyfile with this program).

Notice that the 'keyreaders' have to be modified with the same algorithm to
work properbly.


If you use this code in your program, let me know. (would be nice to know is someone is using it =)
