#!/bin/bash

# Based on http://stackoverflow.com/questions/359424/detach-subdirectory-into-separate-git-repository

ORIGINAL_REPO=$1
ORIGINAL_DIRECTORY=$2
TEMP_DIR="./git-repo-extractor-temp"
NEW_LIB_NAME=${2##*/}

if [ "$ORIGINAL_REPO" == "" ] || [ "$ORIGINAL_DIRECTORY" == "" ]; then
	echo "Usage: $0 [path_to_library_on_mobilibs]"
	echo "Example: $0 android-lib/yahoosearchlibrary"
	exit 1
fi

echo
echo "Starting extraction of \"$NEW_LIB_NAME\" (\"$ORIGINAL_DIRECTORY\" directory at \"$ORIGINAL_REPO\")..."
echo

# Clone your mobi-libs and go there.
git clone $ORIGINAL_REPO $TEMP_DIR
cd $TEMP_DIR

if [ ! -d "$ORIGINAL_DIRECTORY" ]; then
	echo "Error: Cannot find directory \"$ORIGINAL_DIRECTORY\" inside \"$ORIGINAL_REPO\"."
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
git filter-branch --prune-empty --subdirectory-filter $ORIGINAL_DIRECTORY -- --all

# Garbage collect all commits that are not part of your library.
git reset --hard
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
git reflog expire --expire=now --all
git gc --aggressive --prune=now

# Rename this directory to library name.
cd ..
mv $TEMP_DIR $NEW_LIB_NAME

echo
echo "Done: Directory \"$ORIGINAL_DIRECTORY\" extracted to \"$NEW_LIB_NAME\"."
