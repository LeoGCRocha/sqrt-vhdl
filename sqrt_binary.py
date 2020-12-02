def sqrt_binary_search(x):
    

    start = 0
    end = x
    cont = 0

    while start <= end:
        
        mid = (start+end)//2
        cont = cont + 1

        if  x == mid * mid:
            break
        elif x < mid * mid:
            end = mid - 1
        elif x > mid * mid:
            start = mid + 1

    print("cont: " + str(cont))
    return end

while 1:
    print("resultado: " + str(sqrt_binary_search(int(input()))))
