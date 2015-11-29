
vessels=("127.0.0.1" "63100" "127.0.0.1" "63101")
sent_entries=${#vessels[*]}
nr_of_vessels=$(expr $sent_entries / 2)

for i in ${!vessels[*]}; do
  if [[ i%2 -eq 0 ]]; then
		address="${vessels[$i]}:${vessels[$i+1]}"
		echo $address
		i2=$(($i + 1))
		curl -d comment="test$i" $address --silent &
		curl -d comment="test$i2" $address --silent &
	fi
done

start_time=$(date +%s%N | cut -b1-13)
var=0
complete_prop=0
while [[ $var -eq 0 ]]; do
	for i in ${!vessels[*]}; do
  	if [[ i%2 -eq 0 ]]; then
			address="${vessels[$i]}:${vessels[$i+1]}"
			echo $address
			CURL=$(curl --request GET $address --silent)
			CURLSUB1=$(echo $CURL | sed 's/.*<div class="entry">//')
			CURLSUB2=$(echo $CURLSUB1 | awk '{split($1, a, "</div>"); print a[1]}')
			echo $CURLSUB2
	
			NUMBER_OF_ENTRIES=$(grep -o "<br>" <<< "$CURLSUB2" | wc -l)
			echo $NUMBER_OF_ENTRIES
			if [[ $NUMBER_OF_ENTRIES -eq $sent_entries ]]; then
				complete_prop=$(($complete_prop + 1))
			fi
			
			if [[ $complete_prop -eq $nr_of_vessels ]]; then
				prop_time=$(($(date +%s%N | cut -b1-13) - $start_time))
				echo "DONE! in $prop_time ms"
				exit
			fi
			echo "trying again"
			sleep 0.001
		fi
	done
done
