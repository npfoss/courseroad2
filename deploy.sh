#!/bin/bash
# To run this script you must have *in your athena locker*:
# - 'aklog' written in ~/.bash_environment (or the environment file for whatever shell you use)
# - 'sipb' and 'athena' written in ~/.xlog.
# Otherwise, you will not have permission to access the courseroad locker,
# even if you are on courseroad-dev@.

#syntax: ./deploy.sh [dev|prod] [kerberos]

# this section is for Miriam's kdo setup
if [ $SHELL = "/bin/zsh" ]; then
  source ~/.zshrc
fi

# exit if anything errors
set -e

npm run build-$1
if [ "$1" = "prod" ]; then
  echo -n "You are about to deploy to the production site, are you sure? (y/n)? "
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "Checking for AFS on this system"
    if which aklog &>/dev/null; then
      echo "AFS detected, using AFS for deployment"
      if which kdo &>/dev/null; then
        echo "Using kdo"
        kdo $2 aklog sipb
      else
        kinit -f -l 1h $2
        aklog sipb
      fi
      rsync --delete --progress --checksum -r deploy/production/.htaccess dist/* /afs/sipb.mit.edu/project/courseroad/web_scripts/courseroad/
    else
      echo "Could not locate AFS, using SSH for deployment"
      # this is what happens without any fancy setup
      scp -r deploy/production/.htaccess dist/* cgi-bin/ $2@athena.dialup.mit.edu:/mit/courseroad/web_scripts/courseroad/
    fi
  else
    echo "Cancelled"
  fi
elif [ "$1" = "dev" ]; then
  echo "Checking for AFS on this system"
  if which aklog &>/dev/null; then
    echo "AFS detected, using AFS for deployment"
    if which kdo &>/dev/null; then
      echo "Using kdo"
      kdo $2 aklog sipb
    else
      kinit -f -l 1h $2
      aklog sipb
    fi
    rsync --delete --progress --checksum -r deploy/development/.htaccess dist/* /afs/sipb.mit.edu/project/courseroad/web_scripts/courseroad/dev/
  else
    echo "Could not locate AFS, using SSH for deployment"
    # this is what happens without any fancy setup
    scp -r deploy/development/.htaccess dist/* cgi-bin/ $2@athena.dialup.mit.edu:/mit/courseroad/web_scripts/courseroad/dev/
  fi
else
  echo "Invalid build location"
fi
