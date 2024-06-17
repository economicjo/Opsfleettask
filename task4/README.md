# GPU Slicing on EKS

This document explains how to enable GPU Slicing on EKS clusters to optimize GPU usage.

## Prerequisites

1. Install the NVIDIA device plugin:

```sh
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.9.0/nvidia-device-plugin.yml
