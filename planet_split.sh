#/bin/bash
#link  #https://jerkwin.github.io/2013/12/14/Bash%E8%84%9A%E6%9C%AC%E5%AE%9E%E7%8E%B0%E6%89%B9%E9%87%8F%E4%BD%9C%E4%B8%9A%E5%B9%B6%E8%A1%8C%E5%8C%96/

Njob=4    # jobs num
Nproc=3    # max jobs num

# long time data process
function Split {        
	echo "Split=================="
	echo "mm-arg1:$1"
	echo "nn-arg2:$2"


	n=$((RANDOM % 5 + 110))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
    wait
}

function CMD {        # test cmd, wait for several seconds
	n=$((RANDOM % 5 + 3))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
}
function PushQue {    # 将PID压入队列
	Que="$Que $1"
	Nrun=$(($Nrun+1))
}
function GenQue {     # 更新队列
	OldQue=$Que
	Que=""; Nrun=0
	for PID in $OldQue; do
		if [[ -d /proc/$PID ]]; then
			PushQue $PID
		fi
	done
}
function ChkQue {     # 检查队列
	OldQue=$Que
	for PID in $OldQue; do
		if [[ ! -d /proc/$PID ]] ; then
			GenQue; break
		fi
	done
}




BORDER_PATH="/Users/zhenhuihu/Documents/gullmap_offline/gullmap_mobile/data/borders"
index=0
#echo $(ls $BORDER_PATH | grep '\.poly')
for file in "$BORDER_PATH"/*.poly; do
	echo "process file ->>>> file[:'$file']"
	Split "'$file'" $i &
	PID=$!
	
	PushQue $PID
	while [[ $Nrun -ge $Nproc ]]; do
		ChkQue
		sleep 1
	done 

	((i++)) 
done
wait

# for((i=1; i<=$Njob; i++)); do
# 	CMD $i &
# 	PID=$!
# 	PushQue $PID
# 	while [[ $Nrun -ge $Nproc ]]; do
# 		ChkQue
# 		sleep 1
# 	done
# done
# wait
