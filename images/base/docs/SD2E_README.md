# SD2E Jupyter Notebook Environment

## Fileystem Map

```bash
/home/jupyter
├── examples - Exemplar Jupyter notebooks
├── sd2e-community - SD2 primary project data
├── sd2e-partners - Isolated storage for external partners
├── sd2e-projects - Isolated storage for approved projects
└── tacc-work - 1TB of persistent storage at TACC
```

* Data created in $HOME (/home/jupyter) will NOT be saved
* Store persistent data, such as notebooks or data sets in `tacc-work`
    * 1+ TB storage quota
    * High performance accessible across all TACC systems
    * Formerly _mydata_
    * Available via Agave API as `data-tacc-work-<username>`
* Access (read-only) primary project data in sd2e-community
    * Available via Agave API as `data-sd2e-community`
* Collaborate using the `data-sd2e-projects-users` Agave data resource

## Sharing Notebooks

* Find and share Jupyter notebooks with the sd2nb command in the Terminal
    * sd2nb usage

## Customizing the Jupyter environment

The Jupyter environment now supports persistent custom conda environments and jupyter kernels. This means you no longer have to submit an issue and wait on us if you need a specialized notebook environment, accelerating your work.

### Conda environments

By default, we have two conda environments

```bash
$ conda env list

# conda environments:
#
base                  *  /opt/conda (Python 3)
python2                  /opt/conda/envs/python2
```

New persistent environments, which will not be affected by server restarts, can be installed to a persistent location as follows

```bash
$ conda create -y -p $LOCAL_ENVS/tabsAreGreat python=2.7 ipykernel 'scipy==0.16.0'

# -y              - respond yes to all questions
# -p PATH         - prefix/name
# python=2.7      - python2 environment
# ipykernel       - required to make a kernel file later
# 'scipy==0.16.0' - scipy requirement
```

In this example, we created a new python 2 (`python=2.7`) environment called `tabsAreGreat` in the `$LOCAL_ENVS` directory that contains the `ipykernel` and `scipy==0.16.0` modules and all necessary dependencies.

```bash
$ conda env list

# conda environments:
#
tabsAreGreat             /home/jupyter/tacc-work/jupyter_packages/envs/tabsAreGreat
base                  *  /opt/conda
python2                  /opt/conda/envs/python2
```

This environment can now be utilized on the command line by entering the environment

```bash
$ conda activate tabsAreGreat
```

### New Jupyter kernels

If you want to use your new envrionment with a notebook, you but create a corresponding Jupyter kernel. To follow these directions, you must have the **ipykernel** module installed in your environment. This was one of our requirements in the `tabsAreGreat` example environment.

<img width="247" alt="original kernels" src="https://user-images.githubusercontent.com/6790115/38400287-0c2ccbc8-3915-11e8-9a80-08e7da97a790.png">

To create the kernel file, you need to call the `ipykernel` module using the absolute path to your custom python environment. The kernel should be installed (`--prefix`) to `$JUPYTER_WORK` which our Jupyter environment will automatically crawl for new kernels. The name (`--name`) should match your conda environment name (no spaces), but your display name should be human-readable and can contain spaces.

```bash
$ $LOCAL_ENVS/tabsAreGreat/bin/python -m ipykernel install \
    --prefix $JUPYTER_WORK \
    --name tabsAreGreat \
    --display-name "tabs are great"

# -m ipykernel install              - install a jupyter kernel
# --prefix $JUPYTER_WORK            - kernel installation path
# --name tabsAreGreat               - name of the kernel (no spaces)
# --display-name "tabs are great"   - the name that will display in the drop-down list
```

Once this is run, you can refresh your main Jupyter page, and you should see the following in your choice of kernels.

<img width="230" alt="new kernel" src="https://user-images.githubusercontent.com/6790115/38400720-20c60430-3917-11e8-93fb-5863b76d7e89.png">

Just remember that this kernel is specific to you and any collaborators will need to create their own to utilize any of your notebooks.

### Removing Jupyter kernels

When you no longer need a Jupyter kernel you created, you can remove it as follows

```bash
$ rm -rf $JUPYTER_WORK/share/jupyter/kernels/tabsaregreat
```

You can also remove all custom Jupyter kernels using

```bash
$ rm -rf $JUPYTER_WORK/share/jupyter/kernels
```

### Removing Conda environments

When you no longer need a custom conda environment, you can delete a specific one

```bash
$ rm -rf $LOCAL_ENVS/tabsAreGreat
```

or all of them

```bash
$ rm -rf $LOCAL_ENVS
```

## API integration

* TACC Cloud CLI is pre-configured with your credentials
* AgavePy Python 2.7.x library is pre-conigured with your credentials

Learn more about collaborating using Agave Cloud APIs
- http://sd2e.org/api-user-guide/

Latest notebook documentation
- https://github.com/SD2E/jupyteruser-sd2e/blob/master/README.md

Latest notebook issue log
- https://github.com/SD2E/jupyteruser-sd2e/issues

Learn more about sharing notebooks
- https://github.com/SD2E/sd2nb-app/blob/master/README.md

## Get Help
- Web: https://sd2e.org/tickets/
- Email: support@sd2e.org
- Slack: https://sd2e.slack.com/messages/cyberinfrastructure
