file_path = 'kube-state-metrics-metrics.txt'  # Replace 'your_file.txt' with your file's path

patterns_to_count = [
    'kube_daemonset',
    'kube_job',
    'kube_node',
    'kube_replicaset',
    'kube_statefulset'
]

specific_metrics_to_count = [
    'kube_deployment_metadata_generation',
    'kube_deployment_spec_replicas',
    'kube_deployment_status_observed_generation',
    'kube_deployment_status_replicas_available',
    'kube_deployment_status_replicas_updated',
    'kube_horizontalpodautoscaler_spec_max_replicas',
    'kube_horizontalpodautoscaler_spec_min_replicas',
    'kube_horizontalpodautoscaler_status_current_replicas',
    'kube_horizontalpodautoscaler_status_desired_replicas',
    'kube_namespace_status_phase',
    'kube_persistentvolumeclaim_resource_requests_storage_bytes',
    'kube_pod_container_info',
    'kube_pod_container_resource_limits',
    'kube_pod_container_resource_requests',
    'kube_pod_container_status_restarts_total',
    'kube_pod_container_status_waiting_reason',
    'kube_pod_info',
    'kube_pod_owner',
    'kube_pod_start_time',
    'kube_pod_status_phase',
    'kube_pod_status_reason',
    'kube_resourcequota'
]

#file_path = 'path/to/your/file.txt'  # Replace 'path/to/your/file.txt' with your file's path

def count_metrics(file_path, patterns_to_count, specific_metrics_to_count):
    metric_counts = {pattern: 0 for pattern in patterns_to_count}
    specific_counts = {metric: 0 for metric in specific_metrics_to_count}

    with open(file_path, 'r') as file:
        lines = file.readlines()
        for line in lines:
            for pattern in patterns_to_count:
                if line.startswith(pattern):
                    metric_counts[pattern] += 1
            for metric in specific_metrics_to_count:
                if metric in line:
                    specific_counts[metric] += 1

    return metric_counts, specific_counts

pattern_counts, specific_counts = count_metrics(file_path, patterns_to_count, specific_metrics_to_count)
total_count = sum(pattern_counts.values()) + sum(specific_counts.values())

print("Metrics Starting with Patterns:")
for pattern, count in pattern_counts.items():
    print(f"{pattern}: {count}")

print("\nSpecific Metrics:")
for metric, count in specific_counts.items():
    print(f"{metric}: {count}")

print(f"\nTotal Count: {total_count}")

