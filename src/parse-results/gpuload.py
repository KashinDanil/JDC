import sys
import os
import re


def main():
    fileName = os.path.basename(__file__)
    if len(sys.argv) < 2:
        print("Usage:\n\tpython " + fileName + " resultFileName")
        return

    resultFileName = sys.argv[1]
    # check if the path exists
    if (not os.path.isfile(resultFileName)):
        print("File " + resultFileName + " is not exists.")
        return
    with open(resultFileName) as f:
        line = f.read()
        # find results by matching regular expression
        res = re.findall("Starting gpuload with utilization:(\d+)%", line, re.MULTILINE)
        if (res):
            print("Expected average GPU usage: " + res[0] + " % in job with ID "
                  + resultFileName.replace("slurm-", "").replace(".out", ""))
            # delete output file if not needed
            if ('--dndoof' not in sys.argv):
                os.remove(resultFileName)
            return

    print("Something went wrong. Was not able to parse the result of " + fileName.replace(".py", "") + ".")


if __name__ == "__main__":
    main()
