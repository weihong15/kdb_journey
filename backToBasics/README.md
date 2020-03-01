## Basics

Table of Contents
=================

- [Table of Contents](#table-of-contents)
    - [Multi-line comments](#multi-line-comments)
    - [Syntax rules and conventions](#syntax-rules-and-conventions)
      - [Parentheses](#parentheses)
      - [Semicolon](#semicolon)
      - [Leading WhiteSpace](#leading-whitespace)
      - [Confusing Min and Max](#confusing-min-and-max)
    ** [parentheses](#parentheses)
    ** [Semicolon](#semicolon)
    ** [importance leading whitespace](#leading-whitespace)
    ** [Confusing statements between Min,Max, "&" and "|"](#confusing-min-and-max)



### Multi-line comments
```
/
All these are comments in q
regardless of how many lines it is
ta-dah
\
```

### Syntax rules and conventions
#### Parentheses
Useful to create lists, order precedence
#### Semicolon
* Seperate Function Arguments
* Seperate list elements
* end of line function

#### Leading WhiteSpace
* Multi-line function, need to have at least a whitspace infront  
* No white-space = new statement/function

#### Confusing Min and Max
Confusing terms: "&" and "|"  
bitwise MIN and MAX  
Note that they both have two arguements
```
q)0101b & 1111b
0101b
q)0101b | 1111b 
1111b
q)type 10:00 
-17h
q)(1;"abC";10:00)|(3;"ABc";05:00)
3
"abc"
10:00
q)(1;"abC";10:00)&(3;"ABc";05:00) 
1
"ABC"
05:00
q)"A" | "a"                         //Do note that "a" > "A"
"a"
```
while min and max operators only have 1 arguement
```
q)min til 5
0
q)min("ABC";"abc")
"ABC"
```

