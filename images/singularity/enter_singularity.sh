#!/bin/bash

# Check to see if work defined
if [ -n "$STOCKYARD2" ]; then

	# Work is defined
	if [ ! -e $STOCKYARD2/jupyter ]; then
        echo "Unpacking example notebooks"
		tar -xzf $SD2E_DIR/home_archive.tar.gz -C $STOCKYARD2
	fi

	# Change to jupyter directory if it exists
	echo "Changing to SD2E notebook directory"
	cd $STOCKYARD2/jupyter

	# Create work and project data symlinks if they don't exist in $STOCKYARD2/jupyter
	if [ ! -e "$STOCKYARD2/jupyter/tacc-work" ]; then
		echo "Creating symlink for tacc-work"
		ln -s ../ $STOCKYARD2/jupyter/tacc-work
	fi

    SD2E_COMM_LINK="$STOCKYARD2/jupyter/sd2e-community"
	if [ ! -e "$SD2E_COMM_LINK" ]; then
		echo "Creating symlink for sd2e-community"
		ln -s /work2/projects/SD2E-Community/prod/data/ $SD2E_COMM_LINK
    elif [ -L "$SD2E_COMM_LINK" ] && [ "$(readlink -f $SD2E_COMM_LINK)" == "/work/projects/SD2E-Community/prod/data" ]; then
		echo "Moving symlink for sd2e-community"
        rm $SD2E_COMM_LINK
		ln -s /work2/projects/SD2E-Community/prod/data/ $SD2E_COMM_LINK
	fi

    SD2E_PROJ_LINK="$STOCKYARD2/jupyter/sd2e-projects"
	if [ ! -e "$SD2E_PROJ_LINK" ]; then
		echo "Creating symlink for sd2e-projects"
		ln -s /work2/projects/SD2E-Community/prod/projects $SD2E_PROJ_LINK
    elif [ -L "$SD2E_PROJ_LINK" ] && [ "$(readlink -f $SD2E_PROJ_LINK)" == "/work/projects/SD2E-Community/prod/projects" ]; then
		echo "Moving symlink for sd2e-projects"
        rm $SD2E_PROJ_LINK
		ln -s /work2/projects/SD2E-Community/prod/projects $SD2E_PROJ_LINK
	fi

    SD2E_PART_LINK="$STOCKYARD2/jupyter/sd2e-partners"
	if [ ! -e "$SD2E_PART_LINK" ]; then
		echo "Creating symlink for sd2e-partners"
		ln -s /work2/projects/DARPA-SD2-Partners $STOCKYARD2/jupyter/sd2e-partners
    elif [ -L "$SD2E_PART_LINK" ] && [ "$(readlink -f $SD2E_PART_LINK)" == "/work/projects/DARPA-SD2-Partners" ]; then
		echo "Moving symlink for sd2e-projects"
        rm $SD2E_PART_LINK
		ln -s /work2/projects/DARPA-SD2-Partners $STOCKYARD2/jupyter/sd2e-partners
	fi

	# Update environment variables based on STOCKYARD, temp hack 1/22/2021
	export PYTHONUSERBASE="$STOCKYARD2/jupyter_packages"
	export JUPYTER_PATH="$STOCKYARD2/jupyter_packages/share/jupyter:"
	export JUPYTER_WORK="$STOCKYARD2/jupyter_packages"
	export LOCAL_ENVS="$STOCKYARD2/jupyter_packages/envs"
	export CONDA_ENVS_PATH="$STOCKYARD2/jupyter_packages/envs:"
	export CONDA_PKGS_DIRS="$STOCKYARD2/jupyter_packages/pkgs"
else
	echo "No \$STOCKYARD2 detected - Not unpacking example notebooks or creating data symlinks"
	export STOCKYARD2=${SCRATCH:=${HOME}}

	# Work is defined
	if [ ! -e $STOCKYARD2/jupyter ]; then
        echo "Unpacking example notebooks"
		tar -xzf $SD2E_DIR/home_archive.tar.gz -C $STOCKYARD2
	fi

	# Change to jupyter directory if it exists
	echo "Changing to SD2E notebook directory"
	cd $STOCKYARD2/jupyter
fi

export HOME=$STOCKYARD2/jupyter

# Unpack jupyter config
#[ ! -e $HOME/.jupyter ] && tar -xzf /usr/share/sd2e/dotjupyter.tar.gz -C $HOME

# Delete any legacy configs
for dir in ~/.jupyter ${HOME}/.jupyter; do
	echo $dir
	if [ -e $dir ]; then rm -rf $dir; fi
done

echo $STOCKYARD2

# Start the notebook
start-notebook.sh "$@"
