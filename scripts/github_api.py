from pprint import pprint
import requests
import json

class GitHubAPI:

    def __init__(self):
        self.base_url = f"https://api.github.com"
        self.org_url = self.base_url + "/users/arjunan4"
        self.headers = {'Authorization': 'token 45e4c506f2bce7233f1308d31fbe6f2bec67c9e5'}

    def calling(self):
        response = json.loads(requests.get(self.org_url + '/repos', headers=self.headers).text)
        print(len(response))
        repo_names = []
        for i in response:
            repo_names.append(i['name'])
        print("repo names =>", repo_names)
        print(len(repo_names))

    def check(self):
        response = json.loads(requests.get('https://api.github.com/repos/arjunan4/ashcloud/actions/runs', headers=self.headers).text)
        # print(response)
        # print(type(response))
        print(len(response))
        # print(response.keys())
        # print(response.values())
        #
        for key in response.keys():

            print(key,)


hello = GitHubAPI()
# hello.calling()
hello.check()

