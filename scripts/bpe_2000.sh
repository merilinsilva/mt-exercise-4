#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

models=$base/models
configs=$base/configs
new_data=$base/new_data
bpe_2000=$base/data/bpe_2000
output_data=$base/data/my_lang_pair_bpe_2000

mkdir $bpe_2000
mkdir -p $output_data

# Here the bpe model and vocabulary is learned
subword-nmt learn-joint-bpe-and-vocab \
  --input $new_data/train.tok.nl $new_data/train.tok.de \
  -s 2000 \
  --total-symbols \
  -o $bpe_2000/bpe.codes \
  --write-vocabulary $bpe_2000/vocab.nl $bpe_2000/vocab.de

# Next, bpe is applied with vocab filtering on train, test and dev
for split in train dev test; do
  for lang in nl de; do
    subword-nmt apply-bpe -c $bpe_2000/bpe.codes \
      --vocabulary $bpe_2000/vocab.$lang --vocabulary-threshold 50 \
      < $new_data/$split.tok.$lang > $bpe_2000/$split.bpe.$lang
  done
done

# 3. Copy to final JoeyNMT data folder
for split in train dev test; do
  for lang in nl de; do
    cp $bpe_2000/$split.bpe.$lang $output_data/$split.$lang
  done
done


# 4. Create joint vocab (token list only, no frequencies)
awk '{print $1}' $bpe_2000/vocab.nl > $bpe_2000/vocab.nl.txt
awk '{print $1}' $bpe_2000/vocab.de > $bpe_2000/vocab.de.txt
cat $bpe_4000/vocab.de.txt $bpe_2000/vocab.nl.txt | sort | uniq > $bpe_2000/joint_vocab.txt

echo "✅ BPE 2000 preprocessing complete."
echo "→ Data saved to:     $output_data"
echo "→ BPE codes:         $bpe_2000/bpe.codes"
echo "→ Joint vocab file:  $bpe_2000/joint_vocab.txt"
