Estimating the latent social distancing effect in Australia in response to COVID-19 from multiple mobility datastreams.


## Development

### Requirements

- R 4.x
- Python 3.7.x (see Tensorflow section below for why)  

There is [renv](https://rstudio.github.io/renv/index.html) support. Starting an `R` instance in the 
root of the repository will automatically install and load renv via the `.Rprofile` file. As long as 
there is a `python3.7` binary on your path it should automatically create a virtual env in 
`renv/python/virtualenvs`. Once started run `renv::restore()` to ensure the
right versions of both the Python and R dependencies are installed. See the renv docuemntion for how
to update and add dependencies.

###### Tensorflow and Python Versions

As Gerta requires Tensorflow 1.14.0 we're limited to versions of Python for which wheels are published
this places a practical cap at 3.7. Python 3.8 and up only support Tensorflow 2. This is causes some 
problems as Python 3.8 as is the default version of Python3 on many systems now. It is possible to 
build Python from source but it must be built with shared library support to work with reticulate.       
