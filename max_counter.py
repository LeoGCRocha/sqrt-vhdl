f = open('outputs_cycles.txt', 'r')
max = 0
count = 0

for line in f:
    try:
        if(int(line) == max):
            count += 1
        if(int(line) > max):
            max = int(line)
            count = 1
    except ValueError :
        pass

print("Pior caso em ciclos: " + str(max))
print("Quantidade de pior casos: " + str(count))
