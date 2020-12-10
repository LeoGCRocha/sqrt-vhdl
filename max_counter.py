f = open('outputs_cycles.txt', 'r')
max = 0
for line in f:
    if(int(line) > max):
        max = int(line)
print(max)
