# Building and Deploying Jupyter Notebooks User Runtime

## Deploying to Staging

```shell

cd jupyteruser-sd2e
git checkout development
git pull origin development
make develop && make tests
```

Go to http://localhost:8888/ and test. When you're satisfied, deploy to staging.

```shell
make staging
```

Go to http://jupyter-dev.sd2e.org/ and test. When you're satisfied, you can propose merge into master.

## Deploying to Production

```shell
cd jupyteruser-sd2e
git checkout master
git pull origin master
make develop && make tests

# test locally at http://localhost:8888/

make release && make pristine
```

Test and validate at https://jupyter-dot-sd2e-dot.org/. In the source repository, update the [change log](./CHANGELOG.md) and any documenation. Push back up to `master`.

