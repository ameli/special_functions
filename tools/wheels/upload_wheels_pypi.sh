set -xe


# ==============================
# install anaconda linux aarch64
# ==============================

install_anaconda_linux_aarch64() {

    # install miniconda in the home directory. For some reason HOME isn't set by Cirrus
    export HOME=$PWD

    # install miniconda for uploading to anaconda
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda3
    $HOME/miniconda3/bin/conda init bash
    source $HOME/miniconda3/bin/activate
}


# ============================
# install anaconda macos arm64
# ============================

install_anaconda_macosx_arm64() {

    # install miniconda in the home directory. For some reason HOME isn't set by Cirrus
    export HOME=$PWD

    # install miniconda for uploading to anaconda
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda3
    $HOME/miniconda3/bin/conda init bash
    source $HOME/miniconda3/bin/activate
}


# ============================
# build upload wheels anaconda
# ============================

build_upload_wheels_anaconda() {

    # Conda executable
    export PATH=$(conda info --root):$PATH
    export PATH=$(conda info --root)/bin:$PATH

    conda install -y anaconda-client conda-build

    # Login to anaconda account
    # ANACONDA_USERNAME="s-ameli"
    # if [[ -z ${ANACONDA_API_TOKEN} ]]; then
    #     echo no anaconda api token set, not uploading
    # else
    #     anaconda login --username ${ANACONDA_USERNAME}
    # fi

    # Upload to anaconda automatically right after each wheel is built
    # conda config --set anaconda_upload yes

    # Upload sdist
    if compgen -G "./dist/*.gz"; then
        anaconda -t ${ANACONDA_API_TOKEN} upload --force -u ${ANACONDA_ORG} ./dist/*.gz
    else
        echo "Dist files do not exist"
    fi

    # Build wheels and upload them automatically
    if compgen -G "./dist/*.whl"; then
        conda-build --output-folder conda-bld .
        anaconda -t ${ANACONDA_API_TOKEN} upload --force -u ${ANACONDA_ORG} ./conda-bld/*.tar.bz2
    else
        echo "Wheel files do not exist"
        return 1
    fi
}


# ==================
# upload wheels pypi
# ==================

upload_wheels_pypi() {

    # Install pip and twine
    python -m pip install --upgrade pip
    python -m pip install twine

    PYPI_USERNAME="__token__"

    if [[ -z ${PYPI_PASSWORD} ]]; then
        echo no pypi password set, not uploading
    else
        if compgen -G "./dist/*.whl"; then
            echo "Found wheel"
            twine upload ./dist/* -u ${PYPI_USERNAME} -p ${PYPI_PASSWORD}
        else
            echo "Wheel files do not exist"
            return 1
        fi
    fi
}
