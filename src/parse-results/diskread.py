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
        resAvg = re.findall("Average disk reading speed: (\d+\.\d{2}) b/s", line, re.MULTILINE)
        if (res):
            print("Expected average disk reading: " + resAvg[len(resAvg) - 1]
                  + " B/s in job with ID "
                  + resultFileName.replace("slurm-", "").replace(".out", ""))
            # print("Expected max disk reading: " + str(max(res)) + " B/s in job with ID "
            #       + resultFileName.replace("slurm-", "").replace(".out", ""))
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
