#!/usr/bin/python3

import sys, getopt, os
import subprocess

# Colors Constant
INFO = "\033[94m"
WARNING = "\033[93m"
ERROR = "\033[91m"
END = "\033[0m"

dev_path = "/home/muhd/dev"

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

def cmd(cmd_list):
    process = subprocess.Popen(
        cmd_list, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
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

    except OSError:
        log("error", "Directory simulation can't be created")
        sys.exit(2)
    else:
        log("info", "Successfully created the directory")

    # Change to simulation folder
    log("info", "Changing to simulation folder")
    os.chdir(target_path)

    # cp type's make folder
    copy_path = "/home/muhd/dev"
    if sim_type == "store":
        new_copy_path = os.path.join(dev_path, "test_pack/asm/store/")
    elif sim_type == "hello":
        new_copy_path = os.path.join(dev_path, "test_pack/c/hello/")
    elif sim_type == "bitcnts":
        new_copy_path = os.path.join(dev_path, "test_pack/MiBench/bitcnts/test/")
    else:  # load
        new_copy_path = os.path.join(dev_path, "test_pack/asm/load/")

    log("info", "Preparing for makefile")
    cmd(["cp", f"{copy_path}/shm.tcl", "./"])
    cmd(["cp", f"{copy_path}/top_test.v", "./"])
    for file in os.listdir(new_copy_path):
        cmd(["cp", new_copy_path+file, "./"])

    log("info", "Run makefile")
    cmd(["make"])

    log("info", "Copy dependencies' files")
    sim_cmd = ["xmverilog", "-s", "+access+rwc", "+tcl+shm.tcl", "top_test.v"]

    dep_path = os.path.join(dev_path, dep_path)
    for file in os.listdir(dep_path):
        cmd(["cp", dep_path+file, "./"])
        if file != "top.v":
            sim_cmd.append(file)

    log("info", "Run Simulation")
    print(" ".join(sim_cmd))
    # cmd(sim_cmd)


def run():
    (sim_type, dep_path) = args()
    if dep_path == "":
        dep_path = "32I-riscv/"
    simulate(sim_type, dep_path)


if __name__ == "__main__":
    run()
