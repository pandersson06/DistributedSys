
CURL=$(curl --request GET '129.16.75.16:63163' --silent)
CURLSUB1=$(echo $CURL | sed 's/.*<div class="entry">//')
CURLSUB2=$(echo $CURLSUB1 | awk '{split($1, a, "</div>"); print a[1]}')
echo $CURLSUB2

