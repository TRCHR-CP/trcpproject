FROM rocker/rstudio:4.5.1


RUN sed -i 's|http://archive.ubuntu.com|https://archive.ubuntu.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|https://security.ubuntu.com|g' /etc/apt/sources.list

# Install system dependencies
#RUN apt-get update && apt-get install -y \
#    libcurl4-openssl-dev \
 #   libssl-dev \
 #   libxml2-dev \
 #   libfontconfig1-dev \
 #   libharfbuzz-dev \ etc was before when it still worked
 

# Install system dependencies
RUN sed -i 's|http://archive.ubuntu.com|https://archive.ubuntu.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|https://security.ubuntu.com|g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgsl-dev \
    libgmp-dev \
    libmpfr-dev \
    libglu1-mesa-dev \
    libgl1-mesa-dev \
    libx11-dev \
    libxt-dev \
    libcairo2-dev \
    libssh2-1-dev \
    libsasl2-dev \
    unixodbc-dev \
    libpq-dev \
    default-libmysqlclient-dev \
    libgdal-dev \
    libudunits2-dev \
    libproj-dev \
    libgeos-dev \
    libv8-dev \
    libsodium-dev \
    libjq-dev \
    libprotobuf-dev \
    protobuf-compiler \
    openjdk-11-jdk \
    cmake \
    libmagick++-dev \
    ffmpeg \
    libavfilter-dev \
    cargo \
    && rm -rf /var/lib/apt/lists/*

# Configure Java
RUN R CMD javareconf

# Install BiocManager first (needed for Bioconductor packages)
RUN R -e "install.packages('BiocManager')"

# Install Bioconductor packages
RUN R -e "BiocManager::install(c('Biobase', 'BiocGenerics', 'BiocParallel', 'BiocVersion', 'AnnotationDbi', 'biomaRt', 'genefilter', 'graph', 'IRanges', 'S4Vectors', 'Rgraphviz', 'KEGGgraph', 'BiocFileCache'))"

# Install CRAN packages in batches (to avoid timeout issues)
# Batch 1: Core dependencies
RUN R -e "install.packages(c('Rcpp', 'RcppArmadillo', 'RcppEigen', 'RcppParallel', 'BH', 'data.table', 'dplyr', 'ggplot2', 'tidyr', 'purrr', 'readr', 'tibble', 'stringr', 'forcats', 'lubridate'))"

# Batch 2: Statistical and modeling packages
RUN R -e "install.packages(c('lme4', 'nlme', 'mgcv', 'survival', 'Matrix', 'lattice', 'MASS', 'boot', 'cluster', 'nnet', 'rpart', 'class', 'foreign', 'KernSmooth', 'spatial', 'caret', 'randomForest', 'glmnet', 'gbm', 'xgboost', 'ranger', 'earth', 'kernlab', 'e1071'))"

# Batch 3: Machine learning and data mining
RUN R -e "install.packages(c('mlr', 'partykit', 'party', 'C50', 'Cubist', 'bartMachine', 'bartMachineJARs', 'ada', 'adabag', 'mboost', 'gamboostLSS', 'evtree', 'extraTrees', 'rFerns', 'kknn', 'naivebayes', 'FNN', 'SuperLearner', 'neuralnet', 'deepnet', 'RSNNS'))"

# Batch 4: Survival analysis
RUN R -e "install.packages(c('survAUC', 'prodlim', 'pec', 'riskRegression', 'dynpred', 'mstate', 'flexsurv', 'msm', 'muhaz', 'timereg', 'eha', 'cmprsk', 'crskdiag'))"

# Batch 5: Causal inference and matching
RUN R -e "install.packages(c('Matching', 'MatchIt', 'MatchThem', 'WeightIt', 'optmatch', 'optweight', 'cobalt', 'designmatch', 'ebal', 'CBPS', 'cem', 'ATE', 'twang', 'sbw', 'rcbalance'))"

# Batch 6: Survey and missing data
RUN R -e "install.packages(c('survey', 'mice', 'mi', 'Amelia', 'missForest', 'VIM', 'hot.deck', 'miceadds', 'imputeR', 'simputation', 'mitools'))"

# Batch 7: Psychometrics and education
RUN R -e "install.packages(c('psychotools', 'psychotree', 'psych', 'psychTools', 'CDM', 'sirt', 'TAM', 'mirt', 'BIFIEsurvey'))"

# Batch 8: Graphics and visualization
RUN R -e "install.packages(c('plotly', 'DT', 'leaflet', 'visNetwork', 'DiagrammeR', 'ggpubr', 'GGally', 'ggExtra', 'ggforce', 'ggrepel', 'ggridges', 'ggsci', 'ggsignif', 'ggRandomForests', 'cowplot', 'patchwork', 'gridExtra', 'RColorBrewer', 'viridis', 'colourpicker'))"

# Batch 9: Spatial analysis
RUN R -e "install.packages(c('sp', 'sf', 'rgdal', 'raster', 'maptools', 'maps', 'mapproj', 'spatstat', 'splancs', 'geosphere', 'units'))"

# Batch 10: Time series
RUN R -e "install.packages(c('forecast', 'tseries', 'xts', 'zoo', 'timeDate', 'fds', 'TSP', 'tsfeatures'))"

# Batch 11: Bayesian and MCMC
RUN R -e "install.packages(c('rstan', 'StanHeaders', 'MCMCpack', 'MCMCglmm', 'mcmc', 'BayesX', 'JM', 'JMbayes2'))"

# Batch 12: SEM and factor analysis
RUN R -e "install.packages(c('lavaan', 'sem', 'semTools', 'OpenMx', 'GPArotation', 'psych'))"

# Batch 13: Network analysis
RUN R -e "install.packages(c('igraph', 'network', 'sna', 'statnet.common', 'qgraph', 'intergraph'))"

# Batch 14: Text and NLP
RUN R -e "install.packages(c('tm', 'topicmodels', 'quanteda', 'spacyr', 'tidytext', 'textclean'))"

# Batch 15: Databases
RUN R -e "install.packages(c('DBI', 'RSQLite', 'RMariaDB', 'RPostgres', 'RODBC', 'dbplyr'))"

# Batch 16: Web and APIs
RUN R -e "install.packages(c('httr', 'curl', 'jsonlite', 'xml2', 'XML', 'rvest', 'RCurl', 'V8'))"

# Batch 17: Shiny and reporting
RUN R -e "install.packages(c('shiny', 'shinyjs', 'rmarkdown', 'knitr', 'bookdown', 'blogdown', 'pagedown', 'xaringan', 'revealjs', 'distill', 'rticles', 'tufte', 'kableExtra', 'flexdashboard'))"

# Batch 18: Development tools
RUN R -e "install.packages(c('devtools', 'usethis', 'pkgdown', 'testthat', 'roxygen2', 'rcmdcheck', 'covr', 'profvis', 'microbenchmark'))"

# Batch 19: Tidymodels ecosystem
RUN R -e "install.packages(c('tidymodels', 'parsnip', 'recipes', 'workflows', 'tune', 'dials', 'yardstick', 'rsample', 'modeldata', 'hardhat', 'infer'))"

# Batch 20: Remaining packages (alphabetically sorted for easier tracking)
RUN R -e "install.packages(c('abind', 'acepack', 'AER', 'akima', 'alphahull', 'alphashape3d', 'alr', 'alr4', 'AmesHousing', 'aod', 'ape', 'aplpack', 'arm', 'arrow', 'ash', 'AsioHeaders', 'askpass', 'assertthat', 'AUC', 'av', 'backports', 'base64enc', 'base64url', 'BatchJobs', 'batchtools', 'BBmisc', 'BDgraph', 'bestglm', 'betareg', 'BiasedUrn', 'biglasso', 'biglm', 'bigmemory', 'bigmemory.sri', 'bit', 'bit64', 'bitops', 'BlandAltmanLeh', 'blme', 'blob', 'bnlearn', 'brew', 'brglm', 'brglm2', 'brio', 'brnn', 'broom', 'broom.helpers', 'broom.mixed', 'bslib', 'bst'))"

RUN R -e "install.packages(c('ca', 'cachem', 'callr', 'car', 'carData', 'care', 'caTools', 'cellranger', 'checkmate', 'chemometrics', 'chron', 'circlize', 'Ckmeans.1d.dp', 'classInt', 'cli', 'clipr', 'clue', 'ClusterR', 'clusterSim', 'cmaes', 'cmaesr', 'cmm', 'coda', 'coin', 'colorspace', 'combinat', 'commonmark', 'CompQuadForm', 'config', 'conflicted', 'conquer', 'corpcor', 'corrplot', 'CoxBoost', 'cpp11', 'crayon', 'credentials', 'crosstalk', 'crs', 'cubature', 'cubelyr'))"

RUN R -e "install.packages(c('cvAUC', 'cvTools', 'cyclocomp', 'data.tree', 'datetimeutils', 'dbarts', 'dbscan', 'deldir', 'dendextend', 'DEoptimR', 'Deriv', 'desc', 'DescTools', 'deSolve', 'dfidx', 'dfoptim', 'dgof', 'DiceDesign', 'DiceKriging', 'diffobj', 'digest', 'diptest', 'DiscriMiner','dlookr', 'docopt', 'doMC', 'doParallel', 'dotCall64', 'downlit', 'downloader', 'dtplyr', 'duckdb', 'dunn.test', 'dygraphs'))"

RUN R -e "install.packages(c('elasticnet', 'ellipse', 'ellipsis', 'EMCluster', 'emmeans', 'emoa', 'EMT', 'enrichwith', 'entropy', 'Epi', 'estimability', 'etm', 'evaluate', 'Exact', 'expm', 'extrafont', 'extrafontdb', 'factoextra', 'FactoMineR', 'fansi', 'farver', 'fastGHQuad', 'fastmap', 'fastmatch', 'fda', 'fda.usc', 'fdapace', 'FDboost', 'fdrtool', 'fields', 'flashClust', 'flexclust', 'flexmix', 'float', 'fontBitstreamVera', 'fontcm', 'fontLiberation', 'fontquiver', 'foreach', 'formatR', 'formattable', 'Formula', 'fpc', 'fpca', 'fracdiff', 'frbs', 'freetypeharfbuzz', 'fs', 'FSA', 'FSelector', 'FSelectorRcpp', 'fst', 'funFEM', 'funHDDC', 'furrr', 'futile.logger', 'futile.options', 'future'))"

RUN R -e "install.packages(c('gam', 'gamlss', 'gamlss.data', 'gamlss.dist', 'gamm4', 'gapminder', 'gbRd', 'gclus', 'gdtools', 'geepack','ggeffects', 'generics', 'GenSA', 'geometry', 'gert', 'getopt', 'gh', 'gifski', 'gitcreds', 'glasso', 'gld', 'GLMMadaptive', 'glmulti', 'GlobalOptions', 'globals', 'glue', 'gmp', 'gnm', 'gof', 'goftest', 'goftte', 'gower', 'GPfit', 'gplots', 'gridGraphics', 'grouped', 'grplasso', 'grpreg', 'gsl', 'gsubfn', 'gtable', 'gtools', 'h2o', 'haven', 'hdi', 'hdrcde', 'heplots', 'hexbin', 'highr', 'Hmisc', 'hms', 'htmlTable', 'htmltools', 'htmlwidgets', 'httpuv', 'huge', 'hunspell'))"

RUN R -e "install.packages(c('imbalance', 'ini', 'inline', 'insight', 'interp', 'inum', 'ipred', 'irace', 'IRdisplay', 'isoband', 'iterators', 'itertools', 'jpeg', 'jquerylib', 'js', 'kmi', 'kohonen', 'ks', 'labdsv', 'labeling', 'labelled', 'laeken', 'laGP', 'Lahman', 'lambda.r', 'lars', 'lasso2', 'later', 'latticeExtra', 'lava', 'lazyeval', 'leaflet.providers', 'leaps', 'lhs', 'libcoin', 'LiblineaR', 'lifecycle', 'linprog', 'lintr', 'listenv', 'littler', 'lmom', 'lmtest','lmerTest', 'locfit', 'lpSolve', 'lpSolveAPI', 'magic', 'magick', 'magrittr', 'manipulateWidget', 'markdown', 'matrixcalc', 'MatrixModels', 'matrixStats', 'maxLik', 'MBESS', 'mclust', 'mco', 'mda', 'mdmb', 'measures', 'memoise', 'meta', 'metafor', 'metaLik', 'mets', 'MIICD', 'mime', 'miniUI', 'minqa', 'mipfp', 'misc3d', 'miscTools', 'mixOmics', 'mlbench', 'mldr', 'mlogit', 'mlrMBO', 'mmpf', 'mnormt', 'MNP', 'ModelMetrics', 'modelr', 'modeltools', 'mRMRe', 'multcomp', 'multcompView', 'multicool', 'munsell', 'mvna', 'mvnormtest', 'mvoutlier', 'mvtnorm'))"

RUN R -e "install.packages(c('NADA', 'ncvreg', 'nleqslv', 'nloptr', 'nnls', 'nodeHarvest', 'nortest', 'np', 'numDeriv', 'nycflights13', 'openssl', 'openxlsx', 'optimParallel', 'optparse', 'ordinal', 'orientlib', 'osqp', 'packrat', 'pamr', 'pander', 'parallelly', 'parallelMap', 'ParamHelpers', 'pbapply', 'pbivnorm', 'pbkrtest', 'pbs', 'pbv', 'pcaPP', 'pdftools', 'pdp', 'penalized', 'permute', 'pillar', 'pixmap', 'pkgbuild', 'pkgconfig', 'pkgload', 'plogr', 'plot3D', 'plot3Drgl', 'plotmo', 'plotrix', 'pls', 'plyr', 'PMCMR', 'pmml', 'png', 'poLCA', 'polspline', 'polyclip', 'polycor', 'polynom', 'powerSurvEpi', 'prabclus', 'pracma', 'praise', 'praznik', 'prettyunits', 'pROC', 'processx', 'profileModel', 'progress', 'promises', 'proto', 'ps', 'pscl', 'pspearman', 'Publish', 'pwr', 'qap', 'qpdf', 'quadprog', 'quantmod', 'quantreg', 'questionr', 'qvcalc'))"

RUN R -e "install.packages(c('R.cache', 'R.matlab', 'R.methodsS3', 'R.oo', 'R.rsp', 'R.utils', 'r2d3', 'R2HTML', 'R6', 'ragg', 'rainbow', 'randomForestSRC', 'rappdirs', 'rARPACK', 'rbibutils', 'Rborist', 'rcompanion', 'RcppProgress', 'RcppRoll', 'Rcsdp', 'Rdpack', 'readxl', 'reda', 'redland', 'refund', 'registry', 'relimp', 'rematch', 'rematch2', 'remotes', 'repr', 'reprex', 'reshape', 'reshape2', 'reticulate', 'rex', 'RGCCA', 'rgenoud', 'rgl', 'Rglpk', 'rio', 'RItools', 'rJava', 'RJSONIO', 'rknn', 'rlang', 'rle', 'RLRsim', 'rmdformats', 'rmdshower', 'rmeta', 'Rmpfr', 'Rmpi', 'rms', 'robCompositions', 'robustbase', 'robustlmm', 'ROCR', 'rootSolve', 'rotationForest', 'round', 'rpf', 'rprojroot', 'rrcov', 'RRF', 'rrlda', 'rsconnect', 'rsm', 'Rsolnp', 'RSpectra', 'rstatix', 'rstudioapi', 'rsvg', 'RSVGTipsDevice', 'Rtsne', 'Rttf2pt1', 'rucrdtw', 'RUnit', 'RVAideMemoire', 'rversions', 'RWeka', 'RWekajars'))"

RUN R -e "install.packages(c('sandwich', 'sass', 'scagnostics', 'scales', 'scalreg', 'scatterplot3d', 'sciplot', 'sda', 'selectr', 'seriation', 'servr', 'sessioninfo', 'sgeostat', 'shape', 'shapefiles', 'simputation', 'SIS', 'sjlabelled', 'skmeans', 'slam', 'slider', 'sm', 'smoof', 'smotefamily', 'snow', 'snowfall', 'som', 'sourcetools', 'spam', 'sparkline', 'sparseFLMM', 'sparseLDA', 'SparseM', 'spatstat.data', 'spatstat.utils', 'spelling', 'splines2', 'sqldf', 'SQUAREM', 'sROC', 'stabs', 'statmod', 'stepPlr', 'stringi', 'strucchange', 'styler', 'svd', 'svglite', 'SwarmSVM', 'synthpop', 'sys', 'systemfonts', 'tables', 'TeachingDemos', 'tensor', 'tensorA', 'tensorflow', 'tesseract', 'testit', 'textshaping', 'tfruns', 'tgp', 'TH.data', 'tidyselect', 'tidyverse', 'tiff', 'tinytest', 'tinytex', 'titanic', 'TMB', 'tmvnsim', 'TRCPTemplatePackage', 'TrialSize', 'tripack', 'truncnorm', 'TTR', 'ucminf', 'urca', 'utf8', 'varImp', 'vcd', 'vcdExtra', 'vctrs', 'vdiffr', 'vegan', 'VGAM', 'VGAMdata', 'VGAMextra', 'vip', 'viridisLite', 'vroom', 'waldo', 'warp', 'wavelets', 'webp', 'webshot', 'websocket', 'whisker', 'whoami', 'withr', 'xfun', 'xmlparsedata', 'xopen', 'xtable', 'yaml', 'zCompositions', 'zeallot', 'Zelig', 'zip'))"

# Install fanetc from GitHub (adjust username if needed)

#RUN R -e "remotes::install_github('fanstev1/fanetc')"
RUN R -e "remotes::install_github('TRCHR-CP/trcpetc', build_vignettes = TRUE)"
RUN R -e "remotes::install_github('TRCHR-CP/trcpproject')"

# Set working directory
WORKDIR /workspace

# Expose RStudio port
EXPOSE 8787

# Default command
CMD ["/init"]