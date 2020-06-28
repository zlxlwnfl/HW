# PROJECT 2

title="MAIL BOX"
pos=0
id=0
user_list=()
user_db_path=/tmp/mailBox_user_DB.txt
mail_db_path=/tmp/mailBox_mail_DB.txt

mail_index_list=()
project1ReturnFilename=""

project2Init() {
    local list=$(ls -al /tmp | grep mailBox_user_DB)
    if [ "$list" == "" ]; then
        cd /tmp
        touch mailBox_user_DB.txt
    fi

    local list=$(ls -al /tmp | grep mailBox_mail_DB)
    if [ "$list" == "" ]; then
        cd /tmp
        touch mailBox_mail_DB.txt
    fi
}

startInitView() {
    clear

    tput setaf 0
	tput cup 1 1
	for i in {1..50}
	do
		echo -n "-"
	done

	tput cup 2 1
	echo -n "|"
	tput cup 2 50
	echo -n "|"

	tput cup 3 1
    for i in {1..50}
    do
        echo -n "-"
	done
    tput cup 4 1
    for i in {1..50}
    do
        echo -n "-"
	done

	for i in {5..19}
	do
		tput cup $i 1
		echo -n "|"
		tput cup $i 50
		echo -n "|"
	done

    tput cup 20 1
    for i in {1..50}
    do
        echo -n "-"
	done
    
    tput setaf 7
	tput cup 2 22
	echo -n $title
}

mainInitView() {
    clear

    tput setaf 0
	tput cup 1 1
	for i in {1..50}
	do
		echo -n "-"
	done

	tput cup 2 1
	echo -n "|"
	tput cup 2 50
	echo -n "|"

	tput cup 3 1
    for i in {1..50}
    do
        echo -n "-"
	done
    
    tput cup 4 1
	echo -n "|"
	tput cup 4 50
	echo -n "|"

    tput cup 5 1
    for i in {1..50}
    do
        echo -n "-"
	done

	for i in {6..19}
	do
		tput cup $i 1
		echo -n "|"
		tput cup $i 50
		echo -n "|"
	done

    tput cup 20 1
    for i in {1..50}
    do
        echo -n "-"
	done
    
    tput setaf 7
	tput cup 2 20
	echo -n $title

    tput cup 4 3
    echo -n "user:$id"
}

mailInitView() {
    clear

    tput setaf 0
	tput cup 1 1
	for i in {1..50}
	do
		echo -n "-"
	done

    tput cup 3 1
	for i in {1..50}
	do
		echo -n "-"
	done

    tput cup 5 1
	for i in {1..50}
	do
		echo -n "-"
	done
}

startView() {
    tput cup 6 5
    echo -n "SIGN IN"
    tput cup 7 5
    echo -n "SIGN UP"
}

signInView() {
    tput cup 6 3
    echo -n "ID : "
    tput cup 7 3
    echo -n "PASSWORD : "
}

signUpView() {
    tput cup 6 3
    echo -n "ID : "
    tput cup 7 3
    echo -n "PASSWORD : "
    tput cup 8 3
    echo -n "PASSWORD CHECK : "
}

mainView() {
    tput cup 6 5
    echo -n "READ MAIL"
    tput cup 7 5
    echo -n "SEND MAIL"
    tput cup 8 5
    echo -n "SENDED"
    tput cup 9 5
    echo -n "SEARCH"
    tput cup 10 5
    echo -n "TRASH CAN"
    tput cup 11 5
    echo -n "EXIT"
}

readMail1View() {
    tput setaf 1
    tput cup 6 5
    echo -n "PREV"

    pos=7

    local index=0
    mail_index_list=()

    local flag=1
    local mail_list=($(cat $mail_db_path))
    local end=${#mail_list[*]}
    for ((i=0; i<2; i++))
    do
        while [ $index -ne $end ]
        do
            local receivers=${mail_list[$(($index+2))]}
            local trash=${mail_list[$(($index+8))]}

            local receiver=""
            for ((k=0; k<${#receivers}; k++))
            do
                if [ "${receivers:$k:1}" != "," ]; then
                    receiver+=${receivers:$k:1}
                else
                    if [ "$receiver" == "$id" ] && [ $trash -eq 0 ]; then
                        local important=${mail_list[$(($index+5))]}
                        local view=${mail_list[$(($index+7))]}

                        local sender=${mail_list[$(($index+1))]}
                        local date="${mail_list[$(($index+3))]} ${mail_list[$(($index+4))]}"

                        local title_count=${mail_list[$(($index+9))]}
                        local title=""
                        for ((j=0; j<$title_count; j++))
                        do
                            title+=${mail_list[$(($index+10+$j))]}
                            title+=" "
                        done

                        if [ $flag -eq 1 ]; then # important
                            if [ $important -eq 1 ]; then
                                mail_index_list+=($index)
                                
                                tput setaf 7
                                tput cup $pos 5
                                echo -n "["
                                tput setaf 1
                                tput cup $pos 6
                                echo -n "!"
                                tput setaf 7
                                tput cup $pos 7
                                echo -n "]"
                                
                                if [ $view -eq 0 ]; then
                                    tput setaf 2
                                fi

                                tput cup $pos 9
                                echo -n "$title - $sender"

                                tput setaf 7
                                tput cup $pos 25
                                echo -n $date

                                let pos=$pos+1
                            fi
                        else
                            if [ $important -eq 0 ]; then
                                mail_index_list+=($index)

                                if [ $view -eq 0 ]; then
                                    tput setaf 2
                                fi

                                tput cup $pos 5
                                echo -n "$title - $sender"

                                tput setaf 7
                                tput cup $pos 25
                                echo -n $date

                                let pos=$pos+1
                            fi
                        fi
                    fi

                    receiver=""
                fi
            done

            if [ $pos -eq 20 ]; then
                break
            fi
            
            let index=$index+${mail_list[$index]}+1
        done

        flag=0
        index=0
    done
}

readMail2View() {
    tput setaf 7
    tput cup 2 1
    echo -n "from. "
    tput cup 4 1
    echo -n "title: "
    tput cup 6 1
    echo -n "content: "
}

sendMail1View() {
    tput cup 6 3
    echo -n "WHO?"

    tput setaf 1
    tput cup 7 5
    echo -n "PREV"

    pos=8

    user_list=()

    tput setaf 7
    local list=($(cat $user_db_path))
    for ((i=0; i<${#list[*]}; i++))
    do
        if [ $((i%2)) -eq 0 ] && [ "${list[$i]}" != "$id" ]; then
            tput cup $pos 5
            echo -n ${list[$i]}

            user_list+=(${list[$i]})

            let pos=$pos+1
            
            if [ $pos -eq 20 ]; then
                break
            fi
        fi
    done
}

sendMail2View() {
    tput setaf 7
    tput cup 2 1
    echo -n "to. "
    tput cup 4 1
    echo -n "title: "
    tput cup 6 1
    echo -n "content: "
}

sendedView() {
    tput setaf 1
    tput cup 6 5
    echo -n "PREV"

    pos=7

    mail_index_list=()

    local index=0

    local mail_list=($(cat $mail_db_path))
    local end=${#mail_list[*]}
    while [ $index -ne $end ]
    do
        local trash=${mail_list[$(($index+8))]}
        local sender=${mail_list[$(($index+1))]}

        if [ "$sender" == "$id" ] && [ $trash -eq 0 ]; then
            local important=${mail_list[$(($index+5))]}
            local view=${mail_list[$(($index+7))]}

            local receiver=${mail_list[$(($index+2))]}
            local date="${mail_list[$(($index+3))]} ${mail_list[$(($index+4))]}"

            local title_count=${mail_list[$(($index+9))]}
            local title=""
            for ((j=0; j<$title_count; j++))
            do
                title+=${mail_list[$(($index+10+$j))]}
                title+=" "
            done

            if [ $important -eq 1 ]; then
                mail_index_list+=($index)
                
                tput setaf 7
                tput cup $pos 5
                echo -n "["
                tput setaf 1
                tput cup $pos 6
                echo -n "!"
                tput setaf 7
                tput cup $pos 7
                echo -n "]"
                
                if [ $view -eq 0 ]; then
                    tput setaf 2
                fi

                tput cup $pos 9
                echo -n "$title - $receiver"
            else
                mail_index_list+=($index)

                if [ $view -eq 0 ]; then
                    tput setaf 2
                fi

                tput cup $pos 5
                echo -n "$title - $receiver"
            fi

            tput setaf 7
            tput cup $pos 25
            echo -n $date

            let pos=$pos+1
        fi

        if [ $pos -eq 20 ]; then
            break
        fi
        
        let index=$index+${mail_list[$index]}+1
    done
}

trashView() {
    tput setaf 1
    tput cup 6 5
    echo -n "PREV"

    pos=7

    local index=0
    mail_index_list=()

    local flag=1
    local mail_list=($(cat $mail_db_path))
    local end=${#mail_list[*]}
    for ((i=0; i<2; i++))
    do
        while [ $index -ne $end ]
        do
            local receivers=${mail_list[$(($index+2))]}
            local trash=${mail_list[$(($index+8))]}

            local receiver=""
            for ((k=0; k<${#receivers}; k++))
            do
                if [ "${receivers:$k:1}" != "," ]; then
                    receiver+=${receivers:$k:1}
                else
                    if [ "$receiver" == "$id" ] && [ $trash -eq 1 ]; then
                        local important=${mail_list[$(($index+5))]}
                        local view=${mail_list[$(($index+7))]}

                        local sender=${mail_list[$(($index+1))]}
                        local date="${mail_list[$(($index+3))]} ${mail_list[$(($index+4))]}"

                        local title_count=${mail_list[$(($index+9))]}
                        local title=""
                        for ((j=0; j<$title_count; j++))
                        do
                            title+=${mail_list[$(($index+10+$j))]}
                            title+=" "
                        done

                        if [ $flag -eq 1 ]; then # important
                            if [ $important -eq 1 ]; then
                                mail_index_list+=($index)
                                
                                tput setaf 7
                                tput cup $pos 5
                                echo -n "["
                                tput setaf 1
                                tput cup $pos 6
                                echo -n "!"
                                tput setaf 7
                                tput cup $pos 7
                                echo -n "]"
                                
                                if [ $view -eq 0 ]; then
                                    tput setaf 2
                                fi

                                tput cup $pos 9
                                echo -n "$title - $sender"

                                tput setaf 7
                                tput cup $pos 25
                                echo -n $date

                                let pos=$pos+1
                            fi
                        else
                            if [ $important -eq 0 ]; then
                                mail_index_list+=($index)

                                if [ $view -eq 0 ]; then
                                    tput setaf 2
                                fi

                                tput cup $pos 5
                                echo -n "$title - $sender"

                                tput setaf 7
                                tput cup $pos 25
                                echo -n $date

                                let pos=$pos+1
                            fi
                        fi
                    fi

                    receiver=""
                fi
            done

            if [ $pos -eq 20 ]; then
                break
            fi
            
            let index=$index+${mail_list[$index]}+1
        done

        flag=0
        index=0
    done
}

singInInput() {
    while [ 0 -eq 0 ]
    do
        local str="ID : "
        let pos=3+${#str}+1
        tput cup 6 $pos

        read key

        id=$key

        str="PASSWORD : "
        let pos=3+${#str}+1
        tput cup 7 $pos

        read -s key

        local canSignIn=($(cat $user_db_path | grep "$id $key"))
        if [ ${#canSignIn[*]} -eq 2 ]; then
            return
        else
            tput cup 9 3
            echo -n "*sign in error*"

            str="ID : "
            let pos=3+${#str}+1
            tput cup 6 $pos
            for ((i=1; i<=${#id}; i++))
            do
                echo -n "　"
            done
        fi
    done
}

signUpInput() {
    local str="ID : "
    let pos=3+${#str}+1
    tput cup 6 $pos
    
    while [ 0 -eq 0 ]
    do
        read key
        
        local canUseId=$(cat $user_db_path | grep $key)
        if [ "$canUseId" == "" ]; then
            id=$key
            break
        else
            tput cup 6 $pos
            for ((i=1; i<=${#key}; i++))
            do
                echo -n " "
            done
            tput cup 6 $pos
        fi
    done
    
    str="PASSWORD : "
    let pos=3+${#str}+1
    tput cup 7 $pos

    read -s key

    str="PASSWORD CHECK : "
    let pos=3+${#str}+1
    tput cup 8 $pos

    local password=0
    while [ 0 -eq 0 ]
    do
        read -s key2
        
        if [ "$key" == "$key2" ]; then
            password=$key
            break
        else
            tput cup 8 $pos
            for ((i=1; i<=${#key2}; i++))
            do
                echo -n " "
            done
            tput cup 8 $pos
        fi
    done

    tput cup 10 20
    echo -n "*sign up?*"

    tput cup 11 19
    echo -n "yes"

    tput cup 11 28
    echo -n "no"

    pos=17

    tput cup 11 $pos
    echo -n ">"

    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $pos -eq 17 ]; then
                echo $id $password >> $user_db_path

                return 1
            elif [ $pos - eq 23 ]; then
                return 0
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "C" ]; then
            pos=23

            tput cup 11 $(($pos-6))
            echo -n " "
            tput cup 11 $pos
            echo -n ">"
        elif [ "$key" == "D" ]; then
            pos=17

            tput cup 11 $(($pos+6))
            echo -n " "
            tput cup 11 $pos
            echo -n ">"
        fi
    done
}

startInput() {
    pos=6

    tput cup $pos 3
    echo -n ">"

    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $pos -eq 6 ]; then
                startInitView
                signInView
                singInInput
                
                return 1
            elif [ $pos -eq 7 ]; then
                while [ 0 -eq 0 ]
                do
                    startInitView
                    signUpView
                    signUpInput
                    local result=$?
                
                    if [ $result -eq 1 ]; then
                        break
                    fi
                done

                return 0
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "A" ]; then
            pos=6

            tput cup $(($pos+1)) 3
            echo -n " "
            tput cup $pos 3
            echo -n ">"
        elif [ "$key" == "B" ]; then
            pos=7

            tput cup $(($pos-1)) 3
            echo -n " "
            tput cup $pos 3
            echo -n ">"
        fi
    done
}

trashInput() {

    pos=6
    local in_pos=-1

    tput cup $pos 3
    echo -n ">"

    local end=$(($pos+${#mail_index_list[*]}))

    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $in_pos -eq -1 ]; then # PREV
                return 1
            else
                mailInitView
                readMail2View
                readMail2Input ${mail_index_list[$in_pos]}
                return 0
            fi
        elif [ "$key" == "B" ] || [ "$key" == "b" ]; then
            local trash_index=$((${mail_index_list[$in_pos]}+8))

            local mail_list=($(cat $mail_db_path))
            mail_list[$trash_index]="0"

            echo ${mail_list[*]} > $mail_db_path

            return 0
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "A" ]; then
            if [ $pos -ne 6 ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos-1
                tput cup $pos 3
                echo -n ">"

                let in_pos=$in_pos-1
            fi
        elif [ "$key" == "B" ]; then
            if [ $pos -ne $end ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos+1
                tput cup $pos 3
                echo -n ">"
                
                let in_pos=$in_pos+1
            fi
        fi
    done
}

sendedInput() {
    pos=6
    local in_pos=-1

    tput cup $pos 3
    echo -n ">"

    local end=$(($pos+${#mail_index_list[*]}))

    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $in_pos -eq -1 ]; then # PREV
                return 1
            else
                mailInitView
                readMail2View
                readMail2Input ${mail_index_list[$in_pos]}

                return 0
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "A" ]; then
            if [ $pos -ne 6 ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos-1
                tput cup $pos 3
                echo -n ">"

                let in_pos=$in_pos-1
            fi
        elif [ "$key" == "B" ]; then
            if [ $pos -ne $end ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos+1
                tput cup $pos 3
                echo -n ">"
                
                let in_pos=$in_pos+1
            fi
        fi
    done
}

readMail2Input() { # mail_index
    local mail_list=($(cat $mail_db_path))
    
    local str="from. "
    let pos=${#str}+1
    tput cup 2 $pos
    echo -n ${mail_list[$(($1+1))]}

    local str="title: "
    let pos=${#str}+1
    tput cup 4 $pos

    local title_count=${mail_list[$(($1+9))]}
    local title=""
    for ((i=0; i<$title_count; i++))
    do
        title+=${mail_list[$(($1+10+$i))]}
        title+=" "
    done

    echo -n $title

    tput cup 7 1
    local content_count=${mail_list[$(($1+11+$title_count-1))]}
    for ((i=0; i<$content_count; i++))
    do
        echo -n ${mail_list[$(($1+12+$title_count-1+$i))]}
        echo -n " "
    done

    local existfile=${mail_list[$(($1+6))]}

    if [ "$existfile" != "0" ]; then
        echo " "
        echo " "
        echo -n " download file?[y/n] "

        while [ 0 -eq 0 ]
        do
            read -n 1 key
            if [ "$key" == "Y" ] || [ "$key" == "y" ]; then
                local filepath=${mail_list[$(($1+6))]}
                local filename=${filepath##/*/}
                cp $filepath ~/$filename
                return
            elif [ "$key" == "N" ] || [ "$key" == "n" ]; then
                return
            fi
        done
    else
        read -n 1 key
    fi
}

readMail1Input() {
    pos=6
    local in_pos=-1

    tput cup $pos 3
    echo -n ">"

    local end=$(($pos+${#mail_index_list[*]}))

    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $in_pos -eq -1 ]; then # PREV
                return 1
            else
                local view_index=$((${mail_index_list[$in_pos]}+7))
                
                local mail_list=($(cat $mail_db_path))
                mail_list[$view_index]="1"

                echo ${mail_list[*]} > $mail_db_path

                mailInitView
                readMail2View
                readMail2Input ${mail_index_list[$in_pos]}

                return 0
            fi
        elif [ "$key" == "D" ] || [ "$key" == "d" ]; then
            if [ $in_pos -ne -1 ]; then
                local trash_index=$((${mail_index_list[$in_pos]}+8))

                local mail_list=($(cat $mail_db_path))
                mail_list[$trash_index]="1"

                echo ${mail_list[*]} > $mail_db_path

                return 0
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "A" ]; then
            if [ $pos -ne 6 ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos-1
                tput cup $pos 3
                echo -n ">"

                let in_pos=$in_pos-1
            fi
        elif [ "$key" == "B" ]; then
            if [ $pos -ne $end ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos+1
                tput cup $pos 3
                echo -n ">"
                
                let in_pos=$in_pos+1
            fi
        fi
    done
}

sendMail2Input() { # receiver_list
    local str="to. "
    pos=$((${#str}+1))
    tput cup 2 $pos

    local receiver_list=(${!1})

    for ((i=0; i<${#receiver_list[*]}; i++))
    do
        echo -n ${receiver_list[$i]}
        echo -n ","
    done

    local str="title: "
    pos=$((${#str}+1))
    tput cup 4 $pos

    read key
    local title=($key)

    tput cup 7 1

    local content=""
    while [ 0 -eq 0 ]
    do
        read -n 1 key

        if [ "$key" == "" ]; then
            break
        elif [ "$key" == "" ]; then
            echo -n " "
            content+=" "
        else
            content+="$key"
        fi
    done

    local content_arr=()
    content_arr=($content)

    echo ""
    echo ""

    echo " 1. Regular mail"
    echo " 2. Important mail"
    echo " 3. with file"
    echo " 4. reset"
    echo " 5. exit"
    echo -n " send method?[1-5]: "

    read key

    local receivers=""
    for ((i=0; i<${#receiver_list[*]}; i++))
    do
        receivers+=${receiver_list[$i]}
        receivers+=","
    done

    local date=$(date '+%Y-%m-%d %H:%M:%S')

    if [ $key -eq 1 ]; then # Regular mail
        local str="$id $receivers $date 0 0 0 0 ${#title[*]} ${title[*]} ${#content_arr[*]} $content"
        local str_arr=($id $receivers $date 0 0 0 0 ${#title[*]} ${title[*]} ${#content_arr[*]} $content)
        echo "${#str_arr[*]} $str" >> $mail_db_path
        return 1
    elif [ $key -eq 2 ]; then # Important mail
        local str="$id $receivers $date 1 0 0 0 ${#title[*]} ${title[*]} ${#content_arr[*]} $content"
        local str_arr=($id $receivers $date 1 0 0 0 ${#title[*]} ${title[*]} ${#content_arr[*]} $content)
        echo "${#str_arr[*]} $str" >> $mail_db_path
        return 1
    elif [ $key -eq 3 ]; then # with file
        project1Start
        local filename=$project1ReturnFilename
        local str="$id $receivers $date 1 $filename 0 0 ${#title[*]} ${title[*]} ${#content[*]} $content"
        local str_arr=($id $receivers $date 1 $filename 0 0 ${#title[*]} ${title[*]} ${#content[*]} $content)
        echo "${#str_arr[*]} $str" >> $mail_db_path
        return 1
    elif [ $key -eq 4 ]; then # reset
        return 0
    else # exit
        return 1
    fi
}

sendMail1Input() { 
    pos=7
    local in_pos=-1

    tput cup $pos 3
    echo -n ">"

    local end=$(($pos+${#user_list[*]}))
    local receiver_list=()
    local receiver_index_list=()
    local flag=0
    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $in_pos -eq -1 ]; then # PREV
                return
            else
                flag=1

                for ((i=0; i<${#receiver_index_list[*]}; i++))
                do
                    if [ "${receiver_index_list[$i]}" == "$in_pos" ]; then
                        flag=0

                        break
                    fi
                done

                if [ $flag -eq 1 ]; then
                    receiver_list+=(${user_list[$in_pos]})
                fi
                
                while [ 0 -eq 0 ]
                do
                    mailInitView
                    sendMail2View
                    sendMail2Input receiver_list[@]
                    local result=$?
                    if [ $result == 1 ]; then
                        break
                    fi
                done
                return
            fi
        elif [ "$key" == "S" ] || [ "$key" == "s" ]; then
            if [ $in_pos -ge 0 ]; then
                flag=1

                for ((i=0; i<${#receiver_index_list[*]}; i++))
                do
                    if [ "${receiver_index_list[$i]}" == "$in_pos" ]; then
                        local col=$((3+1+${#user_list[$in_pos]}+1))
                        tput cup $pos $col
                        echo -n "　"

                        receiver_list[$i]=""
                        receiver_index_list[$i]=""
                        flag=0

                        break
                    fi
                done

                if [ $flag -eq 1 ]; then
                    receiver_list+=(${user_list[$in_pos]})
                    receiver_index_list+=($in_pos)

                    local col=$((3+1+${#user_list[$in_pos]}+1))
                    tput cup $pos $col
                    tput setaf 1
                    echo -n "*"

                    tput setaf 7
                fi
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "A" ]; then
            if [ $pos -ne 7 ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos-1
                tput cup $pos 3
                echo -n ">"

                let in_pos=$in_pos-1
            fi
        elif [ "$key" == "B" ]; then
            if [ $pos -ne $end ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos+1
                tput cup $pos 3
                echo -n ">"

                let in_pos=$in_pos+1
            fi
        fi
    done
}

mainInput() {
    pos=6

    tput cup $pos 3
    echo -n ">"

    local result=""
    local result_arr=()
    while [ 0 -eq 0 ]
    do
        read -n 1 -s key
        if [ "$key" == "" ]; then
            mainInitView
                
            if [ $pos -eq 6 ]; then # READ MAIL
                while [ 0 -eq 0 ]
                do
                    mainInitView
                    readMail1View
                    readMail1Input
                    result=$?

                    if [ $result -eq 1 ]; then
                        break
                    fi
                done

                return 0  
            elif [ $pos -eq 7 ]; then # SEND MAIL
                sendMail1View
                result=$?
                sendMail1Input $result

                return 0
            elif [ $pos -eq 8 ]; then # SENDED
                while [ 0 -eq 0 ]
                do
                    mainInitView
                    sendedView
                    sendedInput
                    result=$?

                    if [ $result -eq 1 ]; then
                        break
                    fi
                done

                return 0
            elif [ $pos -eq 9 ]; then # SEARCH
                return 0
            elif [ $pos -eq 10 ]; then # TRASH CAN
                while [ 0 -eq 0 ]
                do
                    mainInitView
                    trashView
                    trashInput
                    result=$?

                    if [ $result -eq 1 ]; then
                        break
                    fi
                done

                return 0
            elif [ $pos -eq 11 ]; then # EXIT
                clear

                return 1
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ "$key" == "A" ]; then
            if [ $pos -ne 6 ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos-1
                tput cup $pos 3
                echo -n ">"
            fi
        elif [ "$key" == "B" ]; then
            if [ $pos -ne 11 ]; then
                tput cup $pos 3
                echo -n " "

                let pos=$pos+1
                tput cup $pos 3
                echo -n ">"
            fi
        fi
    done
}

project2Main() {
    project2Init

    local result=""

    while [ 0 -eq 0 ]
    do
        startInitView
        startView
        startInput
        result=$?

        if [ $result -eq 1 ]; then
            break
        fi
    done

    while [ 0 -eq 0 ]
    do
        mainInitView
        mainView
        mainInput
        result=$?

        if [ $result -eq 1 ]; then
            break
        fi
    done
}

# PROJECT 1

current_path=""
path_list=()
project1Init() {
	tput setab 6
    tput setaf 7
	tput cup 1 1
	local title="File Explorer"
	echo -n $title
	for ((i=${#title}+1; i<=83; i++))
	do
		echo -n " "
	done

	tput setab 3
	tput cup 2 1
	for i in {1..83}
	do
		echo -n "-"
	done

	tput cup 3 1
	echo "|"
	tput cup 3 83
	echo -n "|"

	tput cup 4 1
        for i in {1..83}
        do
                echo -n "-"
	done

	tput cup 5 1
	for i in {0..19}
	do
		let row=i+5
		tput cup $row 1
		echo "|"
		tput cup $row 42
		echo -n "|"
		tput cup $row 83
		echo -n "|"
	done

	tput cup 25 1
    for i in {1..83}
    do
            echo -n "-"
    done

    tput cup 26 1
    echo "|"
    tput cup 26 83
    echo -n "|"

    tput cup 27 1
    for i in {1..83}
    do
            echo -n "-"
    done
}

currentPath() {
    tput setaf 7
	tput cup 3 2
	local pos=2
	local str="Current path:"
	echo -n $str

	let pos=$pos+${#str}
	tput cup 3 $pos

    current_path=$(pwd)
    path_list+=("$current_path") # .
	echo -n $current_path

	let pos=$pos+${#current_path}
	for ((i=$pos; i<=82; i++))
	do
		echo -n " "
	done

    tput setaf 4
	tput cup 5 43
	local foldername=${current_path##/*/}
    path_list+=("${current_path:0:$((${#current_path}-${#foldername}-1))}") # ..
	echo -n $foldername

    right_list+=("$foldername")
    right_flag+="0"

	let pos=43+${#foldername}
    if [ ${#right_pos_list[*]} -ne 26 ]; then
        right_pos_list+=($(($pos+1)))
    fi

	for ((i=$pos; i<=82; i++))
	do
		echo -n " "
	done
}

left_list=()
left_flag=()
left_print() {
    local tmp=""
	local pos=2
	local filename=$1

    if [ ${#filename} -gt 19 ]; then
        filename="${filename:0:19}"
    fi

	echo -n $filename

    tmp="$filename "
	pos=$pos+${#filename}
	for ((i=$pos; i<=20; i++))
	do
		echo -n " "
	done

	local info=$2
	echo -n $info
    tmp="$tmp$info "
	pos=20+${#info}
	for ((i=$pos; i<=33; i++))
	do
		echo -n " "
	done

	local filesize=$3
	echo -n $filesize
	pos=33+${#filesize}
    tmp="$tmp$filesize"
	for ((i=$pos; i<=39; i++))
	do
		echo -n " "
	done
    
    if [ ${#left_list[*]} -ne 21 ]; then
        left_list+=("$tmp")
    fi
}

right_pos_list=()
right_row=6
right_print() { #$flag $name $filepath $tmp_count $count $tree $color
	if [ $right_row -ne 25 ]; then
		if [ $4 -ne $5 ]; then
			local tree_end="$6├─"
		else
			local tree_end="$6└─"
		fi
        
		tput cup $right_row 43
        tput setaf 0
		echo -n "$tree_end"

        local filename=$2
        local print="$tree_end$filename"
        if [ ${#print} -gt 39 ]; then
            filename="${filename:0:$((39-${#tree_end}+1))}"
        fi
        tput setaf $7
		echo -n "$filename"

        local pos=43+${#print}
        if [ ${#right_pos_list[*]} -ne 26 ]; then
            right_pos_list+=($(($pos+1)))
        fi
    	
        for ((i=$pos; i<=82; i++))
        do
            echo -n " "
        done

		let right_row=$right_row+1

		if [ $1 -eq 0 ]; then
			local list=$(ls -alhR)
			list=(${list#*$3:})
            
			if [ ${#list[*]} -gt 3 ]; then
				local info=${list[2]}
				if [ "${info:0:1}" != "." ]; then
					local sub_count=0
					local index=20
					while [ $index -lt ${#list[*]} ]
					do
						info=${list[$index]}
						if [ "${info:0:1}" != "." ]; then
							let sub_count=$sub_count+1
							let index=$index+9
						else
							break
						fi
					done
                    
                    index=20
					local start=1
					local end=$(($sub_count+1))
					local current=$start
					local sub_tmp_count=0
					local flag=0
                    local color=0
					while [ $right_row -ne 25 ]
					do
						if [ $flag -eq 0 ]; then
                            color=4
							infoarr=${list[$index]}
							if [ "${infoarr:0:1}" == "d" ]; then
                                let sub_tmp_count=$sub_tmp_count+1

                                info=${list[$index]}
                                name=${list[$(($index+8))]}

                                if [ $4 -ne $5 ]; then
                                    tree_end="$6│ "
                                else
                                    tree_end="$6  "
                                fi

                                filepath="$3/$name"
                                right_print $flag $name $filepath $sub_tmp_count $sub_count "$tree_end" $color
                            fi
                        elif [ $flag -eq 1 ]; then
                            color=2
                            infoarr=(${list[$index]})
                            if [ "${infoarr:0:1}" != "d" -a "${infoarr:3:1}" == "x" ]; then
                                let sub_tmp_count=$sub_tmp_count+1

                                info=${list[$index]}
                                name=${list[$(($index+8))]}

                                if [ $4 -ne $5 ]; then
                                    tree_end="$6│ "
                                else
                                    tree_end="$6  "
                                fi

                                filepath="$3/$name"
                                right_print $flag $name $filepath $sub_tmp_count $sub_count "$tree_end" $color
                            fi
                        elif [ $flag -eq 2 ]; then
                            color=0
                            infoarr=(${list[$index]})
                            if [ "${infoarr:0:1}" != "d" -a "${infoarr:3:1}" != "x" ]; then
                                let sub_tmp_count=$sub_tmp_count+1

                                info=${list[$index]}
                                name=${list[$(($index+8))]}

                                if [ $4 -ne $5 ]; then
                                    tree_end="$6│ "
                                else
                                    tree_end="$6  "
                                fi

                                filepath="$3/$name"
                                right_print $flag $name $filepath $sub_tmp_count $sub_count "$tree_end" $color
                            fi
                        fi

                        let index=$index+9
                        
                        if [ $sub_tmp_count -eq $sub_count ]; then
                            break
                        fi

                        let current=$current+1
                        if [ $current -eq $end ]; then
                            if [ $flag -eq 2 ]; then
                                break
                            fi
                            
                            let flag=$flag+1
                            current=$start
                            index=20
                        fi
					done
				fi			
			fi
		fi
	fi
}

list() {
    local directory=0
    local file=0

	local path="."
	local list=($(ls -alh))
    local currentsize=${list[1]}

	local currentfinfo=${list[2]}
	local beforefinfo=${list[11]}

    tput setaf 4
	tput cup 5 2
	left_print "." $currentfinfo "-"
    left_flag[0]=0
	tput cup 6 2
	left_print ".." $beforefinfo "-"
    left_flag[1]=0
    local flag_index=1

	local start=3
	local tmp=($(ls -a))
	let local end=${#tmp[*]}+1
	let local count=$end-$start

    
    local row=7
    local current=$start
    local tmp_count=0
    local index=11
    local flag=0 # 0=directory, 1=execution, 2=normal
    local color=0
    if [ $count -ne 0 ]; then
        while [ $row -ne 25 ]
        do
            tput cup $row 2
            let index=$index+9
            if [ $flag -eq 0 ]; then
                tput setaf 4
                color=4
                local infoarr=${list[$index]}
                if [ "${infoarr:0:1}" == "d" ]; then
                    let directory=$directory+1
                    let tmp_count=$tmp_count+1

                    let flag_index=$flag_index+1
                    left_flag[$flag_index]=0

                    info=${list[$index]}
                    size=${list[$(($index+4))]}
                    name=${list[$(($index+8))]}

                    local tmp_path="${path_list[0]}/${list[$(($index+8))]}"
                    path_list+=("$tmp_path")

                    let row=$row+1
                    left_print $name $info $size

                    filepath="$path/$name"
                    right_print $flag $name $filepath $tmp_count $count "" $color
                fi
            elif [ $flag -eq 1 ]; then
                tput setaf 2
                color=2
                infoarr=(${list[$index]})
                if [ "${infoarr:0:1}" != "d" -a "${infoarr:3:1}" == "x" ]; then
                    let file=$file+1
                    let tmp_count=$tmp_count+1

                    let flag_index=$flag_index+1
                    left_flag[$flag_index]=1

                    info=${list[$index]}
                    size=${list[$(($index+4))]}
                    name=${list[$(($index+8))]}

                    let row=$row+1
                    left_print $name $info $size

                    filepath="$path/$name"
                    right_print $flag $name $filepath $tmp_count $count "" $color
                fi
            elif [ $flag -eq 2 ]; then
                tput setaf 0
                color=0
                infoarr=(${list[$index]})
                if [ "${infoarr:0:1}" != "d" -a "${infoarr:3:1}" != "x" ]; then
                    let file=$file+1
                    let tmp_count=$tmp_count+1

                    let flag_index=$flag_index+1
                    left_flag[$flag_index]=2

                    info=${list[$index]}
                    size=${list[$(($index+4))]}
                    name=${list[$(($index+8))]}

                    let row=$row+1
                    left_print $name $info $size

                    filepath="$path/$name"
                    right_print $flag $name $filepath $tmp_count $count "" $color
                fi
            fi

            if [ $tmp_count -eq $count ]; then
                break
            fi

            let current=$current+1
            if [ $current -eq $end ]; then
                if [ $flag -eq 2 ]; then
                    break
                fi
                
                let flag=$flag+1
                current=$start
                index=11
            fi
        done    
    fi

    while [ $row -ne 25 ]
    do
        tput cup $row 2
        for ((i=2; i<=41; i++))
        do
            echo -n " "
        done
        let row=$row+1
    done

    while [ $right_row -ne 25 ]
    do
        tput cup $right_row 43
        for ((i=43; i<=82; i++))
        do
            echo -n " "
        done
        let right_row=$right_row+1
    done

    tput setaf 7
    tput cup 26 2
	pos=2
	str="Directory: $directory"
	for ((i=$pos; i<=5; i++))
	do
		echo -n " "
	done
    echo -n "$str"

	let pos=5+${#str}
    str="File: $file"
	for ((i=$pos; i<=25; i++))
	do
		echo -n " "
	done
    echo -n "$str"
    
    let pos=25+${#str}
    str="Current Directory Size: $currentsize"
	for ((i=$pos; i<=45; i++))
	do
		echo -n " "
	done
    echo -n "$str"

	let pos=45+${#str}
	for ((i=$pos; i<=79; i++))
	do
		echo -n " "
	done
}

input_row=0
input() {
    input_row=5
    tput cup $input_row 2
    tput setab 4
    tput setaf 3
    local left_str=(${left_list[0]})
    left_print ${left_str[0]} ${left_str[1]} ${left_str[2]}

    tput cup $input_row 2
    local left_index=0
    local right_index=0
    local before_left_flag=0
    local domain=0 # 0=left, 1=right
    local left_list_end=$((${#left_list[*]}-2))
    local right_list_end=$((${#right_pos_list[*]}-1))
    local path_list_end=$((${#path_list[*]}-1))

    while [ 0 -eq 0 ]
    do
        tput sgr 0

        read -n 1 -s key
        if [ "$key" == "" ]; then
            if [ $domain -eq 0 ]; then
                if [ $left_index -le $path_list_end ]; then
                    local next_path=${path_list[$left_index]}
                    cd "$next_path"
                    
                    path_list=()
                    left_list=()
                    left_flag=()
                    right_pos_list=()
                    right_row=6
                    input_row=0

                    new_main
                    return
                # NEW
                else
                    left_str=(${left_list[$left_index]})
                    project1ReturnFilename=$current_path/${left_str[0]}
                    return
                fi
                # NEW
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        if [ $domain -eq 0 ]; then
            tput cup $input_row 2
            if [ "$before_left_flag" == "0" ]; then
                tput setab 3
                tput setaf 4
            elif [ "$before_left_flag" == "1" ]; then
                tput setab 3
                tput setaf 2
            elif [ "$before_left_flag" == "2" ]; then
                tput setab 3
                tput setaf 0
            fi

            left_print ${left_str[0]} ${left_str[1]} ${left_str[2]}
        elif [ $domain -eq 1 ]; then
            tput cup $input_row ${right_pos_list[$right_index]}

            echo -n "   "
        fi

        if [ "$key" == "A" ]; then
            if [ $domain -eq 0 -a $left_index -gt 0 ]; then
                let input_row=$input_row-1
                let left_index=$left_index-1
            elif [ $domain -eq 1 -a $right_index -gt 0 ]; then
                let input_row=$input_row-1
                let right_index=$right_index-1
            fi
        elif [ "$key" == "B" ]; then
            if [ $domain -eq 0 -a $left_index -lt $left_list_end ]; then
                let input_row=$input_row+1
                let left_index=$left_index+1
            elif [ $domain -eq 1 -a $right_index -lt $right_list_end ]; then
                let input_row=$input_row+1
                let right_index=$right_index+1
            fi
        elif [ "$key" == "C" ]; then
            if [ $domain -ne 1 ]; then
                domain=1
                input_row=5
                right_index=0
            fi
        elif [ "$key" == "D" ]; then
            if [ $domain -ne 0 ]; then
                domain=0
                input_row=5
                left_index=0
            fi
        fi
        
        if [ $domain -eq 0 ]; then
            tput cup $input_row 2
            if [ "${left_flag[$left_index]}" == "0" ]; then
                tput setab 4
                tput setaf 3
                before_left_flag=0
            elif [ "${left_flag[$left_index]}" == "1" ]; then
                tput setab 2
                tput setaf 3
                before_left_flag=1
            elif [ "${left_flag[$left_index]}" == "2" ]; then
                tput setab 0
                tput setaf 3
                before_left_flag=2
            fi
            
            left_str=(${left_list[$left_index]})
            left_print ${left_str[0]} ${left_str[1]} ${left_str[2]}
            tput cup $input_row 2
        elif [ $domain -eq 1 ]; then
            tput cup $input_row ${right_pos_list[$right_index]}
            tput setaf 1

            echo -n "<-"
            tput cup $input_row 43
        fi
    done
}

project1Main() {
    project1Init
    tput setab 3
    currentPath
    list

    tput cup 28 0
}
new_main() {
    project1Main
    input

    tput cup 28 0
}

project1Start() {
    project1Main
    input
}

project2Main