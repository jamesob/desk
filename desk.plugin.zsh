# Make desk easier to use with ZSH frameworks.
# Add our plugin's bin diretory to user's path
PLUGIN_D="$(dirname $0)"
export PATH=${PATH}:${PLUGIN_D}

# Make our completion file available
export FPATH=${FPATH}:${PLUGIN_D}/completions
