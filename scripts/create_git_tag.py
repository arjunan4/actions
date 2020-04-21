#!/usr/bin/env python3

from git import Repo
import os

class CreateGitTags:

    def create_git_tag(self):
        os.chdir('../')
        repo = Repo(os.getcwd())
        print('===> Fetching remote tags===>')
        repo.remote().fetch('--tags')
        result = repo.git.tag(l=True)
        tag_list = result.strip().split('\n')
        print("Git Tag results, before sorting in Descending Order => ", tag_list)
        range_number = len(tag_list)
        print("Number of elements in the list =>", range_number)
        for i in range(range_number):
            for j in range(i + 1, range_number):
                if tag_list[i] < tag_list[j]:
                    temp = tag_list[i]
                    tag_list[i] = tag_list[j]
                    tag_list[j] = temp
        print("Git Tag results, after sorting in Descending Order => ", tag_list)
        print("Required Git tag version", tag_list[0])
        print("Changing Directory to Original Path")
        os.chdir('./scripts')
        print("Changing to python script directories", os.getcwd())


hello = CreateGitTags()
hello.create_git_tag()
