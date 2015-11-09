# rd-tool
Rundeck tool

```
Usage: rd-tool SUBCOMMAND SUBCOMMAND TARGET
rd-tool requires at least Rundeck 2.6.0 and a valid token within token.yaml file

Available subcommands:

  projects replicateToInstance                      Replicate Rundeck projects to another Rundeck instance, this action remove all existent project on target
  projects backupToFile                             Backup Rundeck projects to a zip file
  projects replicateFromInstance                    Replicate Rundeck projects from another Rundeck instance, this action remove all existent project on the local Instance
  projects restoreFromFile                          Restore Rundeck projects from a previously generated backupToFile zip file, this action remove all existent project
  projects pushToRepo                               Push Rundeck projects to git repository, requires a valid non empty repository url as parameter, an empty README.md file would be enough
  projects restoreFromRepo                          Restore Rundeck projects from repository, this action remove all existent projects on the local instance

Examples:

  ruby rd-tool projects replicateToInstance rundeck.foo.bar
  ruby rd-tool projects backupToFile foo.zip
  ruby rd-tool projects replicateFromInstance rundeck.foo.bar
  ruby rd-tool projects restoreFromFile foo.zip
  ruby rd-tool projects pushToRepo 'git@git.foo.com:devops-rundeck/foo-repo.git'
  ruby rd-tool projects restoreFromRepo 'https://github.com/snebel29/foo-repo'
```
