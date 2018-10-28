./par_wrappers/:
Contains wrapper scripts for finding doublets or triplets, using various strategies. Wrappers use parfor to find combinations efficienty. 

Other scripts in this folder are for finding either doublets or triplets, using various strategies and either the face-box or the wedge criterion. These scripts get called by wrappers in the ./par_wrappers/ folder. Start there and see which ones are called.

Current best used code is CUR_genDoublets_norep.m. See inside for instructions.