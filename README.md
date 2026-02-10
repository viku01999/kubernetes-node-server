# Kubernetes Cluster Networking Diagram

## Multiple NodePorts, Services, Pods, and Nodes

```mermaid
graph TD
    %% ================= EXTERNAL CLIENTS =================
    ClientA[🌎 Client A<br/>IP: 203.0.113.10]
    ClientB[🌎 Client B<br/>IP: 203.0.113.11]

    %% ================= NODE 1 =================
    subgraph Node1[🖥 Node 1<br/>192.168.1.50]
        subgraph DevNS1[Namespace: dev]
            PodA[📦 Pod A<br/>IP:10.1.1.2<br/>Port:3000]
            PodB[📦 Pod B<br/>IP:10.1.1.3<br/>Port:3000]
        end
        subgraph QaNS1[Namespace: qa]
            PodC[📦 Pod C<br/>IP:10.1.1.4<br/>Port:3000]
        end
    end

    %% ================= NODE 2 =================
    subgraph Node2[🖥 Node 2<br/>192.168.1.51]
        subgraph DevNS2[Namespace: dev]
            PodD[📦 Pod D<br/>IP:10.1.1.5<br/>Port:3000]
        end
        subgraph QaNS2[Namespace: qa]
            PodE[📦 Pod E<br/>IP:10.1.1.6<br/>Port:3000]
        end
    end

    %% ================= SERVICES =================
    ServiceDev[🔗 Service Dev<br/>Selector: app=dev-app<br/>NodePort:32051]
    ServiceQA[🔗 Service QA<br/>Selector: app=qa-app<br/>NodePort:32052]

    %% ================= NODEPORT CONNECTIONS =================
    ClientA -->|HTTP:32051| ServiceDev
    ClientB -->|HTTP:32052| ServiceQA

    %% ================= SERVICE TO PODS =================
    ServiceDev --> PodA
    ServiceDev --> PodB
    ServiceDev --> PodD

    ServiceQA --> PodC
    ServiceQA --> PodE

    %% ================= INTERNAL POD COMMUNICATION =================
    PodA ---|Internal| PodB
    PodD ---|Internal| PodA
    PodC ---|Internal| PodE
