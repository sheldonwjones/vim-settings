VIM Settings
============

It uses Tim Pope's pathogen_ VIM plugin to keep addons in their own
private directories.

Installation
------------

Clone the repository
~~~~~~~~~~~~~~~~~~~~

::

    git clone ...into... ${HOME}/.vim
    cd ${HOME}/.vim
    git submodule init
    git submodule update

Setup the vimrc
~~~~~~~~~~~~~~~

Copy the vimrc.example vimrc file into VIM's runtime path::

    cp ${HOME}/vimrc.example ${HOME}/.vimrc

If the repository wasn't configured on VIM's runtime path, it can be placed
on the path by setting ``g:vim_local``::

    let g:vim_local = '~/.vim'

.. _pathogen: https://github.com/tpope/vim-pathogen
