# Setup data files

Following files you find here:

* /docker\
  * /dockerfiles\
    * pi\
      * teamcity-server: This will simpply build a teamcity server for raspberry pi\
        * 64bit\
        * Based on an alpine image\
        * OpenJdk 11, Maven and Git\
        * Use a 'teamcity' network<
      * teamcity-agent\
        * 64bit\
        * Based on an alpine image\
        * OpenJdk 11, Maven and Git\
        * Use a 'teamcity' network\
      * teamcity-network<
        * Create an docker network for teamcity on docker\
