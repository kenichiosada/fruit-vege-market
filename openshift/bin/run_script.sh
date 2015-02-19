#!/bin/bash

# Set env variables
if [ -z "$OPENSHIFT_APP_NAME" ]; then
  # dev
  export APP_HOME="/data/www/tokyo2/"
  LIB_DIR=${APP_HOME}openshift/lib/
  if [ -z "$PERL5LIB" ]; then
    export PERL5LIB="$LIB_DIR"
  else 
    export PERL5LIB="$LIB_DIR:$PERL5LIB"
  fi
  export OPENSHIFT_TMP_DIR="/tmp"
  export OPENSHIFT_LOG_DIR=${APP_HOME}openshift/log/
else 
  # prod
  export APP_HOME="$OPENSHIFT_APPHOME"
  OPENSHIFT_REPO_DIR=${OPENSHIFT_REPO_DIR}
  export PERL5LIB=${OPENSHIFT_REPO_DIR}openshift/lib/:$PERL5LIB
fi

function usage {
  echo "Call example: sh run_script.sh script_name -option
        
        Available option: 
        -cron    : run script in /cron directory
        -manual  : run script in /manual directory";
}

# Lock file
# ref: http://qiita.com/KurokoSin/items/0eddf05818b89b627102 
function checkDuplicate()
{
    local RET=0
    local base=${0##*/}
    local pidfile="$OPENSHIFT_TMP_DIR/${base}.pid"

    while true; do
        if ln -s $$ ${pidfile} 2> /dev/null
        then
            RET=0 && break
        else
            p=$(ls -l ${pidfile} | sed 's@.* @@g')
            if [ -z "${p//[0-9]/}" -a -d "/proc/$p" ]; then
                local mypid=""
                for mypid in $(pgrep -f ${base})
                do
                    [ ${p} -eq ${mypid} ] && RET=1 && break
                done;
            fi

            [ ${RET} -ne 0 ] && break
        fi

        rm -f ${pidfile}
    done

    if [ ${RET} -eq 0 ]; then
        trap "rm -f ${pidfile}; exit 0" EXIT
        trap "rm -f ${pidfile}; exit 1" 1 2 3 15
    fi

    return ${RET}
}


## Check options
for OPT in "$@"
do 
  case "$OPT" in 
    '-cron') 
      DIR="cron"
      shift 1
      ;;
    '-manual')
      DIR="manual"
      shift 1
      ;;
    '-help')
      usage
      exit 1
      ;;
    '-o')
     PARAM=$2 
     shift 2 
     ;;
    -*)
      echo "illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2 
      exit 1
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        if [ !$TARGET ]; then
          TARGET=$1
          shift 1
        fi
        #TARGET=$1 
      else 
        if [ -z "$TARGET" ]; then
        echo "No script to run is specified" 1>&2
        exit 1
        fi
      fi
      ;; 
  esac
done

if [ $TARGET ] && [ ! -f $DIR/$TARGET ]; then
  echo "$DIR/$TARGET does not exist" 1>&2
else
  checkDuplicate
  if [ 0 -ne $? ]; then
    echo "Script already running"
    exit 1
  else
    if [ $PARAM ]; then 
     $DIR/$TARGET $PARAM 
    else 
      $DIR/$TARGET
    fi
  fi
fi  


