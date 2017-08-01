#/bin/bash

DEFAULT_FOLDER="../Screenshots"
FOLDER=$DEFAULT_FOLDER
STATUS_FILE_GONNA_BE_USED="YES"
LINK_TO_UPLOAD='https://lewd.se/api.php?d=upload-tool'




function go_to_folder() {
 cd $FOLDER
}


function clear_uploadlist() {
 echo "" > uploadlist
}


function list_filenames_to_upload() {
 for file_to_check in `find`;
 do
   STATUS_FILE_GONNA_BE_USED="YES";
   test_file_presence_in_ignorelist
   if [[ "$STATUS_FILE_GONNA_BE_USED" = "YES" ]]
   then
     echo $file_to_check >> uploadlist
   fi
 done
}

function test_file_presence_in_ignorelist() {
 while read file_from_ignorelist;
 do
   check_if_filenames_are_equal
 done < $FOLDER/upload-ignorelist
}

function check_if_filenames_are_equal () {

   if [[ "$file_to_check" = "$file_from_ignorelist" ]] 
   then
     STATUS_FILE_GONNA_BE_USED="NO"
   fi
}


upload_current() {
 echo "${file_to_upload}" 
 answer="$(curl --progress-bar -F file=@"${file_to_upload:2}" "${LINK_TO_UPLOAD}")"
 echo
 echo $answer
 echo "$file_to_upload" "$answer" >> links
}

upload() {
 while read file_to_upload
 do
    ignore_void_string
    upload_current
 done < uploadlist
}

function ignore_void_string() {
 if [[ "$file_to_upload" = '' ]]
 then
   continue
 fi
}


function send_uploaded_to_ignorelist() {
  if file_not_void
  then 
    cat uploadlist >> upload-ignorelist
    echo "" > uploadlist
  fi
}

function file_not_void() {
prev_string="bileberda"
prev_prev="sdsdasdad"
 while read string 
 do
   if [[ "$prev_string" = "$string" ]]
   then
     return 1 
   fi 
   prev_prev="$prev_string"
   prev_string="$string"
 done < uploadlist
 if [[ "$prev_prev" = "bileberda" ]]; then return 1; fi;
 return 0
}


#-#-# PARSE OPTS


while getopts :asf opt
do 
  case $opt in
    a) 
      echo "area"
      #area
    ;;
    s)
      xfce4-screenshooter -f -s ~/Screenshots
      #screen
    ;;
    f)
      echo "file"
      #file
    ;;
    \?)
      echo "wat" 
      #wat?
    ;;
  esac
done


#-#-# BODY


# TODO if folder is mentioned
go_to_folder
clear_uploadlist
list_filenames_to_upload
upload
send_uploaded_to_ignorelist
