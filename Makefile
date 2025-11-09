# Makefile для управления проектом Ollama + Qdrant
# Автоматизированные команды для удобной работы с сервисами

.PHONY: help up down restart logs status setup pull-models clean clean-volumes urls

# Основные команды управления сервисами

## Запуск сервисов в фоне
up:
	@echo "Запуск сервисов Ollama и Qdrant..."
	docker-compose up -d

## Остановка сервисов
down:
	@echo "Остановка сервисов..."
	docker-compose down

## Перезапуск сервисов
restart: down up
	@echo "Сервисы перезапущены"

## Просмотр логов всех сервисов
logs:
	@echo "Просмотр логов сервисов..."
	docker-compose logs -f

## Статус сервисов
status:
	@echo "Статус контейнеров:"
	docker-compose ps

# Команды для работы с моделями Ollama

## Полная настройка проекта (запуск сервисов + загрузка моделей)
setup:
	@echo "Запуск полной настройки проекта..."
	@echo "Запуск сервисов Ollama и Qdrant..."
	docker-compose up -d
	@echo "Ожидание запуска Ollama..."
	sleep 10
	@echo "Загрузка моделей в Ollama..."
	@echo "Загрузка модели embeddinggemma:300m..."
	curl -X POST http://localhost:11434/api/pull -d '{"name": "embeddinggemma:300m"}'
	@echo ""
	@echo "Загрузка модели qwen2.5-coder:7b..."
	curl -X POST http://localhost:11434/api/pull -d '{"name": "qwen2.5-coder:7b"}'
	@echo ""
	@echo "Настройка завершена!"
	@echo "Ollama доступен на: http://localhost:11434"
	@echo "Qdrant доступен на: http://localhost:6333"

## Загрузка моделей в Ollama
pull-models:
	@echo "Загрузка моделей в Ollama..."
	@echo "Загрузка модели embeddinggemma:300m..."
	curl -X POST http://localhost:11434/api/pull -d '{"name": "embeddinggemma:300m"}'
	@echo ""
	@echo "Загрузка модели qwen2.5-coder:7b..."
	curl -X POST http://localhost:11434/api/pull -d '{"name": "qwen2.5-coder:7b"}'
	@echo ""
	@echo "Загрузка моделей завершена!"

# Команды очистки

## Остановка и удаление контейнеров
clean: down
	@echo "Контейнеры остановлены и удалены"

## Полная очистка с удалением томов (данные будут потеряны!)
clean-volumes:
	@echo "ВНИМАНИЕ: Полная очистка с удалением томов!"
	@echo "Все данные моделей и векторной базы будут удалены!"
	docker-compose down -v
	@echo "Тома удалены"

# Информационные команды

## Вывод URL для доступа к сервисам
urls:
	@echo "=== URL для доступа к сервисам ==="
	@echo "Ollama API:     http://localhost:11434"
	@echo "Ollama UI:      http://localhost:11434 (если доступен)"
	@echo "Qdrant HTTP:    http://localhost:6333"
	@echo "Qdrant gRPC:    http://localhost:6334"
	@echo "Qdrant Dashboard: http://localhost:6333/dashboard"
	@echo "================================"

## Справка по всем командам
help:
	@echo "=== Makefile для проекта Ollama + Qdrant ==="
	@echo ""
	@echo "Основные команды управления сервисами:"
	@echo "  make up        - Запуск сервисов в фоне"
	@echo "  make down      - Остановка сервисов"
	@echo "  make restart   - Перезапуск сервисов"
	@echo "  make logs      - Просмотр логов сервисов"
	@echo "  make status    - Статус сервисов"
	@echo ""
	@echo "Команды для работы с моделями Ollama:"
	@echo "  make setup     - Полная настройка проекта"
	@echo "  make pull-models - Загрузка моделей в Ollama"
	@echo ""
	@echo "Команды очистки:"
	@echo "  make clean     - Остановка и удаление контейнеров"
	@echo "  make clean-volumes - Полная очистка с удалением томов"
	@echo ""
	@echo "Информационные команды:"
	@echo "  make urls      - Вывод URL для доступа к сервисам"
	@echo "  make help      - Эта справка"
	@echo ""
	@echo "Пример использования:"
	@echo "  make setup     # Полная настройка проекта"
	@echo "  make logs      # Просмотр логов работающих сервисов"
	@echo ""

# Команда по умолчанию
default: help