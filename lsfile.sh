#!/bin/zsh
if [ -z $1 ]
then
    cd ~
else 
    cd $1
fi
echo "\e[?1049h"
COPYIED_FILE=" "
GREEN="\e[32m"
C_DEFAULT="\e[0m"
function green {
    echo "\e[32m$1\e[0m"
}
while true
do  
    echo "\e[0m"
    echo "\e[32m-----------------"
    echo "'lsfile' File Lookup"
    echo "$(pwd)"
    echo "Clipboard: ${COPYIED_FILE}\e[0m"
    ls -AGF
    echo
    while true
    do
        echo -n "\e[32m" 
        operation=""
        while [ -z "${operation}" ]
        do
            echo -n ":"
            read operation
        done
        if [ "${operation}" = "//q" ] ;then
            echo "\e[?1049l"
            exit
        fi

        if [[ "${operation}" == "//"* ]];then
            command="${operation:2}"
            case "${command}" in
                "finder"*) 
                   #open in finder
                    if [ "${command}" = "finder" ]
                    then
                        open ./
                    else 
                        open -R "${command:7}"
                    fi
                ;;
                "copy "*) 
                    #copy a path
                    COPYIED_FILE="$(realpath "${command:5}")"
                    break;
                ;;
                "copy")
                    COPYIED_FILE="$(realpath ".")"
                    break;
                ;;
                "clear_clipbd")
                    #clear clipboard
                    COPYIED_FILE=" "
                    break;
                ;;
                "reload")
                    break
                ;;
                "linkdown")
                    if [ ${COPYIED_FILE} = " " ];then
                        green "Clipboard is empty"
                    else
                        if [[ ${COPYIED_FILE} == "."* ]] || [[ ${COPYIED_FILE} == "~"* ]];then
                            green "'ln' don't support ./ or ~/"
                        else
                            ln -s ${COPYIED_FILE} ./$(basename ${COPYIED_FILE})
                            break
                        fi
                    fi
                ;;
                "linkdown "*)
                    if [ ${COPYIED_FILE} = " " ];then
                        green "Clipboard is empty"
                    else
                        if [[ ${COPYIED_FILE} == "."* ]] || [[ ${COPYIED_FILE} == "~"* ]];then
                            green "'ln' don't support ./ or ~/"
                        else
                            ln -s "${COPYIED_FILE} ${command:9}"
                            break;
                        fi
                    fi
                ;;
                "sh "*)
                    zsh -c "${command:3}"
                ;;
                "rm "*)
                    echo -n "${GREEN}Will delete '${command:3}' permanently. Really want to remove it? [y/?] ${C_DEFALUT}"
                    read answer
                    if [ "${answer}" = "y" ];then
                        if [ -d "${command:3}" ];then
                            rm -r "${command:3}"
                        else
                            rm "${command:3}"
                        fi
                    fi
                    unset answer
                    break
                ;;
                "paste")
                    if [ ${COPYIED_FILE} = " " ];then
                        green "Clipboard is empty"
                    else
                        if [ -d ${COPYIED_FILE} ];then
                            copy -R ${COPYIED_FILE} $(basename ${COPYIED_FILE})
                        else
                            copy ${COPYIED_FILE} $(basename ${COPYIED_FILE})
                        fi
                    fi
                    break
                ;;
                "paste "*)
                    if [ ${COPYIED_FILE} = " " ];then
                        green "Clipboard is empty"
                    else
                        if [ -d ${COPYIED_FILE} ];then
                            copy -R ${COPYIED_FILE} ${command:6}
                        else
                            copy ${COPYIED_FILE} ${command:6}
                        fi
                    fi
                    break
                ;;
                *)
                    green "Command not support: '${command}'"
                ;;
            esac
            ###########################################
        else
            cd "${operation}" && break
            
        fi
    done
    echo "\e[H\e[J"
done
