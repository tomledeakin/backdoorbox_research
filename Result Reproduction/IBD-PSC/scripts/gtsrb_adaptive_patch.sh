#!/bin/bash
#SBATCH --job-name=gtsrb_adaptive_patch                         # Job name
#SBATCH --output=scripts/gtsrb_adaptive_patch_output.log        # Output file
#SBATCH --error=scripts/gtsrb_adaptive_patch_error.log          # Error file
#SBATCH --partition=gpu                                         # Use GPU partition
#SBATCH --gres=gpu:a100:1                                       # Request 1 A100 GPU
#SBATCH --time=06:00:00                                         # Max runtime

# Move to the directory containing the environment
cd "$HOME/BackdoorBox Research/backdoor-toolbox"
source "my_env/bin/activate"

# Step 1: Create poisoned training set
echo "Creating poisoned training set for adaptive_patch on gtsrb..."
python create_poisoned_set.py -dataset=gtsrb -poison_type=adaptive_patch -poison_rate=0.01

# Step 2: Train the model on the poisoned dataset
echo "Training the model on the poisoned dataset..."
python train_on_poisoned_set.py -dataset=gtsrb -poison_type=adaptive_patch -poison_rate=0.01

# Step 3: Test the backdoor model
echo "Testing the backdoor model..."
python test_model.py -dataset=gtsrb -poison_type=adaptive_patch -poison_rate=0.01

# Step 4: Visualize the model's latent space with various methods
echo "Visualizing the model's latent space..."
methods=("umap")
for method in "${methods[@]}"; do
    echo "Using method: $method"
    python umap_visualize.py -method=$method -dataset=gtsrb -poison_type=adaptive_patch -poison_rate=0.01
done


echo "Experiment for gtsrb with adaptive_patch completed."
