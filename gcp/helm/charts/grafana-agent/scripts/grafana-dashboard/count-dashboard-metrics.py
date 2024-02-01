import json
import yaml
import re

# Paths of /metric scrapes for full list of metrics referances
node_exporter_metrics_path = 'resources/application-metrics-dictionary/node-exporter-metrics.txt'
kube_state_metrics_metrics_path = 'resources/application-metrics-dictionary/kube-state-metrics-metrics.txt'
kubelet_metrics_path = 'resources/application-metrics-dictionary/kubelet-metrics.txt'
cadvisor_metrics_path = "resources/application-metrics-dictionary/cadvisor-metrics.txt"
jmx_exporter_metrics_path = "resources/application-metrics-dictionary/jmx-exporter-metrics.txt"

# Dashboards list to compare against
dashboard_paths = ['dashboards/space-level-dashboard.json', 'dashboards/site-level-dashboard.json', 'dashboards/tenant-namespace-level.json']

# List of additonal Metrics you would like to add as well
additonal_metrics = ['kube_namespace_labels',]

sample_drop_metrics_in_podmonitor = '''
metricRelabelings:
  - action: drop
    regex: ^(metric1|metrics2)$
    sourceLabels:
      - __name__
'''
# Parse existing YAML
sample_drop_metrics_in_podmonitor_yaml = yaml.safe_load(sample_drop_metrics_in_podmonitor)

def extract_metrics_from_file(file_path):
    metrics = []
    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('# TYPE'):
                metric_name = line.split(' ')[2]
                metrics.append(metric_name)
    return metrics

def extract_metrics_from_query(query):
    # Regular expression to extract metric names
    regex = r'([a-zA-Z0-9_]+)\{[^}]+\}'
    matches = re.findall(regex, query)

    return list(matches)

def extract_queries_from_dashboard(dashboard_json):
    with open(dashboard_json, 'r') as file:
        dashboard_data = json.load(file)
        
        metrics = set()
        
        # Check if the JSON contains panels
        if 'panels' in dashboard_data:
            for panel in dashboard_data['panels']:
                # Assuming metrics are in the targets field of each panel
                if 'targets' in panel:
                    for target in panel['targets']:
                        if 'expr' in target:
                            metrics.add(target['expr'])
        
        return list(metrics)

def find_metrics_in_quries(metrics):

    all_metrics = []

    for metric in metrics:
        # Extracting metrics from the query
        extracted_metrics = extract_metrics_from_query(metric)

        for sanitized_metric in extracted_metrics:
            all_metrics.append(sanitized_metric)
    
    return all_metrics




    # Extract all quries from a selected dashboard
    # Then Extracting all metrics from all extracted quries (dashboard related)
    # Then Extract the uniq ones (so not to have duplicates)

unique_dashboard_metrics = []

for dashboard_path in dashboard_paths:
    dashboard_queries = extract_queries_from_dashboard(dashboard_path)
    dashboard_metrics = find_metrics_in_quries(dashboard_queries)
    unique_metrics = list(set(dashboard_metrics))
    unique_dashboard_metrics.extend(unique_metrics)
    print("\nAll uniq metrics in Selected Dashboard '"+dashboard_path+"' ("+str(len(unique_metrics))+") : ")
    # print(unique_metrics)

# cleaning up again in-case of duplicated in between dashboards
unique_dashboard_metrics = list(set(unique_dashboard_metrics))
unique_dashboard_metrics = unique_dashboard_metrics + additonal_metrics
print("All Uniq metrics (without duplicates) from dashboard " + str(len(unique_dashboard_metrics)))


    # Extracting all Metrics from kube-state-metrics

kube_state_metrics_metrics = extract_metrics_from_file(kube_state_metrics_metrics_path)
print("\nall kube-state-metrics metrics ("+str(len(kube_state_metrics_metrics))+") ")
# print(kube_state_metrics_metrics)

    # Extracting all Metrics from node-exporter

node_exporter_metrics = extract_metrics_from_file(node_exporter_metrics_path)
print("all Node Exporter metrics ("+str(len(node_exporter_metrics))+") ")
# print(node_exporter_metrics)

    # Extracting all Metrics from kubelet-metrics

kubelet_metrics = extract_metrics_from_file(kubelet_metrics_path)
print("all kubelet metrics ("+str(len(kubelet_metrics))+") ")
# print(kubelet_metrics)

    # Extracting all Metrics from cadvisor-metrics

cadvisor_metrics = extract_metrics_from_file(cadvisor_metrics_path)
print("all cadvisor metrics ("+str(len(cadvisor_metrics))+") ")
# print(cadvisor_metrics)


    # Extracting all Metrics from jmx-exporter-metrics

jmx_exporter_metrics = extract_metrics_from_file(jmx_exporter_metrics_path)
print("all jmx-exporter metrics ("+str(len(jmx_exporter_metrics))+") ")
# print(jmx_exporter_metrics)


    # Finding metrics from dashboard in kube-state-metrics / node exporter

common_kube_state_metrics = list(set(unique_dashboard_metrics).intersection(set(kube_state_metrics_metrics)))
print("\ndashboard metrics from kube-state-metrics ("+str(len(common_kube_state_metrics))+") :")
print(common_kube_state_metrics)
print("----------")
print("allowList:")
for item in common_kube_state_metrics:
    print(f"- {item}")
print("\n")

common_node_exporter_metrics = list(set(unique_dashboard_metrics).intersection(set(node_exporter_metrics)))
print("\ndashboard metrics from node exporter ("+str(len(common_node_exporter_metrics))+") :")
print(common_node_exporter_metrics)
print("----------")
print("allowList:")
for item in common_node_exporter_metrics:
    print(f"- {item}")
print("\n")

common_kubelet_metrics = list(set(unique_dashboard_metrics).intersection(set(kubelet_metrics)))
print("\ndashboard metrics from kubelet ("+str(len(common_kubelet_metrics))+") :")
print(common_kubelet_metrics)
print("----------")
print("allowList:")
for item in common_kubelet_metrics:
    print(f"- {item}")
print("\n")

common_cadvisor_metrics = list(set(unique_dashboard_metrics).intersection(set(cadvisor_metrics)))
print("\ndashboard metrics from cadvisor ("+str(len(common_cadvisor_metrics))+") :")
print(common_cadvisor_metrics)
print("----------")
print("allowList:")
for item in common_cadvisor_metrics:
    print(f"- {item}")
print("\n")

common_jmx_exporter_metrics = list(set(unique_dashboard_metrics).intersection(set(jmx_exporter_metrics)))
print("\ndashboard metrics from jmx exporter ("+str(len(common_jmx_exporter_metrics))+") :")
print(common_jmx_exporter_metrics)
metrics_to_drop = list(set(jmx_exporter_metrics) - set(common_jmx_exporter_metrics))
# Update regex pattern in the YAML configuration with metrics list
sample_drop_metrics_in_podmonitor_yaml['metricRelabelings'][0]['regex'] = f"^({'|'.join(metrics_to_drop)})$"
print("----------")
print(yaml.dump(sample_drop_metrics_in_podmonitor_yaml, default_flow_style=False))
print("\n")


    # Metrics in dashboard still not found in kube-state-metrics / node exporter

all_found_metrics = common_kube_state_metrics + common_node_exporter_metrics + common_kubelet_metrics + common_cadvisor_metrics + jmx_exporter_metrics
missing_metrics = list(set(unique_dashboard_metrics) - set(all_found_metrics))
print("\nmetrics still not found ("+str(len(missing_metrics))+") :")
print(missing_metrics)
