from bitstring import BitArray
import itertools

def int2unsigned(a, length):    # Não é utilizado bits com sinal nesse projeto
    length = length + 1
    b = BitArray(int=a, length = length)
    return b.bin[1:]

N_BITS = 8 # Bits de entrada,
# deve ser o mesmo valor da constante de mesmo nome em multiplier.pkg

input_f = open("inputs.txt","w")
output_f = open("outputs_ref.txt","w")
testes_a = range(0, 2**(N_BITS//2))
testes_b = range(0, 2**(N_BITS//2))

for a,b in itertools.product(testes_a, testes_b):
    res = int(b * (0.5))

    bin_a = int2unsigned(a, N_BITS)
    bin_b = int2unsigned(b, N_BITS)
    bin_res = int2unsigned(res, N_BITS)
    
    print(f'{bin_b}', file = input_f)
    print(bin_res, file = output_f)

input_f.close()
output_f.close()
