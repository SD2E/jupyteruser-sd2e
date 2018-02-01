# Contribute to jupyteruser-sd2e

If you find that the SD2E jupyter environment lacks some

 - tools
 - libraries
 - packages
 - examples

that the community would benefit from, here is a guide on getting it incorporated.

## Propose work

* Raise an issue \([link](https://github.com/SD2E/jupyteruser-sd2e/issues)\):
  * Describing a proposed change/update/improvement/fix (we provide a nice template).
    * List and link the software \(required\)
      * boost >= 1.58 - (http://www.boost.org/users/download/)
      * python boost >= 0.1
    * List any known dependencies
      * C++
  * If you have one (even just an idea) provide an implementation plan
    * `apt-get install foo`
    * `pip install foo`
  * Let us know how we can verify the software installation
    * Sample commands
    * Example notebooks

## Contribute work

While not necessary, you can also locally develop and test your own feature for integration. When you are satisfied, you can then submit a pull request for integration into the main SD2E repository.

### Fork the repository

While the project is open, we restrict the ability to commit code. Begin by forking

![fork](https://upload.wikimedia.org/wikipedia/commons/3/38/GitHub_Fork_Button.png)

our repository to your own user account on github. This is necessary so we can see the remote repository to pull your changes from. Github cannot pull from your laptop.

### Clone YOUR repository

Clone a local copy of **your** repository

```
git clone https://github.com/[your_name_hear]/jupyteruser-sd2e.git
```

and then make a new branch (`myFeature`) for your feature based on the `development` branch.

```
git checkout -b myFeature development
```

### Incorporate your changes

Please add any external example or configuration files in a descriptive folder in

```
images/custom/
```

and add a new section at the end of the main `Dockerfile` in

```
images/custom/Dockerfile
```

for your code immediately **before** the permissiosn section.

### Build and Test your changes

Build your modified container from the **root** `jupyteruser-sd2e` directory using the (hopefully) helpful make commands

```
sudo make clean
sudo make build sd2e
```

If your build succeeds, you can then test with

```
sudo make test sd2e
```

Visit your local jupyter environment using either the localhost URL if on your own computer, or the external URL if testing in the cloud.

### Submit pull request

When done testing, commit and push your changes to your personal fork of the repository. Then, you can create a pull request against the SD2E `development` branch. Once again, we provide a template to help populate the necessary information about your changes.

After we review and accept your pull request:
  * A Docker image will be built from your code and will be available in about an hour on the test Jupyter server
    * https://jupyter-staging.sd2e.org/
  * Both the SD2E development team and you must review and validate
    * The updated/new functionality
    * Completeness and correctness of provided documenation
* The code will be merged into `master` and used to build the production SD2E Jupyter Notebooks image
    * The updated image will be live in around a day on the production cluster

## Legal-ish stuff

* By contributing you are certifying that you have authorization to contribute code and/or docs under the project's permissive [3-Clause BSD license](./LICENSE.md)
