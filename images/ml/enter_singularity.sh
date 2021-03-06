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
else
	echo "No \$STOCKYARD detected - Not unpacking example notebooks or creating data symlinks"
fi

# Unpack jupyter config
#[ ! -e $HOME/.jupyter ] && tar -xzf /usr/share/sd2e/dotjupyter.tar.gz -C $HOME

# Delete any legacy configs
if [ -e $HOME/.jupyter ]; then
	rm -rf $HOME/.jupyter
fi

# Start the notebook
start-notebook.sh
