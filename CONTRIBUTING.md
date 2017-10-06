# Contribute to jupyteruser-sd2e

Have an idea for what our base Jupyter Notebooks environment needs in it? Here's how to make it happen!

## Propose work

* Raise an issue:
    * Describing a proposed change/update/improvement/fix (we provide a nice template).
    * If you have one (even just an idea) provide an implementation plan
    * Include thoughts about how to test the new feature, as well as how it will be communicated to end users

## Contribute work

* To contribute, fork this repo and pull it down locally
* Checkout a new branch named after the Github issue documenting the bug you're fixing or feature you're adding
* Do development and testing locally against the ':devel' tag
* Push your branch to your Github fork when you're ready to integrate it
* Submit a Pull Request against the `development` branch
* Your PR will be reviewed:
  * A Docker image will be built from your code and will be available shortly thereafter on the [test Jupyter server](https://jupyter-staging.sd2e.org/)
  * Both the SD2E development team and you must review and validate
    * The updated/new functionality
    * Completeness and correctness provided documenation
* The code will be merged into `master` and used to build the production SD2E Jupyter Notebooks image
    * The updated image will be live in around an hour on the production cluster

## Legal-ish stuff

* By contributing you are certifying that you have authorization to contribute code and/or docs under the project's permissive [3-Clause BSD license](./LICENSE.md)
