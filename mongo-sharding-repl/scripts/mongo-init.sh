#!/bin/bash

###
# Инициализируем бд
###

docker exec -i mongos_router mongosh --port 27020 --eval '
sh.addShard("shard1-1/shard1:27018");
sh.addShard("shard2-1/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name": "hashed" });
db = db.getSiblingDB("somedb");
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
'

echo "Shard1 primary (shard1):"
docker exec -i shard1 mongosh --port 27018 --eval '
db = db.getSiblingDB("somedb");
print("Documents count: " + db.helloDoc.countDocuments());
print("Replica set members: " + rs.status().members.length);
'

echo "Shard1 secondary (shard1-2):"
docker exec -i shard1-2 mongosh --port 27018 --eval '
db = db.getSiblingDB("somedb");
print("Documents count: " + db.helloDoc.countDocuments());
print("Replica set members: " + rs.status().members.length);
'

echo "Shard1 secondary (shard1-3):"
docker exec -i shard1-3 mongosh --port 27018 --eval '
db = db.getSiblingDB("somedb");
print("Documents count: " + db.helloDoc.countDocuments());
print("Replica set members: " + rs.status().members.length);
'

echo "Shard2 primary (shard2):"
docker exec -i shard2 mongosh --port 27019 --eval '
db = db.getSiblingDB("somedb");
print("Documents count: " + db.helloDoc.countDocuments());
print("Replica set members: " + rs.status().members.length);
'

echo "Shard2 secondary (shard2-2):"
docker exec -i shard2-2 mongosh --port 27019 --eval '
db = db.getSiblingDB("somedb");
print("Documents count: " + db.helloDoc.countDocuments());
print("Replica set members: " + rs.status().members.length);
'

echo "Shard2 secondary (shard2-3):"
docker exec -i shard2-3 mongosh --port 27019 --eval '
db = db.getSiblingDB("somedb");
print("Documents count: " + db.helloDoc.countDocuments());
print("Replica set members: " + rs.status().members.length);
'