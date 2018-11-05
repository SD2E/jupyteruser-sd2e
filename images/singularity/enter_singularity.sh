#!/bin/bash

# Check to see if work defined
if [ -n "$STOCKYARD" ]; then
	# Work is defined
	if [ -e $STOCKYARD/jupyter ]; then
		echo "Example notebooks already detected. To refresh them, delete\n   \$STOCKYARD/jupyter"
	else
		echo "Unpacking example notebooks"
		tar -xzf $SD2E_DIR/home_archive.tar.gz -C $STOCKYARD
	fi
else
	echo "No \$STOCKYARD detected - Not unpacking example notebooks"
fi

# Unpack jupyter config
#[ ! -e $HOME/.jupyter ] && tar -xzf /usr/share/sd2e/dotjupyter.tar.gz -C $HOME

# Change to jupyter directory if it exists
if [ -n "$STOCKYARD" ]; then
	echo "Changing to SD2E notebook directory"
	cd $STOCKYARD/jupyter
fi

# Create work and project data symlinks if they don't exist in $STOCKYARD/jupyter
if [ ! -e "$STOCKYARD/jupyter/tacc-work" ]; then
	echo "Creating symlink for tacc-work"
	ln -s ../ $STOCKYARD/jupyter/tacc-work
fi

if [ ! -e "$STOCKYARD/jupyter/sd2e-community" ]; then
	echo "Creating symlink for sd2e-community"
	ln -s /work/projects/SD2E-Community/prod/data/ $STOCKYARD/jupyter/sd2e-community
fi

# Delete any legacy configs
if [ -e $HOME/.jupyter ]; then
	rm -rf $HOME/.jupyter
fi

# Start the notebook
start-notebook.sh
