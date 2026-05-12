# Dockerfile для mattermost/docs + GitHub Actions
FROM python:3.12-slim

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Установка pipenv
RUN pip install --no-cache-dir pipenv==2025.0.2

WORKDIR /docs

# Копирование файлов зависимостей (для кэширования слоёв)
COPY Pipfile Pipfile.lock ./

# Установка зависимостей
RUN pipenv install --dev --system --deploy

# Копирование исходного кода
COPY . .

# Инициализация подмодулей (если есть)
RUN git submodule update --init --recursive 2>/dev/null || true

# Команда по умолчанию
CMD ["gmake", "html"]
