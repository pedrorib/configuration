#!/bin/sh

case $1 in
"help") 
		echo "Most of the administration tasks should be performed using the admin backoffice"
		echo "http://courses.mooc.tecnico.ulisboa.pt:18010/admin"
		echo "This script allows you to perform:"
		echo "-> SUPERUSER PROMOTION: super <user email>)"
		echo "-> COURSE REMOVALS: delcourse <Organization> <CourseNumber> <CourseRun> <new|old>"
		echo "-> CHANGE USER PASSWORDS: chpwd <user email>"
		echo "To use other commands, please consult https://openedx.atlassian.net/wiki/display/OpenOPS/Managing+OpenEdX+Tips+and+Tricks"
		;;
"super") 
		if [ 1 -eq $# ] ; then 
			sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws create_user -s -p edx -e (echo $1 | sed 's/@.*//')
			sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws changepassword (echo $1 | sed 's/@.*//')
			sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws shell
		else 
			echo "The super command MUST have only one argument"
			echo "Run bash manage.sh help for more information"
		fi
		;;
"newusr")
		if [1 -eq $#] ; then 
			sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws create_user -e "$1"
			sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws changepassword (echo $1 | sed 's/@.*//')
		else
			echo "This command must have only one argument"
			echo "Run bash manage.sh help for more information"
		fi
		;;
"chpwd") 
		if [ 1 -eq $# ] ; then 
			sudo -u www-data /edx/bin/python.edxapp ./manage.py lms --settings aws changepassword (echo $1 | sed 's/@.*//')
		else 
			echo "The chpwd command MUST have only one argument"
			echo "Run bash manage.sh help for more information"
		fi
		;;
"delcourse") 
		if [ 4 -eq $# ] ; then
			echo 'Deleting the course and dropping its database is UNRECOVERABLE'
			echo 'Have you performed all the desired backups and are you sure you want to proceed?'
			echo '(yes to proceed, anything else to abort)'
			read decision
			if [ decision != "yes"]
				echo "ABORTING NOW"
				exit
			fi
			case $4 in
			"old") sudo -u www-data /edx/bin/python.edxapp ./manage.py cms --settings=aws delete_course Organization/CourseNumber/CourseRun commit ;;
			"new") sudo -u www-data /edx/bin/python.edxapp ./manage.py cms --settings=aws delete_course course-v1:Organization+CourseNumber+CourseRun commit ;;
			*) echo 'The 4th argument must be "old" or "new", depending on the course link format'
			echo 'Run bash manage.sh help for more information'
			;;
			esac
		else
			echo "The delcourse command MUST have only one argument"
			echo "Run bash manage.sh help for more information"
		fi
		;;
*) 
	echo "Unrecognised command"
	echo "Run bash manage.sh help for more information to get a list of all commands"
	;;
esac
			
			
