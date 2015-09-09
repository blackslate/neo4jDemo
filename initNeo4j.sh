## NOTES: 
# Script doesn't halt if an app with the given name already exists.
# Script doesn't offer alternative ports for Meteor and MongoDB

# Define defaults
path_default="~/neo4j/bin/neo4j"
port_default="7474"
pass_default="1234"
meteor_port="3000"
# meteor_default=$meteor_port
version="2.0.0-RC2"
# Need to start mongod on a different port

# Ask for custom values
echo -n "Enter app name: "
read app
read -p "Enter path to neo4j [$path_default]: " path
path="${path:-$path_default}"
read -p "Enter port to neo4j [$port_default]: " port
port="${port:-$port_default}"
read -p "Enter password for neo4j [$pass_default]: " pass
pass="${pass:-$pass_default}"

# Convert ~ to /Users/$USER if necessary (Mac OS X)
if [[ ${path:0:1} == "~" ]]; then
  path="/Users/$USER"${path#"~"}
fi

# Check that meteor is not currently running on port 3000
if lsof -t -i:3000; then
  echo "Meteor (or some other app)is already running on port 3000."
  # read -p "What port do you want to use? [$meteor_default]: " meteor_port
  # meteor_port="${meteor_port:-$meteor_default}"
  # case $meteor_port in
  #   3000)
      read -n1 -p "Are you sure that you want to stop this process? [y,n]" response
      echo
      case $response in
        # Kill the process on port 3000 if the user requests it
        # ALSO KILLS THE BROWSER?   
        y|Y)
          kill `lsof -t -i:3000` ;; 
        *)
          echo "Exiting script"
          exit 1;
      esac
  # esac
fi
# echo $path, $port, $pass, $version, $meteor_port

meteor create $app
cd $app
meteor add meteorhacks:npm
meteor --port $meteor_port
echo -e "{\n  \"neo4j\": \"$version\"\n}" > packages.json
meteor add ostrio:neo4jreactivity
meteor remove autopublish
meteor remove insecure

# Initialize connection to Neo4j server
mkdir lib && cat > lib/neo4j.js << EOF

;(function(){
  /* Place custom URL to Neo4j here */
  Meteor.neo4j.connectionURL = "http://neo4j:$pass@localhost:$port"
  /* Allow query execution by the client */
  Meteor.neo4j.allowClientQuery = true
  /* Deny all writing actions on client */
  Meteor.neo4j.set.deny(Meteor.neo4j.rules.write)
})()

EOF

# Create default Hello-->World HTML page
cat > $app.html << EOF
<head>
  <title>neo4jCallBack</title>
</head>

<body>
  <h1>Welcome to Meteor with Neo4j</h1>

  {{> hello}}
</body>

<template name="hello">
  <button type="button">{{name}}</button>
</template>
EOF

# Create basic Neo4j implementation in JavaScript
cat > $app.js << EOF

// Collection
var helloWorld = Meteor.neo4j.collection("helloWorld")
var key = "button"

// Queries
var destroy =
  "MATCH (n:Node) " +
  "OPTIONAL MATCH n-[r:LINK]-() " +
  "DELETE n, r"
var create = 
  "CREATE" +
  "  (a:Node {name:'Hello'})-[:LINK]->(b:Node {name:'World'})" +
  ", b-[:LINK]->a " +
  "RETURN a"
var click = 
  "MATCH (a:Node)-->(b:Node) " +
  "WHERE a.name = {name} " +
  "RETURN b"


if (Meteor.isClient) {
  Session.setDefault("name", "Hello")

  Tracker.autorun(function (){
    // key = "button" (identifies the publish/subscription channel)
    var options = {name: Session.get("name")} // {} with `name` key
    var link = "b" // same as the key for the RETURNed value
    var subscription = helloWorld.subscribe(key, options, link)
  })

  Template.hello.helpers({
    name: function () {
      return Session.get("name")
    }
  })

  Template.hello.events({
    'click button': function () {
      // helloWorld is a MongoDB Collection
      var cursor = helloWorld.find() //  LocalCollection.Cursor
      var result = cursor.fetch() // array of node objects
      var node = result[0] || {}// first object in array
      var name = node.name || "Not found"
      Session.set("name", name);
    }
  })
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    var options = null

    Meteor.N4JDB.query(destroy, options, function(error, data){
      console.log("Destroyed: ",error,data)

      Meteor.N4JDB.query(create, options, createCallback)

      function createCallback(error, data){
        console.log("Created: ",error,data)
      }
    })

    helloWorld.publish(key, publishCallback)

    function publishCallback() {
      // `this` is {name: <"Hello" | "world">}
      console.log(click, this)
      return click
    }
  });
}

EOF

# Basic CSS to make the button visible
cat > $app.css << EOF
body {
  text-align:center;
}

button{
  font-size: 3em;
}
EOF

# Ignore unimportant files
cat > .gitignore << EOF
.DS_Store
.gitignore
EOF

git init
git add .
git commit -m "Hello-->World setup with Meteor and Neo4j"

if !(lsof -t -i:$port); then
  echo "Starting Neo4j"
  $path start
fi
meteor --port $meteor_port
