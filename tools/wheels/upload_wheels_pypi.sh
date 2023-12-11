set -xe


# ================
# Install Anaconda
# ================

install_anaconda() {

    # install miniconda in the home directory. For some reason HOME isn't set by Cirrus
    export HOME=$PWD

    # install miniconda for uploading to anaconda
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda3
    $HOME/miniconda3/bin/conda init bash
    source $HOME/miniconda3/bin/activate
    conda install -y anaconda-client

    # Install pip and twine
    python -m pip install --upgrade pip
    python -m pip install twine
}


# ============================
# Build Upload Wheela Anaconda
# ============================

build_upload_wheels_anaconda() {

    # Conda executable
    export PATH=$(conda info --root):$PATH
    export PATH=$(conda info --root)/bin:$PATH

    # Login to anaconda account
    ANACONDA_USERNAME="s-ameli"
    if [[ -z ${ANACONDA_TOKEN} ]]; then
        echo no anaconda token set, not uploading
    else
        anaconda login --username ${ANACONDA_USERNAME} --token ${ANACONDA_TOKEN}
    fi

    # Upload to anaconda automatically right after each wheel is built
    conda config --set anaconda_upload yes

    # Upload sdist
    if compgen -G "./dist/*.gz"; then
        anaconda -q -t ${TOKEN} upload --force -u ${ANACONDA_ORG} ./dist/*.gz
    fi

    # Build wheels and upload them automatically
    if compgen -G "./dist/*.whl"; then
        conda-build --output-folder . .
    else
        echo "Wheel files do not exist"
        return 1
    fi
}


# ==================
# Upload Wheels PyPI
# ==================

upload_wheels_pypi() {

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
        echo "PyPI-style index: https://pypi.org"
    fi
}
