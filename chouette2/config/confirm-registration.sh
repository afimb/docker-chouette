#!/bin/bash
EMAIL=$1

function usage(){
	echo "Usage : `basename $0` <user email to confirm>" 

}

if [ -z "$EMAIL" ];then
	usage
	exit
fi


echo "update users set confirmed_at=created_at where email = '$EMAIL'; " | psql -U chouette -h localhost chouette_dev
