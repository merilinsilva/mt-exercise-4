#!/bin/bash

# please run `brew install jq` on ur terminal first!!

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data/my_lang_pair_bpe_4000
configs=$base/configs
model_name=bpe_4k_model
config_file=$configs/$model_name.yaml

translations=$base/translations/$model_name
bleu_logs=$base/bleu_scores
results_csv=$bleu_logs/${model_name}_beam_search_results.csv

mkdir -p $translations
mkdir -p $bleu_logs

src=nl
trg=de
num_threads=4
device=0

echo "beam_size,bleu,time_seconds" > $results_csv

for beam in {1..10}; do
    echo "Running translation with beam size $beam..."

    tmp_config=$configs/${model_name}_beam$beam.yaml
    cp $config_file $tmp_config

    sed -i '' "s/^[[:space:]]*beam_size: .*/  beam_size: $beam/" $tmp_config
    sed -i '' "s/^[[:space:]]*alpha: .*/  beam_alpha: 1.0/" $tmp_config

    out_file=$translations/test.beam${beam}.$trg

    # Start timing
    SECONDS=0

    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads \
    python -m joeynmt translate $tmp_config < $data/test.$src > $out_file

    # Record time taken
    time_taken=$SECONDS

    # Compute BLEU score
    bleu_score=$(cat $out_file \
        | sed -r 's/@@( )?//g' \
        | sacremoses detokenize \
        | sacrebleu $data/test.$trg \
        | grep -o '"score":[ ]*[0-9.]\+' \
        | grep -o '[0-9.]\+')

    # Log results
    echo "$beam,$bleu_score,$time_taken" >> $results_csv
    echo "Beam size $beam: BLEU = $bleu_score, Time = ${time_taken}s"
done

mkdir $base/plots