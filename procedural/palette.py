from PIL import Image
from sets import Set
import sys

def main():
    if len(sys.argv) < 2:
        print "Bad arguments"
        sys.exit(0)
    fn = sys.argv[1]
    im = Image.open(fn).convert("RGB")
    with open(fn + ".txt", 'w') as f:
        for tup in Set(im.getdata()):
            f.write("vec3" + str(tup) + ",\n")
    print "Palette written to " + fn + ".txt"

if __name__ == "__main__":
    main()
