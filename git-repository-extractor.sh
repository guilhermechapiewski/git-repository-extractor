#!/bin/bash

# Based on http://stackoverflow.com/questions/359424/detach-subdirectory-into-separate-git-repository

MOBILIBS_REPO="git@github.com/guilhermechapiewski/mobi-libs.git"
TEMP_DIR="./mobi-libs-temp"
NEW_LIB_NAME=${1##*/}

if [ "$1" == "" ]; then
	echo "Usage: $0 [path_to_library_on_mobilibs]"
	echo "Example: $0 android-lib/yahoosearchlibrary"
	exit 1
fi

echo
echo "Starting extraction of \"$NEW_LIB_NAME\" from mobi-libs (\"$1\" directory at \"$MOBILIBS_REPO\")..."
echo

# Clone your mobi-libs and go there.
git clone $MOBILIBS_REPO $TEMP_DIR
cd $TEMP_DIR

if [ ! -d "$1" ]; then
	echo "Error: Cannot find directory \"$1\" inside mobi-libs."
	cd ..
	rm -rf $TEMP_DIR
	exit 1
fi

# Remove origin to avoid pushing anything there by mistake.
# Also, this will become the library's directory.
git remote rm origin

# Remove all tags.
git tag -l | xargs git tag -d

# Extract the library.
git filter-branch --prune-empty --subdirectory-filter $1 -- --all

# Garbage collect all commits that are not part of your library.
git reset --hard
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
git reflog expire --expire=now --all
git gc --aggressive --prune=now

# Rename this directory to library name.
cd ..
mv $TEMP_DIR $NEW_LIB_NAME

echo
echo "Done: repository \"$1\" extracted to \"$NEW_LIB_NAME\"."
