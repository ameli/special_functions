load("cirrus", "env", "fs", "http")

def main(ctx):

    # code1 = fs.read("tools/ci/cirrus_deploy_pypi_linux_aarch64.yml")
    # code2 = fs.read("tools/ci/cirrus_deploy_pypi_macosx_arm64.yml")
    # code3 = fs.read("tools/ci/cirrus_deploy_conda_linux_aarch64.yml")
    # code4 = fs.read("tools/ci/cirrus_deploy_conda_macosx_arm64.yml")
    #
    # # Return error if any of the codes are nonzero
    # code = code1 or code2 or code3 or code4

    # yaml = fs.readdir("tools/ci/")

    file = ''
    file += fs.read("tools/ci/cirrus_deploy_pypi_linux_aarch64.yml")
    file += fs.read("tools/ci/cirrus_deploy_pypi_macosx_arm64.yml")
    file += fs.read("tools/ci/cirrus_deploy_conda_linux_aarch64.yml")
    file += fs.read("tools/ci/cirrus_deploy_conda_macosx_arm64.yml")

    return file
