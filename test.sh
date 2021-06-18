#! /bin/bash

for	test in hello napier:test pi:test prime:test sort:quick:test sort:insert:test sort:babble:test bitcnts:test stringsearch:test dijkstra:test 
do
    echo "Testing with" $test
    touch "logs/$test.log"

    python3 scripts/simulate.py -t $test 
    cd simulation
    vvp out | tee "../logs/$test.log"
    cd ../
done
