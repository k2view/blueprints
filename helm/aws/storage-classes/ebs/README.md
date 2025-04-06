# EBS Storage Class Helm Chart
===========

A Helm chart of EBS storage class for EKS K2view site


## Configuration

The following table lists the configurable parameters of the Storage-classes chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `encrypted` | Flag to enable or disable encrypted storage class | `true` |
| `gp3-default-class` | Flag to enable or disabel gp3 as a default storage class | `true` |
| `volume-binding-mode` | Volume binding mode | `"Immediate"` |