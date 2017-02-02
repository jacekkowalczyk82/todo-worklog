#!/bin/sh 
set -e 

OPERATION=$1
INPUT=$2
WORKDIR=`pwd`

if [ "$OPERATION" == "" ]; then
   echo "Missing first parameter"
   echo "$0 <OPERATION> <FORMATTED MESSAGE>"
   exit 1
fi

if [ "$INPUT" == "" ]; then
   echo "Missing second parameter"
   echo "$0 <OPERATION> <FORMATTED MESSAGE>"
   exit 1
fi



PROJECT="default"
MESSAGE=$INPUT
if [[ $INPUT == *"PROJECT:"* ]]; then
   echo "project found "
   PROJECT=$(echo $INPUT |awk -F "," '{print $1}'|awk -F ":" '{print $2}')
   MESSAGE=$(echo $INPUT |awk -F "," '{print $2}')
fi

echo "DEBUG"
echo "INPUT=$INPUT"
echo "PROJECT=$PROJECT"
echo "MESSAGE=$MESSAGE"


source ./todo.conf 

#TODO_WORKING_COPY_PATH=/d/babun-repos/todo-worklog
#TODO_GIT_COMMIT_COMMAND="git commit -a -m `[TODO] $MESSAGE`"
#WLOG_GIT_COMMIT_COMMAND="git commit -a -m `[WLOG] $MESSAGE`"

if [ -d ${TODO_WORKING_COPY_PATH}/${PROJECT} ]; then 
   echo "dir ${TODO_WORKING_COPY_PATH}/${PROJECT} exists"
else 
   mkdir -p ${TODO_WORKING_COPY_PATH}/${PROJECT}
fi 

cd ${TODO_WORKING_COPY_PATH} && git pull --rebase 

echo "* [ ] $MESSAGE" >> ${TODO_WORKING_COPY_PATH}/${PROJECT}/TODO.md 

cd ${TODO_WORKING_COPY_PATH} && git add ${PROJECT}/TODO.md
cd ${TODO_WORKING_COPY_PATH} && git commit -a -m "[TODO] $MESSAGE"
cd ${TODO_WORKING_COPY_PATH} && git push origin master 





