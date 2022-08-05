#!/bin/bash
   #===============================================================================================================
   #                                                                                                                                              
   #         FILE: Retail_Demo_v3.command
   #
   #        USAGE: Run from Finder or Terminal
   #
   #  DESCRIPTION: Realtime Retail demo for SDR team using MemSQL & Zoomdata
   #      OPTIONS:  
   # REQUIREMENTS: 
   #       AUTHOR: Matt DeMarco (mattdeee@gmail.com)
   #      CREATED: 08.22.2016
   #      UPDATED: 08.26.2016 12:35 PM
   #      VERSION: 1.0
   #      EUL    : 	THIS CODE IS OFFERED ON AN “AS-IS” BASIS AND NO WARRANTY, EITHER EXPRESSED OR IMPLIED, IS GIVEN. 
   #				THE AUTHOR EXPRESSLY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED.
   #				YOU ASSUME ALL RISK ASSOCIATED WITH THE QUALITY, PERFORMANCE, INSTALLATION AND USE OF THE SOFTWARE INCLUDING, 
   #				BUT NOT LIMITED TO, THE RISKS OF PROGRAM ERRORS, DAMAGE TO EQUIPMENT, LOSS OF DATA OR SOFTWARE PROGRAMS, 
   #				OR UNAVAILABILITY OR INTERRUPTION OF OPERATIONS. 
   #				YOU ARE SOLELY RESPONSIBLE FOR DETERMINING THE APPROPRIATENESS OF USE THE SOFTWARE AND ASSUME ALL RISKS ASSOCIATED WITH ITS USE.
   #
   #
   #
   #
   #
   #
   #===============================================================================================================
clear

export RUNTIME=$(date +%m_%d_%y_%H%M)
export WORKDIR=$(pwd)



function start_up()
{
    clear screen
    echo "########################################################################"
    echo "# This tool will run the Realtime Retail demo using MemSQL & Zoomdata  #"
    echo "########################################################################"
    echo
    echo "################################################"
    echo "#                                              #"
    echo "#    What would you like to do ?               #"
    echo "#                                              #"
    echo "#          1 ==   Set up Docker                #"
    echo "#                                              #"
    echo "#          2 ==   Start the demo               #"
    echo "#                                              #"
    echo "#          3 ==   Stop the demo                #"
    echo "#                                              #"
    echo "#          4 ==   Exit the demo                #" 
    echo "#                                              #"     
    echo "#          5 ==   Help                         #"
    echo "#                                              #"
    echo "#          6 ==   QUIT                         #"
    echo "#                                              #"
    echo "#                                              #"
    echo "################################################"
    echo
    echo "Please enter in your choice:> "
    read whatwhat
}

function pause()
{
   read -p "Press [Enter] key to continue..."
}

function osx_memory_check()
{

  export OSXMEM=$(system_profiler SPHardwareDataType | grep "  Memory:"| awk '{print $2}')
  if [ $OSXMEM -lt 16 ]
    then
      echo "################################################################"
      echo "#  System Memory is less than 16GB.  Demo will not run         #"
      echo "#   EXITING                                                    #"   
      echo "################################################################"
      exit 1
   else
      echo "##################################"
      echo "# Proceed...memory is acceptable #"
      echo "##################################"
  fi
}

function check_for_docker()
{
  if [ -f "/usr/local/bin/docker" ]
      then
      echo "##################################"
      echo "# Proceed...Docker present       #"
      echo "##################################"
      pause
   else
      echo "#################################################"
      echo "#  Docker not found...downloading & installing  #"
      echo "#################################################"
      download_install_docker
      
   fi

}

function download_install_docker()
{
	   #Download Docker of OSX
      curl https://download.docker.com/mac/stable/Docker.dmg  -o /tmp/Docker.dmg
      #Mount the DMG file
      hdiutil attach /tmp/Docker.dmg
      #Copy to Applications dir
      cp -Rv "/Volumes/Docker/Docker.app" /Applications
      #Unmount the DMG file
      hdiutil detach /Volumes/Docker
      #Free up space
      rm /tmp/Docker.dmg
      #Open the Docker app
      open -a /Applications/Docker.app
      pause
}


function check_docker_memsetting()
{
   start_docker
   export DOCKERMEM=$(docker info | grep -i mem|awk '{print $3}' | cut -d. -f1)
   if [ ${DOCKERMEM} -lt 7 ]
      then
      echo "################################################################"
      echo "#  Please increase the Docker memory settings to at least 7GB  #"
      echo "#                                                              #"   
      echo "################################################################"
      increase_docker_mem
   else
      echo "##################################"
      echo "# Proceed...memory is acceptable #"
      echo "##################################"

   fi

}

function check_docker_cpusetting()
{
   start_docker
   export DOCKERCPU=$(docker info | grep -i CPUs|awk '{print $2}' )
   if [ ${DOCKERCPU} -lt 4 ]
      then
      echo "################################################################"
      echo "#  Please increase the Docker CPU count to at least 4 CPU      #"
      echo "#                                                              #"   
      echo "################################################################"
      increase_docker_cpu
   else
      echo "#####################################"
      echo "# Proceed...CPU count is acceptable #"
      echo "#####################################"

   fi

}

function increase_docker_mem()
{
  osascript<<EOF
  try
	tell application "Docker"
		activate
		tell application "System Events"
			tell process "Docker"
				tell menu bar 1
					#click menu item "About Docker" of menu "Docker"
					click menu item "Preferences…" of menu "Docker"
					delay 1
					set visible of first window to true
					set slider "Memory:" to 10000
				end tell
			end tell
		end tell
	end tell
end try
EOF
}

function increase_docker_cpu()
{
  osascript<<EOF
  try
	tell application "Docker"
		activate
		tell application "System Events"
			tell process "Docker"
				tell menu bar 1
					#click menu item "About Docker" of menu "Docker"
					click menu item "Preferences…" of menu "Docker"
					delay 1
					set visible of first window to true
					set slider "CPUs:" to 10000
					set slider "Memory:" to 10000
				end tell
			end tell
		end tell
	end tell
end try
EOF
}

function start_docker()
{
  open -a /Applications/Docker.app
  sleep 3
}

function clean_up_old_docker_images()
{
	#need to put logic here...
	export MEMSQLCONTAINER=$(docker ps -a | grep -i memsql| awk '{print $1}')
	export MEMSQLDOCKERSTATUS=$(docker ps -a | grep -i memsql| awk '{print $7}')
	case $MEMSQLDOCKERSTATUS in
    Up)
        docker rm -f $MEMSQLCONTAINER
        ;;
    Exited)
        docker rm -f $MEMSQLCONTAINER
        ;;   
    *)  
        echo ""
        ;;

	esac

	export ZOOMDATACONTAINER=$(docker ps -a | grep -i zoomdata| awk '{print $1}')
	export ZOOMDATADOCKERSTATUS=$(docker ps -a | grep -i zoomdata| awk '{print $7}')
	case $ZOOMDATADOCKERSTATUS in
    Up)
        docker rm -f $ZOOMDATACONTAINER
        ;;
    Exited)
        docker rm -f $ZOOMDATACONTAINER
        ;;   
    *)  
        echo ""
        ;;

	esac
}

function start_docker_images()
{
	#clean_up_old_docker_images
	#need to put logic here...
	export MEMSQLDOCKERSTATUS=$(docker ps -a | grep -i memsql| awk '{print $7}')
	case $MEMSQLDOCKERSTATUS in
    Up)
        echo "MemSQL appears to be running..."
        ;;
    Exited)
        echo "Starting MemSQL quickstart..."
   		#Run the MemSQL quickstart
   		docker run -d -p 3306:3306 -p 9000:9000 --name=memsql-retail memsql/quickstart
        ;;   
    *)  
        echo "Starting MemSQL quickstart..."
   		#Run the MemSQL quickstart
   		docker run -d -p 3306:3306 -p 9000:9000 --name=memsql-retail memsql/quickstart
        ;;

	esac

	export ZOOMDATADOCKERSTATUS=$(docker ps -a | grep -i zoomdata| awk '{print $7}')
	case $ZOOMDATADOCKERSTATUS in
    Up)
        echo "Zoomdata appears to be running..."
        ;;
    Exited)
        echo "Starting Zoomdata quickstart..."
   		#Run the Zoomdata quickstart
   		docker run -d  -p 8080:8080 -p 8443:8443 --name=zoomdata-retail --sig-proxy=false  zoomdata/quickstart
        ;;   
    *)  
        echo "Starting Zoomdata quickstart..."
   		#Run the Zoomdata quickstart
   		docker run -d  -p 8080:8080 -p 8443:8443 --name=zoomdata-retail --sig-proxy=false  zoomdata/quickstart
        ;;

	esac
}


function restore_demodb()
{
  #Wait 5 seconds for MemSQL database to start up
  sleep 5 
  #Create the database & load data
   #get the demo archive for memsql
   docker exec -it memsql-retail apt-get update
   #install wget for memsql image
   docker exec -it memsql-retail apt-get install -y wget net-tools
   docker exec -it memsql-retail wget https://www.dropbox.com/s/aoymngnbm1x3bbc/retail.tar.gz 
   docker exec -it memsql-retail tar -zxvf retail.tar.gz
   #set up the memsql demo database
   docker exec -it memsql-retail bash retail/dw_demo.sh
}

function restore_mongo()
{
	#update yum in order to install stuff
	docker exec -it zoomdata-retail sudo yum --assumeno update

	#install mongo tools & wget for zoomdata image
	docker exec -it zoomdata-retail sudo yum install -y mongodb-org-shell mongodb-org-tools wget
	docker exec -it zoomdata-retail sudo wget https://www.dropbox.com/s/aoymngnbm1x3bbc/retail.tar.gz 
	docker exec -it zoomdata-retail sudo tar -zxvf retail.tar.gz

	#extract the mongodb dump
	docker exec -it zoomdata-retail sudo tar -xvf retail/mongo_dump.tar

	#stop zoomdata running 
	docker exec -it zoomdata-retail sudo kill -9 $(ps -ef | grep -i zoomdata | awk '{print $2}')

	#restore the mongodb
	#demo/memsql
	docker exec -it zoomdata-retail bash retail/mongo_restore.sh

	#restart zoomdata application
	docker exec -it zoomdata-retail nohup bash /opt/zoomdata/bin/docker-runner &
}


function run_demo()
{
   start_docker
   start_docker_images

    echo "################################################"
    echo " Would you like to start the demo? "
    echo " Enter yes or no"
    echo "################################################"
    read DOWHAT
    export LCASE=$(echo $DOWHAT | awk '{print tolower($0)}')
    if [[ $LCASE = yes ]]; then
        echo "Yes"
        #Run the transaction creation script
        docker exec memsql-retail nohup python retail/trx_retail.py &
        echo "Demo is starting..."
        pause
    else
        echo "No"
        clean_up
    fi
WORK_TIME
}

function clean_up()
{
   #Kill the transaction creation  script
   docker exec memsql-retail bash retail/kill_dw.sh 

   #Clean up the database
   docker exec  memsql-retail python retail/clean_up.py 

   #Remove nohup file
   rm $WORKDIR/nohup.out

}

function remove_images()
{ 
  
  #Stop the running containers
  docker rm -f $(docker ps -a -q)
  #Remove docker images to reclaim space
  docker rmi -f $(docker images | grep -vi image |grep -i quickstart| awk '{print $3}')

}


function INVALID_CHOICE()
{
  echo "Invalid Choice..."
  echo "Try again."
  pause
  WORK_TIME


}

function SET_UP_DEMOSYSTEM()
{
   check_for_docker
   check_docker_cpusetting
   check_docker_memsetting

   echo "##########################"
   echo "# Docker set up Complete #"
   echo "##########################"

   pause
   WORK_TIME
}

function START_DEMO()
{
   start_docker
   start_docker_images
   restore_demodb
   restore_mongo
   #Open the website for each system
   #open http://localhost:9000
   #open https://localhost:8443/zoomdata

   # Ops User - matt/memsql
   # ZD User - demo/memsql

   #Show website for each system
   echo "##################################################"
   echo "# MemSQL OPS WUI - http://localhost:9000         #"
   echo "# ZoomData WUI - https://localhost:8443/zoomdata #"
   echo "# username/password: demo/memsql 				  #"
   echo "##################################################"
 
   run_demo
   WORK_TIME

}

function STOP_DEMO()
{
   clean_up
   WORK_TIME

}

function EXIT_DEMO()
{
   # Stop and remove the images
   remove_images
   DO_NOTHING

}


function DO_NOTHING()
{
    echo "################################################"
    echo "Would you like to quit? "
    echo "Enter yes or no"
    echo "################################################"
    read DOWHAT
    export LCASE=$(echo $DOWHAT | awk '{print tolower($0)}')
    if [[ $LCASE = yes ]]; then
        echo "Yes"
        exit 1
    else
        echo "No"
        WORK_TIME
    fi

}

function HELP()
{
	clear screen
  	echo "################################################"
    echo "#                                              #"
  	echo "#      What would you like help with?          #"
  	echo "#          1 ==   What is this about?          #"
    echo "#                                              #"
  	echo "#          2 ==   Set up Docker                #"
    echo "#                                              #"
    echo "#          3 ==   Start the demo               #"
    echo "#                                              #"
    echo "#          4 ==   Stop the demo                #"
    echo "#                                              #"
    echo "#          5 ==   Exit the demo                #" 
    echo "#                                              #"     
    echo "#          6 ==   Help                         #"
    echo "#                                              #"
    echo "#          7 ==   Exit Help                    #"
    echo "#                                              #"
    echo "#                                              #"
    echo "################################################"
  read HELPME

  case $HELPME in
  	1)
		echo "This is a demostration of Realtime Retail analytics."
		echo "The premise is that you are an Executive at a retail chain and you want to see live point of sales data."
		echo "You can see data from each store on items, transaction amounts, tender types and tender."
		
		;;
	2)
		echo "This will check for OSX Docker."
		echo "If you do not have it installed we will download and install for you."
		echo "We will attempt to set memory and CPU but Docker's API is...faky."

		;;
	3) 
		echo "This will download the quickstart Docker images for MemSQL & Zoomdata."
		echo "This will also restore the retail database & restore mongodb to have MemSQL branding in Zoomdata."
		echo "This will begin generating random transaction data into MemSQL."
		echo "The website for the demo is https://localhost:8443/zoomdata."
		echo "The username and password are demo & memsql."
		echo "We recommend starting the demo using the 'Bars' viz."
		echo "We recomment playing with the demo system PRIOR to customer engagement... >.<"

		;;
	4)
		echo "This will stop the random transaction generation and delete all rows in the transaction table."
		echo "This is done to get memory back... >.<"
		echo "If you combine the stop and start options you can restart your demo at anytime...I think..."

		;;
	5)
		echo "This will STOP and REMOVE the Docker images from you system."
		echo "This will give you back system resources after the demo."

		;;
	6)
		echo "This...you are reading the Help system..."
		echo "If you need help with Help...whelp...I don't know what to tell youse...  >.<"
		
		;;
	7)
		WORK_TIME
		;;
	*)
		INVALID_CHOICE
		;;
	esac


  pause
  WORK_TIME

}

function WORK_TIME()
{
#osx_memory_check
start_up
case $whatwhat in
    1)
        SET_UP_DEMOSYSTEM
        ;;
    2)
        START_DEMO
        ;;
    3)
        STOP_DEMO
        ;;
    4)
        EXIT_DEMO
        ;;
    5)  
        HELP
        ;;
    6)   
        DO_NOTHING
        ;;
    *)  
        INVALID_CHOICE
        ;;

esac
}

# Main
#check memory...then run
osx_memory_check
WORK_TIME









