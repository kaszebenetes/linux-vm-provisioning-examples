#!/bin/bash

# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html

# debug
# set -x

# fail if any command fail, stop interpreting script
# set -e

# fail if variable is not defined/hasn't got value
# set -u

# fail if command after pipe fails
# set -o pipefail

# set -euo pipefail

# sudo dnf update -y

test_var="lololo"


echo "test"

echo "print variable value test_var=$test_var" | grep xda
