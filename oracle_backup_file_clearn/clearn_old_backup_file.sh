#! /bin/bash
for file in `ls /orabak`
do
   if [[ ${file:0:2} == "db" ]];then
         fdate=${file:10:8}
         mydate=`date +%Y%m%d -d "-7 day"`
         if [[ $fdate < $mydate ]];then
               rm -rf $file;
         else
               echo $file;
         fi
     else
         fdate=${file:12:8}
        mydate=`date +%Y%m%d -d "-7 day"`
         if [[ $fdate < $mydate ]];then
               rm -rf $file;
         else
               echo $file;
         fi
      fi
done