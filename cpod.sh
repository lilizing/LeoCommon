#!/bin/bash

Cyan='\033[0;36m'
Default='\033[0;m'

update=""

echo $*

getUpdate() {
	echo -e "请输入需要更新的Framework（${Cyan}ALL${Default} 或 ${Cyan}NO${Default} 或 ${Cyan}以空格分隔的Framework列表${Default}，默认${Cyan}NO${Default}]）: "
    read update
    if test -z "$update"; then
        update="NO"
    fi
}

getInfomation() {
    getUpdate

    echo -e "\n${Default}================================================"
    echo -e "  更新以下Frameworks  :  ${Cyan}${update}${Default}"
    echo -e "================================================\n"
}

getInfomation

OLD_IFS="$IFS"
IFS=" "
params=($update)
IFS="$OLD_IFS"

first=${params[0]}

if [  $first = "ALL" ]; then 
	carthage update --platform ios
elif [ $first != "NO" ]; then
	carthage update --platform ios ${update[*]} 
fi

export TMP_PROJECT_DIR=$(pwd)
pod install --verbose --no-repo-update
unset TMP_PROJECT_DIR

say "Finished"
echo -e "\n${Cyan}================================Finished================================\n"
