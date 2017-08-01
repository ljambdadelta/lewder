# lewder

script for send pics to lewd.se
make screenshot -> save it to ~/Screenshots and push ALL THE FILES from this folder
to deny pushing evrything you can write the unwanted to be uploaded files to upload-ignorelist
upload-ignorelist, uploadlist and links in ~/Screenshots are produced by this script. Copies link to clipboard.

*.upload-ignorelist	files to ignore while upload everything to lewd

*.uploadlist		files that are uploading at this session

*links			file-link pares of already uploaded files


Parametrs :


-a	| area screenshot & upload all not uploaded before files

-s	| fullscreen screenshot & upload all not uploaded before files

-c	| check if there are in list of uploaded files that are already deleted and remove them from this list

-h	| show help

-f file | upload file mentioned after '-f'	
