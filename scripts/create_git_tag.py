#!/usr/bin/env python3

from git import Repo
import os
import semver
import git


class CreateGitTags:

    def create_git_tag(self):
        os.chdir('../')
        repo = Repo(os.getcwd())
        # branch = repo.active_branch
        print("Repository name is =>", repo)
        # print("Active branch nane", branch)
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
        # os.chdir('./scripts')
        # print("Changing to python script directories")
        # os.getcwd()

        print("Current Git tag Version is =>", tag_list[0])
        print("Bumping to new Version")

        new_tag = str(semver.VersionInfo.parse(tag_list[0]).bump_minor())
        print("minor bump version is =>", new_tag)
        print("Verifying New tag version is Valid =>", semver.VersionInfo.isvalid(new_tag))
        commit_message = "Bumping to " + new_tag + " new tag version"
        # self.git_push(new_tag, commit_message)

    def git_push(self, new_tag, commit_message):
        print("Git Push with", new_tag, " with commit message =>", commit_message)
        try:
            os.chdir('../')
            repo = git.Repo.clone_from('https://github.com/arjunan4/actions/')
            repo.index.add()
            repo.index.commit('checking remote')
            print(repo.remotes.origin.push())
            # print("Repo path is ==>", repo)
        except ValueError as e:
            print("Some error occured while pushing the code ", e)
            raise


hello = CreateGitTags()
hello.create_git_tag()
