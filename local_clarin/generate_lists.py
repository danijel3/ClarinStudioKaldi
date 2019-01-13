import argparse
import codecs
from pathlib import Path


def process(dir, audio, sessfile):
    wav_list = open(str(dir / 'wav.scp'), 'w')
    text = codecs.open(str(dir / 'text'), 'w', encoding='utf-8')
    spk_list = open(str(dir / 'utt2spk'), 'w')

    with open(str(sessfile), 'r') as f:
        for s in f:
            s = s.strip()
            spk_path = audio / s / 'spk.txt'
            if spk_path.exists():
                with open(str(spk_path), 'r') as spf:
                    spk = spf.read().strip()
            else:
                spk = s

            for w in sorted((audio / s).glob('*.wav')):
                n = str(w.stem)

                with codecs.open(str(audio / s / (n + '.txt')), 'r', encoding='utf-8') as t:
                    try:
                        txt = t.read().splitlines()[0]
                        txt = txt.replace('\xef\xbb\xbf', '')

                    except:
                        print('WARNING: error in file ' + s + '_' + n + '!')
                        continue

                if len(txt) == 0:
                    print('WARNING: skipped empty file: ' + s + '_' + n)
                    continue

                wav_list.write('{}_{} {}\n'.format(s, n, w.absolute()))

                text.write('{}_{} {}\n'.format(s, n, txt))

                spk_list.write('{}_{} {}\n'.format(s, n, spk))

    wav_list.close()
    text.close()
    spk_list.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Generate files in the train/test subdirs of the data dir: wav.scp, ,text, utt2spk')
    parser.add_argument('audio', help='path to dir with audio files')
    parser.add_argument('data', help='path to data dir')
    parser.add_argument('sessions', help='path to dir containing sessions files')

    args = parser.parse_args()

    data_dir = Path(args.data)
    audio_dir = Path(args.audio)
    sessions_dir = Path(args.sessions)

    if not (data_dir / 'train').exists():
        (data_dir / 'train').mkdir(parents=True)
    if not (data_dir / 'test').exists():
        (data_dir / 'test').mkdir(parents=True)
    if not (data_dir / 'dev').exists():
        (data_dir / 'dev').mkdir(parents=True)

    process(data_dir / 'train', audio_dir, sessions_dir / 'train.sessions')
    process(data_dir / 'test', audio_dir, sessions_dir / 'test.sessions')
    process(data_dir / 'dev', audio_dir, sessions_dir / 'dev.sessions')
