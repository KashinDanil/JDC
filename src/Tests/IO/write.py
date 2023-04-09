#!/usr/bin/env python

import time, os, sys, math, random


def writeToFile(filename, mysizeMB):
    mystr = "x"
    writeloops = int(mysizeMB / len(mystr))
    try:
        f = open(filename, 'w')
    except:
        raise
    mystr = mystr * writeloops
    f.write(mystr)
    f.close()


def diskSpeedMeasure(duration, dirname):
    filesize = 512 * 1024 * 1024  # in bytes
    filename = os.path.join(dirname, 'tmpWriteTest' + str(random.randint(-100000000, -1)))
    start = time.time()
    while True:
        startMeasure = time.time()
        try:
            writeToFile(filename, filesize)
        except:
            raise
        diff = time.time() - startMeasure
        os.remove(filename)
        speed = filesize / diff
        print("Disk writing speed: %.2f b/s" % speed, "(", filesize, "/", diff, ")")
        if (speed > filesize):
            filesize = int(math.ceil(speed / 104857600.0)) * 104857600 #round up to the nearest hundred MB
        if (time.time() - start) >= duration: break


def help():
    print("The program measures disk read/write speed.\n"
          "Execution:\n"
          "./iobandwidth.py {duration in seconds} [tmp_dir_path]\n")


if __name__ == "__main__":
    duration = 600
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
