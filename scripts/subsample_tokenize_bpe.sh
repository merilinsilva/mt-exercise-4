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