import sys
import os
import re


def getNumberOfCores():
    confiFileName = 'config.sh'
    with open(confiFileName) as f:
        line = f.read()
        res = re.findall("NUMBER_OF_CORES_PER_NODE\s*=\s*(\d+)", line, re.MULTILINE)
        if (res):
            return int(res[0])

    return None


def main():
    fileName = os.path.basename(__file__)
    if len(sys.argv) < 2:
        print("Usage:\n\tpython " + fileName + " resultFileName")
        return

    CoresNumber = getNumberOfCores()
    resultFileName = sys.argv[1]
    if (not os.path.isfile(resultFileName)):
        print("File " + resultFileName + " is not exists.")
        return
    with open(resultFileName) as f:
        line = f.read()
        minutes = re.findall("Time spent: \d+ s for \d+ iterations", line, re.MULTILINE)
        sleeps = re.findall("Sleep for \d+ s", line, re.MULTILINE)
        res = re.findall("Expected total number of L1 cache misses: (\d+)", line, re.MULTILINE)
        if (res):
            print("Expected average number of l1 cache misses: "
                  + str(round(int(res[len(res) - 1]) / len(minutes) / CoresNumber / 60))
                  + " in job with ID "
                  + resultFileName.replace("slurm-", "").replace(".out", "")
                  + (" (The result may not be accurate because the desired "
                     + "number of iterations cannot be completed in one minute)"
                     if len(minutes) != len(sleeps) else ""))
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
