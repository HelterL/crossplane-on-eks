# Automatizando Implantações na AWS com EKS e Crossplane

Este repositório contém arquivos .tf (HCL) Terraform para provisionar um cluster Amazon Elastic Kubernetes Service (EKS) na AWS. Além disso, demonstra o uso do Crossplane para criar recursos na AWS, buckets S3, VPC e Instâncias EC2. Como também como pode ser utilizado o ArgoCD em conjunto com o crossplane.

## Pré-requisitos

- Conta na AWS
- Terraform instalado
- AWS CLI configurado
- Bucket para armazenar estado do terraform

## Como utilizar

Com o bucket criado e a AWS CLI configurado.

Siga os seguintes comandos para criar o cluster.

```bash
terraform plan --out plan.out
```

```bash
terraform apply plan.out
```

## Conexão com o cluster EKS

-- name é o nome do nosso cluster

```bash
aws eks --region us-east-1 update-kubeconfig --name clustername
```

Exibindo nós criados

```bash
kubectl get nodes
```

Exibindo pods do namespace kube-system

```bash
kubectl get pods -n kube-system
```

# instalar o crossplane no cluste EKS

## Instalando crossplane com helm chart

```bash
helm install crossplane \
--namespace crossplane-system \
--create-namespace crossplane-stable/crossplane
```

## Verificando pods

```bash
kubectl get pods -n crossplane-system
```

## Instalando providers S3 e EC2

```bash
kubectl apply -f crossplane/crossplane_providers/provider_s3.yaml
```

```bash
kubectl apply -f crossplane/crossplane_providers/provider_ec2.yaml
```

## Verificando providers

```bash
kubectl get providers
```

Eles devem ficar True

## Criar uma secret kubernetes para AWS

Para que os providers consigam criar recursos na AWS é necessário criar uma secret no kubernetes contendo as chaves da AWS.

```
[default]
aws_access_key_id = <sua_aws_access_key>
aws_secret_access_key = <sua_aws_secret_key>
```

Salve em um arquivo com o nome `aws-credentials.txt`

## Criando a secret kubernetes

```bash
kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt
```

## Criando um provider config para utilizar a secret

```bash
kubectl apply -f crossplane/crossplane_providers/provider_config.yaml
```

## Criando recursos na AWS

Agora com o crossplane configurado, podemos criar os recursos através do comando `kubectl create -f`.

O comando a seguir criar um bucket no S3 utilizando o arquivo yaml do crossplane.

```bash
kubectl apply -f crossplane/buckets_s3/devstackbucket-001/devstackbucket-001.yaml
```

Também podemos utilizar o ArgoCD para criar nossos recursos, para isso bastar instalar o ArgoCD no cluster e configurar para apontar para a pasta crossplane.
