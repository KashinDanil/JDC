import sys
import os


def main():
    if len(sys.argv) < 2:
        print("Usage: python parse.py test1='resultFile1' test2='resultFile2'")
        return

    realPath = os.path.dirname(os.path.realpath(__file__)) + "/"
    additionalParseParams = ''
    if ('--dndoof' in sys.argv):
        additionalParseParams += ' --dndoof'
    for test in sys.argv:
        data = test.split("=")
        if (len(data) == 1):
            continue
        command = "python " + realPath + data[0] + ".py '" + data[1] + "'" + additionalParseParams
        os.system(command)

    print("")


if __name__ == "__main__":
    main()
