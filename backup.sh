# This script backups the ThinkPad
backup_file="/backup/readme.txt"

date > $backup_file 
if [[ -z /backup ]]; then
    mkdir /backup
fi

echo "" >> $backup_file
echo "The *.tar.gz files correspond to directories in the / directory of the ThinkPad." >> $backup_file
echo "" >> $backup_file
d=$(date)
d_d="The time is now "$d
echo $dd >> $backup_file
echo " " >> $backup_file 
cd /
echo "Here is an overview of the directories being backed up..." >> $backup_file 
echo " " >> $backup_file 

echo "These 9 are always excluded: ., /tmp, /dev, /mnt, /cdrom, /lost+found, /proc, /backup, /run" >> $backup_file
echo " " >> $backup_file 
blist=$(find . -maxdepth 1 -type d)
echo "Here is a list of directories in the / directory" >> $backup_file
echo $blist >> $backup_file
echo " " >> $backup_file 
eval "biglist=($blist)" # Convert a list of directories in / to be an array for processing below.
# above is a list of every directory in /
# below is a list of directories that should not be backed up
secondlist=("." "./" "./tmp" "./dev" "./mnt" "./cdrom" "./lost+found" "./proc" "./backup" "/./backup" "./run")
len=${#biglist[@]}
for (( i=0; i<$len; i++ )); 
  do
  flag="FALSE"
  for item in "${secondlist[@]}"; do
      if [[ $item == ${biglist[i]} ]]; then 
          flag="TRUE"
      fi
  done
  if [ ! $flag == "TRUE" ]; then 
      echo "-----------------------------"
      echo ${biglist[i]}
      echo "Here is the size of the files in the " ${biglist[i]} " directory" >> $backup_file
      df -h ${biglist[i]} >> $backup_file
      sudo tar -czvf /backup/${biglist[i]}.tar.gz ${biglist[i]}/
      scp /backup/${biglist[i]}.tar.gz monitoruser@147.182.249.116:/thinkpad
  fi
  done

echo " " >> $backup_file 
echo "End of backup process" >> $backup_file
date >> $backup_file 
scp $backup_file monitoruser@147.182.249.116:/thinkpad
echo ""
echo "The script has completed running"
