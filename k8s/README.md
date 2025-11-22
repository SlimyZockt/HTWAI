# Kubernetes Deployment Guide

This directory contains Kubernetes manifests for deploying the application to a local kind cluster.

## Prerequisites

- Docker installed
- kubectl installed
- kind (Kubernetes in Docker) installed

## Setup Steps

1. **Create a kind cluster:**
   ```bash
   kind create cluster --name htwai
   ```

2. **Build Docker images:**
   ```bash
   # Build backend image
   docker build -t backend-api:latest ./backend
   
   # Build frontend image
   docker build -t frontend-api:latest ./frontend
   ```

3. **Load images into kind cluster:**
   ```bash
   kind load docker-image backend-api:latest --name htwai
   kind load docker-image frontend-api:latest --name htwai
   ```

4. **Create secret (optional, if API key is needed):**
   ```bash
   kubectl create secret generic api-secrets \
     --from-literal=openai-api-key=your-key-here
   ```
   Or apply the secret.yaml file and edit it:
   ```bash
   kubectl apply -f secret.yaml
   ```

5. **Deploy services:**
   ```bash
   kubectl apply -f backend-deployment.yaml
   kubectl apply -f backend-service.yaml
   kubectl apply -f frontend-deployment.yaml
   kubectl apply -f frontend-service.yaml
   ```

   Or apply all at once:
   ```bash
   kubectl apply -f .
   ```

6. **Verify deployment:**
   ```bash
   kubectl get deployments
   kubectl get services
   kubectl get pods
   ```

7. **Port forward to access services locally:**
   ```bash
   # Backend API on port 3000
   kubectl port-forward service/backend-api 3000:3000
   
   # Frontend API on port 8080
   kubectl port-forward service/frontend-api 8080:8080
   ```

## Services

- **backend-api**: AI API service running on port 3000
- **frontend-api**: Frontend API service running on port 8080

Both services are exposed as ClusterIP services. Use port-forwarding to access them locally.

