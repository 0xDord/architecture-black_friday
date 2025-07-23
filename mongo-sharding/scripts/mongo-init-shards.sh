#!/bin/bash

###
# Инициализируем шарды
###

docker exec -i shard1 mongosh --port 27018 --eval '
rs.initiate({
  _id: "shard1-1",
  members: [
    { _id: 0, host: "shard1:27018" }
  ]
})
'

docker exec -i shard2 mongosh --port 27019 --eval '
rs.initiate({
  _id: "shard2-1",
  members: [
    { _id: 0, host: "shard2:27019" }
  ]
})
'