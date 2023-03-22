import sys
import os
import re


def getRamSize():
    confiFileName = 'config.sh'
    with open(confiFileName) as f:
        line = f.read()
        res = re.findall("TOTAL_MEM_B\s*=\s*(\d+)", line, re.MULTILINE)
        if (res):
            return int(res[0])

    return None

def main():
    fileName = os.path.basename(__file__)
    if len(sys.argv) < 2:
        print("Usage:\n\tpython " + fileName + " resultFileName")
        return
    RAM = getRamSize()
    resultFileName = sys.argv[1]
    if (not os.path.isfile(resultFileName)):
        print("File " + resultFileName + " is not exists.")
        return
    with open(resultFileName) as f:
        line = f.read()
        res = re.findall("UsedMemory:\s+(\d+) B", line, re.MULTILINE)
        if (res):
            if RAM is not None:
                print(RAM, res[len(res) - 1])
                print("Expected free RAM: " + str(RAM - int(res[len(res) - 1])) + " B in job with ID "
                      + resultFileName.replace("slurm-", "").replace(".out", ""))
            else:
                print("Expected RAM usage: " + res[len(res) - 1] + " B in job with ID "
                      + resultFileName.replace("slurm-", "").replace(".out", ""))
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
