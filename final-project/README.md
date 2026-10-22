# Финальный DevOps-проект

Java Spring Boot приложение, развёрнутое в Yandex Cloud с использованием Docker и Kubernetes.

## Технологии

- Java 21, Spring Boot, Maven
- Docker
- GitHub Actions, Jenkins
- Terraform
- Yandex Cloud
- K3s, Kubernetes, Helm, Traefik
- Prometheus, Grafana

## Структура проекта

- `app/` — код приложения и тесты
- `terraform/` — конфигурация инфраструктуры
- `k8s/base/` — манифесты приложения
- `k8s/monitoring/` — Prometheus и Grafana
- `helm/devops-demo/` — Helm chart приложения
- `Jenkinsfile` — Jenkins Pipeline
- `.github/workflows/` — GitHub Actions

## Сборка и тестирование

Требуется Java 21.

```bash
cd final-project/app
./mvnw -B clean verify
```

## Docker

Сборка образа приложения:

```bash
cd final-project/app
docker build -t devops-demo:0.1.0 .
```

## Terraform

Настройка переменных:

```bash
cd final-project/terraform
cp terraform.tfvars.example terraform.tfvars
```

Заполни `terraform.tfvars` параметрами своего облака и SSH-доступа. Terraform state хранится в Yandex Object Storage через S3-совместимый backend.

Проверка конфигурации и плана:

```bash
terraform init
terraform validate
terraform plan
```

Проверь план перед применением.

## Kubernetes

Основной манифест приложения находится в `k8s/base/app.yaml`.

Проверка ресурсов на сервере с K3s:

```bash
sudo k3s kubectl -n devops-demo get pods,svc,ingress
```

Публичный HTTP-трафик поступает через Traefik. Приложение использует порт `8080`, внутренние management endpoints — `8081`.

## Helm

Helm chart приложения находится в `helm/devops-demo/`.

Проверка chart и просмотр Kubernetes-манифестов:

```bash
helm lint final-project/helm/devops-demo

helm template devops-demo final-project/helm/devops-demo \
  --namespace devops-demo
```

Эти команды проверяют chart и генерируют манифесты без установки в кластер.

## Мониторинг

Prometheus собирает метрики приложения через Spring Boot Actuator. Grafana использует Prometheus как источник данных и содержит dashboard проекта.

Манифесты мониторинга находятся в `k8s/monitoring/`. Prometheus и Grafana доступны через внутренние Kubernetes-сервисы.

## Эндпоинты

- `/` — информация о приложении
- `/health` — проверка состояния
- `/actuator/health` — Spring Boot health
- `/actuator/prometheus` — метрики Prometheus

## Безопасность

Не добавляй в Git `terraform.tfvars`, Terraform state, планы Terraform, access keys и пароли. Доступ по SSH должен быть ограничен доверенным IP-адресом. Для публичного production-развёртывания настрой HTTPS.
