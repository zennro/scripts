#! /bin/bash

# Sleep to make sure compiz starts first, internet is up, etc.
sleep 10

#######################
## Utility Functions ##
#######################

function is_running {
    (pidof $1) > /dev/null && return 0
    return 1
}

function internet_up {
    # check for if you have a working internet connection
    ((ping -w5 -c3 8.8.8.8 || ping -w5 -c3 4.2.2.1) > /dev/null 2>&1) && return 0
    return 1
}
