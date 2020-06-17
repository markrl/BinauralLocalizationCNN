#!/bin/sh

#SBATCH --time=7-00:00:00  # -- first number is days requested, second number is hours.  After this time the job is cancelled. 
#SBATCH --partition=normal
#SBATCH --mail-type=ALL # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=francl@mit.edu # -- use this to send an automated email when:
#SBATCH -o /home/francl/dataset_update/CNN_spherical_%A_%a.stdout
#SBATCH -e /home/francl/dataset_update/CNN_spherical_%A_%a.stder
#SBATCH --ntasks=1
#SBATCH -c 20
#SBATCH --mem=70G
#SBATCH --gres=gpu:QUADRORTX6000:1
#SBATCH --array=103,170,174,193,230,241,278,308,313,518


module add openmind/singularity/2.5.1

#Path to model folders
model_path=/om2/user/francl/new_task_archs/new_task_archs_anechoic_training
#Mdoel versions to test
model_version=200000,125000,150000,225000,250000,300000
#Arch numbers to test
offset=$SLURM_ARRAY_TASK_ID
#Arch initalized
initialization=0
#regularizer="tf.contrib.layers.l1_regularizer(scale=0.001)"
regularizer=None

testing=False
#Data to run through model
bkgd_train_path_pattern=/om/scratch/Wed/francl/bkgdRecords_textures_sparse_sampled_same_texture_expanded_set_44.1kHz_stackedCH_upsampled_anechoic/train*.tfrecords
train_path_pattern=/nobackup/scratch/Wed/francl/stimRecords_convolved_oldHRIRdist140_anechoic_no_hanning_stackedCH_upsampled/train*.tfrecords
all_positions_bkgd=False
background_textures=True
#SNR min/max (DEFAULT: 5/40)
SNR_min=5
SNR_max=40

#Used to chose output formatting
#divide azim/elev label by 10 if false
manually_added=False
#Parses record expecting frequency label if True
freq_label=False
#Parses SAM tones and associated labels
sam_tones=False
#Parses transposed tones and associated labels
transposed_tones=False
#Parses spatialized clickas and associated labels for precedence effect
precedence_effect=False
#Parses narrowband noise for pyschoacoustic experiments
narrowband_noise=False
#Parses record expecting [N,M,2] format instead of interleaved [2N,M] format if True
stacked_channel=True 



trainingID=$offset
init=$initialization
reg=$regularizer
bkgd=$bkgd_train_path_pattern
pattern=$train_path_pattern
model=$model_version

#singularity exec --nv -B /om -B /nobackup -B /om2 tfv1.5.simg python -u call_model_training.py $trainingID
#singularity exec --nv -B /om -B /nobackup -B /om2 tfv1.13_openmind.simg python -u call_model_testing_valid_pad.py $a
SINGULARITYENV_LD_PRELOAD=/usr/lib/libtcmalloc.so.4 singularity exec --nv -B /om -B /nobackup -B /om2 tfv1.13_tcmalloc.simg python -u call_model_training_valid_pad_francl.py $trainingID $init "$reg" "$bkgd" "$pattern" "$model" "$model_path" "$SNR_max" "$SNR_min" "$manually_added" "$freq_label" "$sam_tones" "$transposed_tones" "$precedence_effect" "$narrowband_noise" "$stacked_channel" "$all_positions_bkgd" "$background_textures" "$testing"
#SINGULARITYENV_LD_PRELOAD=/usr/lib/libtcmalloc.so.4 singularity exec --nv -B /om -B /nobackup -B /om2 tfv1.13_tcmalloc.simg python -u call_model_training_valid_pad.py $trainingID $init "$reg" "$bkgd" "$pattern"
