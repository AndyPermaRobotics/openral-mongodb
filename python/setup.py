from setuptools import find_packages, setup

# run:
# python3 setup.py sdist bdist_wheel

with open("requirements.txt") as f:
    requirements = f.read().splitlines()

with open("README.md") as f:
    readme = f.read()

setup(
    name="openral_mongodb_py",
    version="0.1.16",
    description="MongoDB Implementation of a RalRepositories for openRAL.",
    long_description=readme,
    long_description_content_type="text/markdown",
    author="Permarobotics GmbH",
    author_email="blech@permarobotics.com",
    url="https://github.com/AndyPermaRobotics/openral-mongodb-py",
    packages=find_packages(
        include=["openral_mongodb_py", "openral_mongodb_py.*", "openral_mongodb_py.*.*"]
    ),
    license="MIT",
    install_requires=requirements,
    keywords=[
        "openRAL",
        "regenerative agriculture",
        "agriculture",
        "mongodb",
    ],
)
