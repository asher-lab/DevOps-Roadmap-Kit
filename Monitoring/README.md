# Monitoring
![](https://prometheus.io/assets/grafana_prometheus.png)
https://www.reddit.com/r/homelab/comments/c2yfss/docker_monitoring_with_prometheus_und_grafana/
## Sample use cases
![](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.3/vmware-tanzu-kubernetes-grid-13/images/images-monitoring-stack.png)

Prometheus gather metrics from exporters that must be running on the monitored hosts, stores them in it's own time series database, can display graphs of those series and trigger alerts. You can see it as a monitoring solution.

Grafana is a dashboard builder/display a lot of graphs for a lot of databases (including Prometheus one) and optionally send simple alerts too. It is fundamentally a visualization solution, it doesn't gather the metrics/feeds whatever db, not can generate complex alerts. But you can couple it with a lot of DBs (other time series databases, elasticsearch, MySQL and more) not just Prometheus. 
<br>

# Two link to get you started:
https://geekflare.com/prometheus-grafana-setup-for-linux/ <br>
https://www.fosslinux.com/10398/how-to-install-and-configure-prometheus-on-centos-7.htm <br>
Also, you can monitor many different types of metrics not just limited to node exporter, you can monitor network traffic, also sql query and such etc.
