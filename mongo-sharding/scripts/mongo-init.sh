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

docker exec -i shard1 mongosh --port 27018 --eval '
db = db.getSiblingDB("somedb");
db.helloDoc.countDocuments();
'

docker exec -i shard2 mongosh --port 27019 --eval '
db = db.getSiblingDB("somedb");
db.helloDoc.countDocuments();
'