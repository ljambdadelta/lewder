#/bin/bash

DEFAULT_FOLDER=~/Screenshots
FOLDER=$DEFAULT_FOLDER
STATUS_FILE_GONNA_BE_USED="YES"
LINK_TO_UPLOAD='https://lewd.se/api.php?d=upload-tool'




function go_to_folder() {
 cd $FOLDER
}


check_lists() {
 go_to_folder
 touch ._temp
 while read file_exist_check
 do
  if [[ -e "$file_exist_check" ]]
  then
    echo "$file_exist_check" >> ._temp
  fi
 done < .upload-ignorelist 
 rm .upload-ignorelist
 mv ._temp .upload-ignorelist
 exit
}

function clear_uploadlist() {
 echo "" > .uploadlist
}


function list_filenames_to_upload() {
 for file_to_check in `find`;
 do
   STATUS_FILE_GONNA_BE_USED="YES";
   test_file_presence_in_ignorelist
   if [[ "$STATUS_FILE_GONNA_BE_USED" = "YES" ]]
   then
     echo $file_to_check >> .uploadlist
   fi
 done
}

function test_file_presence_in_ignorelist() {
 while read file_from_ignorelist;
 do
   check_if_filenames_are_equal
 done < .upload-ignorelist
}

function check_if_filenames_are_equal () {

   if [[ "$file_to_check" = "$file_from_ignorelist" ]] 
   then
     STATUS_FILE_GONNA_BE_USED="NO"
   fi
}


upload_current() {
 echo "${file_to_upload}" 
 answer="$(curl --progress-bar -F file=@"${file_to_upload}" "${LINK_TO_UPLOAD}")"
 echo "$answer" | xclip -selection cli
 echo
 echo $answer
 echo "$file_to_upload" $'\t\t\t' "$answer" >> ~/Screenshots/links
}

upload() {
 while read file_to_upload
 do
    ignore_void_string
    upload_current
 done < .uploadlist
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
    cat .uploadlist >> .upload-ignorelist
    echo "" > .uploadlist
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
 done < .uploadlist
 if [[ "$prev_prev" = "bileberda" ]]; then return 1; fi;
 return 0
}


#-#-# PARSE OPTS


while getopts f:acsh opt
do 
  case $opt in
    a) 
      xfce4-screenshooter -r -s ~/Screenshots  
      #area
    ;;
    c)
     check_lists
     #check lists!
    ;;
    s)
      xfce4-screenshooter -f -s ~/Screenshots
      #screen
    ;;
    f)
     file_to_upload="$OPTARG"
     upload_current 
     exit
      #file
    ;;
    h)
      echo "Simple interface to upload pictures/files to lewd.se"
      echo "-h to show this H_elp"
      echo "____________________________________________________"
      echo "-a to choose A_rea, save it to ~/Screenshots and upload ALL unuploaded files from this dir"
      echo "-s to make full_S_creen screenshot and treat it like metioned before"
      echo "____________________________________________________"
      echo "-f to upload F_ile mentioned after -f"
      echo "____________________________________________________"
      echo "-c to C_heck and remove from list of uploaded files ones that are not present in directory"
      exit
    ;;
    \?)
      echo "You can call help by -h option"
      exit 
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
