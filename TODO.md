## Refactoring & developement: 
- create general updateUnitypesState sensor
    - based on updateFARKS, SEER, Transports, ...
    - same internal representaiton: {uidToIndex, indexToUid, state} 
    - takes predicate on UnitDefs 

    - ?maybe just unite internal representation and leave separate sensors?
    - index to uid redundant

- fix seer distribution & buying
    - not all of them move -> problem
    - assign states according to lanes (?same mechanism as with FARKS?, ?generalize)

- update lanePressure sensor
    - rename to something more sensible
    - add bunch of stuff
        - index of first dangerous point
        - index of last safe stronghold 
        - map of all points (indexable, in order)
        
        - ?remove frontLoc (used in FARKS)

    - if there's no front -> use the previous one, start with 5

- create MoveHandler tree:
    - bb.unitsToMove 
        - index -> {uid, destLane, pointsFromFirstUnsafe , state}
        - uid -> index 
        - (lastSafePoint - pointsFromFirstUnsafe -> index of point to move)

    - sends them airflift if needed / commands them to move 
    - has internal state waiting on transport -> in progress 
        - uid of their transport (if dead -new)
        - moving if moving by themselves
    - removed from this after the traport is finished 
        - airliftTree finished -> updates via tranportedUnitId
        - those that can move themselves are checked to proximity to their destination 

- laneDefenceManager tree:
    - all units are assigned to some lane / attack (4)
    - per lane, checks units assigned to it 

    - creates orders for new ones if doesn't have enough / bad types 
    - assignes unassigned unit it needs for itself (if noone needs units -> attack group)
        - replace with order system?
    - check if units need to be moved 
        - loops over all assigned unit, checks their distance to their preffered distance from front -> add to unitsToMove
        - ?have central perType prefferedDistance map in sensor?

- attackManager 
    - hord units in safe position at central lane
    - when enough units -> move them to attack using move manager to -2 lastSafePoint / artilery accordingly
    
    - have at least one following radar & spy for LoS

## Cleanup stuff:
- fix all typos seekers -> seer, farcks -> farks
- unite naming conventions for 
    - sensors: update/get 
    - trees: highLevel commands, lower level unit stuff, per lane stuff, ...

