path_list=()
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

    local path=$(pwd)
    path_list+=("$path") # .
	echo -n $path

	let pos=$pos+${#path}
	for ((i=$pos; i<=82; i++))
	do
		echo -n " "
	done

    tput setaf 4
	tput cup 5 43
	local foldername=${path##/*/}
    path_list+=("${path:0:$((${#path}-${#foldername}-1))}") # ..
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
                fi
            fi
        else
            read -n 1 -s key
            read -n 1 -s key
        fi

        main

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

main() {
    init
    tput setab 3
    currentPath
    list

    tput cup 28 0
}
new_main() {
    main
    input

    tput cup 28 0
}

main
input
tput sgr 0

tput cup 28 0