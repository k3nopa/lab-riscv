#!/usr/local/bin/python3
# /usr/bin/python3

import sys, getopt, os
import subprocess

# Colors Constant
INFO = "\033[94m"
WARNING = "\033[93m"
ERROR = "\033[91m"
END = "\033[0m"

# dev_path = "/home/naufal/dev"
dev_path = "/Users/afiqnaufal/Documents/lab/github"


def log(status, msg):
    if status == "info":
        print(f"{INFO}[{'INFO'}]{END} {msg}")
    elif status == "error":
        print(f"{ERROR}[{'ERROR'}]{END} {msg}")
    elif status == "warning":
        print(f"{WARNING}[{'WARNING'}]{END} {msg}")


def usage():
    help_banner = """
    Usage: ./simulate.py -t <types>
    -t     types of simulation to run
    -d     directory containing all top's dependencies

    types:
      asm:
        load
        store
      c:
        hello
      MiBench:
        bitcnts

    Example: ./simulate.py -t load -d deps/
    """
    print(help_banner)


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

    if dep_path == "":
        log("error", "Dependencies path for top verilog is require")
        sys.exit()

    return sim_type, dep_path


def prepare(sim_type):
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

    except OSError:
        log("error", "Directory simulation can't be created")
        sys.exit(2)
    else:
        log("info", "Successfully created the directory")

    # Change to simulation folder
    os.chdir(target_path)

    # cp type's make folder
    copy_path = ""
    if sim_type == "store":
        copy_path = os.path.join(dev_path, "test_pack/asm/store/")
    elif sim_type == "hello":
        copy_path = os.path.join(dev_path, "test_pack/c/hello/")
    elif sim_type == "bitcnts":
        copy_path = os.path.join(dev_path, "test_pack/MiBench/bitcnts/test/")
    else:  # load
        copy_path = os.path.join(dev_path, "test_pack/asm/load/")

    process = subprocess.Popen(
        ["cp", "-r", copy_path, "./"], stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )

    log("info", "Preparing for makefile")
    stdout, stderr = process.communicate()
    stdout = str(stdout, "utf-8")
    stderr = str(stderr, "utf-8")
    if stdout == "" or stdout == "":
        print(stdout, stderr)

    process = subprocess.Popen(["make"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    log("info", "Run makefile")
    stdout, stderr = process.communicate()
    stdout = str(stdout, "utf-8")
    stderr = str(stderr, "utf-8")
    if stdout == "" or stdout == "":
        print(stdout, stderr)


def simulate(dep_path):
    dep_path = os.path.join(dev_path, dep_path)
    dep_files = [f for f in os.listdir(dep_path)]

    process = subprocess.Popen(
        ["xmverilog", "-s", "_access+rwc", "top_test.v"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    log("info", "Run Simulation")
    stdout, stderr = process.communicate()
    stdout = str(stdout, "utf-8")
    stderr = str(stderr, "utf-8")
    if stdout == "" or stdout == "":
        print(stdout, stderr)


def run():
    (sim_type, dep_path) = args()
    prepare(sim_type)
    simulate(dep_path)


if __name__ == "__main__":
    run()
