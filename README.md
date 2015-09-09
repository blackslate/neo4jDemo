# neo4jDemo
Hello-->World demo, using Meteor and Neo4j

## Set up (tested on Mac OS 10.10 Yosemite)
### Install Meteor
curl https://install.meteor.com/ | sh

### Install Neo4j
http://neo4j.com/download/

- Download community edition
- Decompress the files
- Move the `neo4j` director to where you want it. I'll assume that you have moved it to here:

    $ cd ~/neo4j

- On Mac OS 10.10 Yosemite, you might need to [install Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) before Neo4j will run.
- Launch Neo4j to test that it is working
- Open your browser at [http://localhost:7474](http://localhost:7474) to see the Neo4j browser
- Set password for the neo4j user, and remember it so that you can use it when asked. I'll assume you choose `1234`.

### Install neo4j driver globally
If you haven’t already got Node.js installed, you will need to [install it first](https://nodejs.org/), so that you can use npm, for this next step.

$ su admin # or whatever your admin account is called
$ sudo npm -g install neo4j

## Running the demo
$ cd /path/to/neo4jDemo/
$ meteor run

**Note: If you have placed Neo4j in a different location, or if you have used a different password, you can copy the initNeo4j.sh file to a new folder, cd into that folder, then run:**

    $ ./initNeo4j.sh
    
**You will be asked what you want to name your demo, where Neo4j is installed and what its password is.**

## Result
You should see a big button that says [ Hello ]. If you click on it, it should say [ World ]

