job "redis_sentinel" {

  type = "service"

  datacenters = [
    "us-west"
  ]

  constraint {
    attribute = "${node.class}"
    value = "admin"
  }

  group "redis_sentinel" {
    count = 5
    task "redis_sentinel" {
      driver = "docker"
      config {
        image = "redis:3.0.7-alpine"
        args = [
          "/usr/local/etc/redis/sentinel.conf",
          "--sentinel",
          "announce-ip",
          "${NOMAD_IP_sentinel}"
        ]
        port_map {
          sentinel = 26379
        }
      }
      service {
        name = "redis-sentinel"
        port = "sentinel"
        check {
          type = "tcp"
          timeout = "5s"
          interval = "30s"
        }
      }
      resources {
        memory = 100
        network {
          mbits = 1
          port "sentinel" {
            static = 26379
          }
        }
      }
    }
  }

  group "redis_sentinel_manager" {
    count = 1

    task "redis_sentinel_manager" {
      driver = "docker"
      config {
        image = "trotttrotttrott/redis-sentinel-manager:0.0.1"
      }
      env {
        # Names of masters to manage.
        REDIS_MASTERS = "cache sessions something-else"
        # Each master and the rest of its pod must have a corresponding Consul service.
        MASTER_CONSUL_SERVICE_PREFIX = "redis-"
        # Sentinel Consul service name.
        SENTINEL_SERVICE = "redis-sentinel"
        # 3/5 sentinels form a quorum.
        QUORUM = 3
        # Diplomat gem uses this to connect to Consul API.
        CONSUL_HOST = "${NOMAD_IP_http}"
        # Http check will be exposed on this port.
        CHECK_PORT = "${NOMAD_PORT_http}"
      }
      service {
        name = "redis-sentinel-manager"
        port = "http"
        check {
          type = "http"
          path = "/status"
          timeout = "5s"
          interval = "30s"
        }
      }
      resources {
        memory = 100
        network {
          port "http" {}
          mbits = 1
        }
      }
    }
  }
}
