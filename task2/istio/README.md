# Istio Installation and Mutual TLS POC

This POC demonstrates how to install Istio and configure mutual TLS between services running on an EKS cluster.

## Installation

1. Run the `install-istio.sh` script to install Istio and enable sidecar injection.

```sh
./install-istio.sh