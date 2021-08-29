# Monitoring
![](https://prometheus.io/assets/grafana_prometheus.png)
https://www.reddit.com/r/homelab/comments/c2yfss/docker_monitoring_with_prometheus_und_grafana/
## Sample use cases
![](https://i.imgur.com/mBxFxUZ.png)

Prometheus gather metrics from exporters that must be running on the monitored hosts, stores them in it's own time series database, can display graphs of those series and trigger alerts. You can see it as a monitoring solution.

Grafana is a dashboard builder/display a lot of graphs for a lot of databases (including Prometheus one) and optionally send simple alerts too. It is fundamentally a visualization solution, it doesn't gather the metrics/feeds whatever db, not can generate complex alerts. But you can couple it with a lot of DBs (other time series databases, elasticsearch, MySQL and more) not just Prometheus. 
<br>

# Two link to get you started:
https://geekflare.com/prometheus-grafana-setup-for-linux/ <br>
https://www.fosslinux.com/10398/how-to-install-and-configure-prometheus-on-centos-7.htm <br>
Also, you can monitor many different types of metrics not just limited to node exporter, you can monitor network traffic, also sql query and such etc.

# Config on running prom, graf and crud app as well as mysql via a single docker compose:
```
version: '3'

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data: {}

services:
  mysql:
    image: mysql:5.6
    ports:
      - 3307:3306
    environment:
      - MYSQL_ROOT_PASSWORD=newpass
      - 'MYSQL_DATABASE=kaushik'
    volumes:
      - ./mysqldump:/docker-entrypoint-initdb.d # mysqldump folder should contain db.sql
    restart: unless-stopped

  my-app-crud:
    image: my-app-crud:1.0
    restart: unless-stopped
    network_mode: "host"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
#    expose:
#      - 9100
    ports:
     - "9091:9100"

    networks:
      - monitoring

  promcontainer:
    image: "prom/prometheus:latest"
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/etc/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
#    expose:
#      - 9090
    networks:
     - monitoring
    ports:
     - "9090:9090"

  grafanacontainer:
    image: "grafana/grafana"
    ports:
     - "3000:3000"
    networks:
     - monitoring

```
# Be sure that prometheus.yml is in your working directory, same as docker-compose.yaml
`prometheus.yml`
```
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus_master'
    scrape_interval: 5s
    static_configs:
      - targets: ['34.234.35.40:9090']

  - job_name: 'node_exporter_centos'
    scrape_interval: 5s
    static_configs:
      - targets: ['34.234.35.40:9091']

```

![](https://i.imgur.com/3LxnGMN.png)
![](https://i.imgur.com/42TZnA6.png)

Fixed:
1. docker overlay for mysql 
2. 9090,9091 in background = just changed localhost, not public ip on prometheus.yaml
3.  node exporter not running = done

Fix Bad gateway when adding data source:
https://github.com/grafana/grafana/issues/14629

**As a note, you also need to persists Grafana config so you will create a template, once you restarted the grafana container**
