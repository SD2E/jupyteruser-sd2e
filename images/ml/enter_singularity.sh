#!/bin/bash

# Check to see if work defined
if [ -n "$STOCKYARD" ]; then

	# Work is defined
	if [ ! -e $STOCKYARD/jupyter ]; then
		mkdir -p $STOCKYARD/jupyter
	fi

	# Change to jupyter directory if it exists
	echo "Changing to SD2E notebook directory"
	cd $STOCKYARD/jupyter

	# Create work and project data symlinks if they don't exist in $STOCKYARD/jupyter
	if [ ! -e "$STOCKYARD/jupyter/tacc-work" ]; then
		echo "Creating symlink for tacc-work"
		ln -s ../ $STOCKYARD/jupyter/tacc-work
	fi

	if [ ! -e "$STOCKYARD/jupyter/sd2e-community" ]; then
		echo "Creating symlink for sd2e-community"
		ln -s /work/projects/SD2E-Community/prod/data/ $STOCKYARD/jupyter/sd2e-community
	fi

	if [ ! -e "$STOCKYARD/jupyter/sd2e-projects" ]; then
		echo "Creating symlink for sd2e-projects"
		ln -s /work/projects/SD2E-Community/prod/projects $STOCKYARD/jupyter/sd2e-projects
	fi

	if [ ! -e "$STOCKYARD/jupyter/sd2e-partners" ]; then
		echo "Creating symlink for sd2e-partners"
		ln -s /work/projects/DARPA-SD2-Partners $STOCKYARD/jupyter/sd2e-partners
	fi

	# Update environment variables based on STOCKYARD, temp hack 1/22/2021
	export PYTHONUSERBASE="$STOCKYARD/jupyter_packages"
	export JUPYTER_PATH="$STOCKYARD/jupyter_packages/share/jupyter:"
	export JUPYTER_WORK="$STOCKYARD/jupyter_packages"
	export LOCAL_ENVS="$STOCKYARD/jupyter_packages/envs"
	export CONDA_ENVS_PATH="$STOCKYARD/jupyter_packages/envs:"
	export CONDA_PKGS_DIRS="$STOCKYARD/jupyter_packages/pkgs"
else
	echo "No \$STOCKYARD detected - Not unpacking example notebooks or creating data symlinks"
	export STOCKYARD=${SCRATCH:=${HOME}}

	# Work is defined
	if [ ! -e $STOCKYARD/jupyter ]; then
		mkdir -p $STOCKYARD/jupyter
	fi

	# Change to jupyter directory if it exists
	echo "Changing to SD2E notebook directory"
	cd $STOCKYARD/jupyter
fi

export HOME=$STOCKYARD/jupyter

# Unpack jupyter config
#[ ! -e $HOME/.jupyter ] && tar -xzf /usr/share/sd2e/dotjupyter.tar.gz -C $HOME

# Delete any legacy configs
for dir in ~/.jupyter ${HOME}/.jupyter; do
	echo $dir
	if [ -e $dir ]; then rm -rf $dir; fi
done

echo $STOCKYARD

# Start the notebook
start-notebook.sh
