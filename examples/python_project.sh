# Description: desk for working on a Python project

cd ~/python_project

source venv/bin/activate

PROJECT_NAME=python_project

# Run unittests with nose
alias t="nosetests ${PROJECT_NAME}/tests"

# Install requirements
alias req="pip install -r requirements.txt"

# Push the package to PyPI
alias pypipush="python setup.py sdist upload -r ${PROJECT_NAME}"
