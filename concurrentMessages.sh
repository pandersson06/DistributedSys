curl -d comment=test1 127.0.0.1:63100 &
curl -d comment=test2 127.0.0.1:63101 &
curl -d comment=test2 127.0.0.1:63100 &
curl -d comment=test3 127.0.0.1:63102 &
curl -d comment=test2 127.0.0.1:63103 &
curl -d comment=test4 127.0.0.1:63101
