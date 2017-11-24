Njob=1000    # 作业数目
Nproc=5    # 可同时运行的最大作业数

function CMD {        # 测试命令, 随机等待几秒钟
	n=$((RANDOM % 5 + 11))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
}
function PushQue {    # 将PID压入队列
	Que="$Que $1"
	Nrun=$(($Nrun+1))
}

function ChkQue {     # 检查队列
	OldQue=$Que
	for PID in $OldQue; do
		if [[ ! -d /proc/$PID ]] ; then
			echo "ChkQue判断：$(! -d /proc/$PID)"
			GenQue; break
		fi
	done
}

function GenQue {     # 更新队列
	OldQue=$Que
	Que=""; Nrun=0
	for PID in $OldQue; do
		if [[ -d /proc/$PID ]]; then
			echo "-----------------------------------"
			PushQue $PID
		fi
	done
	echo "GenOldQue_que:$OldQue"
	echo "GenQue_que:$Que"
}

for((i=1; i<=$Njob; i++)); do
	CMD $i &
	PID=$!
	PushQue $PID
	while [[ $Nrun -ge $Nproc ]]; do
		ChkQue
		sleep 1
	done
done
wait