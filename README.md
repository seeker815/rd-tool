# rd-tool
Rundeck tool

```
Usage: rd-tool.rb SUBCOMMAND SUBCOMMAND TARGET

Available subcommands:

  projects exportToFile                             Export Rundeck projects to file, requires a valid filename
  projects importFromFile                           Import Rundeck projects from a zip file
  projects importFromInstance                       Import Rundeck projects from another Rundeck instance
  projects importFromRepo                           Import Rundeck projects from repository, requires a valid repository url as parameter
  projects exportToRepo                             Export Rundeck projects to repository, requires a valid non empty repository url as parameter, an empty README.md file would be enough
  projects exportToInstance                         Export Rundeck projects to another Rundeck instance

Examples:

  ruby rd-tool.rb projects exportToFile foo.zip
  ruby rd-tool.rb projects importFromFile foo.zip
  ruby rd-tool.rb projects importFromInstance rundeck.foo.bar
  ruby rd-tool.rb projects importFromRepo 'https://github.com/snebel29/foo-repo'
  ruby rd-tool.rb projects exportToRepo 'https://github.com/snebel29/foo-repo'
  ruby rd-tool.rb projects exportToInstance rundeck.foo.bar
```
