# dblookup
Manages multiple mlocate databases. Update them separately, or several at a time.  Search one or all.


Planed are two tools: mkdb, dblookup they are analogous to updatedb and locate. 

1. mkdb dbname path1 path2 ...

   runs mkdir -p ${LOCATEDIR}/{path1,path2,..}\
        updatedb -o $LOCATEDIR/path/mlocate.db -U path1\
	updatedb -o $LOCATEDIR/path/mlocate.db -U path2\
	...for each path\
   Adds to the database the assoction dbname-> [path1,path2,...]\
   \
   The database directory is $LOCATEDIR/dblookp.ht.
	
	
	
2. dblookup dbname seachspec

    looks for matches to searchspec in mlocate databases
	   associated with dbname.


## Status
   
 mkdb is now funtional
   
```
$ ./mkdb bin /bin /usr/bin ~/bin /sbin /usr/lucho/*bin
updatedb -o /var/lib/mlocate/bin/mlocate.db -U /bin
updatedb -o /var/lib/mlocate/usr/bin/mlocate.db -U /usr/bin
updatedb -o /var/lib/mlocate/export/home/frayser/bin/mlocate.db -U /export/home/frayser/bin
updatedb -o /var/lib/mlocate/sbin/mlocate.db -U /sbin
updatedb -o /var/lib/mlocate/usr/lucho/bin/mlocate.db -U /usr/lucho/bin
updatedb -o /var/lib/mlocate/usr/lucho/sbin/mlocate.db -U /usr/lucho/sbin
```
