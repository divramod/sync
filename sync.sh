#sudo rsync -avq /home/mod /media/mod/HD11/backups-home/20170509_x121e --delete
sudo rsync -av --exclude-from='/home/mod/sync/exclude.txt' /home/mod /media/mod/HD11/backups-home/20170509_x121e --delete
