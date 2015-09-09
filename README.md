# neo4jDemo
Hello-->World demo, using Meteor and Neo4j

![Demo Maze](http://lexogram.github.io/Meteo4j/img/map.png)

## Set up
Here are the steps to get this demo working an a clean install of Mac OS 10.10 Yosemite or Ubuntu 15.04.
You will need to install:

- curl (Ubuntu only)
- Git
- Java Runtime Environment 1.7 or later
- npm (Node.js Package Manager)
- Meteor
- Neo4j
- A Neo4j driver
- The demo itself

If you have any of these already installed, you can skip the associated steps.

### Ubuntu only: install curl

    sudo apt-get update
    sudo apt-get install curl
    
### Install Git
#### Ubuntu

    sudo apt-get install git

#### Mac OS X
[Download an installer](http://git-scm.com/download/mac)
[Download the Apple CommandLine tools](https://developer.apple.com/downloads/) for your version of OS X.

(You might need to create a Developer ID before you can access the page). Install both packages. Check in the Terminal that Git is running correctly:

    $ which git
    /usr/bin/git
    $ git --version
    git version 2.3.2 (Apple Git-55)
    
### Install Java
#### Ubuntu

    sudo apt-get install openjdk-7-jre

    $ java -version
    Picked up JAVA_TOOL_OPTIONS: -javaagent:/usr/share/java/jayatanaag.jar 
    java version "1.7.0_79"
    OpenJDK Runtime Environment (IcedTea 2.5.6) (7u79-2.5.6-0ubuntu1.15.04.1)
    OpenJDK 64-Bit Server VM (build 24.79-b02, mixed mode)

#### Mac OS X
[Download the installer](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

Check that the installation is working in the Terminal:

    $ java -version
    java version "1.8.0_60"
    Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
    Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)

### Install npm (from Node.js)
#### Ubuntu

    sudo apt-get install npm

#### Mac OS X
[Download the Node.js installer](https://nodejs.org/) and run it.

### Install Meteor

    curl https://install.meteor.com/ | sh

### Install Neo4j

[http://neo4j.com/download/](http://neo4j.com/download/)

- Download community edition
- Decompress the files
- Move the `neo4j` director to where you want it. I'll assume that you have moved it to here:

    ~/neo4j

- Launch Neo4j to test that it is working:

    $ ~/neo4j/bin/neo4j start

- Open your browser at [http://localhost:7474](http://localhost:7474) to see the Neo4j browser
- Log in as neo4j with the temporary password neo4j
- You'll be asked to se the password for the neo4j user. Set it to 1234 (for simplicity for now. You can change it to something else by using `:server change-password`)

### Install the neo4j driver globally, using npm

    $ sudo npm -g install neo4j

## Running the demo
    $ cd /path/to/neo4jDemo/
    $ meteor run

**Note: If you have placed Neo4j in a different location, or if you have used a different password, you can copy the initNeo4j.sh file to a new folder, cd into that folder, then run:**

    $ ./initNeo4j.sh
    
**You will be asked what you want to name your demo, where Neo4j is installed and what its password is.**

## Result
You should see a big button that says [ Hello ]. If you click on it, it should say [ World ].

The demo creates two Neo4j nodes, with the names "Hello" and "World", and two links between them, creating a looped sequence. Here's the Cypher query:

    CREATE
      (a:Node {name:'Hello'})-[:LINK]->(b:Node {name:'World'})
    , b-[:LINK]->a
    RETURN a
    
Here's what this looks like in the Neo4j browser:
image::http://lexogram.github.io/Meteo4j/img/helloWorld.png?raw=true[Neo4j Browser View]

When you click on the button, Meteor will use Neo4j will follow the link to the next node in the sequence and display its name.
