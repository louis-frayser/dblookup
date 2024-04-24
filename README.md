# dblookup
Manages multiple mlocate databases. Update them separately, or several at a time.  Search one or all.


Planed are two tools: mkdb, dblookup they are analogous to updatedb and locate. 

1. mkdb dbname path1 path2 ...

   Runs mkdir -p ${LOCATEDIR}/{path1,path2,..}\
        updatedb -o $LOCATEDIR/path1/mlocate.db -U path1\
	    updatedb -o $LOCATEDIR/path2/mlocate.db -U path2\
	...for each path\
   Adds to the database the assoction dbname-> [path1,path2,...]\
   \
   The database definition file is $LOCATEDIR/dblookp.ht.
	
	
	
2. dblookup dbname seachspec...

    Looks for matches to searchspec in mlocate databases
	   associated with dbname.


## Configuration 
1. Configuration is handled by Config.hs.
2. The locate database(s) name-to-files mapping is in the file \
   _$prefix/lib/db/dblookup/dblookup.ht_
3. *dblookup* analizes the locate databases in ($prefix/lib/db/**/dblookup.db)
	at runtime to determine if they are mlocate or plocate databases.
4.  NOTE: /etc/updatedb.conf still controls what _updatedb_ does.

## Status
   
 mkdb is now functional
   
```
$ ./mkdb bin /bin /usr/bin ~/bin /sbin /usr/lucho/*bin
updatedb -o /var/lib/mlocate/bin/mlocate.db -U /bin
updatedb -o /var/lib/mlocate/usr/bin/mlocate.db -U /usr/bin
updatedb -o /var/lib/mlocate/export/home/frayser/bin/mlocate.db -U /export/home/frayser/bin
updatedb -o /var/lib/mlocate/sbin/mlocate.db -U /sbin
updatedb -o /var/lib/mlocate/usr/lucho/bin/mlocate.db -U /usr/lucho/bin
updatedb -o /var/lib/mlocate/usr/lucho/sbin/mlocate.db -U /usr/lucho/sbin
```
