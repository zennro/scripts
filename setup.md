# New System Setup

This setup is for a freshly installed [Kubuntu 13.10](http://www.kubuntu.org/getkubuntu) on a [Lenovo Yoga 13 laptop](http://www.amazon.com/gp/product/B00ATANVLG/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00ATANVLG&linkCode=as2&tag=scistapro-20).

## Common Install

    sudo apt-get install chromium-browser vim-gtk git build-essential gfortran xclip curl vlc kubuntu-restricted-extras konversation subversion mercurial conky thunderbird feh ubuntuone-control-panel-qt skype gawk htop

## Laptop Only

    sudo apt-get install powertop acpi

## SSD Performance

This will be the default in Ubuntu 14.04, but for now make a cron job to run TRIM on your SSD.

    sudo gvim /etc/cron.daily/trim

Insert 

    #!/bin/sh
    LOG=/var/log/trim.log
    echo "*** $(date -R) ***" >> $LOG
    fstrim -v / >> $LOG
    fstrim -v /home >> $LOG

Make it executable

    sudo chmod +x /etc/cron.daily/trim


## Lenovo Yoga 13 Only

#### Wi-Fi and Bluetooth until supported by kernel

    cd ~/scratch

    git clone git@github.com:lwfinger/rtl8723au.git
    cd rtl8723au/
    make
    sudo make install
    cd ..

    git clone git@github.com:lwfinger/rtl8723au_bt.git
    cd rtl8723au_bt/
    make
    sudo make install
    cd ~

#### Brightness Controls

Edit

    sudo gvim /etc/default/grub

Change

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

to

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor"

Run

    dpkg-reconfigure linux-image-$(uname -r)

Edit

    sudo gvim /etc/modprobe.d/blacklist.conf

Add `blacklist ideapad_laptop`


#### Second SSD

Add this to `/etc/fstab`

    /dev/sdb1 /media/data ntfs defaults 0 2

Then

    sudo chown -R skipper:skipper /media/data

## LaTeX

This is a big install!

    sudo apt-get install texlive texlive-xetex texlive-fonts-extra lyx latexmk


## Python Setup

    sudo apt-get install python-dev python-pip

## Pip Installs

    sudo apt-get install libxml2-dev libxslt1-dev zlib1g-dev graphviz
    pip install --user lxml beautifulsoup4 html5lib
    pip install --user nose sphinx cython virtualenv coverage mechanize regex\
                       requests keyring

## Git Config

    ln -s ~/src/dotfiles/.gitconfig ~/.gitconfig

## Common Directories

    cd ~
    mkdir scratch
    mkdir src
    mkdir statsmodels
    mkdir school
    mkdir work
    mkdir virtualenvs
    mkdir -p .local/lib
    mkdir -p .local/include

## Security

#### SSH Keys

    cd ~/.ssh
    ssh-keygen -t rsa - C "email@domain.com"
    ssh-add id_rsa

#### GPG Keys

    gpg --gen-key
    gpg --armor --output .gnupg/skipperkey.asc --export

## [Config Files](https://github.com/jseabold/dotfiles) and [Scripts](https://github.com/jseabold/scripts)

    cd ~
    cd src
    git clone git@github.com:jseabold/scripts
    sudo cp ~/src/scripts/00-powersave /etc/pm/power.d/

    git clone git@github.com:jseabold/dotfiles
    ln -s ~/src/dotfiles/.bashrc ~/
    ln -s ~/src/dotfiles/.vimrc ~/
    ln -s ~/src/dotfiles/.pystartup ~/
    sudo ln -s ~/src/scripts/clean_scratch.sh /etc/cron.weekly/clean_scratch

Make sure not to include any periods in the symlink name in the cron folder.

## [Bashmarks](http://www.huyng.com/projects/bashmarks/)

Bookmark directories for the shell.

    cd ~/src/
    git clone https://github.com/huyng/bashmarks
    cd bashmarks
    make install

Make sure `bashmarks.sh` is sourced in your `.bashrc` file.

## Keyboard Shortcuts

Common keyboard shortcuts I use

    ctrl+shift+i -> browser
    alt+g -> gvim
    alt+d -> dolphin
    alt+k -> konsole
    alt+m -> move window
    meta+m -> minimize window

## Vim Setup

Setup directory structure

    mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/ftplugin

#### [Pathogen](http://www.vim.org/scripts/script.php?script_id=2332): easy package management in vim

    curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    cd ~/.vim/bundle

#### [sensible.vim](http://www.vim.org/scripts/script.php?script_id=4391): Defaults everyone can agree on

    git clone git://github.com/tpope/vim-sensible.git

#### [Markdown](http://www.vim.org/scripts/script.php?script_id=2882) syntax support for vim

    git clone https://github.com/hallison/vim-markdown.git

#### [LaTeX suite](http://vim-latex.sourceforge.net/) tools for vim

    git clone git://git.code.sf.net/p/vim-latex/vim-latex

#### [fugitive.vim](http://www.vim.org/scripts/script.php?script_id=2975): support for git in vim

    git clone https://github.com/tpope/vim-fugitive.git

#### [Command-t](https://wincent.com/products/command-t): Fast file navigation for vim

    git clone git://git.wincent.com/command-t.git
    cd command-t/ruby/command-t
    sudo apt-get install ruby-dev
    ruby extconf.rb && make
    cd ../../../

#### [snipMate](http://www.vim.org/scripts/script.php?script_id=2540): TextMate style snippets for vim

    cd ~/.vim/bundle
    git clone https://github.com/msanders/snipmate.vim
    echo -e "# user-added" >> snipmate.vim/snippets/python.snippets
    echo -e "snippet ipdb\n\timport ipdb; ipdb.set_trace()" >> snipmate.vim/snippets/python.snippets
    echo -e "snippet stop\n\traise ValueError('stop')" >> snipmate.vim/snippets/python.snippets
    # optional
    # cd ../
    # git clone https://github.com/scrooloose/snipmate-snippets snippets
    # delete snipmate.vim/snippets if you Install the above

Remap the trigger key, if you're going to install PyDiction below (or remap the PyDiction trigger key). Edit `after/plugin/snipMate.vim` and change the following lines

    ino <silent> <c-cr> <c-r>=TriggerSnippet()<cr>
    snor <silent> <c-cr> <esc>i<right><c-r>=TriggerSnippet()<cr>
    ino <silent> <s-c-cr> <c-r>=BackwardsSnippet()<cr>
    snor <silent> <s-c-cr> <esc>i<right><c-r>=BackwardsSnippet()<cr>

This remaps from TAB to CTRL+Return.

    cd ../bundle

#### [gnupg](http://www.vim.org/scripts/script.php?script_id=3645): plugin for editing gpg encrypted files

    git clone https://github.com/jamessan/vim-gnupg

#### [PyDiction](http://www.vim.org/scripts/script.php?script_id=850): Tab-complete Python code

    git clone https://github.com/rkulla/pydiction.git

After installing the Python modules you commonly use, update the autocomplete dictionary

    cd ~/.vim/bundle/pydiction
    python pydiction.py numpy scipy pandas statsmodels matplotlib sklearn

    cd ~

#### [vim-flake8](https://github.com/nvie/vim-flake8): Pep-8 Checker

    pip install --user flake8
    cd ~/.vim/bundle/
    git clone https://github.com/nvie/vim-flake8

#### [syntastic](https://github.com/scrooloose/syntastic): Another option for syntax checking

    cd ~/.vim/bundle/
    git clone https://github.com/scrooloose/syntastic

#### [jedi-vim](https://github.com/davidhalter/jedi-vim): Jedi autocompletion library for vim

    cd ~/.vim/bundle
    git clone --recursive https://github.com/davidhalter/jedi-vim.git

#### [vim-python-pep8-indent](https://github.com/hynek/vim-python-pep8-indent): A nicer Python indentation style for vim

    cd ~/.vim/bundle
    git clone https://github.com/hynek/vim-python-pep8-indent.git


#### [autopep8](https://github.com/tell-k/vim-autopep8) Automatically applies pep8 changes

    pip install --user autopep8
    cd ~/.vim/bundle
    git clone https://github.com/tell-k/vim-autopep8

#### Custom ftplugins

Add my own custom ftplugins that are kept on github

    ln -s ~/src/dotfiles/vim/ftplugin/* ~/.vim/ftplugin/

## [Conky](http://conky.sourceforge.net/)

    cd ~/scratch/
    wget -O abite.zip http://img.dafont.com/dl/?f=a_bite
    unzip -e abite.zip
    xdg-open ABITE.ttf
    cd ~

## [Choqok](http://choqok.gnufolks.org/) KDE Microblog client

As of 1.3 Choqok still uses the Twitter 1.0 API, so you need to install from source.

    sudo apt-get install kdelibs5-dev libqjson-dev libqoauth-dev libqca2-dev cmake libindicate-qt-dev
    cd ~/src/
    wget --content-disposition http://sourceforge.net/projects/choqok/files/Choqok/choqok-1.4.tar.xz/download
    tar -xvf choqok*
    cd choqok*
    mkdir BUILD
    cd BUILD
    cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..
    make
    sudo make install

You might need to `sudo ldconfig`.

## Python Libraries Git Sources

These are all packages I like to build from source to stay close to the bleeding edge.

    cd ~/src/
    git clone git@github.com:jseabold/ipython ipython-skipper && cd ipython-skipper && git remote add upstream git://github.com/ipython/ipython && cd ..
    git clone git@github.com:jseabold/numpy numpy-skipper && cd numpy-skipper && git remote add upstream git://github.com/numpy/numpy && cd ..
    git clone git@github.com:jseabold/scipy scipy-skipper && cd scipy-skipper && git remote add upstream git://github.com/scipy/scipy && cd ..
    git clone git@github.com:jseabold/matplotlib matplotlib-skipper && cd matplotlib-skipper && git add remote upstream git://github.com/matplotlib/matplotlib && cd ..
    git clone git@github.com:jseabold/pandas pandas-skipper && cd pandas-skipper && git remote add upstream git://github.com/pydata/pandas && cd ..
    git clone git://github.com/scikit-learn/scikit-learn/
    git clone git@github.com:jseabold/pysal pysal-skipper && cd pysal-skipper && git remote add upstream git://github.com/pysal/pysal && cd ..
    git clone git@github.com:jseabold/scikits-sparse scikits-sparse-skipper && cd scikits-sparse-skipper && git remote add upstream git://github.com/njsmith/scikits-sparse && cd ..
    git clone git@github.com:jseabold/networkx networkx-skipper && cd networkx-skipper && git remote add upstream git://github.com/networkx/networkx && cd ..
    git clone git@github.com:jseabold/gensim gensim-skipper && cd gensim-skipper && git remote add upstream git://github.com/piskvorky/gensim && cd ..
    git clone https://github.com/discoproject/disco

### [IPython](http://ipython.org/)

    sudo apt-get install libzmq-dev pandoc python-tk
    pip install --user pyzmq jinja2 tornado
    cd ~/src/ipython-skipper
    python setup.py build
    sudo python setup.py install
    cd ~
    ipython profile create
    rm ~/.config/ipython/profile_default/ipython_config.py
    ln -s ~/src/dotfiles/ipython_config.py ~/.config/ipython/profile_default/
    pip install --user ipdb
    pip install --user ipdbplugin

### [Numpy](http://www.numpy.org/)

#### [OpenBLAS](http://www.openblas.net/)

    cd src
    git clone git://github.com/xianyi/OpenBLAS
    cd OpenBLAS
    
Edit the Makefile.rule to have

    NO_WARMUP=1
    NO_AFFINITY=1

Then

    make
    make PREFIX=~/.local/ install

Add the location of these library files to the end of the following files to make them easier to find for libraries that depend on numpy

    sudo gvim /etc/ld.so.conf

#### [SuiteSparse](https://www.cise.ufl.edu/research/sparse/SuiteSparse/)

    cd src/
    wget http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-4.2.1.tar.gz
    tar -xvf SuiteSparse-4.2.1.tar.gz

Edit SuiteSparse_config/SuiteSparse_config.mk to use the right compilers and point to BLAS and LAPACK

    # For "make install"
    INSTALL_LIB = ~/.local/lib
    INSTALL_INCLUDE = ~/.local/include

Change these lines

    BLAS = -lblas -lgfortran
    LAPACK = -llapack

to

    BLAS = -lopenblas -lgfortran -lpthread
    LAPACK = -lopenblas

Comment out

    #CHOLMOD_CONFIG = $(GPU_CONFIG)

Uncomment

    CHOLMOD_CONFIG = -DNPARTITION

Compile

    make
    make install

Build/Install NumPy

Don't rely on HOME (~) expansion in site.cfg

    cd ~/src/numpy-skipper
    echo -e "[DEFAULT]\nlibrary_dirs = /home/skipper/.local/lib\ninclude_dirs = /home/skipper/.local/include\n\n[openblas]\nlibraries = openblas\nlibrary_dirs = /home/skipper/.local/lib\ninclude_dirs = /home/skipper/.local/include\n\n[amd]\namd_libs = amd\n\n[umfpack]\numfpack_libs = umfpack" > site.cfg
    python setup.py build &> build.log
    sudo python setup.py install

### [SciPy](http://www.scipy.org/)

Dependencies (not already installed)

For UMFPACK support

    sudo apt-get install swig

Build/Install SciPy

    cd ~/src/scipy-skipper
    cp ~/src/numpy-skipper/site.cfg
    python setup.py build
    sudo python setup.py install

### [Matplotlib](http://matplotlib.org/)

    pip install --user pyparsing
    pip install --user python-dateutil
    sudo apt-get install dvipng
    python setup.py build
    sudo python setup.py install

### [Pandas](http://pandas.pydata.org/)

(Optional) Dependencies

Excel Support

    pip install --user openpyxl xlrd xlwt

[Boto](http://docs.pythonboto.org/en/latest/): Amazon S3 Support. This will need to be configured with your Amazon credentials.

    pip install --user boto

[NumExpr](https://code.google.com/p/numexpr/): Fast numerical array expression evaluator for Python and NumPy

    cd ~/src/
    hg clone https://code.google.com/p/numexpr/
    cd numexpr
    python setup.py build
    sudo python setup.py install


[PyTables](http://www.pytables.org/moin) (depends on NumExpr): package for managing hierarchical datasets and designed to efficiently and easily cope with extremely large amounts of data.

    sudo apt-get install libhdf5-dev liblzo2-dev libbz2-dev
    cd ~/src/
    git clone git://github.com/PyTables/PyTables
    cd PyTables
    python setup.py build
    sudo python setup.py install

[Bottleneck](http://berkeleyanalytics.com/bottleneck/): Fast NumPy array funtions written in Cython

    cd ~/src/
    git clone git://github.com/kwgoodman/bottleneck
    cd bottleneck
    python setup.py build
    sudo python setup.py install

Build/Install pandas

    cd ~/src/pandas-skipper
    python setup.py build
    sudo python setup.py install

### [Statsmodels](http://statsmodels.sourceforge.net/): Statistics in Python

    cd ~/statsmodels
    git clone git@github.com:statsmodels/statsmodels.git
    git clone git@github.com:jseabold/statsmodels.git statsmodels-skipper && cd statsmodels-skipper && git remote add upstream git://github.com/statsmodels/statsmodels && cd ..
    pip install --user patsy
    cd statsmodels-skipper
    python setup.py build_ext --inplace
    sudo python setup.py install

### [scikit-learn](http://scikit-learn.org/stable/): machine learning in Python

    cd ~/src/scikit-learn
    python setup.py build
    sudo python setup.py install

### [starcluster](http://star.mit.edu/cluster/): cluster-computing toolkit for Amazon EC2

    cd ~/src/
    git clone git://github.com/jtriley/StarCluster.git
    cd StarCluster

Last Stable release

    git checkout 0.94.2
    sudo python setup.py install

[Setup your config file](http://star.mit.edu/cluster/docs/latest/quickstart.html) with SSH Keys, AWS Credentials, etc. [Setup for use with IPython](http://star.mit.edu/cluster/docs/latest/plugins/ipython.html#ipython-cluster-plugin).

## [seaborn](http://stanford.edu/~mwaskom/software/seaborn/): statistical data visualization

    cd ~/src/
    git clone https://github.com/mwaskom/seaborn

## [ggplot](https://github.com/yhat/ggplot/blob/master/README.md): ggplot for python

    cd ~/src/
    git clone https://github.com/yhat/ggplot/

## NLP / Text Processing

### [NLTK](http://nltk.org/) Natural Language Toolkit

    sudo apt-get install libyaml-dev
    pip install --user pyyaml nltk
    cd ~/src/
    git clone https://github.com/japerk/nltk-trainer
    cd nltk-trainer
    python setup.py build
    sudo python setup.py install

### [fuzzywuzzy](https://github.com/seatgeek/fuzzywuzzy): Fuzzy string matching like a boss

Fuzzy string matching library

    cd ~/src/
    pip install --user python-Levenshtein
    git clone https://github.com/seatgeek/fuzzywuzzy
    cd fuzzywuzzy
    python setup.py build
    sudo python setup.py install

### [Snowball Stemmer](http://snowball.tartarus.org/)

    pip install --user PyStemmer

### [pattern](http://www.clips.ua.ac.be/pages/pattern)

    pip install --user pattern

### gensim

    cd ~/src/gensim
    python setup.py build
    sudo python setup.py install
    cd ~

## R

Dependencies

    sudo apt-get install libreadline-dev xorg-dev

For building HTML docs

    sudo apt-get install texinfo

Build/Install R

    cd ~/src
    wget http://mirrors.nics.utk.edu/cran/src/base/R-3/R-3.0.2.tar.gz
    tar -xvf R-3*
    cd R-3*
    ./configure --with-blas="openblas" --with-lapack="-L ~/.local/lib -lopenblas" --enable-R-shlib
    make
    make check
    sudo make install

Rprofile settings.

    ln -s ~/src/dotfiles/.Rprofile ~/.Rprofile

### R Packages

Install some often used default packages

    Rscript -e "install.packages(c('car', 'systemfit', 'plyr', 'stringr', 'ggplot2', 'RColorBrewer', 'vars', 'forecast', 'zoo', 'gtools', 'gamlr', 'distrom', 'robustbase', 'lubridate', 'maptpx'))"


I like to have the source of some packages I use available to muck around in

    cd ~
    mkdir ~/src/R_packages && cd ~/src/R_packages

    wget http://cran.r-project.org/src/contrib/plm_1.4-0.tar.gz
    Rscript -e "install.packages(c('bdsmatrix','Formula'))"
    R CMD INSTALL plm_1.4-0.tar.gz
    tar -xvf plm*

    wget http://cran.r-project.org/src/contrib/textir_1.8-8.tar.gz
    Rscript -e "install.packages(c('slam'))"
    R CMD INSTALL textir_1.8-8.tar.gz
    tar -xvf textir*

### [Rpy2](http://rpy.sourceforge.net/rpy2.html)

    pip install --user rpy2

## [Gretl](http://gretl.sourceforge.net/) Gnu Regression, Econometrics, and Time-series Library

Dependencies (not yet installed above)

    sudo apt-get install gnuplot-dev libfftw3-dev libgmp-dev libmpfr-dev libcurl4-openssl-dev libgtk-3-dev libgtksourceview-3.0-dev

Optional Dependency (X-12 ARIMA)

    cd ~/src/
    mkdir x12arima && cd x12arima
    wget http://www.census.gov/ts/x12a/v03/unix/omegav03src.tar.gz
    tar -xvf omega*
    sed -i -e 's/ifort/gfortran/g' makefile.lnx
    mv makefile.lnx Makefile
    make

Build/Install Gretl

    cd ~/src/
    wget http://prdownloads.sourceforge.net/gretl/gretl-1.9.13.tar.bz2
    tar -xvf gretl*
    LAPACK_LIBS='-L/home/skipper/.local/lib -lopenblas' ./configure --with-x-12-arima --with-libR
    make
    make check
    sudo make install
    sudo ldconfig

## GIS

    sudo apt-get install libgeos-3.3.3 libgeos-dev

    cd ~/src/
    git clone git://github.com/matplotlib/basemap matplotlib-basemap
    cd matplotlib-basemap
    export GEOS_DIR=/usr
    python setup.py build
    sudo python setup.py install
    cd ~

    pip install --user geopy

    pip install --user shapely

    pip install --user pyshp

    cd ~/src/
    wget http://download.osgeo.org/proj/proj-4.8.0.tar.gz
    tar -xvf proj-*
    cd proj-*
    ./configure && make
    sudo make install
    make clean && make distclean
    pip install --user pyproj

## Graph Theory / Networks

### [igraph](http://igraph.sourceforge.net/)

Build the source

    cd ~/src/
    git clone git://github.com/igraph/igraph
    cd igraph
    sudo apt-get install libtool
    ./bootstrap.sh
    ./configure
    make
    sudo make install
    make clean && make distclean

Install the Python package

    cd interfaces/python
    python setup.py build
    sudo python setup.py install
    cd ~

### [networkx](http://networkx.github.io/)

    cd ~/src/networkx-skipper
    python setup.py build
    sudo python setup.py install


## [Dropbox](https://db.tt/LLAHiF9s)

    cd ~/src/
    wget -O dropbox.tar.gz http://www.getdropbox.com/download?plat=lnx.x86_64
    tar -xvf dropbox.tar.gz
    cd .dropbox-dist

Set it up

    ./dropboxd

## Autostart Scripts

    ln -s ~/src/scripts/conky_start.sh ~/.kde/Autostart/
    ln -s ~/src/scripts/choqok_start.sh ~/.kde/Autostart/
    ln -s ~/src/scripts/dropbox_start.sh ~/.kde/Autostart/

## 32-bit chroot environment

For testing development packages on 32-bit.

[https://gist.github.com/jseabold/7139282](https://gist.github.com/jseabold/7139282)

## Web Development

    sudo apt-get install nodejs npm

## Personal web-site

    cd ~/virtualenvs
    virtualenv pelican --system-site-packages
    source pelican/bin/activate
    pip install markdown
    pip install ipython==1.1

    cd ~/src/
    git clone https://github.com/getpelican/pelican
    cd pelican
    python setup.py install

    cd ~/src/
    git clone https://github.com/getpelican/pelican-plugins pelican-plugins

    cd ~
    git clone git@github.com:jseabold/web-site
    cd web-site
    mkdir themes && cd themes
    git clone https://github.com/jseabold/pelican-fresh

## Backups

### [s3fs](https://code.google.com/p/s3fs/wiki/FuseOverAmazon) FUSE-based file system backed by Amazon S3

Backuping files to Amazon S3 using s3fs. Note that this is pretty slow for use with many small files. I might consider exploring [s3curl](https://aws.amazon.com/code/128) in the future. You might also considering compressing directories to separate tarballs. I suspect that performance- and cost-wise this would be more efficient, though obviously not bandwidth-wise.

Dependencies (some already installed above)

    sudo apt-get install libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support autoconf

    cd ~/src/
    svn checkout http://s3fs.googlecode.com/svn/trunk/ s3fs
    cd s3fs
    autoreconf --install
    ./configure --prefix=/usr
    make
    sudo make install
    sudo mkdir -p /mnt/backup/s3
    sudo chown skipper:skipper /mnt/backup/s3

Add your credentials to a file

    ~/.passwd-s3fs

In the form

    AccessKeyId:SecretAccessKey

Change its permissions

    chmod 600 ~/.passwd-s3fs

Create a bucket using the AWS console or your tool of choice.

Create a backup script. On KDE the `kdialog` command will send a notification to a user. To do so you need to specify an Xserver and Xauthority file.

    :::bash
    #! /bin/bash

    if [[ $1 == "test" ]]; then
        mkdir ~/test_backup
        BACKUP_DIR=~/test_backup/
    else
        /usr/bin/s3fs your-bucket-name /mnt/backup/s3 -ouse_cache=/tmp
        BACKUP_DIR=/mnt/backup/s3/
    fi

    export DISPLAY=:0
    export XAUTHORITY=/home/skipper/.Xauthority

    kdialog --passivepopup "Your S3 backup job has started" 5
    /usr/bin/rsync -avrz --delete --inplace --stats --partial --log-file=log.file --exclude-from=/path/to/exclude --files-from=/path/to/include/backup.files /home/username/ $BACKUP_DIR
    mv log.file backup.log.`date +"%Y%m%d%H%M%S"`
    if [[ $1 != "test" ]]; then
        /bin/umount /mnt/backup/s3
    fi
    kdialog --passivepopup "Your S3 backup job has completed" 5

Make it executable

    chmod +x ~/src/scripts/s3backup

Since this is a laptop, you can add this to anacron, so that it will run the next time your machine is on according to some schedule. I added the following to `/etc/anacrontab`

    sudo ln -s ~/src/scripts/s3backup.sh /etc/cron.weekly/s3backup

Make sure not to include any periods in the symlink name in the cron folder. That is, do NOT include a file ending. It won't be found by `run-parts`. You may need to edit `/etc/mstab` so that users have permissions to unmount this drive. Add the following line

    s3fs /mnt/backup/s3 fuse.s3fs rw,noexec,nosuid,nodev,allow_other,user=skipper 0 0

## Postfix

### Setup System Mail using postfix and gmail

Only do this if you want to *send* mail using gmail. If you want a local setup, e.g. for sending mail sent to root to the local user see below.

Install postfix and dependencies

    sudo apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules

Select server as `Internet site`. It doesn't matter what you put for FQDN. `mail.example.com` will work for now or use your hostname. You can change this in `/etc/mailname` or by setting myhostname in `main.cf`.

Open config file

    sudo vim /etc/postfix/main.cf

Add the following lines

    relayhost = [smtp.gmail.com]:587
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_tls_CAfile = /etc/postfix/cacert.pem
    smtp_use_tls = yes

Setup password

    vim /etc/postfix/sasl_passwd

Add the following line

    [smtp.gmail.com]:587 USERNAME@gmail.com:PASSWORD

Fix permissions and update postfix config to use sasl_passwd

    sudo chmod 400 /etc/postfix/sasl_passwd
    sudo postmap /etc/postfix/sasl_passwd

You can remove the sasl_passwd file after running postmap. It creates a Berkeley DB file that it uses.

Add certificates

    cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem

Reload postfix config

    sudo /etc/init.d/postfix reload

Test it out

    echo "Test mail from postfix" | mail -s "Test postfix" jsseabold@gmail.com

### Setup System Mail using postfix and localhost

Assuming postfix is installed already, make sure that `/etc/aliases` reads

    # See man 5 aliases for format
    postmaster:    root
    root:   skipper

If you have to, add the third line and run

    sudo newaliases

Then create a forward file

    sudo gvim /root/.forward

And add

    skipper@skipper-lenovo

Add your user to the mail group so Thunderbird can read the mail

    sudo adduser $USER mail

This should be all your need to do for forwarding mail. Let's test it out.

    echo "Test mail from postfix" | mail -s "Test postfix" skipper@skipper-lenovo

This message should show up in `/var/mail/skipper`.

Now setup thunderbird, so you can read the mail there. Open thunderbird and go to preferences > account settings > account actions > add other account. Select Unix Mailspool. Set

    Your Name: skipper
    Email Address: skipper@skipper-lenovo

Now finish this and edit the account settings for this account. Try to set the mail directory to `/var/mail/skipper`. It might not let you. It's not a big deal, apparently. Seems to work anyway.

Now setup the smtp server. Fill in localhost for everything and set the port to 25. If you've previously set up gmail in Thunderbird, make sure you set the localhost to be the default outgoing SMTP server.

## Setting up Flash

Adobe stopped supporting Linux as of 11.2. The old plugins crash for me in chromium now. Chrome has Pepper, an API for a proprietary flash plugin. You can install Chrome Pepper in Chromium through a PPA. Rune the following

    sudo add-apt-repository ppa:skunk/pepper-flash
    sudo apt-get update
    sudo apt-get install pepflashplugin-installer

Then edit (with permission) `/etc/chromium-browser/default`. Past this at the bottom

    . /usr/lib/pepflashplugin-installer/pepflashplayer.sh
