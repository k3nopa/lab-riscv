SIM = simulation

STORE = test_pack/asm/store/*
LOAD = test_pack/asm/load/*
P2 = test_pack/asm/p2/*

HELLO = test_pack/c/hello/*

store: prepare test_store run
load: prepare test_load run
p2: prepare test_p2 run

hello: prepare test_hello run

prepare:
	if [ ! -d $(SIM) ]; then mkdir -p $(SIM); else rm -rf $(SIM); mkdir -p $(SIM);fi
	cp -r ./32I-riscv/* $(SIM)
	cp top_test.v $(SIM)

test_store: prepare
	cp	 $(STORE) $(SIM)

test_load: prepare
	cp	 $(LOAD) $(SIM)

test_p2: prepare
	cp	 $(P2) $(SIM)

test_hello: prepare
	cp	 $(HELLO) $(SIM)

run:
	cd $(SIM) && make
	cd $(SIM) && iverilog -o out top_test.v
