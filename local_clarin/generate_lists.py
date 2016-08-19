from os import listdir
from os.path import basename, splitext, realpath
import glob
import codecs

def process(dir,audio):
	
	with open(dir+'/sessions','r') as f:
		lines=f.read().splitlines()
	
	wav_list=open(dir+'/wav.scp','w')
	text=open(dir+'/text','w')
	spk_list=open(dir+'/utt2spk','w')
	for s in lines:
		
		wav_files=sorted(glob.glob(audio+'/'+s+'/*.wav'))
		
	
		for w in wav_files: 
			n=splitext(basename(w))[0]
			p=realpath(w)

			wav_list.write(s+'_'+n+' '+p+'\n')
			
			with codecs.open(audio+'/'+s+'/'+n+'.txt','r','utf-8') as f:
				try:
					txt_file=f.read().splitlines()[0]
				except UnicodeDecodeError:
					print('Error in file '+s+'_'+n+'\n')
			
			text.write(s+'_'+n+' '+txt_file.encode('utf-8')+'\n')
			
			spk_list.write(s+'_'+n+' '+s+'\n')

	
	wav_list.close()
	text.close()
	spk_list.close()


process('train','../audio')
process('test','../audio')
