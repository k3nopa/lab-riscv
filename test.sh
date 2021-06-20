#! /bin/bash
red='\e[0;31m'
norm='\e[0m'

for test in hello bitcnts:test stringsearch:test napier:test pi:test prime:test sort:quick:test sort:insert:test sort:babble:test dijkstra:test 
do
    touch "logs/$test.log"
    python3 scripts/simulate.py -t $test 
    cd simulation
    echo -e ${red}"[${test^^}]"${norm}
    vvp out | tee "../logs/$test.log"
    cd ../
    sleep 2
done
