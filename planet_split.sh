#bin/bash
#link  #https://jerkwin.github.io/2013/12/14/Bash%E8%84%9A%E6%9C%AC%E5%AE%9E%E7%8E%B0%E6%89%B9%E9%87%8F%E4%BD%9C%E4%B8%9A%E5%B9%B6%E8%A1%8C%E5%8C%96/

Njob=1000    # jobs num
Nproc=8   # max jobs num

# long time data process
function Split {        
	echo "Split=================="
	echo "kk-arg0:$0"
	echo "mm-arg1:$1"
	echo "nn-arg2:$2"
	echo "ll-arg3&:$3"

	n=$((RANDOM % 5 + 2))
	echo "Job $2 Ijob $3 sleeping for $n seconds ..."
	sleep $n
        ./osmconvert $PLANET  -B=$1 -o="$(basename $1).pbf"
        echo "Job $2 Ijob $3 exiting ..."
}

function CMD {        
	n=$((RANDOM % 5 + 1))
	echo "Job $1 Ijob $2 sleeping for $n seconds ..."
	sleep $n
	echo "Job $1 Ijob $2 exiting ..."
}

function PushQue {    
	Que="$Que $1"
	echo "Que:" $Que
	Nrun=$(($Nrun+1))
	echo "Nrun:" $Nrun
}

#todo : /proc/$PID   just for linux 
# MacOS has problem
function ChkQue {     
	OldQue=$Que
	echo "OldQue:$OldQue">>"logs/que.log"
	for PID in $OldQue; do
		echo "OldQue pid：:$PID"
		if [[ ! -d /proc/$PID ]] ; then
			echo "not valid pid：:$PID"

			OldQue=$Que
			Que=""; Nrun=0
			for PID in $OldQue; do
				if [[ -d /proc/$PID ]]; then
					PushQue $PID
				fi
			done
			echo "Que:$Que">>"logs/que.log"	 

			break
		fi
	done
}


BORDER_PATH="$BORDER_PATH"
i=0
#log path
mkdir -p "logs"
for file in "$BORDER_PATH"/*.poly; do
	echo "process file ->>>> file[:'$file']\n">>"logs/file.log"
	Split "$file" $i &
	PID=$!
	((i++))
	PushQue $PID
    ((index++))
	while [[ $Nrun -ge $Nproc ]]; do
		ChkQue
		sleep 1
	done
done
wait



















# for((i=1; i<=$Njob; i++)); do
# 	# CMD $i &
# 	Split "'$file'" $i &
# 	PID=$!

# 	echo "i:$i"
# 	echo "&:$&"
# 	echo "PID:$PID"
# 	echo "Njob:$Njob"

# 	PushQue $PID
# 	while [[ $Nrun -ge $Nproc ]]; do
# 		ChkQue
# 		sleep 1
# 	done
# done
# wait


# index=0
# BORDER_PATH="/data/borders"

# for file in "$BORDER_PATH"/*.poly; do
# 	echo "process file ->>>> file[:'$file']"
# 	# Split "'$file'" $index &
# 	CMD $index &
# 	PID=$!

# 	echo "'$index:'$index"
# 	echo "PID:$PID"

# 	PushQue $PID
# 	# ((index++))
# 	while [[ $Nrun -ge $Nproc ]]; do
# 		ChkQue
# 		sleep 1
# 	done 	 
# done
# wait

