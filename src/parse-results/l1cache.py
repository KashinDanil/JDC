import sys
import os
import re
import subprocess


def getNumberOfCores():
    confiFileName = 'config.sh'
    # read number of cores per node from bash config file
    CMD = 'echo $(source ' + confiFileName + '; echo $NUMBER_OF_CORES_PER_NODE)'
    p = subprocess.Popen(CMD, stdout=subprocess.PIPE, shell=True, executable='/bin/bash')

    return int(p.stdout.readlines()[0].strip())


def main():
    fileName = os.path.basename(__file__)
    if len(sys.argv) < 2:
        print("Usage:\n\tpython " + fileName + " resultFileName")
        return

    CoresNumber = getNumberOfCores()
    resultFileName = sys.argv[1]
    # check if the path exists
    if (not os.path.isfile(resultFileName)):
        print("File " + resultFileName + " is not exists.")
        return
    with open(resultFileName) as f:
        line = f.read()
        spentSeconds = re.findall("Time spent: (\d+) s", line, re.MULTILINE)
        # find results by matching regular expression
        res = re.findall("Expected total number of L1 cache misses: (\d+)", line, re.MULTILINE)
        if (res):
            print("Expected average number of L1 cache misses: "
                  + str(round(int(res[len(res) - 1]) / int(spentSeconds[0]) / CoresNumber))
                  + " in job with ID "
                  + resultFileName.replace("slurm-", "").replace(".out", ""))
            # delete output file if not needed
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
