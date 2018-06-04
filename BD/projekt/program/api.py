import sys

if __name__ == "__main__":
    main()

db = db_connect()

def main():
    parse_input()

    # my code here

def parse_input():
    for line in sys.stdin:
        parse(line)

    
    