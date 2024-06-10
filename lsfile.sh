#!/bin/zsh
if [ -z $1 ]
then
    cd ~
else 
    cd $1
fi
COPYIED_FILE=" "
green() {
    echo $2
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
            #operations area
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
                    zsh -c "${command:3}"
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
