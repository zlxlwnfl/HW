current_path=""
path_list=()
mainname=""

c_count=0
h_count=0

init() {
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
}

count_print() {
    tput setaf 7
    tput cup 26 2
	pos=2
	str="C file: $c_count"
	for ((i=$pos; i<=5; i++))
	do
		echo -n " "
	done
    echo -n "$str"

	let pos=5+${#str}
    str="Header: $h_count"
	for ((i=$pos; i<=25; i++))
	do
		echo -n " "
	done
    echo -n "$str"
    
    let pos=25+${#str}
	for ((i=$pos; i<=80; i++))
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

right_print() { #filename
    local filename=$1

    if [ ${#filename} -gt 38 ]; then
        filename="${filename:0:38}"
    fi

	echo -n $filename

	local pos=$((42+${#filename}))
	for ((i=$pos; i<82; i++))
	do
		echo -n " "
	done
}

right_list=()
right_sorted_list=()
right_flag=()
right_sorted_flag=()
right_row=5
right_list_print() {    
	tput setab 3

    if [ ${#right_list[*]} -eq 0 ]; then
        while [ $right_row -ne 25 ]
        do
            tput cup $right_row 43
            for ((i=43; i<=82; i++))
            do
                echo -n " "
            done
            let right_row=$right_row+1
        done

        return
    fi
    
    local row=5
    local tmp_count=0
	local count=$((${#right_list[*]}+1))
    local index=0
    local end=$(($count-1))
    local flag=0 # 0=main, 1=c, 2=h
    while [ $row -ne 25 ]
    do
        tput cup $row 43

        if [ $flag -eq 0 ]; then
            tput setaf 1
            local filename=${right_list[$index]}                

            if [ "$mainname" == "" ]; then
                local str="int main()"
                local isMain=$(cat $filename | grep "$str")

                if [ "$isMain" != "" ]; then
                    mainname=$filename
                fi
            fi

            if [ "$mainname" == "$filename" ]; then
                right_print $filename

                right_sorted_flag[$tmp_count]=0
                right_sorted_list[$tmp_count]=$filename

                let tmp_count=$tmp_count+1
                let row=$row+1
            fi
        elif [ $flag -eq 1 -a "${right_flag[$index]}" == "1" ]; then
            tput setaf 2
            local filename=${right_list[$index]}  

            if [ "$mainname" != "$filename" ]; then            
                right_print $filename

                right_sorted_flag[$tmp_count]=1
                right_sorted_list[$tmp_count]=$filename

                let tmp_count=$tmp_count+1
                let row=$row+1
            fi
        elif [ $flag -eq 2 -a "${right_flag[$index]}" == "2" ]; then
            tput setaf 0
            local filename=${right_list[$index]}    
                    
            right_print $filename

            right_sorted_flag[$tmp_count]=2
            right_sorted_list[$tmp_count]=$filename

            let tmp_count=$tmp_count+1
            let row=$row+1
        fi

        if [ $tmp_count -eq $count ]; then
            break
        fi

        let index=$index+1
        if [ $index -ge $end ]; then
            if [ $flag -eq 2 ]; then
                break
            fi
            
            let flag=$flag+1
            index=0
        fi
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
}

list() {
	local path="."
	local list=($(ls -alh))

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
    local flag=0 # 0=directory, 1=c, 2=h
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
                fi
            elif [ $flag -eq 1 ]; then
                tput setaf 2
                color=2
                infoarr=(${list[$index]})
                name=${list[$(($index+8))]}
                if [ "${infoarr:0:1}" != "d" -a "${name:$((${#name}-2)):2}" == ".c" ]; then
                    let c_count=$c_count+1
                    let tmp_count=$tmp_count+1

                    let flag_index=$flag_index+1
                    left_flag[$flag_index]=1

                    info=${list[$index]}
                    size=${list[$(($index+4))]}

                    let row=$row+1
                    left_print $name $info $size
                fi
            elif [ $flag -eq 2 ]; then
                tput setaf 0
                color=0
                infoarr=(${list[$index]})
                name=${list[$(($index+8))]}
                if [ "${infoarr:0:1}" != "d" -a "${name:$((${#name}-2)):2}" == ".h" ]; then
                    let h_count=$h_count+1
                    let tmp_count=$tmp_count+1

                    let flag_index=$flag_index+1
                    left_flag[$flag_index]=2

                    info=${list[$index]}
                    size=${list[$(($index+4))]}

                    let row=$row+1
                    left_print $name $info $size
                fi
            fi

            if [ $tmp_count -eq $(($count+1)) ]; then
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

    right_list_print
    count_print
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
    local before_right_flag=0
    local domain=0 # 0=left, 1=right
    local left_list_end=$((${#left_list[*]}-2))
    local right_list_end=0
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
                    
                    c_count=0
                    h_count=0
                    path_list=()
                    left_list=()
                    left_flag=()
                    right_row=5
                    input_row=0

                    new_main
                else
                    left_str=(${left_list[$left_index]})

                    local flag="false"
                    local right_index=0
                    local right_end=${#right_list[*]}

                    while [ $right_index -ne $right_end ]
                    do
                        if [ "${right_list[$right_index]}" == "${left_str[0]}" ]; then
                            flag="true"
                            break
                        fi

                        let right_index=$right_index+1
                    done

                    if [ "$flag" == "false" ]; then
                        right_list+=("${left_str[0]}")
                        right_flag+=(${left_flag[$left_index]})

                        right_list_print

                        right_list_end=$((${#right_list[*]}-1))
                    fi
                fi
            fi
        elif [ "$key" == "M" ] || [ "$key" == "m" ]; then
            if [ "$mainname" != "" ]; then
                local source=""
                local c_names=()

                for ((i=0; i<${#right_list[*]}; i++))
                do
                    if [ "${right_flag[$i]}" == "1" ]; then
                        local filename=${right_list[$i]}
                        c_names+=("${filename%.*}")
                    fi
                done

                source+="2014906050.out : "
                for ((i=0; i<${#c_names[*]}; i++))
                do
                    source+="${c_names[$i]}.o "
                done
                source+="\n\tgcc -o 2014906050.out "
                for ((i=0; i<${#c_names[*]}; i++))
                do
                    source+="${c_names[$i]}.o "
                done
                source+="\n\trm "
                for ((i=0; i<${#c_names[*]}; i++))
                do
                    source+="${c_names[$i]}.o "
                done

                source+="\n\n"

                for ((i=0; i<${#c_names[*]}; i++))
                do
                    source+="${c_names[$i]}.o : ${c_names[$i]}.c"
                    source+="\n\t"
                    source+="gcc -c -o ${c_names[$i]}.o ${c_names[$i]}.c"
                    source+="\n\n"
                done

                echo -e $source > Makefile
                
                clear
                exit
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
            if [ "$before_right_flag" == "0" ]; then
                tput setab 3
                tput setaf 1
            elif [ "$before_right_flag" == "1" ]; then
                tput setab 3
                tput setaf 2
            elif [ "$before_right_flag" == "2" ]; then
                tput setab 3
                tput setaf 0
            fi
            
            local filename=${right_sorted_list[$right_index]}    
            
            right_print $filename
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
            tput cup $input_row 43
            if [ "${right_sorted_flag[$right_index]}" == "0" ]; then
                tput setab 1
                tput setaf 3
                before_right_flag=0
            elif [ "${right_sorted_flag[$right_index]}" == "1" ]; then
                tput setab 2
                tput setaf 3
                before_right_flag=1
            elif [ "${right_sorted_flag[$right_index]}" == "2" ]; then
                tput setab 0
                tput setaf 3
                before_right_flag=2
            fi
            
            local filename=${right_sorted_list[$right_index]}
            
            right_print $filename
            tput cup $input_row 43
        fi
    done
}

main() {
    init
    currentPath
    list
}
new_main() {
    clear
    main
    input
}

cd ~
clear
main
input