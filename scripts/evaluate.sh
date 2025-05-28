#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data/my_lang_pair_bpe_4000
configs=$base/configs

translations=$base/translations
bleu_logs=$base/bleu_scores

mkdir -p $bleu_logs
mkdir -p $translations

src=nl
trg=de


num_threads=4
device=0

# measure time

SECONDS=0

model_name=word_level_model

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.$src > $translations_sub/test.$model_name.$trg

# compute case-sensitive BLEU 
cat $translations_sub/test.$model_name.$trg \
| sed -r 's/@@( )?//g' \
| sacremoses detokenize \
| sacrebleu $data/test.$trg > $bleu_logs/${model_name}_results.log


echo "time taken:"
echo "$SECONDS seconds"
