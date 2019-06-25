# Redis Sentinel Manager

Service intended to be launched alongside [Redis](https://redis.io/) pods and [Sentinel](https://redis.io/topics/sentinel) constellations for dynamic configuration management and monitoring.

* It dynamically configures Sentinel masters based on [Consul](https://www.consul.io/) catalog.
* Monitors that all configured Redis pods exist.
* Monitors that all pods are replicating properly by making sure only 1 master exists.
