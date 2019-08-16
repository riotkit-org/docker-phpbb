#!/usr/bin/env python3

import requests
import sys
import subprocess


class BuildAllReleases:
    url: str
    build_command: str

    def __init__(self, repo_name: str, build_command: str):
        self.url = 'https://api.github.com/repos/%s' % repo_name
        self.build_command = build_command

    def build_last_versions(self, max_versions: int):
        tags = self.get_available_tags()
        to_build = {'snapshot': 'master'}
        versions_left = max_versions
        result = True

        for tag in tags:
            if versions_left == 0:
                break

            if not tag.startswith('release-'):
                if tag == 'start':
                    continue

                print('!!! Found a weird tag %s' % tag)
                continue

            to_build[tag.replace('release-', '')] = tag
            versions_left -= 1

        for version, git_tag in to_build.items():
            try:
                command = self.build_command\
                    .replace('%VERSION%', version) \
                    .replace('%TAG%', git_tag)

                print(' ===> %s' % command)
                print(subprocess.check_output(command, stderr=sys.stderr, shell=True))

            except subprocess.CalledProcessError as e:
                print(e.output)
                result = False

        return result

    def get_available_tags(self) -> list:
        response = requests.get(self.url + '/tags').json()

        return list(map(
            lambda tag_object: str(tag_object['name']),
            response
        ))


app = BuildAllReleases(
    repo_name='phpbb/phpbb',
    build_command='make build VERSION=%VERSION% TAG=%TAG% ' + ' '.join(sys.argv[1:])
)
sys.exit(0 if app.build_last_versions(max_versions=5) else 1)
