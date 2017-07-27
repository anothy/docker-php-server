#!/bin/bash

#
# Run the setup
#
/setup.sh

#
# Start Apache in the foreground
#
apachectl -DFOREGROUND
