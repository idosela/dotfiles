#!/bin/bash

# cd into the scripts directory.
cd "$(dirname "$0")"

# Get a list of the files to be copied.
exclude_files=(".DS_Store" "README.md" "sync.sh" ".git")
files=$(grep -vxF -f <(printf "%s\n" ${exclude_files[@]}) <(ls -A))

# Determine the sync direction.
echo
echo "Please choose the sync direction:"
select suite in "To homedir" "From homedir";
do
  case "$suite" in
    "To homedir") syncdir="t";;
    "From homedir") syncdir="f";;
    *) echo "Invalid option"; exit 0;;
  esac
  break
done

# Sync the dot files to the home directory.
if [[ $syncdir == "t" ]]; then

  # Create a backup of any preexisting dot files.
  backupdir="$HOME/dotfiles-backup-$(date +%Y%m%d%H%M%S)"
  mkdir $backupdir

  for file in ${files[@]}; do
    file="$HOME/$file"
    [ -e $file ] && cp $file $backupdir
    [ -d $file ] && rm -rf $file
  done
  unset file

  # Sync and reload.
  rsync -av ${files[@]} $HOME/
  source $HOME/.bash_profile

# Sync the dot files from the home directory.
else
  for file in ${files[@]}; do
    file="$HOME/$file"
    [ -e $file ] && cp -r $file .
  done
  unset file
fi
