# SD2E Jupyter Notebook Environment

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

* Store persistent data, such as notebooks or data sets in tacc-work.
    * 1+ TB storage quota
    * High performance accessible across all TACC systems
    * Formerly _mydata_
    * Available via Agave API as data-tacc-work-<username>
* Access (read-only) primary project data in sd2e-community
    * Available via Agave API as data-sd2e-community
* Collaborate using the data-sd2e-projects-users Agave data resource

Learn more about collaborating using Agave Cloud APIs
- http://sd2e.org/api-user-guide/

Latest notebook documentation and issue log
- https://github.com/SD2E/jupyteruser-sd2e

Get Help
- support@sd2e.org
