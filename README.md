# Bionexo Test

After clone, execute:

` cd bionexo_test `

` bundle install `

` cd lib/ `

` irb `

` 2.4.2 :001 > require_relative 'delivery_gain.rb' `

` => true `

set your graph, ex.:

` 2.4.2 :002 > graph = ['AD4', 'DE1', 'EC8', 'CB2', 'BA6', 'AC9', 'DF7', 'FC5', 'FE9', 'BD3', 'FA3'] `

` => ["AD4", "DE1", "EC8", "CB2", "BA6", "AC9", "DF7", "FC5", "FE9", "BD3", "FA3"] `

then call <b>DeliveryGain process</b> method with <b>graph</b>  parameter:

` 2.4.2 :003 > DeliveryGain.process(graph) `

you output will be:

`=> [5, "NO SUCH ROUTE", 10, 19, 5, 3, 6, 2, 5, 6, 27, 137] `

Output:
Array with <b>12 outputs</b> following the rules in test:

1. The cost of the route A-D-E.
2. The cost of the route A-F-E.
3. The cost of the route E-C-B.
4. The cost of the route B-D-F-E.
5. The cost of the route F-C.
6. How many routes are arriving the client `C`
7. How many routes start at the client `B` and end at the client `A` with a maximum of 5 stops.
8. How many routes start at the client `A` and end at the client `A` with exactly 3 stops.
9. The cost of the shortest route between the clients `A` and `E`.
10. The cost of the shortest route between the clients `C` and `E`.
11. The number of different routes between the clients `A` and `B` that costs less than 40.
12. The number of different routes between the clients `E` and `D` that costs less than 60.



