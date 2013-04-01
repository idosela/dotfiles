#!/bin/bash
cd "$(dirname "$0")"

exclude_files=(".DS_Store" "README.md" "sync.sh" ".git")
files=$(grep -vxF -f <(printf "%s\n" ${exclude_files[@]}) <(ls -A))

# Determine the sync direction
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

if [[ $syncdir == "t" ]]; then
  backupdir="$HOME/dotfiles-backup-$(date +%Y%m%d%H%M%S)"
  mkdir $backupdir

  for file in ${files[@]}; do
    file="$HOME/$file"
    [ -e $file ] && cp $file $backupdir
    [ -d $file ] && rm -rf $file
  done
  unset file

  rsync -av ${files[@]} $HOME/
else
  echo "F"
fi

#     doIt
#   fi
#
# git pull
# function doIt() {
# 	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "README.md" -av . ~
# }
# if [ "$1" == "--force" -o "$1" == "-f" ]; then
# 	doIt
# else
# 	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
# 	echo
# 	if [[ $REPLY =~ ^[Yy]$ ]]; then
# 		doIt
# 	fi
# fi
# unset doIt
# source ~/.bash_profile
