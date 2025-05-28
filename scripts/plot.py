########IMPORTS##################
import pandas as pd
import matplotlib.pyplot as plt
########IMPORTS##################

# First the file is read
results = pd.read_csv("bleu_scores/bpe_4k_model_beam_search_results.csv")

colors = ["red", "pink", "blue", "purple", "green", "orange", "brown", "grey", "yellow", "lightblue"]

_, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 8))
p1 = ax1.bar(results["beam_size"], results["bleu"], width=0.8, color=colors)
ax1.set_title("Model Beam Size compared to BLEU Score")
ax1.set(xlabel='Beam Size', ylabel='BLEU Score')
ax1.bar_label(p1, label_type='center')
p2 = ax2.bar(results["beam_size"], results["time_seconds"], width=0.8, color=colors)
ax2.set_title("Model Beam Size compared to Time")
ax2.set(xlabel='Beam Size', ylabel='Time (s)')
ax2.bar_label(p2, label_type='center')

plt.savefig("plots/beamsize_bleu_time_plot.png")
