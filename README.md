# Redis Sentinel Manager

Will tell Sentinels which masters to monitor based on existing Consul nodes and associated services.

Also makes sure that:

* All configured Redis pods exist.
* All pods are replicating properly by making sure only 1 master exists.

Misconfigurations can be monitored with builtin http check.
