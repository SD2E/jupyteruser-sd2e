# Testing out your changes

After you've added software or updated configurations at `images/custom`, you can and should test in a local instance of Jupyter Notebooks. We've made this really easy for you. You can either leverage the extensive Makefile support for building and testing an updated user image, or manually drive the process. There's a Docker Compose setup inside `tests` and the names of the container images you need to build if you're doing this by hand should be quite obvious.

*Before you issue a PR, you must have tested locally*
