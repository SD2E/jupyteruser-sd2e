# SD2E Jupyter Notebook Environment

## Fileystem Map

```
/home/jupyter
├── cli - TACC cloud CLI
├── examples - Exemplar Jupyter notebooks
├── sd2e-community - SD2 primary project data
|____reference
| |____examples
| | |____jupyter - Additional data sets and exemplar notebooks
└── tacc-work - Your TACC work directory
```

* Store persistent data, such as notebooks or data sets in tacc-work
    * 1+ TB storage quota
    * High performance accessible across all TACC systems
    * Formerly _mydata_
    * Available via Agave API as data-tacc-work-<username>
* Access (read-only) primary project data in sd2e-community
    * Available via Agave API as data-sd2e-community
* Collaborate using the data-sd2e-projects-users Agave data resource

## Sharing Notebooks

* Find and share Jupyter notebooks with the sd2nb command in the Terminal
    * sd2nb usage

## API integration

* TACC Cloud CLI is pre-configured with your credentials
* AgavePy Python 2.7.x library is pre-conigured with your credentials

Learn more about collaborating using Agave Cloud APIs
- http://sd2e.org/api-user-guide/

Latest notebook documentation
- https://github.com/SD2E/jupyteruser-sd2e/README.md

Latest notebook issue log
- https://github.com/SD2E/jupyteruser-sd2e/issues

Get Help
- support@sd2e.org
