About
=====

**git-repository-extractor** extracts subdirectories of a certain [Git](http://git-scm.com) repository into new clean repositories, rewriting the Git history and leaving only the commits and files that belong to the extracted files.

This is useful if you want to extract parts of a bigger Git repository into smaller ones.

Don't worry that this script will **never** change or delete files from your original repository. You will have to delete the files from your original repository later if you want, and then you can add the extracted one as a [submodule](http://git-scm.com/book/en/Git-Tools-Submodules), for instance.

Usage
=====

Clone this repository and run *git-repository-extractor.sh*:

	$ git clone git@github.com:guilhermechapiewski/git-repository-extractor.sh.git  
	$ cd ./git-repository-extractor.sh  
	$ ./git-repository-extractor.sh [repo_url] [path_of_directory_to_extract]

Example:

	$ ./git-repository-extractor.sh "git@github.com:guilhermechapiewski/simple-db-migrate.git" "example/mysql"

After you run it
================

A directory should have been created under the current directory, which will be a full rewritten git repository named after the original directory. You can rename it to whatever you want, then push it to a new separate repository on Github that you will have to create:

	$ mv ./mysql ./mysql_examples
	$ cd ./mysql_examples
	$ git remote add origin git@github.com:guilhermechapiewki/mysql_examples.git
	$ git push -u origin master