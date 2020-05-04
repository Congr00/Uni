import sys

file_name = sys.argv[1]
with open(file_name) as r:
    buffor = []
    for line in r.readlines():
        if len(line.strip()) == 0:
            buffor.append(line)
        elif line.find('--'):
            buffor.append('> ' + line)
        else: buffor.append(line.replace('--', '').strip() + '\n')
    with open(file_name.split('.')[0] + '.lhs', 'w') as w:
        for b in buffor:
            w.write(b)
