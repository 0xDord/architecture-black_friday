#!/bin/bash

###
# Инициализируем шарды с 3 репликами
###

docker exec -i shard1 mongosh --port 27018 --eval '
rs.initiate({
  _id: "shard1-1",
  members: [
    { _id: 0, host: "shard1:27018" },
    { _id: 1, host: "shard1-2:27018" },
    { _id: 2, host: "shard1-3:27018" }
  ]
})
'

docker exec -i shard2 mongosh --port 27019 --eval '
rs.initiate({
  _id: "shard2-1",
  members: [
    { _id: 0, host: "shard2:27019" },
    { _id: 1, host: "shard2-2:27019" },
    { _id: 2, host: "shard2-3:27019" }
  ]
})
'