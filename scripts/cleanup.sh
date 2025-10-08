#!/usr/bin/env bash
set -e
kind delete cluster --name pvcsec || true
