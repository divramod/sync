= Knowledge =

== du ==
* exclude http://www.golinuxhub.com/2014/09/how-to-exclude-multiple-directories.html

== rsync ==
* https://linux.die.net/man/1/rsync
* exclude pattern: https://askubuntu.com/questions/320458/how-to-exclude-multiple-directories-with-rsync
```bash
/dir/ means exclude the root folder /dir
/dir/* means get the root folder /dir but not the contents
dir/ means exclude any folder anywhere where the name contains dir/
Examples excluded: /dir/, /usr/share/directory/, /var/spool/dir/
/var/spool/lpd/cf means skip files that start with cf within any folder within /var/spool/lpd

```
