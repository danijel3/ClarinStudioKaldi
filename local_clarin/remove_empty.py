import os
import sys

if len(sys.argv)!=2:
	print './remove_empty.py [file]'
	sys.exit(1)

filename=sys.argv[1]

os.rename(filename,filename+'.bak')

with open(filename+'.bak','r') as f_in:
	with open(filename,'w') as f_out:
		for n,l in enumerate(f_in):
			if len(l.split()) <= 1:
				print 'WARNING: Removed line #{}: {}'.format(n,l[:-1])
			else:
				f_out.write(l)
