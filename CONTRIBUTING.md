# Contribute to jupyteruser-sd2e

Have an idea for what our base Jupyter Notebooks environment needs in it? Here's how to make it happen!

* Raise an issue describing your proposed change/update/improvement/fix and what you plan to do
* To contribute, fork this repo and pull it down locally
* Checkout a new branch named after the Github issue documenting the bug you're fixing or feature you're adding
* Do development and testing locally against the ':devel' tag
* Push your branch to your Github fork when you're ready to integrate it
* Submit a Pull Request against the `development` branch
* Your PR will be reviewed:
  * A Docker image will be built from your code and deployed to a staging server
  * Both the SD2E development team and you will review and validate its function
* The code will be merged into `master` and used to build the production SD2E Jupyter Notebooks image
