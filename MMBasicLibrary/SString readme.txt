Small Strings
An MMBasic program by TassyJim - Oct 2012

Save space by using short strings. MMBasic strings are a fixed 255 bytes long.
If you have a lot of short strings, you can save a lot of valuable memory by using short strings.
The code creates an array of any ( < 255 ) length strings.
It would be a bit slow for intensive string manipulation but it can save heaps of space.

Strings use 256 bytes. The first byte is the length of the string and the remaining 255 bytes are where the actual string is stored. I used the same method so if you need strings 32 bytes long, you will have to specify 33 as the size. In MMBasic you can specify the starting array number as zero or one. I have stayed with one because that is the way I have always done it.
I use the 'zero' location to store the new array size to save on 2 variables.

An example that might be relevant to you.

I have a list of 652 Aussie towns.
The longest name in the list is "Kingston South East" which is 19 characters long.
An array of 652 X 20 bytes is needed. 652*20/256 = 51
My method creates an array with 51 elements which uses about 13k
Full length strings would need 163k of memory
I also have a list of 65k place names but that's too much for the Maximite to chew on!

I deliberately kept to single dimension arrays but it is easy to use the short array as 2 dimensions. Most times a single dim array for the string and another standard numeric array for the rest of the data. In the Towns example this numeric array will store the latitude and longitude of the towns.

It is thanks to Geoff implementing PEEK and POKE and giving us the location of the variable table that I was able to do this. 

The code makes use of PEEK and POKE so it does have the potential to cause havoc.

function makeSmall( aa,bb)
First we work out the number of normal string elements needed to store out small array.
We then create the holding array and find its memory address.
The first 2 memory locations are used to store the new array dimensions.

function PutSmall(b, a$)
We pass the array element and the string for storing.
If the string is too long, it is truncated without any error message.
The function returns -1 if an error occurs or the length of the string.

function GetSmall$(b, a$)
Pass the array element and an optional error string
Return the string or the error string if array is out of bounds 

The code has been tested on various hardware but not as part of a big program.
Jim
