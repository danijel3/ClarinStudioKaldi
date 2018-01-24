from os import listdir, makedirs
from os.path import basename, splitext, realpath, exists, join
import argparse
import glob
import codecs

def process(dir,audio,sessfile):

	dir = realpath(dir)
	
	with open(sessfile,'r') as f:
		lines=f.read().splitlines()
	
	wav_list=open(join(dir,'wav.scp'),'w')
	text=open(join(dir,'text'),'w')
	spk_list=open(join(dir,'utt2spk'),'w')
	for s in lines:

		spk_path=join(audio,s,'spk.txt')
		if exists(spk_path):
			with codecs.open(spk_path,'r','utf-8') as f:
				spk=f.read().strip()
		else:
			spk=s	

		wav_files=sorted(glob.glob(audio+'/'+s+'/*.wav'))

		for w in wav_files: 
			n=splitext(basename(w))[0]
			p=realpath(w)

			with codecs.open(join(audio,s,n+'.txt'),'r','utf-8') as f:
				try:
					txt_file=f.read().splitlines()[0]
				except:
					print('WARNING: error in file '+s+'_'+n+'\n')
					continue

			txt=txt_file.encode('utf-8').replace('\xef\xbb\xbf','')

			if len(txt) == 0:
				print('WARNING: skipped empty file: '+s+'_'+n)
				continue
			
			wav_list.write(s+'_'+n+' '+p+'\n')

			text.write(s+'_'+n+' '+txt+'\n')
			
			spk_list.write(s+'_'+n+' '+spk+'\n')

	
	wav_list.close()
	text.close()
	spk_list.close()


parser = argparse.ArgumentParser(description='Generate files in the train/test subdirs of the data dir: wav.scp, ,text, utt2spk')
parser.add_argument('audio', help='path to dir with audio files')
parser.add_argument('data', help='path to data dir')
parser.add_argument('sessions', help='path to dir containing sessions files')
args = parser.parse_args()

if not exists(join(args.data,'train')):
	makedirs(join(args.data,'train'))
if not exists(join(args.data,'test')):
	makedirs(join(args.data,'test'))
process(join(args.data,'train'),args.audio,join(args.sessions,'train.sessions'))
process(join(args.data,'test'),args.audio,join(args.sessions,'test.sessions'))
