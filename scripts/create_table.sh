# !/bin/bash


# Here, we define the directory with the bleu scores
results="bleu_scores"

# Next, we extract the scores
bleu_word_model=$(grep '"score"' "$results/word_level_model_results.log" | awk -F ': ' '{print $2}' | tr -d ',')
bleu_bpe_2k_model=$(grep '"score"' "$results/bpe_2k_model_results.log" | awk -F ': ' '{print $2}' | tr -d ',')
bleu_bpe_4k_model=$(grep '"score"' "$results/bpe_4k_model_results.log" | awk -F ': ' '{print $2}' | tr -d ',')

# Finally the table is created and printed
printf "\n%-7s | %-7s | %-14s | %-5s\n" "Exp" "use BPE" "vocabulary size" "BLEU"
printf "%-7s | %-7s | %-14s | %-5s\n" "------" "-------" "---------------" "-----"
printf "%-7s | %-7s | %-14s | %-5.2f\n" "(a)" "no"  "2000" "$bleu_word_model"
printf "%-7s | %-7s | %-14s | %-5.2f\n" "(b)" "yes" "2000" "$bleu_bpe_2k_model"
printf "%-7s | %-7s | %-14s | %-5.2f\n" "(c)" "yes" "4000"    "$bleu_bpe_4k_model"
