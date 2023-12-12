load("cirrus", "env", "fs", "http")

def main(ctx):

    return fs.read("tools/ci/cirrus_deploy_pypi_linux_aarch64.yml")
    return fs.read("tools/ci/cirrus_deploy_pypi_macosx_arm64.yml")
    return fs.read("tools/ci/cirrus_deploy_conda_linux_aarch64.yml")
    return fs.read("tools/ci/cirrus_deploy_conda_macosx_arm64.yml")
