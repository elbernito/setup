# Setup data files

Following files you find here:

* /docker
  * /dockerfiles
    * /pi
      * /teamcity-server
        * 64bit
        * Based on an alpine image
        * OpenJdk 11, Maven and Git
        * Use a 'teamcity' network
      * /teamcity-agent-01
        * Adds first agent to teamcity
        * 64bit
        * Based on an alpine image
        * OpenJdk 11, Maven and Git
        * Use a 'teamcity' network
      * /teamcity-agent-02
        * Adds second agent to teamcity
        * 64bit
        * Based on an alpine image
        * OpenJdk 11, Maven and Git
        * Use a 'teamcity' network
      * /teamcity-network
        * Create an docker network for teamcity on docker
