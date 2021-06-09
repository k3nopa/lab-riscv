#! /usr/bin/python3

import sys, getopt, os
import subprocess

# Colors Constant
INFO = "\033[94m"
WARNING = "\033[93m"
ERROR = "\033[91m"
END = "\033[0m"

dev_path = "/home/vagrant/dev"


def log(status, msg):
    if status == "info":
        print(f"{INFO}['INFO']{END} {msg}")
    elif status == "error":
        print(f"{ERROR}['ERROR']{END} {msg}")
    elif status == "warning":
        print("{WARNING}['WARNING']{END} {msg}")


def usage():
    help_banner = """
    Usage: ./simulate.py -t <types>
    -t     types of simulation to run
    -d     directory containing all top's dependencies

    types:
      asm:
        load
        store
        skel
        p2
      c:
        hello

        napier:test
        napier:small
        napier:mid
        napier:large
        napier:ans

        pi:test
        pi:small
        pi:mid
        pi:large
        pi:ans

        prime:test
        prime:small
        prime:mid
        prime:large
        prime:ans

        sort:quick:test
        sort:quick:small
        sort:quick:mid
        sort:quick:large
        sort:quick:ans

        sort:insert:test
        sort:insert:small
        sort:insert:mid
        sort:insert:large
        sort:insert:ans

        sort:babble:test
        sort:babble:small
        sort:babble:mid
        sort:babble:large
        sort:babble:ans

      MiBench:
        bitcnts:test
        bitcnts:small
        bitcnts:large

        dijkstra:test
        dijkstra:small
        dijkstra:large
        dijkstra:ans

        stringsearch:test
        stringsearch:small
        stringsearch:large
        stringsearch:ans

    Example: ./simulate.py -t load -d deps/
    """
    print(help_banner)


def cmd(cmd_list):
    process = subprocess.Popen(cmd_list, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    stdout = str(stdout, "utf-8")
    stderr = str(stderr, "utf-8")
    if stdout != "" or stderr != "":
        print(stdout, stderr)


def args():
    sim_type = ""
    dep_path = ""

    if len(sys.argv) < 2:
        usage()
        sys.exit()

    try:
        opts, args = getopt.getopt(sys.argv[1:], "ht:d:")

    except getopt.GetoptError:
        usage()
        sys.exit(2)

    for opt, arg in opts:
        if opt == "-h":
            usage()
        elif opt == "-t":
            sim_type = arg
        elif opt == "-d":
            dep_path = arg
        else:
            usage()

    if sim_type == "":
        log("error", "Simulation type is require")
        sys.exit()

    return sim_type, dep_path


def simulate(sim_type, dep_path):
    target_path = os.path.join(dev_path, "simulation")

    current_path = os.path.dirname(os.path.abspath(__file__))
    if current_path != dev_path:
        os.chdir(dev_path)
    try:
        if not os.path.exists(target_path):
            log("info", "Creating simulation directory")
            os.mkdir("simulation")
        else:
            log("info", "Simulation directory already exists")
            log("info", "Deleting Simulation directory")
            cmd(["rm", "-rf", target_path])
            log("info", "Creating simulation directory")
            os.mkdir("simulation")

    except OSError:
        log("error", "Directory simulation can't be created")
        sys.exit(2)
    else:
        log("info", "Successfully created the directory")

    # Change to simulation folder
    log("info", "Changing to simulation folder")
    os.chdir(target_path)

    # cp type's make folder
    copy_path = "/home/vagrant/dev"

    if sim_type == "store":
        new_copy_path = os.path.join(dev_path, "test_pack/asm/store/")
    elif sim_type == "skel":
        new_copy_path = os.path.join(dev_path, "test_pack/asm/skel/")
    elif sim_type == "p2":
        new_copy_path = os.path.join(dev_path, "test_pack/asm/p2/")
    elif sim_type == "hello":
        new_copy_path = os.path.join(dev_path, "test_pack/c/hello/")

    elif sim_type == "napier:test":
        new_copy_path = os.path.join(dev_path, "test_pack/c/napier/test/")
    elif sim_type == "napier:small":
        new_copy_path = os.path.join(dev_path, "test_pack/c/napier/small/")
    elif sim_type == "napier:mid":
        new_copy_path = os.path.join(dev_path, "test_pack/c/napier/mid/")
    elif sim_type == "napier:large":
        new_copy_path = os.path.join(dev_path, "test_pack/c/napier/large/")
    elif sim_type == "napier:ans":
        new_copy_path = os.path.join(dev_path, "test_pack/c/napier/ans/")

    elif sim_type == "pi:test":
        new_copy_path = os.path.join(dev_path, "test_pack/c/pi/test/")
    elif sim_type == "pi:small":
        new_copy_path = os.path.join(dev_path, "test_pack/c/pi/small/")
    elif sim_type == "pi:mid":
        new_copy_path = os.path.join(dev_path, "test_pack/c/pi/mid/")
    elif sim_type == "pi:large":
        new_copy_path = os.path.join(dev_path, "test_pack/c/pi/large/")
    elif sim_type == "pi:ans":
        new_copy_path = os.path.join(dev_path, "test_pack/c/pi/ans/")

    elif sim_type == "prime:test":
        new_copy_path = os.path.join(dev_path, "test_pack/c/prime/test/")
    elif sim_type == "prime:small":
        new_copy_path = os.path.join(dev_path, "test_pack/c/prime/small/")
    elif sim_type == "prime:mid":
        new_copy_path = os.path.join(dev_path, "test_pack/c/prime/mid/")
    elif sim_type == "prime:large":
        new_copy_path = os.path.join(dev_path, "test_pack/c/prime/large/")
    elif sim_type == "prime:ans":
        new_copy_path = os.path.join(dev_path, "test_pack/c/prime/ans/")

    elif sim_type == "sort:quick:test":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/quick/test/")
    elif sim_type == "sort:quick:small":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/quick/small/")
    elif sim_type == "sort:quick:mid":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/quick/mid/")
    elif sim_type == "sort:quick:large":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/quick/large/")

    elif sim_type == "sort:insert:test":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/insert/test/")
    elif sim_type == "sort:insert:small":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/insert/small/")
    elif sim_type == "sort:insert:mid":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/insert/mid/")
    elif sim_type == "sort:insert:large":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/insert/large/")

    elif sim_type == "sort:babble:test":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/babble/test/")
    elif sim_type == "sort:babble:small":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/babble/small/")
    elif sim_type == "sort:babble:mid":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/babble/mid/")
    elif sim_type == "sort:babble:large":
        new_copy_path = os.path.join(dev_path, "test_pack/c/sort/babble/large/")

    elif sim_type == "bitcnts:test":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/bitcnts/test/")
    elif sim_type == "bitcnts:small":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/bitcnts/small/")
    elif sim_type == "bitcnts:large":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/bitcnts/large/")
    elif sim_type == "dijkstra:ans":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/dijkstra/ans/")

    elif sim_type == "dijkstra:test":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/dijkstra/test/")
    elif sim_type == "dijkstra:small":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/dijkstra/small/")
    elif sim_type == "dijkstra:large":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/dijkstra/large/")
    elif sim_type == "dijkstra:ans":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/dijkstra/ans/")

    elif sim_type == "stringsearch:test":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/stringsearch/test/")
    elif sim_type == "stringsearch:small":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/stringsearch/small/")
    elif sim_type == "stringsearch:large":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/stringsearch/large/")
    elif sim_type == "stringsearch:ans":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/stringsearch/ans/")

    else:  # load
        new_copy_path = os.path.join(dev_path, "test_pack/asm/load/")

    log("info", "Preparing for makefile")
    cmd(["cp", f"{copy_path}/top_test.v", "./"])
    for file in os.listdir(new_copy_path):
        cmd(["cp", "-r", new_copy_path + file, "./"])

    log("info", "Run makefile")
    cmd(["make"])

    dep_path = os.path.join(dev_path, dep_path)
    for file in os.listdir(dep_path):
        cmd(["cp", "-r", dep_path + file, "./"])

    log("info", "Run Simulation")
    os.chdir(copy_path + "/simulation")
    cmd(["iverilog", "-o", "out", "top_test.v"])


def run():
    (sim_type, dep_path) = args()
    if dep_path == "":
        dep_path = "32I-riscv/"
    simulate(sim_type, dep_path)


if __name__ == "__main__":
    run()
