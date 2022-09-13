#!/bin/sh

#Path to model folders
# model_path=/om2/user/francl/new_task_archs/new_task_archs_no_background_noise_80dBSNR_training
model_path=/home/marklind/research/binaural/BinauralLocalizationCNN/weights
#Model versions to test
model_version=100000
#Arch initalized
initialization=0
#regularizer="tf.contrib.layers.l1_regularizer(scale=0.001)"
regularizer=None

testing=True
#Data to run through model
bkgd_train_path_pattern=/home/marklind/research/binaural/BinauralLocalizationCNN/binaural_localization_training_data/testset_record_subset/train*.tfrecords
train_path_pattern=/home/marklind/research/binaural/BinauralLocalizationCNN/binaural_localization_training_data/testset_record_subset/train*.tfrecords
all_positions_bkgd=False
background_textures=False
#SNR min/max (DEFAULT: 5/40)
SNR_min=80
SNR_max=80

#Used to chose output formatting
#divide azim/elev label by 10 if false
manually_added=False
#Parses record expecting frequency label if True
freq_label=False
#Parses SAM tones and associated labels
sam_tones=False
#Parses transposed tones and associated labels
transposed_tones=False
#Parses spatialized clicks and associated labels for precedence effect
precedence_effect=False
#Parses narrowband noise for pyschoacoustic experiments
narrowband_noise=False
#Parses record expecting [N,M,2] format instead of interleaved [2N,M] format if True
stacked_channel=True 



trainingID=0
init=$initialization
reg=$regularizer
bkgd=$bkgd_train_path_pattern
pattern=$train_path_pattern
model=$model_version

singularity exec --nv tfv1.13_tcmalloc.simg python -u call_model_training_valid_pad_francl.py $trainingID $init "$reg" "$bkgd" "$pattern" "$model" "$model_path" "$SNR_max" "$SNR_min" "$manually_added" "$freq_label" "$sam_tones" "$transposed_tones" "$precedence_effect" "$narrowband_noise" "$stacked_channel" "$all_positions_bkgd" "$background_textures" "$testing"
