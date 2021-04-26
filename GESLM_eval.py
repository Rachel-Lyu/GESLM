path = "./result/"
maflis = [0.05, 0.1, 0.2, 0.5]
# sslis = [500*i for i in range(1, 11)]
rsqlis = [0.7, 0.9]
for maf in maflis:
    print('MAF = '+str(maf)+': ')
    for rsq in rsqlis:
        print('  rsq = '+str(rsq)+': ', end = '')
        inp1 = open(path+'rsq'+str(rsq)+'_MAF'+str(maf)+'_D1.csv', 'r')
        inp2 = open(path+'rsq'+str(rsq)+'_MAF'+str(maf)+'_D2.csv', 'r')
        rec1 = []
        rec2 = []
        for s in inp1:
            if ('X' not in s and 'Y' not in s and 'Z' not in s and 'W' not in s) and ('A' in s and 'B' in s):
                rec1.append(1)
            else:
                rec1.append(0)
        inp1.close()
        for s in inp2:
            sspl=s.split(',')
            if ('X' not in s and 'Y' not in s and 'Z' not in s and 'W' not in s) and ('A' in s and 'C' in s):
                rec2.append(1)
            else:
                rec2.append(0)
        inp2.close()
        cnt = 0
        for i in range(len(rec1)):
            if rec1[i]+rec2[i]==2:
                cnt += 1
        print(''+str(float(cnt/10)))