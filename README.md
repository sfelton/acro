# acro

acro is a simple program to quickly look up any acronym from an acronym list stored on your computer.  It also provides the functionality to create this list easily add entries to the list.

###Setup
acro depends on a file called acronyms.txt placed in the same directory as the acho.sh file.  When the program starts it will check if this file exsists and remind you to create it if it does not.  Creating this file can be done easily using the `-c` flag.
```sh
$ acro -c
```
No argument is required, it will automatically create the a file called acronyms.txt.  If you wish to change the name of this file, you can shange the FILENAME variable in acro.sh

###Use
Simply type the acronym you are looking for as an argument to search for it.
```sh
$ acro VPN
VPN     | Virtual Private Network
```
When searching for acronyms, the case of the letters does not matter.
```sh
$ acro TLA
TLA     | Three Letter Acronym
$acro tla
TLA     | Three Letter Acronym
```

To display only exact word matches (skip any patial matches), use the `-e` flag
```sh
$ acro BU
BU      | Buisness Unit
COBC    | Code of Buisness Conduct
$ acro -e BU
BU      | Buisness Unit
```

The `-l` flag will let you search for all acronyms starting with a specific letter
```sh
$ arco -l D
DB      | Database
DBMS    | Database Management System
DES     | Data Encryption Standard
DoS     | Denial of Service
```

The `-a` flag will prompt you to add an acronym to the list.  This does not take any arguments and will not print anything if added successfully.
```sh
$ acro -a
What is the ACRONYM? TPS
What is the MEANING? Third Party Software
$ acro
```
*Important Note:*
acro does not change the entry (case of letters, spelling, etc...) before adding it to the acronyms file.  This means the search results will show exactly what you have typed.




