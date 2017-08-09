#!/bin/sh

/setup.sh

if [ $# -eq 0 ]; then

  /run.sh

else

  exec "$@"

fi
