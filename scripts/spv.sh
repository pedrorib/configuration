#!/bin/sh

case $1 in 
"status") sudo /edx/bin/supervisorctl status ;;
"restart")  if [ -z $2 ] ; then
			sudo /edx/bin/supervisorctl restart edxapp:
			sudo /edx/bin/supervisorctl restart edxapp_worker:
			else
			sudo /edx/bin/supervisorctl restart "$2"
			fi
			;;
"start")    if [ -z $2 ] ; then
			sudo /edx/bin/supervisorctl start edxapp:
			sudo /edx/bin/supervisorctl start edxapp_worker:
			else
			sudo /edx/bin/supervisorctl start "$2"
			fi
			;;
"stop")    if [ -z $2 ] ; then
			sudo /edx/bin/supervisorctl stop edxapp:
			sudo /edx/bin/supervisorctl stop edxapp_worker:
			else
			sudo /edx/bin/supervisorctl stop "$2"
			fi
			;;
esac
