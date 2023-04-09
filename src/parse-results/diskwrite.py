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
        res = re.findall("Disk writing speed: (\d+\.\d{2}) b/s", line, re.MULTILINE)
        res = [float(numeric_string) for numeric_string in res]
        if (res):
            print("Expected average disk write: " + str(round(sum(res) / len(res), 2)) + " B/s in job with ID "
                  + resultFileName.replace("slurm-", "").replace(".out", ""))
            # print("Expected max disk write: " + str(max(res)) + " B/s in job with ID "
            #       + resultFileName.replace("slurm-", "").replace(".out", ""))
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
