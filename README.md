# ArchiveBits

ArchiveBits search the specified directory, and all subdirectories, for files with archive bit set.  It returns the sum-total size of those files, then outputs a file listing those files, to that directory, sorted either by size or date.  

Examples

>.\ArchiveBits.ps1 -path C:
-Searches entire C: drive and outputs results.txt to root with files sorted by size (default).

>.\ArchiveBits.ps1 -path C: -sizeonly
Only returns the sum-total size of the files (How much space an incremental backup is going to take).

>.\ArchiveBits.ps1 -path C: -filename myfilename.txt
-Searches entire C: drive and outputs myfilename.txt to root with files sorted by size (default).

>.\ArchiveBits.ps1 -path C: -filename myfilename.txt -minsize -1000
-Only files larger than 1,000 Bytes.

>.\ArchiveBits.ps1 -path C: -filename myfilename.txt -newest
-Sorts by date.

