About
=====

**git-repository-extractor** extracts subdirectories of a certain git repository into new clean repositories, rewriting the Git history and leaving only the commits and files that touched that subdirectory.

This script is useful if you want to extract parts of a bugger git repository into smaller separate ones.

Usage
=====

Clone this repository and run *git-repository-extractor.sh*:

	$ git clone git@github.com:guilhermechapiewski/git-repository-extractor.sh.git  
	$ cd ./git-repository-extractor.sh  
	$ ./git-repository-extractor.sh.sh [path_to_directory_on_your_local_git_clone]

Don't worry that this script will **never** change or delete files from your original repository.

After you run it
================

A directory should have been created under the current directory, which will be a full rewritten git repository named after the original directory. You can rename it to whatever you want, then push it to a new separate repository on Github that you will have to create:

	$ mv ./mysubdirectory ./new_library
	$ cd ./new_library
	$ git remote add origin git@github.com:guilhermechapiewki/new_library.git
	$ git push -u origin master