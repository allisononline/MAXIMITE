'small strings by TassyJim
x=makeSmall( 39,40) ' 38+1 bytes long, 40 elements
print x;" string elements used"
memory
for n = 1 to 41
test$="Test string number "+str$(n)
x=PutSmall(n,test$)
print test$;" ";x
next n
print
print "Now we retrieve the strings"
for n = 1 to 41
test$=GetSmall$(n,"woops!")
print n;"  ";test$
next n
memory
end

function makeSmall( aa,bb) 'aa= string length, bb= array elements
local ascii$,g,n,c
makeSmall=-1
dim smallstring$(int(aa*bb/256)+1) ' allocate the required memory as a normal array
for g=0 to 32 'look through a maximum of 32 variables
ascii$=""
for n = 0 to 32
c=peek(VARTBL,n+g*56)
if c=0 then exit for
ascii$=ascii$+chr$(c) ' retrieve variable name (end is chr$(0))
next n
SSl=peek(VARTBL,52+g*56)+peek(VARTBL,53+g*56)*256 ' string storage low word
SSh=peek(VARTBL,54+g*56)+peek(VARTBL,55+g*56)*256 ' string storage high word
if ascii$="SMALLSTRING$(" then 
poke SSh, SSl, aa 'store the max string length
poke SSh, SSl+1, bb ' store the max number of elements
makeSmall=int(aa*bb/256)+1
exit for
endif
next g 
end function 'returns -1 for error or number of normal string array elements used

function PutSmall(b, a$) ' element number, string to store 
local n,aa,bb
aa=peek(SSh, SSl) ' retrieve the max string length
bb=peek(SSh, SSl+1) ' retrieve the max number of elements
n=-1
b=int(b)
if b>0 and b<=bb then
    if len(a$)>=aa then
        a$=left$(a$,aa-1) ' trim the string to max length
    endif
    poke SSh, SSl+b*aa, len(a$) ' store the string length
    for n = 1 to len(a$)
        c=asc(mid$(a$,n,1))
        poke SSh, SSl+b*aa+n, c ' store the string
    next n
endif
PutSmall=n ' returns length of string or -1 if subscript out of range
end function

function GetSmall$(b, a$) ' element number, error message if out of bounds
local n,aa,bb,s
aa=peek(SSh, SSl) ' retrieve the max string length
bb=peek(SSh, SSl+1) ' retrieve the max number of elements
b=int(b)
if b>0 and b<=bb then
a$=""
s = peek(SSh,SSl+aa*b) ' size of element
for n = 1 to s
k=peek(SSh,SSl+aa*b+n) ' build the string
a$=a$+chr$(k)
next n
endif
GetSmall$=a$ 'returns string or error message
end function