# Building and Deploying Jupyter Notebooks User Runtime

## Building a local image

```shell

cd jupyteruser-sd2e
git checkout development
git pull origin development
```
You can either build the base image
```
sudo make build base
```
without contributated software stacks, or the full SD2E image.
```
sudo make build sd2e
```
Please make sure to increment the `Version:` in whichever `Dockerfile` you contribute to.

## Testing
Test the image and software locally by launching the notebook server using
```
sudo make test sd2e
```
You can test either `base` or `sd2e`. Either visit the localhost address in your browser if working from your local machine, or the external IP address if working from a cloud system.

## Test in staging
Push the image to dockerhub (SD2E admin only) and tag as `staging` to be built automatically by the staging environment.
```
sudo make staging sd2e
```
Both the developer and SD2E admin need to set the environment at (https://jupyter-staging.sd2e.org) before being pushed to production.

## Deploy to production
Push an image that passes tests in staging to production with
```
sudo make release sd2e
```
which tags the image as latest for the production environment to pick up.
