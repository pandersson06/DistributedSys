
vessels=("192.33.90.67" "63163" "134.197.113.3" "63163" "149.43.80.20" "63163" "195.113.161.84" "63163" "206.23.240.29" "63163" "128.42.142.45" "63163")
#vessels=("192.33.90.67" "63163" "134.197.113.3" "63163" "149.43.80.20" "63163")
#vessels=("192.33.90.67" "63163" "134.197.113.3" "63163" "149.43.80.20" "63163" "195.113.161.84" "63163" "206.23.240.29" "63163" "128.42.142.45" "63163" "210.32.181.184" "63163" "200.19.159.35" "63163" "148.206.185.34" "63163")

sent_entries=6
nr_of_vessels=$(expr ${#vessels[*]} / 2)

address_fst="${vessels[0]}:${vessels[1]}"
CURL=$(curl --request GET $address_fst --silent)
CURLSUB1=$(echo $CURL | sed 's/.*<div class="entry">//')
CURLSUB2=$(echo $CURLSUB1 | awk '{split($1, a, "</div>"); print a[1]}')
echo "Entries at start: $CURLSUB2"

NUMBER_OF_BEGIN_ENTRIES=$(grep -o "<br>" <<< "$CURLSUB2" | wc -l)
echo "Nr of entries at start: $NUMBER_OF_BEGIN_ENTRIES"

for i in ${!vessels[*]}; do
  if [[ i%2 -eq 0 ]]; then
    address="${vessels[$i]}:${vessels[$i+1]}"
    echo "POST to $address"
    i2=$(($i + 1))
    curl --silent -d comment="test$i" $address > scrap.txt &
    curl --silent -d comment="test$i2" $address > scrap.txt &
    if [[ $i2 -eq 5 ]]; then
      break
    fi
  fi
done

start_time=$(date +%s%N | cut -b1-13)
var=0
complete_prop=0
while [[ $var -eq 0 ]]; do
  for i in ${!vessels[*]}; do
    if [[ i%2 -eq 0 ]]; then
      address="${vessels[$i]}:${vessels[$i+1]}"
      echo "GET to $address"
      CURL=$(curl --request GET $address --silent)
      CURLSUB1=$(echo $CURL | sed 's/.*<div class="entry">//')
      CURLSUB2=$(echo $CURLSUB1 | awk '{split($1, a, "</div>"); print a[1]}')
      echo "Entries on vessel: $CURLSUB2"
	
      NUMBER_OF_ENTRIES=$(grep -o "<br>" <<< "$CURLSUB2" | wc -l)
      echo "Current nr of entries: $NUMBER_OF_ENTRIES"
      sync_entries=$(($NUMBER_OF_ENTRIES - $NUMBER_OF_BEGIN_ENTRIES))
      echo "Entries sync: $sync_entries"
      if [[ $sync_entries -eq $sent_entries ]]; then
        complete_prop=$(($complete_prop + 1))
        echo $complete_prop
      fi
			
      if [[ $complete_prop -eq $nr_of_vessels ]]; then
        prop_time=$(($(date +%s%N | cut -b1-13) - $start_time))
        echo "DONE! in $prop_time ms"
        exit
      fi
    fi
  done
  echo "Not sync, trying again"
  sleep 0.001
  complete_prop=0
done
