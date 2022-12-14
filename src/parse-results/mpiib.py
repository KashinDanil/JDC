import sys
import os
import re


def main():
    fileName = os.path.basename(__file__)
    if len(sys.argv) < 2:
        print("Usage:\n\tpython " + fileName + " resultFileName")
        return

    resultFileName = sys.argv[1]
    if (not os.path.isfile(resultFileName)):
        print("File " + resultFileName + " is not exists.")
        return
    with open(resultFileName) as f:
        line = f.read()
        res = re.findall("#\s+Size\s+Bandwidth\s+\(MB/s\)\s+\d+\s+(\d+(\.\d+)?)", line, re.MULTILINE)
        if (res):
            print("Expected network bandwidth: " + (res[0][0] if type(res[0]) is tuple else res[0])
                  + " MB/s in job with ID "
                  + resultFileName.replace("slurm-", "").replace(".out", ""))
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
