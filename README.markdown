Usage
=====

    ruby multilog.rb "date-pattern" logfile1 logfile2 logfile3

Example
=======

    ruby multilog.rb "Wed May 04 20:16:02 CEST 2011" `find neo4jlogs -name "messages.log"` | less

Sample-Output
=============

    Wed May 04 20:17:40 +0200 2011 |: org.neo4j.kernel.ha.zookeeper.ZooClient@786c1a82 |                                                   |
    Wed May 04 20:17:40 +0200 2011 |: getMaster 1 based on [(1, 1, 1), (2, 1, 4), (3,  |                                                   |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: org.neo4j.kernel.ha.zookeeper.ZooClient@337b4703 |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: Read HA server:neo4jnode3.sf.viadeo.local:6001 ( |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: getMaster 1 based on [(1, 1, 1), (2, 1, 4), (3,  |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: org.neo4j.kernel.ha.zookeeper.ZooClient@337b4703 |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: getMaster 1 based on [(1, 1, 1), (2, 1, 4), (3,  |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: newMaster((org.neo4j.kernel.ha.MasterClient@6986 |
                                   |                                                   |java.lang.Exception                                |
                                   |                                                   |  at org.neo4j.kernel.ha.zookeeper.ZooClient.proce |
                                   |                                                   |  at org.apache.zookeeper.ClientCnxn$EventThread.p |
                                   |                                                   |  at org.apache.zookeeper.ClientCnxn$EventThread.r |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: ReevaluateMyself: machineId=2 with master[(org.n |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: master-notify not set, is already 1              |
    Wed May 04 20:17:41 +0200 2011 |                                                   |: Master id for last committed tx ok with highestC |
    Wed May 04 20:20:55 +0200 2011 |: getMaster 1 based on [(1, 1, 1), (2, 1, 4), (3,  |                                                   |
    Wed May 04 20:20:57 +0200 2011 |                                                   |: getMaster 1 based on [(1, 1, 1), (2, 1, 4), (3,  |
    Wed May 04 20:26:46 +0200 2011 |: applyTxWithoutTxId log version: 0, committing tx |                                                   |
    Wed May 04 20:26:46 +0200 2011 |: ZooClient setting txId=2 for machine=1           |                                                   |


