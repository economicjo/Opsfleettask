#!/bin/bash

ISTIO_VERSION="1.13.2"
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

cd istio-$ISTIO_VERSION
export PATH=$PWD/bin:$PATH

istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled