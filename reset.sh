#!/bin/bash
set -e

function print_red() {
    echo -e "\033[31m$1\033[39m"
}

RUNSERVER=false
while getopts "sh" OPTION
do
    case $OPTION in
        s)
             echo "Start Server"
             RUNSERVER=true
             ;;
        ?)
             echo "fail"
             exit
             ;;
     esac
done


debug=$(python -c "from project.settings import DEBUG; print(DEBUG)")
dbname=$(python -c "from project.settings import LOCAL_DATABASES; print(LOCAL_DATABASES['default']['NAME'])")

if [ "$debug" != "True" ] ; then
  print_red "DEBUG is not True."
  exit 1
fi

echo "----------------------drop-database------------------------------"
dropdb "$dbname"

echo "  create-database"
createdb "$dbname"

python manage.py migrate


if  $RUNSERVER ; then
    python manage.py runserver 0.0.0.0:8000 --nothreading
fi
