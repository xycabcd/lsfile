#!/bin/zsh
if [ -z $1 ]
then
    cd ~
else 
    cd $1
fi
COPYIED_FILE=" "
GREEN="\e[32m"
C_DEFAULT="\e[0m"
green() {
    echo "\e[32m$1\e[0m"
}
while true
do
    echo "\e[32m-----------------"
    echo "'lsfile' File Lookup"
    echo "$(pwd)"
    echo "Clipboard: ${COPYIED_FILE}\e[0m"
    ls -AGF
    echo
    while true
    do
        echo -n "\e[32m:\e[0m" 
        read operation
        if [ ${operation} = "//q" ] ;then
            exit
        fi

        if [[ ${operation} == "//"* ]];then
            command=${operation:2}
            #operation
            ###########################################
            case "${command}" in
                "finder"*) 
                   #open in finder
                    if [ ${command} = "finder"]
                    then
                        open ./
                    else 
                        open -R ${command:6}
                    fi
                ;;
                "copy "*) 
                    #copy a path
                    COPYIED_FILE=$(realpath ${command:5})
                    break
                ;;
                "clear_clipbd")
                    #clear clipboard
                    COPYIED_FILE=" "
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
                            ln -s ${COPYIED_FILE} ${command:9}
                            break;
                        fi
                    fi
                ;;
                "sh "*)
                    zsh -c ${command:3}
                ;;
                "rm "*)
                    echo -n "${GREEN}Will delete '${command:3}' permanently. Really want to remove it? [Y/any other key] ${C_DEFALUT}"
                    read answer
                    if [ ${answer} = "Y" ];then
                        if [ -d ${command:3} ];then
                            rm -r ${command:3}
                        else
                            rm ${command:3}
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
                ;;
                *)
                    green "Command not support: '${command}'"
                ;;
            esac
            ###########################################
        else
            cd ${operation}
            if [ $? = 0 ];then
                break
            fi
        fi
    done
done
