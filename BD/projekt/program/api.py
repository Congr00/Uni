import sys
import json_parser


db = 0

def parse_input():
    for line in sys.stdin:
        if line == '\n':
            break
        print(json_parser.parse(line))


def main():
    parse_input()

if __name__ == '__main__':
    main()

    # my code here

    
    