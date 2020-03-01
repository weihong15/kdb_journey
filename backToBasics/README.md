## Basics

Table of Contents
=================

  - [Multi-line comments](#multi-line-comments)
  - [Syntax rules and conventions](#syntax-rules-and-conventions)
    - [Parentheses](#parentheses)
    - [Semicolon](#semicolon)
    - [Leading WhiteSpace](#leading-whitespace)
    - [Confusing Min and Max](#confusing-min-and-max)



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
### Using set or global
Using set in a function will result in storing of global, function name should be a symbol
```
q)f:{`test_g1 set 123;5};test_g1
'test_g1
  [0]  f:{`test_g1 set 123;5};test_g1       //test_g1 is not defined has function has not been called
q)f`;test_g1
123
```
if variable set has a symbol defined, set will be second layer!
```
q)v:`sq
q)v set x*x:1+til 10
`sq
q)sq
1 4 9 16 25 36 49 64 81 100
q)v
`sq
```
For the first use case of set, we can use global variable too
```
q)f:{a:: 12321;5};f` 
5
q)a
12321
```

### Aggregating Functions
Aggregation always reduce dimensionality, aggregating a list--> atom, aggregating a list of list(matrix)--> list
```
q)prd x:1+til 10  //factorial, list --> atom
3628800
q)yz:enlist[x],enlist[1+x],enlist[2+x]
q)yz
1 2 3 4 5 6 7 8  9  10
2 3 4 5 6 7 8 9  10 11
3 4 5 6 7 8 9 10 11 12
q)prd yz
6 24 60 120 210 336 504 720 990 1320    //Matrix -> list
```

### Random data, generate,deal, rand
Generate: replacement, deal: without replacement, rand: one single value of generate  
for ?[x;y], if y>0, generate from 0 till y, not including y
```
q)10?10
9 5 4 6 6 1 8 5 4 9         //generate, random number from 0-9
q)asc -10?10                //deal might not work for all data type, need to cast from int,etc
`s#0 1 2 3 4 5 6 7 8 9      //deal, negative, each number once
q)5?1f                      //up to, but not including 1
0.8546861 0.875458 0.2801965 0.5379561 0.5801688
q)rand                  //equivalent to first ?[1;x]
k){*1?x}
```
-ve values can't be upper limit, if 0 is placed as upper limit, will generate all kinds positive and negative value, excluding null  
See https://code.kx.com/v2/ref/ for the equivalent 0 values for other types
```
q)2?0h              //2 random short
-28012 29473h
//temporal
q)max 10000000?00:00
23:59
q)max 10000000?00:00:00
23:59:59
q)max 10000000?00:00:00.000
23:59:59.994
q)max 10000000?0D          
0D23:59:59.992677569
q)max 10000000?2000.01.01               //this will give the maximum of 4 years, 1 leap year cycle
2003.12.31
```
#### Generating unordered data, string/GUID/list
?[x;y], there's no maximum y for strings or GUID, so we have to use null  
Null for string: 0Nc or " ", Null for GUID: 0Ng or 000....-000000......  
generate from a list (i.e. .Q.a .Q.A .Q.n .Q.nA .Q.an .Q.b6)
```
q)10?0Nc            //all small letters
"voadnqlhna"
q)15?.Q.A,.Q.a      //all letters
"cDVLbBYMXHPDlSv"
q)2?0Ng             //GUID
fc04efa6-b3ab-9906-4e9b-ec22880b8516 28f54020-aa8f-f446-75a4-456c058a5360
```
Generating symbol, specify y to be backtick and length (i.e. `3)
```
q)10?`3
`llm`ifc`bpk`iid`mgp`gbf`eec`ign`lnf`mhe
```

#### Deck Example
```
q)deck: "234567890JQKA"cross"DCHS" //all combinations, 52
q))"," sv 5#deck 
"2D,2C,2H,2S,3D"
q)"," sv -5?deck            //drawing cards from deck
"8S,6S,KH,9D,JS"
q)shuffle:{deck::-52?deck;};shuffle`    //shuffle cards, hidden
```

#### Seed
To set seed, \S 100         //setting seed to 100  
However, seeding at 0 makes random stuff always 0
