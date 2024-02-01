file_path = 'node_exporter_metrics.txt'  # Replace 'your_file.txt' with your file's path

patterns_to_count = [
    'node_cpu',
    'node_filesystem',
    'node_memory'
]

specific_metrics_to_count = [
    'node_exporter_build_info',
    'process_cpu_seconds_total',
    'process_resident_memory_bytes'
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

