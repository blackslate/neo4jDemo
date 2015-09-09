
;(function(){
  /* Place custom URL to Neo4j here */
  Meteor.neo4j.connectionURL = "http://neo4j:1234@localhost:7474"

  /* Use the following line to test with a remote Neo4j database */
  // Meteor.neo4j.connectionURL = "http://Meteo4j:K64BoXjts4ObqKRC0jHx@meteo4j.sb02.stations.graphenedb.com:24789"
  
  /* Allow query execution by the client */
  Meteor.neo4j.allowClientQuery = true
  /* Deny all writing actions on client */
  Meteor.neo4j.set.deny(Meteor.neo4j.rules.write)
})()

