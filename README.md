# Instructions to run this repository

## Task 1
### Preprocessing
- We used the translation direction nl-de
- Word_level_model: In the folder `scripts` please run `subsample_tokenize.sh` to tokenize the train, test and dev data and to subsample 100,000 lines from training data, this bash file also creates the final train.nl, train.de etc. files under `data/my_lang_pair`.
- BPE model: In the folder `scripts` please run `subsample_tokenize_bpe.sh` to tokenize the train, test and dev data and to subsample 100,000 lines from training data

### Run BPE
- Depending on the vocabulary size, you either run `bpe_2000.sh` or `bpe_4000.sh`, where the commands are run to learn the bpe model and vocabulary, apply bpe with vocab filtering, create the final train.nl... files and finally the `joint_vocab.txt` file.

### Training the models
- Under the folder `configs` you will find a yaml file for each model in task 1 and the ones for task 2 with varying beam sizes.
- Run `./scripts/train.sh`, but change the model_name accordingly on line 19 beforehand.

### Evaluation
- Change the model name on line 26 and run `./scripts/evaluate.sh` to get the BLEU scores saved under the folder `bleu_scores`

### Create Table
- To create the final table please run `./scripts/create_table.sh` and it will be printed on your terminal.

### Troubleshooting
- If you get the message that you do not have permission to run a file, please, run `chmod +x FILEPATH`, before running the again.


## Task 2
### Beam Size evaluation
- For this, simply run `./scripts/beam_size_evaluation.sh` and the beam sizes, BLEU scores and the times get saved in a csv in the `bleu_scores` folder.

### Plotting
- Run `python scripts/plot.py` and the plots will be generated and saved under the folder `plots`


# Interpretations

## Task 1
```
Exp     | use BPE | vocabulary size | BLEU 
------  | ------- | --------------- | -----
(a)     | no      | 2000           | 3.50 
(b)     | yes     | 2000           | 6.00 
(c)     | yes     | 4000           | 7.40
```

### Word level model translations:
    Vor ein paar Jahren hat <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> zeigen <unk> <unk> <unk> <unk> <unk> <unk> zeigen .
    Die <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> .
    Die Idee ist ziemlich <unk> <unk> : <unk> <unk> <unk> von vier müssen <unk> <unk> mit <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> <unk> , <unk> <unk>     <unk> <unk> , einen Meter <unk> <unk> , einen <unk> <unk> <unk> , einen <unk> <unk> <unk> <unk> .
    Die <unk> <unk> <unk> <unk> <unk> muss <unk> <unk> .

### BPE 2k translations:
    V<unk> @ or ein<unk> @ igen Jahren hat P<unk> @ eter S<unk> @ k<unk> @ ill<unk> @ man hier bei TED , ein Desig<unk> @ n<unk> @ -<unk> @ Sch<unk> @ rei<unk> @ b<unk> @     st<unk> @ rei<unk> @ d .
    Die Mar<unk> @ s<unk> @ h<unk> @ m<unk> @ all<unk> @ o<unk> @ w<unk> @ -<unk> @ C<unk> @ all<unk> @ en<unk> @ ge .
    Die Idee ist ziemlich einfach : Gr<unk> @ ö<unk> @ e<unk> @ p<unk> @ fen : Gr<unk> @ ö<unk> @ e<unk> @ p<unk> @ fen von vier sol<unk> @ chen S<unk> @ pa<unk> @ g<unk>     @ het<unk> @ ti<unk> @ sch<unk> @ es Sp<unk> @ ag<unk> @ het<unk> @ ti<unk> @ -<unk> @ S<unk> @ pa<unk> @ g<unk> @ het<unk> @ ti<unk> @ -<unk> @ M<unk> @ et<unk> @        ern , ein M<unk> @ et<unk> @ ern und ein Mar<unk> @ s<unk> @ h<unk> @ m<unk> @ all<unk> @ o<unk> @ w .
    Der Mar<unk> @ s<unk> @ h<unk> @ m<unk> @ all<unk> @ o<unk> @ w muss dort o<unk> @ ben .

### BPE 4k translations:
    Vor ein paar Jahren hat P<unk> @ eter S<unk> @ k<unk> @ ill<unk> @ man hier bei TED , ein Desig<unk> @ n<unk> @ -<unk> @ W<unk> @ ett<unk> @ be<unk> @ wer<unk> @ b .
    Der Mar<unk> @ sh<unk> @ m<unk> @ all<unk> @ o<unk> @ w<unk> @ -<unk> @ Ch<unk> @ all<unk> @ en<unk> @ ge .
    Die Idee ist ziemlich einfa<unk> @ che : Die Gr<unk> @ ön<unk> @ e von vier so ho<unk> @ ch<unk> @ ar<unk> @ akter<unk> @ ist<unk> @ ischen Sp<unk> @ ag<unk> @            het<unk> @ t<unk> @ i , ein M<unk> @ eter T<unk> @ ap<unk> @ e , ein M<unk> @ eter T<unk> @ ap<unk> @ e , ein M<unk> @ eter T<unk> @ ap<unk> @ p , ein M<unk> @ eter       T<unk> @ ap<unk> @ p .
    Der Mar<unk> @ sh<unk> @ m<unk> @ all<unk> @ o<unk> @ w muss oben .

### Comments:
- The baseline word level model performed the worst as visible in the table. There is a heavy use of unknowns, since the vocabulary is very limited and thus the translations are not very feasible.
- The model, with BPE 2k use, increased the BLEU score to 6, showing an increase in vocabulary through subword-level modeling. However, there is still a lot of unknowns, since the vocabulary cut-off was set to 2,000.
- Finally, the model with BPE and a vocabulary threshold of 4,000, performed the best with a BLEU score of 7.4. In the translations, the mitigation of unknowns is further visible. This leads to a better token alignment and allows for smoother translations.

## Task 2

![Image](https://github.com/user-attachments/assets/fc9c9367-060a-42a2-a96a-c1cffaaa4da7)

### Score vs. Beam Size
- With the beam size, the BLEU score increases from 7.1 to 7.4, yet decreases starting from beam size 8 to 7.3 again.
- Therefore, starting from beam size 3, the scores plateau, since these do not provide better translations. We assume that it is due to over-searching or redundancy.

### Time vs. Beam Size
- There is a high second count at beam size 1, since model loading, tokenizer setuo and checkpoint loading are measured too for the first beam. Technically, beam size 1 should run the fastest, since it is the equivalent to doing **greedy decoding**. The other beam sizes behave as expected, the bigger the beam size, the longer it will take. It scales non-linearly (nearly 6x).

### Beam Size choice
- If regarding the time and the scores, beam size 3 seems to be the best choice.
- Beam size 1 would be the fastest, yet the BLEU score is too low, while anything above beam size 3 provides no BLEU gain and wastes time.
