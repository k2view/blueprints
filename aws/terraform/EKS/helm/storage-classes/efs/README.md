# EFS Storage Class Helm Chart
===========

A Helm chart of EFS storage class for EKS K2view site


## Configuration

The following table lists the configurable parameters of the Storage-classes chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `efs_id` | EFS ID | `""` |
| `sc-name` | Storage class name | `"sc-fabric"` |
| `permissions` | Directory permissions | `"700"` |
| `gidRangeStart` | gid range start value | `"1000"` |
| `gidRangeEnd` | gid range end value | `"2000"` |
| `uid` | UID value | `"1000"` |

