# This script is supposed to subsample 100000 sentence pairs
scripts=$(dirname "$0")
base=$scripts/..

data=$base/data

mkdir $base/new_data
new_data=$base/new_data

head -n 100000 $data/train.nl-de.nl > $new_data/train.nl-de.100k.nl
head -n 100000 $data/train.nl-de.de > $new_data/train.nl-de.100k.de

# Tokenize training data
sacremoses tokenize < $new_data/train.nl-de.100k.nl > $new_data/train.tok.nl
sacremoses tokenize < $new_data/train.nl-de.100k.de > $new_data/train.tok.de

# Same for dev and test files:
sacremoses tokenize < $data/dev.nl-de.nl > $new_data/dev.tok.nl
sacremoses tokenize < $data/dev.nl-de.de > $new_data/dev.tok.de

sacremoses tokenize < $data/test.nl-de.nl > $new_data/test.tok.nl
sacremoses tokenize < $data/test.nl-de.de > $new_data/test.tok.de

# Move the files and rename them accordingly
mkdir $data/my_lang_pair

my_lang_pair=$data/my_lang_pair

mv $new_data/train.tok.nl $my_lang_pair/train.nl
mv $new_data/train.tok.de $my_lang_pair/train.de
mv $new_data/dev.tok.nl   $my_lang_pair/dev.nl
mv $new_data/dev.tok.de   $my_lang_pair/dev.de
mv $new_data/test.tok.nl  $my_lang_pair/test.nl
mv $new_data/test.tok.de  $my_lang_pair/test.de