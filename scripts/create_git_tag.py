#!/usr/bin/env python3

from git import Repo
import os
import semver
import git



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
        print("Current Git tag Version is =>", tag_list[0])

        print("Bumping to new Version")
        new_tag = str(semver.VersionInfo.parse(tag_list[0]).bump_minor())
        print("minor bump version is =>", new_tag)
        print("Verifying New tag version is Valid =>", semver.VersionInfo.isvalid(new_tag))
        commit_message = "Bumping to " + new_tag + " new tag version"
        # self.git_push(new_tag, commit_message)
        self.check_git_push()

    # def git_push(self, new_tag, commit_message):
    #     print("Git Push with", new_tag, " with commit message =>", commit_message)
    #     try:
    #         response = StringIO.StringIO()
    #         c = pycurl.Curl()
    #         c.setopt(c.URL, 'https://api.github.com/repos/$REPO_OWNER/$repo/git/refs')
    #         c.setopt(c.WRITEFUNCTION, response.write)
    #         c.setopt(c.HTTPHEADER, ['Content-Type: application/json', 'Accept-Charset: UTF-8'])
    #         c.setopt(c.POSTFIELDS, '@request.json')
    #         c.perform()
    #         c.close()
    #         print(response.getvalue())
    #         response.close()
    #     except ValueError as e:
    #         print("Some error occured while pushing the code ", e)
    #         raise

    def check_git_push(self):
        print("Git checkout the branch")
        repo = Repo(os.getcwd())
        print(repo.remotes.origin.url)
        # hello = git.Tag.create(repo, "0.3.4")
        # print(hello)
        # git.Commit.message()
        # repo = Repo(os.getcwd())
        add = repo.remote().add_url('https://github.com/arjunan4/actions.git')
        print(add)
        repo.remote().push()


hello = CreateGitTags()
hello.create_git_tag()
