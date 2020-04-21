#!/usr/bin/env python3

import git

class CreateGitTags:

    def create_git_tag(self):
        print('Creating Git tag for the repository after PR is merged')
        g = git.cmd.Git()
        print("Git First command is  " + g)


hello = CreateGitTags()
hello.create_git_tag()
