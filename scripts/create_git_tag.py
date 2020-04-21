#!/usr/bin/env python3

import git
from git import Repo
import os

class CreateGitTags:

    def create_git_tag(self):
        os.chdir('../')
        print("Changing to home directory", os.getcwd())
        print('List directories', os.listdir())
        repo = Repo(os.getcwd())
        # print("Git Repository Head details ==> ", repo.head.ref)
        # print("Git Repository Master details ==>", repo.heads.master)
        print("Git Repository tags details ==>", repo.tags)
        tag_result = repo.git.tag(l=True)
        print('Tags results Object Type ==>', type(tag_result))
        print('Tags results are ==>', tag_result)
        print("Changing Directory to Original Path")

        os.chdir('./scripts')
        print("Changing to python script directoriesfss", os.getcwd())

hello = CreateGitTags()
hello.create_git_tag()
