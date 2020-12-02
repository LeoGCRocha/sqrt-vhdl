f = open('arquivo.txt', 'r')
max = 0
for line in f:
    if(int(line) > max):
        max = int(line)
print(max)
