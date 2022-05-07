#!/bin/bash

display_syntax_remember_exit () {
   echo "Rappel de syntaxe :"
   echo "./sauvegarder.sh -s dossier_a_sauvegarder -d emplacement_de_la_sauvegarde"
   exit 2
}

#On part du postulat que le 1er argument de cette fonction sera TOUJOURS le dossier à sauvegarder
checkDirectoriesExistances(){
	if ! [ -d $1 ]
	then
   		echo "Le dossier a sauvegarder n'existe pas !"
   		exit 2
	elif ! [ -d $2 ]
	then
		echo "Le dossier contenant les sauvegardes n'existes pas !"
		exit 2
	fi
}

getFolderName(){
		echo $1$(date '+%Y%m%d-%H%M%S') | sed  's/\//_/g' 
		#echo $1 | echo $d(sed  's/\//_/g
	}

# la 1er argument est le nom du dossier container, le second est le nom du dossier a sauvegarder 
getFoldersNumber(){
	ls -l $1 | grep $2 | wc -l
	
}

#Cette fonction delete tous les fichiers alors qu'elle ne devrait delete que ceux nécéssaire :-(
deleteFolderIfNecessary(){
	read -p "Combien faut il de dossier d'archive maximum : " nbFoldersMax
	if [ $nbFoldersMax -lt $(getFoldersNumber $1 $2) ]
	then 
		nbFolderToDelete=$( getFoldersNumber $1 $2 - $nbFoldersMax )
		echo "Cette fonction delete tous les fichier et je ne sais pas pourquoi :-("		
		tabFile=($(ls $1 | grep ds1 | sort  | head -n $nbFolderToDelete | sed "s/^/$1\//g")) 
		for file in ${tabFile[*]}
		do
			echo $file
			rm -f $file
		done
	fi
}


if [ -z $1 ]
then
	echo "Arguments invalides"
	display_syntax_remember_exit 
fi
case $1 in
       	"-s")
		if [ -n "$4" ] 	&& [ "$3" == "-d" ]
 		 then 
			checkDirectoriesExistances $2 $4
			newFolderName=$(getFolderName $2)
			# deleteFolderIfNecessary $4 $2
			tar cvfz $4/$newFolderName.tar.gz $4
			exit 0	
		else
			echo "Arguments incorrects"
                	display_syntax_remember_exit
		fi		
		;;
	
	"-d")
		if [ -n "$4" ]  && [ "$3" == "-s" ]
                 then
			checkDirectoriesExistances $4 $2
			newFolderName=$(getFolderName $4)
            # deleteFolderIfNecessary $2 $newFolderName
			tar cvfz $4/$newFolderName.tar.gz $2
			exit 0
                else
                        echo "Arguments incorrects"
                	display_syntax_remember_exit
                fi
                ;;


	"-i")
		read -p "Saisir le chemin du dossier à sauvegarder : " folderToSave
	        read -p "Saisir le chemin de l'emplacement de sauvegarde : " folderContainer 
		checkDirectoriesExistances $folderToSave $folderContainer
		tar cvfz $folderContainer/$(getFolderName "$folderToSave").tar.gz $folderToSave
	       	exit 0	
		;;
	*)
		echo "Arguments incorrects"
        	display_syntax_remember_exit
esac
	
