#!/usr/bin/env python

import time
import os
import sys
import random


def writeToFile(filename, mysizeMB):
    mystring = "x"
    writeloops = int(mysizeMB / len(mystring))
    try:
        f = open(filename, 'w')
    except:
        raise
    # generate a string to write to a temporary file
    mystring = mystring * writeloops
    f.write(mystring)
    f.close()


def readFromFile(filename):
    try:
        f = open(filename, 'r')
    except:
        raise
    # read whole file
    str = f.read()
    f.close()

    return len(str)


def diskSpeedMeasure(duration, dirname):
    filesize = 1024 * 1024 * 1024  # in bytes
    filename = os.path.join(dirname, 'tmpReadTest' + str(random.randint(-100000000, -1)))
    # set start time
    start = time.time()
    totalSize = 0
    try:
        writeToFile(filename, filesize)
    except:
        raise
    while True:
        try:
            readFromFile(filename)
            totalSize += filesize
        except:
            raise
        # check if the time has elapsed
        if (time.time() - start) >= duration: break

    # remove temp file
    os.remove(filename)
    diff = time.time() - start
    speed = totalSize / diff
    print("Average disk reading speed: %.2f b/s" % speed, "(", totalSize, "/", diff, ")")


def help():
    print("The program measures disk read/write speed.\n"
          "Execution:\n"
          "./iobandwidth.py {duration in seconds} [tmp_dir_path]\n")


if __name__ == "__main__":
    duration = 600
    # default temp dir is current dir
    dirname = os.getcwd()
    if len(sys.argv) >= 2:
        duration = int(sys.argv[1])
        if len(sys.argv) >= 3:
            dirname = sys.argv[2]
            if not os.path.isdir(dirname):
                print("Specified directory is not exist. Bailing out")
                sys.exit(1)
    else:
        help()

    try:
        diskSpeedMeasure(duration, dirname)
    except e:
        if e.errno == 13:
            print("Could not create test file. Check that you have write rights to directory", dirname)
    except:
        print("Something else went wrong")
        raise
